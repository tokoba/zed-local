# 補完

Zed は補完のソースとして次の 2 種類をサポートしています:

1. Zed が自動的にインストールする、または [Zed Language Extensions](languages.md) 経由でインストールされる Language Server (LSP) によって提供されるコード補完。
2. Zed 独自の Zeta モデル、または [GitHub Copilot](#github-copilot) のような外部プロバイダによって提供される編集予測。

## Language Server によるコード補完 {#code-completions}

適切な language server が利用可能な場合、Zed は現在のファイル内の変数名、関数、その他のシンボルの補完を提供します。これらを無効にするには、Zed の `settings.json` ファイルに次の設定を追加します:

```json [settings]
"show_completions_on_input": false
```

補完は、`ctrl-space` を押すか、コマンドパレットから `editor::ShowCompletions` アクションを実行することで手動でトリガーできます。

> 注意: Zed で `ctrl-space` を使用するには、macOS のグローバルショートカットを無効にする必要があります。
> **System Settings** > **Keyboard** > **Keyboard Shortcut**s >
> **Input Sources** を開き、**Select the previous input source** のチェックを外してください。

詳細については、次を参照してください:

- [サポートされている言語の設定](./configuring-languages.md)
- [Zed がサポートする言語の一覧](./languages.md)

## 編集予測 {#edit-predictions}

Zed には、Zed のオープンソースかつオープンデータのモデルである [Zeta](https://huggingface.co/zed-industries/zeta) を用いて、一度に複数の編集を予測するためのサポートが組み込まれています。
編集予測は入力中に表示され、多くの場合は `tab` を押すことで確定できます。

Zed の編集予測のセットアップと設定方法の詳細については、[編集予測に関するドキュメント](./ai/edit-prediction.md) を参照してください。
