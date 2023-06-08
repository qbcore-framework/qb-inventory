import { ContainerBase } from "./ContainerBase";
import { Item } from "../Item/Item";
import MaxAmmo from "../Interfaces/MaxAmmo";

class PlayerInventory extends ContainerBase<Item> {
  constructor() {
    super();
  }

  getId(): string {
    return "player";
  }

  getName(): string {
    return "Inventory";
  }

  UpdateContents(items: Item[], maxWeight: number, maxAmmo: MaxAmmo, ammo: []) {
    this._UpdateContents(items, maxWeight, maxAmmo, ammo);
  }
}

export { PlayerInventory };
