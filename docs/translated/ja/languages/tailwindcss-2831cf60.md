# Tailwind CSS

Zed には Tailwind CSS の補完、リント、およびホバープレビューのサポートが組み込まれています。

- 言語サーバー: [tailwindlabs/tailwindcss-intellisense](https://github.com/tailwindlabs/tailwindcss-intellisense)

Zed で Tailwind CSS と併用できる言語:

- [Astro](./astro.md#using-the-tailwind-css-language-server-with-astro)
- [CSS](./css.md)
- [ERB](./ruby.md#using-the-tailwind-css-language-server-with-ruby)
- [Gleam](./gleam.md)
- [HEEx](./elixir.md#using-the-tailwind-css-language-server-with-heex-templates)
- [HTML](./html.md#using-the-tailwind-css-language-server-with-html)
- [TypeScript](./typescript.md#using-the-tailwind-css-language-server-with-typescript)
- [JavaScript](./javascript.md#using-the-tailwind-css-language-server-with-javascript)
- [PHP](./php.md#using-the-tailwind-css-language-server-with-php)
- [Svelte](./svelte.md#using-the-tailwind-css-language-server-with-svelte)
- [Vue](./vue.md#using-the-tailwind-css-language-server-with-vue)

## 設定

デフォルトの言語サーバー設定では特定の言語で Tailwind が十分に動作しない場合、言語サーバーの設定を行い、それらを `settings.json` の `lsp` セクションに追加できます:

```json [settings]
{
  "lsp": {
    "tailwindcss-language-server": {
      "settings": {
        "classFunctions": ["cva", "cx"],
        "experimental": {
          "classRegex": ["[cls|className]\\s\\:\\=\\s\"([^\"]*)"]
        }
      }
    }
  }
}
```

詳しくは、[the Tailwind CSS language server settings docs](https://github.com/tailwindlabs/tailwindcss-intellisense?tab=readme-ov-file#extension-settings) を参照してください。

### CSS ファイルで Tailwind CSS モードを使用する

Zed には Tailwind CSS 言語モードのサポートが含まれており、`@apply`、`@layer`、`@theme` などの Tailwind 固有の at ルールを使用している場合でも、CSS の IntelliSense を完全に利用できます。
Settings ({#kb zed::OpenSettings}) の Languages > CSS で言語サーバーを設定するか、設定ファイルに次を追加します:

```json [settings]
{
  "languages": {
    "CSS": {
      "language_servers": [
        "tailwindcss-intellisense-css",
        "!vscode-css-language-server",
        "..."
      ]
    }
  }
}
```

`tailwindcss-intellisense-css` 言語サーバーは、デフォルトの CSS 言語サーバーの代替として機能し、標準的な CSS IntelliSense の機能をすべて維持しつつ、Tailwind 固有の構文のサポートを追加します。

### Prettier プラグイン

Zed は標準で Prettier をサポートしているため、[Tailwind CSS Prettier plugin](https://github.com/tailwindlabs/prettier-plugin-tailwindcss) をインストールしている場合は、Prettier の設定にこのプラグインを追加するだけで自動的に機能します:

```json
// .prettierrc
{
  "plugins": ["prettier-plugin-tailwindcss"]
}
```
