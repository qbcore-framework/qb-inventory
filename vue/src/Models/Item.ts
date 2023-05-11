class Item {
  name: string;
  amount: number;
  info: object;
  label: string;
  description: string;
  weight: number;
  type: string;
  unique: boolean;
  usable: boolean;
  image: string;
  id: number;
  shouldClose?: boolean;

  constructor(data: any) {
    this.name = data.name;
    this.amount = data.amount;
    this.info = data.info;
    this.label = data.label;
    this.description = data.description;
    this.weight = data.weight;
    this.type = data.type;
    this.unique = data.unique;
    this.usable = data.usable;
    this.image = data.image;
    this.id = data.id;
    this.shouldClose = data.shouldClose;
  }

  canMerge(item: Item): boolean {
    if (item === null || item === undefined) return false;

    return (
      this.name === item.name &&
      !this.unique &&
      !item.unique
    );
  }
}

export default Item;