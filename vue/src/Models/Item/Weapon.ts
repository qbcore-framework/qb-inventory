import { HttpClient } from "@/plugins/HttpClient";
import { Item } from "./Item";
import { ItemCtorParams } from "../Interfaces/ItemCtorParams";
import { WeaponInfo } from "../Interfaces/WeaponInfo";
import { WeaponDataDto } from "../Dto/GetWeaponData";

class Weapon extends Item {
  public static readonly MAX_QUALITY = 100;
  public override readonly info: WeaponInfo;

  private weaponData: WeaponDataDto | null = null;
  public async GetWeaponData(): Promise<WeaponDataDto> {
    if (this.weaponData) return this.weaponData;
    this.weaponData = await this._httpClient.Post(`GetWeaponData`, {
      weapon: this.name,
      ItemData: this,
    });

    if (this.weaponData === null)
      throw new Error("Weapon data is null after fetch");

    return this.weaponData;
  }

  private readonly _httpClient: HttpClient;
  // Required for RemoveAttachment 🙃
  private readonly _slot: number;

  constructor(
    data: ItemCtorParams & {
      info: WeaponInfo;
    },
    slot: number
  ) {
    super(data);
    this.info = data.info as WeaponInfo;
    this._slot = slot;
    this._httpClient = new HttpClient();
  }

  public async RemoveAttachment(attachmentName: string) {
    const attachment = (await this.GetWeaponData()).AttachmentData.find(
      (a) => a.attachment === attachmentName
    );

    const weaponData = JSON.parse(JSON.stringify(this));
    weaponData.slot = this._slot;

    if (!attachment) return;
    await this._httpClient.Post(`RemoveAttachment`, {
      AttachmentData: attachment,
      WeaponData: weaponData,
    });

    if (this.weaponData === null) throw new Error("Weapon data is null");

    // Remove attachment from weapon
    this.weaponData.AttachmentData = this.weaponData.AttachmentData.filter(
      (a) => a.attachment !== attachmentName
    );
  }
}

export { Weapon };
