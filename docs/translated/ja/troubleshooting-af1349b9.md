# トラブルシューティング

このガイドでは、Zed に関する一般的なトラブルシューティング手法を説明します。
ここに記載された情報を使えば、ご自身で問題の原因を特定して解決できる場合もあります。
一方で、トラブルシューティングとは、問題の診断と修正を支援するために、適切な情報（ログ、プロファイル、再現手順など）を収集することを意味する場合もあります。

> **注意**: コマンドパレットを開くには、macOS では `cmd-shift-p`、Windows / Linux では `ctrl-shift-p` を使用します。

## Zed とシステム情報の取得

問題を報告したりヘルプを求めたりする際には、Zed のバージョンやシステム構成を把握しておくと便利です。
これらの情報は、コマンドパレットから次のアクションを実行することで取得できます。

- {#action zed::About}: Zed のバージョン番号を確認する
- {#action zed::CopySystemSpecsIntoClipboard}: Zed のバージョン番号、オペレーティングシステムのバージョン、ハードウェア構成をクリップボードにコピーする

## Zed ログ

Zed のあらゆる問題をトラブルシューティングする際、最初に確認するとよいのが Zed ログです。ここには何が問題になっているかの手がかりが含まれている可能性があります。
コマンドパレットから {#action zed::OpenLog} アクションを実行すると、直近 1000 行分のログを確認できます。
ファイル全体を確認したい場合は、コマンドパレットから {#action zed::RevealLogInFileManager} を実行して、OS 標準のファイルマネージャーでログファイルを表示できます。

Zed ログは、各オペレーティングシステムで次の場所にあります:

- macOS: `~/Library/Logs/Zed/Zed.log`
- Windows: `C:\Users\YOU\AppData\Local\Zed\logs\Zed.log`
- Linux: `~/.local/share/zed/logs/Zed.log` または `$XDG_DATA_HOME`

> **注意:** 場合によっては、ログをリアルタイムに監視できると便利なことがあります。例えば、[Zed extension を開発する](https://zed.dev/docs/extensions/developing-extensions) ときなどです。
> 例: `tail -f ~/Library/Logs/Zed/Zed.log`

ログの内容によっては、ご自身で問題をデバッグするのに十分なコンテキストが得られる場合もありますし、[GitHub issue](https://github.com/zed-industries/zed/issues/new/choose) を作成したり、[Discord server](https://zed.dev/community-links#forums-and-discussions) 上で Zed スタッフと話したりする際に役立つ具体的なエラーが見つかる場合もあります。

## パフォーマンス問題（プロファイリング）

Zed でパフォーマンスの問題（カクつき、ハング、全体的な無応答など）が発生している場合、issue にパフォーマンスプロファイルを添付していただけると、どこで処理が詰まっているのかを特定するのに役立ちます。

### macOS

[Xcode](https://apps.apple.com/us/app/xcode/id497799835) に同梱されている Xcode Instruments は、macOS でプロファイリングを行うための標準的なツールです。

1. Zed を起動した状態で、Instruments を開きます
1. プロファイリングテンプレートとして `Time Profiler` を選択します  
   ![Time Profiler が選択された Instruments のテンプレートピッカー](https://images.zed.dev/docs/troubleshooting/instruments-template-picker.webp)
1. `Time Profiler` の設定で、ターゲットを実行中の Zed プロセスに設定します
1. 記録を開始します  
   ![ターゲットのドロップダウンと記録ボタンが表示された Time Profiler の設定](https://images.zed.dev/docs/troubleshooting/instruments-target-and-record.webp)
1. Zed でパフォーマンス問題を引き起こす操作を実行します
1. 記録を停止します  
   ![Instruments で完了した Time Profiler の記録](https://images.zed.dev/docs/troubleshooting/instruments-recording.webp)
1. トレースファイルを保存します
1. トレースファイルを zip アーカイブに圧縮します
1. トレースの zip を添付して [GitHub issue](https://github.com/zed-industries/zed/issues/new/choose) を作成します

<!--### Windows-->

<!--### Linux-->

## 起動およびワークスペースの問題

Zed は、ワークスペースやプロジェクトに関連するデータを永続化するためにローカルの SQLite データベースを作成します。
これらのデータベースには、例えばプロジェクトで開いているタブやペイン、各開いているファイルのスクロール位置、これまでに開いたすべてのプロジェクトの一覧（最近使ったプロジェクトのモーダルピッカー用）などが保存されています。
これらのデータベースは、次の場所で見つけて確認できます。

- macOS: `~/Library/Application Support/Zed/db`
- Linux and FreeBSD: `~/.local/share/zed/db`（または `XDG_DATA_HOME` または `FLATPAK_XDG_DATA_HOME` 内）
- Windows: `%LOCALAPPDATA%\Zed\db`

これらのデータベースの命名規則は `0-<zed_channel>` の形式です。

- 安定版: `0-stable`
- プレビュー: `0-preview`
- ナイトリー: `0-nightly`
- 開発版: `0-dev`

稀ではありますが、ワークスペースデータベースが破損し、その結果 Zed が起動しなくなったケースがいくつか報告されています。
起動時の問題が発生している場合は、データベースを一時的に元の場所から移動し、その後 Zed を再起動してみることで、それがワークスペースに関連する問題かどうかを確認できます。

> **注意**: ワークスペースデータベースを移動すると、Zed は新しいデータベースを作成します。
> 最近のプロジェクト、開いているタブなどは「初期状態」にリセットされます。

データベースを再生成しても問題が解決しない場合は、[issue を作成](https://github.com/zed-industries/zed/issues/new/choose)してください。

## 言語サーバーの問題

古い診断結果が残り続ける、定義へのジャンプがうまく機能しないといった言語サーバー関連の問題が発生している場合は、コマンドパレットから {#action editor::RestartLanguageServer} を実行して言語サーバーを再起動することで、解決することがよくあります。

## エージェントのエラーメッセージ

### "Max tokens reached"

このエラーは、エージェントのレスポンスがモデルの最大トークン数制限を超えたときに表示されます。
これは次のような場合に発生します。

- エージェントが非常に長いレスポンスを生成した場合
- 会話のコンテキストとレスポンスの合計がモデルの許容量を超えた場合
- ツールの出力が大きく、利用可能なトークン枠を使い切ってしまった場合

**解決方法:**

1. 新しいスレッドを開始し、コンテキストのサイズを小さくする
2. AI 設定で、より大きなトークン上限を持つモデルを使用する
3. リクエストを、より小さく焦点を絞ったタスクに分割する
4. スレッドのコントロールを使って、ツールの出力や過去のメッセージをクリアする

トークン上限はモデルによって異なります。具体的な上限値については、利用しているモデル提供元のドキュメントを確認してください。
