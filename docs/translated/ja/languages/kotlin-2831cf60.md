# Kotlin

Zed における Kotlin 言語サポートは、コミュニティによってメンテナンスされている [Kotlin extension](https://github.com/zed-extensions/kotlin) によって提供されています。
問題の報告先: <https://github.com/zed-extensions/kotlin/issues>

- Tree-sitter: [fwcd/tree-sitter-kotlin](https://github.com/fwcd/tree-sitter-kotlin)
- 言語サーバー: [fwcd/kotlin-language-server](https://github.com/fwcd/kotlin-language-server)
- 代替言語サーバー: [kotlin/kotlin-lsp](https://github.com/kotlin/kotlin-lsp)

## 設定

ワークスペースの設定オプションは、`settings.json` 内の lsp 設定を通じて言語サーバーに渡すことができます。

lsp の `settings` の完全な一覧は
[こちら](https://github.com/fwcd/kotlin-language-server/blob/main/server/src/main/kotlin/org/javacs/kt/Configuration.kt)
の `class Configuration` と、`class InitializationOptions` の下にある initialization_options に記載されています。

### JVM ターゲット

次の例では、JVM ターゲットを `default`（1.8）から
`17` に変更します:

```json [settings]
{
  "lsp": {
    "kotlin-language-server": {
      "settings": {
        "compiler": {
          "jvm": {
            "target": "17"
          }
        }
      }
    }
  }
}
```

### JAVA_HOME

特定の Java インストールを使用するには、`JAVA_HOME` 環境変数を次のように指定します:

```json [settings]
{
  "lsp": {
    "kotlin-language-server": {
      "binary": {
        "env": {
          "JAVA_HOME": "/Users/whatever/Applications/Work/Android Studio.app/Contents/jbr/Contents/Home"
        }
      }
    }
  }
}
```
