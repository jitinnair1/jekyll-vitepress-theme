---
title: Deployment
nav_order: 3
description: Build and deploy versioned docs with GitHub Pages on gh-pages.
---

This theme repository uses a branch-based versioned deployment flow:

1. Push to `main` publishes unreleased docs to `/next/`.
2. `main` also runs a release gate; if `lib/jekyll/vitepress_theme/version.rb` is not published on RubyGems, it runs the release workflow.
3. A release publish writes immutable docs to `/v/x.y.z/` and refreshes `/latest/`.
4. A shared `versions.yml` manifest drives the version selector.

This keeps old versions intact while always exposing both preview (`next`) and stable (`latest`) docs.

In repository settings, configure GitHub Pages to serve from branch `gh-pages` (root).
