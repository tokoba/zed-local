# クラッシュのデバッグ

Zed がパニックを起こすかクラッシュすると、エディタのメモリを検査するサイドカー・プロセスにメッセージを送信し、`~/Library/Logs/Zed` または `$XDG_DATA_HOME/zed/logs` に [minidump](https://chromium.googlesource.com/breakpad/breakpad/+/master/docs/getting_started_with_breakpad.md#the-minidump-file-format) を作成します。この minidump を使って、すべてのスレッドスタックのバックトレースを生成できます。

テレメトリが有効になっている場合、アプリを再起動したときに Zed がこれらのレポートをアップロードします。レポートは [Slack チャンネル](https://zed-industries.slack.com/archives/C0977J9MA1Y) と [Sentry](https://zed-dev.sentry.io/issues) に送信されます（いずれも Zed スタッフ専用です）。

これらのクラッシュレポートには有用なデータが含まれていますが、スパンやシンボル情報がないと読みづらいものです。それでも、利用中の Zed リリース用のソースコードとストリップされていないバイナリ（または別のシンボルファイル）をダウンロードし、次を実行することでローカルで解析できます。

```sh
zstd -d ~/.local/share/zed/<uuid>.dmp -o minidump.dmp
minidump-stackwalk minidump.dmp
```

ログディレクトリ内の minidump のほかに、パニックメッセージ、スパン、システムスペックなどのメタデータを含む `<uuid>.json` ファイルも確認できるはずです。

## デバッガーの利用

クラッシュを一貫して再現できる場合は、デバッガーを使ってクラッシュ時点のプログラムの状態を調査してください。

セットアップの詳細については、[デバッガーの使用](./debuggers.md#debugging-panics-and-crashes) を参照してください。
