# テーマ

拡張機能内の `themes` ディレクトリには、1つ以上のテーマファイルを含める必要があります。

各テーマファイルは、[`https://zed.dev/schema/themes/v0.2.0.json`](https://zed.dev/schema/themes/v0.2.0.json) で指定されている JSON スキーマに従う必要があります。

テーマの作成に関する追加の背景情報については、[このブログ記事](https://zed.dev/blog/user-themes-now-in-preview) を参照してください。

## Theme JSON 構造

Zed テーマの構造は、[Zed Theme JSON Schema](https://zed.dev/schema/themes/v0.2.0.json) で定義されています。

Zed テーマは、次を含む Theme Family オブジェクトで構成されます:

- `name`: テーマファミリーの名前
- `author`: テーマファミリーの作者名
- `themes`: テーマファミリーに属する Theme の配列

Theme オブジェクトの中核となる構成要素は次のとおりです:

1. テーマのメタデータ:

   - `name`: テーマの名前
   - `appearance`: "light" または "dark" のいずれか

2. `style` 配下のスタイルプロパティ。例:

   - `background`: メインの背景色
   - `foreground`: メインのテキストカラー
   - `accent`: 強調やハイライトに使用されるアクセントカラー

3. シンタックスハイライト:

   - `syntax`: さまざまな構文要素（キーワード、文字列、コメントなど）の色定義を含むオブジェクト

4. UI 要素:

   - 次のような各種 UI コンポーネントの色:
     - `element.background`: UI 要素の背景色
     - `border`: 通常、フォーカス時、選択時などの状態ごとのボーダーカラー
     - `text`: 通常、弱め、アクセントなど状態ごとのテキストカラー

5. エディタ固有の色:

   - 次のようなエディタ関連要素の色:
     - `editor.background`: エディタの背景色
     - `editor.gutter`: ガターの色
     - `editor.line_number`: 行番号の色

6. ターミナルの色:
   - 統合ターミナル用の ANSI カラー定義

## テーマのデザイン

[Zed's Theme Builder](https://zed.dev/theme-builder) を使用して、既存のテーマをベースに独自のカスタムテーマをデザインできます。

このツールを使うと、Zed 内の各サーフェスがどのように見えるかを微調整しながらプレビューできます。
その後、JSON をエクスポートして Zed の拡張機能ストアに公開できます。
