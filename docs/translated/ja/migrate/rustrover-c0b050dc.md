# RustRover から Zed への移行方法

このガイドでは、RustRover から移行する Rust 開発者向けに、キーバインド、設定、および主な違いについて説明します。

## Zed をインストールする

Zed は macOS、Windows、Linux 向けに提供されています。

macOS の場合は zed.dev/download からダウンロードするか、Homebrew 経由でインストールできます:

```sh
brew install --cask zed
```

Windows の場合は zed.dev/download からインストーラーをダウンロードするか、winget 経由でインストールできます:

```sh
winget install Zed.Zed
```

多くの Linux ユーザーにとって、Zed をインストールする最も簡単な方法は、インストールスクリプトを使うことです:

```sh
curl -f https://zed.dev/install.sh | sh
```

インストール後は、Zed をアプリケーションフォルダ（macOS）、スタートメニュー（Windows）から起動するか、ターミナルから直接次のように実行できます:
`zed .`
これにより、カレントディレクトリが Zed で開かれます。

## JetBrains キーマップを設定する

RustRover から移行する場合、すぐに使い慣れた感覚に近づく最速の方法は JetBrains キーマップを使うことです。オンボーディング中に、ベースキーマップとして選択できます。もしそのステップを飛ばしてしまった場合でも、いつでも変更できます:

1. `Cmd+,`（macOS）または `Ctrl+,`（Linux/Windows）で Settings を開く
2. `Base Keymap` を検索する
3. `JetBrains` を選択する

これにより、Search Everywhere 用の `Shift Shift`、Go to Class 用の `Cmd+O`、Find Action 用の `Cmd+Shift+A` など、おなじみのショートカットが割り当てられます。

## エディター設定を行う

ほとんどの設定は Settings Editor ({#kb zed::OpenSettings}) で構成できます。より高度な設定を行うには、Command Palette から `zed: open settings file` を実行して設定ファイルを直接編集します。

RustRover ユーザーが最初に設定することが多い項目:

| Zed 設定                 | 機能説明                                                                 |
| ------------------------ | ------------------------------------------------------------------------ |
| `format_on_save`         | 保存時に自動フォーマットします。有効にするには `"on"` に設定します（デフォルトで rustfmt を使用）。 |
| `soft_wrap`              | 長い行を折り返します。オプション: `"none"`, `"editor_width"`, `"preferred_line_length"` |
| `preferred_line_length`  | 折り返しやルーラーの列幅です。Rust の慣習では 100 が一般的です。       |
| `inlay_hints`            | 型ヒント、パラメーター名、チェーンのヒントをインライン表示します。      |
| `relative_line_numbers`  | IdeaVim から移行する場合に便利です。                                     |

Zed はプロジェクトごとの設定にも対応しています。プロジェクトルートに `.zed/settings.json` ファイルを作成すると、そのプロジェクトに対してグローバル設定を上書きできます。

> **Tip:** 既存プロジェクトに参加する場合は、最初のコミットを行う前に `format_on_save` を確認してください。そうしないと、1 行だけ変更したつもりが、ファイル全体を誤って再フォーマットしてしまうかもしれません。

## プロジェクトを開く／作成する

セットアップ後、`Cmd+Shift+O`（JetBrains キーマップ使用時）でフォルダを開けます。これが Zed におけるワークスペースになります。

新しいプロジェクトを開始するには、ターミナルから Cargo を使用します:

```sh
cargo new my_project
cd my_project
zed .
```

ライブラリの場合:

```sh
cargo new --lib my_library
```

既存の任意の Cargo プロジェクト内のターミナルから Zed を起動することもできます:
`zed .`

プロジェクト内では次のように操作します:

- `Cmd+Shift+O` または `Cmd+E` を使用してファイル間を素早く移動します（RustRover の「Recent Files」に相当）
- `Cmd+Shift+A` または `Shift Shift` を使用して Command Palette を開きます（RustRover の「Search Everywhere」に相当）
- `Cmd+O` を使用してシンボルを検索します（RustRover の「Go to Symbol」に相当）

開いているバッファは上部にタブとして表示されます。Project Panel にはファイルツリーと Git ステータスが表示されます。`Cmd+1` で切り替えられます（RustRover の Project ツールウィンドウと同様）。

## キーバインドの違い

オンボーディング中に JetBrains キーマップを選択していれば、ほとんどのショートカットはすでに使い慣れたものになっているはずです。ここでは、Zed と RustRover の比較に関するクイックリファレンスを示します。

### 共通のキーバインド

| アクション                      | ショートカット             |
| ------------------------------ | -------------------------- |
| Search Everywhere              | `Shift Shift`              |
| Find Action / Command Palette  | `Cmd + Shift + A`          |
| Go to File                     | `Cmd + Shift + O`          |
| Go to Symbol                   | `Cmd + O`                  |
| Recent Files                   | `Cmd + E`                  |
| Go to Definition               | `Cmd + B`                  |
| Find Usages                    | `Alt + F7`                 |
| Rename Symbol                  | `Shift + F6`               |
| Reformat Code                  | `Cmd + Alt + L`            |
| Toggle Project Panel           | `Cmd + 1`                  |
| Toggle Terminal                | `Alt + F12`                |
| Duplicate Line                 | `Cmd + D`                  |
| Delete Line                    | `Cmd + Backspace`          |
| Move Line Up/Down              | `Shift + Alt + Up/Down`    |
| Expand/Shrink Selection        | `Alt + Up/Down`            |
| Comment Line                   | `Cmd + /`                  |
| Go Back / Forward              | `Cmd + [` / `Cmd + ]`      |
| Toggle Breakpoint              | `Ctrl + F8`                |

### 異なるキーバインド（RustRover → Zed）

| アクション               | RustRover   | Zed (JetBrains キーマップ) |
| ------------------------ | ----------- | --------------------------- |
| File Structure           | `Cmd + F12` | `Cmd + F12`（アウトライン） |
| Navigate to Next Error   | `F2`        | `F2`                        |
| Run                      | `Ctrl + R`  | `Ctrl + Alt + R`（tasks）   |
| Debug                    | `Ctrl + D`  | `Alt + Shift + F9`          |
| Stop                     | `Cmd + F2`  | `Ctrl + F2`                 |
| Expand Macro             | `Alt+Enter` | `Cmd + Shift + M`           |

### Zed 固有の機能

| アクション            | ショートカット               | 備考                               |
| --------------------- | ---------------------------- | ---------------------------------- |
| Toggle Right Dock     | `Cmd + R`                    | Assistant パネル、通知             |
| Split Panes           | `Cmd + K` の後に矢印キー     | 任意の方向に分割を作成             |

### キーバインドをカスタマイズする方法

- Command Palette（`Cmd+Shift+A` または `Shift Shift`）を開く
- `Zed: Open Keymap Editor` を実行する

すると、利用可能なすべてのバインディングの一覧が開きます。個々のショートカットを上書きしたり、競合を解消したりできます。

Zed はキーシーケンス（複数キーのショートカット）にも対応しています。

## ユーザーインターフェイスの違い

### 解析エンジンの違い

RustRover は Rust インテリジェンスのために独自のプロプライエタリなコード解析エンジンを使用しています。Zed は Language Server Protocol（LSP）経由で rust-analyzer を使用します。

これが意味するところ:

- **補完、定義へのジャンプ、使用箇所の検索、型推論** — いずれも rust-analyzer を通じて Zed で利用できます
- **マクロ展開** — 両方で利用可能です（Zed では `Cmd+Shift+M` を使用）
- **インレイヒント** — 両方とも型ヒント、パラメーターヒント、チェーンのヒントをサポートしています

違いを感じるかもしれない点:

- RustRover で利用できる一部のリファクタリングは、rust-analyzer に対応する機能がない場合があります
- Clippy 以外の、RustRover 固有のインスペクションは Zed には存在しません
- rust-analyzer は GUI ではなく、Zed では JSON によって構成されます

**How to adapt:**```

- 利用可能なコードアクションを呼び出すには `Alt+Enter` を使用します—rust-analyzer が多数提供しています
- プロジェクト固有のニーズに合わせて `.zed/settings.json` で rust-analyzer の設定を行います
- リントには `cargo clippy` を実行します（rust-analyzer の診断と統合されています）

### プロジェクト設定

どちらのエディタも、プロジェクトごとの設定を隠しフォルダに保存します。RustRover は `.idea`（XML ファイル）を使用し、Zed は `.zed`（JSON ファイル）を使用します。

**実行構成は引き継がれません。** RustRover は実行/デバッグ構成を `.idea` に保存します。これらには自動的な移行経路がありません。Zed では、それらを `.zed/tasks.json` で Zed の [タスク](../tasks.md) として、そして `.zed/debug.json` でデバッグ構成として作り直すことになります。

**Cargo ツールウィンドウはありません。** RustRover では、ワークスペースのメンバー、ターゲット、フィーチャ、依存関係のビジュアルツリーが提供されます。Zed にはこれはありません。`Cargo.toml` と Cargo CLI を直接扱うことになります。

**ツールチェーン管理は外部で行います。** RustRover では、設定 UI からツールチェーンの選択や切り替えができます。Zed では、ツールチェーンは `rustup` を通じて管理します。

**設定はオプトインです。** RustRover はプロジェクトを開くと自動的に `.idea` を生成します。Zed は何も自動生成しません。必要に応じて `.zed/settings.json`、`tasks.json`、`debug.json` を自分で作成します。

**適応方法:**

- プロジェクトのルートに `.zed/settings.json` を作成し、プロジェクト固有の設定を記述します
- よく使うコマンドを `tasks.json` に定義します（コマンドパレットから `zed: open tasks` で開きます）:

```json
[
  {
    "label": "cargo run",
    "command": "cargo run"
  },
  {
    "label": "cargo build",
    "command": "cargo build"
  },
  {
    "label": "cargo test",
    "command": "cargo test"
  },
  {
    "label": "cargo clippy",
    "command": "cargo clippy"
  },
  {
    "label": "cargo run --release",
    "command": "cargo run --release"
  }
]
```

- `Ctrl+Alt+R` でタスクをすばやく実行します
- タスクでカバーされない処理には、ターミナル（`Alt+F12`）を活用します

### Cargo 統合 UI がない

RustRover の Cargo ツールウィンドウは、プロジェクトのターゲット、依存関係、および一般的な Cargo コマンドへのビジュアルなアクセスを提供します。ビルド、テスト、ベンチマークをクリックひとつで実行できます。

Zed には Cargo の GUI がありません。Cargo とは次の方法でやり取りします。

- **Terminal** — 任意の Cargo コマンドを直接実行します
- **Tasks** — よく使うコマンドのショートカットを定義します
- **Gutter icons** — クリック可能なアイコンからテストやバイナリを実行します

**適応方法:**

- `cargo build`, `cargo run`, `cargo test`, `cargo clippy`, `cargo doc` などの Cargo CLI コマンドに慣れておきます
- 頻繁に実行するコマンドには tasks を使用します
- 依存関係の管理には `Cargo.toml` を直接編集します（crate 名やバージョンについては rust-analyzer が補完を提供します）

### ツールウィンドウとドック

RustRover は補助ビューを番号付きのツールウィンドウ（Project = 1、Cargo = Alt+1、Terminal = Alt+F12 など）として整理しています。Zed では、これと似たコンセプトとして「docks」が使われます。

| RustRover のツールウィンドウ | Zed での対応 | Shortcut (JetBrains keymap) |
| --------------------- | -------------- | --------------------------- |
| Project (1)           | Project Panel  | `Cmd + 1`                   |
| Git (9 or Cmd+0)      | Git Panel      | `Cmd + 0`                   |
| Terminal (Alt+F12)    | Terminal Panel | `Alt + F12`                 |
| Structure (7)         | Outline Panel  | `Cmd + 7`                   |
| Problems (6)          | Diagnostics    | `Cmd + 6`                   |
| Debug (5)             | Debug Panel    | `Cmd + 5`                   |

Zed には左・下・右の 3 つのドック位置があります。パネルはドラッグまたは設定から、ドック間で移動できます。

Zed には専用の Cargo ツールウィンドウがないことに注意してください。よく使う Cargo コマンドにはターミナルを利用するか、tasks を定義して対応します。

### デバッグ

RustRover と Zed のどちらも Rust 用の統合デバッグ機能を提供しますが、使用しているバックエンドが異なります。

- RustRover は独自のデバッガ統合を使用します
- Zed は **CodeLLDB** を使用します（VS Code で一般的なデバッグアダプタと同じものです）

Zed で Rust コードをデバッグするには次のようにします。

- `Ctrl+F8` でブレークポイントを設定します
- `Alt+Shift+F9` でデバッグを開始するか、`F4` を押してデバッグ対象を選択します
- `F7`（ステップイン）、`F8`（ステップオーバー）、`Shift+F8`（ステップアウト）でコードをステップ実行します
- `F9` で実行を継続します

Zed は Cargo プロジェクト内のデバッグ可能なターゲットを自動的に検出できます。`F4` を押すと利用可能なオプションが表示されます。

より詳細に制御したい場合は、`.zed/debug.json` ファイルを作成します。

```json
[
  {
    "label": "Debug Binary",
    "adapter": "CodeLLDB",
    "request": "launch",
    "program": "${workspaceFolder}/target/debug/my_project"
  },
  {
    "label": "Debug Tests",
    "adapter": "CodeLLDB",
    "request": "launch",
    "cargo": {
      "args": ["test", "--no-run"],
      "filter": {
        "kind": "test"
      }
    }
  },
  {
    "label": "Debug with Arguments",
    "adapter": "CodeLLDB",
    "request": "launch",
    "program": "${workspaceFolder}/target/debug/my_project",
    "args": ["--config", "dev.toml"]
  }
]
```

### テストの実行

RustRover には各テストの成功/失敗ステータスを視覚的に表示する専用のテストランナーがあります。Zed では次の方法でテストを実行できます。

- **Gutter icons** — `#[test]` 関数やテストモジュールの横にある再生ボタンをクリックします
- **Tasks** — `tasks.json` に `cargo test` コマンドを定義します
- **Terminal** — `cargo test` を直接実行します

テスト出力はターミナルパネルに表示されます。より詳細な出力が必要な場合は、次のコマンドを使用します。

- `cargo test -- --nocapture` — `println!` の出力を表示します
- `cargo test -- --test-threads=1` — テストを逐次実行します
- `cargo test specific_test_name` — 単一のテストだけを実行します

### エクステンションとプラグイン

RustRover には JetBrains のプラグインカタログ全体が利用できます。

Zed のエクステンションカタログはより小さく、より焦点を絞ったものになっています。

- 言語サポートとシンタックスハイライト
- テーマ
- コンテキストサーバー

他のエディタではプラグインが必要になるような機能のいくつかは、Zed では組み込みになっています。

- 音声チャット付きのリアルタイムコラボレーション
- AI コーディング支援
- 組み込みターミナル
- タスクランナー
- rust-analyzer との統合
- rustfmt によるフォーマット

### Zed にないもの

RustRover が提供していて、Zed にはない機能は次のとおりです。

- **プロファイラ統合** — `cargo flamegraph`、`perf`、その他の外部プロファイリングツールを使用します
- **データベースツール** — DataGrip、DBeaver、TablePlus などを使用します
- **HTTP クライアント** — `curl`、`httpie`、Postman などのツールを使用します
- **カバレッジの可視化** — 外部で `cargo tarpaulin` や `cargo llvm-cov` を使用します

## ライセンスとテレメトリに関する注意

ライセンスとテレメトリについて:

- **Zed はオープンソースです**（エディタは MIT ライセンス、コラボレーションサービスは AGPL）
- **テレメトリは任意です**。オンボーディング中または設定で無効化できます。

## Zed と RustRover のコラボレーション機能

RustRover では、コラボレーション用に Code With Me が別機能として提供されています。Zed ではコラボレーションがコア体験として組み込まれています。

- 左側のドックで Collab パネルを開きます
- チャンネルを作成し、[共同作業者を招待](https://zed.dev/docs/collaboration#inviting-a-collaborator)して参加してもらいます
- 直接[画面やコードベースを共有](https://zed.dev/docs/collaboration#share-a-project)します

接続されると、お互いのカーソル、選択範囲、編集内容をリアルタイムで確認できます。ボイスチャットも含まれており、別のツールやサードパーティのログインは必要ありません。

## Zed での AI 利用

Zed には AI 機能が組み込まれています。JetBrains AI Assistant を使用したことがある場合は、次の手順でセットアップできます。

### GitHub Copilot の設定

1. macOS では `Cmd+,`、Linux/Windows では `Ctrl+,` で Settings を開きます
2. **AI → Edit Predictions** に移動します
3. 「Configure Providers」の横にある **Configure** をクリックします
4. **GitHub Copilot** の項目で **Sign in to GitHub** をクリックします

サインインが完了したら、そのまま入力を開始してください。Zed がインラインで候補を表示するので、受け入れて利用できます。

### 追加の AI オプション

Zed で他の AI モデルを利用するには、いくつかの方法があります:

- レート制限がより高い Zed のホスト型モデルを使用する。[認証](https://zed.dev/docs/authentication) と [Zed Pro](https://zed.dev/docs/ai/subscription.html) へのサブスクリプションが必要です。
- 自分の [API keys](https://zed.dev/docs/ai/llm-providers.html) を使用する（認証は不要）
- [Claude Agent などの外部エージェント](https://zed.dev/docs/ai/external-agents.html) を使用する

## 高度な設定と生産性向上のための調整

Zed では、環境を細かく調整したいパワーユーザー向けに高度な設定項目が公開されています。

ここでは、Rust 開発者に役立ついくつかの調整方法を紹介します:

**保存時に自動整形（デフォルトで rustfmt を使用）:**

```json
"format_on_save": "on"
```

**Rust 向けのインレイヒントを設定:**

```json
{
  "inlay_hints": {
    "enabled": true,
    "show_type_hints": true,
    "show_parameter_hints": true,
    "show_other_hints": true
  }
}
```

**rust-analyzer の設定を構成**（JSON を手動で編集する必要があります）:

```json
{
  "lsp": {
    "rust-analyzer": {
      "initialization_options": {
        "checkOnSave": {
          "command": "clippy"
        },
        "cargo": {
          "allFeatures": true
        },
        "procMacro": {
          "enable": true
        }
      }
    }
  }
}
```

**rust-analyzer 用に別の target ディレクトリを使用（ビルドを高速化）:**

```json
{
  "lsp": {
    "rust-analyzer": {
      "initialization_options": {
        "rust-analyzer.cargo.targetDir": true
      }
    }
  }
}
```

これにより、rust-analyzer は `target` の代わりに `target/rust-analyzer` を使用するようになり、IDE の解析が手動で実行する `cargo build` コマンドと競合しなくなります。

**direnv サポートを有効化（direnv を使う Rust プロジェクトに便利）:**

```json
"load_direnv": "shell_hook"
```

**ワークスペース向けにリンクされたプロジェクトを設定:**

ワークスペースに含まれていない複数の Cargo プロジェクトを扱っている場合、それらを rust-analyzer に知らせることができます:

```json
{
  "lsp": {
    "rust-analyzer": {
      "initialization_options": {
        "linkedProjects": ["./project-a/Cargo.toml", "./project-b/Cargo.toml"]
      }
    }
  }
}
```

## 次のステップ

セットアップが完了したので、Zed を最大限に活用するためのリソースをいくつか紹介します:

- [すべての設定](../reference/all-settings.md) — 設定、テーマ、エディターの挙動をカスタマイズ
- [キーバインド](../key-bindings.md) — キーマップをカスタマイズおよび拡張する方法を学ぶ
- [タスク](../tasks.md) — プロジェクト向けのビルドおよび実行コマンドを設定
- [AI 機能](../ai/overview.md) — コード補完を超えた Zed の AI 機能を探る
- [コラボレーション](../collaboration/overview.md) — プロジェクトやコードをリアルタイムで共同編集・共有する
- [Zed での Rust](../languages/rust.md) — Rust 向けのセットアップと設定
