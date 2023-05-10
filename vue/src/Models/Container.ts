import { Inventory } from "./Inventory";

class Container extends Inventory {
  constructor() {
    super();
    this.Close();
  }

  public override Open(
    data: any & {
      name: string;
    }
  ): void {
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
