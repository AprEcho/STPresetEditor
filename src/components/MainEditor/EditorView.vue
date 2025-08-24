<template>
  <div class="flex h-full flex-col">
    <div class="mb-2 flex flex-shrink-0 items-center justify-between">
      <h2 class="text-lg font-semibold">编辑器</h2>
      <div class="flex items-center space-x-4">
        <!-- 全局收缩/展开切换按钮 -->
        <div class="flex items-center space-x-2">
          <button
            class="inline-flex items-center rounded-md border border-gray-300 bg-white px-3 py-1.5 text-sm font-medium text-gray-700 shadow-sm transition-colors hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:ring-offset-2"
            @click="handleGlobalToggle"
            :class="{ 'bg-blue-50 text-blue-700 border-blue-300': store.globalCollapseState }"
            title="切换所有提示词的收缩/展开状态"
          >
            <ChevronUpIcon v-if="store.globalCollapseState" class="mr-1 h-4 w-4" />
            <ChevronDownIcon v-else class="mr-1 h-4 w-4" />
            {{ store.globalCollapseState ? '全部展开' : '全部收缩' }}
          </button>
        </div>

        <!-- 模式切换开关 -->
        <SwitchGroup as="div" class="mx-2 flex items-center">
          <SwitchLabel as="span" class="mr-2 text-sm font-medium text-gray-900">
            {{ isPreviewMode ? '预览模式' : '原始模式' }}
          </SwitchLabel>
          <Switch
            :model-value="isPreviewMode"
            :class="isPreviewMode ? 'bg-green-500' : 'bg-gray-400'"
            class="relative inline-flex h-6 w-11 flex-shrink-0 cursor-pointer rounded-full border-2 border-transparent transition-colors duration-200 ease-in-out"
            @update:model-value="store.toggleMacroDisplayMode()"
          >
            <span
              aria-hidden="true"
              :class="isPreviewMode ? 'translate-x-5' : 'translate-x-0'"
              class="pointer-events-none relative inline-block h-5 w-5 transform rounded-full bg-white shadow ring-0 transition duration-200 ease-in-out"
            >
              <span
                :class="isPreviewMode ? 'opacity-0 duration-100 ease-out' : 'opacity-100 duration-200 ease-in'"
                class="absolute inset-0 flex h-full w-full items-center justify-center transition-opacity"
                aria-hidden="true"
              >
                <CodeBracketIcon class="h-3 w-3 text-gray-400" />
              </span>
              <span
                :class="isPreviewMode ? 'opacity-100 duration-200 ease-in' : 'opacity-0 duration-100 ease-out'"
                class="absolute inset-0 flex h-full w-full items-center justify-center transition-opacity"
                aria-hidden="true"
              >
                <EyeIcon class="h-3 w-3 text-green-600" />
              </span>
            </span>
          </Switch>
        </SwitchGroup>
      </div>
    </div>
    <div class="overflow-y-auto">
      <draggable v-model="prompts" tag="div" item-key="id" class="space-y-4" handle=".cursor-grab">
        <template #item="{ element }">
          <PromptCard
            :ref="(el) => { if (el) promptCardRefs[element.id] = el; }"
            :prompt="element"
            :is-collapsed="store.promptCollapseStates[element.id]"
            @toggle-collapse="toggleSingleCard(element.id)"
          />
        </template>
      </draggable>
    </div>
  </div>
</template>

<script setup>
import { computed, ref, watch, onBeforeUpdate } from 'vue';
import { usePresetStore } from '../../stores/presetStore';
import PromptCard from './PromptCard.vue';
import draggable from 'vuedraggable';
import { Switch, SwitchGroup, SwitchLabel } from '@headlessui/vue';
import { 
  EyeIcon, 
  CodeBracketIcon,
  ChevronDownIcon,
  ChevronUpIcon
} from '@heroicons/vue/20/solid';

const store = usePresetStore();
const promptCardRefs = ref({});

const isPreviewMode = computed(() => store.macroDisplayMode === 'preview');

// 处理全局切换 - 统一所有卡片状态
const handleGlobalToggle = () => {
  // 切换全局状态
  const newGlobalState = !store.globalCollapseState;
  store.globalCollapseState = newGlobalState;
  
  // 将所有卡片状态同步为全局状态
  Object.keys(store.prompts).forEach(promptId => {
    store.promptCollapseStates[promptId] = newGlobalState;
  });
};

// 处理单个卡片切换
const toggleSingleCard = (promptId) => {
  // 只切换当前卡片的状态
  store.promptCollapseStates[promptId] = !store.promptCollapseStates[promptId];
  
  // 检查是否所有卡片状态都相同，如果不同则全局状态设为与大多数一致
  syncGlobalStateWithCards();
};

// 同步全局状态与卡片状态
const syncGlobalStateWithCards = () => {
  const collapseStates = Object.values(store.promptCollapseStates);
  if (collapseStates.length === 0) return;
  
  // 计算收缩状态的数量
  const collapsedCount = collapseStates.filter(state => state).length;
  const expandedCount = collapseStates.length - collapsedCount;
  
  // 根据多数卡片的状态设置全局状态
  store.globalCollapseState = collapsedCount >= expandedCount;
};

onBeforeUpdate(() => {
  promptCardRefs.value = {};
});

const prompts = computed({
  get() {
    return store.orderedPrompts;
  },
  set(newOrder) {
    store.updatePromptOrder(newOrder);
  },
});

watch(
  () => store.scrollToPromptId,
  (newId) => {
    if (newId) {
      const cardComponent = promptCardRefs.value[newId];
      if (cardComponent) {
        const element = cardComponent.$el;
        element.scrollIntoView({ behavior: 'smooth', block: 'start' });

        // 闪烁动画
        element.classList.add('flash-highlight');
        window.setTimeout(() => {
          element.classList.remove('flash-highlight');
          store.clearScrollToRequest();
        }, 1500);
      }
    }
  },
);
</script>

<style scoped>
@keyframes flash {
  0% { background-color: rgba(74, 144, 226, 0); }
  50% { background-color: rgba(74, 144, 226, 0.2); }
  100% { background-color: rgba(74, 144, 226, 0); }
}

.flash-highlight {
  animation: flash 1.5s ease-out;
}
</style>
    