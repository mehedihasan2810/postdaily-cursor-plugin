# Changelog

All notable changes to this plugin are documented here.

## 1.1.0

- Requires Cursor 3.13.0 or later (`minClientVersions`).
- The README covers installing from the marketplace, what the plugin runs and
  what it sends.
- Settings paths name Cursor's **Customize** page (Browse Marketplace, MCPs).
- `local-media`: the agent writes the upload command itself from the URL and
  headers PostDaily returns.
- `release-posts`: works from pasted release notes when there is no
  repository, and writes for Facebook instead of LinkedIn.
- LinkedIn removed from the supported networks.
- Opaque square logo.

## 1.0.0 — initial release

- PostDaily's remote MCP server (`https://mcp.postdaily.app/mcp`, OAuth).
- Skills: `posting`, `local-media` and `release-posts`.
- A `beforeMCPExecution` hook that asks before PostDaily publishes now,
  retries, deletes, cancels or schedules a batch.
