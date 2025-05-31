from chef import Chef
from dishwasher import Dishwasher
from waiter import Waiter

class KitchenManager:
    def __init__(self):
        self.chef = Chef()
        self.dishwasher = Dishwasher()
        self.waiter = Waiter()

    def run(self):
        self.chef.prepare_food()
        self.waiter.serve_customers()
        self.dishwasher.wash_dishes()