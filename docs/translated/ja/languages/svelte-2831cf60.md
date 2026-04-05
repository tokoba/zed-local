# Svelte

Svelte のサポートは [Svelte extension](https://github.com/zed-extensions/svelte) を通して利用できます。

- Tree-sitter: [tree-sitter-grammars/tree-sitter-svelte](https://github.com/tree-sitter-grammars/tree-sitter-svelte)
- Language Server: [sveltejs/language-tools](https://github.com/sveltejs/language-tools)

## テーマスタイルの追加設定

ディレクティブやモディファイアなどの特定のスタイルが属性内でどのように表示されるかを変更できます:

```json
"syntax": {
  // ディレクティブのスタイル設定（例: `class:foo` や `on:click`）（属性の `on` や `class` の部分）。
  "attribute.function": {
    "color": "#ff0000"
  },
  // 属性の末尾にあるモディファイア（例: `on:<click|preventDefault|stopPropagation>`）のスタイル設定
  "attribute.special": {
    "color": "#00ff00"
  }
}
```

## インレイヒント

Zed でインレイヒントを有効にすると、言語サーバーからインレイヒントが返されるように、Zed は次の初期化オプションを設定します:

```json
"inlayHints": {
  "parameterNames": {
    "enabled": "all",
    "suppressWhenArgumentMatchesName": false
  },
  "parameterTypes": {
    "enabled": true
  },
  "variableTypes": {
    "enabled": true,
    "suppressWhenTypeMatchesName": false
  },
  "propertyDeclarationTypes": {
    "enabled": true
  },
  "functionLikeReturnTypes": {
    "enabled": true
  },
  "enumMemberValues": {
    "enabled": true
  }
}
```

これらの設定を上書きするには、次のようにします:

```json [settings]
"lsp": {
  "svelte-language-server": {
    "initialization_options": {
      "configuration": {
        "typescript": {
          // ......
        },
        "javascript": {
          // ......
        }
      }
    }
  }
}
```

詳しくは、[TypeScript language server の `package.json`](https://github.com/microsoft/vscode/blob/main/extensions/typescript-language-features/package.json) を参照してください。

## Svelte で Tailwind CSS Language Server を使用する

Svelte ファイルで [Tailwind CSS language server](https://github.com/tailwindlabs/tailwindcss-intellisense/tree/HEAD/packages/tailwindcss-language-server#readme) のすべての機能（補完、Lint など）を利用するには、言語サーバーが CSS クラスをどこで探せばよいかを認識できるように、`settings.json` に次の設定を追加する必要があります:

```json [settings]
{
  "lsp": {
    "tailwindcss-language-server": {
      "settings": {
        "includeLanguages": {
          "svelte": "html"
        },
        "experimental": {
          "classRegex": [
            "class=\"([^\"]*)\"",
            "class='([^']*)'",
            "class:\\s*([^\\s{]+)",
            "\\{\\s*class:\\s*\"([^\"]*)\"",
            "\\{\\s*class:\\s*'([^']*)'"
          ]
        }
      }
    }
  }
}
```

これらの設定により、Svelte ファイル内で Tailwind CSS クラスの補完が利用できるようになります。例:

```svelte
<!-- 標準的な class 属性 -->
<div class="flex items-center <completion here>">
  <p class="text-lg font-bold <completion here>">こんにちは、世界</p>
</div>

<!-- class ディレクティブ -->
<button class:active="bg-blue-500 <completion here>">クリックしてください</button>

<!-- 式 -->
<div class={active ? "flex <completion here>" : "hidden <completion here>"}>
  コンテンツ
</div>
```
