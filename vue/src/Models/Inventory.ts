import { HttpClient } from "@/plugins/HttpClient";
import MaxAmmo from "./MaxAmmo";
import { Ref, ref } from "vue";
import Item from "./Item";

class Inventory {
  private items = ref<Item[]>([]);
  private isVisible = ref<boolean>(false);
  private readonly _httpClient: HttpClient;

  constructor() {
    this._httpClient = new HttpClient();
  }

  public get Items() { return this.items; }
  public get IsVisible() { return this.isVisible }

  public Open(data: {
    Ammo: [],
    inventory: Item[],
    maxammo: MaxAmmo,
    maxweight: number,
    slots: number,
  }) {
    this.isVisible.value = true;
    this.items.value = data.inventory;
  }

  public Close() {
    this.isVisible.value = false;
    this._httpClient.Get("CloseInventory");
  }
}

export { Inventory };