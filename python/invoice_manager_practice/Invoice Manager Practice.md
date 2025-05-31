# Python Invoice Manager: Single Responsibility Principle Practice

This exercise demonstrates the Single Responsibility Principle (SRP) using an Invoice Management system in Python.
Each class has a single, well-defined responsibility, improving code organization and maintainability.

- First, try to implement on your own
- Functions should not do all the things. They only print and call other functions

## Explanation of SRP Application

1.  **`InvoiceCalculator`**: Its sole purpose is to compute the invoice's final amount, including any taxes or discounts. If the business rules for these computations change, this is the only class that should need to be updated.
2.  **`InvoiceRenderer`**: This class is dedicated to taking the computed invoice data and formatting it for presentation (e.g., as an HTML page, a PDF document, or a CSV file). If you need to alter the appearance of the invoice or support a new output format, this is the class you would modify.
3.  **`InvoiceSender`**: The single job of this class is to deliver the formatted invoice to the customer. If the delivery method changes (for instance, switching from one email service provider to another, or adding an option to send by SMS), this class would be the one to change.
4.  **`InvoiceManager`**: This class doesn't perform any of the core tasks of calculation, rendering, or sending. Its one responsibility is to direct the overall process, coordinating the actions of the other specialized classes. If the sequence of operations in processing an invoice needs to change (e.g., adding a step to log the invoice details to a database before it's sent), the `InvoiceManager` is the class that would be updated. The other classes would typically remain unchanged unless the new process step required different inputs from them.

Adhering to SRP in this way results in a system where each component is focused and independent, making the entire application easier to understand, test, debug, and evolve over time.
