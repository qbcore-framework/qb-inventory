import openEvent from '../fixtures/inventory-open-event.json';

describe('Open inventory', () => {
  beforeEach(() => {
    cy.visit('http://localhost:3000')
    cy.window().then(win => win.postMessage(openEvent));
  })

  it('should open the inventory', () => {
    cy.get('.item-group').should('be.visible');
  })

  it('should close the inventory', () => {
    cy.get('.item-group').should('be.visible');
    cy.intercept(
      '/CloseInventory',
      {
        statusCode: 200,
        body: {}
      }
    ).as('closeInventory');

    cy.get('body').type('{esc}');

    cy.get('.item-group').should('not.exist');
    cy.wait('@closeInventory');
  });

  it.only('should swap items', () => {
    const phone = cy.get('.item-container').contains('Phone').parent();
    const idCard = cy.get('.item-container').contains('ID Card').parent();

    phone.should('be.visible');
    idCard.should('be.visible');

    cy.intercept('/SetInventoryData', { statusCode: 200, body: {} })
      .as('setInventoryData');

    phone
      .realMouseDown()
      .realMouseMove(-150, 200, { position: 'center' })
      .wait(300)
      .realMouseUp();

    cy.wait('@setInventoryData');
  });
})