# JavaScript Invoice Manager: Single Responsibility Principle Practice

This exercise demonstrates the Single Responsibility Principle (SRP) with an Invoice Management system in JavaScript.
Each class has a specific job, making the code cleaner and easier to manage.

- First, try to implement on your own
- Functions should not do all the things. They only print and call other functions

## Explanation of SRP Application

1.  **`InvoiceCalculator`**: Its only job is to compute the final invoice amount. If how taxes or discounts are calculated changes, this is the only class that needs to be updated.
2.  **`InvoiceRenderer`**: Its only job is to create a representation of the invoice (like an HTML page or a PDF document). If you want to change how the invoice looks, or add a new format like CSV, this class is where you'd make changes.
3.  **`InvoiceSender`**: Its only job is to send the created invoice. If you decide to switch from sending emails to using a messaging app, this class would be modified.
4.  **`InvoiceManager`**: It doesn't do any of the actual work of calculating, rendering, or sending. Its single responsibility is to manage the sequence of these operations. If the business decides to add a new step, like logging the invoice to a database before sending, the `InvoiceManager` would change, but the other classes would remain untouched (unless the new step needed different information from them).

By following SRP, each part of the system is independent and can be changed without affecting other parts, making the whole system easier to develop and maintain.
