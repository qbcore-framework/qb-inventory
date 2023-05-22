import MaxAmmo from "./Interfaces/MaxAmmo";
import { Inventory } from "./Inventory";
import { Item } from "./Item";

class Container extends Inventory {
  constructor() {
    super();
    this.Close();
  }

  public override Open(data: {
    ammo: [];
    items: Item[];
    maxAmmo: MaxAmmo;
    maxWeight: number;
    name: string;
  }): void {
    this.name = data.name;
    super.Open(data);
  }

  public override Close(): void {
    this.Items.value = new Array(20);
    // QB-Inventory uses this to indicate for unused "ground"
    this.name = "0";
  }
}

export { Container };
