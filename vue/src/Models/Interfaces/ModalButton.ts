class ModalButton {
  onClick: () => void = () => undefined;
  constructor(
    public text: string,
    public returnVal: any,
  ) {}
}

export { ModalButton };
