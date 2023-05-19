import { HttpClient } from "@/plugins/HttpClient";
import Item from "./Item";
import { WeaponInfo } from "./WeaponInfo";
import { WeaponDataDto } from "./Dto/GetWeaponData";

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

  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  constructor(data: any) {
    super(data);
    this.info = data.info;
    this._httpClient = new HttpClient();
    this._slot = data.slot;
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
