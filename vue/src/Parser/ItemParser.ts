import { ItemCtorParams } from "@/Models/Interfaces/ItemCtorParams";
import { WeaponInfo } from "@/Models/Interfaces/WeaponInfo";
import { Item } from "@/Models/Item";
import { Weapon } from "@/Models/Weapon";

/**
 * Parse inventory from the client to NUI into an array of items
 */
function ParseInventory(itemData: any, slots: number): Item[] {
  const items = new Array<Item>(slots);

  // If inventory is an object, convert it to an array
  if (!Array.isArray(itemData)) {
    const inventory = [];
    for (const key in itemData) {
      inventory.push(itemData[key]);
    }

    itemData = inventory;
  }

  // Remove slot from items since this causes issues with 1 based indexing
  itemData.forEach((itemData: (Item & { slot: number }) | null) => {
    if (itemData === null) return;
    let item: Item;

    const params: ItemCtorParams = {
      name: itemData.name,
      amount: itemData.amount,
      info: itemData.info,
      label: itemData.label,
      description: itemData.description,
      weight: itemData.weight,
      type: itemData.type,
      unique: itemData.unique,
      usable: itemData.usable,
      image: itemData.image,
      id: itemData.id,
      shouldClose: itemData.shouldClose,
    };

    if (itemData.name.startsWith("weapon_"))
      item = new Weapon(
        params as ItemCtorParams & { info: WeaponInfo },
        itemData.slot
      );
    else item = new Item(params);
    items[itemData.slot - 1] = item;
  });

  return items;
}

export { ParseInventory };
