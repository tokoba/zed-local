# 拡張機能の開発 {#developing-extensions}

Zed の拡張機能は、`extension.toml` マニフェストを含む Git リポジトリです。言語、テーマ、デバッガー、スニペット、MCP サーバーを提供できます。

## 拡張機能の機能 {#extension-features}

拡張機能では次のものを提供できます:

- [言語](./languages.md)
- [デバッガー](./debugger-extensions.md)
- [テーマ](./themes.md)
- [アイコンテーマ](./icon-themes.md)
- [スニペット](./snippets.md)
- [MCP サーバー](./mcp-extensions.md)

## ローカルで拡張機能を開発する

Zed 用の拡張機能の開発を始める前に、[rustup を使って Rust をインストール](https://www.rust-lang.org/tools/install)しておいてください。

> Rust は rustup 経由でインストールされている必要があります。Rust を homebrew など別の方法でインストールしている場合、開発用拡張機能のインストールは動作しません。

拡張機能を開発する際は、それを *開発用拡張機能* としてインストールすることで、公開せずに Zed で利用できます。

Extensions ページから、`Install Dev Extension` ボタン（または {#action zed::InstallDevExtension} アクション）をクリックし、拡張機能を含むディレクトリを選択します。

トラブルシュートが必要な場合は、追加の出力を確認するために Zed.log（{#action zed::OpenLog}）を確認してください。デバッグ出力が必要な場合は、コマンドラインから `zed --foreground` で Zed を終了後に再起動すると、より冗長な INFO レベルのログが表示されます。

すでに公開版の拡張機能がインストールされている場合は、開発用拡張機能をインストールする前に公開版がアンインストールされます。インストールが成功すると、`Extensions` ページには上流の拡張機能が「Overridden by dev extension」と表示されます。

## Zed 拡張機能のディレクトリ構造

Zed 拡張機能は、`extension.toml` を含む Git リポジトリです。このファイルには、拡張機能に関する基本情報をいくつか含める必要があります:

```toml
id = "my-extension"
name = "My extension"
version = "0.0.1"
schema_version = 1
authors = ["Your Name <you@example.com>"]
description = "Example extension"
repository = "https://github.com/your-name/my-zed-extension"
```

これに加えて、Zed 拡張機能に機能を追加するために使用できる任意のファイルやディレクトリがいくつかあります。すべての機能を提供する拡張機能のディレクトリ構造の例は次のとおりです:

```
my-extension/
  extension.toml
  Cargo.toml
  src/
    lib.rs
  languages/
    my-language/
      config.toml
      highlights.scm
  themes/
    my-theme.json
  snippets/
    snippets.json
    rust.json
```

## WebAssembly

拡張機能の手続き的な部分は Rust で記述され、WebAssembly にコンパイルされます。カスタムコードを含む拡張機能を開発するには、次のような `Cargo.toml` を含めます:

```toml
[package]
name = "my-extension"
version = "0.0.1"
edition = "2021"

[lib]
crate-type = ["cdylib"]

[dependencies]
zed_extension_api = "0.1.0"
```

crates.io で利用可能な [`zed_extension_api`](https://crates.io/crates/zed_extension_api) の最新バージョンを使用してください。サポートしたい Zed のバージョンと[互換性がある](https://github.com/zed-industries/zed/blob/main/crates/extension_api#compatible-zed-versions)ことを確認してください。

Rust クレート内の `src/lib.rs` ファイルでは、拡張機能用の構造体を定義し、`Extension` トレイトを実装するとともに、`register_extension!` マクロを使って拡張機能を登録する必要があります:

```rs
use zed_extension_api as zed;

struct MyExtension {
    // ... 状態
}

impl zed::Extension for MyExtension {
    // ...
}

zed::register_extension!(MyExtension);
```

> `stdout`/`stderr` は Zed プロセスに直接転送されます。拡張機能からの `println!`/`dbg!` の出力を確認するには、ターミナルで `--foreground` フラグを付けて Zed を起動してください。

## リポジトリのフォークとクローン

1. リポジトリをフォークする

> **注意:** `zed-industries/extensions` リポジトリは、GitHub 組織ではなく個人の GitHub アカウントにフォークしておくと非常に役立ちます。そうすることで、Zed のスタッフが公開プロセスを迅速に進めるために必要な変更をあなたの PR に直接 push できるようになります。

2. リポジトリをローカル環境にクローンする

```sh
# ここに自分のフォークの URL を指定してください:
# git clone https://github.com/zed-industries/extensions
cd extensions
git submodule init
git submodule update
```

## 拡張機能のライセンス要件

2025年10月1日以降、拡張機能のリポジトリにはライセンスを含める必要があります。
受け入れられるライセンスは次のとおりです:

- [Apache 2.0](https://www.apache.org/licenses/LICENSE-2.0)
- [BSD 2-Clause](https://opensource.org/license/bsd-2-clause)
- [BSD 3-Clause](https://opensource.org/license/bsd-3-clause)
- [CC BY 4.0](https://creativecommons.org/licenses/by/4.0)
- [GNU GPLv3](https://www.gnu.org/licenses/gpl-3.0.en.html)
- [GNU LGPLv3](https://www.gnu.org/licenses/lgpl-3.0.en.html)
- [MIT](https://opensource.org/license/mit)
- [Unlicense](https://unlicense.org)
- [zlib](https://opensource.org/license/zlib)

これにより、拡張機能のコードから生成されるバイナリをユーザーに配布できるようになります。
有効なライセンスがない場合、後述の手順で拡張機能を追加または更新するための pull request は CI で失敗します。

ライセンスファイルは拡張機能リポジトリのルートに配置する必要があります。`LICENCE` または `LICENSE` をプレフィックスに持つ（大文字小文字は区別されません）任意のファイル名が、受け入れ可能なライセンスのいずれかと一致しているか検査されます。[ライセンス検証のソースコード](https://github.com/zed-industries/extensions/blob/main/src/lib/license.js)を参照してください。

> このライセンス要件は、拡張機能のコード自体（拡張機能バイナリにコンパイルされるコード）にのみ適用されます。
> 言語サーバーやその他の外部依存関係など、拡張機能がダウンロードまたは連携するツールには適用されません。
> リポジトリに拡張機能コードと他のプロジェクト（言語サーバーなど）が両方含まれている場合でも、それら他のプロジェクトのライセンスを変更する必要はありません — 上記の受け入れ可能なライセンスのいずれかである必要があるのは拡張機能コードだけです。

## 拡張機能を公開する前提条件

拡張機能を公開する前に、[拡張機能マニフェスト](#directory-structure-of-a-zed-extension)で、拡張機能に一意の extension ID を選択していることを確認してください。
これは拡張機能の主な識別子となり、一度拡張機能を公開すると変更できません。
また、マニフェスト内の必須フィールドをすべて入力していることを確認してください。

さらに、拡張機能を公開に進む前に、次の前提条件を満たしていることを確認してください:

```
- 拡張機能 ID および名前には `zed`、`Zed`、`extension` という単語を含めてはなりません。すべてが Zed の拡張機能であるためです。
- 拡張機能 ID から、その拡張機能が何を行うものかがある程度わかるようにすることが推奨されます。たとえば、テーマであれば `-theme` をサフィックスとして付与し、スニペット拡張機能であれば `-snippets` を付与するといった具合です。ただし、このルールには例外があり、言語や一般的なツールのサポートを提供し、人々がその ID で見つかると期待するような拡張機能については必ずしも従う必要はありません。通常どのように運用されているかを把握するには、[既存の拡張機能](https://github.com/zed-industries/extensions/blob/main/extensions.toml) の一覧を確認してください。
- 拡張機能は、本来であれば既存の拡張機能の中で解決されるべき問題を修正するのではなく、マーケットプレイスにまだ存在していない何かを提供するべきです。たとえば、既存の拡張機能が提供する Language Server のサポートが正しく動作していないことに気づいた場合、すぐに新しい拡張機能を投稿するのではなく、まずはその既存の拡張機能に対して修正をコントリビュートするようにしてください。
  - 妥当な期間内に upstream リポジトリから応答や反応が得られない場合は、その問題を解決することを目的とした pull request を送ってもらって構いません。拡張機能を追加するために extensions リポジトリへ送る pull request には、それまでに行った取り組みの内容を必ず含めてください。Zed のメンテナーが、ケースバイケースでどのように進めるかを判断します。
- 言語、デバッガー、または MCP サーバーを提供しようとする拡張機能は、拡張機能の一部として Language Server を同梱してはなりません。その代わりに、拡張機能は [Zed Rust Extension API](https://docs.rs/zed_extension_api/latest/zed_extension_api/) が提供する API を使用して、Language Server をダウンロードするか、ユーザー環境に Language Server が存在するかどうかを確認するようにしてください。
- テーマおよびアイコンテーマは、たとえば言語サポートのような別の機能を提供する拡張機能の一部として公開すべきではありません。代わりに、個別の拡張機能として公開する必要があります。これは、同じリポジトリ内に含まれているテーマやアイコンテーマにも当てはまります。

これらのルールに従っていない場合、公開プロセス中にレビュアーから指摘され、拡張機能のリリースが遅れることに注意してください。

## 拡張機能の公開

拡張機能を公開するには、[`zed-industries/extensions` リポジトリ](https://github.com/zed-industries/extensions) に PR を作成します。

PR では、次の作業を行ってください。

1. `extensions/{extension-id}` パスの `extensions/` ディレクトリ配下に、拡張機能を Git サブモジュールとして追加します。

```sh
git submodule add https://github.com/your-username/foobar-zed.git extensions/my-extension
git add extensions/my-extension
```

> すべての拡張機能サブモジュールは HTTPS URL を使用しなければならず、SSH URL（`git@github.com`）を使用してはなりません。

2. ルートの `extensions.toml` ファイルに、拡張機能を表す新しいエントリを追加します。

```toml
[my-extension]
submodule = "extensions/my-extension"
version = "0.0.1"
```

拡張機能がサブモジュール内のサブディレクトリにある場合は、`path` フィールドを使って拡張機能が存在する場所を指し示すことができます。

```toml
[my-extension]
submodule = "extensions-my-extension"
path = "packages/zed"
version = "0.0.1"
```

> [必須の拡張機能ライセンス](#extension-license-requirements) は指定したパスに存在している必要があり、リポジトリのルートにあるライセンスでは認識されません。ただし、リポジトリ内の既存のライセンスへのシンボリックリンクを作成することも、拡張機能コードに対して許可されているライセンス一覧から別のライセンスを選択することも可能です。

3. `pnpm sort-extensions` を実行して、`extensions.toml` と `.gitmodules` がソートされていることを確認します。

PR がマージされると、拡張機能はパッケージ化され、Zed の拡張機能レジストリに公開されます。

## 拡張機能の更新

拡張機能を更新するには、[`zed-industries/extensions` リポジトリ](https://github.com/zed-industries/extensions) に PR を作成します。

PR では、次の作業を行ってください。

1. 拡張機能のサブモジュールを、新しいバージョンのコミットに更新します。そのためには、次のコマンドを実行できます。

```sh
# リポジトリのルートから実行します:
git submodule update --remote extensions/your-extension-name
```

これにより、リモートリポジトリで利用可能な最新のコミットに拡張機能が更新されます。

2. `extensions.toml` 内のその拡張機能の `version` フィールドを更新します。
   - 対象のコミットで `extension.toml` に設定されている `version` と一致していることを確認してください。

このプロセスを自動化したい場合は、利用可能な [コミュニティ製の GitHub Action](https://github.com/huacnlee/zed-extension-action) があります。

> **注意:** 拡張機能のリポジトリに別のライセンスが設定されている場合は、更新を公開する前に、そのライセンスを [許可されている拡張機能ライセンス](#extension-license-requirements) のいずれかに変更する必要があります。
