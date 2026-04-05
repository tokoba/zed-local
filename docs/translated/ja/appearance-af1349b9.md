# 外観

Zed の見た目を自分の好みに合わせてカスタマイズできます。このガイドでは、テーマ、フォント、アイコン、そのほかの表示設定について説明します。

設定システムの仕組みについては、[すべての設定](./reference/all-settings.md) を参照してください。

## 5 分で Zed をカスタマイズ

Zed を自分好みの環境にする手順は次のとおりです。

1. **テーマを選ぶ**: {#kb theme_selector::Toggle} を押してテーマセレクターを開きます。矢印キーでリストを移動してテーマをリアルタイムにプレビューし、Enter キーを押して適用します。

2. **ライト/ダークモードを素早く切り替える**: {#kb theme::ToggleMode} を押します。現在静的な `"theme": "..."` の値を使用している場合、最初の切り替え時にそれがデフォルトテーマを使用する動的モード設定に変換されます。

3. **アイコンテーマを選ぶ**: コマンドパレットから `icon theme selector: toggle` を実行して、アイコンテーマをブラウズします。

4. **フォントを設定する**: {#kb zed::OpenSettings} で Settings Editor を開き、`buffer_font_family` を検索します。お好みのコーディング用フォントに設定します。

5. **フォントサイズを調整する**: 同じ Settings Editor で `buffer_font_size` と `ui_font_size` を検索し、エディターとインターフェースの文字サイズを調整します。

以上で完了です。自分専用にカスタマイズされた Zed のセットアップになりました。

## テーマ

Extensions ページ ({#action zed::Extensions}) からテーマをインストールし、テーマセレクター ({#kb theme_selector::Toggle}) で切り替えます。

Zed ではライトモードとダークモード用に別々のテーマを設定でき、システムの設定に基づいて自動的に切り替えられます。

```json [settings]
{
  "theme": {
    "mode": "system",
    "light": "One Light",
    "dark": "One Dark"
  }
}
```

さらに、特定のテーマ属性を上書きして、より細かく制御することもできます。

→ [テーマのドキュメント](./themes.md)

## アイコンテーマ

Project Panel やタブに表示されるファイルおよびフォルダーのアイコンをカスタマイズできます。アイコンテーマセレクター（コマンドパレットで `icon theme selector: toggle` を実行）を使って、利用可能なアイコンテーマをブラウズします。

カラーテーマと同様に、アイコンテーマもライト用とダーク用のバリアントを別々に設定できます。

```json [settings]
{
  "icon_theme": {
    "mode": "system",
    "light": "Zed (Default)",
    "dark": "Zed (Default)"
  }
}
```

→ [アイコンテーマのドキュメント](./icon-themes.md)

## フォント

Zed では、用途に応じて 3 つのフォント設定を使用します。

| 設定                   | 用途                      |
| ---------------------- | ------------------------- |
| `buffer_font_family`   | エディターのテキスト      |
| `ui_font_family`       | インターフェース要素      |
| `terminal.font_family` | [ターミナル](./terminal.md) |

設定例:

```json [settings]
{
  "buffer_font_family": "JetBrains Mono",
  "buffer_font_size": 14,
  "ui_font_family": "Inter",
  "ui_font_size": 16,
  "terminal": {
    "font_family": "JetBrains Mono",
    "font_size": 14
  }
}
```

### フォントの合字

フォントの合字を無効にするには次のようにします。

```json [settings]
{
  "buffer_font_features": {
    "calt": false
  }
}
```

### 行の高さ

`buffer_line_height` で行間を調整できます。

- `"comfortable"` — 比率 1.618（デフォルト）
- `"standard"` — 比率 1.3
- `{ "custom": 1.5 }` — カスタム比率

## UI 要素

Zed では、次のような UI 要素を細かく制御できます。

- **タブバー** — 表示/非表示、ナビゲーションボタン、ファイルアイコン、Git ステータス
- **ステータスバー** — 言語セレクター、カーソル位置、改行コード
- **スクロールバー** — 表示/非表示、Git diff インジケーター、検索結果
- **ミニマップ** — コード全体の概観表示
- **ガター** — 行番号、折りたたみインジケーター、ブレークポイント
- **パネル** — Project Panel、Terminal、Agent Panel のサイズとドッキング

→ すべての UI 要素の設定については、[ビジュアルカスタマイズのドキュメント](./visual-customization.md) を参照してください

## 次のステップ

- [すべての設定](./reference/all-settings.md) — 設定の完全なリファレンス
- [キーバインド](./key-bindings.md) — キーボードショートカットをカスタマイズ
- [Vim モード](./vim.md) — モーダル編集を有効にする
