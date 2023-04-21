import { HttpClient } from "@/plugins/HttpClient";

class Inventory {
  private items: Item[] = [];
  private readonly _httpClient: HttpClient;

  constructor() {
    this._httpClient = new HttpClient();
  }

  public Open() {
    // Fetch items from server
  }

  public Close() {
    // Tell server to close inventory
    this._httpClient.Get("CloseInventory");
  }
}

export { Inventory };