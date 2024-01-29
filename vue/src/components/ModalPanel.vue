<template>
  <TransitionRoot as="template" :show="open">
    <Dialog as="div" class="relative z-10" @close="open = false">
      <TransitionChild
        as="template"
        enter="ease-out duration-300"
        enter-from="opacity-0"
        enter-to="opacity-100"
        leave="ease-in duration-200"
        leave-from="opacity-100"
        leave-to="opacity-0"
      >
        <div
          class="fixed inset-0 bg-gray-500 bg-opacity-75 transition-opacity"
        />
      </TransitionChild>

      <div class="fixed inset-0 z-10 w-screen overflow-y-auto">
        <div
          class="flex min-h-full items-end justify-center p-4 text-center sm:items-center sm:p-0"
        >
          <TransitionChild
            as="template"
            enter="ease-out duration-300"
            enter-from="opacity-0 translate-y-4 sm:translate-y-0 sm:scale-95"
            enter-to="opacity-100 translate-y-0 sm:scale-100"
            leave="ease-in duration-200"
            leave-from="opacity-100 translate-y-0 sm:scale-100"
            leave-to="opacity-0 translate-y-4 sm:translate-y-0 sm:scale-95"
          >
            <DialogPanel
              class="relative transform overflow-hidden text-left shadow-xl transition-all sm:my-8 sm:w-full sm:max-w-lg"
            >
              <div
                class="bg-gray-400 text-gray-900 px-4 pb-4 pt-5 sm:p-6 sm:pb-4"
              >
                <div class="sm:flex sm:items-start">
                  <div class="mt-3 text-center sm:ml-4 sm:mt-0 sm:text-left">
                    <DialogTitle
                      as="h3"
                      class="text-base font-semibold leading-6 text-gray-900"
                    >
                      {{ title }}
                    </DialogTitle>
                    <div class="mt-2">
                      <p class="text-sm" v-html="description" />
                    </div>
                  </div>
                </div>
              </div>
              <div
                class="bg-gray-500 px-4 py-3 sm:flex sm:flex-row-reverse sm:px-6"
              >
                <button
                  type="button"
                  class="inline-flex w-full justify-center bg-gray-700 border px-3 py-2 text-sm font-semibold text-white shadow-sm hover:bg-gray-10 sm:ml-3 sm:w-auto"
                  v-for="modalButton in buttons"
                  :key="modalButton.text"
                  @click="modalButton.onClick()"
                >
                  {{ modalButton.text }}
                </button>
              </div>
            </DialogPanel>
          </TransitionChild>
        </div>
      </div>
    </Dialog>
  </TransitionRoot>
</template>

<script setup lang="ts">
import { inject, ref } from "vue";
import {
  Dialog,
  DialogPanel,
  DialogTitle,
  TransitionChild,
  TransitionRoot,
} from "@headlessui/vue";
import { ModalPanelPlugin } from "@/plugins/ModalPanelPlugin";

// eslint-disable-next-line @typescript-eslint/no-non-null-assertion
const modalPanel = inject<ModalPanelPlugin>(ModalPanelPlugin.SERVICE_NAME)!;

const title = ref(modalPanel.title);
const description = ref(modalPanel.description);
const open = ref(modalPanel.isOpen);
const buttons = ref(modalPanel.buttons);
</script>
