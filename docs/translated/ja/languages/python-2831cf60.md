# Zed で Python をセットアップする方法

Zed には Python のサポートがネイティブで組み込まれています。

- Tree-sitter: [tree-sitter-python](https://github.com/zed-industries/tree-sitter-python)
- Language Servers:
  - [DetachHead/basedpyright](https://github.com/DetachHead/basedpyright)
  - [astral-sh/ruff](https://github.com/astral-sh/ruff)
  - [astral-sh/ty](https://github.com/astral-sh/ty)
  - [microsoft/pyright](https://github.com/microsoft/pyright)
  - [python-lsp/python-lsp-server](https://github.com/python-lsp/python-lsp-server) (PyLSP)
- Debug Adapter: [debugpy](https://github.com/microsoft/debugpy)

## Python をインストールする

作業を始める前に、Zed と Python の両方がインストールされている必要があります。

### 手順 1: Python をインストールする

Zed には Python ランタイムが同梱されていないため、自分でインストールする必要があります。
次のいずれかの方法を選択してください。

- uv（推奨）

```bash
curl -LsSf https://astral.sh/uv/install.sh | sh
```

詳しくは、[Astral のインストールガイド](https://docs.astral.sh/uv/getting-started/installation/)を参照してください。

- Homebrew:

```bash
brew install python
```

- Python.org インストーラー: [python.org/downloads](https://python.org/downloads) から最新版をダウンロードします。

### 手順 2: Python のインストールを確認する

Python がインストールされていて、シェルから利用可能であることを確認します。

```bash
python3 --version
```

`Python 3.x.x` のような出力が表示されます。

## Zed で最初の Python プロジェクトを開く

Zed と Python のインストールが完了したら、Python コードを含むフォルダーを開いて作業を開始します。

### 手順 1: Python プロジェクトで Zed を起動する

Zed を開きます。
メニューバーから File > Open Folder を選択するか、ターミナルから次のように起動します。

```bash
zed path/to/your/project
```

Zed はネイティブの tree-sitter-python パーサーを使用して `.py` ファイルを自動的に認識するため、プラグインや手動設定は不要です。

### 手順 2: 統合ターミナルを使用する（任意）

Zed には統合ターミナルが含まれており、下部パネルからアクセスできます。Zed がプロジェクトで[仮想環境](#virtual-environments)が使用されていることを検出すると、新しく作成されたターミナルで自動的にその仮想環境が有効化されます。この挙動は、[`detect_venv`](../reference/all-settings.md#terminal-detect_venv) 設定で構成できます。

## Zed で Python Language Server を設定する

Zed には複数の Python Language Server があらかじめ組み込まれています。デフォルトでは、[basedpyright](https://github.com/DetachHead/basedpyright) がメインの Language Server として使用され、[Ruff](https://github.com/astral-sh/ruff) がフォーマットおよび lint に使用されます。

その他の組み込み Language Server は次のとおりです。

- [ty](https://docs.astral.sh/ty/)&mdash;Astral 製の、高速性を重視した新進の Language Server。
- [Pyright](https://github.com/microsoft/pyright)&mdash;basedpyright のベースとなっている Language Server。
- [PyLSP](https://github.com/python-lsp/python-lsp-server)&mdash;`pycodestyle`、`autopep8`、`yapf` などのツールと統合するプラグイン型 Language Server。

これらはデフォルトでは無効ですが、設定で有効化できます。

Settings ({#kb zed::OpenSettings}) の Languages > Python から Language Server を設定するか、設定ファイルに次のように追加します。

```json [settings]
{
  "languages": {
    "Python": {
      "language_servers": [
        // ty を有効にし、basedpyright を無効にして、
        // 他の登録済み Language Server（ruff、pylsp、pyright）をすべて有効にします。
        "ty",
        "!basedpyright",
        "..."
      ]
    }
  }
}
```

Language Server の有効化および無効化の詳細については、[Working with Language Servers](https://zed.dev/docs/configuring-languages#working-with-language-servers) を参照してください。

### Basedpyright

[basedpyright](https://docs.basedpyright.com/latest/) は、Zed v0.204.0 以降での主要な Python Language Server です。定義へ移動（go to definition）/参照の全検索（find all references）といったナビゲーション機能や型チェックなど、Language Server の中核機能を提供します。Pyright と比較して、inlay hints のような追加の Language Server 機能やチェックルールをサポートしています。

単体で使用した場合、basedpyright のデフォルトは `recommended` [type-checking mode](https://docs.basedpyright.com/latest/benefits-over-pyright/better-defaults/#typecheckingmode) ですが、Zed では、Pyright の動作と一致する、より厳格でない `standard` モードをデフォルトとして使用するように構成されています。プロジェクトごとの type-checking モードは、`pyrightconfig.json` または `pyproject.toml` の `typeCheckingMode` 設定を使って指定でき、この設定は Zed のデフォルトを上書きします。basedpyright の設定方法の詳細については、この後の節を参照してください。

#### Basedpyright の設定

basedpyright は、2 種類のソースから設定オプションを読み込みます。

- Language Server 設定（「ワークスペース設定」）。エディターごとに設定する必要があります（Zed の場合は `settings.json` を使用）が、そのエディターで開いたすべてのプロジェクトに適用されます。
- 設定ファイル（`pyrightconfig.json`、`pyproject.toml`）。エディターには依存せず、そのファイルが置かれているプロジェクトごとに有効になります。

一般的な目安として、エディターから basedpyright を使用するときにのみ意味を持つオプションは Language Server 設定で指定する必要があり、[コマンドラインツールとして](https://docs.basedpyright.com/latest/configuration/command-line/)実行する場合にも有効なオプションは設定ファイルで指定する必要があります。inlay hints に関する設定は前者の例であり、[diagnostic category](https://docs.basedpyright.com/latest/configuration/config-files/#diagnostic-categories) の設定は後者の例です。

両方の種類の設定の例を以下に示します。利用可能なオプションの包括的な一覧については、basedpyright ドキュメントの [language server settings](https://docs.basedpyright.com/latest/configuration/language-server-settings/) と [configuration files](https://docs.basedpyright.com/latest/configuration/config-files/) を参照してください。

##### Language Server 設定

Zed における basedpyright の Language Server 設定は、`settings.json` の `lsp` セクションで行えます。

たとえば、次のことを行う場合:

- デフォルトの「開いているファイルのみ」ではなく、ワークスペース内のすべてのファイルを解析対象にする
- 関数引数に対する inlay hints を無効にする

次の設定を使用できます。

```json [settings]
{
  "lsp": {
    "basedpyright": {
      "settings": {
        "basedpyright.analysis": {
          "diagnosticMode": "workspace",
          "inlayHints": {
            "callArgumentNames": false
          }
        }
      }
    }
  }
}
```

##### 設定ファイル

basedpyright は、プロジェクト固有の設定を `pyrightconfig.json` 設定ファイルと、`pyproject.toml` マニフェストの `[tool.basedpyright]` および `[tool.pyright]` セクションから読み込みます。両方に設定が存在する場合は、`pyrightconfig.json` が `pyproject.toml` より優先されます。

以下は、basedpyright に `strict` type-checking モードを使用させ、`__pycache__` ディレクトリ内のファイルに対しては診断を出さないように設定する `pyrightconfig.json` ファイルの例です。

```json
{
  "typeCheckingMode": "strict",
  "ignore": ["**/__pycache__"]
}
```

### PyLSP

[python-lsp-server](https://github.com/python-lsp/python-lsp-server/)、一般には PyLSP として知られているツールは、デフォルトで複数の外部ツール（autopep8、mccabe、pycodestyle、yapf）と統合されます。一方、その他のツール（flake8、pylint）はオプションであり、明示的に有効化して設定する必要があります。

詳しくは [Python Language Server Configuration](https://github.com/python-lsp/python-lsp-server/blob/develop/CONFIGURATION.md) を参照してください。

## 仮想環境

[Virtual environments](https://docs.python.org/3/library/venv.html) は、特定のプロジェクトに対して Python のバージョンと依存関係のセットを固定し、同じマシン上の他のプロジェクトから分離された形で管理するのに役立つツールです。Zed には、言語非依存の [toolchain](../toolchains.md) という概念に基づいて、仮想環境の検出、設定、有効化を行うためのサポートが組み込まれています。

グローバルな Python インストールがある場合、それも Zed にとってはツールチェーンとして数えられる点に注意してください。

### 仮想環境を作成する

プロジェクトでまだ仮想環境が設定されていない場合は、次のように作成できます。

```bash
python3 -m venv .venv
```

別の方法として、`uv` を使用している場合、`uv sync` を初めて実行すると仮想環境が作成されます。

### Zed による Python ツールチェーンの利用方法

Zed は、プロジェクトに選択された Python ツールチェーンを次のように利用します。

- 組み込みの language server は、ツールチェーンの Python インタープリターおよび（該当する場合）仮想環境へのパスで自動的に設定されます。これは依存関係を解決できるようにするために重要です。（なお、拡張機能によって提供される language server は現時点ではこのように自動設定できません。）
- Python タスク（pytest テストなど）は、ツールチェーンの Python インタープリターを使って実行されます。
- ツールチェーンが仮想環境である場合、Zed の統合ターミナルで新しいシェルを起動すると、その環境のアクティベーションスクリプトが自動的に実行され、選択された Python インタープリターと依存関係セットに簡単にアクセスできるようになります。
- アクティブな仮想環境に組み込みの language server がインストールされている場合は、Zed がプライベートに自動インストールしたバイナリではなく、そのバイナリが使用されます。これは debugpy にも適用されます。

### ツールチェーンの選択

ほとんどのプロジェクトでは、Zed が適切な Python ツールチェーンを自動的に選択します。複数の仮想環境が存在する複雑なプロジェクトでは、この自動選択を上書きする必要があるかもしれません。Zed が検出したリストからツールチェーンを選択するには [toolchain selector](../toolchains.md#selecting-toolchains) を使用するか、リストにない場合は [ツールチェーンへのパスを手動で指定](../toolchains.md#adding-toolchains-manually) できます。

## コードのフォーマットとリント

Zed は [Ruff](https://github.com/astral-sh/ruff) を使って Python コードのフォーマットおよびリントを行います。具体的には、`ruff server` サブコマンドを使って Ruff を LSP サーバーとして実行します。

### フォーマットの設定

Zed のフォーマット処理は 2 段階のパイプラインに従います。まず、フォーマット時のコードアクション（`code_actions_on_format`）が実行され、その後に設定されたフォーマッターが実行されます。

Settings ({#kb zed::OpenSettings}) の Languages > Python でフォーマットを設定するか、設定ファイルに次のように追加します。

```json [settings]
{
  "languages": {
    "Python": {
      "code_actions_on_format": {
        "source.organizeImports.ruff": true
      },
      "formatter": {
        "language_server": {
          "name": "ruff"
        }
      }
    }
  }
}
```

これら 2 つのフェーズは独立しています。たとえば、コードのフォーマットには [Black](https://github.com/psf/black) を使いたいが、インポートの並び替えには Ruff を使い続けたい場合は、フォーマッターのフェーズだけを変更すればかまいません。

Settings ({#kb zed::OpenSettings}) の Languages > Python で設定するか、設定ファイルに次のように追加します。

```json [settings]
{
  "languages": {
    "Python": {
      "code_actions_on_format": {
        // フェーズ 1: organize imports は引き続き Ruff が処理する
        "source.organizeImports.ruff": true
      },
      "formatter": {
        // フェーズ 2: フォーマットは Black が処理する
        "external": {
          "command": "black",
          "arguments": ["--stdin-filename", "{buffer_path}", "-"]
        }
      }
    }
  }
}
```

完全に別のツールに切り替えて Ruff がコードを一切変更しないようにするには、フォーマッターを変更するだけでなく、`code_actions_on_format` セクションで `source.organizeImports.ruff` を明示的に false に設定する必要があります。

保存時にいかなるフォーマット処理も行われないようにするには、Python ファイルに対する format-on-save を無効にできます。

Settings ({#kb zed::OpenSettings}) の Languages > Python で設定するか、設定ファイルに次のように追加します。

```json [settings]
{
  "languages": {
    "Python": {
      "format_on_save": "off"
    }
  }
}
```

### Ruff の設定

basedpyright と同様に、Zed で Ruff を使用する場合、Ruff は Zed の language server 設定と構成ファイル（`ruff.toml`）の両方からオプションを読み込みます。basedpyright と異なり、オプションは *すべて* どちらの場所でも設定できるため、Ruff の設定をどこに置くかは、プロジェクト間で共有するが Zed に特化させたいか（その場合は language server 設定を使用）、あるいは 1 つのプロジェクト専用だがすべての Ruff 実行で共通にしたいか（その場合は `ruff.toml` を使用）によって決まります。

以下は、Zed の `settings.json` 内で language server の設定を使用し、Zed における Ruff のリントをすべて無効化しつつ、フォーマッターとしては Ruff を使い続ける例です。

```json [settings]
{
  "lsp": {
    "ruff": {
      "initialization_options": {
        "settings": {
          "exclude": ["*"]
        }
      }
    }
  }
}
```

また、Ruff のドキュメントを基にした、リントとフォーマットのオプションを含む `ruff.toml` の例を次に示します。

```toml
[lint]
# 行の長さに関する違反（`E501`）は強制しない
ignore = ["E501"]

[format]
# フォーマット時にシングルクォートを使用する
quote-style = "single"
```

詳細については、Ruff のドキュメントの [configuration files](https://docs.astral.sh/ruff/configuration/) や [language server settings](https://docs.astral.sh/ruff/editors/settings/)、および [list of options](https://docs.astral.sh/ruff/settings/) を参照してください。

### 埋め込み言語のハイライト

Zed は、言語名を記したコメントを追加することで、Python の文字列内に埋め込まれたコードのシンタックスハイライトに対応しています。

```python
# sql
query = "SELECT * FROM users"

#sql
query = """
    SELECT *
    FROM users
"""

result = func( #sql
    "SELECT * FROM users"
)
```

## デバッグ

Zed は `debugpy` アダプターを通じて Python のデバッグに対応しています。設定なしで開始することも、`.zed/debug.json` にカスタムの起動プロファイルを定義することもできます。

### 設定なしでデバッグを開始する

Zed はデバッグ可能な Python のエントリーポイントを自動的に検出できます。F4 を押すか（または Command Palette から debugger: start を実行して）、現在のプロジェクトで利用可能なオプションを確認します。
これは次のケースで機能します。

- Python スクリプト
- モジュール
- pytest テスト

Zed は内部的に `debugpy` を使用しますが、アダプターを手動で設定する必要はありません。

### カスタムデバッグ設定を定義する

再利用可能なセットアップのために、プロジェクトルートに `.zed/debug.json` ファイルを作成します。これにより、Zed がコードを実行およびデバッグする方法をより細かく制御できます。

```
- [debugpy configuration documentation](https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings#launchattach-settings)

#### アクティブなファイルをデバッグ

```json [debug]
[
  {
    "label": "Python Active File",
    "adapter": "Debugpy",
    "program": "$ZED_FILE",
    "request": "launch"
  }
]
```

これは、エディタで現在開いているファイルを実行します。

#### Flask アプリをデバッグ

Flask を使用するプロジェクトでは、次のような起動構成を定義できます:

```
.venv/
app/
  init.py
  main.py
  routes.py
templates/
  index.html
static/
  style.css
requirements.txt
```

…次の構成を使用できます:

```json [debug]
[
  {
    "label": "Python: Flask",
    "adapter": "Debugpy",
    "request": "launch",
    "module": "app",
    "cwd": "$ZED_WORKTREE_ROOT",
    "env": {
      "FLASK_APP": "app",
      "FLASK_DEBUG": "1"
    },
    "args": [
      "run",
      "--reload", // ファイル変更を監視する Flask のリローダーを有効にします
      "--debugger" // Flask のデバッガーを有効にします
    ],
    "autoReload": {
      "enable": true
    },
    "jinja": true,
    "justMyCode": true
  }
]
```

これらは組み合わせて、Web サーバー、テストランナー、またはカスタムスクリプト向けに挙動を調整できます。

## トラブルシューティング

Zed における Python の問題は、通常は仮想環境、言語サーバー、またはツールの設定に関係します。

### 言語サーバーの起動問題を解決する

言語サーバーが応答しない場合や、診断や自動補完などの機能が利用できない場合:

- 使用しようとしている言語サーバーに関連するエラーがないか、Zed のログを確認してください（{#action zed::OpenLog} アクションを使用します）。言語サーバーがそもそも起動に失敗している場合は、ここで有用な情報が見つかる可能性が高いです。
- 該当する言語サーバーのライフサイクルを把握するには、言語サーバーログビューを使用してください。このビューには、{#action dev::OpenLanguageServerLogs} アクションを使用するか、ステータスバーの稲妻アイコンをクリックして言語サーバーを選択することでアクセスできます。このビューでもっとも有用な情報は次のとおりです:
  - `"Server Logs"`（言語サーバーによって出力されたエラーが表示されます）
  - `"Server Info"`（言語サーバーがどのように起動されたかの詳細が表示されます）
- `settings.json` または `pyrightconfig.json` の構文が正しいことを確認してください。
- Zed を再起動して言語サーバーとの接続を再初期化するか、{#action editor::RestartLanguageServer} を使って言語サーバーの再起動を試してください。

言語サーバーが import の解決に失敗していて、かつ仮想環境を使用している場合は、セレクタで正しい環境が選択されていることを確認してください。どの仮想環境を Zed が言語サーバーに渡しているかは、"Server Info" ビューで確認できます&mdash;末尾にある `* Configuration` セクションを探してください。
