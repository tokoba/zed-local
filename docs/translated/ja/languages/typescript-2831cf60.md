# TypeScript

Zed では TypeScript と TSX をネイティブにサポートしています。

- Tree-sitter: [tree-sitter/tree-sitter-typescript](https://github.com/tree-sitter/tree-sitter-typescript)
- 言語サーバー: [yioneko/vtsls](https://github.com/yioneko/vtsls)
- 代替の言語サーバー: [typescript-language-server/typescript-language-server](https://github.com/typescript-language-server/typescript-language-server)
- デバッグアダプター: [vscode-js-debug](https://github.com/microsoft/vscode-js-debug)

<!--
TBD: 言語サーバー間の違いについて文書化する
-->

## 言語サーバー

デフォルトでは、Zed は TypeScript、TSX、JavaScript のファイルに対して [vtsls](https://github.com/yioneko/vtsls) を使用します。
言語サーバーは、Settings ({#kb zed::OpenSettings}) の Languages > TypeScript/TSX/JavaScript から設定するか、あるいは設定ファイルに次のように追加します:

```json [settings]
{
  "languages": {
    "TypeScript": {
      "language_servers": ["typescript-language-server", "!vtsls", "..."]
    },
    "TSX": {
      "language_servers": ["typescript-language-server", "!vtsls", "..."]
    },
    "JavaScript": {
      "language_servers": ["typescript-language-server", "!vtsls", "..."]
    }
  }
}
```

TypeScript ファイルには、デフォルトで Prettier も使用されます。これを無効にするには、Settings ({#kb zed::OpenSettings}) の Languages > TypeScript で設定するか、設定ファイルに次のように追加します:

```json [settings]
{
  "languages": {
    "TypeScript": {
      "prettier": { "allowed": false }
    }
    //...
  }
}
```

## Tailwind CSS Language Server を TypeScript で使用する

プレーンな TypeScript ファイル（`.ts`）で [Tailwind CSS language server](https://github.com/tailwindlabs/tailwindcss-intellisense/tree/HEAD/packages/tailwindcss-language-server#readme) のすべての機能（自動補完、Lint など）を利用するには、`settings.json` 内のその `classRegex` フィールドを次のようにカスタマイズできます:

```json [settings]
{
  "lsp": {
    "tailwindcss-language-server": {
      "settings": {
        "experimental": {
          "classRegex": [
            "\\.className\\s*[+]?=\\s*['\"]([^'\"]*)['\"]",
            "\\.setAttributeNS\\(.*,\\s*['\"]class['\"],\\s*['\"]([^'\"]*)['\"]",
            "\\.setAttribute\\(['\"]class['\"],\\s*['\"]([^'\"]*)['\"]",
            "\\.classList\\.add\\(['\"]([^'\"]*)['\"]",
            "\\.classList\\.remove\\(['\"]([^'\"]*)['\"]",
            "\\.classList\\.toggle\\(['\"]([^'\"]*)['\"]",
            "\\.classList\\.contains\\(['\"]([^'\"]*)['\"]",
            "\\.classList\\.replace\\(\\s*['\"]([^'\"]*)['\"]",
            "\\.classList\\.replace\\([^,)]+,\\s*['\"]([^'\"]*)['\"]"
          ]
        }
      }
    }
  }
}
```

## 大規模なプロジェクト

非常に大きなプロジェクトでは、`vtsls` がメモリ不足になる場合があります。Zed では、デフォルト値の 3072 ではなく 8092（8 GiB）を上限として設定していますが、それでも十分でない場合があります:

```json [settings]
{
  "lsp": {
    "vtsls": {
      "settings": {
        // TypeScript 用:
        "typescript": { "tsserver": { "maxTsServerMemory": 16184 } },
        // JavaScript 用:
        "javascript": { "tsserver": { "maxTsServerMemory": 16184 } }
      }
    }
  }
}
```

## インレイ ヒント

Zed は、言語サーバーがインレイ ヒントを返すようにするために、次の初期化オプションを設定します（Zed の設定でインレイ ヒントが有効になっている場合）。

`typescript-language-server` を使用する場合、Zed の `settings.json` でこれらの設定を次のように上書きできます:

```json [settings]
{
  "lsp": {
    "typescript-language-server": {
      "initialization_options": {
        "preferences": {
          "includeInlayParameterNameHints": "all",
          "includeInlayParameterNameHintsWhenArgumentMatchesName": true,
          "includeInlayFunctionParameterTypeHints": true,
          "includeInlayVariableTypeHints": true,
          "includeInlayVariableTypeHintsWhenTypeMatchesName": true,
          "includeInlayPropertyDeclarationTypeHints": true,
          "includeInlayFunctionLikeReturnTypeHints": true,
          "includeInlayEnumMemberValueHints": true
        }
      }
    }
  }
}
```

詳細は [typescript-language-server の inlayhints ドキュメント](https://github.com/typescript-language-server/typescript-language-server?tab=readme-ov-file#inlay-hints-textdocumentinlayhint) を参照してください。

`vtsls` を使用する場合:

```json [settings]
{
  "lsp": {
    "vtsls": {
      "settings": {
        // JavaScript 用:
        "javascript": {
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
              "suppressWhenTypeMatchesName": true
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
        },
        // TypeScript 用:
        "typescript": {
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
              "suppressWhenTypeMatchesName": true
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
        }
      }
    }
  }
}
```

## デバッグ

Zed は `vscode-js-debug` によって、TypeScript コードのデバッグを標準でサポートしています。
以下は追加の設定を行わなくてもデバッグできます:

- `package.json` 内のタスク
- 複数の一般的なフレームワーク（Jest、Mocha、Vitest、Jasmine、Bun、Node）で書かれたテスト

これらの定義済みデバッグタスクのコンテキストに応じた一覧を表示するには、{#action debugger::Start} ({#kb debugger::Start}) を実行します。

> **注:** `package.json` に `@types/bun` が存在する場合、Bun のテストは自動的に検出されます。

> **注:** `package.json` に `@types/node` が存在する場合、Node のテストは自動的に検出されます（Node.js 20 以降が必要です）。

他のすべての言語と同様に、`.vscode/launch.json` の設定も Zed でのデバッグに利用できます。

これらのいずれにも該当しないユースケースの場合は、`.zed/debug.json` にデバッグ設定を追加することで、完全に制御できます。サンプル設定については、以下を参照してください。

### JavaScript のデバッグタスクの設定

JavaScript のデバッグは、Node.js とブラウザーという 2 つの異なる環境があるため、他の言語よりも複雑です。`vscode-js-debug` は `type` フィールドを提供しており、`node` または `chrome` を指定することで、どちらの環境であるかを指定できます。

- [vscode-js-debug の設定ドキュメント](https://github.com/microsoft/vscode-js-debug/blob/main/OPTIONS.md)

### ウェブブラウザーで実行中のサーバー (`npx serve`) にデバッガーをアタッチする

外部で実行されている Web サーバー（例: `npx serve` や `npx live-server` で起動したもの）がある場合、それにアタッチし、ブラウザーで開くことができます。

```json [debug]
[
  {
    "label": "Launch Chrome (TypeScript)",
    "adapter": "JavaScript",
    "type": "chrome",
    "request": "launch",
    "url": "http://localhost:5500",
    "program": "$ZED_FILE",
    "webRoot": "${ZED_WORKTREE_ROOT}",
    "build": {
      "command": "npx",
      "args": ["tsc"]
    },
    "skipFiles": ["<node_internals>/**"]
  }
]
```

## 関連情報

- Yarn をプロジェクトで使うように設定する手順については、[Zed Yarn ドキュメント](./yarn.md) を参照してください。
- [Zed Deno ドキュメント](./deno.md)
