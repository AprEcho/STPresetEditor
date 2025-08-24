import { defineConfig } from 'vite';
import vue from '@vitejs/plugin-vue';
import tailwindcss from '@tailwindcss/vite';

// https://vite.dev/config/
export default defineConfig({
  plugins: [vue(), tailwindcss()],
  server: {
    host: '0.0.0.0', // 允许所有网络接口访问
    port: 5173,      // 指定端口
    strictPort: true, // 端口被占用时严格报错
    open: true,       // 自动打开浏览器
    cors: true,       // 启用CORS
  },
  preview: {
    host: '0.0.0.0', // 预览模式也允许网络访问
    port: 4173,      // 预览端口
    strictPort: true,
    open: true,
  },
});
