# ============================================================
# Learn OpenUSD - Dockerfile for DGX Spark
# Base: Python 3.12 slim (usd-core は CPU ベースで動作)
# GPU レンダリングが必要な場合は nvcr.io/nvidia/cuda ベースに変更可
# ============================================================
FROM --platform=linux/amd64 python:3.12-slim

# --------------------
# システムパッケージ
# --------------------
RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    git-lfs \
    curl \
    ca-certificates \
    # usd-core / OpenUSD の実行に必要なライブラリ
    libgl1 \
    libglib2.0-0 \
    libgomp1 \
    libx11-6 \
    libxt6 \
    # ビルドツール
    build-essential \
    && git lfs install \
    && rm -rf /var/lib/apt/lists/*

# --------------------
# uv のインストール
# --------------------
RUN curl -LsSf https://astral.sh/uv/install.sh | sh
ENV PATH="/root/.local/bin:${PATH}"

# --------------------
# 作業ディレクトリ
# --------------------
WORKDIR /workspace

# --------------------
# 依存関係のキャッシュ層
# （pyproject.toml / uv.lock だけ先にコピーしてキャッシュ活用）
# --------------------
COPY pyproject.toml uv.lock* ./

# uv で依存関係をインストール（dev グループ = JupyterLab も含む）
RUN uv sync --group dev

# --------------------
# ソースコード一式をコピー
# （docker-compose でマウントする場合はこの COPY は不要だが
#   スタンドアロンビルド用に残す）
# --------------------
COPY . .

# --------------------
# ポート公開
# 8888 : JupyterLab
# 8000 : Sphinx ドキュメントプレビュー
# --------------------
EXPOSE 8888 8000

# --------------------
# デフォルト起動: JupyterLab
# （Sphinx ビルド → Notebook 起動は entrypoint.sh 経由）
# --------------------
CMD ["uv", "run", "jupyter", "lab", \
     "--ip=0.0.0.0", \
     "--port=8888", \
     "--no-browser", \
     "--allow-root", \
     "--NotebookApp.token=''", \
     "--NotebookApp.password=''"]
