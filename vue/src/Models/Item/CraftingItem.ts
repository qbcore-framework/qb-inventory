import { ItemCtorParams } from "../Interfaces/ItemCtorParams";
import { Item } from "./Item";

class CraftingItem extends Item {
  constructor(data: ItemCtorParams) {
    super(data);
  }
}

export { CraftingItem };
