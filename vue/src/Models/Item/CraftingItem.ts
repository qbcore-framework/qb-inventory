import { ItemCtorParams } from "../Interfaces/ItemCtorParams";
import { Item } from "./Item";

class CraftingItem extends Item {
  constructor(data: ItemCtorParams) {
    super(data);
  }

  override _canSwap(item: Item): boolean {
    // Craft items can never be swapped as their container is ephemeral
    return false;
  }
}

export { CraftingItem };
