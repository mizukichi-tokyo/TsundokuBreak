# 作成したアプリ

![appImage](./ReadmeImages/appImage.png)

## App URL

**[積読くずし](https://apps.apple.com/us/app/%E7%A9%8D%E8%AA%AD%E3%81%8F%E3%81%9A%E3%81%97/id1508001531?l=ja&ls=1)**

## アプリの特徴
### シンプルで使いやすい

 - 複数回の画面遷移を必要とせず、すぐに記録をとれる
 - 書籍の登録のためにテキスト入力をしなくてよい
 - 記録の入力にテキストを打たなくて良い
 - 記録がすぐに見え、進捗が見やすい
 - 広告がないので入力の邪魔にならない

## 使用した技術(箇条書き)

- MVVM
- RxSwift
- DIパターン
- Realm
- Bitrise
- git-flow

## 使い方
 
> `$ pod install`

## 意識した点
### アプリのUX/UI

 - すぐに記録できるように、既存のアプリよりも画面遷移が少なくすぐ使える
 - バーコード読み取りのデータ呼び出し時に、フィードバックを与えることでユーザーの不安を解消。
 - テキストを入力する必要がなく、入力が簡単
 - 入力していて楽しい

### 技術面
  MVVMによって実装し、FatViewControllerをさけた
  DIパターンを採用しテストが書きやすいようにした
    （テストは鋭意実装中）
  Bitriseを用いてテスト自動化を行っている
  
## 使用したライブラリ

 - [RxSwift](https://github.com/ReactiveX/RxSwift)　リアクティブプログラミング用 
 -  [RxCocoa](https://github.com/ReactiveX/RxSwift/tree/master/RxCocoa)　リアクティブプログラミング用
 - [RealmSwift](https://realm.io/docs/swift/latest)　ネイティブアプリDB操作用
 - [RxRealm](https://github.com/RxSwiftCommunity/RxRealm) 上記のものをRxSwiftで扱うライブラリ
 - [RxTest](https://github.com/ReactiveX/RxSwift/tree/master/RxTest) RxSwiftのテスト用
 - [RxBlocking](https://github.com/ReactiveX/RxSwift/tree/master/RxBlocking)　RxSwiftのテスト用
 - [Moya](https://github.com/Moya/Moya) ネットワークを抽象化するレイヤーの役割をしてくれるライブラリ
 - [AlamofireImage](https://github.com/Alamofire/AlamofireImage)画像キャッシュライブラリ
 
 - [SwiftLint](https://github.com/realm/SwiftLint)　校正ツール
 - [R.swift](https://github.com/mac-cain13/R.swift)　ハードコーディングによるスペルミス対策
 - [LicensePlist](https://github.com/mono0926/LicensePlist) ライセンス一覧を生成するツール
 
 - [MaterialComponents/Buttons](https://material.io/develop/ios/components/buttons/)　FABのライブラリ
 - [ColorMatchTabs](https://github.com/Yalantis/ColorMatchTabs)ポップなタブのライブラリ
 -  [SwiftGifOrigin](https://github.com/swiftgif/SwiftGif).gifを読みこむためのライブラリ
 - [MBProgressHUD](https://github.com/jdg/MBProgressHUD)  progressHUD
 - [CDAlertView](https://github.com/candostdagdeviren/CDAlertView)ポップなアラート
 - [FaveButton](https://github.com/janselv/fave-button)　可愛いボタンのライブラリ
 - [DZNEmptyDataSet](https://github.com/dzenbot/DZNEmptyDataSet)　エンプティエステート
 - [Onboard](https://github.com/mamaral/Onboard)　初回説明用ライブラリ

## 今後の予定
テストコードの整備. 
UIの変更による使いやすさの向上. 
全体進捗の把握機能. 
