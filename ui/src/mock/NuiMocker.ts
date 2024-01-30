import inventoryOpenEvent from "@/../cypress/fixtures/inventory-open-event.json";
import inventoryOpenContainerEvent from "@/../cypress/fixtures/inventory-open-container-event.json";
import fetchGetWeaponDataResponse from "@/../cypress/fixtures/fetch-get-weapon-data-response.json";
import inventoryToggleHotbarEvent from "@/../cypress/fixtures/inventory-toggle-hotbar-event.json";

///
/// This file is not included in production builds. It is used to allow for UI development outside of the game.
/// Imports of this file are configured in: vue.config.js
///

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
    } else if (e.key === "z") {
      e.preventDefault();
      toggleToolBar();
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

function toggleToolBar() {
  window.postMessage({ action: "close" });
  window.postMessage(inventoryToggleHotbarEvent);
}

// This is a hacky way to check if we're in a dev environment
if (process.env.NODE_ENV === "development") {
  try {
    await fetch("https://qb-inventory/");
    console.log("Running in game");
  } catch (e) {
    console.log("Running in browser");
    NuiMocker();
  }
} else {
  throw new Error("This file should only be included in development builds");
}
