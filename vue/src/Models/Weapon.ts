import { HttpClient } from "@/plugins/HttpClient";
import Item from "./Item";
import { WeaponInfo } from "./WeaponInfo";
import { WeaponDataDto } from "./Dto/GetWeaponData";

class Weapon extends Item {
  public get Info(): WeaponInfo {
    return this.info as WeaponInfo;
  }

  private weaponData: WeaponDataDto | null = null;
  public async GetWeaponData(): Promise<WeaponDataDto> {
    if (this.weaponData) return this.weaponData;
    // Allow for async loading of weapon data
    this.weaponData = await this._httpClient.Post(`GetWeaponData`, {
      weapon: this.name,
      ItemData: this,
    });
    return this.weaponData!;
  }

  private readonly _httpClient: HttpClient;
  // Required for RemoveAttachment 🙃
  private readonly _slot: number;

  constructor(data: any) {
    super(data);
    this._httpClient = new HttpClient();
    this._slot = data.slot;
  }

  public async RemoveAttachment(attachmentName: string) {
    console.log("RemoveAttachment");
    const attachment = (await this.GetWeaponData())
      .AttachmentData
      .find((a) => a.attachment === attachmentName);

    const weaponData = JSON.parse(JSON.stringify(this));
    weaponData.slot = this._slot;

    if (!attachment) return;
    const res = await this._httpClient.Post(`RemoveAttachment`, {
      AttachmentData: attachment,
      WeaponData: weaponData,
    });

    console.log(res);
  }
}

export { Weapon };
