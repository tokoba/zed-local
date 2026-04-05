# 外部エージェント

Zed は [Agent Client Protocol (ACP)](https://agentclientprotocol.com) を通じて、CLI ベースのものを含む多くの外部エージェントをサポートしています。

Zed は [Gemini CLI](https://github.com/google-gemini/gemini-cli)（ACP のリファレンス実装）、[Claude Agent](https://platform.claude.com/docs/en/agent-sdk/overview)、[Codex](https://developers.openai.com/codex)、[GitHub Copilot](https://github.com/github/copilot-language-server-release) に加えて、設定可能な[追加エージェント](#add-more-agents)もサポートしています。

Zed のビルトインエージェントおよび、そのエージェントがネイティブに使用できるツールの一覧については、[Agent Tools](./tools.md) を参照してください。

> Zed の外部エージェントとのやり取りは厳密に UI ベースで行われます。課金、法的事項、利用条件の取り決めは、あなたとエージェントの提供元との間で直接行われます。
> Zed は外部エージェントの利用に対して料金を請求しません。また、当社の [zero-data retention agreements/privacy guarantees](./ai-improvement.md) は、Zed がホストするモデルに ***のみ*** 適用されます。

## Gemini CLI {#gemini-cli}

Zed は [エージェントパネル](./agent-panel.md) 内で [Gemini CLI](https://github.com/google-gemini/gemini-cli) を直接実行する機能を提供します。
内部的には Gemini CLI をバックグラウンドで実行し、ACP 経由でそれと通信します。

### はじめに

まず {#kb agent::ToggleFocus} でエージェントパネルを開き、右上の `+` ボタンを使って新しい Gemini CLI スレッドを開始します。

これをキーボードショートカットに割り当てたい場合は、`zed: open keymap file` コマンドで `keymap.json` ファイルを編集し、次の内容を追加します。

```json [keymap]
[
  {
    "bindings": {
      "cmd-alt-g": [
        "agent::NewExternalAgentThread",
        { "agent": { "custom": { "name": "gemini" } } }
      ]
    }
  }
]
```

#### インストール

初めて Gemini CLI スレッドを作成するとき、Zed は [@google/gemini-cli](https://github.com/google-gemini/gemini-cli) をインストールします。
このインストールは Zed からのみ利用可能で、エージェントを使用する間、自動的に最新の状態に保たれます。

#### 認証

Gemini CLI の起動後、認証を求めるプロンプトが表示されます。

「Login」ボタンをクリックして Gemini CLI を対話的に開き、Google アカウントまたは [Vertex AI](https://cloud.google.com/vertex-ai) の認証情報でログインできます。
この場合、Zed があなたの OAuth またはアクセストークンを閲覧することはありません。

`GEMINI_API_KEY` 環境変数（または `GOOGLE_AI_API_KEY`）がすでに設定されている場合、あるいは Zed の [language model provider settings](./llm-providers.md#google-ai) で Google AI の API キーを設定している場合、そのキーは自動的に Gemini CLI に渡されます。

詳細については、[Gemini CLI ドキュメント](https://github.com/google-gemini/gemini-cli/blob/main/docs/index.md) を参照してください。

### 使い方

Gemini CLI は Zed のファーストパーティエージェントと同じワークフロー（コード生成、リファクタリング、デバッグ、Q&A）をサポートします。ファイル、最近のスレッド、シンボルを @ メンションすることでコンテキストを追加できます。

> Gemini CLI では、エージェントパネルの一部機能（過去メッセージの編集、履歴からのスレッド再開、チェックポイント作成）はまだ利用できません。

## Claude Agent

Gemini CLI と同様に、[Claude Agent](https://platform.claude.com/docs/en/agent-sdk/overview) も Zed の [エージェントパネル](./agent-panel.md) から直接実行できます。
内部的には、Zed は Claude Agent SDK を実行しており、その SDK が内部で Claude Code を実行します。また、[専用のアダプター](https://github.com/zed-industries/claude-agent-acp) を通じて ACP 経由でそれと通信します。

### はじめに

{#kb agent::ToggleFocus} でエージェントパネルを開き、右上の `+` ボタンを使って新しい Claude Agent スレッドを開始します。

これをキーボードショートカットに割り当てたい場合は、`zed: open keymap file` コマンドで `keymap.json` ファイルを編集し、次の内容を追加します。

```json [keymap]
[
  {
    "bindings": {
      "cmd-alt-c": [
        "agent::NewExternalAgentThread",
        { "agent": { "custom": { "name": "claude-acp" } } }
      ]
    }
  }
]
```

### 認証

バージョン `0.202.7` 以降、Zed による Claude Agent のインストールに対する認証は、Zed のエージェントとは完全に切り離されています。
つまり、[Zed Agent's settings](./llm-providers.md#anthropic) から追加された Anthropic の API キーは、Claude Agent による認証や課金には使用されません。

希望する課金方法が使用されるようにするには、[新しい Claude Agent スレッドを開き](./agent-panel.md#new-thread)、`/login` を実行して、API キー経由、または `Log in with Claude Code` を使用して Claude Pro/Max サブスクリプションで認証します。

#### インストール

初めて Claude Agent スレッドを作成するとき、Zed は [@zed-industries/claude-agent-acp](https://github.com/zed-industries/claude-agent-acp) をインストールします。
このインストールは Zed からのみ利用可能で、エージェントを使用する間、自動的に最新の状態に保たれます。

Zed は、グローバルにインストールされているかどうかに関わらず、Claude Code CLI のベンダリング版を含む、この管理された Claude Agent アダプターのバージョンを常に使用します。

アダプターが使用する実行ファイルを上書きしたい場合は、設定内で `CLAUDE_CODE_EXECUTABLE` 環境変数を、使用したい実行ファイルへのパスに設定できます。

```json
{
  "agent_servers": {
    "claude-acp": {
      "type": "registry",
      "env": {
        "CLAUDE_CODE_EXECUTABLE": "/path/to/alternate-claude-code-executable"
      }
    }
  }
}
```

### 使い方

Claude Agent は Zed のファーストパーティエージェントと同じワークフローをサポートします。ファイル、最近のスレッド、診断結果、シンボルを @ メンションすることでコンテキストを追加できます。

[ACP 経由](https://agentclientprotocol.com)でのやり取りに加え、Zed は一部の特有の機能をサポートするために [Claude Agent SDK](https://platform.claude.com/docs/en/agent-sdk/overview) に依存しています。
しかし、SDK はそれらを完全にサポートするために必要なすべてをまだ公開していません。

- スラッシュコマンド: [Custom slash commands](https://code.claude.com/docs/en/slash-commands#custom-slash-commands) は完全にサポートされており、skills に統合されています。[built-in commands](https://code.claude.com/docs/en/slash-commands#built-in-slash-commands) の一部もサポートされています。
- [Subagents](https://code.claude.com/docs/en/sub-agents) はサポートされています。
- [Agent teams](https://code.claude.com/docs/en/agent-teams) は現在 *サポートされていません*。
- [Hooks](https://code.claude.com/docs/en/hooks-guide) は現在 *サポートされていません*。

> Claude Agent では、[エージェントパネル](./agent-panel.md) の一部機能（過去メッセージの編集、履歴からのスレッド再開、チェックポイント作成）はまだ利用できません。

#### CLAUDE.md

Zed の Claude Agent は、プロジェクトルート、プロジェクトのサブディレクトリ、またはルートの `.claude` ディレクトリで見つかった `CLAUDE.md` ファイルを自動的に使用します。

`CLAUDE.md` ファイルがない場合は、`init` スラッシュコマンドを使って Claude Agent に作成させることができます。

## Codex CLI

[Codex CLI](https://github.com/openai/codex) も Zed の [エージェントパネル](./agent-panel.md) から直接実行できます。
内部的には、Zed は Codex CLI を実行し、[専用のアダプター](https://github.com/zed-industries/codex-acp) を通じて ACP 経由でそれと通信します。

### はじめに

As of version `0.208`, Zed から直接 Codex を使用できるようになっています。
{#kb agent::ToggleFocus} でエージェントパネルを開き、右上の `+` ボタンを使って新しい Codex スレッドを開始します。

これをキーボードショートカットに割り当てたい場合は、`zed: open keymap file` コマンドで `keymap.json` ファイルを編集し、次の内容を追加してください。

```json
[
  {
    "bindings": {
      "cmd-alt-c": [
        "agent::NewExternalAgentThread",
        { "agent": { "custom": { "name": "codex-acp" } } }
      ]
    }
  }
]
```

### Authentication

Zed における Codex のインストールに対する認証は、Zed のエージェントとは完全に切り離されています。
つまり、[Zed Agent の設定](./llm-providers.md#openai)で追加した OpenAI の API キーは、認証および課金のために Codex では使用されません。

希望する課金方法が使われるようにするには、[新しい Codex スレッドを開き](./agent-panel.md#new-thread)ます。
初回は、次の 3 つのいずれかの方法で認証するよう求められます。

1. Login with ChatGPT - 既存の有料 ChatGPT サブスクリプションを利用できます。*注: この方法は現在、リモートプロジェクトではサポートされていません*
2. `CODEX_API_KEY` - 環境変数 `CODEX_API_KEY` に設定した API キーを使用します。
3. `OPENAI_API_KEY` - 環境変数 `OPENAI_API_KEY` に設定した API キーを使用します。

すでにログイン済みで認証方法を変更したい場合は、スレッド内で `/logout` と入力し、再度認証してください。

Codex でサードパーティプロバイダを使用したい場合は、[Codex config.toml](https://github.com/openai/codex/blob/main/docs/config.md#model-selection) を使って設定するか、Codex エージェントサーバーの設定に追加の [args/env variables](https://github.com/openai/codex/blob/main/docs/config.md#model-selection) を渡してください。

#### Installation

初めて Codex スレッドを作成するとき、Zed は [codex-acp](https://github.com/zed-industries/codex-acp) をインストールします。
このインストールは Zed からのみ利用でき、エージェントを使用している間に最新の状態に保たれます。

グローバルに Codex をインストールしている場合でも、Zed は常にこの管理されたバージョンの Codex を使用します。

### Usage

Codex は Zed のファーストパーティエージェントと同じワークフローをサポートします。ファイルやシンボルを @ メンションすることでコンテキストを追加できます。

> Codex ではまだ一部のエージェントパネル機能が利用できません: 過去のメッセージの編集、履歴からのスレッド再開、チェックポイント機能。

## Add More Agents {#add-more-agents}

### Via Agent Server Extensions

<div class="warning">

`v0.221.x` 以降、Zed に外部エージェントをインストールするには [ACP Registry](https://agentclientprotocol.com/registry) を使用することが推奨されています。
詳細は[リリースブログ記事](https://zed.dev/blog/acp-registry)を参照してください。
近い将来、Agent Server 拡張機能は廃止される予定です。

</div>

[Agent Server extensions](../extensions/agent-servers.md) をインストールすることで、Zed に外部エージェントを追加できます。

利用可能なエージェントは、拡張機能ページで「Agent Servers」でフィルタリングして確認できます。このページにはコマンドパレットから `zed: extensions` でアクセスするか、[Zed の Web サイト](https://zed.dev/extensions?filter=agent-servers)からアクセスできます。

### Via The ACP Registry

#### Overview

前述のとおり、ACP Registry に移行するため、Agent Server extensions は近い将来廃止される予定です。

[ACP Registry](https://github.com/agentclientprotocol/registry) を使うと、開発者は ACP に対応したエージェントを、そのプロトコルを実装する任意のクライアントに配布できます。レジストリからインストールされたエージェントは自動的にアップデートされます。

現時点では、レジストリはキュレーションされたエージェントのみを含んでおり、[認証をサポートする](https://agentclientprotocol.com/rfds/auth-methods)エージェントだけが登録されています。

#### Using it in Zed

`zed: acp registry` コマンドを使用すると、ACP Registry ページに素早く移動できます。
エージェントパネルの設定ビューにも、そこに移動できる「Add Agent」ボタンがあります。

そのページから、好みのエージェントをクリックしてインストールすると、エージェントパネルの `+` アイコンボタンからすぐに利用できるようになります。

> 同じエージェントを拡張機能とレジストリの両方からインストールした場合は、レジストリ版が優先されます。

### Custom Agents

設定ファイル（[編集方法](../configuring-zed.md#settings-files)）の `agent_servers` 配下に特定のフィールドを指定することで、エージェントを追加することもできます。例えば次のようになります。

```json [settings]
{
  "agent_servers": {
    "My Custom Agent": {
      "type": "custom",
      "command": "node",
      "args": ["~/projects/agent/index.js", "--acp"],
      "env": {}
    }
  }
}
```

これは、プロトコルに対応した新しいエージェントを開発中でデバッグしたい場合に便利です。

Claude Agent、Codex、Gemini CLI などレジストリからインストールしたエージェントについては、設定内で `"type": "registry"` を使用し、そのレジストリ名（`claude-acp`、`codex-acp`、`gemini`）を指定することで環境変数をカスタマイズすることも可能です。

## Debugging Agents

Zed で外部エージェントを使用している場合、コマンドパレットから `dev: open acp logs` を実行してデバッグビューにアクセスできます。
ここでは、Zed とエージェント間で送受信されているメッセージを確認できます。

![ACP ログのデバッグビュー。](https://zed.dev/img/acp/acp-logs.webp)

Claude Agent、Codex、OpenCode などの外部エージェントに関する問題で issue を作成する際には、このビューから取得したデータを添付すると役立ちます。

## MCP Servers

外部エージェントにおいては、[Zed からインストールされた](./mcp.md) MCP サーバーへのアクセスは ACP の実装によって異なる場合があることに注意してください。
たとえば、Claude Agent と Codex はどちらも MCP サーバーへのアクセスをサポートしていますが、Gemini CLI はまだサポートしていません。
