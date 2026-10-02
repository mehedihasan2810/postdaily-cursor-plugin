# PostDaily

Cursor plugin that drafts, schedules and publishes social media posts with
[PostDaily](https://www.postdaily.app) — Instagram, Facebook, TikTok, YouTube,
X, Threads, Pinterest, Bluesky and Mastodon. Ask in plain words, check a post
against each network's limits before it is saved, attach images and videos
from your machine, and turn a release into posts. Publishing a post
immediately always asks for your confirmation first.

You need a PostDaily account with at least one connected social channel.

## Install and connect

1. Open **Cursor Settings → Customize**, select **Browse Marketplace**,
   search for **PostDaily** and select **Install**. Or run
   `/add-plugin postdaily` in chat.
2. In **Cursor Settings → Customize → MCPs**, select **Authenticate** next to
   **postdaily**.
3. PostDaily opens in your browser: sign in, pick the workspaces Cursor may
   use and what it can do (Full access, Drafts only or Read only).

Change or revoke the connection any time in PostDaily under
**Settings → AI agents**. To sign out in Cursor, open **postdaily** under
**Customize → MCPs** and select **Logout**.

## What you get

- **PostDaily's MCP server** (`https://mcp.postdaily.app/mcp`): up to 20 tools
  for channels, posts, the queue, media and analytics, and prompts such as
  planning a week of posts. Auth is OAuth; there is no API key to configure.
- **Skills**
  - `posting`: drafts by default, one text per network, a check before
    saving, and a clear yes before anything goes out now.
  - `local-media`: attach an image, video or PDF from your machine.
  - `release-posts`: turn release notes, or a repository's recent changes,
    into per-network drafts announcing a release.
- **A confirmation hook** (`beforeMCPExecution`): Cursor asks you before a
  PostDaily call publishes immediately, retries a failed post, deletes or
  cancels a post, or schedules a batch. Drafts, reads and a single scheduled
  post follow your usual Cursor settings, and other MCP servers are never
  touched.

## What this plugin runs and sends

- **MCP server:** the only network destination is PostDaily's own server,
  `https://mcp.postdaily.app/mcp`, reached after you sign in with OAuth. It
  receives the requests the agent makes with PostDaily's tools and nothing
  else.
- **Hook:** `hooks/confirm-publish.sh` runs on your computer before MCP tool
  calls. It reads the tool name and arguments it is given, prints a
  permission decision for PostDaily's tools only, and sends nothing anywhere.
  It uses only `sh`, `sed` and `grep`.
- **Skills:** instructions only. The `local-media` skill asks the agent to read
  a file's size and type (`wc`, `file`) and upload it with `curl` to the
  one-time URL PostDaily returns. `release-posts` reads the repository with
  `git` and, when installed, `gh`, or works from release notes you paste.
  Cursor asks before running commands under your usual settings.
- No telemetry, no credentials stored by the plugin, no other downloads.

## Notes

- **Publishing is live to real social accounts.** A post published now, or a
  scheduled post when its time comes, goes out on the network. Deleting a
  published post in PostDaily does not remove it from the network.
- Drafts stay in PostDaily until you schedule or publish them there or ask
  the agent to.

## Try it

- "What's scheduled on my channels this week?"
- "Draft a post for Bluesky and Threads about the new export feature."
- "Announce the v2.3 release."
- "Attach this screenshot and schedule it for tomorrow at 9am."

## Help and privacy

- [Connecting AI apps to PostDaily](https://www.postdaily.app/help/connect-ai-apps)
- [Privacy policy](https://www.postdaily.app/privacy) (section 6 covers AI
  apps you connect)
- support@postdaily.app

## License

[MIT](./LICENSE)
