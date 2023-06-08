import { Ref, ref } from "vue";
import { Item } from "../Item/Item";
import { HttpClient } from "@/plugins/HttpClient";
import MaxAmmo from "../Interfaces/MaxAmmo";

abstract class ContainerBase<TItem extends Item> {
  readonly Items = ref<TItem[]>([]) as Ref<TItem[]>;
  protected readonly _httpClient = new HttpClient();
  private _isVisible = ref(false);

  get isVisible() {
    return this._isVisible;
  }

  private _maxWeight = ref(0);

  public get maxWeight() {
    return this._maxWeight;
  }

  abstract getId(): string;
  abstract getName(): string;

  constructor() {
    window.addEventListener("inventory:close", () => this.Close());
  }

  public Close() {
    this._isVisible.value = false;
    // TODO: Move this to NUI event handler
    this._httpClient.Get("CloseInventory");
  }

  public Open() {
    this._isVisible.value = true;
  }

  protected _UpdateContents(
    items: TItem[],
    maxWeight: number,
    maxAmmo: MaxAmmo,
    ammo: []
  ) {
    this.Items.value = items;
    this._maxWeight.value = maxWeight;
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
    toInventory?: ContainerBase<Item>,
    amount?: number
  ) {
    // eslint-disable-next-line @typescript-eslint/no-this-alias
    if (!toInventory) toInventory = this;
    // Cant move negative amount of items
    if (amount !== undefined && amount <= 0) return;

    // Don't allow moving to same slot if inventory is the same
    if (fromSlot == toSlot && this == toInventory) return;

    const fromItem = this.Items.value[fromSlot];
    const toItem: Item = toInventory.Items.value[toSlot];

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
      fromInventory: this.getId(),
      toInventory: toInventory.getId(),
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
        if (fromItem.amount <= 0) delete this.Items.value[fromSlot];
      }
      // Swap items
      else {
        // Check if items can be swapped
        if (fromItem.canSwap(toItem)) {
          this.Items.value[fromSlot] = toItem as TItem;
          toInventory.Items.value[toSlot] = fromItem;
        }
      }
    }
    // Handle moving or splitting items
    else {
      // Check if items are being split
      if (amount < fromItem.amount) {
        // Split items
        const newItem: Item = fromItem.split(amount);

        toInventory.Items.value[toSlot] = newItem;
      }
      // Move items
      else {
        toInventory.Items.value[toSlot] = fromItem;
        delete this.Items.value[fromSlot];
      }
    }
  }

  public QuickMoveItem(
    fromSlot: number,
    toInventory: ContainerBase<Item>,
    amount?: number
  ) {
    const fromItem = this.Items.value[fromSlot];

    // If there is no item in the from slot, don't move
    if (!fromItem) return;

    // Check if there it can merge with any items in the to inventory
    let toSlot = toInventory.Items.value.findIndex((item) =>
      fromItem.canMerge(item)
    );

    // If there is no item to merge with, find a slot with no item
    if (toSlot === -1) {
      toSlot = toInventory.Items.value.findIndex((item) => !item);
    }
    // If there is no empty slot, don't move
    if (toSlot === -1) return;

    this.MoveItem(fromSlot, toSlot, toInventory, amount);
  }
}

export { ContainerBase };
