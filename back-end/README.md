# BackEnd
backendの開発ようディレクトリ

## Dockerコマンド
docker desktopを起動する
docker compose build
によってビルドをする。
docker compose up
によってサーバー起動可能。
起動出来た場合は、
Environment: development
PID : xxx
Listening on http://x.x.x.x:8080
Use Cntrl-C to stop
などの出力があれば動作している。
ストップさせるにはCtrl + c。

バックエンドのファイルをいじった場合は、
docker compose down
して再度
docker compose up
することで、サーバースタート可能

## DB
~/back-endで、
docker compose run --rm -it web bash
dockerのサーバーないに入ったら
rails db:create DB作成
rails db:migrate DBテーブル作成
rails db:seed 初期データ作成
rails db:drop DB削除
drop -> create -> migratetでDBのリセットができる。
