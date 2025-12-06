# ---------------------------------------------------
# 使用公共的基础镜像 (Node.js 18)
# 这样就不需要任何 GHCR 权限了
# ---------------------------------------------------
FROM node:18-alpine

# 1. 安装系统工具 (Git 和 Gettext)
RUN apk add --no-cache git gettext

# 2. 设置工作目录
WORKDIR /home/node/app

# 3. 把当前仓库的所有代码复制进去
# (因为这就是 Nyy 仓库本身，所以直接复制自己)
COPY . .

# 4. 创建数据保存目录
RUN mkdir -p /home/node/app/data

# --- 安装云端备份插件 (Cloud Saves) ---
# 定义插件目录
ARG PLUGINS_DIR=/home/node/app/plugins
# 创建目录
RUN mkdir -p ${PLUGINS_DIR}
# 进入插件目录
WORKDIR ${PLUGINS_DIR}
# 克隆插件代码
RUN git clone https://github.com/fuwei99/cloud-saves
# 安装插件依赖
WORKDIR ${PLUGINS_DIR}/cloud-saves
RUN npm install
# -----------------------------------

# 5. 回到主目录，安装酒馆本身的依赖
WORKDIR /home/node/app
RUN npm install

# 6. 给启动脚本加权限
RUN chmod +x entrypoint.sh

# 7. 修复文件权限 (让 node 用户能读写)
RUN chown -R node:node /home/node/app

# 8. 切换到安全用户启动
USER node
ENTRYPOINT ["./entrypoint.sh"]
