import inventoryOpenEvent from "@/../cypress/fixtures/inventory-open-event.json";

function NuiEventMocker() {
  // Listen to tab
  window.addEventListener("keydown", (e) => {
    if (e.repeat) return;

    // This can't be tab because that also would trigger the close event
    if (e.key === "`") {
      e.preventDefault();
      openInventory();
    }
  });

  // Open inventory on load
  openInventory();
}

function openInventory() {
  window.postMessage(inventoryOpenEvent);
}

export { NuiEventMocker };
