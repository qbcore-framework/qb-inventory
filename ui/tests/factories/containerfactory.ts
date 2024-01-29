import { CraftingContainer } from "@/Models/Container/CraftingContainer";
import { PlayerInventory } from "@/Models/Container/PlayerInventory";
import MaxAmmo from "@/Models/Interfaces/MaxAmmo";
import { CraftingItem } from "@/Models/Item/CraftingItem";
import { Item } from "@/Models/Item/Item";

export function PlayerInventoryFactory(
  overrides?: Partial<{
    items: Item[];
    maxWeight: number;
    maxAmmo: MaxAmmo;
    ammo: [];
  }>,
): PlayerInventory {
  const inventory = new PlayerInventory();

  inventory.UpdateContents(
    overrides?.items ?? [],
    overrides?.maxWeight ?? 90000000,
    overrides?.maxAmmo ?? {
      pistol: 0,
      smg: 0,
      rifle: 0,
      shotgun: 0,
    },
    overrides?.ammo ?? [],
  );

  return inventory;
}

export function CraftingContainerFactory(
  overrides?: Partial<{
    items: CraftingItem[];
    maxWeight: number;
  }>,
): CraftingContainer {
  const container = new CraftingContainer();

  container.UpdateContents(
    overrides?.items ?? [],
    overrides?.maxWeight ?? 90000000,
  );

  return container;
}
