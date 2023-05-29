import { OpenInventoryDto } from "../Dto/OpenInventory";
import { Inventory } from "../Inventory";
import { IInventoryState } from "../Interfaces/IInventoryState";

/**
 * Used for opening the player's inventory.
 */
class PLayerInventoryState implements IInventoryState {
  constructor(private readonly container: Inventory) {}

  public getName(): string {
    return "player";
  }

  public open(inventoryData: OpenInventoryDto): void {
    this.container.Items.value = inventoryData.items;
  }
}

export { PLayerInventoryState };
