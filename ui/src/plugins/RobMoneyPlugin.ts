import { computed, ref } from "vue";
import { HttpClient } from "./HttpClient";

class RobMoneyPlugin {
  static readonly SERVICE_NAME = "robMoney";

  public readonly canRobMoney = computed(
    () => this.hasReceivedClientEvent.value && this.isInventoryOpen.value,
  );

  private readonly httpClient = new HttpClient();

  private hasReceivedClientEvent = ref(false);
  private isInventoryOpen = ref(false);
  private robbedPlayerId = -1;

  constructor() {
    addEventListener("inventory:rob-money", (event) => {
      const data = event as CustomEvent;
      this.hasReceivedClientEvent.value = true;
      this.robbedPlayerId = data.detail.playerId;
    });

    addEventListener("inventory:open", () => {
      this.isInventoryOpen.value = true;
    });

    addEventListener("inventory:close", () => {
      this.isInventoryOpen.value = false;
    });
  }

  rob() {
    if (!this.canRobMoney.value && this.robbedPlayerId !== -1) {
      throw new Error("Attempted to rob money when not allowed");
    }

    const body = {
      TargetId: this.robbedPlayerId,
    };
    this.httpClient.Post("RobMoney", body);

    this.hasReceivedClientEvent.value = false;
    this.robbedPlayerId = -1;
  }
}

export { RobMoneyPlugin };
