# 診断

Zed は言語サーバーから診断情報を取得し、LSP の push / pull の両方の方式をサポートしているため、既存のすべての言語サーバーと互換性があります。

# 通常の診断

デフォルトでは、Zed はエディタおよびスクロールバー上で、すべての診断を下線付きのテキストとして表示します。

エディタ内の診断は、次の

```json [settings]
"diagnostics_max_severity": null
```

というエディタ設定でフィルタできます（指定可能な値: `"off"`, `"error"`, `"warning"`, `"info"`, `"hint"`, `null`（デフォルト。すべての診断））。

スクロールバーに表示される診断は、次の

```json [settings]
"scrollbar": {
  "diagnostics": "all",
}
```

という設定で構成されます（指定可能な値: `"none"`, `"error"`, `"warning"`, `"information"`, `"all"`（デフォルト））。

診断の上にポインタをホバーすると、整形済みの診断メッセージ全体を含むツールチップが表示されます。
また、`editor::GoToDiagnostic` と `editor::GoToPreviousDiagnostic` を使用して、エディタ内の診断間を移動でき、その際、現在アクティブな診断についてのポップオーバーが表示されます。

# インライン診断（Error lens）

Zed は、コードの右側にレンズとして診断を表示することをサポートしています。
これはデフォルトでは無効になっていますが、エディタメニューから一時的に有効（または無効）にすることも、次の

```json [settings]
"diagnostics": {
  "inline": {
    "enabled": true,
    "max_severity": null, // エディタ設定の `diagnostics_max_severity` と同じ値を指定します
  }
}
```

設定を使って恒久的に切り替えることもできます。

# その他の UI

## プロジェクトパネル

プロジェクトパネルでは、ファイル内の診断の重大度に基づいてエントリに色を付けることができます。

これを設定するには、次の

```json [settings]
"project_panel": {
  "show_diagnostics": "all",
}
```

という設定を使用します（指定可能な値: `"off"`, `"errors"`, `"all"`（デフォルト））。

## エディタタブ

プロジェクトパネルと同様に、エディタタブも次の

```json [settings]
"tabs": {
  "show_diagnostics": "off",
}
```

という設定で色付けできます（指定可能な値: `"off"`（デフォルト）, `"errors"`, `"all"`）。
