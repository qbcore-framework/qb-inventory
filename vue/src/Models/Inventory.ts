import { HttpClient } from "@/plugins/HttpClient";
import MaxAmmo from "./Interfaces/MaxAmmo";
import { Ref, ref } from "vue";
import { Item } from "./Item";
import { Weapon } from "./Weapon";
class Inventory {
  private items = ref<Item[]>([]);
  private isVisible = ref<boolean>(false);
  protected name = "player";

  protected readonly _httpClient: HttpClient;

  constructor() {
    this._httpClient = new HttpClient();
    window.addEventListener("inventory:close", () => this.Close());
  }

  public get Items(): Ref<Item[]> {
    return this.items;
  }
  public get IsVisible() {
    return this.isVisible;
  }
  public get Name() {
    return this.name;
  }

  public Open(data: {
    ammo: [];
    items: Item[];
    maxAmmo: MaxAmmo;
    maxWeight: number;
  }) {
    this.isVisible.value = true;
    this.items.value = data.items;
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
    // eslint-disable-next-line @typescript-eslint/no-this-alias
    if (!toInventory) toInventory = this;
    // Cant move negative amount of items
    if (amount !== undefined && amount <= 0) return;

    // Don't allow moving to same slot if inventory is the same
    if (fromSlot == toSlot && this == toInventory) return;

    const fromItem: Item = this.items.value[fromSlot];
    const toItem: Item = toInventory.items.value[toSlot];

    // If there is no item in the from slot, don't move
    if (!fromItem) return;

    // If amount is not set, move all items
    if (amount === undefined) amount = fromItem.amount;
    // Can't move more items than there are in the slot
    if (amount > fromItem.amount) return;
    // Can't split items if there is a different item in the to slot (causes items to disappear)
    if (toItem && amount < fromItem.amount && toItem.name !== fromItem.name)
      return;

    const body = {
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
      if (fromItem.canMerge(toItem)) {
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
        const newItem: Item = new Item(fromItem);
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

  public QuickMoveItem(
    fromSlot: number,
    toInventory: Inventory,
    amount?: number
  ) {
    const fromItem: Item = this.items.value[fromSlot];

    // If there is no item in the from slot, don't move
    if (!fromItem) return;

    // Check if there it can merge with any items in the to inventory
    let toSlot = toInventory.items.value.findIndex((item: Item) =>
      fromItem.canMerge(item)
    );

    // If there is no item to merge with, find a slot with no item
    if (toSlot === -1) {
      toSlot = toInventory.items.value.findIndex((item: Item) => !item);
    }
    // If there is no empty slot, don't move
    if (toSlot === -1) return;

    this.MoveItem(fromSlot, toSlot, toInventory, amount);
  }
}

export { Inventory };
