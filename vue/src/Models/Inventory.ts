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
    inventory: any,
    maxammo: MaxAmmo,
    maxweight: number,
    slots: number,
  }) {
    this.isVisible.value = true;

    const items = new Array(data.slots);

    // If inventory is an object, convert it to an array
    if (!Array.isArray(data.inventory)) {
      const inventory: Item[] = [];

      for (const key in data.inventory) {
        inventory.push(data.inventory[key]);
      }

      data.inventory = inventory;
    }

    data.inventory.forEach((item: Item) => {
      // Do -1 to account for lua 1-indexing
      items[item.slot] = item;
    });

    this.items.value = items;
  }

  public Close() {
    this.isVisible.value = false;
    this._httpClient.Get("CloseInventory");
  }

  public SwapSlots(from: number, to: number) {
    const fromItem = this.items.value[from];
    const toItem = this.items.value[to] || null;

    // Update items on server
    const body: any = {
      fromInventory: "player",
      toInventory: "player",
      fromSlot: from,
      toSlot: to,
      fromAmount: fromItem?.amount,
    }

    if (toItem) {
      body.toAmount = toItem.amount;
    }

    this._httpClient.Post("SetInventoryData", body);

    // Update items in vue
    this.items.value[from] = toItem;
    this.items.value[to] = fromItem;
  }
}

export { Inventory };