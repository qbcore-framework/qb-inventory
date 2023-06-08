import { CraftingItem } from "@/Models/Item/CraftingItem";
import { Item } from "@/Models/Item/Item";
import { CraftingItemFactory, ItemFactory } from "@tests/factories/itemfactory";

describe("CraftingItem", () => {
  let craftingItem: CraftingItem;
  let coffee: Item;
  let tea: Item;
  let tea2: Item;
  let sugar: Item;

  beforeEach(() => {
    craftingItem = CraftingItemFactory({
      name: "CoffeeTea",
      costs: {
        Coffee: 1,
        Tea: 2,
      },
      amount: 10,
    });
    coffee = ItemFactory({
      name: "Coffee",
      amount: 10,
    });
    tea = ItemFactory({
      name: "Tea",
      label: "Tea",
      amount: 10,
    });
    tea2 = ItemFactory({
      name: "Tea",
      label: "Tea2",
      amount: 10,
    });
    sugar = ItemFactory({
      name: "Sugar",
      amount: 5,
    });
  });

  describe("removeCraftingItems", () => {
    it("should not remove any items if the amount is zero or negative", () => {
      // Arrange
      const items = [coffee, tea];

      // Act
      const result = craftingItem.removeCraftingItems(items, 0);

      // Assert
      expect(result).toEqual(items);
    });

    it("should not remove any items if the items do not exist", () => {
      // Arrange
      const items = [coffee, tea];

      // Act
      const result = craftingItem.removeCraftingItems(items, 1);

      // Assert
      expect(result).toEqual(items);
    });

    it("should remove the required items if they exist in the correct amounts", () => {
      // Arrange
      const items = [coffee, tea];

      // Act
      const result = craftingItem.removeCraftingItems(items, 1);

      // Assert
      expect(result).toEqual([coffee, tea]);
      expect(coffee.amount).toEqual(9);
      expect(tea.amount).toEqual(8);
    });

    it("Should take from multiple stacks if the required items are not in a single stack", () => {
      // Arrange
      const items = [coffee, tea, tea2];

      // Act
      const result = craftingItem.removeCraftingItems(items, 10);

      // Assert
      expect(result).toEqual([]);
    });

    it("should remove the required items if they exist in smaller amounts", () => {
      // Arrange
      const items = [coffee, tea];

      // Act
      const result = craftingItem.removeCraftingItems(items, 1);

      // Assert
      expect(result).toEqual([coffee, tea]);
      expect(coffee.amount).toEqual(9);
      expect(tea.amount).toEqual(8);
    });

    it("should remove the required items if they exist in multiple stacks and other items are present", () => {
      // Arrange
      const items = [coffee, sugar, tea, tea2];

      // Act
      const result = craftingItem.removeCraftingItems(items, 10);

      // Assert
      expect(result).toEqual([sugar]);
    });

    it("Should craft one item if amount is not specified", () => {
      // Arrange
      const items = [coffee, tea];

      // Act
      const result = craftingItem.removeCraftingItems(items);

      // Assert
      expect(result).toEqual([coffee, tea]);
      expect(coffee.amount).toEqual(9);
      expect(tea.amount).toEqual(8);
    });

    it("Should stop removing items if the required amount is reached", () => {
      // Arrange
      const items = [coffee, tea];

      // Act
      const result = craftingItem.removeCraftingItems(items, 2);

      // Assert
      expect(result).toEqual([coffee, tea]);
      expect(coffee.amount).toEqual(8);
      expect(tea.amount).toEqual(6);
    });
  });
});
