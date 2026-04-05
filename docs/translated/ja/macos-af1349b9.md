# macOS 上の Zed

Zed は主に macOS 上で開発されており、macOS はすべての機能がサポートされる第一級のプラットフォームです。

## Zed のインストール

[download page](https://zed.dev/download) から Zed をダウンロードします。ダウンロードされるのは `.dmg` ファイルなので、それを開き、Zed を Applications フォルダにドラッグします。

安定版より約 1 週間早く更新を受け取るプレビュービルドについては、[preview releases page](https://zed.dev/releases/preview) を参照してください。

インストール後、Zed は自動的にアップデートをチェックし、新しいバージョンが利用可能なときに通知します。

### Homebrew

Zed は Homebrew を使ってインストールすることもできます:

```sh
brew install --cask zed
```

プレビューバージョンの場合:

```sh
brew install --cask zed@preview
```

### ソースからビルドする

Zed をソースからビルドするには、[macOS 開発ドキュメント](./development/macos.md) を参照してください。

## システム要件

- macOS 10.15.7（Catalina）以降
- Apple Silicon（M1/M2/M3/M4）または Intel プロセッサー

Zed は GPU アクセラレーションによるレンダリングに Metal を使用しており、これはサポートされるすべての macOS バージョンで利用できます。

## CLI のインストール

Zed には、ターミナルからファイルやプロジェクトを開くためのコマンドラインツールが含まれています。インストールするには次の手順に従います。

1. Zed を開く
2. `Cmd+Shift+P` でコマンドパレットを開く
3. `cli: install` を実行する

これにより `/usr/local/bin` に `zed` コマンドが作成されます。その後、次のようにファイルやフォルダーを開くことができます。

```sh
zed .                    # カレントフォルダーを開く
zed file.txt             # ファイルを開く
zed project/ file.txt    # フォルダーとファイルを開く
```

利用可能なすべてのオプションについては、[CLI リファレンス](./reference/cli.md) を参照してください。

## アンインストール

1. Zed が起動している場合は終了する
2. Applications から Zed をゴミ箱にドラッグする
3. 必要に応じて、設定や拡張機能を削除します:

```sh
rm -rf ~/.config/zed
rm -rf ~/Library/Application\ Support/Zed
rm -rf ~/Library/Caches/Zed
rm -rf ~/Library/Logs/Zed
rm -rf ~/Library/Saved\ Application\ State/dev.zed.Zed.savedState
```

CLI をインストールしている場合は、次のコマンドで削除します:

```sh
rm /usr/local/bin/zed
```

## トラブルシューティング

### Zed が開かない、または「損傷している」という警告が表示される

macOS が Zed は損傷している、または開けないと報告する場合、Gatekeeper の問題である可能性が高いです。次を試してください。

1. Applications 内の Zed を右クリック（または Control キーを押しながらクリック）する
2. コンテキストメニューから「開く」を選択する
3. 表示されるダイアログで「開く」をクリックする

これにより、macOS にこのアプリケーションを信頼するよう指示できます。

それでも解決しない場合は、隔離属性を削除します:

```sh
xattr -cr /Applications/Zed.app
```

### CLI コマンドが見つからない

インストール後に `zed` コマンドが利用できない場合:

1. PATH に `/usr/local/bin` が含まれていることを確認する
2. コマンドパレットで `cli: install` を実行して CLI を再インストールしてみる
3. PATH を再読み込みするために新しいターミナルウィンドウを開く

### GPU またはレンダリングの問題

Zed はレンダリングに Metal を使用しています。表示の乱れなどグラフィックの問題が発生する場合:

1. macOS が最新であることを確認する
2. GPU の状態をリセットするために Mac を再起動する
3. 他のアプリによる GPU の負荷がないか、アクティビティモニタで確認する

### メモリまたは CPU 使用率が高い

Zed が想定以上にリソースを使用している場合:

1. ターミナル出力（`zed: open log`）で暴走している language server がないか確認する
2. 拡張機能を 1 つずつ無効化して競合の原因を特定してみる
3. 大規模なプロジェクトの場合は、[プロジェクト設定](./reference/all-settings.md#file-scan-exclusions) を使用して、インデックス対象から不要なフォルダーを除外することを検討する

さらにヘルプが必要な場合は、[トラブルシューティングガイド](./troubleshooting.md) を参照するか、[Zed Discord](https://discord.gg/zed-community) を訪れてください。
