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
