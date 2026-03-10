---
title: Code Blocks
nav_order: 2
description: Copy buttons, language labels, syntax palettes, and file-title icons.
---

Code blocks support VitePress-style enhancements:

- copy button
- language label
- optional title bar via `data-title`
- file-type icon in title bar inferred from file extension/language

Syntax colors come from Rouge themes configured in `_config.yml`:

```yaml
vp_theme:
  rouge_theme:
    light: github
    dark: github.dark
```
{: data-title="_config.yml"}

## Titled block example

```ruby
class WeatherTool
  def call(city:)
    "sunny in #{city}"
  end
end
```
{: data-title="app/tools/weather_tool.rb"}

```ts
export function formatDate(input: string): string {
  return new Date(input).toISOString()
}
```
{: data-title="src/utils/date.ts"}

`light` and `dark` accept any installed Rouge theme name.
