# MIDI Step Sequencer

iPhone/iPad用の外部MIDI機器対応ステップシーケンサーアプリです。

## 主な機能

### 基本機能
- **8音×16ステップ**のステップシーケンサー
- **外部MIDI機器**への送信対応（CoreMIDI使用）
- **複数ステップにまたがる長音**の設定が可能
- **ループ再生**機能
- **テンポ調整**（40-240 BPM）

### MIDI設定
- **接続されたMIDI機器**から選択可能
- **MIDIチャンネル**選択（1-16）
- ベロシティ固定値（100）

### スケール設定
- **ベース音選択**：C1〜C7から選択可能
- **スケールタイプ**：メジャー/マイナー
- 選択したベース音から1オクターブ（8音）の音階を表示

## 使い方

### ノートの入力方法
1. **タップ**：1ステップのノートを配置
2. **ドラッグ**：開始位置から終了位置までドラッグして長音を配置
3. **削除**：既存のノートをタップ

### 再生方法
1. **MIDI機器を接続**（USB、Bluetooth MIDI対応）
2. **Device**メニューから使用するMIDI機器を選択
3. **Channel**を設定（1-16）
4. **Play**ボタンを押して再生開始
5. **Stop**ボタンで停止

### スケール設定
1. **Base Note**で基準音を選択（C1〜C7）
2. **Scale**でメジャー/マイナーを選択
3. グリッドの左側に音名が表示されます

## 技術仕様

- **開発言語**: Swift
- **フレームワーク**: SwiftUI, CoreMIDI
- **対応デバイス**: iPhone, iPad
- **最小iOS**: iOS 15.0以上
- **MIDI接続**: USB MIDI, Bluetooth MIDI対応

## プロジェクト構成

```
MIDISequencer/
├── MIDISequencer/
│   ├── MIDISequencerApp.swift     # アプリエントリーポイント
│   ├── Models/
│   │   ├── MusicTheory.swift      # 音楽理論（音階、スケール定義）
│   │   └── SequencerModels.swift  # データモデル（ノート、パターン）
│   ├── Services/
│   │   ├── MIDIManager.swift      # MIDI通信管理
│   │   └── SequencerEngine.swift  # シーケンス再生エンジン
│   ├── Views/
│   │   ├── ContentView.swift      # メインビュー
│   │   ├── StepGridView.swift     # ステップグリッドUI
│   │   └── ControlPanelView.swift # コントロールパネルUI
│   ├── Assets.xcassets/           # アセット
│   └── Info.plist                 # アプリ設定
└── README.md
```

## ビルド方法

1. Xcodeで`MIDISequencer.xcodeproj`を開く
2. ターゲットデバイスを選択（実機推奨）
3. ビルド＆実行

**注意**: MIDI機能は実機でのテストが必要です。シミュレータでは動作しません。

## 必要な権限

- **Bluetooth権限**: Bluetooth MIDI機器の使用に必要
- **Background Audio**: バックグラウンド再生のため

これらは`Info.plist`に設定済みです。

## カスタマイズ

### ベロシティの変更
`SequencerModels.swift`の`NoteEvent`構造体で:
```swift
var velocity: UInt8 = 100 // 0-127の範囲で変更可能
```

### ステップ数の変更
`SequencerModels.swift`の`SequencerPattern`クラスで:
```swift
let numberOfSteps = 16 // 変更可能
```

### テンポ範囲の変更
`SequencerEngine.swift`の`updateTempo`メソッドで:
```swift
tempo = max(40.0, min(240.0, newTempo)) // 最小値・最大値を変更可能
```

## トラブルシューティング

### MIDI機器が表示されない
1. MIDI機器が正しく接続されているか確認
2. 更新ボタン（🔄）をタップして再スキャン
3. Bluetooth MIDIの場合、設定アプリでペアリングを確認

### 音が出ない
1. MIDI機器が正しいチャンネルで受信設定されているか確認
2. MIDI機器の音量設定を確認
3. アプリのMIDIチャンネル設定を確認

## ライセンス

このプロジェクトはサンプルコードです。自由にご使用ください。

## 開発環境

- Xcode 15.0以上
- Swift 5.9以上
- iOS 15.0以上
