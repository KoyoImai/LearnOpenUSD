# Learn OpenUSD
## 環境構築
DGX SparkでOpenUSDの勉強を進めるための環境構築を行います。
```
# リポジトリのクローン（まだの場合）
git lfs install
git clone https://github.com/NVIDIA-Omniverse/LearnOpenUSD.git
cd LearnOpenUSD
git lfs pull
```
```
# entrypoint.sh に実行権限を付与
chmod +x entrypoint.sh

# 初回ビルド＆起動
docker compose up --build

# 2回目以降
docker compose up
```
