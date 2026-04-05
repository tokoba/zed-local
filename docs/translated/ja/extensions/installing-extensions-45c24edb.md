# 拡張機能のインストール {#installing-extensions}

拡張機能は、言語、テーマ、AI ツールなどの機能を Zed に追加します。Extension Gallery から参照してインストールできます。

Extension Gallery は {#kb zed::Extensions} で開くか、メニューバーから "Zed > Extensions" を選択します。

## インストール先

- macOS では、拡張機能は `~/Library/Application Support/Zed/extensions` にインストールされます。
- Linux では、`$XDG_DATA_HOME/zed/extensions` または `~/.local/share/zed/extensions` のいずれかにインストールされます。
- Windows では、ディレクトリは `%LOCALAPPDATA%\Zed\extensions` です。

このディレクトリには 2 つのサブディレクトリが含まれています:

- `installed` は、各拡張機能のソースコードを含みます。
- `work` は、ダウンロードされた language server など、拡張機能自身によって作成されたファイルを含みます。

## 自動インストール

拡張機能のインストール/アンインストールを自動化するには、[auto_install_extensions](../reference/all-settings.md#auto-install-extensions) のドキュメントを参照してください。
