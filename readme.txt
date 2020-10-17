


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
```


## dockerコマンド
* 起動・停止
sudo docker-compose up
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
