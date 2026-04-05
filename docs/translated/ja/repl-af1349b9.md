# REPL

## はじめに

Zed に組み込まれている REPL は [Jupyter kernels](https://docs.jupyter.org/en/latest/projects/kernels.html) を使用しており、通常のエディタファイル内でコードをインタラクティブに実行できます。

<figure style="width: 100%; margin: 0; overflow: hidden; border-top-left-radius: 2px; border-top-right-radius: 2px;">
    <video loop controls playsinline>
        <source
            src="https://customer-snccc0j9v3kfzkif.cloudflarestream.com/aec66e79f23d6d1a0bee5e388a3f17cc/downloads/default.mp4"
            type='video/webm; codecs="vp8.0, vorbis"'
        />
        <source
            src="https://customer-snccc0j9v3kfzkif.cloudflarestream.com/aec66e79f23d6d1a0bee5e388a3f17cc/downloads/default.mp4"
            type='video/mp4; codecs="avc1.4D401E, mp4a.40.2"'
        />
        <source
          src="https://zed.dev/img/post/repl/typescript-deno-kernel-markdown.png"
          type="image/png"
        />
    </video>
</figure>

## インストール

Zed は複数の言語でコードを実行できます。使い始めるには、使用したい言語用のカーネルをインストールする必要があります。

**現在サポートされている言語:**

- [Python (ipykernel)](#python)
- [TypeScript (Deno)](#typescript-deno)
- [R (Ark)](#r-ark)
- [R (Xeus)](#r-xeus)
- [Julia](#julia)
- [Scala (Almond)](#scala)

インストールが完了したら、対応する言語ファイルや、Markdown などその言語がサポートされている場所で REPL を使い始められます。最近カーネルを追加した場合は、エディタで使用できるようにするために `repl: refresh kernelspecs` コマンドを実行してください。

## REPL の使用方法

REPL を起動するには、使用したい言語のファイルを開き、`repl: run` コマンド（macOS ではデフォルトで `ctrl-shift-enter`）を使って、ブロック、選択範囲、または行を実行します。ツールバーの REPL アイコンをクリックして実行することもできます。

`repl: run` コマンドは選択範囲（複数可）に対して実行され、結果は選択範囲の下に表示されます。

出力は `repl: clear outputs` コマンド、またはツールバーの REPL メニューから消去できます。

### セルモード

Zed は、Python では `# %%`、TypeScript では `// %%` のセル区切りを使用する [notebooks as scripts](https://jupytext.readthedocs.io/en/latest/formats-scripts.html) をサポートしています。これにより、1 つのファイル内にコードを書き、ノートブックのようにセルごとに実行できます。

`repl: run` コマンドは、`# %%` マーカーの間の各コードブロックを別々のセルとして実行します。

```python
# %% セル 1
import time
import numpy as np

# %% セル 2
import matplotlib.pyplot as plt
import matplotlib.pyplot as plt
from matplotlib import style
style.use('ggplot')
```

## 言語ごとの手順

### Python {#python}

#### グローバル環境

<div class="warning">

macOS では、システムに標準で入っている Python は動作しません。[pyenv](https://github.com/pyenv/pyenv?tab=readme-ov-file#installation) をセットアップするか、仮想環境を使用してください。

</div>

現在使用している Python で利用可能なカーネルを用意するには、次を実行します:

```sh
pip install ipykernel
python -m ipykernel install --user
```

#### Conda 環境

```sh
source activate myenv
conda install ipykernel
python -m ipykernel install --user --name myenv --display-name "Python (myenv)"
```

#### pip を使った Virtualenv

```sh
source activate myenv
pip install ipykernel
python -m ipykernel install --user --name myenv --display-name "Python (myenv)"
```

### R (Ark Kernel) {#r-ark}

使用しているオペレーティングシステム向けのリリースをダウンロードして [Ark](https://github.com/posit-dev/ark/releases) をインストールします。例えば macOS では、`ark` バイナリを展開して `/usr/local/bin` に配置するだけです。その後、次を実行します:

```sh
ark --install
```

### R (Xeus Kernel) {#r-xeus}

- [Xeus-R](https://github.com/jupyter-xeus/xeus-r) をインストールします
- Zed の R 拡張機能をインストールします（Zed Extensions で `R` を検索）

<!--
TBD: R REPL (Ark Kernel) の手順を改善する
-->

### TypeScript: Deno {#typescript-deno}

- [Deno をインストール](https://docs.deno.com/runtime/manual/getting_started/installation/) し、その後 Deno jupyter kernel をインストールします:

```sh
deno jupyter --install
```

<!--
TBD: R REPL (Ark Kernel) の手順を改善する
-->

### Julia

- [公式サイト](https://julialang.org/downloads/) から Julia をダウンロードしてインストールします。
- Zed の Julia 拡張機能をインストールします（Zed Extensions で `Julia` を検索）

<!--
TBD: Julia REPL の手順を改善する
-->

### Scala

- `cs setup`（Coursier）を使って [Scala をインストール](https://www.scala-lang.org/download/) します:
  - `brew install coursier/formulas/coursier && cs setup`
- REPL (Almond) の [セットアップ手順](https://almond.sh/docs/quick-start-install):
  - `brew install --cask temurin`（Eclipse Foundation の公式 OpenJDK バイナリ）
  - `brew install coursier/formulas/coursier && cs setup`
  - `coursier launch --use-bootstrap almond -- --install`

## 言語ごとの使用カーネルの変更 {#changing-kernels}

Zed は利用可能なカーネルを自動的に検出し、カーネルピッカーで次のように整理します:

- **Recommended**: アクティブなツールチェーンに一致する Python 環境（検出された場合）
- **Python Environments**: 仮想環境（venv、virtualenv、Poetry、Pipenv、Conda、uv など）
- **Jupyter Kernels**: インストール済みの Jupyter kernelspec
- **Remote Servers**: 接続済みのリモート Jupyter サーバー

### ipykernel のインストール

Python 環境は、ipykernel がインストールされていなくてもピッカーに表示されます。ipykernel が無い環境は淡色表示され、「ipykernel not installed」とラベル付けされます。そのような環境を選択すると、Zed は自動的にその環境内で `pip install ipykernel` を実行し、インストール完了後にその環境を有効化します。

### Zed がカーネルを推奨する方法

コードを実行するとき、Zed は自動的にカーネルを選択します:

1. **アクティブなツールチェーンとの一致**: Python 環境がアクティブなツールチェーンと一致し、かつ ipykernel がある場合、Zed はその環境を使用します
2. **最初に利用可能な Python 環境**: そうでない場合は、ipykernel を持つ最初の Python 環境を使用します
3. **言語ベースのフォールバック**: どの Python 環境も準備できていない場合、Zed はコードブロックの言語に一致する Jupyter カーネルを選択します

カーネルピッカーから明示的にカーネルを選択することで、この挙動を上書きできます。

### デフォルトカーネルの設定

言語ごとに別のデフォルトカーネルを設定するには、`settings.json` でサポートされている任意の言語にカーネルを割り当てます:

```json [settings]
{
  "jupyter": {
    "kernel_selections": {
      "python": "conda-env",
      "typescript": "deno",
      "javascript": "deno",
      "r": "ark"
    }
  }
}
```

## インタラクティブな入力

コードの実行中に（Python の `input()` 関数などの）ユーザー入力が必要な場合、REPL はセル出力の下に入力プロンプトを表示します。

テキストフィールドに入力し、`Enter` を押すと送信されます。カーネルはその入力を受け取り、実行を続行します。

パスワード入力の場合は、セキュリティのために文字はアスタリスクでマスク表示されます。

入力プロンプトがアクティブな状態で実行が中断された場合、カーネルがアイドル状態に戻るとプロンプトは自動的にクリアされます。

## Kernelspec のデバッグ

利用可能なカーネルは `repl: sessions` コマンドで表示されます。実行可能なカーネルの一覧を更新するには、`repl: refresh kernelspecs` コマンドを使用します。

`jupyter` がインストールされている場合、`jupyter kernelspec list` を実行して利用可能なカーネルを確認できます。

```sh
$ jupyter kernelspec list
Available kernels:
  ark                   /Users/z/Library/Jupyter/kernels/ark
  conda-base            /Users/z/Library/Jupyter/kernels/conda-base
  deno                  /Users/z/Library/Jupyter/kernels/deno
  python-chatlab-dev    /Users/z/Library/Jupyter/kernels/python-chatlab-dev
  python3               /Users/z/Library/Jupyter/kernels/python3
  ruby                  /Users/z/Library/Jupyter/kernels/ruby
  rust                  /Users/z/Library/Jupyter/kernels/rust
```

> Note: Zed は、Python 環境内でカーネルを見つけるために、`sys.prefix` と `CONDA_PREFIX` を可能な限り活用します。明示的に制御したい場合は、対象の環境内で `python -m ipykernel install --user --name myenv --display-name "Python (myenv)"` を実行して、カーネルを直接インストールしてください。
