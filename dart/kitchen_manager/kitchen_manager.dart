import 'chef.dart';
import 'dishwasher.dart';
import 'waiter.dart';

class KitchenManager {
  final Chef _chef = Chef();
  final Dishwasher _dishwasher = Dishwasher();
  final Waiter _waiter = Waiter();

  void run() {
    _chef.prepareFood();
    _waiter.serveCustomers();
    _dishwasher.washDishes();
  }
}