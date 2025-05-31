# C# Invoice Manager: Single Responsibility Principle Practice

This exercise demonstrates the Single Responsibility Principle (SRP) using an Invoice Management system.
Each class in this example has a single reason to change.

- First, try to implement on your own
- Functions should not do all the things. They only print and call other functions

## Explanation of SRP Application

1.  **`InvoiceCalculator`**: Its sole responsibility is to perform calculations. If tax laws change, this class changes.
2.  **`InvoiceRenderer`**: Its sole responsibility is to format the invoice. If you want to change the PDF layout, this class changes.
3.  **`InvoiceSender`**: Its sole responsibility is to send the invoice. If you switch from SMTP to a third-party email API, this class changes.
4.  **`InvoiceManager`**: Its sole responsibility is to manage the overall workflow. If the business decides to add a step (e.g., save to database before sending), this class changes, but the others remain unaffected.

This adherence to SRP leads to a more modular, understandable, and maintainable codebase.
