# Dart Invoice Manager: Single Responsibility Principle Practice

This exercise demonstrates the Single Responsibility Principle (SRP) using an Invoice Management system in Dart.
Each class has a distinct responsibility, making the system more maintainable.

- First, try to implement on your own
- Functions should not do all the things. They only print and call other functions

## Explanation of SRP Application

1.  **`InvoiceCalculator`**: Solely responsible for calculations (taxes, discounts). Changes to calculation logic only affect this class.
2.  **`InvoiceRenderer`**: Solely responsible for formatting the invoice (HTML, PDF, etc.). Changes to output appearance or new formats affect only this class.
3.  **`InvoiceSender`**: Solely responsible for sending the invoice. Changes to delivery methods (email, SMS) affect only this class.
4.  **`InvoiceManager`**: Solely responsible for orchestrating the invoice process. It delegates to the other classes. If the overall process changes (e.g., adding a notification step), this class is modified, but the others are not (unless they need to provide different information for the new step).

This separation of concerns enhances code clarity, testability, and ease of maintenance.
