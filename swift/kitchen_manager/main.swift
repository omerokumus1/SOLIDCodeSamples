
/*
Run this in the terminal. Current directory should be swift directory:
swiftc kitchen_manager/main.swift kitchen_manager/KitchenManager.swift kitchen_manager/Chef.swift kitchen_manager/Dishwasher.swift kitchen_manager/Waiter.swift -o main && ./main
*/
let kitchenManager = KitchenManager()
kitchenManager.run()