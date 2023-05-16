interface WeaponInfo {
  ammo: number;
  quality: number;
  serie: string;
  attachments: {
    component: string;
    item: string;
    label: string;
  }[];
}