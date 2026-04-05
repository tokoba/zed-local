# Astro

Astro のサポートは [Astro extension](https://github.com/zed-extensions/astro) を通じて利用できます。

- Tree-sitter: [virchau13/tree-sitter-astro](https://github.com/virchau13/tree-sitter-astro)
- Language Server: [withastro/language-tools](https://github.com/withastro/astro/tree/main/packages/language-tools/language-server)

## Using the Tailwind CSS Language Server with Astro

Astro ファイルで [Tailwind CSS language server](https://github.com/tailwindlabs/tailwindcss-intellisense/tree/HEAD/packages/tailwindcss-language-server#readme) のすべての機能（補完、Lint など）を利用するには、CSS クラスをどこで探せばよいかを認識できるように言語サーバーを設定する必要があります。これを行うには、`settings.json` に次の設定を追加します:

```json [settings]
{
  "lsp": {
    "tailwindcss-language-server": {
      "settings": {
        "includeLanguages": {
          "astro": "html"
        },
        "experimental": {
          "classRegex": [
            "class=\"([^\"]*)\"",
            "class='([^']*)'",
            "class:list=\"{([^}]*)}\"",
            "class:list='{([^}]*)}'"
          ]
        }
      }
    }
  }
}
```

これらの設定により、Astro テンプレートファイル内で Tailwind CSS クラスの補完が利用できるようになります。例:

```astro
---
const active = true;
---

<!-- 標準的な class 属性 -->
<div class="flex items-center <completion here>">
  <p class="text-lg font-bold <completion here>">こんにちは、世界</p>
</div>

<!-- class:list ディレクティブ -->
<div class:list={["flex", "items-center", "<completion here>"]}>
  コンテンツ
</div>

<!-- 条件付きクラス -->
<div class:list={{ "flex <completion here>": active, "hidden <completion here>": !active }}>
  コンテンツ
</div>
```
