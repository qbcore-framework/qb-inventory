import { ReactiveEffect, Ref, ref } from "vue";
import Item from "./Item";

class Hotbar {
  private _items = ref<Item[]>([]);
  public get items() {
    return this._items
  }

  public readonly open = ref(false);

  public Toggle(items: Item[], open: boolean) {
    this._items.value = items;
    this.open.value = open;    
  }
}

export { Hotbar };