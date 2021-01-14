# notificy

## 目次
* [はじめに](#はじめに)
* [目的](#目的)
* [アプリ概要](#アプリ概要)
* [システム概要](#システム概要)
* [今後の改修予定](#今後の改修予定)

## はじめに
「notificy」はコンテンツを任意にスケジュール登録し、LINEに通知するアプリです。  
以下、本アプリを作成した背景や、アプリの機能、システム概要等について説明します。

## 目的
本アプリを作成した目的は以下の通りです。
* 高久家の課題解決  
現在、妹と二人暮らしをしているのですが、我が家では以下の課題があります。
  1. たまにごみを出し忘れる
  2. たまに家賃(毎月25日まで)の振込を忘れそうになる
  3. 電気を無駄に使いがち（特に妹）
  4. 家賃、光熱費、通信費、食費等は基本割り勘しているが清算が面倒  
 ...

  この課題を解決するための対処として、本アプリを作成します。  
  1,2は単にごみの日や振り込み期日を忘れているだけなので、設定した期日に高久家のグループLINEにリマインド通知を行うことで、忘れないようにする作戦です。  
  （3,4はこれから実装予定ですが、）3はいきなり電気の無駄遣いをやめさせることは性格的に難しいと考えられるので、まずは電気使用量、電気代を毎日グループLINEに通知することで、何をすると電気を多く使うのかを認識してもらう作戦です。使用量の情報は電力会社がWEBで公開してくれているので、そのサイトから取得してきます。  
  4はLINEを用いて手軽に清算してくれる機能を実装します。

* 自身の学習  
WEBアプリ作成を通して、一般的なWEBアプリを構成する以下の技術スキルを習得します。（これまでの実務経歴はオンプレのJavaアプリ開発、性能試験がメインのため、以下の技術要素を用いたWEBアプリ開発は初めてです。）
  * インフラ：AWS、Docker、Vagrant
  * バックエンド：Ruby、Ruby on Rails
  * フロントエンド：JavaScript、JQuery


* 転職活動時のスキルアピール  
  本アプリを作成するスキルを持っていることと、使ったことのない技術要素でも抵抗なく学習していけることをアピールできればと思います。

## アプリ概要
![notificy概要](https://user-images.githubusercontent.com/70317171/102046633-098bd780-3e1f-11eb-8cf0-2a0399c580e8.jpg)

## システム構成
![システム構成](https://user-images.githubusercontent.com/70317171/102046553-e3663780-3e1e-11eb-9074-852d601583d0.png)
* 本番環境はAWSのEC2上にDockerホストを構築。開発環境はローカルPC(Windows)にVagrantでubuntuの仮想マシンを立て、その上にDockerホストを構築。
* マイクロサービスアーキテクチャのように、役割ごとにコンテナを分けて設計しました。マイクロサービスにした理由は、今後の機能拡充を考慮して保守しやすいようにしたかったのと、単純にマイクロサービスをやってみたかったためです。
* リバースプロキシを実現するために、EC2のフロントにnginxのWEBサーバを配置しています。
* 外部とWEBサーバ間はHTTPS、WEBサーバより内部はHTTPで通信しています。SSL/TLS証明書は無料で発行できる「Let's Encrypt」を利用しています。
* アプリはRuby(Ruby on Rails)で実装しました。理由は、Rubyを触ったことがなかったので触ってみたかったのと、転職市場にてRuby on Railsの求人が多かったためです。

## 今後の改修予定
まだまだ改善余地多数です。
#### 大きめの改修
* 電気使用量、電気代の自動通知機能の実装  
WEBスクレイピングで我が家で契約している東京電力のWEBページから電気使用量、電気代を日次で取得し、LINEに通知する。
* 割り勘機能  
LINEから金額、使用目的を入力すると、月末に自動で割り勘金額を算出してくれる機能。

#### 小さめ改修
* スマホ向け画面の実装
* エラーメッセージ等のメッセージ表示の実装
* フォーム画面でのビュー上(javasqript)のバリデーション機能の実装