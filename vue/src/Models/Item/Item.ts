import { Combinable } from "../Interfaces/Combinable";

class Item {
  // Key used for inject/provide to track the currently selected item in the UI
  public static readonly SELECTED_ITEM = "selectedItem";
  public static readonly HOVERED_ITEM = "hoveredItem";

  constructor(
    public name: string,
    public amount: number,
    public info: object,
    public label: string,
    public description: string,
    public weight: number,
    public type: string,
    public unique: boolean,
    public usable: boolean,
    public image: string,
    public id: number,
    public shouldClose?: boolean,
    public combinable?: Combinable,
  ) {}

  get totalWeight(): number {
    return this.weight * this.amount;
  }

  canMerge(item: Item): boolean {
    if (item === null || item === undefined) return false;

    return this.name === item.name && !this.unique && !item.unique;
  }

  canSwap(item: Item): boolean {
    return this._canSwap(item) && item._canSwap(this);
  }

  split(amount: number): Item {
    if (amount > this.amount) {
      throw new Error("Cannot split item into more than it's amount");
    }

    this.amount -= amount;

    return new Item(
      this.name,
      amount,
      this.info,
      this.label,
      this.description,
      this.weight,
      this.type,
      this.unique,
      this.usable,
      this.image,
      this.id,
      this.shouldClose,
    );
  }

  isCombinableWith(item: Item): boolean {
    // QB doesn't check if items are combinable both ways, so we do it here
    if (this._isCombinableWith(item)) return true;
    if (item._isCombinableWith(this)) return true;

    return false;
  }

  /**
   * Combine two items together to create a new item.
   * @param item The item to combine with.
   */
  combineWith(item: Item): void {
    if (!this.isCombinableWith(item)) {
      throw new Error("Cannot combine items");
    }
  }

  protected _isCombinableWith(item: Item): boolean {
    if (this.combinable === undefined) return false;
    const itemName = item.name;

    return this.combinable.accept.includes(itemName);
  }

  // Internal method for checking if this items allows swapping with another item
  protected _canSwap(item: Item): boolean {
    return true;
  }
}

export { Item };
