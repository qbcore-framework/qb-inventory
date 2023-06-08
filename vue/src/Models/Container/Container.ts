import MaxAmmo from "../Interfaces/MaxAmmo";
import { Item } from "../Item/Item";
import { ContainerBase } from "./ContainerBase";

class Container extends ContainerBase<Item> {
  // "0" is the value used for opening the inventory when there are no stored containers nearby
  private _name = "0";

  getId(): string {
    return this._name;
  }

  getName(): string {
    return this._name === "0" ? "Ground" : this._name;
  }

  UpdateContents(
    name: string,
    items: Item[],
    maxWeight: number,
    maxAmmo: MaxAmmo,
    ammo: []
  ) {
    this._UpdateContents(items, maxWeight, maxAmmo, ammo);
    this._name = name;
  }
}

export { Container };
