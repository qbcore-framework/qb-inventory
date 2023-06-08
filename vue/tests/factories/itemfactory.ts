import { CraftingItem } from "@/Models/Item/CraftingItem";
import { Item } from "@/Models/Item/Item";

export function ItemFactory(overrides?: Partial<Item>): Item {
  return new Item(
    overrides?.name ?? "Test Item",
    overrides?.amount ?? 1,
    overrides?.info ?? {},
    overrides?.label ?? "Test Item",
    overrides?.description ?? "Test Item",
    overrides?.weight ?? 1,
    overrides?.type ?? "item",
    overrides?.unique ?? false,
    overrides?.usable ?? false,
    overrides?.image ?? "test.png",
    overrides?.id ?? 1,
    overrides?.shouldClose ?? undefined
  );
}

export function CraftingItemFactory(
  overrides?: Partial<CraftingItem>
): CraftingItem {
  return new CraftingItem(
    overrides?.costs ?? {},
    overrides?.name ?? "Test Item",
    overrides?.amount ?? 1,
    overrides?.info ?? {
      costs: "test",
    },
    overrides?.label ?? "Test Item",
    overrides?.description ?? "Test Item",
    overrides?.weight ?? 1,
    overrides?.type ?? "item",
    overrides?.unique ?? false,
    overrides?.usable ?? false,
    overrides?.image ?? "test.png",
    overrides?.id ?? 1,
    overrides?.shouldClose ?? undefined
  );
}
