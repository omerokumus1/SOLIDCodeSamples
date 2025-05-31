using System;

namespace KitchenManagerApp
{
    public class KitchenManager
    {
        private Chef chef = new Chef();
        private Dishwasher dishwasher = new Dishwasher();
        private Waiter waiter = new Waiter();

        public void Run()
        {
            chef.PrepareFood();
            waiter.ServeCustomers();
            dishwasher.WashDishes();
        }
    }
}