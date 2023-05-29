import { OpenInventoryDto } from "../Dto/OpenInventory";

interface IInventoryState {
  getName(): string;
  open(inventoryData: OpenInventoryDto): void;
}

export { IInventoryState };
