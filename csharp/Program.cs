using UserExample.Bad;
using UserExample.Good;
using KitchenManagerApp;
using InvoiceManagerSolution;

// UserBadExample.Run();
// UserGoodExample.Run();

KitchenManager kitchenManager = new KitchenManager();
kitchenManager.Run();

InvoiceManager manager = new InvoiceManager();
manager.Run();