import { HttpClient } from "@/plugins/HttpClient";
import { Item } from "./Item";
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
    slot: number,
    name: string,
    amount: number,
    info: WeaponInfo,
    label: string,
    description: string,
    weight: number,
    type: string,
    unique: boolean,
    usable: boolean,
    image: string,
    id: number,
    shouldClose?: boolean
  ) {
    // eslint-disable-next-line prettier/prettier
    super(name, amount, info, label, description, weight, type, unique, usable, image, id, shouldClose);
    this.info = info;
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
