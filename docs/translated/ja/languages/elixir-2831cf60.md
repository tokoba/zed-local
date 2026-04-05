# Elixir

Elixir のサポートは [Elixir extension](https://github.com/zed-extensions/elixir) を通じて利用できます。

- Tree-sitter グラマー:
  - [elixir-lang/tree-sitter-elixir](https://github.com/elixir-lang/tree-sitter-elixir)
  - [phoenixframework/tree-sitter-heex](https://github.com/phoenixframework/tree-sitter-heex)
- 言語サーバー:
  - [elixir-lang/expert](https://github.com/elixir-lang/expert)
  - [elixir-lsp/elixir-ls](https://github.com/elixir-lsp/elixir-ls)
  - [elixir-tools/next-ls](https://github.com/elixir-tools/next-ls)
  - [lexical-lsp/lexical](https://github.com/lexical-lsp/lexical)

さらに、この拡張機能は [EEx](https://hexdocs.pm/eex/EEx.html)（Embedded Elixir）テンプレートと、Phoenix LiveView アプリケーションで使用される HTML と EEx の混合テンプレートである [HEEx](https://hexdocs.pm/phoenix/components.html#heex) テンプレートもサポートします。

## 言語サーバー

Elixir 拡張機能は、ElixirLS、Expert、Next LS、Lexical 用の言語サーバーをサポートしています。デフォルトでは ElixirLS のみが有効になっています。設定 ({#kb zed::OpenSettings}) の Languages > Elixir/EEx/HEEx から、または設定ファイルを直接編集して、有効な言語サーバーを変更したり無効化したりできます。

一部の言語サーバーは、初期化オプションやワークスペース設定オプションも受け付けます。それぞれのサーバーがサポートしている内容については、以下のセクションを参照してください。設定は、それぞれ `lsp.{language-server-id}.initialization_options` および `lsp.{language-server-id}.settings` を通じて設定ファイルに記述できます。

設定ファイルの編集方法について詳しくは、[Configuring Zed](../configuring-zed.md#settings-files) ガイドを参照してください。

### ElixirLS を使用する

ElixirLS はワークスペース設定オプションを受け付けます。

次の例では、[Dialyzer](https://github.com/elixir-lsp/elixir-ls#dialyzer-integration) を無効にしています。

```json [settings]
  "lsp": {
    "elixir-ls": {
      "settings": {
        "dialyzerEnabled": false
      }
    }
  }
```

利用可能なすべてのオプションについては、公式の [ElixirLS configuration settings](https://github.com/elixir-lsp/elixir-ls#elixirls-configuration-settings) の一覧を参照してください。

### Expert を使用する

設定ファイルに次を追加して、Expert を有効にします。

```json [settings]
  "languages": {
    "Elixir": {
      "language_servers": ["expert", "!elixir-ls", "!next-ls", "!lexical", "..."]
    },
    "EEx": {
      "language_servers": ["expert", "!elixir-ls", "!next-ls", "!lexical", "..."]
    },
    "HEEx": {
      "language_servers": ["expert", "!elixir-ls", "!next-ls", "!lexical", "..."]
    }
  }
```

Expert はワークスペース設定オプションを受け付けます。

次の例では、プロジェクトシンボル検索で結果を返すために必要な最小文字数を設定しています。

```json [settings]
  "lsp": {
    "expert": {
      "settings": {
        "workspaceSymbols": {
          "minQueryLength": 0
        }
      }
    }
  }
```

利用可能なすべてのオプションについては、[Expert configuration](https://expert-lsp.org/docs/configuration/) ページを参照してください。

カスタムビルドの Expert を使用するには、設定ファイルに次を追加します。

```json [settings]
  "lsp": {
    "expert": {
      "binary": {
        "path": "/path/to/expert",
        "arguments": ["--stdio"]
      }
    }
  }
```

### Next LS を使用する

設定ファイルに次を追加して、Next LS を有効にします。

```json [settings]
  "languages": {
    "Elixir": {
      "language_servers": ["next-ls", "!expert", "!elixir-ls", "!lexical", "..."]
    },
    "EEx": {
      "language_servers": ["next-ls", "!expert", "!elixir-ls", "!lexical", "..."]
    },
    "HEEx": {
      "language_servers": ["next-ls", "!expert", "!elixir-ls", "!lexical", "..."]
    }
  }
```

Next LS は初期化オプションを受け付けます。

補完は Next LS における実験的な機能であり、Zed ではデフォルトで有効になっています。次を設定ファイルに追加することで無効にできます。

```json [settings]
  "lsp": {
    "next-ls": {
      "initialization_options": {
        "experimental": {
          "completions": {
            "enable": false
          }
        }
      }
    }
  }
```

Next LS には [Credo](https://hexdocs.pm/credo/overview.html) 連携用の拡張機能もあり、これはデフォルトで有効になっています。これを無効にするには、次のセクションを設定ファイルに追加します。

```json [settings]
  "lsp": {
    "next-ls": {
      "initialization_options": {
        "extensions": {
          "credo": {
            "enable": false
          }
        }
      }
    }
  }
```

Next LS から Credo に対して CLI オプションを直接渡すこともできます。次の例では、`--min-priority high` を渡しています。

```json [settings]
  "lsp": {
    "next-ls": {
      "initialization_options": {
        "extensions": {
          "credo": {
            "cli_options": ["--min-priority high"]
          }
        }
      }
    }
  }
```

その他の CLI オプションについては、[Credo Command Line Switches](https://hexdocs.pm/credo/suggest_command.html#command-line-switches) ページを参照してください。

### Lexical を使用する

設定ファイルに次を追加して、Lexical を有効にします。

```json [settings]
  "languages": {
    "Elixir": {
      "language_servers": ["lexical", "!expert", "!elixir-ls", "!next-ls", "..."]
    },
    "EEx": {
      "language_servers": ["lexical", "!expert", "!elixir-ls", "!next-ls", "..."]
    },
    "HEEx": {
      "language_servers": ["lexical", "!expert", "!elixir-ls", "!next-ls", "..."]
    }
  }
```

## 言語サーバーなしでのフォーマット

言語サーバーを使わずに作業したいが、それでも [Mix](https://hexdocs.pm/mix/Mix.html) によるコードフォーマットは行いたい場合は、次を設定ファイルに追加して外部フォーマッタとして設定できます。

```json [settings]
  "languages": {
    "Elixir": {
      "enable_language_server": false,
      "format_on_save": "on",
      "formatter": {
        "external": {
          "command": "mix",
          "arguments": ["format", "--stdin-filename", "{buffer_path}", "-"]
        }
      }
    },
    "EEx": {
      "enable_language_server": false,
      "format_on_save": "on",
      "formatter": {
        "external": {
          "command": "mix",
          "arguments": ["format", "--stdin-filename", "{buffer_path}", "-"]
        }
      }
    },
    "HEEx": {
      "enable_language_server": false,
      "format_on_save": "on",
      "formatter": {
        "external": {
          "command": "mix",
          "arguments": ["format", "--stdin-filename", "{buffer_path}", "-"]
        }
      }
    }
  }
```

## Tailwind CSS Language Server を HEEx テンプレートで使用する

HEEx テンプレートで [Tailwind CSS language server](https://github.com/tailwindlabs/tailwindcss-intellisense/tree/HEAD/packages/tailwindcss-language-server#readme) のすべての機能（補完、Lint、ホバードキュメント）を利用するには、設定ファイルに次を追加します。

```json [settings]
  "lsp": {
    "tailwindcss-language-server": {
      "settings": {
        "includeLanguages": {
          "elixir": "html",
          "heex": "html"
        },
        "experimental": {
          "classRegex": ["class=\"([^\"]*)\"", "class='([^']*)'"]
        }
      }
    }
  }
```

これらの設定により、HEEx テンプレート内で Tailwind CSS クラスの補完が利用できるようになります。例:

```heex
<%!-- 標準的な class 属性 --%>
<div class="flex items-center <completion here>">
  <p class="text-lg font-bold <completion here>">Hello World</p>
</div>

<%!-- Elixir の式を含む場合 --%>
<div class={"flex #{@custom_class} <completion here>"}>
  Content
</div>

<%!-- Phoenix の関数を使用する場合 --%>
<div class={class_list(["flex", "items-center", "<completion here>"])}>
  Content
</div>
```

## 関連項目

- [Erlang](./erlang.md)
- [Gleam](./gleam.md)
