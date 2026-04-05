# Zed の AI 機能とプライバシー

## 概要

Zed の AI 機能には次のものがあります:

- [Agent Panel](./agent-panel.md)
- [Edit Predictions](./edit-prediction.md)
- [Inline Assist](./inline-assistant.md)
- Git コミットメッセージの自動生成

デフォルトでは、Zed はあなたのプロンプトやコードコンテキストを保存しません。これらのデータは、応答を生成するために、あなたが選択した AI プロバイダー（Anthropic、OpenAI、Google、xAI など）に送信され、その後破棄されます。あなたが明示的に共有しない限り（[AI Feedback with Ratings](#ai-feedback-with-ratings) を参照）、または edit prediction の学習データ収集にオプトインしない限り（[Edit Predictions](#edit-predictions) を参照）、Zed が AI 機能の評価や改善のためにあなたのデータを利用することはありません。

Zed は設計上モデルに依存しておらず、どのプロバイダーを選択しても上記の点は変わりません。独自の API キーや Zed がホストするモデルを利用しても、データが保持されることはありません。

### データ保持と学習

Zed の Agent Panel は次の方法で利用できます:

- [Zed がホストするモデル](./subscription.md)
- [API キーを使用して Zed 以外の AI サービスに接続する](./llm-providers.md)
- ACP を通じて [外部エージェント](./external-agents.md) を使用する

Zed がホストするモデルを利用する場合、ユーザーコンテンツがモデルの学習に使用されないことをサービスプロバイダーに保証してもらうよう求めています。

| プロバイダー | 学習に使用しない保証                                   | ゼロデータ保持 (ZDR)                                                                                                                     |
| --------- | ------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------- |
| Anthropic | [はい](https://www.anthropic.com/legal/commercial-terms) | [はい](https://privacy.anthropic.com/en/articles/8956058-i-have-a-zero-data-retention-agreement-with-anthropic-what-products-does-it-apply-to) |
| Google    | [はい](https://cloud.google.com/terms/service-terms)     | [はい](https://cloud.google.com/terms/service-terms)、Service Terms のセクション 17 および 19h を参照してください                          |
| OpenAI    | [はい](https://openai.com/enterprise-privacy/)           | [はい](https://platform.openai.com/docs/guides/your-data)                                                                                |
| xAI       | [はい](https://x.ai/legal/faq-enterprise)                | [はい](https://x.ai/legal/faq-enterprise)                                                                                                |

独自の API キーや外部エージェントを使用する場合、**Zed はそのサービスプロバイダーによるデータの利用方法を制御できません。** 適用される条件を理解するために、それぞれのサービスプロバイダーとの契約内容を確認してください。

### 評価による AI フィードバック

Zed 内で特定の AI 応答を評価し、その会話に関連する詳細を Zed と共有することで、Zed の AI 機能に関するフィードバックを提供できます。各共有はオプトインであり、一度共有しても、今後のコンテンツやデータが継続的に共有されることはありません。

> **評価 = データ共有:** 応答を評価すると、その会話スレッド全体が Zed に送信されます。これにはメッセージ、AI の応答、スレッドのメタデータが含まれます。  
> ***Zed のサーバー上にデータを永続的に保存されたくない場合は、評価しないでください***。あなたが明示的に応答を評価しない限り、AI 機能を改善するためのデータを収集することはありません。

### 収集されるデータ（AI フィードバック）

評価を通じてあなたが明示的に共有した会話について、Zed は次のものを保存する場合があります:

- スレッド内のすべてのメッセージ（あなたのプロンプトと AI 応答）
- 評価時に入力したコメント
- スレッドのメタデータ（使用モデル、トークン数、タイムスタンプ）
- あなたの Zed インストールに関するメタデータ

応答を評価しない場合、Zed は AI 機能の利用に関連する Customer Data（コード、会話、応答）を保存しません。

Zed の AI 機能に関連するテレメトリーは収集されます。これには、使用されている AI 機能や、その機能のパフォーマンスを把握するための高レベルなインタラクションに関するメタデータ（例: Agent の応答時間、Agent Panel での編集の受け入れ/拒否、または編集完了）などが含まれます。詳細は Zed の [テレメトリー](../telemetry.md) ドキュメントを参照してください。

収集されたデータは、プライベートデータベースである Snowflake に保存されます。私たちはこのデータを定期的にレビューし、エージェントのシステムプロンプトやツールの利用方法を改善します。すべてのデータは匿名化され、機密情報（アクセストークン、ユーザー ID、メールアドレス）は削除されます。

## Edit Predictions

Edit predictions は、**Zed の Zeta モデル** または GitHub Copilot のような **サードパーティプロバイダー** によって提供されます。

### Zed の Zeta モデル（デフォルト）

予測を生成するために、Zed は制限されたコンテキストウィンドウをモデルに送信します:

- カーソル周辺のコード抜粋（ファイル全体ではありません）
- 最近の編集（diff として）
- 関連する開いているファイルからの関連抜粋

これらのデータは予測を生成するために一時的に処理され、その後は保持されません。

### サードパーティプロバイダー

GitHub Copilot のようなサードパーティプロバイダーを使用する場合、そのプロバイダーによるデータの取り扱いについては **Zed が制御することはできません**。詳細については、各プロバイダーの利用規約を直接確認してください。

注: Zed の `disabled_globs` 設定により予測のリクエストは行われなくなりますが、ファイルを開いた際にサードパーティプロバイダーがファイル内容を受け取る場合があります。

### 学習データ: オープンソースプロジェクトでのオプトイン

以下の条件が満たされない限り、Zed は edit prediction モデルの学習データを収集しません:

1. **あなたがオプトインすること** – ステータスバーの edit prediction アイコンをクリックし、edit prediction ステータスバーメニューの **Privacy** セクションにある「Training Data Collection」を切り替えます。
2. **プロジェクトがオープンソースであること** — LICENSE ファイルによって検出されます（[検出ロジックはこちら](https://github.com/zed-industries/zed/blob/main/crates/edit_prediction/src/license_detection.rs)）。
3. **ファイルが除外されていないこと** — `disabled_globs` によって制御されます

### ファイルの除外

特定のファイルは、オプトインの状態に関係なく常に edit predictions から除外されます:

```json [settings]
{
  "edit_predictions": {
    "disabled_globs": [
      "**/.env*",
      "**/*.pem",
      "**/*.key",
      "**/*.cert",
      "**/*.crt",
      "**/secrets.yml"
    ]
  }
}
```

ユーザーは、Zed の設定ファイル内の [`edit_predictions.disabled_globs`](https://zed.dev/docs/reference/all-settings#edit-predictions) にパスやファイル拡張子を追加することで、さらに除外対象を明示的に指定できます（[設定ファイルの編集方法](../configuring-zed.md#settings-files)）。

```json [settings]
{
  "edit_predictions": {
    "disabled_globs": ["secret_dir/*", "**/*.log"]
  }
}
```

### 収集されるデータ（edit prediction 学習データ）

オープンソースプロジェクトでオプトインしている場合、Zed は次のデータを収集する場合があります:

- カーソル周辺のコード抜粋
- 最近の編集の diff
- 生成された予測
- リポジトリの URL と git リビジョン
- バッファのアウトラインおよび診断情報

収集されたデータは Snowflake に保存されます。私たちはこのデータを定期的にレビューし、モデルの学習用データセットに含める学習サンプルを選定します。含まれるデータはすべて匿名化され、機密情報（アクセストークン、ユーザー ID、メールアドレスなど）が含まれていないことを確認しています。この学習データセットは [huggingface.co/datasets/zed-industries/zeta](https://huggingface.co/datasets/zed-industries/zeta) で一般公開されています。

### モデル出力

その後、この学習データセットを使用して [Qwen2.5-Coder-7B](https://huggingface.co/Qwen/Qwen2.5-Coder-7B) をファインチューニングし、その結果得られたモデルを [huggingface.co/zed-industries/zeta](https://huggingface.co/zed-industries/zeta) で公開しています。

## 適用される規約

詳細は [Zed 利用規約](https://zed.dev/terms) を参照してください。
