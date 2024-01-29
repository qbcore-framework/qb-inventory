import { CraftingContainer } from "@/Models/Container/CraftingContainer";
import { PlayerInventory } from "@/Models/Container/PlayerInventory";
import { CraftingItem } from "@/Models/Item/CraftingItem";
import { Item } from "@/Models/Item/Item";
import {
  CraftingContainerFactory,
  PlayerInventoryFactory,
} from "@tests/factories/containerfactory";
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

  let coffee1: Item;
  let coffee2: Item;
  let tea1: Item;
  let tea2: Item;

  let craftedItem: CraftingItem;

  beforeEach(() => {
    inventory = PlayerInventoryFactory();
    craftingContainer = CraftingContainerFactory();

    coffee1 = ItemFactory({
      name: "Coffee",
      amount: 5,
    });

    coffee2 = ItemFactory({
      name: "Coffee",
      amount: 5,
    });

    tea1 = ItemFactory({
      name: "Tea",
      amount: 5,
    });

    tea2 = ItemFactory({
      name: "Tea",
      amount: 5,
    });

    craftedItem = CraftingItemFactory({
      name: "CoffeeTea",
      costs: {
        Coffee: 1,
        Tea: 1,
      },
      amount: 10,
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
      const amountToCraft = 2;

      toInventory.Items.value[0] = coffee1;
      toInventory.Items.value[1] = tea1;

      // Act
      craftingContainer.MoveItem(fromSlot, toSlot, toInventory, amountToCraft);

      // Assert
      expect(craftingContainer.Items.value[fromSlot]).toEqual(craftedItem);
      expect(coffee1.amount).toEqual(3);
      expect(tea1.amount).toEqual(3);
      expect(toInventory.Items.value[toSlot].name).toEqual(craftedItem.name);
      expect(toInventory.Items.value[toSlot].amount).toEqual(amountToCraft);
    });

    it("shouldn't move the item if the destination inventory doesn't have enough of the required items for crafting", () => {
      // Arrange
      const fromSlot = 0;
      const toSlot = 3;
      const toInventory = inventory;
      craftingContainer.Items.value[fromSlot] = craftedItem;
      toInventory.Items.value[0] = coffee1;

      // Act
      craftingContainer.MoveItem(fromSlot, toSlot, toInventory);

      // Assert
      expect(craftingContainer.Items.value[fromSlot]).toEqual(craftedItem);
      expect(toInventory.Items.value[toSlot]).toBeUndefined();
      expect(toInventory.Items.value[0]).toEqual(coffee1);
      expect(coffee1.amount).toEqual(5);
    });
  });
});
