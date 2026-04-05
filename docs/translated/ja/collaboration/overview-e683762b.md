# コラボレーション {#collaboration}

Zed はリアルタイムのマルチプレイヤー編集をサポートしています。複数人が同じプロジェクトで同時に作業でき、お互いのカーソルや編集内容をリアルタイムに確認できます。

コラボレーションパネルは {#kb collab_panel::ToggleFocus} で開きます。コラボレーション機能にアクセスするには、[サインイン](../authentication.md#signing-in)する必要があります。

## コラボレーションパネル {#collaboration-panel}

コラボレーションパネルには次の 2 つのセクションがあります。

1. [Channels](./channels.md): 共有プロジェクトやボイスチャットを備えた、チームコラボレーション用の永続的なプロジェクトルームです。
2. [Contacts and Private Calls](./contacts-and-private-calls.md): アドホックなプライベートセッションのための、コンタクトリストです。

> **警告:** プロジェクトを共有すると、そのプロジェクト内であなたのローカルファイルシステムへ共同編集者がアクセスできるようになります。信頼できる人とだけコラボレーションしてください。

詳細については [データとプライバシーに関する FAQ](https://zed.dev/faq#data-and-privacy) を参照してください。

## オーディオ設定 {#audio-settings}

### オーディオデバイスの選択

システムのデフォルトではなく、特定の入力および出力オーディオデバイスを選択できます。オーディオデバイスを設定するには:

1. {#kb zed::OpenSettings} を開きます
2. **Collaboration** > **Experimental** に移動します
3. **Output Audio Device** と **Input Audio Device** のドロップダウンを使用して、希望のデバイスを選択します

変更は即座に反映されます。選択したデバイスが利用できなくなった場合、Zed はシステムのデフォルトにフォールバックします。

オーディオ設定をテストするには、同じセクションの **Test Audio** をクリックします。選択したデバイスでマイクとスピーカーが正しく動作するか確認できるウィンドウが開きます。

**JSON 設定:**

```json [settings]
{
  "audio": {
    "experimental.output_audio_device": "Device Name (device-id)",
    "experimental.input_audio_device": "Device Name (device-id)"
  }
}
```

システムのデフォルトを使用するには、どちらか、または両方の値を `null` に設定します。
