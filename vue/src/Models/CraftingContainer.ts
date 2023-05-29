import { Inventory } from "./Inventory";
import { Item } from "./Item";

class CraftingContainer extends Inventory {
  override MoveItem(
    fromSlot: number,
    toSlot: number,
    toInventory: Inventory,
    amount?: number
  ) {
    // TODO: Check if crafting is possible
    // TODO: Remove items from inventory
    // TODO: Can't swap items
    super.MoveItem(fromSlot, toSlot, toInventory, amount);
  }

  override QuickMoveItem(
    fromSlot: number,
    toInventory: Inventory,
    amount?: number
  ) {
    // TODO: Check if crafting is possible
    // TODO: Remove items from inventory
    super.QuickMoveItem(fromSlot, toInventory, amount);
  }

  /**
   * Checks if inventory has the required items to craft the item
   * @param item item to craft
   * @param amount amount of items to craft
   * @param inventory inventory containing resources used to craft
   */
  private CanCraft(item: Item, amount: number, inventory: Inventory): boolean {
    // const requiredItems: {
    //   item: Item;
    //   amount: number;
    // }[] = item.recipe?.requiredItems ?? [];
    return false;
  }
}

export { CraftingContainer };
