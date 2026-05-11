#!/bin/bash
# ============================================================
# entrypoint.sh
# Sphinx ドキュメントをビルドしてから JupyterLab を起動する
# ============================================================
set -e

echo "=================================================="
echo " Learn OpenUSD - Docker Environment"
echo "=================================================="

# Sphinx ドキュメントのビルド（Notebook の実行も含む）
echo "[1/2] Sphinx ドキュメントをビルド中..."
uv run sphinx-build -M html docs/ docs/_build/
echo "      → ビルド完了: docs/_build/html/"

# バックグラウンドで Sphinx プレビューサーバーを起動
echo "[2/2] Sphinx プレビューサーバーを起動 (ポート: 8000)..."
uv run python -m http.server 8000 -d docs/_build/html/ &

# JupyterLab を起動
echo "      JupyterLab を起動 (ポート: 8888)..."
echo "      ブラウザで http://<DGX_IP>:8888 を開いてください"
echo "      ドキュメントは http://<DGX_IP>:8000 で確認できます"
echo "=================================================="

exec uv run jupyter lab \
    --ip=0.0.0.0 \
    --port=8888 \
    --no-browser \
    --allow-root \
    --NotebookApp.token='' \
    --NotebookApp.password='' \
    --notebook-dir=/workspace
