# Ansible

Zed における Ansible のサポートは、コミュニティによってメンテナンスされている [Ansible extension](https://github.com/kartikvashistha/zed-ansible) によって提供されます。

- Tree-sitter: [zed-industries/tree-sitter-yaml](https://github.com/zed-industries/tree-sitter-yaml)
- 言語サーバー: [ansible/vscode-ansible](https://github.com/ansible/vscode-ansible/tree/main/packages/ansible-language-server)

## セットアップ

### ファイル検出

Ansible 以外の YAML ファイルを誤って扱わないように、デフォルトでは Ansible 言語にはどのファイル拡張子も関連付けられていません。

この挙動を変更するには、フォルダーや命名規則に合わせてマッチさせるために、プロジェクト内の Zed 設定（`.zed/settings.json`）または Zed のユーザー設定（`~/.config/zed/settings.json`）に `"file_types"` セクションを追加できます。例えば次のようになります。

```json [settings]
{
  "file_types": {
    "Ansible": [
      "**.ansible.yml",
      "**.ansible.yaml",
      "**/defaults/*.yml",
      "**/defaults/*.yaml",
      "**/meta/*.yml",
      "**/meta/*.yaml",
      "**/tasks/*.yml",
      "**/tasks/*.yaml",
      "**/handlers/*.yml",
      "**/handlers/*.yaml",
      "**/group_vars/*.yml",
      "**/group_vars/*.yaml",
      "**/host_vars/*.yml",
      "**/host_vars/*.yaml",
      "**/playbooks/*.yml",
      "**/playbooks/*.yaml",
      "**playbook*.yml",
      "**playbook*.yaml"
    ]
  }
}
```

このリストは必要に応じて自由に変更してください。

#### インベントリ

インベントリファイルが YAML 形式である場合、次のいずれかを行えます。

- インベントリファイルの先頭に次のコメントを追加して、`ansible-lint` のインベントリ JSON スキーマを付与します。

```yml
# yaml-language-server: $schema=https://raw.githubusercontent.com/ansible/ansible-lint/main/src/ansiblelint/schemas/inventory.json
```

- あるいは、Zed の設定で YAML 言語サーバーの設定を行い、インベントリパターンに一致するすべてのインベントリファイルにこのスキーマを設定します（[参考](https://zed.dev/docs/languages/yaml)）。

```json [settings]
{
  "lsp": {
    "yaml-language-server": {
      "settings": {
        "yaml": {
          "schemas": {
            "https://raw.githubusercontent.com/ansible/ansible-lint/main/src/ansiblelint/schemas/inventory.json": [
              "./inventory/*.yaml",
              "hosts.yml"
            ]
          }
        }
      }
    }
  }
}
```

### LSP の設定

デフォルトでは、次の設定が Ansible 言語サーバーに渡されます。これは Ansible 言語サーバー向けに [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig/blob/03bc581e05e81d33808b42b2d7e76d70adb3b595/lua/lspconfig/configs/ansiblels.lua) で設定されているデフォルトを便利に反映したものです。

```json
{
  "ansible": {
    "ansible": {
      "path": "ansible"
    },
    "executionEnvironment": {
      "enabled": false
    },
    "python": {
      "interpreterPath": "python3"
    },
    "validation": {
      "enabled": true,
      "lint": {
        "enabled": true,
        "path": "ansible-lint"
      }
    }
  }
}
```

> **注:** リンティングを機能させるには、`ansible-lint` がインストールされており、`$PATH` 上から見つけられることを確認してください。

必要に応じて、上記のデフォルト設定は Zed 設定ファイルの `"lsp"` セクションで上書きできます。例えば次のようになります。

```json [settings]
{
  "lsp": {
    // Zed Ansible extension は、すべての設定に `ansible` というプレフィックスを付けます
    // そのため、`ansible.ansible.path` ではなく `ansible.path` を使用してください。
    "ansible-language-server": {
      "settings": {
        "ansible": {
          "path": "ansible"
        },
        "executionEnvironment": {
          "enabled": false
        },
        "python": {
          "interpreterPath": "python3"
        },
        "validation": {
          "enabled": false,
          "lint": {
            "enabled": false,
            "path": "ansible-lint"
          }
        }
      }
    }
  }
}
```

サーバーに渡すことができるオプションや設定の完全な一覧は、プロジェクトのページ [こちら](https://github.com/ansible/vscode-ansible/blob/main/docs/als/settings.md) にあります。
