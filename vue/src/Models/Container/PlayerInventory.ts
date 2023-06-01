import { ref } from "vue";
import { ContainerBase } from "./ContainerBase";
import { Item } from "../Item/Item";
import MaxAmmo from "../Interfaces/MaxAmmo";

class PlayerInventory extends ContainerBase<Item> {
  private _isVisible = ref(false);

  get isVisible() {
    return this._isVisible;
  }

  constructor() {
    super();
    window.addEventListener("inventory:close", () => this.Close());
  }

  getName(): string {
    return "player";
  }

  public Close() {
    this._isVisible.value = false;
    this._httpClient.Get("CloseInventory");
  }

  public Open() {
    this._isVisible.value = true;
  }

  UpdateContents(items: Item[], maxWeight: number, maxAmmo: MaxAmmo, ammo: []) {
    this._UpdateContents(items, maxWeight, maxAmmo, ammo);
  }
}

export { PlayerInventory };
