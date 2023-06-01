import MaxAmmo from "../Interfaces/MaxAmmo";
import { CraftingItem } from "../Item/CraftingItem";
import { Item } from "../Item/Item";

interface OpenInventoryDto {
  ammo: [];
  items: Item[];
  maxAmmo: MaxAmmo;
  maxWeight: number;
  name: string;
}

interface OpenCraftingInventoryDto extends OpenInventoryDto {
  items: CraftingItem[];
}

export { OpenInventoryDto, OpenCraftingInventoryDto };
