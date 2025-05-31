const Chef = require('./Chef');
const Dishwasher = require('./Dishwasher');
const Waiter = require('./Waiter');

class KitchenManager {
  constructor() {
    this.chef = new Chef();
    this.dishwasher = new Dishwasher();
    this.waiter = new Waiter();
  }

  run() {
    this.chef.prepareFood();
    this.waiter.serveCustomers();
    this.dishwasher.washDishes();
  }
}

module.exports = KitchenManager;
