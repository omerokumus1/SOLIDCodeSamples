# TypeScript Invoice Manager: Single Responsibility Principle Practice

This exercise demonstrates the Single Responsibility Principle (SRP) with an Invoice Management system in TypeScript.
Each class has a distinct role, leading to a more organized, testable, and maintainable codebase.

- First, try to implement on your own
- Functions should not do all the things. They only print and call other functions

## Explanation of SRP Application

1.  **`InvoiceCalculator`**: This class is solely responsible for all calculations related to an invoice, such as computing taxes and applying discounts. If the mathematical or business logic for these calculations changes, this is the only class that needs modification.
2.  **`InvoiceRenderer`**: Its single purpose is to take the finalized invoice data and generate a representation in a specific format (e.g., HTML for web display, PDF for a printable document). If you need to change how an invoice is presented visually, or if you want to support a new output format like CSV, this is the class you would alter.
3.  **`InvoiceSender`**: This class has one job: to send the rendered invoice to the customer. If the means of delivery needs to change (for example, switching from an internal SMTP server to a cloud-based email service, or adding the ability to send invoices via a messaging platform), this class is the one that would be updated.
4.  **`InvoiceManager`**: The `InvoiceManager` itself does not perform any calculation, rendering, or sending. Its single responsibility is to orchestrate these tasks by coordinating the `InvoiceCalculator`, `InvoiceRenderer`, and `InvoiceSender`. If the overall business process for handling invoices changes (e.g., adding a new step like archiving the invoice in a document management system before it's sent), then the `InvoiceManager` is the class that would change. The individual component classes would likely remain untouched unless the new step required them to handle different data or provide new functionalities.

By applying SRP, each class becomes more focused and cohesive. This makes the system easier to understand, test, and maintain, as changes in one area of responsibility are less likely to have unintended consequences in other areas.
