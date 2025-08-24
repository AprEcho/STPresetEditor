.PHONY: help install dev build test clean docker-build docker-run docker-stop

# 默认目标
help:
	@echo "可用的命令:"
	@echo "  install      - 安装依赖"
	@echo "  dev          - 启动开发服务器"
	@echo "  build        - 构建生产版本"
	@echo "  test         - 运行测试"
	@echo "  clean        - 清理构建文件"
	@echo "  docker-dev   - 使用Docker启动开发环境"
	@echo "  docker-build - 构建Docker镜像"
	@echo "  docker-run   - 运行Docker容器"
	@echo "  docker-stop  - 停止Docker容器"

# 安装依赖
install:
	npm install

# 启动开发服务器
dev:
	npm run dev

# 构建生产版本
build:
	npm run build

# 运行测试
test:
	npm test

# 清理构建文件
clean:
	rm -rf dist node_modules
	rm -f package-lock.json

# Docker开发环境
docker-dev:
	docker-compose --profile dev up --build

# 构建Docker镜像
docker-build:
	docker-compose --profile build up --build

# 运行Docker生产环境
docker-run:
	docker-compose --profile prod up -d

# 停止Docker容器
docker-stop:
	docker-compose down

# 预览构建结果
preview:
	npm run preview

# 检查代码质量
lint:
	npm run lint

# 格式化代码
format:
	npm run format 