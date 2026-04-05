# LLM プロバイダー

Zed で AI を利用するには、少なくとも 1 つの大規模言語モデル (LLM) プロバイダーを設定する必要があります。設定が完了すると、プロバイダーは [Agent Panel](./agent-panel.md) や [Inline Assistant](./inline-assistant.md) から利用できるようになります。

これは、[Zed のいずれかのプラン](./plans-and-usage.md) を購読するか、対応プロバイダー向けに既に持っている API キーを使用することで行えます。AI の一般的なセットアップについては [Configuration](./configuration.md) を参照してください。

## 自分のキーを使用する {#use-your-own-keys}

Anthropic や OpenAI などのプロバイダー用の API キーを既に持っている場合は、それを Zed に追加できます。Zed のサブスクリプションは不要です。

既存の API キーを特定のプロバイダーに追加するには、Agent Panel の設定 (`agent: open settings`) を開き、目的のプロバイダーを探し、入力欄にキーを貼り付けて Enter キーを押してください。

> 注意: API キーは設定ファイル内にプレーンテキストとして保存されることは *なく*、OS の安全な認証情報ストレージに保存されます。

## 対応プロバイダー

Zed は以下のプロバイダーを、自前の API キーを使って利用できます:

- [Amazon Bedrock](#amazon-bedrock)
- [Anthropic](#anthropic)
- [DeepSeek](#deepseek)
- [GitHub Copilot Chat](#github-copilot-chat)
- [Google AI](#google-ai)
- [LM Studio](#lmstudio)
- [Mistral](#mistral)
- [Ollama](#ollama)
- [OpenAI](#openai)
- [OpenAI API Compatible](#openai-api-compatible)
- [OpenRouter](#openrouter)
- [Vercel AI Gateway](#vercel-ai-gateway)
- [Vercel](#vercel-v0)
- [xAI](#xai)

### Amazon Bedrock {#amazon-bedrock}

> ストリーミングでのツール利用をサポートするモデルに対して、ツール利用をサポートしています。
> 詳細は [Amazon Bedrock の Tool Use ドキュメント](https://docs.aws.amazon.com/bedrock/latest/userguide/conversation-inference-supported-models-features.html) を参照してください。

Amazon Bedrock のモデルを使用するには、AWS の認証が必要です。
使用する認証情報に、次の権限が設定されていることを確認してください:

- `bedrock:InvokeModelWithResponseStream`
- `bedrock:InvokeModel`

IAM ポリシーは次のようになります:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "bedrock:InvokeModel",
        "bedrock:InvokeModelWithResponseStream"
      ],
      "Resource": "*"
    }
  ]
}
```

これが完了したら、以下の 3 つの認証方法のいずれかを選択します:

#### Named Profile による認証 (推奨)

1. AWS CLI がインストールされており、Named Profile が設定されていることを確認します。
2. 設定ファイル (`zed: open settings file`) を開き、`language_models` の下に `bedrock` キーを次の設定で追加します:

   ```json [settings]
   {
     "language_models": {
       "bedrock": {
         "authentication_method": "named_profile",
         "region": "your-aws-region",
         "profile": "your-profile-name"
       }
     }
   }
   ```

#### Static Credentials による認証

AWS アクセスキーとシークレットを直接入力して Agent Panel の設定 UI から構成することも可能ですが、より良いセキュリティの観点から、代わりに Named Profile を使用することを推奨します。
手順は次のとおりです:

1. [IAM Console](https://us-east-1.console.aws.amazon.com/iam/home?region=us-east-1#/users) で IAM ユーザーを作成します。
2. そのユーザーのセキュリティ認証情報を作成し、保存して安全に保管します。
3. `agent: open settings` で Agent Configuration を開き、Amazon Bedrock セクションに移動します。
4. 手順 2 で取得した認証情報を、それぞれ **Access Key ID**、**Secret Access Key**、**Region** フィールドにコピーします。

#### Bedrock API Key による認証

Amazon Bedrock は [API Keys](https://docs.aws.amazon.com/bedrock/latest/userguide/api-keys-use.html) による認証にも対応しており、IAM ユーザーや Named Profile を必要とせずに直接認証できます。

1. [Amazon Bedrock Console](https://console.aws.amazon.com/bedrock/) で API キーを作成します。
2. `agent: open settings` で Agent Configuration を開き、Amazon Bedrock セクションに移動します。
3. **API Key** フィールドに Bedrock の API キーを入力し、**Region** を選択します。

```json [settings]
{
  "language_models": {
    "bedrock": {
      "authentication_method": "api_key",
      "region": "your-aws-region"
    }
  }
}
```

API キー自体は設定ファイルではなく、OS のキーチェーン内に安全に保存されます。

#### Cross-Region Inference

Zed における Amazon Bedrock の実装は、可用性とスループットを向上させるために [Cross-Region inference](https://docs.aws.amazon.com/bedrock/latest/userguide/cross-region-inference.html) を利用します。
Cross-Region inference を使用すると、複数の AWS リージョンにトラフィックを分散でき、より高いスループットを実現できます。

##### Regional プロファイル vs Global プロファイル

Bedrock は 2 種類のクロスリージョン推論プロファイルをサポートしています:

- **Regional profiles** (デフォルト): 特定の地域 (US、EU、APAC) 内でリクエストをルーティングします。たとえば、`us-east-1` は `us-east-1`、`us-east-2`、`us-west-2` 間でルーティングする `us.*` プロファイルを使用します。
- **Global profiles**: すべての商用 AWS リージョンにリクエストをルーティングし、最大限の可用性とパフォーマンスを提供します。

デフォルトでは、Zed はデータを同一地域内に保持する **regional profiles** を使用します。Bedrock の設定に `"allow_global": true` を追加することで、global profiles を有効化できます:

```json [settings]
{
  "language_models": {
    "bedrock": {
      "authentication_method": "named_profile",
      "region": "your-aws-region",
      "profile": "your-profile-name",
      "allow_global": true
    }
  }
}
```

**注意:** 一部の新しいモデルのみが global inference profiles をサポートしています。現在 global inference をサポートしているモデルの一覧については、[AWS Bedrock supported models documentation](https://docs.aws.amazon.com/bedrock/latest/userguide/inference-profiles-support.html#inference-profiles-support-system) を参照してください。お使いのリージョンで特定のモデルの可用性に問題がある場合、`allow_global` を有効にすることで解決できる場合があります。

データはソースリージョンにのみ保存されますが、Cross-Region inference 中には、入力プロンプトや出力結果がソースリージョン外に移動する可能性があります。
すべてのデータは、Amazon の安全なネットワーク上で暗号化されて送信されます。

各モデルに対する Cross-Region inference のサポートはベストエフォートで提供します。[Cross-Region Inference method Code](https://github.com/zed-industries/zed/blob/main/crates/bedrock/src/models.rs#L297) を参照してください。

最新の対応リージョンおよびモデルについては、[Supported Models and Regions for Cross Region inference](https://docs.aws.amazon.com/bedrock/latest/userguide/inference-profiles-support.html) を参照してください。

#### 拡張コンテキストウィンドウ {#bedrock-extended-context}

Bedrock 上の Anthropic モデルは、`anthropic_beta` API パラメーターを使用して 100 万トークンの拡張コンテキストウィンドウをサポートします。この機能を有効にするには、Bedrock の設定で `"allow_extended_context": true` を指定します:

```json [settings]
{
  "language_models": {
    "bedrock": {
      "authentication_method": "named_profile",
      "region": "your-aws-region",
      "profile": "your-profile-name",
      "allow_extended_context": true
    }
  }
}
```

Zed は、対応モデル (Claude Sonnet 4.5 および Claude Opus 4.6) に対して拡張コンテキストを有効にします。拡張コンテキストを使用すると API コストが増加する可能性があります。詳細は AWS Bedrock の料金表を参照してください。

#### 画像サポート {#bedrock-image-support}

ビジョンに対応した Bedrock モデル（Claude 3 以降、Amazon Nova Pro および Lite、Meta Llama 3.2 Vision モデル、Mistral Pixtral）は、会話やツールの結果として画像を受け取ることができます。

### Anthropic {#anthropic}

Agent Panel のモデルドロップダウンから選択することで、Anthropic のモデルを利用できます。

1. Anthropic にサインアップし、[API キーを作成](https://console.anthropic.com/settings/keys)します
2. Anthropic アカウントにクレジットがあることを確認します
3. 設定ビュー（`agent: open settings`）を開き、Anthropic セクションに移動します
4. Anthropic の API キーを入力します

Claude Pro を契約している場合でも、API 経由で利用するには[追加クレジットを支払う](https://console.anthropic.com/settings/plans)必要があります。

Zed は、`ANTHROPIC_API_KEY` 環境変数が定義されている場合は、その値も使用します。

#### カスタムモデル {#anthropic-custom-models}

以下を Zed の設定ファイル（[編集方法](../configuring-zed.md#settings-files)）に追加することで、Anthropic プロバイダーにカスタムモデルを追加できます。

```json [settings]
{
  "language_models": {
    "anthropic": {
      "available_models": [
        {
          "name": "claude-3-5-sonnet-20240620",
          "display_name": "Sonnet 2024-June",
          "max_tokens": 128000,
          "max_output_tokens": 2560,
          "cache_configuration": {
            "max_cache_anchors": 10,
            "min_total_token": 10000,
            "should_speculate": false
          },
          "tool_override": "some-model-that-supports-toolcalling"
        }
      ]
    }
  }
}
```

カスタムモデルは Agent Panel のモデルドロップダウンに表示されます。

モデルの設定で mode を `thinking` に変更することで、（モデルが対応している場合は）[extended thinking](https://docs.anthropic.com/en/docs/about-claude/models/extended-thinking-models) を利用するように構成できます。例:

```json
{
  "name": "claude-sonnet-4-latest",
  "display_name": "claude-sonnet-4-thinking",
  "max_tokens": 200000,
  "mode": {
    "type": "thinking",
    "budget_tokens": 4096
  }
}
```

### DeepSeek {#deepseek}

1. DeepSeek プラットフォームにアクセスし、[API キーを作成](https://platform.deepseek.com/api_keys)します
2. 設定ビュー（`agent: open settings`）を開き、DeepSeek セクションに移動します
3. DeepSeek の API キーを入力します

DeepSeek の API キーはキーチェーンに保存されます。

Zed は、`DEEPSEEK_API_KEY` 環境変数が定義されている場合は、その値も使用します。

#### カスタムモデル {#deepseek-custom-models}

Zed agent には、一般的なモデル（DeepSeek Chat、DeepSeek Reasoner）の最新版を使用するよう、あらかじめ設定がされています。
別のモデルを使用したい場合や、API エンドポイントをカスタマイズしたい場合は、次の設定を Zed の設定ファイル（[編集方法](../configuring-zed.md#settings-files)）に追加します。

```json [settings]
{
  "language_models": {
    "deepseek": {
      "api_url": "https://api.deepseek.com",
      "available_models": [
        {
          "name": "deepseek-chat",
          "display_name": "DeepSeek Chat",
          "max_tokens": 64000
        },
        {
          "name": "deepseek-reasoner",
          "display_name": "DeepSeek Reasoner",
          "max_tokens": 64000,
          "max_output_tokens": 4096
        }
      ]
    }
  }
}
```

カスタムモデルは Agent Panel のモデルドロップダウンに表示されます。
また、必要に応じて `api_url` を変更してカスタムエンドポイントを使用することもできます。

### GitHub Copilot Chat {#github-copilot-chat}

Agent Panel のモデルドロップダウンから選択することで、Zed agent で GitHub Copilot Chat を利用できます。

1. 設定ビュー（`agent: open settings`）を開き、GitHub Copilot Chat セクションに移動します
2. `Sign in to use GitHub Copilot` をクリックし、モーダルに表示される手順に従います

別の方法として、`GH_COPILOT_TOKEN` 環境変数を通じて OAuth トークンを指定することもできます。

> **注意**: ドロップダウンに特定のモデルが表示されない場合は、[GitHub Copilot 設定](https://github.com/settings/copilot/features)でそれらを有効化する必要があるかもしれません。

Zed で Copilot Enterprise（agent と補完の両方）を使用するには、[Configuring GitHub Copilot Enterprise](./edit-prediction.md#github-copilot-enterprise) に記載されているとおりにエンタープライズエンドポイントを設定する必要があります。

### Google AI {#google-ai}

Agent Panel のモデルドロップダウンから選択することで、Zed agent で Gemini モデルを利用できます。

1. Google AI Studio サイトにアクセスし、[API キーを作成](https://aistudio.google.com/app/apikey)します。
2. 設定ビュー（`agent: open settings`）を開き、Google AI セクションに移動します
3. Google AI API キーを入力し、Enter キーを押します。

Google AI API キーはキーチェーンに保存されます。

また、`GEMINI_API_KEY` 環境変数が定義されている場合、Zed はその値も使用します。詳細は Gemini ドキュメントの [Using Gemini API keys](https://ai.google.dev/gemini-api/docs/api-key) を参照してください。

#### カスタムモデル {#google-ai-custom-models}

デフォルトでは、Zed はモデルの `stable` バージョンを使用しますが、[experimental models](https://ai.google.dev/gemini-api/docs/models/experimental-models) を含む特定バージョンのモデルを使用することもできます。モデルに `mode` 設定を追加することで、（モデルが対応している場合は）[thinking mode](https://ai.google.dev/gemini-api/docs/thinking) を使用するように構成できます。これは、推論トークンの使用量やレスポンス速度を制御するのに役立ちます。指定しなかった場合、thinking budget は Gemini が自動的に決定します。

以下は、Zed の設定ファイル（[編集方法](../configuring-zed.md#settings-files)）に追加できるカスタム Google AI モデルの例です。

```json [settings]
{
  "language_models": {
    "google": {
      "available_models": [
        {
          "name": "gemini-3.1-pro-preview",
          "display_name": "Gemini 3.1 Pro",
          "max_tokens": 1000000,
          "mode": {
            "type": "thinking",
            "budget_tokens": 24000
          }
        },
        {
          "name": "gemini-3-flash-preview",
          "display_name": "Gemini 3 Flash (Thinking)",
          "max_tokens": 1000000,
          "mode": {
            "type": "thinking",
            "budget_tokens": 24000
          }
        }
      ]
    }
  }
}
```

カスタムモデルは Agent Panel のモデルドロップダウンに表示されます。

### LM Studio {#lmstudio}

1. [LM Studio の最新バージョン](https://lmstudio.ai/download)をダウンロードしてインストールします
2. アプリ内で `cmd/ctrl-shift-m` を押し、少なくとも 1 つのモデル（例: qwen2.5-coder-7b）をダウンロードします。あるいは、LM Studio CLI を使ってモデルを取得することもできます:

   ```sh
   lms get qwen2.5-coder-7b
   ```

3. 次を実行して、LM Studio API サーバーが起動していることを確認します:

   ```sh
   lms server start
   ```

ヒント: LM Studio サーバーの起動を自動化するには、[LM Studio をログイン項目として設定](https://lmstudio.ai/docs/advanced/headless#run-the-llm-service-on-machine-login)してください。

### Mistral {#mistral}

1. Mistral プラットフォームにアクセスし、[API キーを作成](https://console.mistral.ai/api-keys/)します
2. 設定ビュー（`agent: open settings`）を開き、Mistral セクションに移動します
3. Mistral の API キーを入力します

Mistral の API キーはキーチェーンに保存されます。

Zed は、`MISTRAL_API_KEY` 環境変数が定義されている場合は、その値も使用します。

#### カスタムモデル {#mistral-custom-models}

Zed エージェントには、あらかじめ複数の Mistral モデル (codestral-latest、mistral-large-latest、mistral-medium-latest、mistral-small-latest、open-mistral-nemo、open-codestral-mamba) が設定されています。
すべてのデフォルトモデルはツールの使用をサポートしています。
別のモデルを使用したい場合やパラメーターをカスタマイズしたい場合は、次の内容を Zed の設定ファイルに追加してください（[編集方法](../configuring-zed.md#settings-files)）。

```json [settings]
{
  "language_models": {
    "mistral": {
      "api_url": "https://api.mistral.ai/v1",
      "available_models": [
        {
          "name": "mistral-tiny-latest",
          "display_name": "Mistral Tiny",
          "max_tokens": 32000,
          "max_output_tokens": 4096,
          "max_completion_tokens": 1024,
          "supports_tools": true,
          "supports_images": false
        }
      ]
    }
  }
}
```

カスタムモデルは、エージェントパネルのモデルのドロップダウンに表示されます。

### Ollama {#ollama}

Linux または macOS の場合は [ollama.com/download](https://ollama.com/download) から Ollama をダウンロードしてインストールし、`ollama --version` を実行して動作していることを確認します。

1. [利用可能なモデル](https://ollama.com/models) のいずれかをダウンロードします。例として、`mistral` の場合:

   ```sh
   ollama pull mistral
   ```

2. Ollama サーバーが動作していることを確認します。macOS の場合は Ollama.app を実行するか、次のコマンドで起動できます:

   ```sh
   ollama serve
   ```

3. エージェントパネルで、モデルのドロップダウンからいずれかの Ollama モデルを選択します。

#### Ollama の自動検出

Zed は、Ollama が取得したモデルを自動的に検出します。これを無効にするには、Ollama 設定の
`auto_discover` フィールドを設定します。そうした場合は、利用可能な
モデルを手動で指定する必要があります。

```json [settings]
{
  "language_models": {
    "ollama": {
      "api_url": "http://localhost:11434",
      "auto_discover": false,
      "available_models": [
        {
          "name": "qwen2.5-coder",
          "display_name": "qwen 2.5 coder",
          "max_tokens": 32768,
          "supports_tools": true,
          "supports_thinking": true,
          "supports_images": true
        }
      ]
    }
  }
}
```

#### Ollama のコンテキスト長 {#ollama-context}

Ollama への Zed の API リクエストには、`num_ctx` パラメーターとしてコンテキスト長が含まれます。デフォルトでは、Zed はすべての Ollama モデルに対してコンテキスト長 `4096` トークンを使用します。

> **注意**: エージェントパネルに表示されるトークン数はあくまで推定値であり、モデル固有のトークナイザーが算出する値とは異なります。

すべての Ollama モデルに対するコンテキスト長は、`context_window` 設定で指定できます。これは Ollama プロバイダー設定の UI からも構成できます。

```json [settings]
{
  "language_models": {
    "ollama": {
      "context_window": 8192
    }
  }
}
```

あるいは、`available_models` 内の `max_tokens` フィールドを使用して、モデルごとにコンテキスト長を設定することもできます。

```json [settings]
{
  "language_models": {
    "ollama": {
      "api_url": "http://localhost:11434",
      "available_models": [
        {
          "name": "qwen2.5-coder",
          "display_name": "qwen 2.5 coder 32K",
          "max_tokens": 32768,
          "supports_tools": true,
          "supports_thinking": true,
          "supports_images": true
        }
      ]
    }
  }
}
```

> **注意**: `context_window` が設定されている場合、モデルごとの `max_tokens` の値よりも優先されます。

ハードウェアに対して大きすぎるコンテキスト長を指定した場合、Ollama はエラーをログに記録します。
これらのログは、macOS では `tail -f ~/.ollama/logs/ollama.log`、Linux では `journalctl -u ollama -f` を実行することで確認できます。
マシンで利用可能なメモリ容量に応じて、コンテキスト長をより小さい値に調整する必要がある場合があります。

また、各利用可能なモデルに対してオプションで `keep_alive` の値を指定することもできます。
これは整数（秒）でも、"5m"、"10m"、"1h"、"1d" などの文字列による時間指定でもかまいません。
たとえば `"keep_alive": "120s"` とすると、リモートサーバーは 120 秒後にモデルをアンロードし（GPU の VRAM を解放し）ます。

`supports_tools` オプションは、そのモデルが追加のツールを使用するかどうかを制御します。
モデルが Ollama カタログで `tools` タグ付きになっている場合は、このオプションを指定する必要があり、ビルトインプロファイルの `Ask` と `Write` が使用できます。
モデルが Ollama カタログで `tools` タグ付きになっていない場合でも、このオプションに `true` を指定できますが、その場合に動作するビルトインプロファイルは `Minimal` のみであることに注意してください。

`supports_thinking` オプションは、モデルが最終的な回答を生成する前に明示的な「思考」（推論）フェーズを実行するかどうかを制御します。
モデルが Ollama カタログで `thinking` タグ付きになっている場合は、このオプションを有効にすると Zed で利用できます。

`supports_images` オプションはモデルのビジョン機能を有効にし、会話コンテキストに含まれる画像を処理できるようにします。
モデルが Ollama カタログで `vision` タグ付きになっている場合は、このオプションを有効にすると Zed で利用できます。

#### Ollama の認証

通常は認証を必要としない自前のハードウェア上で Ollama を実行するだけでなく、Zed はリモートの Ollama インスタンスへの接続もサポートしています。後者では認証に API キーが必要です。

そのようなサービスの 1 つが [Ollama Turbo](https://ollama.com/turbo) です。Zed で Ollama Turbo を使用するには次のように設定します。

1. Ollama アカウントにサインインし、Ollama Turbo を購読します
2. [ollama.com/settings/keys](https://ollama.com/settings/keys) にアクセスして API キーを作成します
3. 設定ビュー (`agent: open settings`) を開き、Ollama セクションへ移動します
4. API キーを貼り付けて Enter キーを押します。
5. API URL として `https://ollama.com` を入力します

`OLLAMA_API_KEY` 環境変数が定義されている場合は、Zed はそれも使用します。

### OpenAI {#openai}

1. OpenAI プラットフォームにアクセスし、[API キーを作成します](https://platform.openai.com/account/api-keys)
2. OpenAI アカウントにクレジットがあることを確認します
3. 設定ビュー (`agent: open settings`) を開き、OpenAI セクションへ移動します
4. OpenAI の API キーを入力します

OpenAI の API キーはキーチェーンに保存されます。

`OPENAI_API_KEY` 環境変数が定義されている場合は、Zed はそれも使用します。

#### カスタムモデル {#openai-custom-models}

Zed エージェントには、一般的な OpenAI モデル (GPT-5.2、GPT-5 mini、GPT-5.2 Codex など) の最新版を使用するよう、あらかじめ設定が用意されています。
プレビューバージョンなど別のモデルを使用したい場合や、リクエストパラメーターを制御したい場合は、次の内容を Zed の設定ファイルに追加してください（[編集方法](../configuring-zed.md#settings-files)）。

```json [settings]
{
  "language_models": {
    "openai": {
      "available_models": [
        {
          "name": "gpt-5.2",
          "display_name": "gpt-5.2 high",
          "reasoning_effort": "high",
          "max_tokens": 272000,
          "max_completion_tokens": 20000
        },
        {
          "name": "gpt-5-nano",
          "display_name": "GPT-5 Nano",
          "max_tokens": 400000
        },
        {
          "name": "gpt-5.2-codex",
          "display_name": "GPT-5.2 Codex",
          "max_tokens": 128000,
          "capabilities": {
            "chat_completions": false
          }
        }
      ]
    }
  }
}
```

モデルのコンテキストウィンドウのサイズを `max_tokens` パラメーターで指定する必要があります。これは [OpenAI モデルのドキュメント](https://platform.openai.com/docs/models)で確認できます。

推論に特化したモデルでは、高い推論トークンコストが発生するのを避けるために、`max_completion_tokens` も設定してください。

モデルが `/chat/completions` エンドポイントをサポートしていない場合（例: `gpt-5.2-codex`）、`capabilities.chat_completions` を `false` に設定して無効化してください。Zed は代わりに Responses エンドポイントを使用します。

カスタムモデルは、Agent Panel のモデルドロップダウンに一覧表示されます。

### OpenAI API Compatible {#openai-api-compatible}

Zed では、OpenAI プロバイダーに対してカスタム `api_url` と `available_models` を指定することで、[OpenAI 互換 API](https://platform.openai.com/docs/api-reference/chat) を利用できます。
これは、Together AI や Anyscale などの他のホスト型サービスやローカルモデルに接続する際に便利です。

カスタムの OpenAI 互換モデルは、UI から追加するか、設定ファイルを編集することで追加できます。

UI から行うには、Agent Panel の設定（`agent: open settings`）を開き、「LLM Providers」セクションタイトルの右側にある「Add Provider」ボタンを探します。
次に、モーダル内の入力フィールドに必要事項を入力します。

設定ファイルから行うには（[編集方法](../configuring-zed.md#settings-files)）、`language_models` の下に次のスニペットを追加します。

```json [settings]
{
  "language_models": {
    "openai_compatible": {
      // 例として Together AI を使用
      "Together AI": {
        "api_url": "https://api.together.xyz/v1",
        "available_models": [
          {
            "name": "mistralai/Mixtral-8x7B-Instruct-v0.1",
            "display_name": "Together Mixtral 8x7B",
            "max_tokens": 32768,
            "capabilities": {
              "tools": true,
              "images": false,
              "parallel_tool_calls": false,
              "prompt_cache_key": false
            }
          }
        ]
      }
    }
  }
}
```

デフォルトでは、OpenAI 互換モデルは次の機能を継承します。

- `tools`: true（ツール／関数呼び出しをサポート）
- `images`: false（画像入力をサポートしない）
- `parallel_tool_calls`: false（`parallel_tool_calls` パラメーターをサポートしない）
- `prompt_cache_key`: false（`prompt_cache_key` パラメーターをサポートしない）
- `chat_completions`: true（`/chat/completions` エンドポイントを呼び出す）

プロバイダーが Responses API でのみ動作するモデルを提供している場合は、それらのエントリでは `chat_completions` を `false` に設定してください。Zed はこれらのモデルに対して Responses エンドポイントを使用します。

なお、LLM の API キーは設定ファイル内には保存されません。
そのため、設定で参照できるように、環境変数（`<PROVIDER_NAME>_API_KEY=<your api key>`）として設定しておいてください。上記の例では `TOGETHER_AI_API_KEY=<your api key>` となります。

### OpenRouter {#openrouter}

OpenRouter は、単一の API を通じて複数の AI モデルへアクセスできるサービスです。対応しているモデルではツールの利用もサポートしています。

1. [OpenRouter](https://openrouter.ai) にアクセスしてアカウントを作成する
2. [OpenRouter keys ページ](https://openrouter.ai/keys)で API キーを生成する
3. 設定ビュー（`agent: open settings`）を開き、OpenRouter セクションに移動する
4. OpenRouter の API キーを入力する

OpenRouter の API キーはキーチェーンに保存されます。

また、`OPENROUTER_API_KEY` 環境変数が定義されている場合は、Zed はそれも使用します。

OpenRouter をアシスタントプロバイダーとして使用する場合、設定でモデルを明示的に選択する必要があります。OpenRouter はデフォルトのモデル選択を提供しなくなりました。

好みの OpenRouter モデルを `settings.json` に設定します。

```json [settings]
{
  "agent": {
    "default_model": {
      "provider": "openrouter",
      "model": "openrouter/auto"
    }
  }
}
```

`openrouter/auto` モデルは、利用可能な中で最も適切なモデルへリクエストを自動的にルーティングします。OpenRouter の API から利用できる任意のモデルを指定することもできます。

#### Custom Models {#openrouter-custom-models}

Zed の設定ファイル（[編集方法](../configuring-zed.md#settings-files)）に次の内容を追加することで、OpenRouter プロバイダーにカスタムモデルを追加できます。

```json [settings]
{
  "language_models": {
    "open_router": {
      "api_url": "https://openrouter.ai/api/v1",
      "available_models": [
        {
          "name": "google/gemini-2.0-flash-thinking-exp",
          "display_name": "Gemini 2.0 Flash (Thinking)",
          "max_tokens": 200000,
          "max_output_tokens": 8192,
          "supports_tools": true,
          "supports_images": true,
          "mode": {
            "type": "thinking",
            "budget_tokens": 8000
          }
        }
      ]
    }
  }
}
```

各モデルで利用可能な設定オプションは次のとおりです。

- `name`（必須）: OpenRouter が使用するモデル識別子
- `display_name`（任意）: UI に表示される、人間が読みやすい名前
- `max_tokens`（必須）: モデルのコンテキストウィンドウサイズ
- `max_output_tokens`（任意）: モデルが生成できるトークン数の上限
- `max_completion_tokens`（任意）: completion トークンの上限
- `supports_tools`（任意）: モデルがツール／関数呼び出しをサポートするかどうか
- `supports_images`（任意）: モデルが画像入力をサポートするかどうか
- `mode`（任意）: thinking モデル向けの特別なモード設定

利用可能なモデルとその仕様は、[OpenRouter のモデルページ](https://openrouter.ai/models)で確認できます。

カスタムモデルは、Agent Panel のモデルドロップダウンに一覧表示されます。

#### Provider Routing

各モデルエントリの `provider` オブジェクトを通じて、OpenRouter が特定のカスタムモデルのリクエストを基盤となる上流プロバイダー間でどのようにルーティングするかを任意で制御できます。

サポートされているフィールド（すべて任意）:

- `order`: 優先して試すプロバイダー slug の配列（例: `["anthropic", "openai"]`）
- `allow_fallbacks`（デフォルト: `true`）: 優先プロバイダーが利用できない場合にフォールバックプロバイダーを使用してよいかどうか
- `require_parameters`（デフォルト: `false`）: 指定したすべてのパラメーターをサポートするプロバイダーのみを使用する
- `data_collection`（デフォルト: `allow`）: `"allow"` または `"disallow"`（データを保存する可能性のあるプロバイダーの利用を制御）
- `only`: このリクエストで許可されるプロバイダー slug のホワイトリスト
- `ignore`: スキップするプロバイダー slug
- `quantizations`: 特定の量子化バリアントに制限（例: `["int4","int8"]`）
- `sort`: 候補プロバイダーのソート戦略（例: `"price"` や `"throughput"`）

モデルにルーティングの優先設定を追加する例:

```json [settings]
{
  "language_models": {
    "open_router": {
      "api_url": "https://openrouter.ai/api/v1",
      "available_models": [
        {
          "name": "openrouter/auto",
          "display_name": "Auto Router (Tools Preferred)",
          "max_tokens": 2000000,
          "supports_tools": true,
          "provider": {
            "order": ["anthropic", "openai"],
            "allow_fallbacks": true,
            "require_parameters": true,
            "only": ["anthropic", "openai", "google"],
            "ignore": ["cohere"],
            "quantizations": ["int8"],
            "sort": "price",
            "data_collection": "allow"
          }
        }
      ]
    }
  }
}
```

これらのルーティング制御により、UI で選択するモデル名を変更することなく、コスト、機能、信頼性のトレードオフを細かく調整できます。

### Vercel AI Gateway {#vercel-ai-gateway}

[Vercel AI Gateway](https://vercel.com/ai-gateway) は、単一の OpenAI 互換エンドポイントを通じて多数のモデルへアクセスできるようにします。

1. [Vercel AI Gateway keys page](https://vercel.com/d?to=%2F%5Bteam%5D%2F%7E%2Fai%2Fapi-keys&title=Go+to+AI+Gateway) から API キーを作成します
2. 設定ビュー (`agent: open settings`) を開き、**Vercel AI Gateway** セクションに移動します
3. Vercel AI Gateway の API キーを入力します

Vercel AI Gateway の API キーはキーチェーンに保存されます。

Zed は、定義されている場合は `VERCEL_AI_GATEWAY_API_KEY` 環境変数も使用します。

設定ファイル内で Vercel AI Gateway のカスタムエンドポイントを設定することもできます:

```json [settings]
{
  "language_models": {
    "vercel_ai_gateway": {
      "api_url": "https://ai-gateway.vercel.sh/v1"
    }
  }
}
```

### Vercel v0 {#vercel-v0}

[Vercel v0](https://v0.app/docs/api/model) は、Next.js や Vercel などのスタック向けにフレームワークを理解した補完を行う、フルスタックアプリケーション生成用のモデルです。
テキストおよび画像入力をサポートし、高速なストリーミングレスポンスを提供します。

v0 モデルは [OpenAI 互換モデル](/#openai-api-compatible) であり、パネルの設定ビューでは Vercel が専用プロバイダーとして表示されます。

Zed で使用を開始するには、まず [v0 API キー](https://v0.dev/chat/settings/keys) を作成しておいてください。
作成したら、パネルの設定ビュー内の Vercel プロバイダーセクションにそのキーを直接貼り付けます。

その後、Agent パネルのモデルドロップダウンで `v0-1.5-md` として表示されるはずです。

### xAI {#xai}

Zed には専用の [xAI](https://x.ai/) プロバイダーが含まれています。独自の API キーを使用して Grok モデルにアクセスできます。

1. [xAI Console で API キーを作成します](https://console.x.ai/team/default/api-keys)
2. 設定ビュー (`agent: open settings`) を開き、**xAI** セクションに移動します
3. xAI の API キーを入力します

xAI の API キーはキーチェーンに保存されます。Zed は、定義されている場合は `XAI_API_KEY` 環境変数も使用します。

> **Note:** xAI API は OpenAI 互換であり、Zed には専用の xAI プロバイダーも含まれています。[OpenAI API Compatible](#openai-api-compatible) の方法ではなく、専用の `x_ai` プロバイダー設定を使用することを推奨します。

#### カスタムモデル {#xai-custom-models}

Zed agent には、一般的な Grok モデルがあらかじめ設定されています。別のモデルを使用したり、そのパラメータをカスタマイズしたりしたい場合は、Zed の設定ファイルに次の内容を追加します（[編集方法](../configuring-zed.md#settings-files)）:

```json [settings]
{
  "language_models": {
    "x_ai": {
      "api_url": "https://api.x.ai/v1",
      "available_models": [
        {
          "name": "grok-1.5",
          "display_name": "Grok 1.5",
          "max_tokens": 131072,
          "max_output_tokens": 8192
        },
        {
          "name": "grok-1.5v",
          "display_name": "Grok 1.5V (Vision)",
          "max_tokens": 131072,
          "max_output_tokens": 8192,
          "supports_images": true
        }
      ]
    }
  }
}
```

## カスタムプロバイダーエンドポイント {#custom-provider-endpoint}

プロバイダーの API 構造と互換性がある限り、さまざまなプロバイダーに対してカスタム API エンドポイントを使用できます。
そのためには、設定ファイルに次の内容を追加します（[編集方法](../configuring-zed.md#settings-files)）:

```json
{
  "language_models": {
    "some-provider": {
      "api_url": "http://localhost:11434"
    }
  }
}
```

現在、`some-provider` には次のいずれかの値を指定できます: `anthropic`, `google`, `ollama`, `openai`。

これは、たとえば [OpenAI 互換](#openai-api-compatible) なモデルを提供しているのと同じインフラストラクチャです。
