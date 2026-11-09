#!/bin/sh
# beforeMCPExecution hook: make Cursor ask the person before a PostDaily call
# that publishes immediately, removes a post, schedules many posts at once, or
# writes into one workspace after the agent worked in another
# (confirmCrossWorkspace).
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

# confirmCrossWorkspace set to true, matched the same way. The server refuses a
# write into one covered workspace soon after the agent worked in another until
# the call carries it; text another member wrote in one workspace could have
# asked for the copy (docs/mcp/SECURITY.md, T19). Only write tools take it.
crosses_workspaces() {
  printf '%s' "$input" |
    grep -Eq '\\?"confirmCrossWorkspace\\?"[[:space:]]*:[[:space:]]*true'
}

if crosses_workspaces; then
  reason="PostDaily: write into this workspace? The agent also worked in another of your workspaces just now, and their members can differ. Allow only if you asked for content to move between them."
  if publishes_now; then
    reason="$reason It also publishes immediately."
  fi
  printf '{"permission":"ask","user_message":"%s","agent_message":"The user was asked to approve this PostDaily call."}\n' "$reason"
  exit 0
fi

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
