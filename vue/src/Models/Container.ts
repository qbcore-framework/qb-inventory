import { CraftingContainerState } from "./ContainerStates/CraftingContainerState";
import { EmptyContainerState } from "./ContainerStates/EmptyContainerState";
import { StoredContainerState } from "./ContainerStates/StoredContainerState";
import { OpenInventoryDto } from "./Dto/OpenInventory";
import { Inventory } from "./Inventory";

class Container extends Inventory {
  constructor() {
    super();
    this.Close();
  }

  public UpdateState(data: OpenInventoryDto | undefined) {
    if (data === undefined) {
      // Player is not opening an existing container
      console.log("open empty container");
      this.state = new EmptyContainerState(this);
    } else if (data.name === "crafting") {
      // Player is opening a crafting table
      // TODO: Implement crafting table
      this.state = new CraftingContainerState(this);
      console.log("open crafting table");
    } else {
      // Player is opening an existing container
      console.log("open standard container");
      this.state = new StoredContainerState(this, data);
    }
  }
}

export { Container };
