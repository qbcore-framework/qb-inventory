import { RequiredItemDto } from "@/Models/Dto/RequiredItem";
import { computed, ref } from "vue";

class RequiredItemsPlugin {
  static readonly SERVICE_NAME = "requiredItems";

  public readonly isVisible = computed(
    () => this._isVisible.value && !this.isInventoryOpen.value,
  );

  requiredItems = ref<RequiredItemDto[]>([]);

  private readonly isInventoryOpen = ref(false);
  private readonly _isVisible = ref(false);

  constructor() {
    addEventListener("inventory:required-item", (event) => {
      const data = event as CustomEvent;
      this.Toggle(data.detail.items, data.detail.isVisible);
    });

    addEventListener("inventory:open", () => {
      this.isInventoryOpen.value = true;
    });
    addEventListener("inventory:close", () => {
      this.isInventoryOpen.value = false;
    });
  }

  public Toggle(items: RequiredItemDto[], isVisible: boolean) {
    this.requiredItems.value = items;
    this._isVisible.value = isVisible;
  }
}

export { RequiredItemsPlugin };
