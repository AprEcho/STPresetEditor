<script setup>
import { ref, computed } from 'vue';
import { usePresetStore } from '../stores/presetStore';
import { TransitionRoot, TransitionChild, Dialog, DialogPanel, DialogTitle } from '@headlessui/vue';
import { ArrowDownTrayIcon, DocumentTextIcon, ExclamationTriangleIcon } from '@heroicons/vue/24/outline';

const store = usePresetStore();
const jsonInput = ref('');
const isDragOver = ref(false);
const errorMessage = ref('');
const isImporting = ref(false);
const fileInput = ref(null);

const hasContent = computed(() => jsonInput.value.trim().length > 0);
const isValidJson = computed(() => {
  if (!hasContent.value) return false;
  try {
    JSON.parse(jsonInput.value);
    return true;
  } catch {
    return false;
  }
});

function handleFileSelect(event) {
  const file = event.target.files[0];
  if (file) {
    readFile(file);
  }
}

function readFile(file) {
  if (file.type !== 'application/json' && !file.name.endsWith('.json')) {
    errorMessage.value = '请选择有效的 JSON 文件';
    return;
  }

  const reader = new FileReader();
  reader.onload = (e) => {
    jsonInput.value = e.target.result;
    errorMessage.value = '';
  };
  reader.onerror = () => {
    errorMessage.value = '读取文件时发生错误';
  };
  reader.readAsText(file);
}

function handleDragOver(event) {
  event.preventDefault();
  isDragOver.value = true;
}

function handleDragLeave() {
  isDragOver.value = false;
}

function handleDrop(event) {
  event.preventDefault();
  isDragOver.value = false;
  
  const files = event.dataTransfer.files;
  if (files.length > 0) {
    readFile(files[0]);
  }
}

function importJson() {
  if (!isValidJson.value) {
    errorMessage.value = '请输入有效的 JSON 格式';
    return;
  }

  isImporting.value = true;
  errorMessage.value = '';

  try {
    store.importNewJson(jsonInput.value);
    store.closeImportModal();
    // 重置状态
    jsonInput.value = '';
    isImporting.value = false;
  } catch (error) {
    errorMessage.value = `导入失败: ${error.message}`;
    isImporting.value = false;
  }
}

function clearInput() {
  jsonInput.value = '';
  errorMessage.value = '';
}

function openFileDialog() {
  fileInput.value?.click();
}
</script>

<template>
  <TransitionRoot appear :show="store.isImportModalOpen" as="template">
    <Dialog as="div" class="relative z-50" @close="store.closeImportModal">
      <TransitionChild
        as="template"
        enter="duration-300 ease-out"
        enter-from="opacity-0"
        enter-to="opacity-100"
        leave="duration-200 ease-in"
        leave-from="opacity-100"
        leave-to="opacity-0"
      >
        <div class="fixed inset-0 bg-black/30" />
      </TransitionChild>

      <div class="fixed inset-0 overflow-y-auto">
        <div class="flex min-h-full items-center justify-center p-4 text-center">
          <TransitionChild
            as="template"
            enter="duration-300 ease-out"
            enter-from="opacity-0 scale-95"
            enter-to="opacity-100 scale-100"
            leave="duration-200 ease-in"
            leave-from="opacity-100 scale-100"
            leave-to="opacity-0 scale-95"
          >
            <DialogPanel
              class="w-full max-w-4xl transform overflow-hidden rounded-2xl bg-white p-6 text-left align-middle shadow-xl transition-all"
            >
              <DialogTitle
                as="h3"
                class="flex items-center text-lg leading-6 font-medium text-gray-900"
              >
                <ArrowDownTrayIcon class="mr-2 h-6 w-6 text-blue-600" />
                导入预设文件
              </DialogTitle>
              
              <div class="mt-2">
                <p class="text-sm text-gray-500">
                  选择或拖拽你的 <code class="bg-gray-100 px-1 py-0.5 rounded">preset.json</code> 文件，或直接粘贴 JSON 内容到下方文本框。
                </p>
              </div>

              <!-- 文件上传区域 -->
              <div class="mt-4">
                <div
                  class="relative rounded-lg border-2 border-dashed border-gray-300 p-6 text-center hover:border-gray-400 transition-colors"
                  :class="{ 'border-blue-500 bg-blue-50': isDragOver }"
                  @dragover="handleDragOver"
                  @dragleave="handleDragLeave"
                  @drop="handleDrop"
                >
                  <DocumentTextIcon class="mx-auto h-12 w-12 text-gray-400" />
                  <div class="mt-2">
                    <p class="text-sm text-gray-600">
                      <span class="font-medium text-blue-600 hover:text-blue-500 cursor-pointer" @click="openFileDialog">
                        点击选择文件
                      </span>
                      或拖拽文件到此处
                    </p>
                    <p class="text-xs text-gray-500 mt-1">支持 .json 文件</p>
                  </div>
                </div>
                
                <!-- 隐藏的文件输入 -->
                <input
                  ref="fileInput"
                  type="file"
                  accept=".json,application/json"
                  class="hidden"
                  @change="handleFileSelect"
                />
              </div>

              <!-- 分隔线 -->
              <div class="mt-4 flex items-center">
                <div class="flex-1 border-t border-gray-300"></div>
                <span class="px-3 text-sm text-gray-500">或直接粘贴内容</span>
                <div class="flex-1 border-t border-gray-300"></div>
              </div>

              <!-- JSON 输入区域 -->
              <div class="mt-4">
                <div class="flex items-center justify-between mb-2">
                  <label class="block text-sm font-medium text-gray-700">JSON 内容</label>
                  <button
                    v-if="hasContent"
                    type="button"
                    class="text-sm text-gray-500 hover:text-gray-700"
                    @click="clearInput"
                  >
                    清空
                  </button>
                </div>
                
                <textarea
                  v-model="jsonInput"
                  class="h-64 w-full rounded-md border border-gray-300 p-3 font-mono text-sm transition focus:border-blue-500 focus:ring-2 focus:ring-blue-500"
                  :class="{ 'border-red-300 focus:border-red-500 focus:ring-red-500': errorMessage }"
                  placeholder='{&#10;  "prompts": [...],&#10;  "prompt_order": [...]&#10;}'
                />
              </div>

              <!-- 错误信息 -->
              <div v-if="errorMessage" class="mt-3 flex items-center text-sm text-red-600">
                <ExclamationTriangleIcon class="mr-2 h-5 w-5" />
                {{ errorMessage }}
              </div>

              <!-- 验证状态 -->
              <div v-if="hasContent" class="mt-2 text-sm">
                <span v-if="isValidJson" class="text-green-600">✓ JSON 格式有效</span>
                <span v-else class="text-red-600">✗ JSON 格式无效</span>
              </div>

              <div class="mt-6 flex justify-end space-x-3">
                <button
                  type="button"
                  class="inline-flex justify-center rounded-md border border-transparent bg-gray-100 px-4 py-2 text-sm font-medium text-gray-700 transition-colors hover:bg-gray-200 focus:outline-none focus-visible:ring-2 focus-visible:ring-gray-500 focus-visible:ring-offset-2"
                  @click="store.closeImportModal"
                >
                  取消
                </button>
                <button
                  type="button"
                  :disabled="!isValidJson || isImporting"
                  class="inline-flex justify-center rounded-md border border-transparent px-4 py-2 text-sm font-medium text-white transition-colors focus:outline-none focus-visible:ring-2 focus-visible:ring-offset-2 disabled:opacity-50 disabled:cursor-not-allowed"
                  :class="isValidJson ? 'bg-blue-600 hover:bg-blue-700 focus-visible:ring-blue-500' : 'bg-gray-400'"
                  @click="importJson"
                >
                  <ArrowDownTrayIcon v-if="!isImporting" class="mr-2 -ml-1 h-5 w-5" />
                  <span v-if="isImporting">导入中...</span>
                  <span v-else>导入预设</span>
                </button>
              </div>
            </DialogPanel>
          </TransitionChild>
        </div>
      </div>
    </Dialog>
  </TransitionRoot>
</template>
