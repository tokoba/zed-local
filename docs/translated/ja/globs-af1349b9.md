# グロブ

Zed では、sh、bash、zsh などでサポートされている `*.md` や `docs/src/**/*.md` といった Unix シェル形式のパスマッチング用ワイルドカードの正式名称である [glob](<https://en.wikipedia.org/wiki/Glob_(programming)>) パターンを使用できます。グロブは [regex（正規表現）](https://en.wikipedia.org/wiki/Regular_expression) に似ていますが、別物です。Zed では、グロブは主にファイル名のマッチングに使用されます。

## グロブの種類

Zed はグロブパターンのマッチングに、2 つの異なる Rust crate を使用します。

- `.gitignore` ファイルに記述されたグロブパターンのマッチング用の [ignore crate](https://docs.rs/ignore/latest/ignore/)
- Zed 内のファイルパスのマッチング用の [glob crate](https://docs.rs/glob/latest/glob/)

単純な式は環境間で共通して動作します（例: `ls *.py` を実行する、`.gitignore` に `*.tmp` を書く など）が、より高度な機能（文字クラス、否定、`**` など）については、実装によってサポート状況や構文に大きな違いがあります。本ドキュメントの残りの部分では、`glob` crate の実装を通じて Zed がサポートしているグロブについて説明します。`.gitignore`、シェル、その他のプログラミング言語におけるグロブパターン構文のドキュメントリンクについては、後述の [References](#references) を参照してください。

`glob` crate は完全に Rust で実装されており、プラットフォームの libc が提供する `glob` / `fnmatch` インターフェイスには依存していません。つまり、Zed におけるグロブはプラットフォーム間で同様に動作するはずです。

## Introduction

グロブの「パターン」は、ファイル名または完全なファイルパスをマッチさせるために使用されます。たとえば "Search all files" {#kb project_search::ToggleFocus} を使用しているとき、じょうごの形をした "Toggle Filters" ボタンをクリックするか {#kb project_search::ToggleFilters} すると、"Include" と "Exclude" の追加の検索フィールドが表示されます。これらのフィールドでは、ファイルパスやファイル名にマッチさせるグロブパターンを指定できます。

### Multiple Patterns

プロジェクト検索のフィルターでは、グロブパターンをカンマで区切ることで複数指定できます。カンマ区切りのパターンを使う場合でも、Zed は各パターン内の波括弧を正しく扱います。

- `*.ts, *.tsx` — TypeScript ファイルと TSX ファイルにマッチします
- `src/{components,utils}/**/*.ts, tests/**/*.test.ts` — 特定のディレクトリ内の TypeScript ファイルとテストファイルにマッチします

各パターンは独立して評価されます。波括弧内のカンマ（`{a,b}` のようなもの）は区切り文字ではなく、パターンの一部として扱われます。

**重要:** 波括弧はパターン内にそのまま残りますが、Zed はそれらを複数のパターンに展開しません。パターン `src/{a,b}/*.ts` は、`src/a/*.ts` や `src/b/*.ts` ではなく、リテラルなパス構造として `{a,b}` を含むパスにマッチします。これはシェルの動作とは異なります。

グロブパターンを作成する際には、1 つまたは複数の特殊文字を使用できます。

| Special Character | Meaning                                                           |
| ----------------- | ----------------------------------------------------------------- |
| `?`               | 任意の 1 文字にマッチします                                       |
| `*`               | 任意の（空文字列を含む）長さの文字列にマッチします               |
| `**`              | 現在のディレクトリおよび任意のサブディレクトリにマッチします     |
| `[abc]`           | 角括弧内のいずれか 1 文字にマッチします                          |
| `[a-z]`           | （Unicode の順序で）連続する文字の範囲内のいずれか 1 文字にマッチします |
| `[!... ]`         | `[...]` の否定（角括弧内にない文字にマッチします）               |

Notes:

1. 波括弧文字 `{` と `}` は展開用の演算子ではなく、リテラルなパターン文字として扱われます。パターン `src/{a,b}/*.ts` は、シェルのグロブのように `src/a/*.ts` または `src/b/*.ts` にマッチするのではなく、リテラルな文字列 `{a,b}` を含むパスにマッチします。
2. 角括弧内でリテラルの `-` 文字にマッチさせるには、先頭 `[-abc]` もしくは末尾 `[abc-]` に置く必要があります。
3. リテラルの `[` 文字にマッチさせるには `[[]` を使うか、グループの先頭に `[[abc]` のように置きます。
4. リテラルの `]` 文字にマッチさせるには `[]]` を使うか、グループの末尾に `[abc]]` のように置きます。

## Examples

### Matching file extensions

Markdown ファイルだけを検索したい場合は、"Include" 検索フィールドに `*.md` を追加します。

### Case insensitive matching

Zed のグロブは大文字・小文字を区別するため、`*.c` は `main.C` にはマッチしません（macOS の HFS+/APFS のような大文字・小文字を区別しないファイルシステム上であっても同様です）。代わりに角括弧を使って文字を指定してください。つまり、`*.c` の代わりに `*.[cC]` を使用します。

### Matching directories

Zed の [zed リポジトリ](https://github.com/zed-industries/zed) 内で [Configuring Language Servers](https://zed.dev/docs/configuring-languages#configuring-language-servers)（Zed の settings.json の `"lsp"` の下） の例を検索したい場合、`"lsp"` を検索し、"Include" フィルターに `docs/**/*.md` を指定できます。これにより、パスが `docs` ディレクトリ、またはそのフォルダー配下の任意の入れ子になったサブディレクトリ `**/` の下にあり、ファイル名が `.md` で終わるファイルだけがマッチします。

代わりに、[Zed Language-Specific Documentation](https://zed.dev/docs/languages) のページだけに絞り込みたい場合は、より狭いパターンとして `docs/src/languages/*.md` を指定できます。これは [`docs/src/languages/rust.md`](https://github.com/zed-industries/zed/blob/main/docs/src/languages/rust.md) や [`docs/src/languages/cpp.md`](https://github.com/zed-industries/zed/blob/main/docs/src/languages/cpp.md) にはマッチしますが、[`docs/src/configuring-languages.md`](https://github.com/zed-industries/zed/blob/main/docs/src/configuring-languages.md) にはマッチしません。

### Implicit Wildcards

プロジェクト検索で "Include" / "Exclude" フィルターを使用する場合、各グロブは暗黙のワイルドカードで囲まれます。例えば、パスやファイル名に `license` を含むファイルを検索対象から除外したい場合は、Exclude ボックスに単に `license` と入力します。内部的には、Zed は `license` を `**license**` に変換します。つまり、`license.*` という名前のファイル、`*.license` という名前のファイル、`license` サブディレクトリ内のファイルはすべて除外されます。これにより、ユーザーは毎回 `**/*.ts` と入力することを覚えておかなくても、簡単に `*.ts` でフィルターできるようになります。

一方で、Zed の設定で特定のディレクトリにのみ適用される [`file_types`](./reference/all-settings.md#file-types) の上書きを行いたい場合は、ワイルドカードのグロブを明示的に含める必要があります。例えば、拡張子が `html` のテンプレートファイルのディレクトリを Jinja2 テンプレートとして認識させたい場合は、次のように指定できます。

```json [settings]
{
  "file_types": {
    "C++": ["[cC]"],
    "Jinja2": ["**/templates/*.html"]
  }
}
```

## References

Zed におけるグロブは上述の通りに実装されていますが、他の言語でグロブを使うコードを書く際には、利用しているプラットフォームのグロブに関するドキュメントを参照してください。

- [macOS fnmatch](https://developer.apple.com/library/archive/documentation/System/Conceptual/ManPages_iPhoneOS/man3/fnmatch.3.html)（BSD C 標準ライブラリ）
- [Linux fnmatch](https://www.gnu.org/software/libc/manual/html_node/Wildcard-Matching.html)（GNU C 標準ライブラリ）
- [POSIX fnmatch](https://pubs.opengroup.org/onlinepubs/9699919799/functions/fnmatch.html)（POSIX 仕様）
- [node-glob](https://github.com/isaacs/node-glob)（Node.js の `glob` パッケージ）
- [Python glob](https://docs.python.org/3/library/glob.html)（Python 標準ライブラリ）
- [Golang glob](https://pkg.go.dev/path/filepath#Match)（Go 標準ライブラリ）
- [gitignore patterns](https://git-scm.com/docs/gitignore)（Gitignore パターン形式）
- [PowerShell: About Wildcards](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_wildcards)（PowerShell におけるワイルドカード）
