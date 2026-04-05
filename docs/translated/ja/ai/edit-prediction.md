---
title: ZedのAIコード補完 - Zeta、Copilot、Codestral、Mercury Coder
description: ZedでZeta（組み込み）、GitHub Copilot、Codestral、またはMercury Coderを使用してAIコード補完を設定します。すべてのキーストロークでマルチラインの予測を提供します。
---

# 編集予測

編集予測はZedのAIコード補完の仕組みです：LLMがあなたが書きたいコードを予測します。
各キーストロークは編集予測プロバイダーに新しいリクエストを送信し、プロバイダーは`tab`キーを押して受け入れることができる単一行または複数行の候補を返します。

デフォルトのプロバイダーは[プロプライエタリなオープンソースおよびオープンデータセットモデルであるZeta](https://huggingface.co/zed-industries/zeta)ですが、GitHub Copilot、Mercury Coder、Codestralなどの[他のプロバイダー](#other-providers)も使用できます。

## Zetaの設定

Zetaを使用するには、[サインイン](../authentication.md#what-features-require-signing-in)してください。
サインインすると、入力時に予測が表示されます。

[設定エディタ](zed://settings/edit_predictions.providers)（macOSでは`Cmd+,`、Linux/Windowsでは`Ctrl+,`）を開いて`edit_predictions`を検索し、Zetaが正しく設定されていることを確認できます。`provider`フィールドは`Zed AI`に設定されている必要があります。

または、settings.jsonで確認できます：

```json [settings]
{
  "edit_predictions": {
    "provider": "zed"
  }
}
```

ステータスバーのZアイコンも、Zetaがアクティブであることを示しています。

### 料金プランとプラン

無料プランには月2,000回のZeta予測が含まれています。[Proプラン](../ai/plans-and-usage.md)はこの制限を解除します。詳細については[Zedの料金ページ](https://zed.dev/pricing)を参照してください。

### モードの切り替え {#switching-modes}

編集予測には2つの表示モードがあります：

1. `eager`（デフォルト）：言語サーバーの補完と競合しない限り、予測がインラインで表示されます
2. `subtle`：修飾キー（デフォルトは`alt`）を押している場合のみ、予測がインラインで表示されます

`mode`キーを使用して切り替えます：

```json [settings]
"edit_predictions": {
  "mode": "eager" // または "subtle"
},
```

または、ステータスバーメニューからUIで直接切り替えます：

![編集予測のステータスバーメニュー、モードの切り替え。](https://zed.dev/img/edit-prediction/status-bar-menu.webp)

> 編集予測モードはどの予測プロバイダーでも機能することに注意してください。

## デフォルトのキーバインド

macOSとWindowsでは、`alt-tab`で編集予測を受け入れることができます。Linuxでは、`alt-tab`はウィンドウマネージャーでウィンドウの切り替えによく使用されるため、編集予測のデフォルトのキーバインドは`alt-l`です。

`eager`モードでは、補完メニューが開いていない限り、`tab`キーを使用して編集予測を受け入れることもできます。この場合、`tab`はLSP補完を受け入れます。`tab`を押して空白を挿入するには、その前に{#kb editor::Cancel}で予測を閉じる必要があります。

{#action editor::AcceptNextWordEditPrediction}（{#kb editor::AcceptNextWordEditPrediction}）を使用して、次の単語の境界まで現在の編集予測を受け入れることができます。
{#action editor::AcceptNextLineEditPrediction}（{#kb editor::AcceptNextLineEditPrediction}）を使用して、次の行の境界まで現在の編集予測を受け入れることができます。

## 編集予測のキーバインドの設定 {#edit-predictions-keybinding}

### キーバインドの例：常にタブを使用する

LSP補完メニューが開いているかどうかにかかわらず、常に`tab`を使用して編集予測を受け入れるには、キーマップに以下を追加します：

{#action zed::OpenKeymap}（{#kb zed::OpenKeymap}）でキーマップエディタを開き、`AcceptEditPrediction`を検索し、`tab`のバインディングを右クリックして`edit`を押します。次に、バインディングがアクティブになるコンテキストを`Editor && edit_prediction`だけに変更して保存します。

または、`keymap.json`に以下を配置します：

```json [keymap]
[
  {
    "context": "Editor && edit_prediction",
    "bindings": {
      "tab": "editor::AcceptEditPrediction"
    }
  }
]
```

その後、{#kb editor::ComposeCompletion}はLSP補完を受け入れるために引き続き利用可能です。

### キーバインドの例：常にAlt-Tabを使用する

編集予測を受け入れるために`tab`を使用するのをやめ、代わりに常に`alt-tab`を使用するには、eager編集予測コンテキストでデフォルトの`tab`バインディングをアンバインドします：

{#action zed::OpenKeymap}（{#kb zed::OpenKeymap}）でキーマップエディタを開き、`AcceptEditPrediction`を検索し、`tab`のバインディングを右クリックして削除します。

または、`keymap.json`に以下を配置します：

```json [keymap]
[
  {
    "context": "Editor && edit_prediction",
    "unbind": {
      "tab": "editor::AcceptEditPrediction"
    }
  }
]
```

その後、`alt-tab`は編集予測を受け入れるために引き続き利用可能で、Linuxでは`alt-l`もアンバインドしない限り利用可能です。

### キーバインドの例：TabとAlt-Tabの両方を再バインドする

デフォルトの受け入れバインディングの両方を別のものに移動するには、それらをアンバインドして置換を追加します：

{#action zed::OpenKeymap}（{#kb zed::OpenKeymap}）でキーマップエディタを開き、`AcceptEditPrediction`を検索し、`tab`のバインディングを右クリックして削除します。次に、`alt-tab`のバインディングを右クリックし、「編集」を選択して、保存する前に望ましいキーストロークを記録します。

または、`keymap.json`に以下を配置します：

```json [keymap]
[
  {
    "context": "Editor && edit_prediction",
    "unbind": {
      "alt-tab": "editor::AcceptEditPrediction",
      // Windows/Linuxでもこれを追加
      // "alt-l": "editor::AcceptEditPrediction",
      "tab": "editor::AcceptEditPrediction"
    },
    "bindings": {
      "ctrl-enter": "editor::AcceptEditPrediction"
    }
  }
]
```

この場合、バインディングに修飾子`ctrl`が含まれているため、subtleモードで予測をプレビューしたり、補完メニューが開いているときに使用したりします。

### 古いキーマップエントリのクリーンアップ

Zed `v0.229.0`の前に編集予測のキーバインドを設定した場合、`keymap.json`に現在は冗長なエントリがある可能性があります。

**古いtabの回避策**: `unbind`が存在する前は、`tab`が編集予測を受け入れるのを防ぐ唯一の方法は、すべてのデフォルトの非編集予測`tab`バインディングをカスタムの`AcceptEditPrediction`バインディングと一緒にキーマップにコピーすることでした。キーマップにまだそれらのコピーペーストされたエントリが含まれている場合は、それらを削除して、上記の例のように単一の`"unbind"`エントリを使用してください。

**名前が変更されたコンテキスト**: `edit_prediction_conflict`コンテキストは`edit_prediction && (showing_completions || in_leading_whitespace)`に置き換えられました。Zedは`edit_prediction_conflict`を使用したすべてのバインディングを自動的に移行するため、あなた側で変更する必要はありません。

## 自動編集予測の無効化

編集予測をいくつかのレベルで無効にしたり、完全にオフにしたりできます。

または、プロバイダーとしてZedを設定している場合は、[Subtleモードを使用](#switching-modes)することを検討してください。

### バッファで

入力時に予測が自動的に表示されないようにするには、設定ファイルにこれを設定します（[編集方法](../configuring-zed.md#settings-files)）：

```json [settings]
{
  "show_edit_predictions": false
}
```

これは、あなたがいる[表示モード](#switching-modes)に関係なく、予測が利用可能であることを示すすべての表示を非表示にします（プロバイダーとしてZedを持っている場合にのみ有効）。
それでも、{#action editor::ShowEditPrediction}を実行するか、{#kb editor::ShowEditPrediction}を押すと、編集予測を手動でトリガーできます。

### 特定の言語で

特定の言語で作業しているとき、入力時に予測が自動的に表示されないようにするには、設定ファイルにこれを設定します（[編集方法](../configuring-zed.md#settings-files)）：

```json [settings]
{
  "languages": {
    "Python": {
      "show_edit_predictions": false
    }
  }
}
```

### 特定のディレクトリで

特定のディレクトリまたはファイルの編集予測を無効にするには、設定ファイルにこれを設定します（[編集方法](../configuring-zed.md#settings-files)）：

```json [settings]
{
  "edit_predictions": {
    "disabled_globs": ["~/.config/zed/settings.json"]
  }
}
```

### 完全にオフにする

すべてのプロバイダーで編集予測を完全にオフにするには、次のように設定を明示的に`none`に設定します：

```json [settings]
{
  "edit_predictions": {
    "provider": "none"
  }
}
```

## 他のプロバイダーの設定 {#other-providers}

編集予測は他のプロバイダーでも機能します。

### GitHub Copilot {#github-copilot}

プロバイダーとしてGitHub Copilotを使用するには、設定ファイルにこれを設定します（[編集方法](../configuring-zed.md#settings-files)）：

```json [settings]
{
  "edit_predictions": {
    "provider": "copilot"
  }
}
```

GitHub Copilotにサインインするには、ステータスバーのCopilotアイコンをクリックします。デバイスコードを表示するポップアップウィンドウが表示されます。コピーボタンをクリックしてコードをコピーし、「Connect to GitHub」をクリックしてブラウザでGitHub検証ページを開きます。プロンプトが表示されたらコードを貼り付けます。認証に成功すると、ポップアップウィンドウは自動的に閉じます。

#### GitHub Copilot Enterpriseの使用

組織でGitHub Copilot Enterpriseを使用している場合は、設定ファイルでエンタープライズURIを指定して、エンタープライズインスタンスを使用するようにZedを設定できます（[編集方法](../configuring-zed.md#settings-files)）：

```json [settings]
{
  "edit_predictions": {
    "copilot": {
      "enterprise_uri": "https://your.enterprise.domain"
    }
  }
}
```

`"https://your.enterprise.domain"`をGitHub Enterprise管理者から提供されたURL（例：`https://foo.ghe.com`）に置き換えます。

設定すると、Zedはエンタープライズエンドポイントを介してCopilotリクエストをルーティングします。
ステータスバーのCopilotアイコンをクリックしてサインインすると、認証を完了するために構成されたエンタープライズURLにリダイレクトされます。
他のすべてのCopilot機能と使用法は同じままです。

Copilotは複数の補完代替案を提供でき、これらは以下のアクションでナビゲートできます：

- {#action editor::NextEditPrediction}（{#kb editor::NextEditPrediction}）：次の編集予測にサイクルします
- {#action editor::PreviousEditPrediction}（{#kb editor::PreviousEditPrediction}）：前の編集予測にサイクルします

### Mercury Coder {#mercury-coder}

Inception Labsの[Mercury Coder](https://www.inceptionlabs.ai/)をプロバイダーとして使用するには：

1. 設定エディタを開きます（{#kb zed::OpenSettings}）
2. 「Edit Predictions」を検索し、**[プロバイダーの設定]**をクリックします
3. Mercuryセクションを見つけ、[Inception Labsダッシュボード](https://platform.inceptionlabs.ai/dashboard/api-keys)からAPIキーを入力します

または、ステータスバーの編集予測アイコンをクリックし、メニューから**[プロバイダーの設定]**を選択します。

APIキーを追加すると、Mercury Coderがステータスバーメニューのプロバイダードロップダウンに表示され、そこで選択できます。また、設定ファイルで直接設定することもできます：

```json [settings]
{
  "edit_predictions": {
    "provider": "mercury"
  }
}
```

### Codestral {#codestral}

MistralのCodestralをプロバイダーとして使用するには：

1. 設定エディタを開きます（macOSでは`Cmd+,`、Linux/Windowsでは`Ctrl+,`）
2. 「Edit Predictions」を検索し、**[プロバイダーの設定]**をクリックします
3. Codestralセクションを見つけ、[Codestralダッシュボード](https://console.mistral.ai/codestral)からAPIキーを入力します

または、ステータスバーの編集予測アイコンをクリックし、メニューから**[プロバイダーの設定]**を選択します。

APIキーを追加すると、Codestralがステータスバーメニューのプロバイダードロップダウンに表示され、そこで選択できます。また、設定ファイルで直接設定することもできます：

```json [settings]
{
  "edit_predictions": {
    "provider": "codestral"
  }
}
```

### セルフホストのOpenAI互換サーバー

OpenAI補完API形式を実装するセルフホストサーバーを使用できます。これはvLLM、llama.cppサーバー、LocalAI、およびその他の互換サーバーで機能します。

#### 設定

プロバイダーとして`open_ai_compatible_api`を設定し、APIエンドポイントを設定します：

```json [settings]
{
  "edit_predictions": {
    "provider": "open_ai_compatible_api",
    "open_ai_compatible_api": {
      "api_url": "http://localhost:8080/v1/completions",
      "model": "deepseek-coder-6.7b-base",
      "prompt_format": "deepseek_coder",
      "max_output_tokens": 64
    }
  }
}
```

`prompt_format`設定は、コードコンテキストをモデル用にフォーマットする方法を制御します。`"infer"`を使用してモデル名から形式を検出するか、以下のように明示的に指定します：

- `code_llama` - CodeLlama形式：`<PRE> prefix <SUF> suffix <MID>`
- `star_coder` - StarCoder形式：`<fim_prefix>prefix<fim_suffix>suffix<fim_middle>`
- `deepseek_coder` - 特殊なunicodeマーカーを使用するDeepSeek形式
- `qwen` - Qwen/CodeGemma形式：`<|fim_prefix|>prefix<|fim_suffix|>suffix<|fim_middle|>`
- `codestral` - Codestral形式：`[SUFFIX]suffix[PREFIX]prefix`
- `glm` - コードマーカーを使用するGLM-4形式
- `infer` - モデル名から自動検出（デフォルト）

サーバーはOpenAI `/v1/completions`エンドポイントを実装している必要があります。編集予測はこの形式でPOSTリクエストを送信します：

```json
{
  "model": "your-model-name",
  "prompt": "formatted-code-context",
  "max_tokens": 256,
  "temperature": 0.2,
  "stop": ["", ...]
}
```

## 関連項目

- [エージェントパネル](./agent-panel.md)：ファイルの読み取り/書き込みとターミナルアクセスによるエージェント編集
- [インラインアシスタント](./inline-assistant.md)：選択したコードのプロンプト駆動型変換
