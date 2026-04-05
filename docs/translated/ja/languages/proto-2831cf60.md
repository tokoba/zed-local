# Proto

Proto/proto3（Protocol Buffers 定義言語）のサポートは、[Proto extension](https://github.com/zed-industries/zed/tree/main/extensions/proto) で利用できます。

- Tree-sitter: [coder3101/tree-sitter-proto](https://github.com/coder3101/tree-sitter-proto)
- 言語サーバー: [protobuf-language-server](https://github.com/lasorda/protobuf-language-server)

<!--
TBD: 使用する言語サーバーおよびサポートされる機能を明確化する。

## セットアップ

### protobuf-language-server のインストール

protobuf-language-server をインストールし、PATH に含まれていることを確認します:

```
go install github.com/lasorda/protobuf-language-server@latest
which protobuf-language-server
```

### ProtoLS のインストール

protols をインストールし、PATH に含まれていることを確認します:

```
cargo install protols
which protols
```

## 設定

```json [settings]
"lsp": {
  "protobuf-language-server": {
    "binary": {
      "path": "protols"
    }
  }
}
```

## フォーマット

`clang-format` がインストールされていれば、ProtoLS はフォーマットをサポートします。

```sh
# MacOS:
brew install clang-format
# Ubuntu
sudo apt-get install clang-format
# Fedora
sudo dnf install clang-tools-extra
```

フォーマット設定をカスタマイズするには、たとえば次のような `.clang-format` ファイルを作成します:

```clang-format
IndentWidth: 4
ColumnLimit: 120
```

または、設定で `clang-format` を [formatter](https://zed.dev/docs/reference/all-settings#formatter) として指定し、zed から直接呼び出すこともできます:

```json [settings]
  "languages": {
    "Proto": {
      "format_on_save": "on",
      "tab_size": 4,
      "formatter": {
        "external": {
          "command": "clang-format",
          "arguments": ["-style={IndentWidth: 4, ColumnLimit: 0}"]
        }
      }
    },
  }
```
-->