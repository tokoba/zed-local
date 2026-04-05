# IntelliJ IDEA から Zed へ移行する方法

このガイドでは、IntelliJ IDEA から移行する際に Zed をどのようにセットアップするか（キーバインド、設定、および想定される違い）について説明します。

## Zed をインストールする

Zed は macOS、Windows、Linux で利用できます。

macOS の場合は、zed.dev/download からダウンロードするか、Homebrew でインストールできます:

```sh
brew install --cask zed
```

Windows の場合は、zed.dev/download からインストーラーをダウンロードするか、winget でインストールできます:

```sh
winget install Zed.Zed
```

ほとんどの Linux ユーザーにとって、Zed をインストールする最も簡単な方法は、次のインストールスクリプトを使うことです:

```sh
curl -f https://zed.dev/install.sh | sh
```

インストール後は、macOS では Applications フォルダから、Windows ではスタートメニューから Zed を起動できます。また、ターミナルから次のように実行して直接起動することもできます:
`zed .`
このコマンドは、現在のディレクトリを Zed で開きます。

## JetBrains キーマップを設定する

IntelliJ から移行してきた場合、すぐに馴染むための最速の方法は、JetBrains キーマップを使うことです。オンボーディング時に、これをベースキーマップとして選択できます。そのステップを見逃してしまっても、いつでも変更できます:

1. `Cmd+,`（macOS）または `Ctrl+,`（Linux/Windows）で Settings を開く
2. `Base Keymap` を検索する
3. `JetBrains` を選択する

これにより、Search Everywhere 用の `Shift Shift`、Go to Class 用の `Cmd+O`、Find Action 用の `Cmd+Shift+A` など、おなじみのショートカットが割り当てられます。

## エディターの設定を行う

ほとんどの設定は Settings Editor ({#kb zed::OpenSettings}) で構成できます。高度な設定については、コマンドパレットから `zed: open settings file` を実行して、設定ファイルを直接編集します。

IntelliJ ユーザーが最初に設定することが多い項目:

| Zed 設定項目            | 機能                                                                 |
| ----------------------- | -------------------------------------------------------------------- |
| `format_on_save`        | 保存時に自動フォーマットします。有効にするには `"on"` に設定します。 |
| `soft_wrap`             | 長い行を折り返します。指定可能な値: `"none"`、`"editor_width"`、`"preferred_line_length"` |
| `preferred_line_length` | 折り返しとルーラーに使用する桁幅を指定します。デフォルトは 80 です。 |
| `inlay_hints`           | パラメーター名や型ヒントを IntelliJ と同様にインライン表示します。   |
| `relative_line_numbers` | IdeaVim を使っていた場合に便利です。                                 |

Zed ではプロジェクトごとの設定もサポートしています。プロジェクトのルートに `.zed/settings.json` ファイルを作成すると、そのプロジェクトに対してだけグローバル設定を上書きできます。これは IntelliJ で `.idea` フォルダーを使うのと同様の仕組みです。

> **Tip:** 既存のプロジェクトに参加する場合は、最初のコミットの前に `format_on_save` を確認してください。1 行だけ変更したつもりが、ファイル全体を誤って再フォーマットしてしまうかもしれません。

## プロジェクトを開く・作成する

セットアップが完了したら、JetBrains キーマップ使用時は `Cmd+Shift+O` を押してフォルダーを開きます。これが Zed におけるワークスペースになります。IntelliJ と異なり、プロジェクト設定ウィザードや `.iml` ファイル、SDK のセットアップは不要です。

新しいプロジェクトを始めるには、ターミナルやファイルマネージャーでディレクトリを作成し、それを Zed で開きます。エディターはそのフォルダーをプロジェクトのルートとして扱います。

任意のフォルダー内のターミナルから、次のコマンドで Zed を起動することもできます:
`zed .`

プロジェクト内では次のように操作できます:

- `Cmd+Shift+O` や `Cmd+E` を使ってファイル間をすばやく移動できます（IntelliJ の "Recent Files" のような操作）。
- `Cmd+Shift+A` や `Shift Shift` でコマンドパレットを開きます（IntelliJ の "Search Everywhere" のような操作）。
- `Cmd+O` でシンボルを検索します（IntelliJ の "Go to Class" のような操作）。

開いているバッファーは上部のタブとして表示されます。Project パネルにはファイルツリーや Git のステータスが表示されます。`Cmd+1` で表示の切り替えができます（IntelliJ の Project ツールウィンドウと同様です）。

## キーバインドの違い

オンボーディング時に JetBrains キーマップを選択していれば、多くのショートカットはすでに馴染みのあるものになっているはずです。ここでは、Zed と IntelliJ の対応関係を簡単にまとめます。

### 共通のキーバインド（JetBrains キーマップを使った Zed ↔ IntelliJ）

| アクション                      | ショートカット            |
| ------------------------------ | ------------------------- |
| Search Everywhere              | `Shift Shift`            |
| Find Action / Command Palette  | `Cmd + Shift + A`        |
| Go to File                     | `Cmd + Shift + O`        |
| Go to Symbol / Class           | `Cmd + O`                |
| Recent Files                   | `Cmd + E`                |
| Go to Definition               | `Cmd + B`                |
| Find Usages                    | `Alt + F7`               |
| Rename Symbol                  | `Shift + F6`             |
| Reformat Code                  | `Cmd + Alt + L`          |
| Toggle Project Panel           | `Cmd + 1`                |
| Toggle Terminal                | `Alt + F12`              |
| Duplicate Line                 | `Cmd + D`                |
| Delete Line                    | `Cmd + Backspace`        |
| Move Line Up/Down              | `Shift + Alt + Up/Down`  |
| Expand/Shrink Selection        | `Alt + Up/Down`          |
| Comment Line                   | `Cmd + /`                |
| Go Back / Forward              | `Cmd + [` / `Cmd + ]`    |
| Toggle Breakpoint              | `Ctrl + F8`              |

### 異なるキーバインド（IntelliJ → Zed）

| アクション               | IntelliJ    | Zed（JetBrains キーマップ） |
| ------------------------ | ----------- | ---------------------------- |
| File Structure           | `Cmd + F12` | `Cmd + F12` (outline)        |
| Navigate to Next Error   | `F2`        | `F2`                         |
| Run                      | `Ctrl + R`  | `Ctrl + Alt + R` (tasks)     |
| Debug                    | `Ctrl + D`  | `Alt + Shift + F9`           |
| Stop                     | `Cmd + F2`  | `Ctrl + F2`                  |

### Zed 固有のキーバインド

| アクション           | ショートカット                 | 備考                              |
| -------------------- | ------------------------------ | --------------------------------- |
| Toggle Right Dock    | `Cmd + R`                      | アシスタントパネル、通知          |
| Split Panes          | `Cmd + K` の後に矢印キー       | 任意の方向に分割を作成します      |

### キーバインドをカスタマイズする方法

- コマンドパレットを開きます（`Cmd+Shift+A` または `Shift Shift`）。
- `Zed: Open Keymap Editor` を実行します。

これにより、利用可能なすべてのバインドの一覧が開きます。個々のショートカットを上書きしたり、競合を解消したりできます。

Zed はキーシーケンス（複数キーのショートカット）もサポートしています。

## ユーザーインターフェースの違い

### インデックス作成がない

大規模なプロジェクトで IntelliJ を使ったことがあれば、「Indexing...」と表示されてからの待ち時間をご存じだと思います。プロジェクトの規模によっては 30 秒から 15 分ほどかかることもあります。IntelliJ はコードインテリジェンス機能のためにコードベース全体の包括的なインデックスを構築し、依存関係の変更やビルド後には再インデックスを行います。

Zed はインデックスを作成しません。フォルダーを開けばすぐに作業を開始できます。ファイル検索やナビゲーションは、プロジェクトの規模にかかわらず即座に機能します。

IntelliJ のインデックスは、コードベース全体からのすべての使用箇所の検索、クラス階層の把握、未使用コードの検出といった機能を支えています。Zed はこの種の処理を言語サーバーに委ねており、必ずしも同じ深さまで解析されるとは限りません。

**どのように対応するか:**

- プロジェクト全体のシンボル検索には `Cmd+O` / Go to Symbol を使用します（言語サーバーに依存します）
- ファイル名で検索するには `Cmd+Shift+O` / Go to File を使用します
- ファイル全体でのテキスト検索には `Cmd+Shift+F` を使用します — 大規模なコードベースでも高速です
- JVM コードに対してより高度な静的解析が必要な場合は、IntelliJ のインスペクションを別ステップとして実行するか、Checkstyle、PMD、SpotBugs などのスタンドアロンツールの利用を検討してください

### LSP とネイティブな言語インテリジェンス

IntelliJ には、サポートしている各言語ごとにゼロから実装された独自の言語解析エンジンがあります。Java、Kotlin などの JVM 言語に対しては、このエンジンがコードを深く理解しており、型の解決、データフローの追跡、フレームワークのアノテーションの把握、そして多数の専用リファクタリングを提供します。

Zed はコードインテリジェンスに Language Server Protocol (LSP) を使用します。各言語にはそれぞれ専用のサーバーがあり、Java には `jdtls`、Rust には `rust-analyzer` などがあります。

言語によっては、LSP による体験は非常に優れています。TypeScript、Rust、Go には成熟した言語サーバーがあり、高速で正確な補完、診断、リファクタリングを提供します。一方、JVM 言語では差がより顕著になるかもしれません。Eclipse ベースの Java 言語サーバーも十分有能ですが、次のような点では IntelliJ ほどの深さはありません:

- Spring や Jakarta EE のアノテーション処理
- 複雑なリファクタリング（インターフェースの抽出、メンバーの上位クラスへの移動、呼び出し元を含めたシグネチャ変更など）
- フレームワークを考慮したインスペクション
- カスタムの並び順ルールを用いた自動 import 最適化

**どう適応するか:**

- 利用可能なコードアクションには `Alt+Enter` を使います — 内容は言語サーバーごとに異なります
- Java の場合、設定で `jdtls` に正しい JDK パスが設定されていることを確認してください

### プロジェクトモデルがない

IntelliJ は、XML 設定ファイルを含む `.idea` フォルダー、`.iml` モジュール定義、SDK の割り当て、実行構成を通してプロジェクトを管理します。このモデルにより、IntelliJ はマルチモジュールプロジェクトを理解し、依存関係を自動で管理し、複雑な実行/デバッグ構成を永続化できます。

Zed にはプロジェクトモデルがありません。プロジェクトは単なるフォルダーです。ウィザードも、SDK 選択画面も、モジュール設定も存在しません。

これは次のことを意味します:

- ビルドコマンドは手動です。Zed は Maven や Gradle プロジェクトを自動検出しません。
- 実行構成は存在しません。タスクを定義するか、ターミナルを使用します。
- SDK の管理は外部で行います。言語サーバーは PATH にある JDK をそのまま使用します。
- モジュールの境界はありません。Zed はプロジェクト構造ではなく、フォルダーとしてのみ認識します。

**どう適応するか:**

- プロジェクト固有の設定用に、プロジェクトルートに `.zed/settings.json` を作成します
- `tasks.json` に共通コマンドを定義します（Command Palette から `zed: open tasks` で開きます）:

```json
[
  {
    "label": "build",
    "command": "./gradlew build"
  },
  {
    "label": "run",
    "command": "./gradlew bootRun"
  },
  {
    "label": "test current file",
    "command": "./gradlew test --tests $ZED_STEM"
  }
]
```

- タスクを素早く実行するには `Ctrl+Alt+R` を使います
- タスクでカバーしきれない処理には、ターミナル（`Alt+F12`）を積極的に使います
- マルチモジュールプロジェクトでは、各モジュールを別々の Zed ウィンドウとして開くか、ルートを開いてファイルファインダー経由でナビゲートできます

### フレームワーク統合なし

エンタープライズ Java 開発における IntelliJ の価値の多くは、フレームワーク統合から来ています。Spring の Bean は理解され、ナビゲート可能です。JPA エンティティには特別な扱いがあります。エンドポイントはインデックス化され、検索できます。Jakarta EE のアノテーションは、IDE がコードを解析する方法を変更します。

Zed にはこうした機能は一切ありません。言語サーバーは Java コードを単なる Java コードとして扱うため、`@Autowired` に特別な意味があることや、このクラスが REST コントローラーであることを理解しません。

他のスタックについても同様です。Rails との統合もなければ、Django を認識しているわけでもなく、TypeScript 言語サーバーが提供する範囲を超える Angular/React 向けの専用ツールもありません。

**どう適応するか:**

- grep とファイル検索を積極的に使いましょう。正規表現付きの `Cmd+Shift+F` で、エンドポイント定義や Bean 名、アノテーションの使用箇所などを見つけられます。
- ナビゲーションには、言語サーバーの「find references」（`Alt+F7`）に頼りましょう — フレームワークの文脈こそありませんが、機能自体は動作します。
- Spring Boot では、Bean のワイヤリングを把握するために Actuator のエンドポイントや別ツールを併用するとよいでしょう。
- Zed のターミナルから、Spring CLI や Rails ジェネレーターなどフレームワーク専用の CLI ツールを利用することも検討してください。

> **ヒント:** データベース作業には、DataGrip、DBeaver、TablePlus のような専用ツールを使いましょう。Zed に移行した開発者の多くは、SQL 用に DataGrip を残しており、既存の JetBrains ライセンスとも相性よく使えます。

日々の業務がフレームワークを理解したナビゲーションやリファクタリングに大きく依存している場合、このギャップを強く感じるはずです。Zed が最も力を発揮するのは、専用ツールよりも検索中心のコードナビゲーションに慣れている場合や、利用している言語に必要な機能の大半をカバーする強力な LSP サポートがある場合です。

### ツールウィンドウ vs. ドック

IntelliJ は補助ビューを番号付きのツールウィンドウに整理しています（Project = 1、Git = 9、Terminal = Alt+F12 など）。Zed もこれと似た概念として「docks」を採用しています:

| IntelliJ Tool Window | Zed 側の対応 | ショートカット (JetBrains キーマップ) |
| -------------------- | ------------ | --------------------------- |
| Project (1)          | Project Panel  | `Cmd + 1`                   |
| Git (9 or Cmd+0)     | Git Panel      | `Cmd + 0`                   |
| Terminal (Alt+F12)   | Terminal Panel | `Alt + F12`                 |
| Structure (7)        | Outline Panel  | `Cmd + 7`                   |
| Problems (6)         | Diagnostics    | `Cmd + 6`                   |
| Debug (5)            | Debug Panel    | `Cmd + 5`                   |

Zed には左・下・右の 3 つのドック位置があります。パネルはドラッグまたは設定から、ドック間を移動できます。

> **ヒント:** IntelliJ には「Override IDE shortcuts」という設定があり、`Ctrl+Left/Right` のようなターミナルのショートカットを通常どおり使えるようにできます。Zed ではターミナル用のキーバインドは別扱いなので、ターミナルパネルで慣れ親しんだショートカットが効かない場合はキーマップを確認してください。

### デバッグ

IntelliJ と Zed のどちらも統合デバッガを提供していますが、体験は異なります:

- Zed のデバッガは Debug Adapter Protocol (DAP) を使用しており、複数の言語をサポートします
- `Ctrl+F8` でブレークポイントを設定します
- `Alt+Shift+F9` でデバッグを開始します
- `F7`（ステップイン）、`F8`（ステップオーバー）、`Shift+F8`（ステップアウト）でコードをステップ実行します
- `F9` で実行を継続します

Debug Panel（`Cmd+5`）には、変数、コールスタック、ブレークポイントが表示され、IntelliJ の Debug ツールウィンドウとよく似ています。

### 拡張機能 vs. プラグイン

IntelliJ には、言語サポートからデータベースツール、デプロイ統合に至るまで幅広くカバーする豊富なプラグインカタログがあります。

Zed の拡張機能カタログは、より小規模でフォーカスされています:

- 言語サポートとシンタックスハイライト
- テーマ
- コンテキストサーバー

他のエディタではプラグインが必要になる機能のいくつかは、Zed ではビルトインになっています:

- 音声チャット付きリアルタイムコラボレーション
- AI コーディング支援
- 組み込みターミナル
- タスクランナー
- LSP ベースのコードインテリジェンス

すべての IntelliJ プラグインに対する 1 対 1 の代替は見つからないでしょう。特に、フレームワーク専用ツール、データベースクライアント、アプリケーションサーバーとの統合については同様です。そうしたワークフローでは、Zed と並行して外部ツールを利用する必要があります。

## Zed と IntelliJ におけるコラボレーション

IntelliJ は、コラボレーション用に Code With Me を別個のプラグインとして提供しています。Zed では、コラボレーション機能がコアのエクスペリエンスに組み込まれています。

- 左側のドックにある Collab Panel を開きます
- チャンネルを作成し、[共同作業者を招待](https://zed.dev/docs/collaboration#inviting-a-collaborator)して参加してもらいます
- [画面またはコードベースを共有](https://zed.dev/docs/collaboration#share-a-project)します

接続されると、お互いのカーソル、選択範囲、編集内容がリアルタイムに表示されます。ボイスチャットも含まれています。別のツールやサードパーティのログインは必要ありません。

## Zed での AI の使用

IntelliJ での AI アシスタント（GitHub Copilot や JetBrains AI など）に慣れている場合、Zed でも同様の機能を、より柔軟に利用できます。

### GitHub Copilot の設定

1. macOS では `Cmd+,`、Linux/Windows では `Ctrl+,` で設定を開きます
2. **AI → Edit Predictions** に移動します
3. 「Configure Providers」の横にある **Configure** をクリックします
4. **GitHub Copilot** の下にある **Sign in to GitHub** をクリックします

サインインが完了したら、そのまま入力を始めてください。Zed がインラインで候補を提示するので、必要に応じて受け入れることができます。

### 追加の AI オプション

Zed で他の AI モデルを使用するには、いくつかの方法があります。

- Zed がホストするモデルを利用し、より高いレート制限を得ます。[認証](https://zed.dev/docs/authentication) と [Zed Pro](https://zed.dev/docs/ai/subscription.html) のサブスクリプションが必要です。
- 自分の [API キー](https://zed.dev/docs/ai/llm-providers.html) を使用し、認証は不要です。
- [Claude Agent などの外部エージェント](https://zed.dev/docs/ai/external-agents.html) を使用します。

## 高度な設定と生産性向上のための調整

Zed では、環境を細かく調整したいパワーユーザー向けに高度な設定が公開されています。

ここでは、いくつかの便利な調整項目を紹介します。

**保存時にフォーマット:**

```json
"format_on_save": "on"
```

**direnv サポートを有効化:**

```json
"load_direnv": "shell_hook"
```

**言語サーバーを設定**（手動で JSON を編集する必要があります）：Java 開発では、設定内で Java 言語サーバーを構成したい場合があるでしょう。

```json
{
  "lsp": {
    "jdtls": {
      "settings": {
        "java_home": "/path/to/jdk"
      }
    }
  }
}
```

## 次のステップ

セットアップが完了したので、Zed を最大限に活用するためのリソースをいくつか紹介します。

- [All Settings](../reference/all-settings.md) — 設定、テーマ、エディターの挙動をカスタマイズします
- [Key Bindings](../key-bindings.md) — キーマップのカスタマイズと拡張方法を学びます
- [Tasks](../tasks.md) — プロジェクト用のビルドおよび実行コマンドを設定します
- [AI Features](../ai/overview.md) — コード補完を超えた Zed の AI 機能を探索します
- [Collaboration](../collaboration/overview.md) — プロジェクトやコードをリアルタイムで共有し、一緒に作業します
- [Languages](../languages.md) — Java や Kotlin を含む、言語ごとのセットアップガイドです
