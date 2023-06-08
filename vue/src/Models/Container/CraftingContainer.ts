import { CraftingItem } from "../Item/CraftingItem";
import { Item } from "../Item/Item";
import { ContainerBase } from "./ContainerBase";

class CraftingContainer extends ContainerBase<CraftingItem> {
  getId(): string {
    return "crafting";
  }

  getName(): string {
    return "Crafting Table";
  }

  UpdateContents(items: CraftingItem[], maxWeight: number) {
    this._UpdateContents(
      items,
      maxWeight,
      {
        pistol: 0,
        shotgun: 0,
        rifle: 0,
        smg: 0,
      },
      []
    );
  }

  override MoveItem(
    fromSlot: number,
    toSlot: number,
    toInventory: ContainerBase<Item>,
    amount?: number
  ): void {
    // Check if toInventory contains the items required to craft the item being moved
    const craftItem = this.Items.value[fromSlot];
    if (craftItem === undefined || craftItem === null) return;

    // Check if toInventory contains the items required to craft the item being moved
    if (!craftItem.canCraft(toInventory.Items.value, amount)) return;

    super.MoveItem(fromSlot, toSlot, toInventory, amount);

    // Remove the items required to craft the item being moved
    toInventory.Items.value = craftItem.removeCraftingItems(
      toInventory.Items.value,
      amount
    );
  }

  override QuickMoveItem(
    fromSlot: number,
    toInventory: ContainerBase<Item>,
    amount?: number
  ): void {
    // Check if toInventory contains the items required to craft the item being moved
    const craftItem = this.Items.value[fromSlot];
    if (craftItem === undefined || craftItem === null) return;

    // Check if toInventory contains the items required to craft the item being moved
    if (!craftItem.canCraft(toInventory.Items.value, amount)) return;

    super.QuickMoveItem(fromSlot, toInventory, amount);
  }
}

export { CraftingContainer };
