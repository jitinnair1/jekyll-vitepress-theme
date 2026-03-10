---
title: Customizing Styles
nav_order: 1
description: Override tokens, fonts, and appearance behavior.
---

Use `vp_theme.css_vars.light` and `vp_theme.css_vars.dark` to override VitePress token variables.

```yaml
vp_theme:
  css_vars:
    light:
      --vp-c-brand-1: "#3451b2"
      --vp-c-brand-2: "#3a5ccc"
    dark:
      --vp-c-brand-1: "#a8b1ff"
      --vp-c-brand-2: "#bac2ff"
```
{: data-title="_config.yml"}

Font stacks are controlled with:

- `vp_theme.font_family_base`
- `vp_theme.font_family_mono`

Appearance mode defaults to system preference and can be overridden by user toggle.
