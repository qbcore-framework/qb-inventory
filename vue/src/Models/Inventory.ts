import { HttpClient } from "@/plugins/HttpClient";
import MaxAmmo from "./MaxAmmo";
import { ref } from "vue";
import Item from "./Item";
class Inventory {
  private items = ref<Item[]>([]);
  private isVisible = ref<boolean>(false);
  protected name = "player";

  protected readonly _httpClient: HttpClient;

  constructor() {
    this._httpClient = new HttpClient();
  }

  public get Items() {
    return this.items;
  }
  public get IsVisible() {
    return this.isVisible;
  }
  public get Name() {
    return this.name;
  }

  public Open(data: {
    Ammo: [];
    inventory: any;
    maxammo: MaxAmmo;
    maxweight: number;
    slots: number;
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

    // Remove slot from items since this causes issues with 1 based indexing
    data.inventory.forEach((item: Item) => {
      // Client returns null for empty slots
      if (item === null) return;
      // @ts-ignore
      items[item.slot - 1] = item;
      // @ts-ignore
      delete item.slot;
    });

    this.items.value = items;
  }

  public Close() {
    this.isVisible.value = false;
    this._httpClient.Get("CloseInventory");
  }

  /**
   *  Move items from one inventory to another or within the same inventory.
   *
   * @param fromSlot Index of item to move
   * @param toSlot Index of item to move to
   * @param toInventory Inventory to move item to, if this is not set, the item will be moved to the same inventory
   */
  public MoveItem(
    fromSlot: number,
    toSlot: number,
    toInventory?: Inventory,
    amount?: number
  ) {
    if (!toInventory) toInventory = this;
    // Cant move negative amount of items
    if (amount !== undefined && amount <= 0) return;

    // Don't allow moving to same slot if inventory is the same
    if (fromSlot == toSlot && this == toInventory) return;

    const fromItem = this.items.value[fromSlot];
    const toItem = toInventory.items.value[toSlot] || null;

    // If amount is not set, move all items
    if (amount === undefined) amount = fromItem.amount;
    // Can't move more items than there are in the slot
    if (amount > fromItem.amount) return;
    // Can't split items if there is a different item in the to slot (causes items to dissapear)
    if (amount < fromItem.amount && toItem.name !== fromItem.name) return;

    // If there is no item in the from slot, don't move
    if (!fromItem) return;

    const body: any = {
      fromInventory: this.Name,
      toInventory: toInventory.Name,
      fromSlot: fromSlot + 1,
      toSlot: toSlot + 1,
      fromAmount: amount || fromItem.amount,
    };

    this._httpClient.Post("SetInventoryData", body);

    // Handle stacking or swapping items
    if (toItem) {      
      // If item is the same, stack
      if (fromItem.name == toItem.name) {        
        toItem.amount += amount;
        fromItem.amount -= amount;

        // If there are no items left in the from slot, remove it
        if (fromItem.amount <= 0) delete this.items.value[fromSlot];
      } 
      // Swap items
      else {
        this.items.value[fromSlot] = toItem;
        toInventory.items.value[toSlot] = fromItem;
      }
    }
    // Handle moving or splitting items
    else {
      // Check if items are being split
      if (amount < fromItem.amount) {
        // Split items
        const newItem: Item = { ...fromItem };
        newItem.amount = amount;
        fromItem.amount -= amount;

        toInventory.items.value[toSlot] = newItem;
      }
      // Move items
      else {
        toInventory.items.value[toSlot] = fromItem;
        delete this.items.value[fromSlot];
      }
    }
  }
}

export { Inventory };
