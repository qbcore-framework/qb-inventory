import { ref } from "vue";
import { ContainerBase } from "./ContainerBase";

class PlayerInventory extends ContainerBase {
  private isVisible = ref(false);

  constructor() {
    super();
    window.addEventListener("inventory:close", () => this.Close()); 
  }
  
  getName(): string {
    return "player";
  }

  public Close() {
    this.isVisible.value = false;
    this._httpClient.Get("CloseInventory");
  }
}

export { PlayerInventory };
