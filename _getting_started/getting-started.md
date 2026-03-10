---
title: Getting Started
nav_order: 2
description: Install and run Jekyll VitePress Theme in a few minutes.
---

Install the theme gem and enable it as both `theme` and plugin.

## 1. Add the gem

```ruby
gem "jekyll-vitepress-theme"
```
{: data-title="Gemfile"}

Then install:

```sh
bundle install
```

## 2. Enable theme and plugin

```yaml
theme: jekyll-vitepress-theme
plugins:
  - jekyll-vitepress-theme
```
{: data-title="_config.yml"}

## 3. Configure navigation

```yaml
vp_theme:
  nav:
    - text: Guide
      link: /what-is-jekyll-vitepress-theme/
      collections: [getting_started, core_features, advanced]
    - text: Reference
      link: /configuration-reference/
      collections: [reference]

  sidebar_collections:
    - id: getting_started
      text: Introduction
    - id: core_features
      text: Core Features
    - id: advanced
      text: Advanced
    - id: reference
      text: Reference
```
{: data-title="_config.yml"}

## 4. Run locally

```sh
bundle exec jekyll serve --livereload
```

Open `http://127.0.0.1:4000`.

<div class="tip custom-block">
  <p class="custom-block-title">TIP</p>
  <p>Set <code>layout: home</code> on your home page front matter to render the VitePress-style hero/features home without sidebar.</p>
</div>
