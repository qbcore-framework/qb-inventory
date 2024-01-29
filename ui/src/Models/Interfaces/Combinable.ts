export interface Combinable {
  accept: string[];
  reward: string; // Item name
  anim?: {
    text: string;
    dict: string;
    timeOut: number;
    lib: string;
  };
}
