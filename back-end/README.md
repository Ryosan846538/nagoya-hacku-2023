# BackEnd

backendの開発用ディレクトリ

## Dockerコマンド

docker desktopを起動する

`docker compose build`によってビルドをする。

`docker compose up`によってサーバー起動可能。

起動出来た場合は、

`Environment: development`
`PID : xxx`
`Listening on http://x.x.x.x:8080`
`Use Cntrl-C to stop`

などの出力があれば動作している。

ストップさせるにはCtrl + c。

バックエンドのファイルをいじった場合は、

`docker compose down`

して再度

`docker compose up`

することで、サーバースタート可能

## DB

`~/back-end`で、
`docker compose run --rm -it web bash`
dockerのサーバー内に入ったら
`rails db:create DB`：作成
`rails db:migrate DB`：テーブル作成
`rails db:seed`：初期データ作成
`rails db:drop`：DB削除
`drop -> create -> migratet`でDBのリセットができる。
