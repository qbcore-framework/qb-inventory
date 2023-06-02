import { CraftingItemFactory, ItemFactory } from "./item.spec";

describe("CraftingItem", () => {
  describe("canCraft", () => {
    it("should return true if all required items are present in the correct amounts", () => {
      const item1 = ItemFactory({
        name: "item1",
        amount: 5,
      });
      const item2 = ItemFactory({
        name: "item2",
        amount: 10,
      });
      const item3 = ItemFactory({
        name: "item3",
        amount: 2,
      });
      const items = [item1, item2, item3];

      const craftingItem = CraftingItemFactory({
        name: "craftingItem",
        costs: {
          item1: 2,
          item2: 5,
          item3: 1,
        },
      });

      expect(craftingItem.canCraft(items)).toBe(true);
    });

    it("should return false if any required item is missing", () => {
      const item1 = ItemFactory({
        name: "item1",
        amount: 5,
      });
      const item2 = ItemFactory({
        name: "item2",
        amount: 10,
      });
      const items = [item1, item2];

      const craftingItem = CraftingItemFactory({
        name: "craftingItem",
        costs: {
          item1: 2,
          item2: 5,
          item3: 1,
        },
      });

      expect(craftingItem.canCraft(items)).toBe(false);
    });

    it("should return false if any required item is present in insufficient amounts", () => {
      const item1 = ItemFactory({
        name: "item1",
        amount: 5,
      });
      const item2 = ItemFactory({
        name: "item2",
        amount: 10,
      });
      const item3 = ItemFactory({
        name: "item3",
        amount: 2,
      });
      const items = [item1, item2, item3];

      const craftingItem = CraftingItemFactory({
        name: "craftingItem",
        costs: {
          item1: 2,
          item2: 15,
          item3: 1,
        },
      });

      expect(craftingItem.canCraft(items)).toBe(false);
    });

    it("should return true if the required amount is specified and all required items are present in the correct amounts", () => {
      const item1 = ItemFactory({
        name: "item1",
        amount: 5,
      });
      const item2 = ItemFactory({
        name: "item2",
        amount: 10,
      });
      const item3 = ItemFactory({
        name: "item3",
        amount: 2,
      });
      const items = [item1, item2, item3];

      const craftingItem = CraftingItemFactory({
        name: "craftingItem",
        costs: {
          item1: 2,
          item2: 5,
          item3: 1,
        },
      });

      expect(craftingItem.canCraft(items, 2)).toBe(true);
    });

    it("should return false if the required amount is specified and any required item is missing", () => {
      const item1 = ItemFactory({
        name: "item1",
        amount: 5,
      });
      const item2 = ItemFactory({
        name: "item2",
        amount: 10,
      });
      const items = [item1, item2];

      const craftingItem = CraftingItemFactory({
        name: "craftingItem",
        costs: {
          item1: 2,
          item2: 5,
          item3: 1,
        },
      });

      expect(craftingItem.canCraft(items, 2)).toBe(false);
    });

    it("should return false if the required amount is specified and any required item is present in insufficient amounts", () => {
      const item1 = ItemFactory({
        name: "item1",
        amount: 5,
      });
      const item2 = ItemFactory({
        name: "item2",
        amount: 10,
      });
      const item3 = ItemFactory({
        name: "item3",
        amount: 2,
      });
      const items = [item1, item2, item3];

      const craftingItem = CraftingItemFactory({
        name: "craftingItem",
        costs: {
          item1: 2,
          item2: 15,
          item3: 1,
        },
      });

      expect(craftingItem.canCraft(items, 2)).toBe(false);
    });
  });
});
