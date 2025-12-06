# 使用公共基础镜像，不需要任何权限
FROM node:18-slim

# 1. 安装系统工具
RUN apt-get update && apt-get install -y \
    git \
    gettext-base \
    python3 \
    make \
    g++ \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# 2. 准备工作目录
WORKDIR /home/node/app

# 3. 复制当前仓库代码 (自带食材)
COPY . .

# 4. 创建数据目录
RUN mkdir -p /home/node/app/data

# --- 安装云端备份插件 ---
ARG PLUGINS_DIR=/home/node/app/plugins
RUN mkdir -p ${PLUGINS_DIR}
WORKDIR ${PLUGINS_DIR}
RUN git clone https://github.com/fuwei99/cloud-saves
WORKDIR ${PLUGINS_DIR}/cloud-saves
RUN npm install
# ---------------------

# 5. 回到主目录安装依赖
WORKDIR /home/node/app
RUN npm install

# 6. 修复权限和换行符
RUN sed -i 's/\r$//' entrypoint.sh && chmod +x entrypoint.sh
RUN chown -R node:node /home/node/app

# 7. 启动
USER node
ENTRYPOINT ["./entrypoint.sh"]
