package kitchen_manager

class KitchenManager {
    private val chef = Chef()
    private val dishwasher = Dishwasher()
    private val waiter = Waiter()

    fun run() {
        chef.prepareFood()
        waiter.serveCustomers()
        dishwasher.washDishes()
    }
}