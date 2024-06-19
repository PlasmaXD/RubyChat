# README

## 1.2. Ubuntu の場合
## 起動
sudo service postgresql start

## 停止
sudo service postgresql stop

## 再起動
なし pg_ctl で再起動する。

Pumaサーバー解除

```bash
sudo systemctl stop puma

sudo systemctl disable puma
```

ステータスの確認

```bash
sudo systemctl status puma
```

