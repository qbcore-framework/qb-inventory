import { RequiredItemDto } from "@/Models/Dto/RequiredItem";
import { ref } from "vue";

class RequiredItemsPlugin {
  static readonly SERVICE_NAME = "requiredItems";

  public readonly isVisible = ref(false);
  requiredItems = ref<RequiredItemDto[]>([]);

  constructor() {
    addEventListener("inventory:required-item", (event) => {
      const data = event as CustomEvent;
      this.Toggle(data.detail.items, data.detail.isVisible);

      console.log(
        "Updated required items",
        this.requiredItems.value,
        this.isVisible.value,
      );
    });
  }

  public Toggle(items: RequiredItemDto[], isVisible: boolean) {
    this.requiredItems.value = items;
    this.isVisible.value = isVisible;
  }
}

export { RequiredItemsPlugin };
