# Biome

[Biome](https://biomejs.dev/) の Zed でのサポートは、コミュニティによってメンテナンスされている [Biome extension](https://github.com/biomejs/biome-zed) によって提供されています。
不具合の報告先: <https://github.com/biomejs/biome-zed/issues>

- 言語サーバー: [biomejs/biome](https://github.com/biomejs/biome)

## Biome 言語サポート

Biome extension には、次の言語のサポートが含まれています:

- JavaScript
- TypeScript
- JSX
- TSX
- JSON
- JSONC
- Vue.js
- Astro
- Svelte
- CSS

## 設定

デフォルトでは、`biome.json` ファイルはワークスペースのルートに配置されている必要があります。

```json
{
  "$schema": "https://biomejs.dev/schemas/1.8.3/schema.json"
}
```

利用可能な `biome.json` オプションの全一覧については、[Biome Configuration](https://biomejs.dev/reference/configuration/) ドキュメントを参照してください。

機能と設定オプションの完全な一覧については、[Biome Zed Extension README](https://github.com/biomejs/biome-zed) を参照してください。
