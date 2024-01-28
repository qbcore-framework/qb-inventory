import { ModalButton } from "@/Models/Interfaces/ModalButton";
import { ref } from "vue";

class ModalPanel {
  isOpen = ref(true);
  title = ref("");
  description = ref("");
  buttons = ref<ModalButton[]>([]);

  open(title: string, description: string, buttons: ModalButton[]) {
    this.isOpen.value = true;
    this.title.value = title;
    this.description.value = description;
    this.buttons.value = buttons;
  }

  close() {
    this.isOpen.value = false;
  }
}

export { ModalPanel };
