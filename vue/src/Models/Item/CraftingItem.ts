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

  /**
   * Checks if the given items can be used to craft this item
   * @param items List of items used to craft this item
   * @param amount Amount of items to craft
   * @returns True if the given items can be used to craft this item
   */
  canCraft(items: Item[], amount?: number) {
    if (amount === undefined) amount = 1;

    // Check if all required items are present in the correct amounts
    for (const requiredItemName in this.costs) {
      if (Object.prototype.hasOwnProperty.call(this.costs, requiredItemName)) {
        const requiredItemCount = this.costs[requiredItemName] * amount;
        const hasAmount = items
          .filter((item) => item.name === requiredItemName)
          .reduce((acc, item) => acc + item.amount, 0);
        if (hasAmount < requiredItemCount) return false;
      }
    }

    return true;
  }
}

export { CraftingItem };
