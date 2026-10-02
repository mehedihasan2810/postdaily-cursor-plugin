# PostDaily for Cursor

Draft, schedule and publish social media posts from Cursor with
[PostDaily](https://www.postdaily.app) — Instagram, Facebook, TikTok, YouTube,
X, Threads, Pinterest, Bluesky and Mastodon. Publishing a post immediately
always asks for your confirmation first.

You need a PostDaily account with at least one connected social channel.

The plugin is in [`plugins/postdaily`](./plugins/postdaily): its
[README](./plugins/postdaily/README.md) covers what it does, what it runs and
what it sends.

## Install

- **Cursor Marketplace**: open **Cursor Settings → Plugins**, search for
  PostDaily and select **Install**, or run `/add-plugin postdaily` in chat.
- **Team marketplace**: an admin can add
  `https://github.com/mehedihasan2810/postdaily-cursor-plugin` under
  **Dashboard → Plugins & MCPs → Add Marketplace → Import from Repo**.
- **Local**:

  ```bash
  git clone https://github.com/mehedihasan2810/postdaily-cursor-plugin.git
  cp -R postdaily-cursor-plugin/plugins/postdaily ~/.cursor/plugins/local/postdaily
  ```

  then run **Developer: Reload Window**.

Then open **Cursor Settings → Tools & MCPs** and connect **postdaily**.
PostDaily opens in your browser: pick the workspaces Cursor may use and what
it can do (Full access, Drafts only or Read only). Change or revoke it any
time in PostDaily under **Settings → AI agents**.

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
- [Privacy policy](https://www.postdaily.app/privacy)
- support@postdaily.app

## License

[MIT](./LICENSE)
