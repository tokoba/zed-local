# Zed におけるテレメトリ

Zed は、利用パターンを把握し問題を診断するために、匿名のテレメトリを収集します。

テレメトリは次の 2 つのカテゴリに分類されます:

- **クライアント側**: 利用状況メトリクスとクラッシュレポート。これらは設定で無効にできます。
- **サーバー側**: AI や Collaboration などのホスト型サービスを利用する際に収集されます。これらの機能を動作させるために必要です。

## テレメトリ設定の構成

Zed から送信されるデータは、すべてあなたが制御できます。
一部またはすべてのテレメトリの種類を有効化または無効化するには、Settings ({#kb zed::OpenSettings}) を開いて「telemetry」と検索するか、設定ファイルに次を追加してください:

```json [settings]
"telemetry": {
    "diagnostics": false,
    "metrics": false
},
```

## データフロー

テレメトリは、アプリケーションから当社のサーバーへ 5 分ごと（または 50 件のイベントが蓄積されたとき）に送信され、その後、適切なサービスにルーティングされます。現在、次のサービスを利用しています:

- [Sentry](https://sentry.io): クラッシュ監視サービス - 診断イベントを保存します
- [Snowflake](https://snowflake.com): データウェアハウス - 診断イベントとメトリクスイベントの両方を保存します
- [Hex](https://www.hex.tech): ダッシュボードおよびデータ探索 - Snowflake に保存されたデータへアクセスします
- [Amplitude](https://www.amplitude.com): ダッシュボードおよびデータ探索 - Snowflake に保存されたデータへアクセスします

## テレメトリの種類

### 診断

クラッシュレポートは、[minidump](https://learn.microsoft.com/en-us/windows/win32/debug/minidump-files) とデバッグ用メタデータで構成されます。レポートはクラッシュ後の次回起動時に送信されるため、あなたがバグレポートを送信しなくても、Zed が問題を特定して修正できるようになります。

送信されるデータの内容は、[crates/telemetry_events/src/telemetry_events.rs](https://github.com/zed-industries/zed/blob/main/crates/telemetry_events/src/telemetry_events.rs) 内の `Panic` 構造体で確認できます。併せて [クラッシュのデバッグ](./development/debugging-crashes.md) も参照してください。

### クライアント側メトリクス

クライアント側テレメトリには次のものが含まれます:

- 開いたファイルのファイル拡張子
- エディタ内で使用された機能やツール
- プロジェクトの統計情報（例: ファイル数）
- あなたのプロジェクトで検出されたフレームワーク

これらのデータにあなたのコードやプロジェクトの機密情報が含まれることはありません。イベントは HTTPS 経由で送信され、送信レートは制限されています。

利用データはランダムなテレメトリ ID に紐づけられます。認証済みの場合、この ID があなたのメールアドレスに関連付けられることがあり、Zed が時間をかけてパターンを分析したり、フィードバックをお願いするために連絡したりできるようになります。

Zed が送信した内容を確認するには、コマンドパレットから {#action zed::OpenTelemetryLog} を実行するか、`Help > View Telemetry Log` をクリックしてください。

イベントタイプの完全な一覧については、[telemetry_events.rs](https://github.com/zed-industries/zed/blob/main/crates/telemetry_events/src/telemetry_events.rs) 内の `Event` 列挙型を参照してください。

### サーバー側メトリクス

Zed のホスト型サービスを利用する場合、レート制限および課金（例: トークン使用量）のためのメタデータを収集します。フィードバック評価を通じて明示的に共有しない限り、Zed があなたのプロンプトやコードを保存することはありません。

AI データの取り扱いの詳細については、[Zed AI の機能とプライバシー](./ai/ai-improvement.md) を参照してください。

## 懸念事項と質問

テレメトリについて懸念がある場合は、[issue を作成する](https://github.com/zed-industries/zed/issues/new/choose) か、<hi@zed.dev> までメールでお問い合わせいただけます。
