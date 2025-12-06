# 使用基于 Debian 的镜像，兼容性比 Alpine 更好，不容易报错
FROM node:18-slim

# 1. 安装必要的系统工具 (Git, Gettext, Python, 编译工具)
# 这些是做“硬菜”必须的工具
RUN apt-get update && apt-get install -y \
    git \
    gettext-base \
    python3 \
    make \
    g++ \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# 2. 设置工作目录
WORKDIR /home/node/app

# 3. 复制所有文件
COPY . .

# 4. 创建数据目录
RUN mkdir -p /home/node/app/data

# --- 安装云端备份插件 (Cloud Saves) ---
ARG PLUGINS_DIR=/home/node/app/plugins
RUN mkdir -p ${PLUGINS_DIR}
WORKDIR ${PLUGINS_DIR}
RUN git clone https://github.com/fuwei99/cloud-saves
WORKDIR ${PLUGINS_DIR}/cloud-saves
RUN npm install
# -----------------------------------

# 5. 回到主目录，安装酒馆依赖
WORKDIR /home/node/app
RUN npm install

# 6. 【关键】修复 Windows 换行符问题 & 加权限
# 防止因为你在 Windows 上创建文件导致格式错误
RUN sed -i 's/\r$//' entrypoint.sh && chmod +x entrypoint.sh

# 7. 修复文件权限
RUN chown -R node:node /home/node/app

# 8. 启动
USER node
ENTRYPOINT ["./entrypoint.sh"]
