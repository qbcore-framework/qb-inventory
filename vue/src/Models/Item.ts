interface Item {
  name: string;
  amount: number;
  info: object;
  slot: number;
  label: string;
  description: string;
  weight: number;
  type: string;
  unique: boolean;
  usable: boolean;
  image: string;
  id: number;
  shouldClose?: boolean;
}

export default Item;