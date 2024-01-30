import openEvent from "../fixtures/inventory-open-event.json";

describe("Open inventory", () => {
  beforeEach(() => {
    cy.visit("http://localhost:3000");
    cy.window().then((win) => win.postMessage(openEvent));
  });

  it("should open the inventory", () => {
    cy.get(".item-group").should("be.visible");
  });

  it("should close the inventory", () => {
    cy.get(".item-group").should("be.visible");
    cy.intercept("/CloseInventory", {
      statusCode: 200,
      body: {},
    }).as("closeInventory");

    cy.get("body").type("{esc}");

    cy.get(".item-group").should("not.exist");
    cy.wait("@closeInventory");
  });

  // Scrolling is disabled as this test sometimes seems to scroll the page when it shouldn't
  it("should swap items", { scrollBehavior: false }, () => {
    // Find img with "phone" in src and get parent
    const phone = cy.get(".item-container").find("img[src*='phone']").parent();
    const idCard = cy
      .get(".item-container")
      .find("img[src*='id_card']")
      .parent();

    phone.should("be.visible");
    idCard.should("be.visible");

    cy.intercept("/SetInventoryData", { statusCode: 200, body: {} }).as(
      "setInventoryData",
    );

    phone
      .realMouseDown()
      .realMouseMove(-300, 0, { position: "center" })
      .wait(300)
      .realMouseUp();

    cy.wait("@setInventoryData");
  });

  // Scrolling is disabled as this test sometimes seems to scroll the page when it shouldn't
  it("Should quick move items", { scrollBehavior: false }, () => {
    const phone = cy.get(".item-container").find("img[src*='phone']");

    phone.should("be.visible");

    cy.intercept("/SetInventoryData", { statusCode: 200, body: {} }).as(
      "setInventoryData",
    );

    phone.realClick({ button: "right" });

    cy.wait("@setInventoryData");

    cy.get(".item-container").find("img[src*='phone']").should("not.exist");
  });
});
