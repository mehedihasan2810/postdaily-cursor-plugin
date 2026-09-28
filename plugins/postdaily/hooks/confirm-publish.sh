#!/bin/sh
# beforeMCPExecution hook: make Cursor ask the person before a PostDaily call
# that publishes immediately, removes a post, or schedules many posts at once.
# Anything else — other servers, drafts, reads, one scheduled post — gets `{}`,
# which leaves Cursor's own approval settings in charge.
#
# Cursor's MCP hook input differs from Claude Code's: `tool_name` may carry a
# prefix ("MCP:create_post") and `tool_input` is a JSON-encoded string, so a
# field inside it appears as \"confirmPublish\":true. Plain sh + sed + grep so
# it runs wherever Cursor does, with no jq, Node or Python.

input=$(cat)

field() {
  printf '%s' "$input" |
    sed -n "s/.*\"$1\"[[:space:]]*:[[:space:]]*\"\\([^\"]*\\)\".*/\\1/p" |
    head -n 1
}

pass() {
  printf '{}\n'
  exit 0
}

# Only PostDaily's server, whatever name Cursor gives it.
case "$(field mcp_server_name) $(field url) $(field mcp_server_url)" in
  *postdaily*) ;;
  *) pass ;;
esac

# confirmPublish set to true, in an object or a JSON-encoded string. Text that
# merely mentions it inside the post is escaped one level deeper and does not
# match.
publishes_now() {
  printf '%s' "$input" |
    grep -Eq '\\?"confirmPublish\\?"[[:space:]]*:[[:space:]]*true'
}

case "$(field tool_name)" in
  *delete_post)
    reason="PostDaily: delete this post from PostDaily? A scheduled post is canceled; a published one stays live on the network."
    ;;
  *cancel_post)
    reason="PostDaily: cancel this scheduled post? It will not publish, and stays in PostDaily as canceled."
    ;;
  *bulk_create_posts)
    reason="PostDaily: schedule this batch of posts? Each one publishes at its time or the next free queue slot."
    ;;
  *create_post | *schedule_post | *retry_post)
    if publishes_now; then
      reason="PostDaily: publish this now? It goes out to the selected channels immediately."
    else
      pass
    fi
    ;;
  *)
    pass
    ;;
esac

printf '{"permission":"ask","user_message":"%s","agent_message":"The user was asked to approve this PostDaily call."}\n' "$reason"
