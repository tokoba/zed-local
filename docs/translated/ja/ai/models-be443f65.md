# モデル

Zed のプランでは、主要な LLM のホスト版を、直接の API アクセスよりも高いレート制限で提供します。モデルの提供状況は定期的に更新されます。代わりに自分の API キーを使用するには、[LLM Providers](./llm-providers.md) を参照してください。一般的なセットアップについては、[Configuration](./configuration.md) を参照してください。

| モデル                  | プロバイダー  | トークン種別              | プロバイダーの 100 万トークンあたりの価格 | Zed の 100 万トークンあたりの価格 |
| ---------------------- | --------- | ----------------------- | ---------------------------- | ----------------------- |
| Claude Opus 4.5        | Anthropic | 入力                     | $5.00                        | $5.50                   |
|                        | Anthropic | 出力                     | $25.00                       | $27.50                  |
|                        | Anthropic | 入力 - キャッシュ書き込み | $6.25                        | $6.875                  |
|                        | Anthropic | 入力 - キャッシュ読み取り | $0.50                        | $0.55                   |
| Claude Opus 4.6        | Anthropic | 入力                     | $5.00                        | $5.50                   |
|                        | Anthropic | 出力                     | $25.00                       | $27.50                  |
|                        | Anthropic | 入力 - キャッシュ書き込み | $6.25                        | $6.875                  |
|                        | Anthropic | 入力 - キャッシュ読み取り | $0.50                        | $0.55                   |
| Claude Sonnet 4.5      | Anthropic | 入力                     | $3.00                        | $3.30                   |
|                        | Anthropic | 出力                     | $15.00                       | $16.50                  |
|                        | Anthropic | 入力 - キャッシュ書き込み | $3.75                        | $4.125                  |
|                        | Anthropic | 入力 - キャッシュ読み取り | $0.30                        | $0.33                   |
| Claude Sonnet 4.6      | Anthropic | 入力                     | $3.00                        | $3.30                   |
|                        | Anthropic | 出力                     | $15.00                       | $16.50                  |
|                        | Anthropic | 入力 - キャッシュ書き込み | $3.75                        | $4.125                  |
|                        | Anthropic | 入力 - キャッシュ読み取り | $0.30                        | $0.33                   |
| Claude Haiku 4.5       | Anthropic | 入力                     | $1.00                        | $1.10                   |
|                        | Anthropic | 出力                     | $5.00                        | $5.50                   |
|                        | Anthropic | 入力 - キャッシュ書き込み | $1.25                        | $1.375                  |
|                        | Anthropic | 入力 - キャッシュ読み取り | $0.10                        | $0.11                   |
| GPT-5.2                | OpenAI    | 入力                     | $1.25                        | $1.375                  |
|                        | OpenAI    | 出力                     | $10.00                       | $11.00                  |
|                        | OpenAI    | キャッシュ済み入力       | $0.125                       | $0.1375                 |
| GPT-5.2 Codex          | OpenAI    | 入力                     | $1.25                        | $1.375                  |
|                        | OpenAI    | 出力                     | $10.00                       | $11.00                  |
|                        | OpenAI    | キャッシュ済み入力       | $0.125                       | $0.1375                 |
| GPT-5 mini             | OpenAI    | 入力                     | $0.25                        | $0.275                  |
|                        | OpenAI    | 出力                     | $2.00                        | $2.20                   |
|                        | OpenAI    | キャッシュ済み入力       | $0.025                       | $0.0275                 |
| GPT-5 nano             | OpenAI    | 入力                     | $0.05                        | $0.055                  |
|                        | OpenAI    | 出力                     | $0.40                        | $0.44                   |
|                        | OpenAI    | キャッシュ済み入力       | $0.005                       | $0.0055                 |
| Gemini 3.1 Pro         | Google    | 入力                     | $2.00                        | $2.20                   |
|                        | Google    | 出力                     | $12.00                       | $13.20                  |
| Gemini 3 Flash         | Google    | 入力                     | $0.30                        | $0.33                   |
|                        | Google    | 出力                     | $2.50                        | $2.75                   |
| Grok 4                 | X.ai      | 入力                     | $3.00                        | $3.30                   |
|                        | X.ai      | 出力                     | $15.00                       | $16.5                   |
|                        | X.ai      | キャッシュ済み入力       | $0.75                        | $0.825                  |
| Grok 4 Fast            | X.ai      | 入力                     | $0.20                        | $0.22                   |
|                        | X.ai      | 出力                     | $0.50                        | $0.55                   |
|                        | X.ai      | キャッシュ済み入力       | $0.05                        | $0.055                  |
| Grok 4 (Non-Reasoning) | X.ai      | 入力                     | $0.20                        | $0.22                   |
|                        | X.ai      | 出力                     | $0.50                        | $0.55                   |
|                        | X.ai      | キャッシュ済み入力       | $0.05                        | $0.055                  |
| Grok Code Fast 1       | X.ai      | 入力                     | $0.20                        | $0.22                   |
|                        | X.ai      | 出力                     | $1.50                        | $1.65                   |
|                        | X.ai      | キャッシュ済み入力       | $0.02                        | $0.022                  |

## 最近廃止されたモデル

2026 年 2 月 19 日時点で、Zed Pro は以下の廃止されたモデルの代わりに新しいバージョンのモデルを提供します。

- Claude Opus 4.1 → Claude Opus 4.5 または Claude Opus 4.6
- Claude Sonnet 4 → Claude Sonnet 4.5 または Claude Sonnet 4.6
- Claude Sonnet 3.7 (retired Feb 19) → Claude Sonnet 4.5 または Claude Sonnet 4.6
- GPT-5.1 および GPT-5 → GPT-5.2 または GPT-5.2 Codex
- Gemini 2.5 Pro → Gemini 3.1 Pro
- Gemini 3 Pro → Gemini 3.1 Pro
- Gemini 2.5 Flash → Gemini 3 Flash

## 利用方法 {#usage}

Zed がホストするモデルの利用はすべて、Zed の価格（上記の最右列）で課金されます。Zed のプランおよびホストモデル利用の制限の詳細については、[Plans and Usage](./plans-and-usage.md) を参照してください。

> LLM は、ユーザーによる介入が必要となる非生産的なループに陥ることがあります。長時間実行されるタスクは監視し、必要に応じて中断してください。

## コンテキストウィンドウ {#context-windows}

```
コンテキストウィンドウとは、LLM が一度に考慮できるテキストおよびコードの最大範囲のことで、入力プロンプトとモデルによって生成される出力の両方を含みます。

| Model             | Provider  | Zed-Hosted Context Window |
| ----------------- | --------- | ------------------------- |
| Claude Opus 4.5   | Anthropic | 200k                      |
| Claude Opus 4.6   | Anthropic | 1M                        |
| Claude Sonnet 4.5 | Anthropic | 200k                      |
| Claude Sonnet 4.6 | Anthropic | 1M                        |
| Claude Haiku 4.5  | Anthropic | 200k                      |
| GPT-5.2           | OpenAI    | 400k                      |
| GPT-5.2 Codex     | OpenAI    | 400k                      |
| GPT-5 mini        | OpenAI    | 400k                      |
| GPT-5 nano        | OpenAI    | 400k                      |
| Gemini 3.1 Pro    | Google    | 200k                      |
| Gemini 3 Flash    | Google    | 200k                      |

> ホスト型 Gemini 3.1 Pro/3 Pro/Flash のコンテキストウィンドウの上限は、今後のリリースで増加する可能性があります。

Zed の各 Agent スレッドは、それぞれ独自のコンテキストウィンドウを維持します。
セッションに含まれるプロンプト、添付ファイル、応答が多いほど、コンテキストウィンドウは大きくなります。

コンテキストを明確に保つために、タスクごとに新しいスレッドを開始してください。

## ツール呼び出し {#tool-calls}

モデルは、コードと連携したり、Web を検索したり、その他の有用な機能を実行するために [ツール](./tools.md) を使用できます。
