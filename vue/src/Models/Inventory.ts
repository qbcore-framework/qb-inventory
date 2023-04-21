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
    // Load json for testing
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

    const items = new Array(data.slots);
    data.inventory.forEach(item => {
      // Do -1 to account for lua 1-indexing
      items[item.slot - 1] = item;
    });

    console.log(items);

    this.items.value = items;
  }

  public Close() {
    this.isVisible.value = false;
    this._httpClient.Get("CloseInventory");
  }
}

export { Inventory };