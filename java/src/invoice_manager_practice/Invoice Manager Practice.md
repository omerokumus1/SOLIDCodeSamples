# Java Invoice Manager: Single Responsibility Principle Practice

This exercise demonstrates the Single Responsibility Principle (SRP) using an Invoice Management system in Java.
Each class is designed to have only one reason to change, promoting modularity and maintainability.

- First, try to implement on your own
- Functions should not do all the things. They only print and call other functions

## Explanation of SRP Application

1.  **`InvoiceCalculator`**: Dedicated to invoice calculations (e.g., applying taxes, discounts). If calculation rules evolve, only this class is impacted.
2.  **`InvoiceRenderer`**: Focused on converting invoice data into a specific output format (like HTML or PDF). Changes in presentation or support for new formats are confined to this class.
3.  **`InvoiceSender`**: Handles the dispatch of the rendered invoice. Modifications to the sending mechanism (e.g., changing email services) are isolated here.
4.  **`InvoiceManager`**: Orchestrates the workflow by calling the other specialized classes. If the sequence of operations for invoice processing changes (e.g., adding an archival step), this class is updated, while the individual components remain stable.

This design adheres to SRP, leading to a system that is easier to test, debug, and extend.
