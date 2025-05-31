# Swift Invoice Manager: Single Responsibility Principle Practice

This exercise demonstrates the Single Responsibility Principle (SRP) using an Invoice Management system in Swift.
Each class has a clearly defined responsibility, leading to a more modular and maintainable codebase.

- First, try to implement on your own
- Functions should not do all the things. They only print and call other functions

## Explanation of SRP Application

1.  **`InvoiceCalculator`**: Its singular focus is on performing all necessary calculations for an invoice, such as applying taxes or discounts. If the rules for these calculations change, this is the only class that needs to be updated.
2.  **`InvoiceRenderer`**: This class is dedicated to transforming the calculated invoice data into a specific presentational format, for example, an HTML document or a PDF file. If there's a need to alter the visual design of the invoice or to introduce a new output format (like CSV), these changes would be confined to this class.
3.  **`InvoiceSender`**: The sole responsibility of this class is to dispatch the generated invoice to the customer. Should the method of delivery change (e.g., moving from one email service to another, or incorporating SMS notifications), this class is the one that would be modified.
4.  **`InvoiceManager`**: This class does not handle any of the intrinsic tasks of calculation, rendering, or sending. Its unique responsibility is to oversee the entire process, by coordinating the operations of the other specialized classes. If the overall workflow for processing an invoice needs to be adjusted (for instance, by adding a step to archive the invoice details in a database before it is dispatched), the `InvoiceManager` is the class that would undergo changes. The other component classes would generally remain unaffected unless the new process step necessitated different inputs from them.

By adhering to the Single Responsibility Principle, each component of the system becomes more specialized and independent. This enhances the overall clarity, testability, and maintainability of the application, making it easier to adapt to future changes.
