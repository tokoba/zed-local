# PyCharm から Zed へ移行する方法

このガイドでは、PyCharm から移行してくる場合に、Zed のセットアップ方法（キーバインド、設定、そして予想される違い）を扱います。

## Zed のインストール

Zed は macOS、Windows、Linux で利用できます。

macOS の場合は、zed.dev/download からダウンロードするか、Homebrew でインストールできます:

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

インストール後は、アプリケーションフォルダ（macOS）、スタートメニュー（Windows）から、またはターミナルから直接次のように Zed を起動できます:
`zed .`
これにより、カレントディレクトリが Zed で開かれます。

## JetBrains キーマップの設定

PyCharm から移行する場合、JetBrains キーマップを使うのが最も手早く馴染む方法です。オンボーディング時に、ベースキーマップとして選択できます。そこで選択し忘れた場合でも、いつでも変更できます:

1. `Cmd+,`（macOS）または `Ctrl+,`（Linux/Windows）で設定を開きます
2. `Base Keymap` を検索します
3. `JetBrains` を選択します

これにより、Search Everywhere 用の `Shift Shift`、Go to Class 用の `Cmd+O`、Find Action 用の `Cmd+Shift+A` など、おなじみのショートカットが割り当てられます。

## エディタ設定のセットアップ

ほとんどの設定は Settings Editor ({#kb zed::OpenSettings}) で構成できます。高度な設定については、Command Palette から `zed: open settings file` を実行して、設定ファイルを直接編集します。

PyCharm ユーザーが最初に設定することが多い項目:

| Zed Setting             | 内容                                                                    |
| ----------------------- | ----------------------------------------------------------------------- |
| `format_on_save`        | 保存時に自動フォーマットします。有効にするには `"on"` に設定します。   |
| `soft_wrap`             | 長い行を折り返します。オプション: `"none"`, `"editor_width"`, `"preferred_line_length"` |
| `preferred_line_length` | 折り返しやルーラーの幅となる桁数です。デフォルトは 80 で、PEP 8 では 79 を推奨しています。 |
| `inlay_hints`           | PyCharm のヒントのように、パラメータ名や型ヒントをインラインで表示します。 |
| `relative_line_numbers` | IdeaVim から移行する場合に便利です。                                   |

Zed はプロジェクトごとの設定もサポートしています。プロジェクトのルートに `.zed/settings.json` ファイルを作成すると、そのプロジェクトに対してグローバル設定を上書きできます。これは、PyCharm で `.idea` フォルダを使用するのと同様です。

> **Tip:** 既存のプロジェクトに参加する場合は、最初のコミットを行う前に `format_on_save` を確認してください。そうしないと、1 行だけ変更するつもりが、誤ってファイル全体を再フォーマットしてしまうかもしれません。

## プロジェクトを開く／作成する

セットアップ後は、`Cmd+Shift+O`（JetBrains キーマップ使用時）を押してフォルダを開きます。これが Zed でのワークスペースになります。PyCharm と異なり、プロジェクト設定ウィザードやインタープリタ選択ダイアログ、プロジェクト構造の設定は不要です。

新しいプロジェクトを開始するには、ターミナルまたはファイルマネージャでディレクトリを作成し、それを Zed で開きます。エディタはそのフォルダをプロジェクトのルートとして扱います。

また、任意のフォルダ内のターミナルから次のように Zed を起動することもできます:
`zed .`

プロジェクト内に入ったら、次の操作が行えます:

- `Cmd+Shift+O` または `Cmd+E` を使ってファイル間を素早く移動できます（PyCharm の "Recent Files" のような動作です）
- `Cmd+Shift+A` または `Shift Shift` で Command Palette を開きます（PyCharm の "Search Everywhere" のような動作です）
- `Cmd+O` でシンボルを検索します（PyCharm の "Go to Symbol" のような動作です）

開いているバッファは上部のタブとして表示されます。Project Panel にはファイルツリーと Git のステータスが表示されます。`Cmd+1` で切り替えられます（PyCharm の Project ツールウィンドウと同様です）。

## キーバインドの違い

オンボーディング時に JetBrains キーマップを選択していれば、ほとんどのショートカットはすでに馴染みのあるものになっているはずです。ここでは、Zed と PyCharm の対応関係を簡単にまとめます。

### 共通しているキーバインド

| Action                        | Shortcut                |
| ----------------------------- | ----------------------- |
| Search Everywhere             | `Shift Shift`           |
| Find Action / Command Palette | `Cmd + Shift + A`       |
| Go to File                    | `Cmd + Shift + O`       |
| Go to Symbol                  | `Cmd + O`               |
| Recent Files                  | `Cmd + E`               |
| Go to Definition              | `Cmd + B`               |
| Find Usages                   | `Alt + F7`              |
| Rename Symbol                 | `Shift + F6`            |
| Reformat Code                 | `Cmd + Alt + L`         |
| Toggle Project Panel          | `Cmd + 1`               |
| Toggle Terminal               | `Alt + F12`             |
| Duplicate Line                | `Cmd + D`               |
| Delete Line                   | `Cmd + Backspace`       |
| Move Line Up/Down             | `Shift + Alt + Up/Down` |
| Expand/Shrink Selection       | `Alt + Up/Down`         |
| Comment Line                  | `Cmd + /`               |
| Go Back / Forward             | `Cmd + [` / `Cmd + ]`   |
| Toggle Breakpoint             | `Ctrl + F8`             |

### キーバインドの違い（PyCharm → Zed）

| Action                 | PyCharm     | Zed (JetBrains keymap)   |
| ---------------------- | ----------- | ------------------------ |
| File Structure         | `Cmd + F12` | `Cmd + F12` (outline)    |
| Navigate to Next Error | `F2`        | `F2`                     |
| Run                    | `Ctrl + R`  | `Ctrl + Alt + R` (tasks) |
| Debug                  | `Ctrl + D`  | `Alt + Shift + F9`       |
| Stop                   | `Cmd + F2`  | `Ctrl + F2`              |

### Zed 固有のキーバインド

| Action            | Shortcut                   | Notes                          |
| ----------------- | -------------------------- | ------------------------------ |
| Toggle Right Dock | `Cmd + R`                  | Assistant panel, notifications |
| Split Panes       | `Cmd + K`, then arrow keys | Create splits in any direction |

### キーバインドをカスタマイズする方法

- Command Palette（`Cmd+Shift+A` または `Shift Shift`）を開きます
- `Zed: Open Keymap Editor` を実行します

これにより、利用可能なすべてのバインディングの一覧が開きます。個々のショートカットを上書きしたり、競合を解消したりできます。

Zed はキーシーケンス（複数キーのショートカット）にも対応しています。

## ユーザーインターフェイスの違い

### インデックス処理なし

大規模なプロジェクトで PyCharm を使ったことがあるなら、「Indexing...」と表示されてからの待ち時間をご存じでしょう。プロジェクトの規模や依存関係によっては、30 秒から数分かかることもあります。PyCharm はコードインテリジェンスのためにコードベース全体の包括的なインデックスを構築し、依存関係が変わったり新しいパッケージをインストールしたりすると再インデックスを行います。

Zed はインデックス処理を行いません。フォルダを開けばすぐに作業を開始できます。インデックス処理による一時停止を待つことなく、プロジェクトの規模に関わらずファイル検索やナビゲーションは高速のままです。

PyCharm のインデックスは、コードベース全体でのすべての使用箇所の検索、クラス階層の把握、プロジェクト全体での未使用インポートの検出といった機能を支えています。Zed はこの種の処理を language server に委譲しており、解析の深さや範囲は同じレベルに達しない場合があります。
**移行のコツ:**

- プロジェクト全体のシンボル検索には `Cmd+O` / Go to Symbol を使います（言語サーバーに依存します）
- ファイル名でファイルを探すには `Cmd+Shift+O` / Go to File を使用します
- 複数ファイルにまたがるテキスト検索には `Cmd+Shift+F` を使います—大規模なコードベースでも高速です
- より深い静的解析が必要な場合は、ターミナルから `mypy`、`pylint`、`ruff check` などのツールを実行することを検討してください

### LSP とネイティブ言語インテリジェンス

PyCharm には、Python 専用に作られた独自の言語解析エンジンがあります。このエンジンはコードを深く理解しており、型注釈がなくても型を解決し、データフローを追跡し、Django モデルや Flask ルートを把握し、専用のリファクタリング機能を提供します。

Zed はコードインテリジェンスに Language Server Protocol (LSP) を使用します。Python 用には、Zed は標準で複数の言語サーバーを提供しています。

- **basedpyright** (default) — 高速な型チェックと補完
- **Ruff** (default) — リンティングとフォーマット
- **ty** — Astral による高速性重視の新興言語サーバー
- **Pyright** — Microsoft の型チェッカー
- **PyLSP** — ツール連携が可能なプラグインベースのサーバー

Python 向けの LSP 体験は十分に強力です。basedpyright は正確な補完、型チェック、ナビゲーションを提供し、Ruff は優れた性能でフォーマットとリンティングを処理します。

違いを感じるかもしれない点:

- フレームワーク固有のインテリジェンス（Django ORM、Flask のルートなど）は組み込まれていません
- 一部の複雑なリファクタリング（適切なスコープ解析を伴うメソッド抽出など）は、あまり洗練されていない場合があります
- 自動インポート候補は、言語サーバーがあなたの環境について把握している情報に依存します

**移行のコツ:**

- `Alt+Enter` で利用可能なコードアクションを呼び出します—表示される内容は言語サーバーによって異なります
- 言語サーバーが依存関係を解決できるよう、仮想環境が選択されていることを確認してください
- Ruff を使って、高速で一貫したフォーマットを行います（デフォルトで有効になっています）
- PyCharm の「Inspect Code」に近いコード検査を行うには、`ruff check .` を実行するか、Diagnostics パネル（`Cmd+6`）を確認してください—basedpyright と Ruff を組み合わせることで、多くの同種の問題を検出できます

### 仮想環境とインタープリター

PyCharm では GUI から Python インタープリターを選択でき、PyCharm がプロジェクトとそのインタープリターとの接続を管理します。利用可能なパッケージを表示し、新しいパッケージのインストールを行え、各プロジェクトがどの環境を使っているかを追跡します。

Zed はツールチェーンシステムを通じて仮想環境を扱います:

- Zed は、一般的な場所（`.venv`、`venv`、`.env`、`env`）にある仮想環境を自動的に検出します
- 仮想環境が検出されると、ターミナルが自動的にその環境をアクティベートします
- 検出された環境を使用するように、言語サーバーは自動的に構成されます
- 自動検出が誤ったものを選んだ場合は、ツールチェーンを手動で選択できます

**移行のコツ:**

- `python -m venv .venv` または `uv sync` で仮想環境を作成します
- フォルダーを Zed で開きます—Zed が自動的に環境を検出します
- 環境を切り替える必要がある場合は、ツールチェーンセレクターを使用します
- conda 環境を使う場合は、Zed を起動する前にシェルでその環境をアクティベートしておいてください

> **ヒント:** basedpyright がインストール済みのパッケージで import エラーを表示する場合は、Zed が正しい仮想環境を選択しているか確認してください。アクティブな環境を確認・変更するには、ツールチェーンセレクターを使用します。

### プロジェクトモデルなし

PyCharm は、XML 設定ファイル、インタープリターの割り当て、実行構成を含む `.idea` フォルダーを通じてプロジェクトを管理します。このモデルにより、PyCharm はインタープリターの選択を記憶し、UI 経由で依存関係を管理し、複雑な実行／デバッグ設定を保存できます。

Zed にはプロジェクトモデルがありません。プロジェクトは単なるフォルダーです。ウィザードもインタープリター選択画面もプロジェクト構造の設定も存在しません。

つまり、次のような違いがあります。

- 実行構成は存在しません。タスクを定義するか、ターミナルを使用します。`.idea/` にある既存の PyCharm の実行構成は読み込まれないため、必要なものは `tasks.json` に再作成することになります。
- インタープリター管理はエディターの外側で行います。Zed は環境を検出しますが、作成はしません。
- 依存関係は pip、uv、poetry、conda などを通じて管理し、エディターからは管理しません。
- Python Console（対話的な REPL）パネルはありません。代わりにターミナルで `python` や `ipython` を使用してください。

**移行のコツ:**

- プロジェクト固有の設定用に、プロジェクトルートに `.zed/settings.json` を作成します
- 共通のコマンドを `tasks.json` に定義します（Command Palette から `zed: open tasks` で開きます）:

```json
[
  {
    "label": "run",
    "command": "python main.py"
  },
  {
    "label": "test",
    "command": "pytest"
  },
  {
    "label": "test current file",
    "command": "pytest $ZED_FILE"
  }
]
```

- `Ctrl+Alt+R` でタスクを素早く実行します
- タスクでカバーしきれない作業には、ターミナル（`Alt+F12`）を積極的に使いましょう

### フレームワーク統合なし

Web 開発における PyCharm Professional の価値の多くは、そのフレームワーク統合にあります。Django テンプレートは解析され、ナビゲーション可能です。Flask のルートはインデックスされ、SQLAlchemy モデルには特別なサポートがあります。テンプレート変数はオートコンプリートされます。

Zed にはこうした機能は一切ありません。言語サーバーは Python コードを単なる Python コードとして扱い、`@app.route` がエンドポイントを定義していることや、Django のモデルクラスがデータベーステーブルを作成することを理解していません。

**移行のコツ:**

- grep やファイル検索を積極的に使いましょう。正規表現付きの `Cmd+Shift+F` で、ルート定義やモデルクラス、テンプレートの使用箇所を見つけられます。
- ナビゲーションには、言語サーバーの「find references」（`Alt+F7`）に頼りましょう—フレームワークのコンテキストはありませんが、動作します。
- Zed のターミナルからフレームワーク専用の CLI ツール（`python manage.py`、`flask routes` など）を使うことも検討してください。

> **ヒント:** データベース作業には、DataGrip、DBeaver、TablePlus などの専用ツールを使いましょう。Zed に乗り換えた開発者の多くは、SQL 用に DataGrip を併用し続けています。

### ツールウィンドウとドック

PyCharm は補助ビューを番号付きのツールウィンドウにまとめています（Project = 1、Python Console = 4、Terminal = Alt+F12 など）。Zed も同様のコンセプトとして「docks」を採用しています。

| PyCharm のツールウィンドウ | Zed の対応パネル | ショートカット（JetBrains キーマップ） |
| ------------------- | -------------- | --------------------------- |
| Project (1)         | Project Panel  | `Cmd + 1`                   |
| Git (9 or Cmd+0)    | Git Panel      | `Cmd + 0`                   |
| Terminal (Alt+F12)  | Terminal Panel | `Alt + F12`                 |
| Structure (7)       | Outline Panel  | `Cmd + 7`                   |
| Problems (6)        | Diagnostics    | `Cmd + 6`                   |
| Debug (5)           | Debug Panel    | `Cmd + 5`                   |

Zed には左・下・右の 3 つのドック位置があります。パネルはドラッグ操作や設定からドック間を移動できます。

### デバッグ

PyCharm と Zed のどちらも統合デバッガーを提供していますが、その体験には違いがあります。

- Zed は `debugpy` を使用します（VS Code と同じデバッグアダプターです）
- `Ctrl+F8` でブレークポイントを設定します
- `Alt+Shift+F9` でデバッグを開始するか、`F4` を押してデバッグターゲットを選択します
- `F7`（ステップイン）、`F8`（ステップオーバー）、`Shift+F8`（ステップアウト）でコードをステップ実行します
- `F9` で実行を継続します

Zed はデバッグ可能なエントリーポイントを自動検出できます。`F4` を押すと、次のような利用可能なオプションが表示されます。

- Python スクリプト
- モジュール
- pytest テスト

```
より細かく制御するには、`.zed/debug.json` ファイルを作成してください:

```json
[
  {
    "label": "Debug Current File",
    "adapter": "Debugpy",
    "program": "$ZED_FILE",
    "request": "launch"
  },
  {
    "label": "Debug Flask App",
    "adapter": "Debugpy",
    "request": "launch",
    "module": "flask",
    "args": ["run", "--debug"],
    "env": {
      "FLASK_APP": "app.py"
    }
  }
]
```

### テストの実行

PyCharm には、各テストの成功/失敗ステータスを表示するビジュアルなインターフェースを備えた専用のテストランナーがあります。Zed では、次の方法でテストを実行できます:

- **ガターアイコン** — テスト関数やクラスの横にある再生ボタンをクリックします
- **Tasks** — `tasks.json` に pytest または unittest のコマンドを定義します
- **Terminal** — `pytest` を直接実行します

テストの出力はターミナルパネルに表示されます。pytest では、簡潔なトレースバックには `--tb=short` を、詳細な出力には `-v` を使用します。

### 拡張機能とプラグインの違い

PyCharm には、追加の言語サポートからデータベースツール、デプロイ統合までを幅広くカバーする豊富なプラグインカタログがあります。

Zed の拡張機能カタログはより小規模ですが、焦点が絞られています:

- 言語サポートとシンタックスハイライト
- テーマ
- コンテキストサーバー

PyCharm ではプラグインが必要な機能のいくつかは、Zed には標準で組み込まれています:

- 音声チャット付きのリアルタイム共同編集
- AI コーディング支援
- 組み込みターミナル
- タスクランナー
- LSP ベースのコードインテリジェンス
- Ruff によるフォーマットとリンティング

### Zed にないもの

期待値を明確にするために、PyCharm にはあるが Zed にはない機能を挙げます:

- **Scientific Mode / Jupyter 連携** — ノートブックやデータサイエンス向けのワークフローには、Zed で Python 編集を行いつつ、JupyterLab または Jupyter 拡張機能をインストールした VS Code を併用してください
- **データベースツール** — DataGrip、DBeaver、TablePlus を使用してください
- **Django/Flask テンプレートナビゲーション** — ファイル検索と grep を使用してください
- **ビジュアルパッケージマネージャー** — ターミナルから pip、uv、poetry を使用してください
- **リモートインタープリター** — Zed にはリモート開発機能がありますが、動作は異なります
- **プロファイラ統合** — cProfile、py-spy などのツールを外部で使用してください

## Zed と PyCharm におけるコラボレーション

PyCharm では、コラボレーション用に Code With Me を別プラグインとして提供しています。Zed では、コラボレーション機能がコアの体験として組み込まれています。

- 左側ドックの Collab パネルを開きます
- チャンネルを作成し、[コラボレーターを招待](https://zed.dev/docs/collaboration#inviting-a-collaborator)して参加してもらいます
- 直接[画面またはコードベースを共有](https://zed.dev/docs/collaboration#share-a-project)します

接続されると、お互いのカーソル、選択範囲、編集内容がリアルタイムに表示されます。音声チャットも含まれています。別のツールやサードパーティのログインは必要ありません。

## Zed での AI の利用

PyCharm の GitHub Copilot や JetBrains AI Assistant のような AI アシスタントに慣れている場合でも、Zed では同様の機能をより柔軟に利用できます。

### GitHub Copilot の設定

1. macOS では `Cmd+,`、Linux/Windows では `Ctrl+,` で Settings を開きます
2. **AI → Edit Predictions** に移動します
3. "Configure Providers" の横にある **Configure** をクリックします
4. **GitHub Copilot** の項目で **Sign in to GitHub** をクリックします

サインインが完了したら、そのまま入力を開始します。Zed がインラインで候補を提示するので、必要に応じて受け入れてください。

### 追加の AI オプション

Zed で他の AI モデルを使用するには、いくつかの選択肢があります:

- レート制限がより緩い Zed のホスト型モデルを使用します。その場合は、[認証](https://zed.dev/docs/authentication)と [Zed Pro](https://zed.dev/docs/ai/subscription.html) へのサブスクリプションが必要です。
- 自身の[API キー](https://zed.dev/docs/ai/llm-providers.html)を使用します。この場合、認証は不要です
- [Claude Agent のような外部エージェント](https://zed.dev/docs/ai/external-agents.html)を使用します

## 高度な設定と生産性向上のための調整

Zed では、環境を細かく調整したいパワーユーザー向けに高度な設定を公開しています。

便利な調整項目をいくつか紹介します:

**保存時にフォーマットする:**

```json
"format_on_save": "on"
```

**direnv サポートを有効にする（direnv を使用する Python プロジェクトに便利です）:**

```json
"load_direnv": "shell_hook"
```

**仮想環境の検出をカスタマイズする**（JSON の手動編集が必要です）:

```json
{
  "terminal": {
    "detect_venv": {
      "on": {
        "directories": [".venv", "venv", ".env", "env"],
        "activate_script": "default"
      }
    }
  }
}
```

**basedpyright の型チェックの厳密さを設定する:**

basedpyright が厳しすぎる、または緩すぎると感じる場合は、プロジェクトの `pyrightconfig.json` で設定します:

```json
{
  "typeCheckingMode": "basic"
}
```

指定できるオプションは `"off"`、`"basic"`、デフォルトの `"standard"`、`"strict"`、`"all"` です。

## 次のステップ

セットアップが完了したら、Zed を最大限に活用するために役立つ以下のリソースを参照してください:

- [すべての設定](../reference/all-settings.md) — 設定、テーマ、エディターの動作をカスタマイズします
- [キーバインド](../key-bindings.md) — キーマップのカスタマイズと拡張方法を学びます
- [Tasks](../tasks.md) — プロジェクト用のビルドおよび実行コマンドを設定します
- [AI Features](../ai/overview.md) — コード補完を超えた Zed の AI 機能を確認します
- [Collaboration](../collaboration/overview.md) — プロジェクトやコードをリアルタイムに共同編集します
- [Python in Zed](../languages/python.md) — Python 向けのセットアップと設定について
