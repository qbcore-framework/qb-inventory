import { Container } from "../Container";
import { OpenInventoryDto } from "../Dto/OpenInventory";
import { IInventoryState } from "../Interfaces/IInventoryState";

/**
 * Used when opening a container with items e.g. a trunk, glovebox, stash, etc.
 */
class StandardContainerState implements IInventoryState {
  constructor(
    private readonly container: Container,
    inventoryData: OpenInventoryDto
  ) {
    console.log("StandardContainerState", inventoryData);

    this.open(inventoryData);
    this.name = inventoryData.name;
  }

  private name: string;

  public getName(): string {
    return this.name;
  }

  public open(inventoryData: OpenInventoryDto): void {
    this.container.Items.value = inventoryData.items;
    this.name = inventoryData.name;
  }
}

export { StandardContainerState };
