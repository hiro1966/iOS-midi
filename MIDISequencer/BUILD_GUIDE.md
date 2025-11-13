# 📱 MIDISequencer ビルドガイド

## 🎯 ステップバイステップ手順

### 1. Xcodeでプロジェクトを開く
- Finderで `MIDISequencer.xcodeproj` をダブルクリック
- または Xcode から File → Open で選択

### 2. 開発チームの設定（初回のみ）

#### 2-1. プロジェクトナビゲーター
- Xcode左側の一番上のフォルダアイコン（MIDISequencer）をクリック

#### 2-2. Signingタブ
1. 中央のエディタエリアで **"MIDISequencer"** ターゲットを選択
2. **"Signing & Capabilities"** タブをクリック
3. **"Team"** のドロップダウンをクリック
4. **"Add an Account..."** を選択（初回のみ）
5. Apple IDでサインイン（無料アカウントでOK）
6. サインイン後、**"Team"** で自分のアカウントを選択

#### 2-3. Bundle Identifierの変更（必要に応じて）
- **"Bundle Identifier"** が `com.example.MIDISequencer` になっています
- 必要に応じて `com.yourname.MIDISequencer` のように変更してください
- **重要**: ユニークな名前にする必要があります

### 3. ビルドターゲットの選択

#### 3-1. デバイスを接続
- iPhoneまたはiPadをMacにUSBケーブルで接続
- デバイスで「このコンピュータを信頼しますか？」→ **信頼**

#### 3-2. ターゲットデバイスを選択
- Xcodeウィンドウ上部中央のデバイス選択メニューをクリック
- 接続したデバイスを選択（例: "Your iPhone"）
- **注意**: "Any iOS Device" や シミュレータは選択しないでください

### 4. ビルド＆実行

#### 4-1. ビルドボタンをクリック
- Xcode左上の **▶️ (再生ボタン)** をクリック
- または **⌘ + R** (Command + R)

#### 4-2. 初回ビルド時の警告
デバイスに「信頼されていない開発元」という警告が出た場合：

1. iPhoneの **設定** アプリを開く
2. **一般** → **VPNとデバイス管理** （または **デバイス管理**）
3. 自分のApple IDを選択
4. **"(あなたのApple ID)を信頼"** をタップ
5. 確認ダイアログで **信頼** をタップ
6. Xcodeに戻って再度 **▶️** をクリック

### 5. アプリの起動

ビルドが成功すると：
- アプリが自動的にデバイスで起動します
- ホーム画面にアイコンが追加されます

## 🎹 MIDI機器の接続方法

### USB MIDI機器の場合
1. **Lightning to USB Camera Adapter** (Apple純正推奨) を用意
2. iPhoneにアダプタを接続
3. MIDI機器をアダプタに接続
4. アプリを起動すると自動的に認識されます

### Bluetooth MIDI機器の場合
1. iPhoneの **設定** → **Bluetooth** を開く
2. MIDI機器をペアリングモードにする
3. デバイス一覧に表示されたらタップして接続
4. アプリを起動すると自動的に認識されます

## 🔧 トラブルシューティング

### ❌ "Signing for 'MIDISequencer' requires a development team"

**解決方法:**
1. プロジェクトナビゲーターでMIDISequencerを選択
2. Signing & Capabilities タブ
3. Team ドロップダウンからアカウントを選択
4. Apple IDを追加していない場合は "Add an Account..." から追加

### ❌ "Failed to prepare device for development"

**解決方法:**
1. デバイスを一度取り外す
2. Xcodeを再起動
3. デバイスを再接続
4. デバイスで「信頼」を選択

### ❌ "No code signing identities found"

**解決方法:**
1. Xcode → Preferences → Accounts
2. 左下の + ボタンで Apple ID を追加
3. アカウントを選択して "Download Manual Profiles" をクリック

### ❌ シミュレータでMIDI機器が表示されない

**原因:** CoreMIDI機能はシミュレータでは動作しません

**解決方法:** 実機を使用してください（iPhone/iPad本体）

### ❌ "The application could not be verified"

**解決方法:**
1. デバイスの設定 → 一般 → VPNとデバイス管理
2. 開発元を信頼する（上記の「4-2」参照）

### ❌ MIDI機器が「No devices found」と表示される

**解決方法:**
1. MIDI機器が正しく接続されているか確認
2. USB接続の場合、アダプタが正しく接続されているか確認
3. アプリ内の更新ボタン（🔄）をタップ
4. Bluetooth MIDIの場合、設定アプリでペアリングを確認

## 📊 ビルド成功の確認

ビルドが成功すると、Xcodeのコンソール（下部）に以下のようなメッセージが表示されます：

```
Build succeeded
Running on iPhone...
```

デバイスでアプリが起動し、以下の画面が表示されれば成功です：
- ヘッダー: "MIDI Step Sequencer"
- 8×16のステップグリッド
- 右側/下部にコントロールパネル

## 🎉 次のステップ

1. MIDI機器を接続
2. Deviceメニューから機器を選択
3. ノートを配置（タップ・ドラッグ）
4. Playボタンを押す
5. 音楽を楽しむ！🎶

---

## 💡 Tips

### Xcodeショートカット
- **⌘ + B**: ビルドのみ（実行はしない）
- **⌘ + R**: ビルド＆実行
- **⌘ + .**: ビルド停止
- **⌘ + Shift + K**: クリーンビルド

### デバッグ方法
- Xcodeのコンソール（下部）でログを確認
- ブレークポイントを設定してステップ実行
- `print()` 文でデバッグ出力

### パフォーマンス確認
- Xcode → Product → Profile (⌘ + I)
- Instrumentsで詳細なパフォーマンス分析

---

**質問があれば、いつでもお気軽にどうぞ！**
