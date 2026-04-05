# Zed Development: Glossary

このページでは、Zed のコードベース全体で使用される用語と構造を定義します。

これは可能な限り網羅した一覧ですが、作業中のドキュメントです。

<!--
TBD: 用語集の改善

質問:

- Zed 全体のドキュメントコメントから、この一覧を自動生成できるか？
- さまざまな UI パーツとその名称を示すセクションを用意すべき。（このチャンネルではそれができない。）
-->

## Naming conventions

以下は、コードベース全体で共通して使われている命名パターンです。`Name` は、`AnyElement` や `LspStore` など、任意の型名を表す
プレースホルダーです。

- `AnyName`: 型消去された *name* のバージョン。`Box<dyn NameTrait>` のようなものです。
- `NameStore`: 操作がローカルで実行されているかリモートで実行されているかを抽象化するラッパー型。

## GPUI

### State management

- `App`: すべてのエンティティを含むアプリケーション全体の状態を保持するシングルトン。`App` は `Send` ではないので、それを作成したスレッド（通常はメイン/UI スレッド）にのみ存在します。`&mut App` が見えているときは、UI スレッド上にいます。
- `Context`: 特定の `Entity` 向けの振る舞いで `App` をラップしたもの。`(&mut App, Entity<V>)` のようなものだと考えられます。たとえば、`App::spawn` は `AsyncFnOnce(AsyncApp) -> Ret` を取り、`Context::spawn` は `AsyncFnOnce(WeakEntity<V>, AsyncApp) -> Ret` を取ります。
- `AsyncApp`: 非同期コンテキスト用の、所有型としての `App`。それでも `Send` ではないため、依然としてメインスレッド上で動作し、`App` がすでに終了している場合には操作が失敗することがあります。
  `AsyncApp` が存在するのは、`App` が通常 `&mut App` としてアクセスされるためであり、これは非同期境界をまたいで保持するには扱いづらいからです。
- `AppContext`: `App`、`AsyncApp`、`Context` およびそれらのテスト用バリアントを抽象化するトレイト。
- `Task`: バックグラウンドまたはフォアグラウンドの executor 上で実行中（または実行予定）の Future。通常の Future と異なり、Task は開始するために `.await` を必要としません。ただし、結果を読むには `.await` する必要があります。
- `Executor`: タスクをフォアグラウンドまたはバックグラウンドスレッド上で実行するために spawn するためのもの。可能な限りタスクはバックグラウンドスレッドで実行するようにしてください。
  - `BackgroundExecutor`: `Task` を実行するスレッドプール。
  - `ForegroundExecutor`: `Task` を実行するメインスレッド。
- `Entity`: gpui によって管理される構造体への、強い型付き参照。実質的には `App::EntityMap` へのポインタ/マップキーです。
- `WeakEntity`: `Entity` がすでに存在しないかもしれない場合の、実行時チェック付き参照。[`std::rc::Weak`](https://doc.rust-lang.org/std/rc/struct.Weak.html) に似ています。
- `Global`: `App` 内に 1 つだけ値を持つシングルトン型。
- `Event`: `Entity` から購読者へ送信されるデータ型。
- `Action`: リスナーによって処理される、ユーザーのキーボード入力を表すイベント。
  例: `file finder: toggle`
- `Observing`: Entity が変更されたという通知に反応すること。
- `Subscription`: アプリケーション内の状態の変化に反応するために使用されるイベントハンドラー。
  1. 発行されたイベントの処理
  2. Entity の `{new,release,on notify}` を監視すること

### UI

- `View`: `Render` の実装を通じて `Element` を生成できる `Entity`。
- `Element`: レイアウトされ、画面に描画できる型。
- `element expression`: 要素ツリーを構築する式。例:

```rust
h_flex()
    .id(text[i])
    .relative()
    .when(selected, |this| {
        this.child(
            div()
                .h_4()
                .absolute()
                etc etc
```

- `Component`: レンダーされることで `Element` に変換されるビルダー。
- `Dispatch tree`: TODO
- `Focus`: キーストロークが最初に処理される場所。
- `Focus tree`: 現在フォーカスを持っている場所から UI Root までのパス。例 <img> TODO

## Zed UI

- `Window`: デスクトップ環境における Zed ウィンドウを表す構造体（下図参照）。複数のウィンドウを同時に開くことができます。これは主にレンダリングのために受け渡されます。
- `Modal`: 残りの UI の上に浮かんで表示される UI 要素。
- `Picker`: UI（Modal）の上に浮かんで表示される項目リストを表す構造体。項目を選択して確定できます。選択時や確定時に何が起こるかは、Picker の delegate によって決まります。（下図の 'Modal' は Picker です。）
- `PickerDelegate`: `Picker` の振る舞いを特化させるために使われるトレイト。`Picker` は `PickerDelegate` をフィールド delegate に保持します。
- `Center`: Zed ウィンドウの中央部分。Center は複数の `Pane` に分割されています。コードベースでは、これは `Workspace` 構造体のフィールドになっています（下図参照）。
- `Pane`: `Center` 内で、エディタ、マルチバッファ、ターミナルなどの項目を配置できる領域（下図参照）。
- `Panel`: `Panel` トレイトを実装した `Entity`。`Panel` は `Dock` 内に配置できます。下図では、`ProjectPanel` が左ドック、`DebugPanel` が下部ドック、`AgentPanel` が右ドックにあります。`Editor` は `Panel` を実装していません。
- `Dock`: `Pane` に似た UI 要素で、開閉が可能です。同時に最大 3 つの Dock を開けます: 左、右、下。Dock には 1 つ以上の `Panel` が入り、`Pane` は入りません。

<img width="1921" height="auto" alt="Pane と Dock 機能のスクリーンショット" src="https://github.com/user-attachments/assets/2cb1170e-2850-450d-89bb-73622b5d07b2" />

- `Project`: 1 つ以上の `Worktree`。
- `Worktree`: ローカルまたはリモートのファイルを表します。

<img width="552" height="auto" alt="Worktree 機能のスクリーンショット" src="https://github.com/user-attachments/assets/da5c58e4-b02e-4038-9736-27e3509fdbfa" />

- [Multibuffer](https://zed.dev/docs/multibuffers): `Editor` の一覧。multi-buffer によって複数ファイルを同時に編集できます。Zed の操作が複数の位置を返したときに multi-buffer が開きます。例: *search* や *go to definition*。下図のプロジェクト検索を参照してください。

<img width="800" height="auto" alt="MultiBuffer 機能のスクリーンショット" src="https://github.com/user-attachments/assets/d59dcecd-8ab6-4172-8fb6-b1fc3c3eaf9d" />

## Editor

- `Editor`: テキストエディタ型。Zed のほとんどの編集可能な領域（1 行入力を含む）は `Editor` です。上図の各ペインには 1 つ以上の `Editor` インスタンスが含まれます。
- `Workspace`: ウィンドウのルート。
- `Entry`: ファイル、ディレクトリ、保留中のディレクトリ、未読み込みのディレクトリ。
- `Buffer`: 「ファイル」のインメモリ表現であり、構文木、Git ステータス、診断情報などの関連データも含みます。
- `pending selection`: マウスボタンを押したままドラッグしていて、まだボタンを離していない状態。

## Collab

- `Collab session`: 共有された `Project` 上で複数のユーザーが作業している状態。
- `Upstream client`: 自分のワークスペースを共有している Zed クライアント。
- `Downstream client`: 共有されたワークスペースに参加している Zed クライアント。

## Debugger

- `DapStore`: デバッガセッションを管理する Entity。
- `debugger::Session`: デバッグセッションのライフサイクルと DAP との通信を管理する Entity。
- `BreakpointStore`: Zed のローカルおよびリモートインスタンスにおけるブレークポイントの状態を管理する Entity。
- `DebugSession`: デバッグセッションの UI と実行状態を管理する。
- `RunningState`: デバッグセッションのすべての View を直接管理する。
- `VariableList`: デバッグセッションの変数およびウォッチリストの View。
- `Console`: TODO
- `Terminal`: TODO
- `BreakpointList`: TODO
