import { ModalButton } from "@/Models/Interfaces/ModalButton";
import { ref } from "vue";

class ModalPanelPlugin {
  public static readonly SERVICE_NAME = "modalPanel";

  isOpen = ref(false);
  title = ref("");
  description = ref("");
  buttons = ref<ModalButton[]>([]);

  async open(
    title: string,
    description: string,
    buttons: ModalButton[],
  ): Promise<any> {
    this.isOpen.value = true;
    this.title.value = title;
    this.description.value = description;
    this.buttons.value = buttons;

    return new Promise((resolve) => {
      // Resolve when button is clicked or modal is closed
      this.isOpen.value = true;
      this.buttons.value.forEach((button) => {
        button.onClick = () => {
          resolve(button.returnVal);
          this.close();
        };
      });
    });
  }

  close() {
    this.isOpen.value = false;
  }
}

export { ModalPanelPlugin };
