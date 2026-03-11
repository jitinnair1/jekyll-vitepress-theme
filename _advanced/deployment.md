---
title: Deployment
nav_order: 3
description: Deploy a single docs site by default, with optional multi-version mode.
---

## Default (recommended): single docs site

This repository deploys one canonical docs site at `/` from `main`.

The docs workflow:

1. Builds Jekyll once at the repository base path.
2. Publishes the build to `gh-pages` root.
3. Maintains compatibility redirects from `/latest/` and `/v/0.9.0/` back to `/`.

This keeps CI and maintenance simple while preserving old links.

## Optional: multi-version docs

If your project needs versioned docs (`/next/`, `/latest/`, `/v/x.y.z/`), this theme includes an advanced pattern:

- `scripts/version_manifest.rb` to generate `/_data/versions.yml`
- `scripts/publish_gh_pages.sh` modes:
  - `next`
  - `release`

When `/_data/versions.yml` is present, it overrides `vp_theme.version` in nav.

Use this mode only when you need immutable version snapshots. It adds operational complexity and more edge cases (caching, legacy paths, rebuilds).

In repository settings, configure GitHub Pages to serve from branch `gh-pages` (root).
