let isInventoryOpen = false;

function NuiEventMocker() {
  // Listen to tab
  window.addEventListener("keydown", (e) => {
    if (e.repeat) return;

    if (e.key === "Tab") {
      e.preventDefault();
      if (!isInventoryOpen) {
        openInventory();
      }
      isInventoryOpen = !isInventoryOpen;
    }
  });
}

function openInventory() {
  // TODO: Implement mocking NUI open event
  // window.postMessage({
  //   action: "close",
  // });
}

export { NuiEventMocker };
