# Kotlin Invoice Manager: Single Responsibility Principle Practice

This exercise illustrates the Single Responsibility Principle (SRP) with an Invoice Management system in Kotlin.
Each class is focused on a single task, enhancing code organization and flexibility.

- First, try to implement on your own
- Functions should not do all the things. They only print and call other functions

## Explanation of SRP Application

1.  **`InvoiceCalculator`**: Its single responsibility is to calculate the invoice amount, applying any necessary taxes or discounts. If the logic for these calculations changes, this is the only class that needs to be modified.
2.  **`InvoiceRenderer`**: This class is solely responsible for taking the calculated invoice data and formatting it into a specific output, like HTML or PDF. If you need to change the visual representation of an invoice or support a new output format, only this class will be affected.
3.  **`InvoiceSender`**: The sole purpose of this class is to send the rendered invoice to the customer. If the delivery mechanism changes (e.g., switching email providers, or adding an option to send via SMS), this is the class to update.
4.  **`InvoiceManager`**: This class does not perform any calculations, rendering, or sending itself. Its single responsibility is to orchestrate the overall process by coordinating the `InvoiceCalculator`, `InvoiceRenderer`, and `InvoiceSender`. If the sequence of operations in invoice processing changes (e.g., adding a step to save the invoice to a database before sending), the `InvoiceManager` would be the class to modify. The other classes would remain unchanged unless the new step required different data from them.

This separation of responsibilities makes each class more focused, easier to understand, test, and maintain. Changes in one aspect of the invoice processing are less likely to inadvertently affect other aspects.
