# SillyTavern Preset Editor

<div>
    <img src="https://img.shields.io/badge/Vue-3.x-brightgreen.svg" alt="Vue 3">
    <img src="https://img.shields.io/badge/TailwindCSS-4.x-blue.svg" alt="Tailwind CSS">
    <img src="https://img.shields.io/badge/License-MIT-yellow.svg" alt="MIT License">
    <img src="https://img.shields.io/badge/Docker-Ready-blue.svg" alt="Docker Ready">
    <img src="https://img.shields.io/badge/CI/CD-GitHub%20Actions-green.svg" alt="CI/CD">
</div>

一个轻量级、用户友好的Web编辑器，用于高效管理SillyTavern `preset.json`文件，由Vue.js和Tailwind CSS提供支持，现已完全中文化。

**🌐 Try it online:** [https://stpe.nativus.workers.dev/](https://stpe.nativus.workers.dev/)

[![Deploy to Cloudflare](https://deploy.workers.cloudflare.com/button)](https://deploy.workers.cloudflare.com/?url=https%3A%2F%2Fgithub.com%2FNativu5%2FSTPresetEditor)

## 🖼 Overview

The default SillyTavern preset editor offers basic functionality but can be slow and lacks advanced editing features (e.g., macro highlighting, variable management).

This project enhances your editing experience with an intuitive, high-performance and powerful UI/UX.

<table>
  <tr>
    <td align="center" style="border: 1px solid #ddd; padding: 8px;">
      <img src="https://github.com/user-attachments/assets/24a8cbf7-932a-4dba-9852-64752fbc406c" alt="Main Editor" height="200" />
      <br>Prompt Manage & Edit
    </td>
    <td align="center" style="border: 1px solid #ddd; padding: 8px;">
      <img src="https://github.com/user-attachments/assets/86f3ca7b-0a86-4dc7-9ee3-0045fc4544d8" alt="Macro Analysis" height="200" />
      <br>Macro Analysis & Preview
    </td>
    <td align="center" style="border: 1px solid #ddd; padding: 8px;">
      <img src="https://github.com/user-attachments/assets/4a2c883c-710e-40aa-9cce-f3be7770e5ad" alt="Variable Manager" height="200" />
      <br>Variable Tools
    </td>
  </tr>
</table>

## 🎯 Key Features

- ⚡ **Real-time Editing & Saving**: Instantly edit prompts with batch selection and drag-and-drop. Changes are saved locally for secure, persistent editing.
- 🧩 **Syntax Highlighting**: Automatically highlight special macros within prompts, enabling quick reference.
- 🔍 **Macro Analysis & Preview**: Instantly analyze macros and switch between raw and preview modes for efficient editing.
- 📊 **Variable Management**: Efficiently rename and track variable usage across all prompts.

## 🚀 快速开始

### 方法一：本地开发

1. **克隆项目**
   ```bash
   git clone https://github.com/yourusername/STPresetEditor.git
   cd STPresetEditor
   ```

2. **安装依赖**
   ```bash
   npm install
   # 或者使用 Makefile
   make install
   ```

3. **启动开发服务器**
   ```bash
   npm run dev
   # 或者使用 Makefile
   make dev
   ```

4. **访问应用**
   在浏览器中打开 [http://localhost:5173](http://localhost:5173)

### 方法二：使用Docker

#### 开发环境
```bash
# 使用Docker启动开发环境
make docker-dev
# 或者
docker-compose --profile dev up --build
```

#### 生产环境
```bash
# 构建并运行生产环境
make docker-run
# 或者
docker-compose --profile prod up -d
```

#### 仅构建
```bash
# 仅构建Docker镜像
make docker-build
# 或者
docker-compose --profile build up --build
```

### 方法三：使用Makefile

```bash
# 查看所有可用命令
make help

# 常用命令
make install    # 安装依赖
make dev        # 启动开发服务器
make build      # 构建生产版本
make preview    # 预览构建结果
make clean      # 清理构建文件
```

## 🐳 Docker部署

### 构建镜像
```bash
docker build -t st-preset-editor .
```

### 运行容器
```bash
docker run -d -p 80:80 --name st-preset-editor st-preset-editor
```

### 使用docker-compose
```bash
# 开发环境
docker-compose --profile dev up --build

# 生产环境
docker-compose --profile prod up -d

# 停止服务
docker-compose down
```

## 📦 构建与部署

### 构建生产版本
```bash
npm run build
```

### 预览构建结果
```bash
npm run preview
```

### 部署到静态托管
将 `dist` 文件夹的内容部署到任何静态托管提供商（如GitHub Pages、Netlify、Vercel）。

## 🔧 开发工具

### 代码质量
```bash
# 代码检查
npm run lint

# 代码格式化
npm run format
```

### 测试
```bash
# 运行测试
npm test
```

## 🚢 CI/CD

项目配置了GitHub Actions工作流，支持：

- 自动构建和测试
- Docker镜像构建
- 构建产物上传

### 工作流触发
- 推送到 `main` 或 `master` 分支
- 创建Pull Request

## 📁 项目结构

```
STPresetEditor/
├── .github/                 # GitHub Actions配置
├── public/                  # 静态资源
├── src/                     # 源代码
│   ├── assets/             # 资源文件
│   ├── components/         # Vue组件
│   │   ├── AppLayout.vue   # 应用布局
│   │   ├── AppToolbar.vue  # 工具栏
│   │   ├── JsonExportModal.vue # 导出模态框
│   │   ├── JsonImportModal.vue # 导入模态框
│   │   ├── LeftSidebar/    # 左侧边栏组件
│   │   ├── MainEditor/     # 主编辑器组件
│   │   └── RightSidebar/   # 右侧边栏组件
│   ├── stores/             # Pinia状态管理
│   └── main.js             # 应用入口
├── .dockerignore           # Docker忽略文件
├── .gitignore             # Git忽略文件
├── docker-compose.yml     # Docker Compose配置
├── Dockerfile             # Docker镜像构建文件
├── Makefile               # 项目命令管理
├── nginx.conf             # Nginx配置
├── package.json           # 项目配置
├── vite.config.js         # Vite配置
└── README.md              # 项目说明
```

## 🌟 使用指南

### 1. 导入预设
- 点击工具栏中的"导入"按钮
- 选择或拖拽你的 `preset.json` 文件
- 或直接粘贴JSON内容

### 2. 编辑提示词
- 在左侧边栏查看所有提示词
- 点击提示词卡片进行编辑
- 在右侧边栏修改详细信息

### 3. 管理变量
- 在右侧边栏切换到"变量"标签
- 查看变量定义和引用位置
- 重命名变量（自动更新所有引用）

### 4. 导出预设
- 点击工具栏中的"导出"按钮
- 复制生成的JSON内容
- 保存为 `preset.json` 文件

## 🤝 贡献指南

欢迎贡献！如果您遇到任何bug或有功能建议，请：

1. 打开一个Issue
2. 提交Pull Request
3. 确保代码符合项目规范

### 开发环境设置
```bash
# 克隆项目
git clone https://github.com/yourusername/STPresetEditor.git
cd STPresetEditor

# 安装依赖
npm install

# 启动开发服务器
npm run dev
```

## 📄 许可证

MIT许可证。详情请参阅 [LICENSE](LICENSE) 文件。

## 🆘 故障排除

### 常见问题

1. **依赖安装失败**
   ```bash
   # 清理缓存
   npm cache clean --force
   # 重新安装
   npm install
   ```

2. **Docker构建失败**
   ```bash
   # 清理Docker缓存
   docker system prune -a
   # 重新构建
   docker build --no-cache -t st-preset-editor .
   ```

3. **端口冲突**
   ```bash
   # 检查端口占用
   netstat -an | findstr :5173
   # 或使用其他端口
   npm run dev -- --port 3000
   ```

## 📞 支持

如果您需要帮助：

- 查看 [Issues](https://github.com/yourusername/STPresetEditor/issues)
- 阅读 [汉化完成报告](汉化完成报告.md)
- 查看 [功能说明文档](IMPORT_FEATURE.md)

---

由 🤖 使用Vue.js和Tailwind CSS开发，现已完全中文化。
