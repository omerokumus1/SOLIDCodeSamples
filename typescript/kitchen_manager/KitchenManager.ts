import { Chef } from './Chef';
import { Dishwasher } from './Dishwasher';
import { Waiter } from './Waiter';

export class KitchenManager {
  private chef: Chef = new Chef();
  private dishwasher: Dishwasher = new Dishwasher();
  private waiter: Waiter = new Waiter();

  public run(): void {
    this.chef.prepareFood();
    this.waiter.serveCustomers();
    this.dishwasher.washDishes();
  }
}
