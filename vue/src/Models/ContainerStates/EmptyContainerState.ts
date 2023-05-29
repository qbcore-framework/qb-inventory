import { Container } from "../Container";
import { IInventoryState } from "./IInventoryState";

class EmptyContainerState implements IInventoryState {
  constructor(private readonly container: Container) {
    this.container.Items.value = new Array(20);
  }

  public getName(): string {
    // QB-Inventory uses this to indicate for unused "ground"
    return "0";
  }

  public open(): void {
    // Do nothing
  }
}

export { EmptyContainerState };
