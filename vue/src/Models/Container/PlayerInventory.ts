import { ContainerBase } from "./ContainerBase";
import { Item } from "../Item/Item";
import MaxAmmo from "../Interfaces/MaxAmmo";

class PlayerInventory extends ContainerBase<Item> {
  constructor() {
    super();
  }

  getName(): string {
    return "player";
  }

  UpdateContents(items: Item[], maxWeight: number, maxAmmo: MaxAmmo, ammo: []) {
    this._UpdateContents(items, maxWeight, maxAmmo, ammo);
  }
}

export { PlayerInventory };
