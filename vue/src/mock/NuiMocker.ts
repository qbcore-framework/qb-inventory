import inventoryOpenEvent from "@/../cypress/fixtures/inventory-open-event.json";
import inventoryOpenContainerEvent from "@/../cypress/fixtures/inventory-open-container-event.json";
import fetchGetWeaponDataResponse from "@/../cypress/fixtures/fetch-get-weapon-data-response.json";

function NuiMocker() {
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

  // monkey patch fetch to intercept "GetWeaponData"
  const originalFetch = window.fetch;

  window.fetch = async function (input: RequestInfo | URL, init?: RequestInit) {
    if (typeof input === "string" && input.includes("GetWeaponData")) {
      return {
        json: async () => fetchGetWeaponDataResponse,
      } as Response;
    }

    return originalFetch(input, init);
  };

  // Open inventory on load
  openInventoryWithFilledContainer();
}

function openInventoryWithEmptyContainer() {
  window.postMessage(inventoryOpenEvent);
}

function openInventoryWithFilledContainer() {
  window.postMessage(inventoryOpenContainerEvent);
}

export { NuiMocker };
