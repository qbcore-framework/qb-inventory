import { CraftingItem } from "../Item/CraftingItem";
import { ContainerBase } from "./ContainerBase";

class CraftingContainer extends ContainerBase<CraftingItem> {
  getName(): string {
    throw new Error("Method not implemented.");
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
}

export { CraftingContainer };
