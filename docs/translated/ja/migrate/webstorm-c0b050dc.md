# WebStorm から Zed へ移行する方法

このガイドでは、WebStorm から移行する際の Zed のセットアップ方法（キーバインド、設定、そして JavaScript/TypeScript 開発者として想定される違い）を説明します。

## Zed のインストール

Zed は macOS、Windows、Linux で利用できます。

macOS の場合は、zed.dev/download からダウンロードするか、Homebrew 経由でインストールできます:

```sh
brew install --cask zed
```

Windows の場合は、zed.dev/download からインストーラーをダウンロードするか、winget でインストールします:

```sh
winget install Zed.Zed
```

ほとんどの Linux ユーザーにとって、Zed をインストールする最も簡単な方法はインストールスクリプトを使うことです:

```sh
curl -f https://zed.dev/install.sh | sh
```

インストール後は、macOS では Applications フォルダから、Windows ではスタートメニューから、またはターミナルで次のコマンドを使って直接 Zed を起動できます:
`zed .`
これにより、現在のディレクトリが Zed で開きます。

## JetBrains キーマップの設定

WebStorm から移行する場合、一番手っ取り早く馴染む方法は JetBrains キーマップを使うことです。オンボーディング中にベースキーマップとして選択できます。もしそのステップを逃してしまっても、いつでも変更できます:

1. {#kb zed::OpenSettings} で Settings を開きます
2. `Base Keymap` を検索します
3. `JetBrains` を選択します

これにより、Go to Class 用の {#kb:jetbrains project_symbols::Toggle} や Find Action 用の {#kb:jetbrains command_palette::Toggle} など、おなじみのショートカットが割り当てられます。

## エディターの設定

ほとんどの設定は Settings Editor ({#kb zed::OpenSettings}) で構成できます。より高度な設定については、Command Palette から `zed: open settings file` を実行し、設定ファイルを直接編集します。

WebStorm ユーザーが最初に設定することが多い項目:

| Zed Setting             | What it does                                                                    |
| ----------------------- | ------------------------------------------------------------------------------- |
| `format_on_save`        | 保存時に自動フォーマットします。有効にするには `"on"` に設定します。            |
| `soft_wrap`             | 長い行を折り返します。オプション: `"none"`, `"editor_width"`, `"preferred_line_length"` |
| `preferred_line_length` | 折り返しやルーラーの列幅を指定します。デフォルトは 80 です。                    |
| `inlay_hints`           | パラメーター名や型ヒントを、WebStorm のヒントのようにインライン表示します。    |
| `relative_line_numbers` | IdeaVim から移行してきた場合に便利です。                                       |

Zed はプロジェクトごとの設定もサポートしています。プロジェクトのルートに `.zed/settings.json` ファイルを作成することで、そのプロジェクトに対してグローバル設定を上書きできます。これは WebStorm で `.idea` フォルダーを使うのに似ています。

> **ヒント:** 既存プロジェクトに参加する場合は、最初のコミットの前に `format_on_save` を確認してください。意図したのは 1 行だけの変更なのに、ファイル全体を誤って再フォーマットしてしまうおそれがあります。

## プロジェクトを開く/作成する

セットアップが完了したら、{#kb:jetbrains file_finder::Toggle} を使ってフォルダーを開きます。これが Zed におけるワークスペースになります。WebStorm と異なり、プロジェクト設定ウィザードやフレームワーク選択ダイアログ、プロジェクト構造のセットアップは不要です。

新しいプロジェクトを始めるには、ターミナルやファイルマネージャーでディレクトリを作成し、それを Zed で開きます。エディターはそのフォルダーをプロジェクトのルートとして扱います。新規プロジェクトでは、通常は最初に `npm init`、`pnpm create`、または利用しているフレームワークの CLI ツールを実行し、その結果できたフォルダーを Zed で開きます。

任意のフォルダー内のターミナルから次のコマンドで Zed を起動することもできます:
`zed .`

プロジェクト内に入ったら:

- {#kb:jetbrains file_finder::Toggle} を使ってファイル間を素早く移動します（WebStorm の「Recent Files」のような機能です）
- {#kb:jetbrains command_palette::Toggle} を使って Command Palette を開きます（WebStorm の「Search Everywhere」のような機能です）
- {#kb:jetbrains project_symbols::Toggle} を使ってシンボルを検索します（WebStorm の「Go to Symbol」のような機能です）

開いているバッファーは上部にタブとして表示されます。Project Panel にはファイルツリーと Git のステータスが表示されます。{#kb:jetbrains project_panel::ToggleFocus} でトグルできます（WebStorm の Project ツールウィンドウと同様です）。

## キーバインドの違い

オンボーディング中に JetBrains キーマップを選択していれば、ほとんどのショートカットはすでに馴染みのあるものになっているはずです。以下は、JetBrains キーマップ有効時の一般的なアクションとそのキーバインドの簡易リファレンスです。

### Common Keybindings

| Action                 | Zed Keybinding                                  |
| ---------------------- | ----------------------------------------------- |
| Command Palette        | {#kb:jetbrains command_palette::Toggle}         |
| Go to File             | {#kb:jetbrains file_finder::Toggle}             |
| Go to Symbol           | {#kb:jetbrains project_symbols::Toggle}         |
| File Outline           | {#kb:jetbrains outline::Toggle}                 |
| Go to Definition       | {#kb:jetbrains editor::GoToDefinition}          |
| Find Usages            | {#kb:jetbrains editor::FindAllReferences}       |
| Rename Symbol          | {#kb:jetbrains editor::Rename}                  |
| Reformat Code          | {#kb:jetbrains editor::Format}                  |
| Toggle Project Panel   | {#kb:jetbrains project_panel::ToggleFocus}      |
| Toggle Terminal        | {#kb:jetbrains terminal_panel::Toggle}          |
| Duplicate Line         | {#kb:jetbrains editor::DuplicateSelection}      |
| Delete Line            | {#kb:jetbrains editor::DeleteLine}              |
| Move Line Up           | {#kb:jetbrains editor::MoveLineUp}              |
| Move Line Down         | {#kb:jetbrains editor::MoveLineDown}            |
| Expand Selection       | {#kb:jetbrains editor::SelectLargerSyntaxNode}  |
| Shrink Selection       | {#kb:jetbrains editor::SelectSmallerSyntaxNode} |
| Comment Line           | {#kb:jetbrains editor::ToggleComments}          |
| Go Back                | {#kb:jetbrains pane::GoBack}                    |
| Go Forward             | {#kb:jetbrains pane::GoForward}                 |
| Toggle Breakpoint      | {#kb:jetbrains editor::ToggleBreakpoint}        |
| Navigate to Next Error | {#kb:jetbrains editor::GoToDiagnostic}          |

### Unique to Zed

| Action            | Keybinding                       | Notes                                                         |
| ----------------- | -------------------------------- | ------------------------------------------------------------- |
| Toggle Right Dock | {#kb workspace::ToggleRightDock} | Assistant パネル、通知                                        |
| Split Pane Right  | {#kb pane::SplitRight}           | 他の矢印キーを使うと、異なる方向に分割を作成できます          |

### キーバインドをカスタマイズする方法

- Command Palette ({#kb:jetbrains command_palette::Toggle}) を開きます
- `zed: open keymap` を実行します

これにより、利用可能なすべてのバインディングの一覧が開きます。個々のショートカットを上書きしたり、競合を解消したりできます。

Zed はキーシーケンス（複数キーのショートカット）もサポートしています。

## ユーザーインターフェースの違い

### インデックス作成なし

大規模なプロジェクトで WebStorm を使ったことがあるなら、あの待ち時間をご存じでしょう。依存関係の多いプロジェクトを開くと、30 秒から数分のあいだ「Indexing...」という表示を見続けることになります。WebStorm はコードインテリジェンスを提供するために、コードベース全体と `node_modules` をインデックス化し、依存関係が変わると再インデックスを行います。

Zed はインデックスを作成しません。フォルダーを開けば、すぐにコーディングを始められます。プログレスバーも「Indexing paused」のバナーもありません。プロジェクトの規模や `node_modules` の依存関係の数に関係なく、ファイル検索やナビゲーションは高速のままです。

WebStorm のインデックスにより、コードベース全体からの使用箇所の一括検索、インポート階層の追跡、プロジェクト全体での未使用エクスポートの検出といった機能が実現されています。Zed はこの種の解析を言語サーバーに依存しているため、カバー範囲が同じとは限りません。

**どう対応するか:**

- {#kb:jetbrains project_symbols::Toggle} を使ってプロジェクト全体のシンボルを検索する（TypeScript 言語サーバーによって提供）
- {#kb:jetbrains file_finder::Toggle} でファイル名からファイルを検索する
- テキスト検索には {#kb pane::DeploySearch} を使う — 大規模なモノレポでも高速です
- プロジェクト全体をより深く解析したい場合は、ターミナルから `tsc --noEmit` や `eslint .` を実行する

### LSP とネイティブな言語インテリジェンス

WebStorm には、JetBrains が開発した独自の JavaScript / TypeScript 解析エンジンがあります。このエンジンはコードを深く理解し、型を解決し、データフローを追跡し、フレームワーク固有のパターンを把握し、専用のリファクタリング機能を提供します。

Zed はコードインテリジェンスに Language Server Protocol (LSP) を利用します。JavaScript と TypeScript については、Zed は次のものをサポートしています:

- **vtsls** (既定) — 高いパフォーマンスを持つ高速な TypeScript 言語サーバー
- **typescript-language-server** — 標準的な TypeScript LSP 実装
- **ESLint** — Lint 統合
- **Prettier** — コード整形（組み込み）

TypeScript LSP の体験はよく整備されています。正確な補完、型チェック、定義へのジャンプ、参照の検索が利用できます。この体験は、同じ TypeScript サービスを基盤としている VS Code と同程度です。

違いを感じるかもしれない点:

- フレームワーク固有のインテリジェンス（Angular テンプレートや Vue の SFC など）は統合度が低い場合があります
- 一部の複雑なリファクタリング（適切なインポート付きでコンポーネントを抽出するなど）は、洗練度が低い場合があります
- 自動インポートの候補は、言語サーバーがプロジェクトについて把握している情報に依存します

**どう対応するか:**

- 利用可能なコードアクションには {#kb:jetbrains editor::ToggleCodeActions} を使う — アクションの一覧は言語サーバーによって異なります
- 言語サーバーがプロジェクト構造を理解できるように、`tsconfig.json` が正しく設定されていることを確認する
- 一貫したフォーマットのために Prettier を利用する（JS/TS ではデフォルトで有効になっています）
- WebStorm の「Inspect Code」に相当するコード検査には、Diagnostics パネル（{#kb:jetbrains diagnostics::Deploy}）を確認する — ESLint と TypeScript を組み合わせることで、多くの同様の問題を検出できます

### プロジェクトモデルがない

WebStorm は、XML 設定ファイル、フレームワーク検出、実行構成などを含む `.idea` フォルダーを通じてプロジェクトを管理します。このモデルにより、WebStorm はプロジェクト設定を記憶し、UI から npm スクリプトを管理し、実行／デバッグ設定を保存できます。

Zed のアプローチは異なります。プロジェクトは単なるフォルダーです。セットアップウィザードも、フレームワーク検出ダイアログも、設定すべきプロジェクト構造もありません。

実際には次のような意味があります:

- 実行構成というものはありません。代わりに、再利用可能なコマンドを `tasks.json` に定義します。既存の `.idea/` の設定は引き継がれないため、必要なものは新たに設定し直す必要があります。
- npm スクリプトはターミナルで扱います。`npm run dev`、`pnpm build`、`yarn test` などを直接実行します。専用の npm パネルはありません。
- フレームワークの自動検出はありません。Zed は React、Angular、Vue、プレーンな JS/TS をすべて同じように扱います。

**どう対応するか:**

- プロジェクト固有の設定用に、プロジェクトルートに `.zed/settings.json` を作成する
- 共通のコマンドを `tasks.json` に定義する（コマンドパレットから `zed: open tasks` で開く）:

```json
[
  {
    "label": "dev",
    "command": "npm run dev"
  },
  {
    "label": "build",
    "command": "npm run build"
  },
  {
    "label": "test",
    "command": "npm test"
  },
  {
    "label": "test current file",
    "command": "npm test -- $ZED_FILE"
  }
]
```

- {#kb:jetbrains task::Spawn} を使ってタスクを素早く実行する
- タスクでカバーされないことは、ターミナル（{#kb:jetbrains terminal_panel::Toggle}）に頼る

### フレームワーク統合がない

WebStorm が Web 開発で価値を発揮するのは、主にフレームワーク統合のおかげです。React コンポーネントには特別な扱いがあります。Angular には専用のツール群があります。Vue のシングルファイルコンポーネントも完全に理解されます。npm ツールウィンドウには、すべてのスクリプトが表示されます。

Zed には、こうした機能は組み込みでは存在しません。TypeScript 言語サーバーはコードを TypeScript として扱うだけで、ある関数が React コンポーネントであることや、あるファイルが Angular のサービスであることまでは理解しません。

**どう対応するか:**

- grep やファイル検索を積極的に使いましょう。正規表現付きの {#kb pane::DeploySearch} で、コンポーネント定義やルート設定、API エンドポイントなどを検索できます。
- ナビゲーションには、言語サーバーの「find references」（{#kb:jetbrains editor::FindAllReferences}）に頼りましょう — フレームワークの文脈こそありませんが、問題なく機能します
- Zed のターミナルから、`ng`、`next`、`vite` といったフレームワーク専用の CLI ツールを利用することも検討してください
- React では、JSX/TSX の構文と TypeScript の型によって、依然として十分なインテリジェンスが得られます

> **ヒント:** 設定が複雑なプロジェクトでは、フレームワークのドキュメントを手元に置いておきましょう。Zed の高速さは、フレームワーク固有の機能に対するサポートの少なさとトレードオフになっています。

### ツールウィンドウとドック

WebStorm は補助的なビューを番号付きのツールウィンドウとして整理します。Zed では、これに似た概念として「ドック」が使われます:

| WebStorm Tool Window | Zed の対応するパネル | Zed のキーバインド                             |
| -------------------- | -------------------- | ---------------------------------------------- |
| Project              | Project Panel        | {#kb:jetbrains project_panel::ToggleFocus}     |
| Git                  | Git Panel            | {#kb:jetbrains git_panel::ToggleFocus}         |
| Terminal             | Terminal Panel       | {#kb:jetbrains terminal_panel::Toggle}         |
| Structure            | Outline Panel        | {#kb:jetbrains outline_panel::ToggleFocus}     |
| Problems             | Diagnostics          | {#kb:jetbrains diagnostics::Deploy}            |
| Debug                | Debug Panel          | {#kb:jetbrains debug_panel::ToggleFocus}       |

Zed には左・下・右の 3 つのドック位置があります。パネルはドラッグ操作や設定画面から、ドック間を移動できます。

なお、Zed には専用の npm ツールウィンドウはありません。ターミナルを使うか、よく使う npm スクリプト用のタスクを定義してください。

### デバッグ

WebStorm と Zed の両方が、JavaScript と TypeScript の統合デバッグ機能を提供しています:

- Zed は `vscode-js-debug` を使用します（VS Code と同じデバッグアダプターです）
- {#kb:jetbrains editor::ToggleBreakpoint} でブレークポイントを設定します
- {#kb:jetbrains debugger::Start} でデバッグを開始します
- {#kb:jetbrains debugger::StepInto}（step into）、{#kb:jetbrains debugger::StepOver}（step over）、{#kb:jetbrains debugger::StepOut}（step out）でコードをステップ実行します
- {#kb:jetbrains debugger::Continue} で実行を再開します

Zed でデバッグできる対象:

```
- Node.js アプリケーションとスクリプト
- Chrome/ブラウザー JavaScript
- Jest、Mocha、Vitest などのテストフレームワーク
- Next.js（サーバー・クライアント両方）

より細かく制御したい場合は、`.zed/debug.json` ファイルを作成します:

```json
[
  {
    "label": "Debug Current File",
    "adapter": "JavaScript",
    "program": "$ZED_FILE",
    "request": "launch"
  },
  {
    "label": "Debug Node Server",
    "adapter": "JavaScript",
    "request": "launch",
    "program": "${workspaceFolder}/src/server.js"
  },
  {
    "label": "Attach to Chrome",
    "adapter": "JavaScript",
    "request": "attach",
    "port": 9222
  }
]
```

Zed は `.vscode/launch.json` の設定も認識するため、既存の VS Code のデバッグ設定がそのまま動作することがよくあります。

### テストの実行

WebStorm には各テストの成功/失敗ステータスを表示する専用のビジュアルなテストランナーがあります。Zed では、次のような方法でテストを実行できます:

- **Gutter icons** — テスト関数や describe ブロックの横にある再生ボタンをクリックします
- **Tasks** — `tasks.json` でテストコマンドを定義します
- **Terminal** — `npm test`、`jest`、`vitest` などを直接実行します

Zed は一般的なテストフレームワークを自動検出します:

- Jest
- Mocha
- Vitest
- Jasmine
- Bun test
- Node.js test runner

テストの出力はターミナルパネルに表示されます。Jest の場合、詳細な出力には `--verbose` を、開発中に継続的にテストを実行するには `--watch` を使用します。

### 拡張機能とプラグイン

WebStorm には、追加の言語サポート、テーマ、ツール連携をカバーするプラグインカタログがあります。

Zed の拡張機能カタログはより小さく、よりフォーカスされています:

- 言語サポートとシンタックスハイライト
- テーマ
- コンテキストサーバー

WebStorm ではプラグインが必要な機能の多くが、Zed では標準で組み込まれています:

- 音声チャット付きリアルタイムコラボレーション
- AI コーディングアシスタンス
- 組み込みターミナル
- タスクランナー
- LSP ベースのコードインテリジェンス
- Prettier フォーマット
- ESLint 連携

### Zed にないもの

期待値を明確にするために、WebStorm にはあるが Zed にはない機能を挙げます:

- **npm tool window** — 代わりにターミナルまたはタスクを使用してください
- **HTTP Client** — Postman、Insomnia、curl などのツールを使用してください
- **Database tools** — DataGrip、DBeaver、TablePlus を使用してください
- **Framework-specific tooling** (Angular schematics, React refactorings) — CLI ツールを使用してください
- **Visual package.json editor** — ファイルを直接編集してください
- **Built-in REST client** — 外部ツールや拡張機能を使用してください
- **Profiler integration** — Chrome DevTools や Node.js のプロファイリングツールを使用してください

## Zed と WebStorm におけるコラボレーション

WebStorm には、コラボレーション用の別機能として Code With Me が用意されています。Zed では、コラボレーション機能がコアの体験に組み込まれています。

- 左ドックで Collab パネルを開きます
- チャンネルを作成し、[コラボレーターを招待します](https://zed.dev/docs/collaboration#inviting-a-collaborator)
- [画面またはコードベースを直接共有します](https://zed.dev/docs/collaboration#share-a-project)

接続すると、お互いのカーソル、選択範囲、編集内容がリアルタイムに表示されます。音声チャットも含まれています。別のツールやサードパーティのログインは必要ありません。

## Zed での AI 利用

WebStorm の AI アシスタント（GitHub Copilot、JetBrains AI Assistant、Junie など）に慣れている場合でも、Zed は同等の機能をより柔軟に提供します。

### GitHub Copilot の設定

1. {#kb zed::OpenSettings} で Settings を開きます
2. **AI → Edit Predictions** に移動します
3. "Configure Providers" の横にある **Configure** をクリックします
4. **GitHub Copilot** セクションで **Sign in to GitHub** をクリックします

サインインが完了したら、そのまま入力を始めてください。Zed がインラインで提案を表示するので、必要に応じて受け入れます。

### その他の AI オプション

Zed で他の AI モデルを使うには、いくつかの選択肢があります:

- Zed のホスト型モデルを使用する（より高いレート制限付き）。その場合は [authentication](https://zed.dev/docs/authentication) と [Zed Pro](https://zed.dev/docs/ai/subscription.html) へのサブスクリプションが必要です。
- 自分の [API keys](https://zed.dev/docs/ai/llm-providers.html) を利用する（認証は不要）
- [Claude Agent のような外部エージェント](https://zed.dev/docs/ai/external-agents.html) を利用する

## 上級設定と生産性向上のための調整

Zed では、環境を細かく調整したいパワーユーザー向けに高度な設定が公開されています。

以下は、JavaScript/TypeScript 開発者に役立ついくつかの調整例です:

**保存時にフォーマット:**

```json
"format_on_save": "on"
```

**Prettier をデフォルトのフォーマッターとして設定**（JSON を手動で編集する必要があります）:

```json
{
  "formatter": {
    "external": {
      "command": "prettier",
      "arguments": ["--stdin-filepath", "{buffer_path}"]
    }
  }
}
```

**ESLint のコードアクションを有効化**（JSON を手動で編集する必要があります）:

```json
{
  "lsp": {
    "eslint": {
      "settings": {
        "codeActionOnSave": {
          "rules": ["import/order"]
        }
      }
    }
  }
}
```

**TypeScript の strict モードのヒントを設定:**

`tsconfig.json` で strict モードを有効にし、より厳密な型チェックを行います:

```json
{
  "compilerOptions": {
    "strict": true,
    "noUncheckedIndexedAccess": true
  }
}
```

**direnv サポートを有効化（環境変数に direnv を使用しているプロジェクトに便利です）:**

```json
"load_direnv": "shell_hook"
```

## 次のステップ

セットアップが完了したら、Zed を最大限に活用するために次のリソースを参照してください:

- [すべての設定](../reference/all-settings.md) — 設定、テーマ、エディターの動作をカスタマイズします
- [キーバインド](../key-bindings.md) — キーマップのカスタマイズと拡張方法を学びます
- [タスク](../tasks.md) — プロジェクト用のビルドおよび実行コマンドを設定します
- [AI 機能](../ai/overview.md) — コード補完以外の Zed の AI 機能を探ります
- [コラボレーション](../collaboration/overview.md) — プロジェクトとコードをリアルタイムで共有します
- [Zed における JavaScript](../languages/javascript.md) — JavaScript 固有のセットアップと設定
- [Zed における TypeScript](../languages/typescript.md) — TypeScript 固有のセットアップと設定
