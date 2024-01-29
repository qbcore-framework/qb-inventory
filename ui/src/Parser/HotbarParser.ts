import { Item } from "@/Models/Item/Item";
import { CreateContainerItem } from "./ItemParser";
import { Hotbar } from "@/Models/Hotbar";

function ParseHotbarItems(items: any[]): Item[] {
  const hotbarItems = Array<Item>(Hotbar.HOTBAR_SIZE);
  items.forEach((item, index) => {
    if (item) {
      hotbarItems[index] = CreateContainerItem(item);
    }
  });

  return hotbarItems;
}

export { ParseHotbarItems };
