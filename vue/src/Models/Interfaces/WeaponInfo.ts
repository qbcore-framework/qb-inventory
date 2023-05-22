import { WeaponAttachment } from "./WeaponAttachment";

interface WeaponInfo {
  ammo: number;
  quality: number;
  serie: string;
  attachments: WeaponAttachment[];
}

export { WeaponInfo };
