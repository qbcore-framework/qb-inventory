import { Inventory } from "./Inventory";

class Container extends Inventory {
  public override Close(): void {
    this.Items.value = [];
  }
}

export { Container };