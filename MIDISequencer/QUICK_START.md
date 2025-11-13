# 🚀 クイックスタートガイド

## 📦 必要なもの

```
✅ Mac (macOS 13.0以降)
✅ Xcode 15.0以降 (App Store から無料)
✅ iPhone/iPad (iOS 15.0以降)
✅ USBケーブル
✅ Apple ID (無料でOK)
```

---

## ⚡ 3ステップでビルド

### 1️⃣ プロジェクトを開く

```bash
# Finderでダブルクリック
MIDISequencer.xcodeproj
```

### 2️⃣ デバイスを接続

```
iPhone/iPad を Mac に USB接続
     ↓
"信頼する" をタップ
     ↓
Xcode上部で接続したデバイスを選択
```

### 3️⃣ ビルド＆実行

```
Xcode左上の ▶️ ボタンをクリック
または
⌘ + R (Command + R)
```

---

## 🎯 初回ビルド時の追加手順

### ステップA: 開発チームの設定

```
1. Xcode左側でプロジェクトアイコン（MIDISequencer）をクリック
2. 中央で "MIDISequencer" ターゲットを選択
3. "Signing & Capabilities" タブをクリック
4. "Team" ドロップダウンをクリック
5. "Add an Account..." を選択
6. Apple IDでサインイン
7. "Team" で自分のアカウントを選択
```

### ステップB: デバイスで開発元を信頼

ビルド後、デバイスで警告が出た場合：

```
1. 設定アプリを開く
2. 一般 → VPNとデバイス管理
3. 自分のApple IDをタップ
4. "信頼" をタップ
5. Xcodeに戻って再度 ▶️ をクリック
```

---

## 🎹 MIDI機器の接続

### USB MIDI

```
Lightning-USBアダプタ → MIDI機器
```

必要なもの：
- Lightning to USB Camera Adapter (Apple純正推奨)
- USB MIDI機器

### Bluetooth MIDI

```
設定 → Bluetooth → MIDI機器をペアリング
```

---

## 📱 アプリの使い方

### 基本操作

```
1. Deviceメニューから MIDI機器を選択
2. Channelを設定 (1-16)
3. Base Note と Scale を選択
4. グリッドをタップ・ドラッグしてノート配置
5. Play ボタンで再生！
```

### ノート入力

```
タップ       → 1ステップのノート
ドラッグ     → 長音（複数ステップ）
既存ノートをタップ → 削除
```

---

## 🔧 よくあるエラーと解決法

### エラー: "Signing requires a development team"

```
→ 上記「ステップA: 開発チームの設定」を実行
```

### エラー: "The application could not be verified"

```
→ 上記「ステップB: デバイスで開発元を信頼」を実行
```

### 問題: MIDI機器が表示されない

```
→ 更新ボタン（🔄）をタップ
→ 接続を確認
→ Bluetooth の場合は設定アプリでペアリング
```

### 問題: シミュレータで動かない

```
→ CoreMIDI機能は実機のみ対応
→ iPhone/iPadの実機を使用してください
```

---

## 📚 詳細ドキュメント

さらに詳しい情報は以下を参照：

- **BUILD_GUIDE.md** - 詳細なビルド手順とトラブルシューティング
- **README.md** - 機能説明とプロジェクト構成

---

## 💡 Xcode ショートカット

```
⌘ + R          ビルド＆実行
⌘ + B          ビルドのみ
⌘ + .          ビルド停止
⌘ + Shift + K  クリーンビルド
```

---

## 🎉 ビルド成功！

デバイスでアプリが起動したら：

1. ✅ ホーム画面にアイコンが追加されます
2. ✅ "MIDI Step Sequencer" のタイトルが表示されます
3. ✅ 8×16のグリッドが表示されます
4. ✅ コントロールパネルが表示されます

**MIDI機器を接続して音楽制作を楽しんでください！** 🎶

---

## ❓ サポート

質問や問題がある場合は、BUILD_GUIDE.mdの「トラブルシューティング」セクションを参照してください。

**Happy Music Making! 🎹✨**
