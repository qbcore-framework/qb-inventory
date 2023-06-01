import { ItemCtorParams } from "./ItemCtorParams";

interface CraftingItemCtorParams extends ItemCtorParams {
  info: {
    costs: string;
  };
  costs: string[];
}

export { CraftingItemCtorParams };
