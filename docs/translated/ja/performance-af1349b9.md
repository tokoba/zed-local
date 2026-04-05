Zed を高速に保つために、社内ツールを使ってプロファイリングする方法。

# ラフで手軽な CPU プロファイリング（Flamechart）

CPU が最も時間を費やしている処理を確認します。samply の使用を強く
推奨します。
[samply](https://github.com/mstange/samply) はブラウザ内でインタラクティブなプロファイルを
開きます（具体的にはローカルの [firefox_profiler](https://profiler.firefox.com/) インスタンス）。

インストールと実行方法については
[samply](https://github.com/mstange/samply) の README を参照してください。

profile.json にはシンボルが含まれていません。Firefox profiler はローカルのシンボルをプロファイルに追加できます。そのためには、右上にある upload local profile ボタンをクリックします。

<img width="851" height="auto" alt="画像" src="https://github.com/user-attachments/assets/cbef2b51-0442-4ee9-bc5c-95f6ccf9be2c" style="display: block; margin: 0 auto;" />

# 詳細な CPU プロファイリング（Tracing）

アノテーションされた各関数呼び出しにどれだけ時間がかかったか、その引数（設定されている
場合）を確認します。

プロファイルに表示したい任意の関数に instrument を付けてアノテーションします。詳細については
[tracing-instrument](https://docs.rs/tracing/latest/tracing/attr.instrument.html)
を参照してください。

```rust
#[instrument(skip_all)]
fn should_appear_in_profile(kitty: Cat) {
    sleep(QUITE_LONG)
}
```

次に、`ZTRACING=1 cargo r --features tracy --release` で Zed をコンパイルします。release ビルドは必須ではありませんが、強く推奨します。ほかのあらゆるプログラムと同様に、最適化の有無によって Zed のパフォーマンス特性は大きく変わります。release ビルドでは存在しない低速化を追いかけることにはなってほしくないはずです。

## 初回セットアップ／Profiler のビルド

Profiler をダウンロードします:
[linux x86_64](https://zed-tracy-import-miniprofiler.nyc3.digitaloceanspaces.com/tracy-profiler-linux-x86_64)
[macos aarch64](https://zed-tracy-import-miniprofiler.nyc3.digitaloceanspaces.com/tracy-profiler-0.13.0-macos-aarch64)

### 代替: 自分でビルドする

- <git@github.com>:wolfpld/tracy.git からリポジトリを clone する
- `cd profiler && mkdir build && cd build`
- cmake を実行してビルドファイルを生成する: `cmake -G Ninja -DCMAKE_BUILD_TYPE=Release ..`
- Profiler をビルドする: `ninja`
- [任意] Linux では ~/.local/bin のような適当な場所に Profiler を移動する

## 使用方法

Profiler（tracy-profiler）を開くと、`Discovered clients` の一覧に zed が表示されているはずなので、それをクリックします。

<img width="392" height="auto" alt="画像" src="https://github.com/user-attachments/assets/b6f06fc3-6b25-41c7-ade9-558cc93d6033" style="display: block; margin: 0 auto;"/>

Tracy は非常に強力で多機能な Profiler ですが、UI はあまり親切ではありません。ここでは Tracy の詳細なガイドは扱いませんが、あるコードが *ときどき* 遅くなる理由を調べる際に役立つ、特定のワークフローをひとつ紹介します。

手順は次のとおりです。

1. 上部の flamechart ボタンをクリックします。

<img width="1815" height="auto" alt="flamechart をクリック" src="https://github.com/user-attachments/assets/9b488c60-90fa-4013-a663-f4e35ea753d2" />

2. 時間のかかっている関数をクリックします。

<img width="2001" height="auto" alt="snapshot をクリック" src="https://github.com/user-attachments/assets/ddb838ed-2c83-4dba-a750-b8a2d4ac6202" />

3. main thread をクリックして、関数呼び出しの一覧を展開します。

<img width="2313" height="auto" alt="main thread をクリック" src="https://github.com/user-attachments/assets/465dd883-9d3c-4384-a396-fce68b872d1a" />

4. そのリストを遅い呼び出しに絞り込み、リスト内の遅い呼び出しのひとつをクリックします。

<img width="2264" height="auto" alt="ヒストグラムの末尾側の呼び出しを選択して呼び出しリストを絞り込み、その中のいずれか 1 件をクリック" src="https://github.com/user-attachments/assets/a8fddc7c-f40a-4f11-a648-ca7cc193ff6f" />

5. タイムライン上でその特定の関数呼び出しに移動するために、zoom to zone をクリックします。

<img width="1822" height="auto" alt="zoom to zone をクリック" src="https://github.com/user-attachments/assets/3391664d-7297-41d4-be17-ac9b2e2c85d1" />

6. スクロールしてズームインし、呼び出し元の詳細を確認します。

<img width="1964" height="auto" alt="スクロールしてズームイン" src="https://github.com/user-attachments/assets/625c2bf4-a68d-40c4-becb-ade16bc9a8bc" />

7. 呼び出し元をクリックして、その *呼び出し元* の統計情報を取得します。

<img width="1888" height="auto" alt="任意のゾーンをクリックして統計情報を取得" src="https://github.com/user-attachments/assets/7e578825-2b63-4b7f-88f7-0cb16b8a3387" />

通常、Tracy のタイムラインに表示される青いバーは関数呼び出しに対応しますが、コードベースの任意の部分の時間計測にも利用できます。以下の例では、追加の span として "for block in edits" を入れ、そのメタデータとして block_height を付加しています。これは次のように記述できます。

```rust
let span = ztracing::debug_span!("for block in edits", block_height = block.height());
let _enter = span.enter(); // span ガード。これが drop されると span が終了し（その継続時間が記録される）
```

# タスク／非同期プロファイリング

zed のフォアグラウンド executor とバックグラウンド executor のプロファイルを取得します。フォアグラウンドを
長時間ブロックしているものや、バックグラウンドで（クロック）時間を取り過ぎているものがないか確認します。

Profiler は常にバックグラウンドで動作します。UI からトレースを保存することも、
その場で結果を確認することもできます。

## インポーターのセットアップ／ビルド

インポーターをダウンロードします
[linux x86_64](https://zed-tracy-import-miniprofiler.nyc3.digitaloceanspaces.com/tracy-import-miniprofiler-linux-x86_64)
[mac aarch64](https://zed-tracy-import-miniprofiler.nyc3.digitaloceanspaces.com/tracy-import-miniprofiler-macos-aarch64)

### 代替: 自分でビルドする

- <git@github.com>:zed-industries/tracy.git の v0.12.2 ブランチを clone する
- `cd import && mkdir build && cd build`
- cmake を実行してビルドファイルを生成する: `cmake -G Ninja -DCMAKE_BUILD_TYPE=Release ..`
- インポーターをビルドする: `ninja`
- トレースファイルに対してインポーターを実行する: `./tracy-import-miniprofiler /path/to/trace.miniprof.json /path/to/output.tracy`
- Tracy でトレースを開く:
  - Windows の場合は、upstream リポジトリの Releases から v0.12.2 をダウンロードする
  - それ以外のプラットフォームでは、<https://tracy.nereid.pl/> で開く（バージョンが一致しない可能性があるため、うまくいかない場合もある。本来は自前でホストする必要がある）

## トレースを保存するには

- アクションを実行する: `zed open performance profiler`
- save ボタンを押す。save ダイアログが開くか、開けない場合はトレースが作業ディレクトリに保存される。
- インポーターを使って、Tracy にインポート可能な形式にプロファイルを変換する: `./tracy-import-miniprofiler <path to performance_profile.miniprof.json> output.tracy`
- <https://tracy.nereid.pl/> にアクセスし、左上の「power ボタン」を押してから保存したトレースを開く。
- ズームインして、タスクとその所要時間を確認する

# 関数が遅い場合に警告する

```rust
let _timer = zlog::time!("my_function_name").warn_if_gt(std::time::Duration::from_millis(100));
```
