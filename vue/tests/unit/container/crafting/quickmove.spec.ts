import { PlayerInventory } from "@/Models/Container/PlayerInventory";
import { Item } from "@/Models/Item/Item";
import { ItemFactory } from "@tests/factories/itemfactory";

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

describe("Inventory", () => {
  let inventory: PlayerInventory;
  let otherInventory: PlayerInventory;

  let coffeeItem: Item;
  let teaItem: Item;
  let tenCoffeeItem: Item;

  beforeEach(() => {
    inventory = new PlayerInventory();
    inventory.UpdateContents(
      new Array(10),
      1000,
      { pistol: 0, smg: 0, rifle: 0, shotgun: 0 },
      [],
    );
    otherInventory = new PlayerInventory();
    otherInventory.UpdateContents(
      new Array(10),
      1000,
      { pistol: 0, smg: 0, rifle: 0, shotgun: 0 },
      [],
    );

    coffeeItem = ItemFactory({ name: "Coffee", amount: 1 });
    teaItem = ItemFactory({ name: "Tea", amount: 1 });
    tenCoffeeItem = ItemFactory({ name: "Coffee", amount: 10 });
  });

  describe("QuickMoveItem", () => {
    it("should not move if there is no item in the from slot", () => {
      const fromSlot = 0;

      const initialToItem = coffeeItem;
      otherInventory.Items.value[0] = initialToItem;

      inventory.QuickMoveItem(fromSlot, otherInventory);

      expect(inventory.Items.value[fromSlot]).toBeUndefined();
      expect(otherInventory.Items.value[0]).toEqual(initialToItem);
    });

    it("should merge items if they can be merged", () => {
      const fromSlot = 0;

      const initialFromItem = coffeeItem;
      inventory.Items.value[fromSlot] = initialFromItem;

      const initialToItem = tenCoffeeItem;
      otherInventory.Items.value[0] = initialToItem;

      inventory.QuickMoveItem(fromSlot, otherInventory);

      expect(inventory.Items.value[fromSlot]).toBeUndefined();
      expect(otherInventory.Items.value[0].name).toEqual("Coffee");
      expect(otherInventory.Items.value[0].amount).toEqual(11);
    });

    it("should move to an empty slot if there is no item to merge with", () => {
      const fromSlot = 0;

      const initialFromItem = coffeeItem;
      inventory.Items.value[fromSlot] = initialFromItem;

      const initialToItem = teaItem;
      otherInventory.Items.value[0] = initialToItem;

      inventory.QuickMoveItem(fromSlot, otherInventory);

      expect(inventory.Items.value[fromSlot]).toBeUndefined();
      expect(otherInventory.Items.value[1].name).toEqual("Coffee");
      expect(otherInventory.Items.value[1].amount).toEqual(1);
    });

    it("should not move if there is no empty slot", () => {
      const fromSlot = 0;

      const initialFromItem = coffeeItem;
      inventory.Items.value[fromSlot] = initialFromItem;

      const initialToItem = teaItem;
      otherInventory.Items.value[0] = initialToItem;
      otherInventory.Items.value[1] = initialToItem;
      otherInventory.Items.value[2] = initialToItem;
      otherInventory.Items.value[3] = initialToItem;
      otherInventory.Items.value[4] = initialToItem;
      otherInventory.Items.value[5] = initialToItem;
      otherInventory.Items.value[6] = initialToItem;
      otherInventory.Items.value[7] = initialToItem;
      otherInventory.Items.value[8] = initialToItem;
      otherInventory.Items.value[9] = initialToItem;

      inventory.QuickMoveItem(fromSlot, otherInventory);

      expect(inventory.Items.value[fromSlot]).toEqual(initialFromItem);
      expect(otherInventory.Items.value[0]).toEqual(initialToItem);
      expect(otherInventory.Items.value[1]).toEqual(initialToItem);
      expect(otherInventory.Items.value[2]).toEqual(initialToItem);
      expect(otherInventory.Items.value[3]).toEqual(initialToItem);
      expect(otherInventory.Items.value[4]).toEqual(initialToItem);
      expect(otherInventory.Items.value[5]).toEqual(initialToItem);
      expect(otherInventory.Items.value[6]).toEqual(initialToItem);
      expect(otherInventory.Items.value[7]).toEqual(initialToItem);
      expect(otherInventory.Items.value[8]).toEqual(initialToItem);
      expect(otherInventory.Items.value[9]).toEqual(initialToItem);
    });

    it("should move the specified amount of items", () => {
      const fromSlot = 0;

      const initialFromItem = tenCoffeeItem;
      inventory.Items.value[fromSlot] = initialFromItem;

      inventory.QuickMoveItem(fromSlot, otherInventory, 4);

      expect(inventory.Items.value[fromSlot].amount).toEqual(6);
      expect(otherInventory.Items.value[0].name).toEqual("Coffee");
      expect(otherInventory.Items.value[0].amount).toEqual(4);
    });
  });
});
