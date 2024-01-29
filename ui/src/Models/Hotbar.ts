import { ref, Ref } from "vue";
import { Item } from "./Item/Item";

class Hotbar {
  static readonly HOTBAR_SIZE = 5;

  private _items = ref<Item[]>([]);
  public get items() {
    return this._items as Ref<Item[]>;
  }

  public readonly open = ref(false);

  public Toggle(items: Item[], open: boolean) {
    this._items.value = items;
    this.open.value = open;
  }
}

export { Hotbar };
