# GDScript

Godot の [GDScript](https://gdscript.com/) 言語サポートは、コミュニティがメンテナンスしている [GDScript extension](https://github.com/GDQuest/zed-gdscript) によって Zed で提供されています。
不具合の報告先: <https://github.com/GDQuest/zed-gdscript/issues>

- Tree-sitter: [PrestonKnopp/tree-sitter-gdscript](https://github.com/PrestonKnopp/tree-sitter-gdscript) および [PrestonKnopp/tree-sitter-godot-resource](https://github.com/PrestonKnopp/tree-sitter-godot-resource)
- Language Server: [gdscript-language-server](https://github.com/godotengine/godot)

## Pre-requisites

以下が必要です:

- [Godot](https://godotengine.org/download/)
- システムの PATH に設定された netcat (`nc` または `ncat`)

## Setup

1. Godot エディタ内で Editor Settings を開き、`Text Editor -> External` を探して次のオプションを設定します:
   - Exec Path: `/path/to/zed`
   - Exec Flags: `{project} {file}:{line}:{col}`
   - Use External Editor: "✅ On"
2. Godot 経由で任意の \*.gd ファイルを開くと、Zed が起動します。

## Usage

Godot が実行中のとき、GDScript extension は Godot ランタイムが提供する language server に接続し、`jump to definition`、Ctrl/cmd を押したときのホバー状態など、その他の language server 機能を提供します。
