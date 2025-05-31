class KitchenManager {
    private let chef = Chef()
    private let dishwasher = Dishwasher()
    private let waiter = Waiter()

    func run() {
        chef.prepareFood()
        waiter.serveCustomers()
        dishwasher.washDishes()
    }
}