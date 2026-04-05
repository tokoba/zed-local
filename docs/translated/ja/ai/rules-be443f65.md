# ルールの使用 {#using-rules}

ルールはプロンプトであり、プロジェクトのファイルツリーで利用可能な `.rules` ファイルを通じて各 [Agent Panel](./agent-panel.md) との対話の冒頭に自動的に挿入することも、Rules Library を経由して @ メンションすることでオンデマンドに挿入することもできます。

## `.rules` ファイル

Zed は、プロジェクトのファイルツリーのルートに `.rules` ファイルを含めることをサポートしており、これらはプロジェクトレベルの指示として機能し、Agent Panel とのすべての対話に自動的に含まれます。

他のエージェントとの互換性のため、このファイルには他の名前も使用できますが、次のリストで最初に一致したファイルが使用される点に注意してください。

- `.rules`
- `.cursorrules`
- `.windsurfrules`
- `.clinerules`
- `.github/copilot-instructions.md`
- `AGENT.md`
- `AGENTS.md`
- `CLAUDE.md`
- `GEMINI.md`

## Rules Library {#rules-library}

Rules Library は、ルールを作成および管理するためのインターフェイスです。
シンタックスハイライトと標準的なすべてのキーバインドを備えたフル機能のエディタです。

ルールエディタ内でインラインアシスタントを使用することもでき、ルール作成のための LLM サポートを素早く得られます。

### Rules Library を開く

1. Agent Panel を開きます。
2. 右上隅の Agent メニュー（`...`）をクリックします。
3. ドロップダウンから `Rules...` を選択します。

また、{#action agent::OpenRulesLibrary} アクションを実行するか、{#kb agent::OpenRulesLibrary} キーバインドを使用して開くこともできます。

### ルールの管理

ルールファイルを選択すると、組み込みエディタで直接編集できます。
タイトルバーから、そのタイトルを変更することもできます。

ルールエディタ内のボタンを使用して、ルールを複製、削除、またはデフォルトルールに追加できます。

### ルールの作成 {#creating-rules}

ルールファイルを作成するには、`Rules Library` を開いて `+` ボタンをクリックするだけです。
ルールファイルはローカルに保存され、いつでもライブラリからアクセスできます。

効果的なルールを書くためのガイドラインについては、次を参照してください。

- [Anthropic: プロンプトエンジニアリング](https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/overview)
- [OpenAI: プロンプトエンジニアリング](https://platform.openai.com/docs/guides/prompt-engineering)

### ルールの利用

Rules Library で作成したすべてのルールは、@ メンションすることができます。
これにより、再利用可能なプロンプトに素早くアクセスでき、使用するたびに入力する手間を省けます。

#### デフォルトルール {#default-rules}

Rules Library 内のすべてのルールはデフォルトルールとして設定でき、そうすると新しい Agent Panel の対話ごとに自動的にコンテキストへ挿入されます。

Rules Library のルールエディタ右上にあるクリップのアイコンボタンをクリックすると、任意のルールをデフォルトとして設定できます。

## Prompt Library からの移行

以前は、Rules Library は「Prompt Library」と呼ばれていました。
新しいルールシステムは、以下で説明するいくつかの特定のケースを除き、Prompt Library を置き換えます。

### ルールにおけるスラッシュコマンド

以前は、カスタムプロンプト（現在のルール）内でスラッシュコマンド（現在の @ メンション）を使用することができました。
現在のところ、ルールファイル内で @ メンションを使用することはサポートされていません。
