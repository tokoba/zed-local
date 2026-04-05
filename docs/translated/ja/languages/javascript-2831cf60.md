# JavaScript

Zed はネイティブに JavaScript をサポートしています。

- Tree-sitter: [tree-sitter/tree-sitter-JavaScript](https://github.com/tree-sitter/tree-sitter-javascript)
- 言語サーバー: [yioneko/vtsls](https://github.com/yioneko/vtsls)
- 代替の言語サーバー: [typescript-language-server/typescript-language-server](https://github.com/typescript-language-server/typescript-language-server)
- デバッグアダプター: [vscode-js-debug](https://github.com/microsoft/vscode-js-debug)

## コードフォーマット

JavaScript では、保存時のフォーマットがデフォルトで有効になっており、TypeScript の組み込みコードフォーマット機能を使用します。
しかし、多くの JavaScript プロジェクトでは、[Prettier](https://prettier.io/) のような別のコマンドラインのコードフォーマットツールを使用しています。
設定で JavaScript 用の *外部* コードフォーマッタを指定することで、これらのツールのいずれかを使用できます。
詳細は [設定ドキュメント](../reference/all-settings.md) を参照してください。

たとえば、Prettier がインストールされていて `PATH` に通っていれば、それを使って JavaScript ファイルをフォーマットできます。

設定 ({#kb zed::OpenSettings}) の Languages > JavaScript でフォーマットを設定するか、設定ファイルに次を追加します:

```json [settings]
{
  "languages": {
    "JavaScript": {
      "formatter": {
        "external": {
          "command": "prettier",
          "arguments": ["--stdin-filepath", "{buffer_path}"]
        }
      }
    }
  }
}
```

## JSX

Zed は標準で JSX の構文ハイライトをサポートしています。

JSX の文字列内では、Tailwind CSS のクラスに対する補完を提供するために [`tailwindcss-language-server`](./tailwindcss.md) が使用されます。

## JSDoc

Zed は、JSDoc 構文に準拠した JavaScript および TypeScript のコメントをサポートしています。
Zed は JSDoc の構文解析とハイライトに [tree-sitter/tree-sitter-jsdoc](https://github.com/tree-sitter/tree-sitter-jsdoc) を使用します。

## ESLint

フォーマット時に ESLint のコードアクションを実行することで、`eslint --fix` を使ってコードを整形するように Zed を設定できます。

設定 ({#kb zed::OpenSettings}) の Languages > JavaScript でフォーマット時のコードアクションを設定するか、設定ファイルに次を追加します:

```json [settings]
{
  "languages": {
    "JavaScript": {
      "code_actions_on_format": {
        "source.fixAll.eslint": true
      }
    }
  }
}
```

また、`fixAll` を使用する際に、単一の ESLint ルールだけを実行するようにすることもできます:

```json [settings]
{
  "languages": {
    "JavaScript": {
      "code_actions_on_format": {
        "source.fixAll.eslint": true
      }
    }
  },
  "lsp": {
    "eslint": {
      "settings": {
        "codeActionOnSave": {
          "rules": ["import/order"]
        }
      }
    }
  }
}
```

> **注意:** ESLint の後でも、設定されている別のフォーマッタは引き続き実行されます。
> そのため、言語サーバーや Prettier の設定が ESLint のルールに従ってフォーマットしない場合、
> ESLint が修正した内容がそれらによって上書きされてしまい、結果としてエラーになります。

保存時に ESLint **だけ** を実行したい場合は、コードアクションをフォーマッタとして設定できます。

設定 ({#kb zed::OpenSettings}) の Languages > JavaScript で設定するか、設定ファイルに次を追加します:

```json [settings]
{
  "languages": {
    "JavaScript": {
      "formatter": [],
      "code_actions_on_format": {
        "source.fixAll.eslint": true
      }
    }
  }
}
```

### ESLint の `nodePath` を設定する

ESLint の `nodePath` 設定を構成できます:

```json [settings]
{
  "lsp": {
    "eslint": {
      "settings": {
        "nodePath": ".yarn/sdks"
      }
    }
  }
}
```

### ESLint の `problems` を設定する

ESLint の `problems` 設定を構成できます。

たとえば、`problems.shortenToSingleLine` を次のように設定できます:

```json [settings]
{
  "lsp": {
    "eslint": {
      "settings": {
        "problems": {
          "shortenToSingleLine": true
        }
      }
    }
  }
}
```

### ESLint の `rulesCustomizations` を設定する

ESLint の `rulesCustomizations` 設定を構成できます:

```json [settings]
{
  "lsp": {
    "eslint": {
      "settings": {
        "rulesCustomizations": [
          // すべての ESLint のエラー/警告を警告として表示する
          { "rule": "*", "severity": "warn" }
        ]
      }
    }
  }
}
```

### ESLint の `workingDirectory` を設定する

ESLint の `workingDirectory` 設定を構成できます:

```json [settings]
{
  "lsp": {
    "eslint": {
      "settings": {
        "workingDirectory": {
          "mode": "auto"
        }
      }
    }
  }
}
```

## JavaScript で Tailwind CSS Language Server を使う

プレーンな JavaScript ファイル (`.js`) で [Tailwind CSS language server](https://github.com/tailwindlabs/tailwindcss-intellisense/tree/HEAD/packages/tailwindcss-language-server#readme) のすべての機能（自動補完、Lint など）を利用するには、`settings.json` 内でその配下にある `classRegex` フィールドをカスタマイズします:

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

## デバッグ

Zed は `vscode-js-debug` を使用して、JavaScript コードのデバッグを標準でサポートしています。
次のものは、追加の設定を書かなくてもデバッグできます:

- `package.json` のタスク
- Jest、Mocha、Vitest、Jasmine、Bun、Node などの一般的なフレームワークで書かれたテスト

これらのあらかじめ定義されたデバッグタスクのコンテキストリストを表示するには、{#action debugger::Start} ({#kb debugger::Start}) を実行します。

> **注意:** `package.json` に `@types/bun` が存在する場合、Bun のテストは自動的に検出されます。

> **注意:** `package.json` に `@types/node` が存在する場合、Node のテストは自動的に検出されます（Node.js 20 以上が必要です）。

他のすべての言語と同様に、`.vscode/launch.json` の構成も Zed でのデバッグに利用できます。

これらでは対応できないユースケースの場合は、`.zed/debug.json` にデバッグ設定を追加することで、完全に制御できます。サンプル設定については以下を参照してください。

### JavaScript のデバッグタスクの設定

JavaScript のデバッグは、Node.js とブラウザーという 2 つの異なる環境があるため、他の言語よりも複雑です。`vscode-js-debug` は `type` フィールドを公開しており、これを使って `node` か `chrome` のどちらの環境かを指定できます。

- [vscode-js-debug の設定ドキュメント](https://github.com/microsoft/vscode-js-debug/blob/main/OPTIONS.md)

### 現在のファイルを Node でデバッグする

```json [debug]
[
  {
    "adapter": "JavaScript",
    "label": "JS ファイルをデバッグ",
    "type": "node",
    "request": "launch",
    "program": "$ZED_FILE",
    "skipFiles": ["<node_internals>/**"]
  }
]
```

### Web アプリを Chrome で起動する

```json [debug]
[
  {
    "adapter": "JavaScript",
    "label": "Chrome でアプリをデバッグ",
    "type": "chrome",
    "request": "launch",
    "file": "$ZED_WORKTREE_ROOT/index.html",
    "webRoot": "$ZED_WORKTREE_ROOT",
    "console": "integratedTerminal",
    "skipFiles": ["<node_internals>/**"]
  }
]
```

## 関連項目

- プロジェクトで Yarn を使うための設定手順については、[Yarn ドキュメント](./yarn.md) を参照してください。
- [TypeScript ドキュメント](./typescript.md)
