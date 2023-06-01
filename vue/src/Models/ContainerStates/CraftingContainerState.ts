import { Container } from "../Container";
import { OpenInventoryDto } from "../Dto/OpenInventory";
import { IInventoryState } from "../Interfaces/IInventoryState";

class CraftingContainerState implements IInventoryState {
  constructor(private readonly container: Container) {}

  getName(): string {
    throw new Error("Method not implemented.");
  }
  open(inventoryData: OpenInventoryDto): void {
    throw new Error("Method not implemented.");
  }
}

export { CraftingContainerState };
