import { CraftingContainer } from "@/Models/Container/CraftingContainer";
import { PlayerInventory } from "@/Models/Container/PlayerInventory";
import { CraftingItem } from "@/Models/Item/CraftingItem";
import { Item } from "@/Models/Item/Item";
import { CraftingItemFactory, ItemFactory } from "@tests/factories/itemfactory";

jest.mock("@/plugins/HttpClient", () => {
  return {
    HttpClient: jest.fn().mockImplementation(() => {
      return {
        Post: jest.fn(),
        Get: jest.fn(),
      };
    }),
  };
});

describe("CraftingContainer", () => {
  let inventory: PlayerInventory;
  let craftingContainer: CraftingContainer;

  let ingredient1: Item;
  let ingredient2: Item;

  let craftedItem: CraftingItem;

  beforeEach(() => {
    inventory = new PlayerInventory();
    craftingContainer = new CraftingContainer();

    ingredient1 = ItemFactory({
      name: "Coffee",
      amount: 5,
    });

    ingredient2 = ItemFactory({
      name: "Tea",
      amount: 5,
    });

    craftedItem = CraftingItemFactory({
      name: "CoffeeTea",
      costs: {
        Coffee: 1,
        Tea: 1,
      },
      amount: 1,
    });
  });

  describe("MoveItem", () => {
    it("should not move the item if it does not exist", () => {
      // Arrange
      const fromSlot = 0;
      const toSlot = 1;
      const toInventory = inventory;

      // Act
      craftingContainer.MoveItem(fromSlot, toSlot, toInventory);

      // Assert
      expect(craftingContainer.Items.value[fromSlot]).toBeUndefined();
      expect(toInventory.Items.value[toSlot]).toBeUndefined();
    });

    it("should not move the item if the destination inventory does not have the required items for crafting", () => {
      // Arrange
      const fromSlot = 0;
      const toSlot = 1;
      const toInventory = inventory;
      craftingContainer.Items.value[fromSlot] = craftedItem;

      // Act
      craftingContainer.MoveItem(fromSlot, toSlot, toInventory);

      // Assert
      expect(craftingContainer.Items.value[fromSlot]).toEqual(craftedItem);
      expect(toInventory.Items.value[toSlot]).toBeUndefined();
    });

    it("Should only remove the required amount of items from the inventory", () => {
      // Arrange
      const fromSlot = 0;
      const toSlot = 3;
      const toInventory = inventory;
      craftingContainer.Items.value[fromSlot] = craftedItem;

      // Act
      craftingContainer.MoveItem(fromSlot, toSlot, toInventory, 2);

      // Assert
      expect(craftingContainer.Items.value[fromSlot]).toEqual(craftedItem);
      expect(ingredient1.amount).toEqual(3);
      expect(ingredient2.amount).toEqual(3);
      expect(toInventory.Items.value[toSlot]).toEqual(craftedItem);
      expect(toInventory.Items.value[toSlot].amount).toEqual(2);
    });

    it("should move the item if the destination inventory has the required items for crafting", () => {
      // Arrange
      const fromSlot = 0;
      const toSlot = 3;
      const toInventory = inventory;
      craftingContainer.Items.value[fromSlot] = craftedItem;
      toInventory.Items.value[0] = ingredient1;
      toInventory.Items.value[1] = ingredient2;

      // Act
      craftingContainer.MoveItem(fromSlot, toSlot, toInventory);

      // Assert
      expect(craftingContainer.Items.value[fromSlot]).toBeUndefined();
      expect(toInventory.Items.value[toSlot]).toEqual(craftedItem);
      expect(toInventory.Items.value[0]).toEqual(ingredient1);
      expect(toInventory.Items.value[1]).toEqual(ingredient2);
      expect(ingredient1.amount).toEqual(5);
      expect(ingredient2.amount).toEqual(5);
    });

    it("shouldn't move the item if the destination inventory doesn't have enough of the required items for crafting", () => {
      // Arrange
      const fromSlot = 0;
      const toSlot = 3;
      const toInventory = inventory;
      craftingContainer.Items.value[fromSlot] = craftedItem;
      toInventory.Items.value[0] = ingredient1;

      // Act
      craftingContainer.MoveItem(fromSlot, toSlot, toInventory);

      // Assert
      expect(craftingContainer.Items.value[fromSlot]).toEqual(craftedItem);
      expect(toInventory.Items.value[toSlot]).toBeUndefined();
      expect(toInventory.Items.value[0]).toEqual(ingredient1);
      expect(ingredient1.amount).toEqual(10);
    });
  });
});
