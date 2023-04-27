import openEvent from '../fixtures/inventory-open-event.json';

describe('Open inventory', () => {
  beforeEach(() => {
    cy.visit('http://localhost:3000')
    cy.window().then(win => win.postMessage(openEvent));
  })

  it('should open the inventory', () => {
    cy.get('.item-group').should('be.visible');
  })
})