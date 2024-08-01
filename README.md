# 〜無NO薬〜野菜栽培〜

サービスURL: https://www.homegarden-harvest.com/

[![Image from Gyazo](https://i.gyazo.com/4e1f0ca45222ab7717c0e0777441d2d6.png)](https://gyazo.com/4e1f0ca45222ab7717c0e0777441d2d6)

## サービス概要
* 無農薬で家庭菜園をする方にアドバイスやスケジュール管理などでサポートをし、市場での価格と育てた量で節約額の比較をしたり収穫量などを表示できたりするサービスです。

## 想定されるユーザー層
* 家庭菜園をやっている方。
* 家庭菜園をやってみたいと思っている方や興味のある方

## サービスコンセプト
* ユーザーが抱えている課題感と提供するサービスでどのように解決するのか
→家庭菜園で無農薬野菜を作るのが難しいと感じている人が多いと思ったので、
それをスケジュール管理やアドバイスをして初心者でも簡単に無農薬野菜を作れるサービスにする。

## 機能一覧
|トップ画面|会員登録|
|:-:|:-:|
|[![Image from Gyazo](https://i.gyazo.com/47c6530547f0771d90bcbcfe56099068.jpg)](https://gyazo.com/47c6530547f0771d90bcbcfe56099068)|[![Image from Gyazo](https://i.gyazo.com/7ac3443263bd41fe06b0701264fe6acc.jpg)](https://gyazo.com/7ac3443263bd41fe06b0701264fe6acc)|
|右上のメニューボタンから会員登録をすることでサービスを利用することができます。|名前、メールアドレス、都道府県、パスワードを入力して登録を行うか、LINEで登録することもできます。

|ログイン画面|サービスの使い方画面|
|:-:|:-:|
|[![Image from Gyazo](https://i.gyazo.com/86c3e3b0bf9b0857a803422370c2da0d.jpg)](https://gyazo.com/86c3e3b0bf9b0857a803422370c2da0d)|[![Image from Gyazo](https://i.gyazo.com/3aaf8da3865b145291f9c4f22e969a1c.jpg)](https://gyazo.com/3aaf8da3865b145291f9c4f22e969a1c)|
|メールアドレスとパスワードを入力するか、LINEでもログインをすることができます。|このサービスの使い方と主な機能の紹介を見ることができます。|

|マイページ画面|プロフィール編集画面|
|:-:|:-:|
|[![Image from Gyazo](https://i.gyazo.com/6470c01152ee037c047cf94290caf90e.jpg)](https://gyazo.com/6470c01152ee037c047cf94290caf90e)|[![Image from Gyazo](https://i.gyazo.com/e5f28c79302c8e93d26726491d3b056e.jpg)](https://gyazo.com/e5f28c79302c8e93d26726491d3b056e)|
|会員登録時に登録した都道府県の天気情報や生育状況をSNSに上げることができます。|名前、メールアドレス、都道府県を編集することができます。|

|育成野菜登録画面|スケジュール画面|
|:-:|:-:|
|[![Image from Gyazo](https://i.gyazo.com/ee3d70de88641ef01fe43875744a807b.jpg)](https://gyazo.com/ee3d70de88641ef01fe43875744a807b)|[![Image from Gyazo](https://i.gyazo.com/cdfc406aa19ebc10b79269f84f4c0e66.jpg)](https://gyazo.com/cdfc406aa19ebc10b79269f84f4c0e66)|
|育てる野菜と種まき日を入力して登録ボタンを押すとスケジュールが登録されます。|登録した野菜のスケジュール画面が表示され、今日何をしたかをボタンで選択してスケジュールに反映させることができます。|

|画像分析画面|画像分析結果|
|:-:|:-:|
|[![Image from Gyazo](https://i.gyazo.com/8bcc4dcff9cc90b3e6d8483b205b7d2b.jpg)](https://gyazo.com/8bcc4dcff9cc90b3e6d8483b205b7d2b)|[![Image from Gyazo](https://i.gyazo.com/5e496fbacd9ffa0609e2579397041f8e.jpg)](https://gyazo.com/5e496fbacd9ffa0609e2579397041f8e)|
|スケジュール画面の右上にあるボタンをクリックして野菜名と画像を選択すると画像分析をすることができます。|画像分析ボタンを押したら画像分析の結果とアドバイスが表示されます。|

## 使用技術
|カテゴリ|技術|
| --- | --- |
|バックエンド|Ruby: 3.1.4 / Ruby on Rails: 7.0.8|
|フロントエンド|JavaScript|
|CSSフレームワーク|Bootstrap|
|データベース|PostgreSQL|
|認証|Devise / Omniauth-line|
|デプロイ|heroku|
|Web API|Azure Translator API / DeepL API / Google Cloud Vision API / LibreTranslate API / LINE Messaging API / OpenWeather API / Perenual API|

## ER図
[![Image from Gyazo](https://i.gyazo.com/c0488013f1daf85960c0b967a9962917.png)](https://gyazo.com/c0488013f1daf85960c0b967a9962917)

## 画面遷移図
https://www.figma.com/file/woDOrmHhrxtdRX12DIeaUk/runteq?type=design&node-id=11-2&mode=design&t=dmm76l53LGGcNAv3-0
