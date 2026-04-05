1. ざっくり一言

----------------

`toolchain_selector` クレートは、Zed のようなエディタ内で、

- 「今開いているファイル」に対応する言語のツールチェーン（コンパイラ・仮想環境など）を自動的に検出・保存し、
- ステータスバーとモーダルダイアログ（ピッカー UI）から、ユーザーがそのツールチェーンを**選択・追加・削除**できるようにする

ための UI コンポーネント群を提供するモジュールです。

---

2. このモジュールの役割

-----------------------

### 2.1 概要

このディレクトリ（クレート）は、主に次の 2 つの役割を持つコンポーネントで構成されています。

- **ActiveToolchain**  
  ステータスバー（`StatusItemView`）に現在のツールチェーン名を表示し、クリックでツールチェイン選択モーダルを開くコンポーネントです。  
  ファイルの言語やパスに応じて、適切なツールチェーンを自動で決定し、必要ならデフォルトを保存します。

- **ToolchainSelector**  
  モーダルとして表示される「ツールチェーン選択・追加 UI」です。  
  既存ツールチェーンの fuzzy 検索、スコープ付きツールチェーンの追加（Global / Project / Subproject）、ユーザー定義ツールチェーンの削除を行います。

### 2.2 アーキテクチャ内での位置づけ

コードから読み取れる主なコンポーネント間の関係を示します。

```mermaid
graph TD
    WS[Workspace] -->|project()| PR[Project]
    WS -->|ステータスバー| AT[ActiveToolchain]
    WS -->|モーダル| TS[ToolchainSelector]

    AT -->|クリックで開く| TS
    TS -->|検索 UI| DELEG[ToolchainSelectorDelegate]
    TS -->|追加フロー| ADD[AddToolchainState]

    DELEG -->|候補取得/保存| PR
    DELEG -->|永続化| DB[WorkspaceDb]

    ADD -->|パス選択| PATH[OpenPathDelegate<br/>+ DirectoryLister]
    ADD -->|toolchain 追加| PR
```

- `Workspace`  
  - 現在の `Project` を保持し、モーダル（`ToolchainSelector`）やステータスバー項目（`ActiveToolchain`）を所有します。
  - `ToolchainSelector::register` によって、`Select` / `AddToolchain` アクションが登録されます。

- `Project`  
  - 言語・ツールチェーンに関するビジネスロジックを提供します。  
    利用されているメソッド（定義はこのチャンク外）としては:
    - `active_toolchain`
    - `available_toolchains`
    - `add_toolchain`
    - `remove_toolchain`
    - `resolve_toolchain`
    - `toolchain_metadata`
    - `find_project_path`

- `WorkspaceDb::global`  
  - `set_toolchain` により、「ワークスペース + パス」に対するツールチェーン選択を永続化します。

- `ActiveToolchain`  
  - `Buffer` の言語・パス変更、および `ToolchainStoreEvent` を監視し、適切なツールチェーンを自動決定して表示します。
  - クリックで `ToolchainSelector::toggle` を呼び、モーダルを開きます。

- `ToolchainSelector`  
  - モーダル本体。`Picker<ToolchainSelectorDelegate>` を使って候補を表示し、`AddToolchainState` による追加フローへ遷移します。

- `ToolchainSelectorDelegate`  
  - ピッカーの delegate として、候補の取得・fuzzy マッチング・選択確定時の `Project` / `WorkspaceDb` 更新を担当します。

- `AddToolchainState`  
  - ツールチェーン追加フローの内部状態を表し、  
    1. パス選択 (`AddState::Path`)  
    2. 名前とスコープ入力 (`AddState::Name`)  
    の 2 段階 UI を実装します。

### 2.3 設計上のポイント

コードから読み取れる特徴的な設計方針を箇条書きにします。

- **非同期処理と UI の分離**
  - `cx.spawn_in` / `cx.spawn` を多用し、ツールチェーンの検出・メタデータ取得・永続化などをバックグラウンドで実行します。
  - それぞれの非同期タスクの `Task` ハンドルを構造体フィールド（例: `_update_toolchain_task`, `PathInputState::*`) に保持し、「最後まで走る」ことを保証しています。

- **`WeakEntity` による疎結合**
  - `Workspace` や `ToolchainSelector` を `WeakEntity` で保持し、  
    参照先が破棄されていた場合には `update` / `read_with` が `Err` を返して静かに中断するようになっています。
  - これにより、UI コンポーネント間の循環参照を避けています。

- **パスとスコープに基づくツールチェーン選択**
  - ツールチェーンの有効範囲は `ToolchainScope`（Global / Project / Subproject）で表現され、  
    `ProjectPath { worktree_id, path }` 単位で選択・検出が行われます。
  - デフォルト候補選択では、**Global スコープのユーザー定義ツールチェーンを優先度低めに扱う**（無視して、それ以外を優先）実装になっています。

- **fuzzy 検索による候補絞り込み**
  - `fuzzy::match_strings` を使い、`name + 相対パス` の文字列に対して fuzzy 検索を行っています。
  - ハイライト位置情報を `HighlightedLabel` に渡して UI で強調表示しています。

- **エディタの状態に追従するステータス表示**
  - `ActiveToolchain` は現在アクティブな `Editor` の `Buffer` に対して、
    - 言語変更 (`BufferEvent::LanguageChanged`)
    - アクティブペイン変更 (`StatusItemView::set_active_pane_item`)
    を検知し、必要に応じて「現在のツールチェーン」を再計算します。

---

3. 主要な機能一覧

-----------------

このクレートが提供する主な機能を列挙します。

- **ステータスバーへの現在ツールチェーン表示**
  - `ActiveToolchain` が、アクティブなファイルに対して選択済み or 推奨のツールチェーン名を表示します。

- **ツールチェーン選択モーダルの表示**
  - ステータスバーのボタンや `Select` アクションを通じて、`ToolchainSelector` モーダルを開閉します。

- **ツールチェーン候補の fuzzy 検索**
  - 現在の言語 + パスに対して利用可能なツールチェーン候補を一覧し、検索クエリに応じて fuzzy マッチングで絞り込みます。

- **ツールチェーンの選択・永続化**
  - ユーザーが候補を選択すると、`WorkspaceDb::set_toolchain` と `Project::activate_toolchain` を通じて、
    - ワークスペース DB に選択内容が永続化され、
    - プロジェクトにもアクティブなツールチェーンとして反映されます。

- **ツールチェーンの追加フロー**
  - `AddToolchain` アクション、またはモーダルフッターの「Add …」ボタンから、
    1. パス選択（OpenPathPrompt）
    2. 解決（`Project::resolve_toolchain`）
    3. 名前編集 + スコープ選択
    を行い、`Project::add_toolchain` によってユーザー定義ツールチェーンを追加します。

- **ユーザー定義ツールチェーンの削除**
  - ピッカーの各行末尾に表示される Trash アイコンから、
    `Project::remove_toolchain` を呼び出し、ユーザー定義ツールチェーンを削除できます。

- **ツールチェーン用語（term）の言語別カスタマイズ**
  - `Project::toolchain_metadata` から取得した `meta.term` を利用し、
    - ステータスバー上のラベル（例: “Toolchain”, “Virtual Environment”）
    - モーダルのプレースホルダやボタンラベル（“Add …”）
    を言語ごとに出し分けています。

---

4. 関数・構造体の解説

---------------------

### 4.1 型一覧（主要な構造体・列挙体）

| 名前 | 種別 | 公開範囲 | 役割 / 用途 |
|------|------|----------|-------------|
| `ToolchainSelector` | 構造体 | `pub` | ツールチェーンを選択・追加するモーダルビュー本体です。現在の状態 `State` を保持します。 |
| `ActiveToolchain` | 構造体 | `pub`（`pub use`） | ステータスバー項目として現在のツールチェーンを表示し、クリックで `ToolchainSelector` を開きます。 |
| `SearchState` | 構造体 | モジュール内 | 検索中状態で使う `Picker<ToolchainSelectorDelegate>` のラッパーです。 |
| `AddToolchainState` | 構造体 | モジュール内 | ツールチェーン追加フロー（パス選択→名前・スコープ入力）の UI と状態を保持します。 |
| `ScopePickerState` | 構造体 | モジュール内 | スコープ選択 UI に必要な `NavigableEntry` と現在選択されている `ToolchainScope` を保持します。 |
| `PathInputState` | 列挙体 | モジュール内 | パス入力の非同期状態（`WaitingForPath` / `Resolving`）を表します。 |
| `AddState` | 列挙体 | モジュール内 | `AddToolchainState` のサブ状態（`Path` / `Name`）を表します。 |
| `State` | 列挙体 | モジュール内 | `ToolchainSelector` 全体の状態（`Search` / `AddToolchain`）を表します。 |
| `ToolchainSelectorDelegate` | 構造体 | モジュール内 | `PickerDelegate` 実装。候補一覧の取得、fuzzy マッチング、選択確定時の処理を担当します。 |

> 補足: `actions!` マクロにより `Select` / `AddToolchain` アクション型も定義されていますが、マクロ展開後の正確な型名はこのチャンクからは確認できません。

---

### 4.2 重要な関数・メソッドの詳細

ここでは、外部からの利用や理解の入口になりやすい代表的な 7 個の関数・メソッドを解説します。

#### 4.2.1 `pub fn init(cx: &mut App)`

```rust
pub fn init(cx: &mut App) {
    cx.observe_new(ToolchainSelector::register).detach();
}
```

**概要**

- アプリケーション全体の初期化時に呼び出される想定の関数です。
- 新しく作成される `Workspace` ごとに `ToolchainSelector::register` を呼び、  
  `Select` / `AddToolchain` アクションを登録します。

**引数**

| 引数名 | 型 | 説明 |
|--------|----|------|
| `cx` | `&mut App` | アプリケーション全体の gpui コンテキスト。新規 `Workspace` 監視の設定に使われます。 |

**戻り値**

- なし（`()`）。副作用として、`Workspace` 作成時のオブザーバが登録されます。

**内部処理の流れ**

1. `cx.observe_new(ToolchainSelector::register)`  
   - 新しく生成される `Workspace` エンティティを監視し、  
     各 `Workspace` に対して `ToolchainSelector::register` を呼ぶオブザーバを作成します。
2. `.detach()` により、返り値のタスクを保持しないまま「走らせっぱなし」にします。

**使用例**

アプリケーションの初期化コードから呼び出す想定の例です。

```rust
use gpui::App;
use toolchain_selector::init as init_toolchain_selector;

fn main() {
    App::new(|app| {
        // ツールチェーン選択機能を Workspace に統合する
        init_toolchain_selector(app); // 各 Workspace で Select / AddToolchain が使えるようになる

        // ここで他の機能も同様に初期化する …
    });
}
```

**使用上の注意点**

- `init` は一度呼べば十分な設計であり、複数回呼んでも実害はないと考えられますが、  
  そのような使用方法はコードからは確認できないため、基本的にはアプリの起動時に 1 回だけ呼び出す前提で設計されているように見えます。

---

#### 4.2.2 `fn register(workspace: &mut Workspace, _window: Option<&mut Window>, _: &mut Context<Workspace>)`

```rust
impl ToolchainSelector {
    fn register(
        workspace: &mut Workspace,
        _window: Option<&mut Window>,
        _: &mut Context<Workspace>,
    ) {
        workspace.register_action(move |workspace, _: &Select, window, cx| {
            Self::toggle(workspace, window, cx);
        });
        workspace.register_action(move |workspace, _: &AddToolchain, window, cx| {
            let Some(toolchain_selector) = workspace.active_modal::<Self>(cx) else {
                Self::toggle(workspace, window, cx);
                return;
            };

            toolchain_selector.update(cx, |toolchain_selector, cx| {
                toolchain_selector.handle_add_toolchain(&AddToolchain, window, cx);
            });
        });
    }
}
```

**概要**

- 各 `Workspace` に対して、
  - ツールチェーン選択モーダルを開く `Select` アクション
  - 追加フローへ遷移する `AddToolchain` アクション
  を登録します。

**引数**

| 引数名 | 型 | 説明 |
|--------|----|------|
| `workspace` | `&mut Workspace` | アクションを登録する対象のワークスペース。 |
| `_window` | `Option<&mut Window>` | 呼び出し時点のウィンドウ。ここでは未使用です。 |
| `_` | `&mut Context<Workspace>` | `Workspace` 用コンテキスト。ここでは未使用です。 |

**戻り値**

- なし。`Workspace` に対してアクションが登録されます。

**内部処理の流れ**

1. `Select` アクションの登録:
   - 発火時に `ToolchainSelector::toggle` を呼び、モーダルを開閉します。
2. `AddToolchain` アクションの登録:
   - すでに `ToolchainSelector` モーダルが開いていれば、そのインスタンスを取得し `handle_add_toolchain` を呼びます。
   - 開いていなければ、まず `toggle` でモーダルを開き、その後ユーザー操作によって `AddToolchain` が効くようになります。

**使用例**

`init` からのみ呼ばれる内部関数であり、外部から直接呼び出す場面は想定されていません。  
使用例としては `init` の例（4.2.1）を参照してください。

**エッジケース**

- `workspace.active_modal::<Self>(cx)` が `None` の場合（モーダルが開いていない場合）、`AddToolchain` アクションはモーダルを開くだけで、即座には追加状態へは遷移しません。

---

#### 4.2.3 `fn toggle(workspace: &mut Workspace, window: &mut Window, cx: &mut Context<Workspace>) -> Option<()>`

```rust
fn toggle(
    workspace: &mut Workspace,
    window: &mut Window,
    cx: &mut Context<Workspace>,
) -> Option<()> {
    let buffer = workspace
        .active_item(cx)?
        .act_as::<Editor>(cx)?
        .read(cx)
        .active_buffer(cx)?;
    let project = workspace.project().clone();

    let language_name = buffer.read(cx).language()?.name();
    let worktree_id = buffer.read(cx).file()?.worktree_id(cx);
    let relative_path: Arc<RelPath> = buffer.read(cx).file()?.path().parent()?.into();
    let worktree_root_path = project
        .read(cx)
        .worktree_for_id(worktree_id, cx)?
        .read(cx)
        .abs_path();
    let weak = workspace.weak_handle();
    cx.spawn_in(window, async move |workspace, cx| {
        let active_toolchain = project
            .read_with(cx, |this, cx| {
                this.active_toolchain(
                    ProjectPath {
                        worktree_id,
                        path: relative_path.clone(),
                    },
                    language_name.clone(),
                    cx,
                )
            })
            .await;
        workspace
            .update_in(cx, |this, window, cx| {
                this.toggle_modal(window, cx, move |window, cx| {
                    ToolchainSelector::new(
                        weak,
                        project,
                        active_toolchain,
                        worktree_id,
                        worktree_root_path,
                        relative_path,
                        language_name,
                        window,
                        cx,
                    )
                });
            })
            .ok();
        anyhow::Ok(())
    })
    .detach();

    Some(())
}
```

**概要**

- 現在アクティブな `Editor` / `Buffer` の情報（言語名・ワークツリー ID・相対パス）からモーダルの初期状態を決定し、  
  `ToolchainSelector` モーダルを開閉します。

**引数**

| 引数名 | 型 | 説明 |
|--------|----|------|
| `workspace` | `&mut Workspace` | アクティブアイテムを取得し、モーダルを開閉する対象ワークスペース。 |
| `window` | `&mut Window` | モーダルを紐付けるウィンドウ。非同期タスクのスコープにも使われます。 |
| `cx` | `&mut Context<Workspace>` | `Workspace` 向けの UI コンテキスト。 |

**戻り値**

- `Option<()>`  
  - `Some(())` … アクティブな `Editor` / `Buffer` が見つかり、非同期にモーダルの開閉処理が開始された場合。
  - `None` … アクティブな編集対象がなく、モーダルを表示できない場合（`?` 演算子でどこかが `None` になった場合）。

**内部処理の流れ**

1. 現在アクティブな `ItemHandle` を `Editor` としてダウンキャストし、そのアクティブ `Buffer` を取得。
2. `Buffer` から:
   - 言語名 (`language_name`)
   - ファイルの `worktree_id`
   - 親ディレクトリの相対パス (`relative_path`)
   を取得。
3. `Project` から `worktree_root_path`（絶対パス）を取得。
4. `cx.spawn_in(window, async move { ... })` で非同期タスクを開始し、以下を実行：
   1. `Project::active_toolchain` を呼んで、現在設定されているツールチェーン（あれば）を取得。
   2. `workspace.toggle_modal` を呼び、`ToolchainSelector::new` でモーダルを生成 or 閉じます。
5. 非同期タスクの `Task` は `.detach()` で保持せず、`Some(())` を返して終了します。

**使用例**

`Workspace` を直接扱えるコードから、明示的にツールチェーン選択モーダルを開きたい場合の例です。

```rust
use workspace::Workspace;
use toolchain_selector::ToolchainSelector;

// 何らかの Workspace ハンドラ内のコード例
fn open_toolchain_selector(
    workspace: &mut Workspace,  // アクティブな Workspace
    window: &mut gpui::Window,  // 対象ウィンドウ
    cx: &mut gpui::Context<Workspace>, // Workspace コンテキスト
) {
    // アクティブな Editor / Buffer が存在する場合にのみモーダルが開く
    if ToolchainSelector::toggle(workspace, window, cx).is_none() {
        // ここに「アクティブなファイルがない」場合のフォールバック処理を書くことができます
    }
}
```

**エッジケース**

- アクティブな `Editor` / `Buffer` や `language()` / `file()` が取得できない場合は、何もせず `None` を返します。
- 非同期タスク内で `Project::active_toolchain` が失敗した場合のエラー処理は、このチャンクでは `anyhow::Ok(())` で無視されています。

**使用上の注意点**

- ユーザーから見ると「すぐにモーダルが開く」挙動ですが、実際は非同期タスクを介しており、ツールチェーン情報取得に時間がかかる場合があります。
- 呼び出し元で `Option<()>` が `None` の場合、UI 上は何も起こらないため、必要ならログやメッセージで補完する必要があります（このチャンクにはその処理はありません）。

---

#### 4.2.4 `fn new(...) -> Self` （`ToolchainSelector` のコンストラクタ）

```rust
fn new(
    workspace: WeakEntity<Workspace>,
    project: Entity<Project>,
    active_toolchain: Option<Toolchain>,
    worktree_id: WorktreeId,
    worktree_root: Arc<Path>,
    relative_path: Arc<RelPath>,
    language_name: LanguageName,
    window: &mut Window,
    cx: &mut Context<Self>,
) -> Self {
    let language_registry = project.read(cx).languages().clone();
    cx.spawn({
        let language_name = language_name.clone();
        async move |this, cx| {
            let language = language_registry
                .language_for_name(&language_name.0)
                .await
                .ok();
            this.update(cx, |this, cx| {
                this.language = language;
                cx.notify();
            })
            .ok();
        }
    })
    .detach();
    let project_clone = project.clone();
    let language_name_clone = language_name.clone();
    let relative_path_clone = relative_path.clone();

    let create_search_state = Arc::new(move |window: &mut Window, cx: &mut Context<Self>| {
        let toolchain_selector = cx.entity().downgrade();
        let picker = cx.new(|cx| {
            let delegate = ToolchainSelectorDelegate::new(
                active_toolchain.clone(),
                toolchain_selector,
                workspace.clone(),
                worktree_id,
                worktree_root.clone(),
                project_clone.clone(),
                relative_path_clone.clone(),
                language_name_clone.clone(),
                window,
                cx,
            );
            Picker::uniform_list(delegate, window, cx)
        });
        let picker_focus_handle = picker.focus_handle(cx);
        picker.update(cx, |picker, _| {
            picker.delegate.focus_handle = picker_focus_handle.clone();
        });
        SearchState { picker }
    });

    Self {
        state: State::Search(create_search_state(window, cx)),
        create_search_state,
        language: None,
        project,
        language_name,
        worktree_id,
        relative_path,
    }
}
```

**概要**

- `ToolchainSelector` モーダルの初期状態を構築するコンストラクタです。
- 言語情報の非同期読み込みと、`Picker<ToolchainSelectorDelegate>` を使った検索状態の初期化を行います。

**引数（主なもの）**

| 引数名 | 型 | 説明 |
|--------|----|------|
| `workspace` | `WeakEntity<Workspace>` | モーダルを所有するワークスペースへの弱参照。 |
| `project` | `Entity<Project>` | ツールチェーン情報を取得・更新する対象プロジェクト。 |
| `active_toolchain` | `Option<Toolchain>` | 現在選択済みのツールチェーン（あれば）。初期選択に使われます。 |
| `worktree_id` | `WorktreeId` | 現在のファイルが属するワークツリー ID。 |
| `worktree_root` | `Arc<Path>` | ワークツリーのルートディレクトリの絶対パス。 |
| `relative_path` | `Arc<RelPath>` | `worktree_root` からの相対パス（ディレクトリ単位）。 |
| `language_name` | `LanguageName` | 対象ファイルの言語名。 |
| `window` | `&mut Window` | UI 要素の生成に使われるウィンドウ。 |
| `cx` | `&mut Context<Self>` | `ToolchainSelector` 自身のコンテキスト。 |

**戻り値**

- 初期化済みの `ToolchainSelector` インスタンス。

**内部処理の流れ**

1. `language_registry.language_for_name` をバックグラウンドで呼び、言語情報を `self.language` に格納（非同期）。
2. `create_search_state` クロージャを作成し、
   - `ToolchainSelectorDelegate::new` で delegate を生成
   - `Picker::uniform_list` でピッカーを作成
   - delegate にフォーカスハンドルを設定
   する処理をカプセル化。
3. `state` を `State::Search(create_search_state(window, cx))` で初期化し、それ以外のフィールドも設定します。

**使用例**

外部から直接呼ぶよりは、`ToolchainSelector::toggle` 内でのみ使われるコンストラクタです。  
そのため、使用例としては `toggle` のコードがそのまま参考になります（4.2.3 参照）。

**使用上の注意点**

- `create_search_state` は `Arc<dyn Fn>` として保持され、追加フローから検索画面に戻るときにも再利用されます。
- `active_toolchain` をクローンしてクロージャにキャプチャしているため、  
  非同期の候補取得完了後に、現在の候補一覧から「元々アクティブだったツールチェーン」を選択状態に戻すことができます。

---

#### 4.2.5 `fn new(...) -> anyhow::Result<Entity<Self>>` （`AddToolchainState` のコンストラクタ）

```rust
impl AddToolchainState {
    fn new(
        project: Entity<Project>,
        language_name: LanguageName,
        root_path: ProjectPath,
        window: &mut Window,
        cx: &mut Context<ToolchainSelector>,
    ) -> anyhow::Result<Entity<Self>> {
        let weak = cx.weak_entity();
        let worktree_root_path = project
            .read(cx)
            .worktree_for_id(root_path.worktree_id, cx)
            .map(|worktree| worktree.read(cx).abs_path())
            .context("Could not find worktree")?;
        Ok(cx.new(|cx| {
            let (lister, rx) = Self::create_path_browser_delegate(project.clone(), cx);
            let path_style = project.read(cx).path_style(cx);
            let picker = cx.new(|cx| {
                let picker = Picker::uniform_list(lister, window, cx);
                let mut worktree_root = worktree_root_path.to_string_lossy().into_owned();
                worktree_root.push_str(path_style.primary_separator());
                picker.set_query(&worktree_root, window, cx);
                picker
            });

            Self {
                state: AddState::Path {
                    _subscription: cx.subscribe(&picker, |_, _, _: &DismissEvent, cx| {
                        cx.stop_propagation();
                    }),
                    picker,
                    error: None,
                    input_state: Self::wait_for_path(rx, window, cx),
                },
                project,
                language_name,
                root_path,
                weak,
                worktree_root_path,
            }
        }))
    }
}
```

**概要**

- ユーザーによるツールチェーン追加フローを開始するための状態 (`AddToolchainState`) を生成します。
- 最初の状態は「パス選択 (`AddState::Path`)」で、OpenPathPrompt を介してツールチェーンのパスを選ばせます。

**引数**

| 引数名 | 型 | 説明 |
|--------|----|------|
| `project` | `Entity<Project>` | ツールチェーン解決・追加を行う対象プロジェクト。 |
| `language_name` | `LanguageName` | 対象言語。`resolve_toolchain` に渡されます。 |
| `root_path` | `ProjectPath` | ツールチェーンを適用するパス（スコープ判定にも使われる）。 |
| `window` | `&mut Window` | ピッカー UI の生成先。 |
| `cx` | `&mut Context<ToolchainSelector>` | 親である `ToolchainSelector` のコンテキスト。 |

**戻り値**

- `Ok(Entity<AddToolchainState>)` … 正常に状態を生成できた場合。
- `Err` … `worktree_for_id` が見つからないなど、ワークツリー情報の取得に失敗した場合。

**内部処理の流れ**

1. `project.worktree_for_id` から `worktree_root_path`（絶対パス）を取得し、失敗したら `Err` を返します。
2. `cx.new` で `AddToolchainState` エンティティを生成:
   1. `create_path_browser_delegate` で `OpenPathDelegate` と `oneshot::Receiver` を作成。
   2. `Picker::uniform_list` でパス選択用ピッカーを生成し、初期クエリとして `"{worktree_root}{セパレータ}"` をセット（ワークツリールートを指す文字列）。
   3. `AddState::Path` を初期状態とし、
      - DismissEvent を `stop_propagation` するサブスクリプションを登録（内側ピッカーの閉じる操作が外側モーダルに伝播しないようにする）。
      - `wait_for_path` でパス選択結果を待つ `PathInputState::WaitingForPath` をセットします。

**使用例**

このコンストラクタは、`ToolchainSelector::handle_add_toolchain` 内でのみ呼び出されています。

```rust
// ToolchainSelector 内
fn handle_add_toolchain(
    &mut self,
    _: &AddToolchain,
    window: &mut Window,
    cx: &mut Context<Self>,
) {
    if matches!(self.state, State::Search(_)) {
        let Ok(state) = AddToolchainState::new(
            self.project.clone(),
            self.language_name.clone(),
            ProjectPath {
                worktree_id: self.worktree_id,
                path: self.relative_path.clone(),
            },
            window,
            cx,
        ) else {
            return; // 追加フロー開始に失敗した場合は何もしない
        };
        self.state = State::AddToolchain(state);
        self.state.focus_handle(cx).focus(window, cx);
        cx.notify();
    }
}
```

**使用上の注意点**

- `AddToolchainState::new` が `Err` を返した場合、呼び出し側 (`ToolchainSelector::handle_add_toolchain`) は何も表示しません。  
  エラーのログなどはこのチャンクには含まれていません。
- パス選択の UI は `OpenPathDelegate` / `DirectoryLister::Project` に依存しており、プロジェクト外のパスも選択可能です（その場合は `ToolchainScope::Global` として扱われます）。

---

#### 4.2.6 `fn confirm_toolchain(&mut self, _: &menu::Confirm, window: &mut Window, cx: &mut Context<Self>)`

```rust
fn confirm_toolchain(
    &mut self,
    _: &menu::Confirm,
    window: &mut Window,
    cx: &mut Context<Self>,
) {
    let AddState::Name {
        toolchain,
        editor,
        scope_picker,
    } = &mut self.state
    else {
        return;
    };

    let text = editor.read(cx).text(cx);
    if text.is_empty() {
        return;
    }

    toolchain.name = SharedString::from(text);
    self.project.update(cx, |this, cx| {
        this.add_toolchain(toolchain.clone(), scope_picker.selected_scope.clone(), cx);
    });
    _ = self.weak.update(cx, |this, cx| {
        this.state = State::Search((this.create_search_state)(window, cx));
        this.focus_handle(cx).focus(window, cx);
        cx.notify();
    });
}
```

**概要**

- 追加フローの「名前とスコープ入力」画面で、ユーザーが `Confirm`（Enter / ボタン）したときに呼ばれるコールバックです。
- 入力された名前と選択されたスコープを使って、`Project::add_toolchain` を呼び、  
  その後 `ToolchainSelector` を検索画面 (`State::Search`) に戻します。

**引数**

| 引数名 | 型 | 説明 |
|--------|----|------|
| `_` | `&menu::Confirm` | Confirm アクション。実際には中身は参照していません。 |
| `window` | `&mut Window` | フォーカス制御に使用。 |
| `cx` | `&mut Context<Self>` | `AddToolchainState` のコンテキスト。 |

**戻り値**

- なし。

**内部処理の流れ**

1. 現在の状態が `AddState::Name` でなければ何もせずに終了。
2. `editor.read(cx).text(cx)` でユーザーが入力した名前を取得。
   - 文字列が空なら何もせずに終了。
3. `toolchain.name` をユーザー入力で上書き。
4. `project.update(... add_toolchain ...)` を呼び、選択された `ToolchainScope` でツールチェーンを登録。
5. 親 `ToolchainSelector` を `weak` 経由で更新し、
   - 状態を `State::Search` に戻し（`create_search_state` で新規生成）
   - フォーカスを適切な UI に移動
   - `cx.notify()` で再描画をトリガします。

**使用例**

このメソッドは UI イベントハンドラとして内部からのみ呼ばれ、  
`AddToolchainState::render` 内で次のようにバインドされています。

```rust
.on_action(cx.listener(Self::confirm_toolchain))
// および
Button::new("add-toolchain", label)
    .key_binding(KeyBinding::for_action_in(&menu::Confirm, &handle, cx))
    .on_click(cx.listener(|this, _, window, cx| {
        this.confirm_toolchain(&menu::Confirm, window, cx);
    }))
```

**エッジケース**

- 名前が空のまま Confirm された場合は、`add_toolchain` は呼ばれません（UI もボタン disabled にしているので通常は起こりません）。
- `self.weak.update` が失敗した場合（親 `ToolchainSelector` が既に破棄されている場合）は、検索画面への復帰処理は行われませんが、その際のエラーは無視されています。

---

#### 4.2.7 `pub fn new(workspace: &Workspace, window: &mut Window, cx: &mut Context<Self>) -> Self` （`ActiveToolchain`）

```rust
impl ActiveToolchain {
    pub fn new(workspace: &Workspace, window: &mut Window, cx: &mut Context<Self>) -> Self {
        if let Some(store) = workspace.project().read(cx).toolchain_store() {
            cx.subscribe_in(
                &store,
                window,
                |this, _, _: &ToolchainStoreEvent, window, cx| {
                    let editor = this
                        .workspace
                        .update(cx, |workspace, cx| {
                            workspace
                                .active_item(cx)
                                .and_then(|item| item.downcast::<Editor>())
                        })
                        .ok()
                        .flatten();
                    if let Some(editor) = editor {
                        this.update_lister(editor, window, cx);
                    }
                },
            )
            .detach();
        }
        Self {
            active_toolchain: None,
            active_buffer: None,
            term: SharedString::new_static("Toolchain"),
            workspace: workspace.weak_handle(),

            _update_toolchain_task: Self::spawn_tracker_task(window, cx),
        }
    }
}
```

**概要**

- ステータスバー項目として使う `ActiveToolchain` を初期化します。
- プロジェクトの `toolchain_store` が存在すれば、その更新イベントにサブスクライブし、  
  ツールチェーン変更時にステータス表示を自動更新できるようにします。

**引数**

| 引数名 | 型 | 説明 |
|--------|----|------|
| `workspace` | `&Workspace` | このステータス項目が属するワークスペース。 |
| `window` | `&mut Window` | サブスクリプションや非同期タスクを紐付けるウィンドウ。 |
| `cx` | `&mut Context<Self>` | `ActiveToolchain` 自身のコンテキスト。 |

**戻り値**

- 初期化された `ActiveToolchain` インスタンス。

**内部処理の流れ**

1. `workspace.project().read(cx).toolchain_store()` を呼び、ツールチェーンストアが存在する場合のみ以下を実行:
   - `cx.subscribe_in(&store, window, |this, _, _: &ToolchainStoreEvent, window, cx| { ... })`
   - コールバックでは:
     1. `Workspace` のアクティブアイテムを `Editor` にダウンキャスト。
     2. `update_lister(editor, window, cx)` を呼び、アクティブバッファとサブスクリプションを更新。
2. フィールド初期化:
   - `active_toolchain: None`（まだツールチェーン未決定）
   - `term: "Toolchain"`（後で `toolchain_metadata` から上書きされる）
   - `workspace: workspace.weak_handle()`（弱参照）
   - `_update_toolchain_task: Self::spawn_tracker_task(window, cx)`  
     → 言語・パス・ツールチェーンメタデータを非同期に取得し、`active_toolchain` をセットするタスクを開始。

**エッジケース**

- `toolchain_store()` が `None` の場合、ストア更新イベントへのサブスクライブは行われませんが、  
  `spawn_tracker_task` による初期ツールチェイン決定は行われます。
- アクティブな `Editor` / `Buffer` が存在しない場合には、`spawn_tracker_task` 内で `did_set_toolchain` が `false` となり、`active_toolchain` は `None` のままです（レンダリング時には非表示になります）。

**使用上の注意点**

- `ActiveToolchain` は `StatusItemView` を実装しており、ワークスペースのステータスバー登録機構から生成される前提ですが、  
  その登録コードはこのチャンクには含まれていません。
- コンストラクタで `spawn_tracker_task` を即座に実行しているため、インスタンス生成直後に表示を更新するコストが発生します。  
  高頻度に生成・破棄する用途ではなく、「ワークスペースに 1 つ常駐させる」用途を想定した実装になっています。

---

#### 4.2.8 `fn active_toolchain(...) -> Task<Option<Toolchain>>` （`ActiveToolchain` の内部補助）

```rust
fn active_toolchain(
    workspace: WeakEntity<Workspace>,
    worktree_id: WorktreeId,
    relative_path: Arc<RelPath>,
    language_name: LanguageName,
    cx: &mut AsyncWindowContext,
) -> Task<Option<Toolchain>> {
    cx.spawn(async move |cx| {
        let workspace_id = workspace
            .read_with(cx, |this, _| this.database_id())
            .ok()
            .flatten()?;
        let selected_toolchain = workspace
            .update(cx, |this, cx| {
                this.project().read(cx).active_toolchain(
                    ProjectPath {
                        worktree_id,
                        path: relative_path.clone(),
                    },
                    language_name.clone(),
                    cx,
                )
            })
            .ok()?
            .await;
        if let Some(toolchain) = selected_toolchain {
            Some(toolchain)
        } else {
            let project = workspace
                .read_with(cx, |this, _| this.project().clone())
                .ok()?;
            let Toolchains {
                toolchains,
                root_path: relative_path,
                user_toolchains,
            } = cx
                .update(|_, cx| {
                    project.read(cx).available_toolchains(
                        ProjectPath {
                            worktree_id,
                            path: relative_path.clone(),
                        },
                        language_name,
                        cx,
                    )
                })
                .ok()?
                .await?;
            // Since we don't have a selected toolchain, pick one for user here.
            let default_choice = user_toolchains
                .iter()
                .find_map(|(scope, toolchains)| {
                    if scope == &ToolchainScope::Global {
                        // Ignore global toolchains when making a default choice. They're unlikely to be the right choice.
                        None
                    } else {
                        toolchains.first()
                    }
                })
                .or_else(|| toolchains.toolchains.first())
                .cloned();
            if let Some(toolchain) = &default_choice {
                let worktree_root_path = project.read_with(cx, |this, cx| {
                    this.worktree_for_id(worktree_id, cx)
                        .map(|worktree| worktree.read(cx).abs_path())
                })?;
                let db = cx.update(|_, cx| workspace::WorkspaceDb::global(cx)).ok()?;
                db.set_toolchain(
                    workspace_id,
                    worktree_root_path,
                    relative_path.clone(),
                    toolchain.clone(),
                )
                .await
                .ok()?;
                project
                    .update(cx, |this, cx| {
                        this.activate_toolchain(
                            ProjectPath {
                                worktree_id,
                                path: relative_path,
                            },
                            toolchain.clone(),
                            cx,
                        )
                    })
                    .await;
            }

            default_choice
        }
    })
}
```

**概要**

- 「今のファイルの場所と言語に対して、どのツールチェーンを使うべきか」を決定し、  
  必要に応じてデフォルトツールチェーンを選び、それを DB とプロジェクト両方に保存します。
- `ActiveToolchain::spawn_tracker_task` 内から呼び出される内部関数です。

**引数**

| 引数名 | 型 | 説明 |
|--------|----|------|
| `workspace` | `WeakEntity<Workspace>` | ツールチェーン情報にアクセスするためのワークスペースへの弱参照。 |
| `worktree_id` | `WorktreeId` | 対象ファイルの属するワークツリー ID。 |
| `relative_path` | `Arc<RelPath>` | ツールチェーンを適用する相対パス（ディレクトリ単位）。 |
| `language_name` | `LanguageName` | 対象言語。 |
| `cx` | `&mut AsyncWindowContext` | 非同期タスク生成用コンテキスト。 |

**戻り値**

- `Task<Option<Toolchain>>`  
  - `Some(toolchain)` … 有効なツールチェーンが決定できた場合（既存 or デフォルト選択）。
  - `None` … `Workspace` / `Project` が取得できない、利用可能なツールチェーンがない等で決定できない場合。

**内部処理の流れ**

1. `workspace.database_id()` を取得（失敗したら `None`）。
2. `Project::active_toolchain` を呼び、既に選択済みのツールチェーンがあるか確認。
   - あればそれを `Some` で返して終了。
3. なければ `Project::available_toolchains` で利用可能な候補を取得。
4. デフォルト候補 `default_choice` を決定:
   1. `user_toolchains`（ユーザー定義）から、`ToolchainScope::Global` 以外のスコープの最初のツールチェーンを優先。
   2. 見つからなければ、自動検出された `toolchains.toolchains` の先頭を利用。
5. `default_choice` が `Some` の場合:
   1. `worktree_root_path`（絶対パス）を取得。
   2. `WorkspaceDb::global(cx)` から DB を取得し、`set_toolchain` で選択内容を保存。
   3. `Project::activate_toolchain` を呼び、プロジェクトに反映。
6. 最終的に `default_choice` を返却。

**エッジケース**

- 利用可能なツールチェーンが一つもない場合、`default_choice` は `None` となり、何も保存されません。
- `Workspace` / `Project` 取得や DB 更新の途中でエラーが発生した場合は、いずれもオプショナルチェーンと `ok()?` により `None` で終了します。

**使用上の注意点**

- デフォルト選択では **Global スコープのユーザー定義ツールチェーンは除外**されるため、
  ユーザーが Global にのみツールチェーンを定義している場合でも、ここで自動選択されない可能性があります（コメントにも理由が記載されています）。
- 非同期タスクの戻り値 `Task<Option<Toolchain>>` 自体は、呼び出し側が `.await` するのではなく、`spawn_tracker_task` 側が `maybe!` マクロを通じて `Option<()>` に変換して利用しています。

---

### 4.3 その他の関数（一覧）

ここでは、理解に役立つが詳細説明を省いた補助関数を簡単にまとめます。

| 関数 / メソッド名 | 所属型 | 役割（1 行） |
|-------------------|--------|--------------|
| `AddToolchainState::create_path_browser_delegate` | `AddToolchainState` | OpenPathPrompt 用の delegate と結果受信用 `oneshot::Receiver` を生成し、フッターにエラー表示・ローディング表示を組み込む。 |
| `AddToolchainState::wait_for_path` | `AddToolchainState` | パス選択結果 (`oneshot::Receiver`) を待ち、受信後に `resolve_path` を開始する。 |
| `AddToolchainState::resolve_path` | `AddToolchainState` | 選択されたパスから `Project::resolve_toolchain` を呼び、成功時は `AddState::Name` へ、失敗時はエラーメッセージ付きで `AddState::Path` に戻す。 |
| `AddToolchainState::select_scope` | `AddToolchainState` | スコープ選択 UI から選ばれた `ToolchainScope` を状態に反映し再描画をトリガ。 |
| `ToolchainSelector::handle_add_toolchain` | `ToolchainSelector` | 検索状態から追加フロー (`State::AddToolchain`) への遷移処理。 |
| `ToolchainSelectorDelegate::update_matches` | `ToolchainSelectorDelegate` | 現在のクエリに基づき、候補リストから fuzzy マッチング結果 (`StringMatch`) を計算する。 |
| `ToolchainSelectorDelegate::confirm` | `ToolchainSelectorDelegate` | 選択されたツールチェーンを `WorkspaceDb` と `Project` に反映し、モーダルを閉じる。 |
| `ToolchainSelectorDelegate::render_match` | `ToolchainSelectorDelegate` | 単一候補の ListItem を描画し、必要なら削除ボタンを付加する。 |
| `ActiveToolchain::spawn_tracker_task` | `ActiveToolchain` | アクティブバッファからツールチェーンを取得・表示する非同期タスクを生成する。 |
| `ActiveToolchain::update_lister` | `ActiveToolchain` | `Editor` のアクティブバッファに対する `BufferEvent` サブスクリプションを張り直し、言語変更時に追従する。 |

---

5. データフロー

--------------

ここでは代表的なシナリオとして、**ステータスバーからツールチェーンを選択し、その選択が永続化されるまで**の流れを説明します。

### 5.1 処理の流れ（概要）

1. ユーザーがステータスバーの `ActiveToolchain` ボタンをクリック。
2. `ActiveToolchain` が `ToolchainSelector::toggle` を呼び出し、現在のファイル情報を基にモーダルを開く。
3. `ToolchainSelector::new` が `Picker<ToolchainSelectorDelegate>` を構築し、  
   `ToolchainSelectorDelegate` が非同期にツールチェーン候補とメタデータを取得。
4. ユーザーが候補を選択して Confirm。
5. `ToolchainSelectorDelegate::confirm` が
   - `WorkspaceDb::set_toolchain` により選択結果を永続化し、
   - `Project::activate_toolchain` によりプロジェクトに反映。
6. プロジェクトのツールチェーンストアが更新され、`ToolchainStoreEvent` が発火。
7. `ActiveToolchain` がそのイベントを受け取り、再度 `update_lister` / `spawn_tracker_task` により表示を更新。

### 5.2 シーケンス図

```mermaid
sequenceDiagram
    participant U as ユーザー
    participant AT as ActiveToolchain
    participant WS as Workspace
    participant TS as ToolchainSelector
    participant PK as Picker&lt;Delegate&gt;
    participant D as ToolchainSelectorDelegate
    participant PR as Project
    participant DB as WorkspaceDb

    U->>AT: ステータスバーのボタンをクリック
    AT->>WS: ToolchainSelector::toggle(...)
    WS->>WS: active_item() から Editor/Buffer を取得
    WS->>PR: active_toolchain(ProjectPath, LanguageName)
    PR-->>WS: 現在のツールチェーン (Option)
    WS->>WS: toggle_modal(... ToolchainSelector::new(...))

    Note over TS: コンストラクタ内で Picker&lt;ToolchainSelectorDelegate&gt; を生成

    TS->>PK: Picker::uniform_list(delegate)
    PK->>D: delegate 初期化 (_fetch_candidates_task 開始)
    D->>PR: toolchain_metadata(), available_toolchains()
    PR-->>D: メタデータ & 候補一覧
    D->>PK: candidates / matches / placeholder_text を更新

    U->>PK: 検索クエリ入力・候補選択・Confirm
    PK->>D: confirm()
    D->>DB: set_toolchain(workspace_id, root, rel_path, toolchain)
    D->>PR: activate_toolchain(ProjectPath, toolchain)
    PR-->>WS: 非同期タスク完了

    Note over PR,WS: ツールチェーンストア更新 → ToolchainStoreEvent 発火

    WS-->>AT: ToolchainStoreEvent
    AT->>AT: update_lister() / spawn_tracker_task()
    AT->>PR: active_toolchain(...) / available_toolchains(...)
    PR-->>AT: 決定されたツールチェーン
    AT-->>U: ステータスバーの表示更新
```

---

6. 使い方（How to Use）

-----------------------

### 6.1 基本的な使用方法

このクレートは主に「アプリ側から初期化する」ことと、「Workspace 内でアクションを発火する」ことで利用します。

#### 6.1.1 アプリケーション初期化時に組み込む

```rust
use gpui::App;
use toolchain_selector::init as init_toolchain_selector;

fn main() {
    App::new(|app| {
        // ツールチェーン選択機能を Workspace に統合
        init_toolchain_selector(app); // 新規 Workspace ごとにアクションが登録される

        // 他の初期化処理 …
    });
}
```

- これにより、各 `Workspace` は
  - `toolchain::Select`
  - `toolchain::AddToolchain`
  といったアクションを認識し、キーバインドやメニューから呼び出せるようになります。

#### 6.1.2 コードから直接モーダルを開く

`Workspace` ハンドラ内など、すでに `&mut Workspace` / `&mut Window` / `&mut Context<Workspace>` を持っている場合は、  
`ToolchainSelector::toggle` を直接呼び出してモーダルを操作できます。

```rust
use workspace::Workspace;
use toolchain_selector::ToolchainSelector;

fn open_toolchain_modal(
    workspace: &mut Workspace,
    window: &mut gpui::Window,
    cx: &mut gpui::Context<Workspace>,
) {
    if ToolchainSelector::toggle(workspace, window, cx).is_none() {
        // アクティブな Editor / Buffer がないなどの理由でモーダルを開けない場合
        // ログ出力やユーザーへの通知を行うのが自然です（このチャンクには含まれません）
    }
}
```

### 6.2 よくある使用パターン

#### パターン 1: ステータスバーからのツールチェーン選択

1. `ActiveToolchain` がワークスペースのステータスバーに登録されている前提で、
2. ユーザーはステータスバーに表示されているツールチェーン名をクリック。
3. `ToolchainSelector` モーダルが開き、候補の fuzzy 検索・選択ができる。
4. 選択内容は `WorkspaceDb` および `Project` に反映され、ステータスバー表示が更新される。

> ステータスバーへの登録コードはこのチャンクには現れませんが、  
> `ActiveToolchain` が `StatusItemView` を実装していることから、そのような経路で使われる前提と解釈できます。

#### パターン 2: モーダル内からツールチェーンを追加

1. `ToolchainSelector` モーダルのフッターに表示される「Add …」ボタンをクリック。
2. `AddToolchain` アクションが発火し、`ToolchainSelector::handle_add_toolchain` により `AddToolchainState` に遷移。
3. OpenPathPrompt を使ってツールチェーンのパスを選択。
4. そのパスに対して `Project::resolve_toolchain` が呼ばれ、ツールチェーン名が推定される。
5. ユーザーは必要に応じて名前を編集し、Global / Project / Subproject のスコープを選択。
6. Confirm（Enter / Add ボタン）で `Project::add_toolchain` が呼ばれ、追加されたツールチェーンは検索画面にも反映される。

### 6.3 使用上の注意点（まとめ）

- **アクティブな Editor / Buffer が必要**
  - `ToolchainSelector::toggle` はアクティブな `Editor` と `Buffer` が存在しない場合 `None` を返し、モーダルは開きません。
  - 多重に `toggle` を呼んでも問題はありませんが、呼び出し元で `None` を無視すると「何も起きない」ように見えるため注意が必要です。

- **非同期処理の完了を前提にしすぎない**
  - 候補取得 (`available_toolchains`)、メタデータ取得 (`toolchain_metadata`)、DB への保存 (`set_toolchain`) などは非同期で行われます。
  - UI はタスクの完了に応じて自動的に更新されますが、呼び出し直後に状態が確定しているとは限りません。

- **Global スコープの扱い**
  - デフォルトの自動選択 (`ActiveToolchain::active_toolchain`) では `ToolchainScope::Global` のユーザー定義ツールチェーンは候補から除外されます。
  - Global スコープのツールチェーンを利用させたい場合は、ユーザーが明示的にモーダルから選択する必要があります。

- **ツールチェーン追加時のパス解決エラー**
  - `AddToolchainState::resolve_path` 内で `Project::resolve_toolchain` が `Err` を返した場合、
    - エラーメッセージは OpenPathPrompt フッターに表示されます。
    - 状態は再びパス選択画面 (`AddState::Path`) に戻されます。
  - この挙動は UI 内部で完結しており、外部からは特別なエラーハンドリングは不要です。

- **削除操作の即時性**
  - ピッカー内の Trash ボタンを押すと、
    - `Project::remove_toolchain` が即座に呼び出され、
    - ローカルの候補・マッチ配列から該当要素が削除されます。
  - 確認ダイアログ等は実装されておらず、誤操作に対する保護はこのチャンクには見当たりません。

---

7. 関連ファイル

--------------

このディレクトリ内のファイルと、その役割を一覧にします。

| パス | 役割 / 関係 |
|------|------------|
| `toolchain_selector/Cargo.toml` | クレート `toolchain_selector` の定義ファイル。ライブラリのエントリポイントを `src/toolchain_selector.rs` に設定し、依存クレート（`editor`, `project`, `workspace`, `ui` など）を指定しています。 |
| `toolchain_selector/src/toolchain_selector.rs` | クレートのメインモジュール。`ToolchainSelector` モーダル、`ToolchainSelectorDelegate`、`AddToolchainState` などを定義し、`ActiveToolchain` を `pub use` しています。 |
| `toolchain_selector/src/active_toolchain.rs` | ステータスバー項目 `ActiveToolchain` の実装。アクティブな `Editor` / `Buffer` を監視し、適切なツールチェーンを自動的に選択・表示します。 |

外部クレートとの関係（コードから読み取れる範囲）:

- `workspace` クレート
  - `Workspace`, `StatusItemView`, `WorkspaceDb` などを提供し、モーダル・ステータスバーの統合ポイントとなります。
- `project` クレート
  - `Project`, `ProjectPath`, `Toolchains` 等を通じて、ツールチェーンの検出・管理ロジックを提供します。
- `language` クレート
  - `Language`, `LanguageName`, `Toolchain`, `ToolchainScope` 等の型定義を提供します。
- `picker`, `open_path_prompt`, `ui`, `fuzzy` クレート
  - モーダル UI / ピッカー UI / fuzzy 検索 / パス選択 UI など、ユーザーインターフェース部分の構築に利用されています。

これら外部クレートの詳細な実装はこのチャンクには含まれていないため、  
より深く理解するには該当クレート側のコードやドキュメントを参照する必要があります。
