# C++ Invoice Manager: Single Responsibility Principle Practice

This exercise demonstrates the Single Responsibility Principle (SRP) using an Invoice Management system.
Each class in this example has a single reason to change.

- First, try to implement on your own
- Functions should not do all the things. They only print and call other functions

## Explanation of SRP Application

1.  **`InvoiceCalculator`**: Its sole responsibility is to perform calculations related to the invoice (e.g., taxes, discounts). If the calculation logic changes, this is the only class that needs modification.
2.  **`InvoiceRenderer`**: Its sole responsibility is to format the invoice data into a presentable form (e.g., HTML, PDF). If you need to change how an invoice looks, or support a new format, this is the class to change.
3.  **`InvoiceSender`**: Its sole responsibility is to send the rendered invoice. If the method of sending changes (e.g., switching email providers, adding SMS notifications), this class is modified.
4.  **`InvoiceManager`**: It does not handle any calculation, rendering, or sending logic itself. Its single responsibility is to orchestrate the overall process by coordinating these specialized classes. If the steps in processing an invoice change (e.g., adding a logging step before sending), then `InvoiceManager` would change, but the individual component classes would not (unless the new step required different data from them).

This separation makes the system more robust, easier to understand, and simpler to maintain, as changes in one area of responsibility are less likely to impact others.
