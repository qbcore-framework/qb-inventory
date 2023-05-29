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
    super.Open(data);
  }
}

export { Container };
