# キーバインド

Zed のキーバインドシステムは完全にカスタマイズ可能です。任意のアクションに対して再割り当てを行ったり、キーシーケンスを作成したり、コンテキストごとのバインディングを定義したりできます。

## 事前定義キーマップ

特定のエディタのデフォルトに慣れている場合は、設定ウィンドウ ({#kb zed::OpenSettings}) から、または `settings.json` ファイル ({#kb zed::OpenSettingsFile}) を直接編集することで、`base_keymap` を変更できます。
現在、次のキーマップをサポートしています。

- VS Code (default)
- Atom
- Emacs (Beta)
- JetBrains
- Sublime Text
- TextMate
- Cursor
- None ( *すべての* キーバインドを無効にします)

この設定は、コマンドパレットから `zed: toggle base keymap selector` アクションを実行することでも変更できます。

`vim_mode` や `helix_mode` を有効にして、モーダルなバインディングを追加することもできます。
詳しくは、[Vim mode](./vim.md) と [Helix mode](./helix.md) のドキュメントを参照してください。

## キーマップエディタ

キーマップエディタには、{#kb zed::OpenKeymap} アクションを使うか、コマンドパレットから {#action zed::OpenKeymap} アクションを実行してアクセスできます。コマンドパレット左下隅の `Change Keybinding` または `Add Keybinding` ボタンを使うと、アクションに対するキーバインドを簡単に追加・変更できます。

そこでは、Zed に存在するすべてのアクションと、それらにデフォルトで割り当てられているキーバインドを確認できます。

また、特定のアクションにカーソルを合わせたときに表示される鉛筆アイコンをクリックするか、アクション行をダブルクリックするか、`enter` キーを押すことで、その場でカスタマイズすることもできます。

キーマップエディタで行った操作はすべて `keymap.json` ファイルにも反映されます。

## ユーザーキーマップ

キーマップファイルは、各プラットフォームで次の場所に保存されます。

- macOS/Linux: `~/.config/zed/keymap.json`
- Windows: `~\AppData\Roaming\Zed/keymap.json`

コマンドパレットから {#action zed::OpenKeymapFile} アクションを実行して、キーマップファイルを開くことができます。

このファイルには、`"bindings"` を持つオブジェクトの JSON 配列が含まれています。
`"context"` が設定されていない場合、そのバインディングは常に有効です。
設定されている場合は、その[コンテキストが一致](#contexts)しているときにのみバインディングが有効になります。

各バインディングセクション内では、[キーシーケンス](#keybinding-syntax) が [アクション](#actions) にマッピングされます。
競合が検出された場合は、[後述のとおり](#precedence)に解決されます。

QWERTY 以外のラテン文字キーボードを使用している場合は、`use_key_equivalents` を `true` に設定するとよいでしょう。詳しくは、[Non-QWERTY keyboards](#non-qwerty-keyboards) を参照してください。

例えば次のようになります。

```json [keymap]
[
  {
    "bindings": {
      "ctrl-right": "editor::SelectLargerSyntaxNode",
      "ctrl-left": "editor::SelectSmallerSyntaxNode"
    }
  },
  {
    "context": "ProjectPanel && not_editing",
    "bindings": {
      "o": "project_panel::Open"
    }
  }
]
```

各プラットフォーム向けの Zed のデフォルトのバインディングは、デフォルトのキーマップファイルで確認できます。

- [macOS](https://github.com/zed-industries/zed/blob/main/assets/keymaps/default-macos.json)
- [Windows](https://github.com/zed-industries/zed/blob/main/assets/keymaps/default-windows.json)
- [Linux](https://github.com/zed-industries/zed/blob/main/assets/keymaps/default-linux.json).

カスタムキーマップに関する問題をデバッグしたい場合は、コマンドパレットから `dev: Open Key Context View` を使用できます。
動作するはずなのに動作しないと思われるものに遭遇した場合は、[an issue](https://github.com/zed-industries/zed) を作成してください。

### キーバインドの構文

Zed は、単一のキー入力だけでなく、順番に入力されたキーのシーケンスにもマッチさせることができます。`"bindings"` マップ内の各キーは、スペースで区切られたキー入力のシーケンスです。

各キー入力は、修飾キーの列とそれに続くキーから構成されます。使用できる修飾キーは次のとおりです。

- `ctrl-` Control キー
- `cmd-`、`win-` または `super-` プラットフォーム修飾キー (macOS では Command、Windows では Windows キー、Linux では Super キー)
- `alt-` Alt キー (macOS では Option キー)
- `shift-` Shift キー
- `fn-` Fn (Function) キー
- `secondary-` Zed が macOS で動作している場合は `cmd`、Windows と Linux の場合は `ctrl` と同等

キーとしては、キーボードが生成する任意の 1 つの Unicode コードポイント (例: `a`、`0`、`£`、`ç`) や、名前付きキー (`tab`、`f1`、`shift`、`cmd` など) を指定できます。ラテン文字以外のレイアウト (例: キリル文字) を使用している場合は、そのキーが `cmd` を押した状態で生成するキリル文字、あるいはラテン文字のどちらにもバインドできます。

いくつか例を示します。

```json [keymap]
{
  "bindings": {
    "cmd-k cmd-s": "zed::OpenKeymap", // ⌘-k のあとに ⌘-s を押したときにマッチ
    "space e": "editor::ShowCompletions", // スペースのあとに e を入力
    "ç": "editor::ShowCompletions", // ⌥-c にマッチ
    "shift shift": "file_finder::Toggle" // Shift キーを 2 回押して離したときにマッチ
  }
}
```

修飾キー `shift-` は、大文字を表すために文字と組み合わせてのみ使用できます。例えば、`shift-g` は `G` を入力したときにマッチします。多くのキーボードでは `(` のような記号文字を入力するために Shift が使われますが、その場合は修飾されたキー入力とは見なされないため、`shift-(` にはマッチしません。

多くのレイアウトでは、修飾キー `alt-` を使って別のキーを生成できます。例えば、macOS の US キーボードでは、`alt-c` の組み合わせで `ç` が入力されます。キーマップファイルではどちらにもマッチさせることができますが、慣例として Zed ではこの組み合わせを `alt-c` と表記します。

修飾キー単体の入力に対してマッチさせることも可能です。例えば、`shift shift` を使って JetBrains の「Search Everywhere」ショートカットを実装できます。この場合、バインディングはキーが押されたときではなく、キーが離されたときに発火します。

### コンテキスト

バインディンググループに `"context"` キーがある場合、その値は Zed 内で現在アクティブなコンテキストに対して照合されます。

Zed のコンテキストはツリー構造になっており、ルートは `Workspace` です。Workspace は Pane や Panel を含み、Pane は Editor を含む、といった構造になります。現在どのコンテキストがアクティブになっているかを確認する最も簡単な方法は、コマンドパレットから `dev: open key context view` コマンドで開けるキーコンテキストビューを使うことです。

例えば次のようになります。

```
# エディタ内では次のように表示されます:
Workspace os=macos keyboard_layout=com.apple.keylayout.QWERTY
  Pane
    Editor mode=full extension=md vim_mode=insert

# プロジェクトパネルの場合
Workspace os=macos
  Dock
    ProjectPanel not_editing
```

コンテキスト式には、次のような構文を含めることができます。

- `X && Y`、`X || Y` 2 つの条件を AND/OR で組み合わせる
- `!X` 条件が偽であることを確認する
- `(X)` グルーピングに使用する
- `X > Y` ツリー内の先祖が X にマッチし、現在の階層が Y にマッチする場合にマッチさせる

例えば:

- `"context": "Editor"` - すべてのエディタにマッチします (インライン入力を含む)
- `"context": "Editor && mode == full"` - コード編集に使用されるメインエディタにマッチします
- `"context": "!Editor && !Terminal"` - Editor または Terminal にフォーカスがある場所以外のすべてにマッチします
- `"context": "os == macos > Editor"` - macOS 上のすべてのエディタにマッチします。

属性は、定義されているノードでのみ参照できる点に注意してください。つまり、例えばデバッガが停止していて vim のノーマルモードのときにだけキーバインドを有効にしたい場合は、`debugger_stopped > vim_mode == normal` のように指定する必要があります。
> 注: Zed v0.197.x より前では、`!` 演算子は一度に 1 つのノードだけを見ており、`>` は「ancestor」ではなく「parent」を意味していました。これは、`!Editor` がコンテキスト `Workspace > Pane > Editor` にマッチすることを意味していました。というのも（やや紛らわしいのですが）Pane が `!Editor` にマッチするためです。また、中間に `Pane` ノードがあるため、`os == macos > Editor` はコンテキスト `Workspace > Pane > Editor` にマッチしませんでした。

Vim モードを使用している場合は、[vim modes influence the context](./vim.md#contexts) に関する情報があります。Helix モードは Vim モードの上に構築されており、同じコンテキストを使用します。

### アクション

Zed の機能のほとんどはアクションとして公開されています。
明示的な一覧は文書化されていませんが、コマンドパレットで検索したり、[macOS](https://github.com/zed-industries/zed/blob/main/assets/keymaps/default-macos.json)、[Windows](https://github.com/zed-industries/zed/blob/main/assets/keymaps/default-windows.json)、[Linux](https://github.com/zed-industries/zed/blob/main/assets/keymaps/default-linux.json) 向けのデフォルトキーマップを見たり、キーマップファイル内で Zed のオートコンプリートを使うことで、ほとんどのアクションを見つけることができます。

ほとんどのアクションは引数を必要としないため、文字列としてバインドできます: `"ctrl-a": "language_selector::Toggle"`。1 つの引数を必要とするものもあり、その場合は配列としてバインドする必要があります: `"cmd-1": ["workspace::ActivatePane", 0]`。複数の引数を必要とするアクションもあり、その場合は文字列とオブジェクトの配列としてバインドされます: `"ctrl-a": ["pane::DeploySearch", { "replace_enabled": true }]`。

### 優先順位

複数のキーバインディングが同じキーストロークを持ち、同時にアクティブになっている場合、優先順位は次の 2 つの方法で解決されます。

- コンテキストツリーのより下位のノードにマッチするバインディングが優先されます。つまり、コンテキストが `Editor` のバインディングがある場合、それはコンテキストが `Workspace` のバインディングよりも優先されます。コンテキストを持たないバインディングは、ツリー内の最下位レベルでマッチします。
- ツリー内の同じレベルでマッチするバインディングが複数ある場合は、後から定義されたバインディングが優先されます。ユーザーのキーバインディングはシステムのキーバインディングより後に読み込まれるため、これによりユーーバインディングが組み込みのキーバインディングよりも優先されます。

もうひとつの種類の競合は、一方がもう一方の接頭辞になっている 2 つのバインディングがある場合に発生します。例えば、`"ctrl-w":"editor::DeleteToNextWordEnd"` と `"ctrl-w left":"editor::DeleteToEndOfLine"` がある場合です。

このような場合、かつ両方のバインディングが現在のコンテキストでアクティブなとき、Zed は `ctrl-w` をタイプした後、`left` をタイプしようとしているかどうか確認するために 1 秒間待ちます。何もタイプしない場合、あるいは別のキーをタイプした場合は、`DeleteToNextWordEnd` がトリガーされます。`left` をタイプした場合は `DeleteToEndOfLine` がトリガーされます。

### QWERTY 以外のキーボード

Zed の QWERTY 以外のキーボードに対するサポートは、まだ開発途中です。

キーボードが ASCII 全体の範囲（DVORAK、COLEMAK など）をタイプできる場合、ショートカットは期待どおりに動作するはずです。

それ以外の場合は、続きをお読みください...

#### macOS

主に非 ASCII のキーボード（キリル文字、ヘブライ語、アルメニア語など）では、`cmd` を押している間、macOS が自動的にキーを ASCII の範囲にマップします。Zed はこれをさらに一歩進め、修飾キーや `use_key_equivalents` 設定に関係なく、常に ASCII レイアウトまたは実際のレイアウトのいずれかに対してキープレスをマッチさせることができます。例えば、タイ語では、`ctrl-ๆ` を押すと、`ctrl-q` または `ctrl-ๆ` に関連付けられたバインディングにマッチします。

拡張ラテンアルファベットをサポートするキーボード（フランス語 AZERTY、ドイツ語 QWERTZ など）では、`option` を使わずに ASCII の全範囲をタイプすることがしばしばできません。これはあいまいさを生みます: `option-2` は `@` を生成します。これらのキーボードでもすべての組み込みキーボードショートカットをタイプできるようにするために、キーのバインディングを移動しています。例えば、QWERTY で `@` にバインドされているショートカットは、スペイン語レイアウトでは `"` に移動されます。このマッピングは macOS のシステムデフォルトに基づいており、コマンドパレットから `dev: open key context view` を実行することで確認できます。

個人のキーマップでショートカットを定義している場合、キーマップ内で `use_key_equivalents` を `true` に設定することで、キー同等マッピングを有効化できます。

```json [keymap]
[
  {
    "use_key_equivalents": true,
    "bindings": {
      "ctrl->": "editor::Indent" // ドイツ語 QWERTZ キーボードがアクティブなときは ctrl-: として解釈されます
    }
  }
]
```

### Linux

v0.196.0 以降、Linux では、タイプしたキーが ASCII 文字を生成しない場合、キーボードショートカットには QWERTY レイアウトの同等キーを使用します。これにより、多くのレイアウトで多くのショートカットをタイプできるようになります。

まだ、すべての組み込みショートカットがあらゆるレイアウトでタイプ可能になるようなリマップは行っていません。レイアウトによってはいくつかの ASCII 文字をタイプできない場合があり、その場合はカスタムキーバインディングが必要になるかもしれません。この点については今後改善を予定しています。

## ヒントとテクニック

### バインディングを無効化する

あるバインディングを特定のコンテキストで何もしないようにしたい場合は、アクションとして `null` を使用できます。これは、誤ってそのキーバインディングを押してしまう場合にそれを無効化したり、そのシーケンスによってタイプされる文字を入力したかったり、そのキーで始まるマルチキーのバインディングを無効化したい場合に便利です。

```json [keymap]
[
  {
    "context": "Workspace",
    "bindings": {
      "cmd-r": null // Workspace コンテキストがアクティブなときは cmd-r は何もしません
    }
  }
]
```

`null` バインディングは通常のアクションと同じ優先順位ルールに従うため、ツリーのさらに上位でマッチするすべてのバインディングも無効化します。ツリーの上位でマッチするバインディングに、下位のバインディングより優先してほしい場合は、望むコンテキストで望むアクションに再バインドする必要があります。

これは、指定したアクションが条件付きで伝播する場合に、Zed がデフォルトのキーバインディングにフォールバックするのを防ぐのに役立ちます。例えば、`buffer_search::DeployReplace` は検索バーが表示されていないときにのみトリガーされます。検索バーが表示されている場合は伝播し、そのキーバインディングに設定されたデフォルトアクション（右ドックを開くなど）をトリガーします。これを防ぐには、次のようにします。

```json [keymap]
[
  {
    "context": "Workspace",
    "bindings": {
      "cmd-r": null // 検索バーが表示されているときは cmd-r は何もしません
    }
  },
  {
    "context": "Workspace",
    "bindings": {
      "cmd-r": "buffer_search::DeployReplace" // 検索バーが表示されていないときは cmd-r が置換を展開します
    }
  }
]
```

### キーの再割り当て

よくある要望として、単一のキーストロークからシーケンスにマップできるようにしたい、というものがあります。これは `workspace::SendKeystrokes` アクションを使うことで実現できます。

```json [keymap]
[
  {
    "bindings": {
      // 下に 4 回移動
      "alt-down": ["workspace::SendKeystrokes", "down down down down"],
      // 選択範囲を拡大 (editor::SelectLargerSyntaxNode);
      // クリップボードにコピーし、その後、選択範囲の拡大を取り消します。
      "cmd-alt-c": [
        "workspace::SendKeystrokes",
        "ctrl-shift-right ctrl-shift-right ctrl-shift-right cmd-c ctrl-shift-left ctrl-shift-left ctrl-shift-left"
      ]
    }
  },
  {
    "context": "Editor && vim_mode == insert",
    "bindings": {
      "j k": ["workspace::SendKeystrokes", "escape"]
    }
  }
]
```

これにはいくつかの制限があり、特に次の点が挙げられます:

- 任意の非同期操作は、すべてのキーバインディングがディスパッチされた後まで開始されません。例えば、`cmd-alt-r` の例のように、バインディングを使ってファイルを開くことはできますが、新しいビューに解釈してもらえることを期待して、さらにキーストロークを送ることはできません。
- その他の非同期処理の例としては、コマンドパレットを開くこと、言語サーバーとの通信、バッファの言語を変更すること、ネットワークアクセスを行う処理などがあります。
- 一度にシミュレートできるキー数には 100 個という上限があります。

`SendKeystrokes` への引数は、スペース区切りのキーストロークのリストです（構文は上記と同じです）。キーストロークのパース方法の都合上、キー押下として認識されない任意の部分は、現在フォーカスされている入力フィールドにそのまま送信されます。

`SendKeystrokes` の引数に、それをトリガーするために使用したバインディングが含まれている場合、そのバインディングに対して次に優先順位の高い定義が使用されます。これにより、キーバインディングのデフォルトの挙動を拡張できます。

### キーをターミナルに転送する

Linux または Windows を使用している場合、キーの組み合わせを Zed に処理させるのではなく、組み込みターミナルに転送したくなることがあるかもしれません。

例えば、Linux では `ctrl-n` は Zed で新しいタブを作成します。組み込みターミナルにフォーカスがあるときに `ctrl-n` をそのターミナルに送信したい場合は、次の内容を keymap に追加してください:

```json [keymap]
{
  "context": "Terminal",
  "bindings": {
    "ctrl-n": ["terminal::SendKeystroke", "ctrl-n"]
  }
}
```

### タスクのキーバインディング

`tasks.json` で定義された Zed Tasks を起動するようにキーをバインドすることもできます。
詳しくは [tasks のドキュメント](tasks.md#custom-keybindings-for-tasks) を参照してください。
