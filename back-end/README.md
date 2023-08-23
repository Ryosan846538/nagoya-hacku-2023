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
DBの操作は以下の通り、
docker compose exec web rails db:create
DBの作成
docker compose exec web rails db:migrate
migrateファイルをもとにDBテーブルの作成
docker compose exec web rails db:seed
seedファイルから初期値を作成可能
docker compose exec web rails db:drop
DBを削除することが可能 drop->create->migrateでリセットとして動作
