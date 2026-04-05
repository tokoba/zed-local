# 設定

Zed における AI の利用について、複数の側面を設定できます:

1. 使用する LLM プロバイダ
   - Zed がホストするモデル（[認証](../authentication.md)と[サブスクリプション](./subscription.md)が必要です）
   - [独自の API キーを使用する](./llm-providers.md)方法（上記は不要です）
   - [Claude Agent などの外部エージェント](./external-agents.md)を使用する方法（これも上記は不要です）
2. [モデルパラメーターと使用方法](./agent-settings.md#model-settings)
3. [Agent パネルとのやり取り](./agent-settings.md#agent-panel-settings)

## AI を完全に無効化する

すべての AI 機能を無効にするには、設定ファイル（[編集方法](../configuring-zed.md#settings-files)）に次を追加します:

```json [settings]
{
  "disable_ai": true
}
```

このオプションの詳細については、[このブログ記事](https://zed.dev/blog/disable-ai-features)を参照してください。
