import { HttpClient } from "@/plugins/HttpClient";
import Item from "./Item";

class Weapon extends Item {
  public get Info(): WeaponInfo {
    return this.info as WeaponInfo;
  }

  private readonly _httpClient: HttpClient;

  constructor(data: any) {
    super(data);
    this._httpClient = new HttpClient();
  }

  public async GetMods() {
    return await this._httpClient.Post(`GetWeaponData`, {
      weapon: this.name,
      ItemData: this,
    });
  }
}

export { Weapon };
