import inventoryOpenEvent from "@/../cypress/fixtures/inventory-open-event.json";
import inventoryOpenContainerEvent from "@/../cypress/fixtures/inventory-open-container-event.json";

function NuiEventMocker() {
  // Listen to tab
  window.addEventListener("keydown", (e) => {
    if (e.repeat) return;

    // This can't be tab because that also would trigger the close event
    if (e.key === "`") {
      e.preventDefault();
      openInventoryWithEmptyContainer();
    } else if (e.key === "1") {
      e.preventDefault();
      openInventoryWithFilledContainer();
    }
  });

  // Open inventory on load
  openInventoryWithFilledContainer();
}

function openInventoryWithEmptyContainer() {
  window.postMessage(inventoryOpenEvent);
}

function openInventoryWithFilledContainer() {
  window.postMessage(inventoryOpenContainerEvent);
}

export { NuiEventMocker };
