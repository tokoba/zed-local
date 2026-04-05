# 拡張機能のケイパビリティ

Zed の拡張機能が実行できる操作は、ケイパビリティシステムによって制御されています。

## ケイパビリティの制限

ユーザーは、拡張機能に付与されるケイパビリティを制限することができます。

これは `granted_extension_capabilities` 設定で制御します。

ケイパビリティを制限または削除すると、拡張機能が十分なケイパビリティなしに対応する拡張 API を呼び出そうとした際に、エラーが返されます。

たとえば、GitHub からのファイルのみダウンロードを許可するには、`download_file` ケイパビリティの `host` を設定します:

```diff
{
  "granted_extension_capabilities": [
    { "kind": "process:exec", "command": "*", "args": ["**"] },
-   { "kind": "download_file", "host": "*", "path": ["**"] },
+   { "kind": "download_file", "host": "github.com", "path": ["**"] },
    { "kind": "npm:install", "package": "*" }
  ]
}
```

*いかなる* ケイパビリティも拡張機能に実行させたくない場合は、付与されているケイパビリティをすべて削除できます:

```json
{
  "granted_extension_capabilities": []
}
```

> なお、この設定を行うと、少なくともデフォルトの設定では多くの拡張機能が動作しなくなる可能性があります。

## ケイパビリティ

### `process:exec`

`process:exec` ケイパビリティは、拡張機能に [`zed_extension_api::process::Command`](https://docs.rs/zed_extension_api/latest/zed_extension_api/process/struct.Command.html) を使ってコマンドを実行する権限を与えます。

#### 例

任意のコマンドを任意の引数で実行できるようにするには:

```toml
{ kind = "process:exec", command = "*", args = ["**"] }
```

特定のコマンド（例: `gem`）を任意の引数で実行できるようにするには:

```toml
{ kind = "process:exec", command = "gem", args = ["**"] }
```

### `download_file`

`download_file` ケイパビリティは、拡張機能に [`zed_extension_api::download_file`](https://docs.rs/zed_extension_api/latest/zed_extension_api/fn.download_file.html) を使ってファイルをダウンロードする権限を与えます。

#### 例

任意のファイルのダウンロードを許可するには:

```toml
{ kind = "download_file", host = "*", path = ["**"] }
```

任意のファイルを `github.com` からダウンロードできるようにするには:

```toml
{ kind = "download_file", host = "github.com", path = ["**"] }
```

特定の GitHub リポジトリから任意のファイルをダウンロードできるようにするには:

```toml
{ kind = "download_file", host = "github.com", path = ["zed-industries", "zed", "**"] }
```

### `npm:install`

`npm:install` ケイパビリティは、拡張機能に [`zed_extension_api::npm_install_package`](https://docs.rs/zed_extension_api/latest/zed_extension_api/fn.npm_install_package.html) を使って npm パッケージをインストールする権限を与えます。

#### 例

任意の npm パッケージのインストールを許可するには:

```toml
{ kind = "npm:install", package = "*" }
```

特定の npm パッケージ（例: `typescript`）のインストールを許可するには:

```toml
{ kind = "npm:install", package = "typescript" }
```
