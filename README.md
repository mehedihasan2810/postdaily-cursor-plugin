# PostDaily for Cursor

Draft, schedule and publish social media posts from Cursor with
[PostDaily](https://www.postdaily.app) — Instagram, Facebook, TikTok, YouTube,
LinkedIn, X, Threads, Pinterest, Bluesky and Mastodon.

You need a PostDaily account — every plan includes AI agent access.

## Install

- **Cursor Marketplace**: open **Customize**, search for PostDaily and select
  **Install** (once the listing is live).
- **Team marketplace**: an admin can add
  `https://github.com/mehedihasan2810/postdaily-cursor-plugin` under
  **Dashboard → Plugins & MCPs → Add Marketplace → Import from Repo**.
- **Local**:

  ```bash
  git clone https://github.com/mehedihasan2810/postdaily-cursor-plugin.git
  cp -R postdaily-cursor-plugin/plugins/postdaily ~/.cursor/plugins/local/postdaily
  ```

  then run **Developer: Reload Window**.

Then open **Cursor Settings → MCP** and select **Connect** next to postdaily.
PostDaily opens in your browser: pick the workspaces Cursor may use and what
it can do (Full access, Drafts only or Read only). Change or revoke it any
time in PostDaily under **Settings → AI agents**.

## What you get

- **PostDaily's MCP server** (`https://mcp.postdaily.app/mcp`): up to 20 tools
  for channels, posts, the queue, media and analytics, plus prompts such as
  planning a week of posts.
- **Skills**: `posting` (drafts by default, one text per network, validation,
  a clear yes before publishing now), `local-media` (upload an image, video
  or PDF from your machine) and `release-posts` (turn a repository's recent
  changes into per-network drafts).
- **A confirmation hook** (`beforeMCPExecution`): Cursor asks you before a
  PostDaily call publishes immediately, retries a failed post, deletes or
  cancels a post, or schedules a batch. Drafts, reads and a single scheduled
  post follow your usual Cursor settings, and other MCP servers are never
  touched.

## Development

This repository is a Cursor plugin marketplace
(`.cursor-plugin/marketplace.json`) with one plugin,
[`plugins/postdaily`](./plugins/postdaily). It is published from PostDaily's
main codebase, where the plugin is kept in step with the MCP server it wraps.

Check it with the validator from
[cursor/plugins](https://github.com/cursor/plugins) (`schemas/` and
`scripts/validate-plugins.mjs`, run from a copy of this folder). The hook is
plain `sh`; feed it an event to see its decision:

```bash
printf '%s' '{"tool_name":"MCP:create_post","tool_input":"{\"mode\":\"now\",\"confirmPublish\":true}","mcp_server_name":"postdaily","url":"https://mcp.postdaily.app/mcp"}' \
  | sh plugins/postdaily/hooks/confirm-publish.sh
```

It prints `"permission":"ask"` for publish-now, retries, deletes, cancels and
batches, and `{}` (no opinion) for everything else.

## Help

- [Connecting AI apps to PostDaily](https://www.postdaily.app/help/connect-ai-apps)
- support@postdaily.app

## License

[MIT](./LICENSE)
