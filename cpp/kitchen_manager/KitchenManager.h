#ifndef KITCHENMANAGER_H
#define KITCHENMANAGER_H

#include "Chef.h"
#include "Dishwasher.h"
#include "Waiter.h"

class KitchenManager {
public:
    KitchenManager();
    void run();

private:
    Chef chef;
    Dishwasher dishwasher;
    Waiter waiter;
};

#endif //KITCHENMANAGER_H