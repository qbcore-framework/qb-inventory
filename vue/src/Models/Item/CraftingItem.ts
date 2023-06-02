import { Item } from "./Item";

class CraftingItem extends Item {
  info: { costs: string };
  costs: { [key: string]: number };

  constructor(
    costs: { [key: string]: number },
    name: string,
    amount: number,
    info: { costs: string },
    label: string,
    description: string,
    weight: number,
    type: string,
    unique: boolean,
    usable: boolean,
    image: string,
    id: number,
    shouldClose?: boolean
  ) {
    // eslint-disable-next-line prettier/prettier
    super(name, amount, info, label, description, weight, type, unique, usable, image, id, shouldClose);
    this.info = info;
    this.costs = costs;
  }

  override _canSwap(item: Item): boolean {
    // Craft items can never be swapped as their container is ephemeral
    return false;
  }
}

export { CraftingItem };
