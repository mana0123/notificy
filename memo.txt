


## 環境構築手順
* 作業用ディレクトリを作成する。
```
mkdir scheduleAPI_1016
```

* 作成した作業用ディレクトリと同じ改装にassetsディレクトリをコピーする。
```
$ ls
scheduleAPI_1016
assets
```

* 以下のファイルをコピー
```
cp -p assets/* scheduleAPI_1016/
```

* 作業ディレクトリ上で以下のコマンドを実行。

`sudo docker-compose run web rails new . --api --force --no-deps --database=postgresql --skip-bundle`

* ビルド 
`sudo docker-compose build`

* database.ymlのdevelopment:タブの中に、以下の三行を追加する。
`sudo vim config/database.yml`
```
host: db
  username: postgres
  password:
```
* 以下のコマンドを実行。
```
sudo docker-compose up
sudo docker-compose run web rake db:create
sudo docker-compose run web rails webpacker:install
```


## dockerコマンド
* 起動・停止
sudo docker-compose up
sudo docker-compose start
sudo docker-compose stop
sudo docker-compose down

* コンテナ一覧
sudo docker ps -a

* コンテナの削除
sudo docker rm {id}

* image一覧
sudo docker images

* imageの削除
sudo docker rmi {id}

* コンテナに入る
sudo docker exec -it web /bin/bash

* railsのコマンド打つとき
sudo docker-compose run web rails {コマンド}

## gitコマンド

```
$ git add -A
$ git commit -m "Finish static pages"
$ git checkout master
$ git merge static-pages
$ git push
$ git push -u origin master
```

## Railsコマンド
docker-compose run --rm web bundle install
docker-compose run --rm web rails g model User name:string email:string
docker-compose run --rm web rails g controller users
docker-compose run --rm web rails db:migrate
docker-compose run --rm api rails db:migrate:reset
docker-compose run --rm web rails test
docker-compose run --rm web rails test test/models/schedule_item_test.rb -n test_repeat_year_item_should_be_valid 
docker-compose run --rm web rails routes
binding.pry
docker-compose run --rm api bundle exec rspec
docker-compose run --rm api bundle exec rspec -e {discribe}
docker-compose run --rm api rails g rspec:model test
docker-compose run --rm web rails db:migrate:reset RAILS_ENV=test
docker-compose run --rm api rails console
docker-compose run --rm api rails db:seed
User.column_names


docker-compose -f docker-compose.prod.ym

## Rails Tips
* テストのREDとGREEN
test/test_helper.rb
``
require "minitest/reporters"
Minitest::Reporters.use!
```

* byebugのよく使うコマンド
next       一行進む
continue   次のブレイクポイントに進む
step       メソッドの内部にステップインする
list       ソースコードを表示する
up         ソースコードの上を表示する
down       ソースコードの下を表示する

* belongs_to / has_manyの関係で使えるメソッド
micropost.user    Micropostに紐付いたUserオブジェクトを返す
user.microposts   Userのマイクロポストの集合をかえす
user.microposts.create(arg)   userに紐付いたマイクロポストを作成する
user.microposts.create!(arg)   userに紐付いたマイクロポストを作成する (失敗時に例外を発生)
user.microposts.build(arg)   userに紐付いた新しいMicropostオブジェクトを返す
user.microposts.find_by(id: 1)   userに紐付いていて、idが1であるマイクロポストを検索する
