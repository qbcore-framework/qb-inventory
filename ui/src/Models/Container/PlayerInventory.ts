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
    if (combineAbleData === undefined)
      throw new Error("Item is not combinable");

    if (combineAbleData.anim) {
      const body = {
        combineData: combineAbleData,
        usedItem: toItem.name,
        requiredItem: fromItem.name,
      };

      this._httpClient.Post("combineWithAnim", body);
    } else {
      const body = {
        reward: combineAbleData.reward,
        toItem: toItem.name,
        fromItem: fromItem.name,
      };

      this._httpClient.Post("combineItem", body);
    }
    this.Close();
  }
}

export { PlayerInventory };
