# Inline Assistant

## 使い方の概要

エディタ、ルールライブラリ、チャネルノート、およびターミナルパネルで Inline Assistant を開くには、{#kb assistant::InlineAssist} を使用します。

Inline Assistant は、現在の選択範囲（または行）を言語モデルに送信し、その応答で置き換えます。

## はじめに

Inline Assistant を初めて使用する場合は、少なくとも 1 つの LLM プロバイダーまたは外部エージェントを設定しておく必要があります。
次のいずれかの方法で設定できます。

1. [当社の Pro プランを購読する](https://zed.dev/pricing)ことで、ホスト型モデルにアクセスできるようにする
2. Anthropic のようなモデルプロバイダーや OpenRouter のようなモデルゲートウェイから取得した[独自の API キーを使用する](./llm-providers.md#use-your-own-keys)

すでに [Agent Panel](./agent-panel.md#getting-started) と対話するための LLM プロバイダーを設定済みの場合、その設定は Inline Assistant でもそのまま利用できます。

> ただし Agent Panel と異なり、現時点での唯一の例外は [external agents](./external-agents.md) です。
> これらは現在、Inline Assistant で変更を生成する用途には使用できません。

## コンテキストの追加

Inline Assistant では、[Agent Panel](./agent-panel.md#adding-context) と同じ方法でコンテキストを追加できます。

- ファイル、ディレクトリ、過去のスレッド、ルール、シンボルを @ メンションする
- クリップボードにコピーした画像を貼り付ける

Agent Panel でスレッドを作成し、Inline Assistant から `@thread` で参照することもできます。これにより、コンテキストを再説明することなく、大きなスレッドの中の特定の変更を洗練できます。

## 並列生成

Inline Assistant は、一度に複数の変更を生成できます。

### 複数カーソル

複数のカーソルを使用している場合、{#kb assistant::InlineAssist} を押すと同じプロンプトが各カーソル位置に送信され、すべての場所で同時に変更が生成されます。

これは、[multibuffers](../multibuffers.md) 内の抜粋と組み合わせると特に有効です。

### 複数モデル

Inline Assistant を使用して、同じプロンプトを複数のモデルに同時に送信できます。

この機能を追加するために設定ファイル（[編集方法](../configuring-zed.md#settings-files)）をカスタマイズする方法は次のとおりです。

```json [settings]
{
  "agent": {
    "default_model": {
      "provider": "zed.dev",
      "model": "claude-sonnet-4-5"
    },
    "inline_alternatives": [
      {
        "provider": "zed.dev",
        "model": "gpt-4-mini"
      }
    ]
  }
}
```

複数のモデルが設定されている場合、Inline Assistant の UI に各モデルが生成した出力を切り替えるためのボタンが表示されます。

ここで指定したモデルは、[デフォルトモデル](#default-model)に *加えて* 常に使用されます。

例えば、次の設定では、アシストごとに 3 つの出力が生成されます。
1 つは Claude Sonnet 4.5（デフォルトモデル）、もう 1 つは GPT-5-mini、さらにもう 1 つは Gemini 3 Flash です。

```json [settings]
{
  "agent": {
    "default_model": {
      "provider": "zed.dev",
      "model": "claude-sonnet-4-5"
    },
    "inline_alternatives": [
      {
        "provider": "zed.dev",
        "model": "gpt-4-mini"
      },
      {
        "provider": "zed.dev",
        "model": "gemini-3-flash"
      }
    ]
  }
}
```

## Inline Assistant と Edit Prediction の比較

どちらの機能もインラインでコードを生成しますが、動作は異なります。

- **Inline Assistant**: プロンプトを書き、変換する対象を選択します。コンテキストを制御するのはユーザーです。
- **[Edit Prediction](./edit-prediction.md)**: 最近の変更内容、閲覧したファイル、カーソル位置に基づいて、Zed が自動的に編集候補を提案します。プロンプトは不要です。

重要な違いは、Inline Assistant は明示的でプロンプト駆動であるのに対し、Edit Prediction は自動かつコンテキスト推論型であることです。

## プロンプトの事前入力

プロンプトを事前入力するカスタムキーバインドを作成するには、keymap に次の形式を追加します。

```json [keymap]
[
  {
    "context": "Editor && mode == full",
    "bindings": {
      "ctrl-shift-enter": [
        "assistant::InlineAssist",
        { "prompt": "Build a snake game" }
      ]
    }
  }
]
```
