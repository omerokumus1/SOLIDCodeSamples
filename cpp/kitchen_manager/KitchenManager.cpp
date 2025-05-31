#include "KitchenManager.h"

KitchenManager::KitchenManager() : chef(), dishwasher(), waiter() {}

void KitchenManager::run() {
    chef.prepareFood();
    waiter.serveCustomers();
    dishwasher.washDishes();
}