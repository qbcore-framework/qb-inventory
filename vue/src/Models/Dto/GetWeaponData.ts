export interface WeaponDataDto {
  AttachmentData: AttachmentData[]
  WeaponData: WeaponData
}

export interface AttachmentData {
  attachment: string
  label: string
}

export interface WeaponData {
  ammotype: string
  description: string
  image: string
  label: string
  name: string
  type: string
  unique: boolean
  useable: boolean
  weight: number
}
