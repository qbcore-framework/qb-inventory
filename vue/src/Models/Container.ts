import { Inventory } from "./Inventory";

class Container extends Inventory {
  public override Open(
    data: any & {
      name: string;
    }
  ): void {
    this.name = data.name;
    super.Open(data);
  }

  public override Close(): void {
    this.Items.value = [];
  }
}

export { Container };
