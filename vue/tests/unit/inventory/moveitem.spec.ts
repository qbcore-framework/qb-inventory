import { Inventory } from "@/Models/Inventory";
import { Item } from "@/Models/Item";

const mockPost = jest.fn();
const mockGet = jest.fn();
jest.mock("@/plugins/HttpClient", () => {
  return {
    HttpClient: jest.fn().mockImplementation(() => {
      return {
        Post: mockPost,
        Get: mockGet,
      };
    }),
  };
});

describe("Inventory", () => {
  let inventory: Inventory;

  let coffeeItem: Item;
  let teaItem: Item;
  let tenCoffeeItem: Item;

  beforeEach(() => {
    inventory = new Inventory();
    const itemBase = {
      description: "description",
      amount: 1,
      image: "404.png",
      info: {},
      weight: 1,
      type: "item",
      unique: false,
      usable: true,
      id: 1,
      shouldClose: false,
    };

    coffeeItem = new Item({
      ...itemBase,
      name: "Coffee",
      label: "Coffee",
    });

    teaItem = new Item({
      ...itemBase,
      name: "Tea",
      label: "Tea",
    });

    tenCoffeeItem = new Item({
      ...itemBase,
      name: "Coffee",
      label: "Coffee",
      amount: 10,
    });
  });

  describe("MoveItem", () => {
    it("should not move negative amount of items", () => {
      const fromSlot = 0;
      const toSlot = 1;
      const amount = -1;

      const initialFromItem = coffeeItem;
      inventory.Items.value[fromSlot] = initialFromItem;

      const initialToItem = teaItem;
      inventory.Items.value[toSlot] = initialToItem;

      inventory.MoveItem(fromSlot, toSlot, undefined, amount);

      expect(inventory.Items.value[fromSlot]).toEqual(initialFromItem);
      expect(inventory.Items.value[toSlot]).toEqual(initialToItem);
    });

    it("should not move more items than there are in the slot", () => {
      const fromSlot = 0;
      const toSlot = 1;
      const amount = 2;

      const initialFromItem = coffeeItem;
      inventory.Items.value[fromSlot] = initialFromItem;

      const initialToItem = teaItem;
      inventory.Items.value[toSlot] = initialToItem;

      inventory.MoveItem(fromSlot, toSlot, undefined, amount);

      expect(inventory.Items.value[fromSlot]).toEqual(initialFromItem);
      expect(inventory.Items.value[toSlot]).toEqual(initialToItem);
    });

    it("should not split items if there is a different item in the to slot", () => {
      const fromSlot = 0;
      const toSlot = 1;

      const initialFromItem = tenCoffeeItem;

      inventory.Items.value[fromSlot] = initialFromItem;

      const initialToItem = teaItem;
      inventory.Items.value[toSlot] = initialToItem;

      inventory.MoveItem(fromSlot, toSlot, undefined, 1);

      expect(inventory.Items.value[fromSlot]).toEqual(initialFromItem);
      expect(inventory.Items.value[toSlot]).toEqual(initialToItem);
    });

    it("should move all items if amount is not set", () => {
      const fromSlot = 0;
      const toSlot = 1;

      const initialFromItem = tenCoffeeItem;
      inventory.Items.value[fromSlot] = initialFromItem;

      inventory.MoveItem(fromSlot, toSlot);

      expect(inventory.Items.value[fromSlot]).toBeUndefined();
      expect(inventory.Items.value[toSlot]).toEqual(initialFromItem);
      expect(inventory.Items.value[toSlot].amount).toEqual(10);
    });

    it("should stack items if they are the same", () => {
      const fromSlot = 0;
      const toSlot = 1;

      const initialFromItem = tenCoffeeItem;
      inventory.Items.value[fromSlot] = initialFromItem;

      const initialToItem = coffeeItem;
      inventory.Items.value[toSlot] = initialToItem;

      inventory.MoveItem(fromSlot, toSlot);

      expect(inventory.Items.value[fromSlot]).toBeUndefined();
      expect(inventory.Items.value[toSlot]).toEqual(initialToItem);
      expect(inventory.Items.value[toSlot].amount).toEqual(11);
    });

    it("should swap items if they are different", () => {
      const fromSlot = 0;
      const toSlot = 1;

      const initialFromItem = coffeeItem;
      inventory.Items.value[fromSlot] = initialFromItem;

      const initialToItem = teaItem;
      inventory.Items.value[toSlot] = initialToItem;

      inventory.MoveItem(fromSlot, toSlot);

      expect(inventory.Items.value[fromSlot]).toEqual(initialToItem);
      expect(inventory.Items.value[toSlot]).toEqual(initialFromItem);
    });

    it("should split items if amount is less than the total", () => {
      const fromSlot = 0;
      const toSlot = 1;
      const amount = 1;

      const initialFromItem = tenCoffeeItem;
      inventory.Items.value[fromSlot] = initialFromItem;

      const initialToItem = coffeeItem;
      inventory.Items.value[toSlot] = initialToItem;

      inventory.MoveItem(fromSlot, toSlot, undefined, amount);

      expect(inventory.Items.value[fromSlot]).toEqual(initialFromItem);
      expect(inventory.Items.value[fromSlot].amount).toEqual(9);
      expect(inventory.Items.value[toSlot].name).toEqual("Coffee");
      expect(inventory.Items.value[toSlot].amount).toEqual(2);
    });

    it("should move items if amount is equal to the total", () => {
      const fromSlot = 0;
      const toSlot = 1;

      const initialFromItem = tenCoffeeItem;
      inventory.Items.value[fromSlot] = initialFromItem;

      inventory.MoveItem(fromSlot, toSlot, undefined, 10);

      expect(inventory.Items.value[fromSlot]).toBeUndefined();
      expect(inventory.Items.value[toSlot].name).toEqual("Coffee");
      expect(inventory.Items.value[toSlot].amount).toEqual(10);
    });

    it("should not move if there is no item in the from slot", () => {
      const fromSlot = 0;
      const toSlot = 1;

      const initialToItem = coffeeItem;
      inventory.Items.value[toSlot] = initialToItem;

      inventory.MoveItem(fromSlot, toSlot);

      expect(inventory.Items.value[fromSlot]).toBeUndefined();
      expect(inventory.Items.value[toSlot]).toEqual(initialToItem);
    });

    it("should move items to another inventory", () => {
      const fromSlot = 0;
      const toSlot = 1;

      const initialFromItem = coffeeItem;
      inventory.Items.value[fromSlot] = initialFromItem;

      const otherInventory = new Inventory();
      const initialToItem = null;
      // otherInventory.Items.value[toSlot] = initialToItem;

      inventory.MoveItem(fromSlot, toSlot, otherInventory);

      expect(inventory.Items.value[fromSlot]).toBeUndefined();
      expect(otherInventory.Items.value[toSlot].name).toEqual("Coffee");
      expect(otherInventory.Items.value[toSlot].amount).toEqual(1);
    });
  });
});
