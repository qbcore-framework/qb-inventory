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
    public shouldClose?: boolean
  ) {}

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
      this.shouldClose
    );
  }

  // Internal method for checking if this items allows swapping with another item
  protected _canSwap(item: Item): boolean {
    return true;
  }
}

export { Item };
