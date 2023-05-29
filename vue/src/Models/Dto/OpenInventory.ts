import MaxAmmo from "../Interfaces/MaxAmmo";
import { Item } from "../Item";

interface OpenInventoryDto {
  ammo: [];
  items: Item[];
  maxAmmo: MaxAmmo;
  maxWeight: number;
  name: string;
}

export { OpenInventoryDto };
