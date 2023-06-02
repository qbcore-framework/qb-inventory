import { WeaponInfo } from "@/Models/Interfaces/WeaponInfo";
import { CraftingItem } from "@/Models/Item/CraftingItem";
import { Item } from "@/Models/Item/Item";
import { Weapon } from "@/Models/Item/Weapon";

/**
 * Parse inventory from the client to NUI into an array of items
 */
function ParseInventory(itemData: any, slots: number): Item[] {
  return StructureInventoryArray(CreateContainerItem, itemData, slots);
}

function ParseCraftingInventory(itemData: any, slots: number): CraftingItem[] {
  return StructureInventoryArray(CreateCraftingItem, itemData, slots);
}

/**
 * Structure the array so that it has null values for empty slots.
 * Also parses the item data using the provided function
 */
function StructureInventoryArray<TItem extends Item>(
  itemParseFunction: (itemData: any) => TItem,
  itemData: any,
  slots: number
): TItem[] {
  const items = new Array<TItem>(slots);

  // If inventory is an object, convert it to an array
  if (!Array.isArray(itemData)) {
    const inventory = [];
    for (const key in itemData) {
      inventory.push(itemData[key]);
    }

    itemData = inventory;
  }

  // Remove slot from items since this causes issues with 1 based indexing
  itemData.forEach((itemData: (TItem & { slot: number }) | null) => {
    if (itemData === null) return;

    items[itemData.slot - 1] = itemParseFunction(itemData);
  });

  return items;
}

/**
 * Parses item data for crafting container events.
 */
function CreateCraftingItem(itemData: CraftingItem): CraftingItem {
  return new CraftingItem(
    itemData.costs,
    itemData.name,
    itemData.amount,
    itemData.info,
    itemData.label,
    itemData.description,
    itemData.weight,
    itemData.type,
    itemData.unique,
    itemData.usable,
    itemData.image,
    itemData.id,
    itemData.shouldClose
  );
}

/**
 * Parses item data for player inventory and default container inventory events.
 */
function CreateContainerItem(itemData: Item & { slot: number }): Item {
  let item: Item;
  if (itemData.name.startsWith("weapon_")) {
    item = new Weapon(
      itemData.slot,
      itemData.name,
      itemData.amount,
      itemData.info as WeaponInfo,
      itemData.label,
      itemData.description,
      itemData.weight,
      itemData.type,
      itemData.unique,
      itemData.usable,
      itemData.image,
      itemData.id,
      itemData.shouldClose
    );
  } else {
    item = new Item(
      itemData.name,
      itemData.amount,
      itemData.info,
      itemData.label,
      itemData.description,
      itemData.weight,
      itemData.type,
      itemData.unique,
      itemData.usable,
      itemData.image,
      itemData.id,
      itemData.shouldClose
    );
  }

  return item;
}

export { ParseInventory, ParseCraftingInventory };
