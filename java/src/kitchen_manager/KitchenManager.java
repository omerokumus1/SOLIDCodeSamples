package kitchen_manager;

public class KitchenManager {
    private Chef chef = new Chef();
    private Dishwasher dishwasher = new Dishwasher();
    private Waiter waiter = new Waiter();

    public void run() {
        chef.prepareFood();
        waiter.serveCustomers();
        dishwasher.washDishes();
    }
}