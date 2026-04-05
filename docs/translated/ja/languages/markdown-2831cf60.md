# Markdown

Zed には Markdown のサポートがネイティブで組み込まれています。

- Tree-sitter: [tree-sitter-Markdown](https://github.com/tree-sitter-grammars/tree-sitter-markdown)
- 言語サーバー: N/A

## Syntax Highlighting Code Blocks

Zed は、[tree-sitter の言語文法](../extensions/languages.md#grammar) を利用して、Markdown のコードブロックに対する言語ごとのシンタックスハイライトをサポートします。[Zed がサポートするすべての言語](../languages.md)は、公式およびコミュニティの拡張機能によって提供されるものも含めて、Markdown のコードブロックで利用できます。あとは、次のように開始側の <kbd>```</kbd> コードフェンスの後に言語名を指定するだけです。

````python
```python
import functools as ft

@ft.lru_cache(maxsize=500)
def fib(n):
    return n if n < 2 else fib(n - 1) + fib(n - 2)
```
````

## Configuration

### Format

Zed は、Prettier を使って Markdown ドキュメントを自動的に再フォーマットできます。これは {#action editor::Format} アクション、または {#kb editor::Format} キーボードショートカットから手動で実行できます。あるいは、保存時の自動フォーマットを有効にすることもできます。

Settings ({#kb zed::OpenSettings}) の Languages > Markdown でフォーマットを設定するか、設定ファイルに次のように追加します。

```json [settings]
  "languages": {
    "Markdown": {
      "format_on_save": "on"
    }
  },
```

### List Continuation

リスト項目の末尾で Enter を押すと、Zed は自動的にリストを継続します。対応しているリストの種類は次のとおりです。

- 箇条書きリスト（マーカーは `-`、`*`、または `+`）
- 番号付きリスト（番号は自動でインクリメントされます）
- タスクリスト（`- [ ]` および `- [x]`）

空のリスト項目で Enter を押すと、マーカーが削除され、リスト入力モードを終了します。

この挙動を無効にするには、Settings ({#kb zed::OpenSettings}) の Languages > Markdown で設定するか、設定ファイルに次のように追加します。

```json [settings]
  "languages": {
    "Markdown": {
      "extend_list_on_newline": false
    }
  },
```

### List Indentation

カーソルがリストマーカーだけを含む行にある状態で Tab を押すと、Zed はそのリスト項目をインデントします。これにより、入れ子のリストを素早く作成できます。

この挙動を無効にするには、Settings ({#kb zed::OpenSettings}) の Languages > Markdown で設定するか、設定ファイルに次のように追加します。

```json [settings]
  "languages": {
    "Markdown": {
      "indent_list_on_tab": false
    }
  },
```

### Trailing Whitespace

デフォルトでは、Zed は保存時に行末の空白を削除します。Markdown ファイルで、見えない行末の空白が `<br />` に変換される挙動に依存している場合は、この挙動を無効にできます。

Settings ({#kb zed::OpenSettings}) の Languages > Markdown で設定するか、設定ファイルに次のように追加します。

```json [settings]
  "languages": {
    "Markdown": {
      "remove_trailing_whitespace_on_save": false
    }
  },
```
