# Vimモード

Zed には Vim のエミュレーションレイヤーが含まれています。このページでは、Vimモードの有効化と無効化、キーバインド、Zed 固有の機能、および設定オプションについて説明します。

## Zed の Vimモードの設計

Vimモードは、意味のある範囲でモーションやコマンドの挙動を再現し、Zed のアプローチの方が優れている部分では Zed 独自の機能を使用します。目的は、設定なしでもすぐに使える、馴染みのある体験を提供することです。

これには、セマンティックなナビゲーション、複数カーソル、周囲のテキストを扱うプラグインが一般的に提供するようなその他の機能のサポートも含まれます。

そのため、Zed の Vimモードは Vim を一対一で再現するものではなく、Vim のモーダルな設計と Zed のモダンな機能を組み合わせて、よりスムーズな体験を提供します。また、設定可能であるため、独自のキーバインドを追加したり、デフォルトを上書きしたりすることもできます。

### 主な相違点

Vimモードには、Zed のコア機能を利用する 4 種類の機能があり、それによって挙動にいくつかの違いが生じます。

1. **Motions**: Vimモードは、言語ごとにモーションの挙動を調整するために Zed のセマンティックな構文解析を使用します。例えば、Rust では `%` で対応する括弧にジャンプする操作がパイプ文字 `|` に対しても機能します。JavaScript では、`w` は `$` を単語文字として扱います。
2. **Visual block selections**: Vimモードは、ビジュアルブロック選択をエミュレートするために Zed の複数カーソル機能を使用し、ブロック選択をはるかに柔軟にします。例えば、ブロック選択の後に入力した内容は、すべての行でリアルタイムに更新され、いつでもカーソルを追加・削除できます。
3. **Macros**: Vimモードは Vim マクロに対して Zed の記録システムを使用します。そのため、補完といったより複雑な操作も記録して再生できます。
4. **Search and replace**: Vimモードは Zed の検索システムを使用するため、正規表現の構文が Vim とは少し異なります。詳細は [Regex differences セクション](#regex-differences) を参照してください。

> **注意:** Zed の Vimモードの基盤は、すでに多くのユースケースをカバーしているはずですが、私たちは常に改善に取り組んでいます。もし、日々のワークフローで依存している機能が欠けていると感じた場合は、[GitHub で issue を作成](https://github.com/zed-industries/zed/issues) してください。

## Vimモードの有効化と無効化

Zed を初めて開くと、Vimモードを有効にできるチェックボックスがウェルカム画面に表示されます。

これを見逃した場合でも、コマンドパレットを開き、ワークスペースコマンド `toggle vim mode` を使用することで、いつでも Vimモードをオンまたはオフに切り替えられます。

> **注意**: このコマンドは、ユーザー設定内の次のプロパティを切り替えます:
>
> ```json [settings]
> {
>   "vim_mode": true
> }
> ```

## Zed 固有の機能

Zed はモダンな基盤の上に構築されており、編集中のファイルの内容を理解するために Tree-sitter や言語サーバーなどを使用し、複数カーソルを標準でサポートしています。

Vimモードには、Zed のコア機能に基づくキーバインドがいくつかあり、Zed 固有の機能セットを最大限に活用するのに役立ちます。

### 言語サーバー

次のコマンドは言語サーバーを利用して、コードのナビゲーションやリファクタリングを支援します。

| コマンド                                  | デフォルトのショートカット |
| ---------------------------------------- | -------------------------- |
| 定義へ移動                               | `g d`                      |
| 宣言へ移動                               | `g D`                      |
| 型定義へ移動                             | `g y`                      |
| 実装へ移動                               | `g I`                      |
| リネーム（定義を変更）                   | `c d`                      |
| 現在の単語へのすべての参照へ移動         | `g A`                      |
| 現在のファイル内のシンボルを検索         | `g s`                      |
| プロジェクト全体のシンボルを検索         | `g S`                      |
| 次の診断へ移動                           | `g ]` or `] d`             |
| 前の診断へ移動                           | `g [` or `[ d`             |
| インラインエラーを表示（ホバー）         | `g h`                      |
| コードアクションメニューを開く           | `g .`                      |

### Git

| コマンド                         | デフォルトのショートカット |
| -------------------------------- | -------------------------- |
| 次の Git の変更へ移動           | `] c`                      |
| 前の Git の変更へ移動           | `[ c`                      |
| diff のハンクを展開             | `d o`                      |
| ステージ状態を切り替え          | `d O`                      |
| ステージして次へ（diff ビューで）   | `d u`                      |
| アンステージして次へ（diff ビューで） | `d U`                      |
| 変更を復元                       | `d p`                      |

### Tree-sitter

Tree-sitter は、Zed がコードの構造を理解するために使用しているパーサーです。Zed は現在のカーソル位置を変更するモーションと、操作の対象として使用できるテキストオブジェクトを提供します。

| コマンド                         | デフォルトのショートカット            |
| -------------------------------- | ------------------------------------- |
| 次/前のメソッドへ移動           | `] m` / `[ m`                         |
| 次/前のメソッドの終わりへ移動   | `] M` / `[ M`                         |
| 次/前のセクションへ移動         | `] ]` / `[ [`                         |
| 次/前のセクションの終わりへ移動 | `] [` / `[ ]`                         |
| 次/前のコメントへ移動           | `] /`, `] *` / `[ /`, `[ *`           |
| より大きい構文ノードを選択      | `[ x`                                 |
| より小さい構文ノードを選択      | `] x`                                 |

| テキストオブジェクト                                           | デフォルトのショートカット |
| -------------------------------------------------------------- | -------------------------- |
| クラスや定義などを含めて全体                                   | `a c`                      |
| クラスや定義などの内側                                         | `i c`                      |
| 関数やメソッドなどを含めて全体                                 | `a f`                      |
| 関数やメソッドなどの内側                                       | `i f`                      |
| コメント                                                       | `g c`                      |
| 引数やリスト項目など                                           | `i a`                      |
| 引数やリスト項目など（末尾のカンマを含む）                     | `a a`                      |
| HTML 風のタグ全体                                              | `a t`                      |
| HTML 風のタグの内側                                            | `i t`                      |
| 現在のインデントレベルと、その前後 1 行                        | `a I`                      |
| 現在のインデントレベルと、その 1 行前                          | `a i`                      |
| 現在のインデントレベル                                         | `i i`                      |

なお、`[m` ファミリーのモーションのターゲットの定義は、`af` で定義される境界と同じです。
`[[` のターゲットは `ac` で定義されるものと同じですが、
クラスがない場合は関数も対象になります。同様に、`gc` は `[ /` を見つけるために使われます。`g c`

関数、クラス、コメントの定義は言語に依存しており、[`textobjects.scm`] を追加することで拡張機能に
サポートを追加できます。引数やタグの定義は Tree-sitter レベルで動作しますが、
構文木内の特定のパターンを探すようになっており、現在のところ言語ごとに
設定を変更することはできません。

### 複数カーソル

これらのコマンドは、Zed で複数のカーソルを管理するのに役立ちます。

```
| Command                                                                           | Default Shortcut |
| --------------------------------------------------------------------------------- | ---------------- |
| Add a cursor selecting the next copy of the current word                          | `g l`            |
| Add a cursor selecting the previous copy of the current word                      | `g L`            |
| Add a cursor at the end of every line in the current visual selection             | `g A`            |
| Add a cursor at the first character of every line in the current visual selection | `g I`            |
| Add a visual selection for every copy of the current word                         | `g a`            |
| Skip latest word selection, and add next                                          | `g >`            |
| Skip latest word selection, and add previous                                      | `g <`            |

### Pane management

These commands open new panes or jump to specific panes.

| Command                                    | Default Shortcut   |
| ------------------------------------------ | ------------------ |
| Open a project-wide search                 | `g /`              |
| Open the current search excerpt            | `g <space>`        |
| Open the current search excerpt in a split | `<ctrl-w> <space>` |
| Go to definition in a split                | `<ctrl-w> g d`     |
| Go to type definition in a split           | `<ctrl-w> g D`     |

### In insert mode

The following commands help you bring up Zed's completion menu, request a suggestion from GitHub Copilot, or open the inline AI assistant without leaving insert mode.

| Command                                                                      | Default Shortcut |
| ---------------------------------------------------------------------------- | ---------------- |
| Open the completion menu                                                     | `ctrl-x ctrl-o`  |
| Request GitHub Copilot suggestion (requires GitHub Copilot to be configured) | `ctrl-x ctrl-c`  |
| Open the inline AI assistant (requires a configured assistant)               | `ctrl-x ctrl-a`  |
| Open the code actions menu                                                   | `ctrl-x ctrl-l`  |
| Hides all suggestions                                                        | `ctrl-x ctrl-z`  |

### Supported plugins

Zed's vim mode includes features commonly provided by plugins in the Vim ecosystem:

- You can surround text objects with `ys` (yank surround), change surrounding with `cs`, and delete surrounding with `ds`.
- You can comment and uncomment selections with `gc` in visual mode and `gcc` in normal mode.
- The project panel supports many shortcuts modeled after the Vim plugin `netrw`: navigation with `hjkl`, open file with `o`, open file in a new tab with `t`, etc.
- You can add key bindings to your keymap to navigate "camelCase" names. [Head down to the Optional key bindings](#optional-key-bindings) section to learn how.
- You can use `gR` to do [ReplaceWithRegister](https://github.com/vim-scripts/ReplaceWithRegister).
- You can use `cx` for [vim-exchange](https://github.com/tommcdo/vim-exchange) functionality. Note that it does not have a default binding in visual mode, but you can add one to your keymap (refer to the [optional key bindings](#optional-key-bindings) section).
- You can navigate to indent depths relative to your cursor with the [indent wise](https://github.com/jeetsukumaran/vim-indentwise) plugin `[-`, `]-`, `[+`, `]+`, `[=`, `]=`.
- You can select quoted text with AnyQuotes and bracketed text with AnyBrackets text objects. Zed also provides MiniQuotes and MiniBrackets which offer alternative selection behavior based on the [mini.ai](https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-ai.md) Neovim plugin. See the [Quote and Bracket text objects](#quote-and-bracket-text-objects) section below for details.
- You can configure AnyQuotes, AnyBrackets, MiniQuotes, and MiniBrackets text objects for selecting quoted and bracketed text using different selection strategies. See the [Any Bracket Functionality](#any-bracket-functionality) section below for details.

### Any Bracket Functionality

Zed offers two different strategies for selecting text surrounded by any quote, or any bracket. These text objects are **not enabled by default** and must be configured in your keymap to be used.

#### Included Characters

Each text object type works with specific characters:

| Text Object              | Characters                                                                             |
| ------------------------ | -------------------------------------------------------------------------------------- |
| AnyQuotes/MiniQuotes     | Single quote (`'`), Double quote (`"`), Backtick (`` ` ``)                             |
| AnyBrackets/MiniBrackets | Parentheses (`()`), Square brackets (`[]`), Curly braces (`{}`), Angle brackets (`<>`) |

Both "Any" and "Mini" variants work with the same character sets, but differ in their selection strategy.

#### AnyQuotes and AnyBrackets (Traditional Vim behavior)

These text objects implement traditional Vim behavior:

- **Selection priority**: Finds the innermost (closest) quotes or brackets first
- **Fallback mechanism**: If none are found, falls back to the current line
- **Character-based matching**: Focuses solely on open and close characters without considering syntax
- **Vanilla Vim similarity**: AnyBrackets matches the behavior of commands like `ci<`, `ci(`, etc., in vanilla Vim, including potential edge cases (like considering `>` in `=>` as a closing delimiter)

#### MiniQuotes and MiniBrackets (mini.ai behavior)

These text objects implement the behavior of the [mini.ai](https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-ai.md) Neovim plugin:

- **Selection priority**: Searches the current line first before expanding outward
- **Tree-sitter integration**: Uses Tree-sitter queries for more context-aware selections
- **Syntax-aware matching**: Can distinguish between actual brackets and similar characters in other contexts (like `>` in `=>`)

#### Choosing Between Approaches

- Use **AnyQuotes/AnyBrackets** if you:

  - Prefer traditional Vim behavior
  - Want consistent character-based selection prioritizing innermost delimiters
  - Need behavior that closely matches vanilla Vim's text objects

- Use **MiniQuotes/MiniBrackets** if you:
  - Prefer the mini.ai plugin behavior
  - Want more context-aware selections using Tree-sitter
  - Prefer current-line priority when searching

#### Example Configuration

To use these text objects, you need to add bindings to your keymap. Here's an example configuration that makes them available when using text object operators (`i` and `a`) or change-surrounds (`cs`):

```

```json [keymap]
{
  "context": "vim_operator == a || vim_operator == i || vim_operator == cs",
  "bindings": {
    // 従来の Vim の挙動
    "q": "vim::AnyQuotes",
    "b": "vim::AnyBrackets",

    // mini.ai プラグインの挙動
    "Q": "vim::MiniQuotes",
    "B": "vim::MiniBrackets"
  }
}
```

この設定により、次のようなコマンドを使用できます:

- `cib` - AnyBrackets の挙動を使って括弧の内側を変更する
- `ciB` - MiniBrackets の挙動を使って括弧の内側を変更する
- `ciq` - AnyQuotes の挙動を使ってクオートの内側を変更する
- `ciQ` - MiniQuotes の挙動を使ってクオートの内側を変更する

## コマンドパレット

Vim モードでは、`:` で Zed のコマンドパレットを開けます。その後、通常の Zed のコマンド名を入力して実行できます。さらに Vim モードでは、よく使われる Vim コマンドにエイリアスを追加し、Vim での慣れた操作（マッスルメモリ）が Zed にそのまま移行できるようにしています。たとえば、ファイルを保存するには `:w` や `:write` と入力できます。

以下の表には、コマンドパレットで使用できるコマンドを示しています。角括弧で囲まれた文字は、省略可能であることを表します。

> **注意**: 現時点では Vim のコマンドラインの全機能をエミュレートしているわけではありません。特に、現在のところコマンドは引数をサポートしていません。コマンドパレットから欠けている機能を見つけた場合は、[GitHub で issue を作成](https://github.com/zed-industries/zed)してください。

### ファイルとウィンドウの管理

この表では、ウィンドウ、タブ、ペインを管理するためのコマンドを示します。現在コマンドは引数をサポートしていないため、ファイルの保存や新規作成時にファイル名を指定することはできません。

| コマンド         | 説明                                                   |
| --------------- | ------------------------------------------------------ |
| `:w[rite][!]`   | 現在のファイルを保存する                               |
| `:wq[!]`        | ファイルを保存してバッファを閉じる                     |
| `:q[uit][!]`    | バッファを閉じる                                       |
| `:wa[ll][!]`    | 開いているすべてのファイルを保存する                   |
| `:wqa[ll][!]`   | 開いているすべてのファイルを保存し、すべてのバッファを閉じる |
| `:qa[ll][!]`    | すべてのバッファを閉じる                               |
| `:[e]x[it][!]`  | バッファを閉じる                                       |
| `:up[date]`     | 現在のファイルを保存する                               |
| `:cq`           | 完全に終了する（Zed の起動中のすべてのインスタンスを閉じる） |
| `:bd[elete][!]` | すべてのペインでアクティブなファイルを閉じる           |
| `:vs[plit]`     | ペインを垂直に分割する                                 |
| `:sp[lit]`      | ペインを水平に分割する                                 |
| `:new`          | 水平分割で新しいファイルを作成する                     |
| `:vne[w]`       | 垂直分割で新しいファイルを作成する                     |
| `:tabedit`      | 新しいタブで新しいファイルを作成する                   |
| `:tabnew`       | 新しいタブで新しいファイルを作成する                   |
| `:tabn[ext]`    | 次のタブに移動する                                     |
| `:tabp[rev]`    | 前のタブに移動する                                     |
| `:tabc[lose]`   | 現在のタブを閉じる                                     |
| `:ls`           | すべてのバッファを表示する                             |

> **注意:** `!` 文字は、変更を保存せずにコマンドの実行を強制したり、ファイルを上書きする前に確認を求めないようにするために使用されます。

### Ex コマンド

これらの Ex コマンドは、Zed のさまざまなパネルやウィンドウを開きます。

| コマンド                      | デフォルトのショートカット |
| ---------------------------- | -------------------------- |
| プロジェクトパネルを開く       | `:E[xplore]`               |
| コラボレーションパネルを開く   | `:C[ollab]`                |
| チャットパネルを開く           | `:Ch[at]`                  |
| AI パネルを開く               | `:A[I]`                    |
| Git パネルを開く              | `:G[it]`                   |
| デバッグパネルを開く           | `:D[ebug]`                 |
| 通知パネルを開く               | `:No[tif]`                 |
| フィードバックウィンドウを開く | `:fe[edback]`              |
| 診断ウィンドウを開く           | `:cl[ist]`                 |
| ターミナルを開く               | `:te[rm]`                  |
| 拡張機能ウィンドウを開く       | `:Ext[ensions]`            |

### 診断間の移動

これらのコマンドで診断間を移動します。

| コマンド                  | 説明                              |
| ------------------------ | --------------------------------- |
| `:cn[ext]` or `:ln[ext]` | 次の診断に移動する                |
| `:cp[rev]` or `:lp[rev]` | 前の診断に移動する                |
| `:cc` or `:ll`           | エラーページを開く                |

### Git

これらのコマンドは、バージョン管理システム Git と連携します。

| コマンド         | 説明                                                     |
| --------------- | -------------------------------------------------------- |
| `:dif[fupdate]` | カーソル位置の diff を表示する（ノーマルモードでは `d o`） |
| `:rev[ert]`     | カーソル位置の diff を元に戻す（ノーマルモードでは `d p`） |

### ジャンプ

これらのコマンドは、ファイル内の特定の位置へジャンプします。

| コマンド             | 説明                                   |
| ------------------- | -------------------------------------- |
| `:<number>`         | 指定した行番号にジャンプする           |
| `:$`                | ファイルの末尾にジャンプする           |
| `:/foo` and `:?foo` | foo にマッチする次/前の行にジャンプする |

### 置換

このコマンドはテキストを置換します。vim の `substitute` コマンドをエミュレートしたものです。`substitute` コマンドは正規表現を使用し、Zed は vim と少し異なる構文を使用します。Zed の構文については、下の[正規表現の違いのセクション](#regex-differences)で詳しく確認できます。Zed は現在行における検索パターンの最初の出現のみを置換します。すべての一致を置換するには、`g` フラグを末尾に追加してください。

| コマンド                 | 説明                                   |
| ----------------------- | -------------------------------------- |
| `:[range]s/foo/bar/[g]` | foo を bar に置換する                  |

### 編集

これらのコマンドはテキストの編集を支援します。

| コマンド           | 説明                                                       |
| ----------------- | ---------------------------------------------------------- |
| `:j[oin]`         | 現在の行を結合する                                         |
| `:d[elete][l][p]` | 現在の行を削除する                                         |
| `:s[ort] [i]`     | 現在の選択範囲をソートする（i を付けると大文字小文字を区別しない） |
| `:y[ank]`         | 現在の選択範囲または行をヤンク（コピー）する              |

### Set

これらのコマンドは、現在のバッファに対してローカルにエディターオプションを変更します。

```
| Command                         | Description                                                                                               |
| ------------------------------- | --------------------------------------------------------------------------------------------------------- |
| `:se[t] [no]wrap`               | ウィンドウの幅より長い行は折り返され、表示が次の行に続きます                                              |
| `:se[t] [no]nu[mber]`           | 各行の先頭に行番号を表示します                                                                            |
| `:se[t] [no]r[elative]nu[mber]` | 表示される行番号をカーソル位置からの相対値に変更します                                                    |
| `:se[t] [no]i[gnore]c[ase]`     | バッファおよびプロジェクト検索で大文字小文字を区別するかどうかを制御します                                |

### Command mnemonics

任意の Zed コマンドを使用できるため、目的のコマンドを実行するニーモニックを覚えておくと便利な場合があります。例えば次のとおりです:

- `:diffs` は "すべてのハンク diff を切り替える" のニーモニックです
- `:cpp` は "ファイルへのパスをコピーする" のニーモニックです
- `:crp` は "相対パスをコピーする" のニーモニックです
- `:reveal` は "Finder で表示する" のニーモニックです
- `:zlog` は "Zed のログを開く" のニーモニックです
- `:clank` は "Language Server の処理をキャンセルする" のニーモニックです

## Customizing key bindings

### Selecting the correct context

Zed のキーバインドは、`"context"` プロパティがエディタ内での現在位置に一致する場合にのみ評価されます。例えば、`"Editor"` コンテキストにキーバインドを追加した場合、それらはファイル編集中にのみ動作します。`"Workspace"` コンテキストにキーバインドを追加した場合、それらは Zed のどこにいても動作します。次は、ファイル編集中に保存を行うキーバインドの例です:

```json [keymap]
{
  "context": "Editor",
  "bindings": {
    "ctrl-s": "workspace::Save"
  }
}
```

コンテキストはネストされています。そのため、ファイルを編集しているときのコンテキストは `"Editor"` コンテキストであり、その内側に `"Pane"` コンテキストがあり、そのさらに内側に `"Workspace"` コンテキストがあります。このため、`"Workspace"` コンテキストに追加したキーバインドは、ファイルを編集しているときにも動作します。例を示します:

```json [keymap]
// This key binding will work when you're editing a file. It comes built into Zed by default as the workspace::Save command.
{
  "context": "Workspace",
  "bindings": {
    "ctrl-s": "workspace::Save"
  }
}
```

コンテキストは式です。`&&`（AND）や `||`（OR）のようなブール演算子をサポートします。例えば、コンテキスト `"Editor && vim_mode == normal"` を使うことで、ファイルを編集していて *かつ* vim のノーマルモードにいる場合にのみ動作するキーバインドを作成できます。

Vim モードは `"Editor"` コンテキストに対して、いくつかのコンテキストを追加します:

| Operator             | Description                                                                                                                                                                        |
| -------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| VimControl           | Vim のキーバインドを有効にすべきであることを示します。現在は `vim_mode == normal \|\| vim_mode == visual \|\| vim_mode == operator` のエイリアスですが、この定義は将来変更される可能性があります |
| vim_mode == normal   | ノーマルモード                                                                                                                                                                    |
| vim_mode == visual   | ビジュアルモード                                                                                                                                                                  |
| vim_mode == insert   | 挿入モード                                                                                                                                                                        |
| vim_mode == replace  | 置換モード                                                                                                                                                                        |
| vim_mode == waiting  | 任意のキー入力を待っている状態（例: `f` や `t` を入力した直後）                                                                                                                   |
| vim_mode == operator | 別のバインディングがトリガーされるのを待っている状態（例: `c` や `d` を入力した直後）                                                                                             |
| vim_operator         | `vim_mode == operator` でない限り `none` が設定されます。その場合は現在のオペレーターのデフォルトキーバインドが設定されます（例: `d` を入力したあとは `vim_operator == d` となります）   |

> **Note**: コンテキストは一度に 1 レベルでのみマッチします。そのため `"Editor && vim_mode == normal"` のような式は使用できますが、vim のコンテキストを `"Editor"` レベルで設定しているため、`"Workspace && vim_mode == normal"` は決してマッチしません。

### Useful contexts for vim mode key bindings

Vim モードのキーバインドをカスタマイズするのに役立つ Vim モード用コンテキストのテンプレートを次に示します。これをコピーしてユーザー keymap に組み込むことができます。

```json [keymap]
[
  {
    "context": "VimControl && !menu",
    "bindings": {
      // ノーマルモードとビジュアルモードの両方で動作させたいキーバインドをここに追加します。
    }
  },
  {
    "context": "vim_mode == normal && !menu",
    "bindings": {
      // "shift-y": ["workspace::SendKeystrokes", "y $"] // Neovim の yank の挙動を使用します: 行末まで yank します。
    }
  },
  {
    "context": "vim_mode == insert",
    "bindings": {
      // "j k": "vim::NormalBefore" // 挿入モードで jk を押したときにノーマルモードへ戻るようにします。
    }
  },
  {
    "context": "EmptyPane || SharedScreen",
    "bindings": {
      // （上のコンテキストに加えて）エディタが存在しないときにもキーバインドを
      // 動作させたい場合は、ここに追加します。
      // "space f": "file_finder::Toggle"
    }
  }
]
```

> **Note**: Vim の `map` コマンド（`nmap` など）をエミュレートしたい場合は、適切なコンテキストで `workspace::SendKeystrokes` アクションを使用できます。

### Optional key bindings

デフォルトでは、エディタで開いている異なるファイル間を、`ctrl+w` に続けて `hjkl` のいずれかを押すことで、左・下・上・右の方向に移動できます。

しかし同じショートカットを使って、ターミナル、プロジェクトパネル、アシスタントパネルなどのすべてのエディタドック間を移動することはできません。ドック間の移動にも同じショートカットを使いたい場合は、次のキーバインドをユーザー keymap に追加します。

```json [keymap]
{
  "context": "Dock",
  "bindings": {
    "ctrl-w h": "workspace::ActivatePaneLeft",
    "ctrl-w l": "workspace::ActivatePaneRight",
    "ctrl-w k": "workspace::ActivatePaneUp",
    "ctrl-w j": "workspace::ActivatePaneDown"
    // ... あるいは他のキーバインド
  }
}
```

Subword モーション（`camelCase` や `snake_case` 内の個々の単語単位で移動・選択できる機能）はデフォルトでは有効になっていません。有効にするには、次のバインディングを keymap に追加します。

```
```json [keymap]
{
  "context": "VimControl && !menu && vim_mode != operator",
  "bindings": {
    "w": "vim::NextSubwordStart",
    "b": "vim::PreviousSubwordStart",
    "e": "vim::NextSubwordEnd",
    "g e": "vim::PreviousSubwordEnd"
  }
}
```

> 注: `dw` のようなオペレーションには影響しません。オペレーションでもサブワードモーションを使いたい場合は、`context` から `vim_mode != operator` を削除してください。

Vim モードにはノーマルモードで選択範囲を囲む (`ys`) ショートカットがありますが、ビジュアルモードで囲みを追加するショートカットはありません。デフォルトでは、`shift-s` は選択範囲を置換します（テキストを削除して挿入モードに入ります）。ビジュアルモードで囲みを追加するために `shift-s` を使いたい場合は、次のオブジェクトを keymap に追加します。

```json [keymap]
{
  "context": "vim_mode == visual",
  "bindings": {
    "shift-s": "vim::PushAddSurrounds"
  }
}
```

非モーダルなテキストエディタでは、カーソル移動は行末を越えると折り返されるのが一般的です。これに対して Zed は、デフォルトでは Vim とまったく同じ動作をします。カーソルは行の境界で停止します。カーソルが行をまたいで折り返すほうが好みの場合は、次のキーバインドを上書きしてください。

```json [keymap]
// VimScript では次のようになります:
// set whichwrap+=<,>,[,],h,l
{
  "context": "VimControl && !menu",
  "bindings": {
    "left": "vim::WrappingLeft",
    "right": "vim::WrappingRight",
    "h": "vim::WrappingLeft",
    "l": "vim::WrappingRight"
  }
}
```

[Sneak モーション](https://github.com/justinmk/vim-sneak) 機能は、テキスト内の任意の 2 文字の並びへ素早く移動できるようにします。この機能は、次のキーバインドを keymap に追加することで有効にできます。デフォルトでは、`s` キーは `vim::Substitute` に割り当てられています。これらのバインドを追加するとその動作が上書きされるため、この変更が自分のワークフローの好みに合っているか確認してください。

```json [keymap]
{
  "context": "vim_mode == normal || vim_mode == visual",
  "bindings": {
    "s": "vim::PushSneak",
    "shift-s": "vim::PushSneakBackward"
  }
}
```

[vim-exchange](https://github.com/tommcdo/vim-exchange) 機能には、ビジュアルモード用のデフォルトバインドがありません。これは、`shift-x` バインドがビジュアルモードのデフォルトの `shift-x` バインド (`vim::VisualDeleteLine`) と競合するためです。vim-exchange のデフォルトバインドを割り当てるには、次のキーバインドを keymap に追加します。

```json [keymap]
{
  "context": "vim_mode == visual",
  "bindings": {
    "shift-x": "vim::Exchange"
  }
}
```

### 一般的なテキスト編集および Zed のキーバインドを復元する

Linux や Windows で vim モードを使っている場合、手放せないキーバインド（貼り付け用の `ctrl+v`、検索用の `ctrl+f` など）が上書きされてしまうことがあります。これらを復元するには、次のデータを keymap にコピーします。

```json [keymap]
{
  "context": "Editor && !menu",
  "bindings": {
    "ctrl-f": "buffer_search::Deploy",      // Vim のデフォルト: 1 ページ下へ
    "ctrl-c": "editor::Copy",               // Vim のデフォルト: ノーマルモードに戻る
    "ctrl-x": "editor::Cut",                // Vim のデフォルト: デクリメント
    "ctrl-v": "editor::Paste",              // Vim のデフォルト: ビジュアルブロックモード
    "ctrl-a": "editor::SelectAll",          // Vim のデフォルト: インクリメント
    "ctrl-y": "editor::Undo",               // Vim のデフォルト: 1 行上へ
    "ctrl-t": "project_symbols::Toggle",    // Vim のデフォルト: 以前のタグへ移動
    "ctrl-o": "workspace::Open",            // Vim のデフォルト: 戻る
    "ctrl-s": "workspace::Save",            // Vim のデフォルト: シグネチャを表示
    "ctrl-b": "workspace::ToggleLeftDock"   // Vim のデフォルト: 下へ
  }
},
```

## vim モード設定の変更

vim モードの動作を変更するには、次の設定を変更できます。

| Property                     | Description                                                                                                                                                                                   | Default Value |
| ---------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------- |
| default_mode                 | 起動時のデフォルトモードです。 "normal"、"insert"、"replace"、"visual"、"visual_line"、"visual_block"、"helix_normal" のいずれかです。                                                         | "normal"      |
| use_system_clipboard         | システムクリップボードをどのように使用するかを決定します:<br><ul><li>"always": すべての操作で使用します</li><li>"never": 明示的に指定された場合にのみ使用します</li><li>"on_yank": yank 操作で使用します</li></ul> | "always"      |
| use_multiline_find           | 非推奨                                                                                                                                                                                        |               |
| use_smartcase_find           | `true` の場合、ターゲット文字が小文字のとき `f` と `t` のモーションは大文字小文字を区別しません。                                                                                             | false         |
| gdefault                     | `true` の場合、`:substitute` コマンドはデフォルトで行内のすべての一致を置換します（`g` フラグが指定された場合と同様）。このとき `g` フラグはトグルとして機能し、最初の一致だけを置換します。    | false         |
| toggle_relative_line_numbers | `true` の場合、ノーマルモードでは行番号が相対表示になり、挿入モードでは絶対表示になります。両方の利点を得ることができます。                                                                     | false         |
| custom_digraphs              | カスタムダイグラフを追加できるオブジェクトです。例については以下を参照してください。                                                                                                           | {}            |
| highlight_on_yank_duration   | ハイライトアニメーションの長さ（ミリ秒単位）です。無効にするには `0` に設定します。                                                                                                            | 200           |

ゾンビ絵文字用のダイグラフを追加する例を次に示します。これにより、`ctrl-k f z` と入力してゾンビ絵文字を挿入できるようになります。ダイグラフはいくつでも追加できます。

```json [settings]
{
  "vim": {
    "custom_digraphs": {
      "fz": "🧟‍♀️"
    }
  }
}
```

これらの設定を変更した例を次に示します。

```json [settings]
{
  "vim": {
    "default_mode": "insert",
    "use_system_clipboard": "never",
    "use_smartcase_find": true,
    "gdefault": true,
    "toggle_relative_line_numbers": true,
    "highlight_on_yank_duration": 50,
    "custom_digraphs": {
      "fz": "🧟‍♀️"
    }
  }
}
```

## vim モード向けの便利な Zed コア設定

Vim での体験を微調整するのに役立つ、一般的な Zed の設定をいくつか示します。

```
| プロパティ                | 説明                                                                                                                                                            | デフォルト値          |
| ----------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------- |
| cursor_blink            | `true` の場合、カーソルが点滅します。                                                                                                                        | `true`               |
| relative_line_numbers   | `"enabled"` の場合、左のガターの行番号はカーソル位置からの相対値になります。`"wrapped"` の場合、折り返された行にも行番号が表示されます。                     | `"disabled"`         |
| scrollbar               | スクロールバーの表示を制御するオブジェクトです。スクロールバーを非表示にするには `{ "show": "never" }` に設定します。                                       | `{ "show": "auto" }` |
| scroll_beyond_last_line | `"one_page"` に設定すると、最終行より最大 1 ページ分先までスクロールできるようになります。この動作を無効にするには `"off"` に設定します。                     | `"one_page"`         |
| vertical_scroll_margin  | スクロール時にカーソルの上下に確保しておく行数です。カーソルが画面の上下端まで移動できるようにするには `0` に設定します。                                   | `3`                  |
| gutter.line_numbers     | ガター内の行番号の表示を制御します。行番号を非表示にするには `"line_numbers"` プロパティを `false` に設定します。                                            | `true`               |
| command_aliases         | コマンドパレット内のコマンドに対するエイリアスを定義するオブジェクトです。よく使うコマンドに短い名前のショートカットを定義するために使用できます。例については以下を参照してください。 | `{}`                 |

これらの設定を変更した例を次に示します。

```json [settings]
{
  // カーソルの点滅を無効化
  "cursor_blink": false,
  // 相対行番号を使用
  "relative_line_numbers": "enabled",
  // スクロールバーを非表示にする
  "scrollbar": { "show": "never" },
  // バッファが最終行を超えてスクロールしないようにする
  "scroll_beyond_last_line": "off",
  // カーソルが画面の端まで届くようにする
  "vertical_scroll_margin": 0,
  "gutter": {
    // 行番号を完全に無効化する
    "line_numbers": false
  },
  "command_aliases": {
    "W": "w",
    "Wq": "wq",
    "Q": "q"
  }
}
```

`command_aliases` プロパティは、キーまたはキーシーケンスを Vim モードのコマンドに対応付ける単一のオブジェクトです。上記の例では、`w` に対する `W`、`wq` に対する `Wq`、`q` に対する `Q` という複数のエイリアスを定義しています。

## 正規表現の違い

Zed は Vim とは異なる正規表現エンジンを使用しています。つまり、場合によっては異なる構文を使う必要があります。以下は最も一般的な違いです。

- **キャプチャグループ**: Vim ではキャプチャグループを表すのに `\(` と `\)` を使用しますが、Zed では `(` と `)` を使用します。逆に、Vim では `(` と `)` はリテラルな丸括弧を表しますが、Zed ではこれらをリテラルとして扱うには `\(` と `\)` としてエスケープする必要があります。
- **マッチ部分**: 置換時、Vim ではバックスラッシュに数字を続けて書くことで、マッチしたキャプチャグループを表します（例: `\1`）。Zed では代わりにドル記号を使用します。そのため、Vim で全体のマッチを表すのに `\0` を使う場合、Zed では代わりに `$0` という構文になります。番号付きキャプチャグループも同様で、Vim の `\1` は Zed では `$1` になります。
- **グローバル指定**: デフォルトでは、Vim の正規表現検索は行ごとの最初の一致だけをマッチし、すべての一致を見つけるにはクエリの末尾に `/g` を付けます。Zed では、正規表現検索はデフォルトでグローバル検索（すべての一致を対象）になります。
- **大文字・小文字の区別**: Vim では `/i` を使って大文字・小文字を区別しない検索を指定します。Zed では、パターンの先頭に `(?i)` と書くか、ショートカット {#kb search::ToggleCaseSensitive} を使って大文字・小文字の区別を切り替えることができます。

> **注記**: 移行を支援するために、Vim 形式の置換コマンド `:%s//` を入力すると、コマンドパレットが括弧や置換グループを自動的に修正します。そのため Zed は `%s:/\(a\)(b)/\1/` を、"(a)\(b\)" を検索し "$1" に置き換えるような操作へと変換します。

Zed の正規表現エンジンがサポートする構文の詳細については、[regex クレートのドキュメントを参照してください](https://docs.rs/regex/latest/regex/#syntax)。
