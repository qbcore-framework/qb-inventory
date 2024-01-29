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

  CombineItems(fromSlot: number, toSlot: number) {
    if (fromSlot === toSlot) return;

    const fromItem = this.Items.value[fromSlot];
    const toItem = this.Items.value[toSlot];

    if (fromItem === undefined || toItem === undefined) return;

    const combineAbleData = toItem.combinable;
    if (combineAbleData === undefined) Error("Item is not combinable");

    const body = {
      combineData: combineAbleData,
      usedItem: toItem.name,
      requiredItem: fromItem.name,
    };

    this._httpClient.Post("combineWithAnim", body);
    this.Close();
  }
}

export { PlayerInventory };
