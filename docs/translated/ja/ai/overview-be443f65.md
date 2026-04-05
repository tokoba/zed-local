# AI

Zed はオープンソースの AI コードエディタです。編集体験のあらゆる場面で AI が動作します。コードを読み書きするエージェント、インライン変換、キー入力ごとのコード補完、任意のバッファでのモデルとの対話などが含まれます。

## Zed の AI への取り組み

Zed の AI 機能は、Rust で構築されたネイティブな GPU アクセラレートアプリケーションの内部で動作します。あなたとモデル出力の間に Electron のレイヤーは存在しません。

- **Open source.** エディタとすべての AI 機能は [オープンソース](https://github.com/zed-industries/zed) です。AI がどのように実装されているか、データがプロバイダへどのように流れるか、ツール呼び出しがどのように実行されるかを確認できます。
- **Multi-model.** Zed がホストするモデルを使うことも、Anthropic、OpenAI、Google、Ollama など 8 つ以上のプロバイダからの [独自の API キーを利用する](./llm-providers.md) こともできます。ローカルモデルを実行したり、クラウド API に接続したり、その両方を組み合わせたりできます。タスクごとにモデルを切り替えられます。
- **External agents.** Claude Agent、Gemini CLI、Codex などの CLI ベースのエージェントを、[Agent Client Protocol](https://zed.dev/acp) を通じて Zed 上で直接実行できます。[External Agents](./external-agents.md) を参照してください。
- **Privacy by default.** AI データの共有はオプトイン方式です。独自の API キーを使用する場合、Zed はプロバイダとゼロデータ保持契約を結びます。[Privacy and Security](./privacy-and-security.md) を参照してください。

## エージェント駆動型の編集

[Agent Panel](./agent-panel.md) は、AI エージェントと作業する場所です。エージェントはファイルの読み取り、コードの編集、ターミナルコマンドの実行、ウェブ検索、[組み込みツール](./tools.md) を通じた診断情報へのアクセスができます。

エージェントは [MCP servers](./mcp.md) を通じて追加ツールで拡張でき、[tool permissions](./tool-permissions.md) によってアクセス可能な範囲を制御し、[rules](./rules.md) によって振る舞いを調整できます。

[Inline Assistant](./inline-assistant.md) は少し異なる動作をします。コードまたはターミナルコマンドを選択し、望む内容を説明すると、モデルがその選択範囲をその場で書き換えます。マルチカーソルにも対応しています。

## Code completions

[Edit Prediction](./edit-prediction.md) は、キー入力ごとに AI によるコード補完を提供します。キーを押すたびに予測プロバイダへリクエストが送信され、1 行または複数行の候補が返されます。候補は `tab` で確定します。

デフォルトのプロバイダは、Zed のオープンデータで学習されたオープンソースモデルである Zeta です。GitHub Copilot や Codestral も利用できます。

## Getting started

- [Configuration](./configuration.md): Anthropic、OpenAI、Ollama、Google AI などの LLM プロバイダに接続します。
- [External Agents](./external-agents.md): Claude Agent、Codex、Aider などの外部エージェントを Zed 内で実行します。
- [Subscription](./subscription.md): Zed がホストするモデルと課金について。
- [Privacy and Security](./privacy-and-security.md): AI 機能を使用する際の Zed によるデータの取り扱い方法。

Zed を初めて使用しますか？ まずは [Getting Started](../getting-started.md) から始め、その後ここに戻って AI を設定してください。より高レベルな概要については、[zed.dev/ai](https://zed.dev/ai) を参照してください。
