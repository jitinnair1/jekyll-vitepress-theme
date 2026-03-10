---
title: Frontmatter Reference
nav_order: 2
description: Page-level frontmatter options used by the theme.
---

## Layouts

- `layout: default` for docs pages.
- `layout: home` for VitePress-style home pages.

## Home layout keys

```yaml
layout: home
hero:
  name: Project Name
  text: Project Tagline
  tagline: Supporting sentence
  image:
    src: /path/to/image.svg
    alt: Logo
  actions:
    - theme: brand
      text: Get Started
      link: /getting-started/
features:
  - icon: ⚡
    title: Fast
    details: Feature description
```
{: data-title="index.md"}

## Optional page keys

- `description`
- `nav_order`
- `last_updated_at` (manual override)
- `footer: false` (hide global footer)
- `doc_footer: false` (hide prev/next pager)
- `edit_link: false` (hide edit link for this page)
- `last_updated: false` (hide last updated for this page)
- `prev: false` / `next: false` (disable pager side)

## Custom prev / next links

You can override auto-computed pager links:

```yaml
prev:
  text: Custom previous title
  link: /some/page/
next:
  text: Custom next title
  link: /another/page/
```
{: data-title="example-page.md"}
