# 🔧 トラブルシューティング

## ✅ 修正済み: プロジェクトファイルのエラー

### 問題
```
The project 'MIDISequencer' is damaged and cannot be opened.
Exception: -[PBXGroup buildPhase]: unrecognized selector sent to instance
```

### 原因
Xcodeプロジェクトファイル（.pbxproj）内で、同じID（`A0FFFFB`）が以下の2つの異なる用途に使用されていました：
- PBXGroup（ファイルグループ）
- PBXSourcesBuildPhase（ビルドフェーズ）

この重複により、Xcodeがオブジェクトの種類を正しく識別できず、エラーが発生していました。

### 解決方法
ビルドフェーズのIDを `A0FFFFB` → `A100030` に変更し、ID衝突を解消しました。

### 修正コミット
```
faa8bb1 - fix: Resolve Xcode project file ID conflict
```

---

## 🔄 修正後の確認手順

### 1. 最新版を取得
```bash
cd /path/to/iOS-midi
git pull origin main
```

### 2. プロジェクトを開く
```bash
open MIDISequencer/MIDISequencer.xcodeproj
```

### 3. 正常に開けることを確認
- プロジェクトが正常に開く
- ファイルツリーが表示される
- エラーメッセージが出ない

---

## 📝 その他のよくある問題

### ❌ Signing for 'MIDISequencer' requires a development team

**解決方法:**
1. プロジェクトナビゲーターでMIDISequencerを選択
2. Signing & Capabilities タブ
3. Team ドロップダウンからアカウントを選択
4. Apple IDを追加していない場合は "Add an Account..." から追加

### ❌ Failed to prepare device for development

**解決方法:**
1. デバイスを一度取り外す
2. Xcodeを再起動
3. デバイスを再接続
4. デバイスで「信頼」を選択

### ❌ No code signing identities found

**解決方法:**
1. Xcode → Preferences → Accounts
2. 左下の + ボタンで Apple ID を追加
3. アカウントを選択して "Download Manual Profiles" をクリック

### ❌ The application could not be verified

**解決方法:**
1. デバイスの設定 → 一般 → VPNとデバイス管理
2. 開発元を信頼する

### ❌ MIDI機器が「No devices found」と表示される

**解決方法:**
1. MIDI機器が正しく接続されているか確認
2. USB接続の場合、アダプタが正しく接続されているか確認
3. アプリ内の更新ボタン（🔄）をタップ
4. Bluetooth MIDIの場合、設定アプリでペアリングを確認

### ❌ シミュレータでMIDI機器が表示されない

**原因:** CoreMIDI機能はシミュレータでは動作しません

**解決方法:** 実機（iPhone/iPad）を使用してください

---

## 📚 詳細ドキュメント

さらに詳しい情報は以下を参照：

- **BUILD_GUIDE.md** - 詳細なビルド手順
- **QUICK_START.md** - クイックガイド
- **README.md** - プロジェクト全体の説明
- **HOW_TO_BUILD.txt** - シンプルなビルド手順

---

## 🆘 まだ問題が解決しない場合

### クリーンビルド
```
1. Xcode → Product → Clean Build Folder (⌘ + Shift + K)
2. 再度ビルド (⌘ + R)
```

### Derived Data の削除
```bash
rm -rf ~/Library/Developer/Xcode/DerivedData/MIDISequencer-*
```

### プロジェクトの再クローン
```bash
cd /path/to/parent-directory
rm -rf iOS-midi
git clone https://github.com/hiro1966/iOS-midi.git
cd iOS-midi/MIDISequencer
open MIDISequencer.xcodeproj
```

---

## ✅ 確認事項チェックリスト

- [ ] Xcode 15.0以降がインストールされている
- [ ] macOS 13.0以降を使用している
- [ ] 最新のプロジェクトをpullした
- [ ] プロジェクトが正常に開ける
- [ ] Apple IDでサインインしている
- [ ] 実機が接続されている
- [ ] デバイスで「信頼」を選択している

---

**更新日:** 2025-11-13
**修正バージョン:** faa8bb1
