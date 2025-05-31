#include <iostream>
#include <string>
#include <vector> // Not strictly needed for this simple example, but typical for real-world

// Represents invoice data (simplified)
struct InvoiceData {
    double amount;
    // other details like customerId, items, etc.
};

// Represents a rendered invoice (e.g., as a string for this example)
struct RenderedInvoice {
    std::string content;
    std::string format; // "HTML", "PDF", "CSV"
};

// --- SRP Applied: Each class below has one responsibility ---

// Responsibility: Calculating invoice totals, including taxes and discounts.
// Reason to change: If tax rules or discount logic changes.
class InvoiceCalculator {
public:
    InvoiceData calculate(const InvoiceData& rawData) {
        std::cout << "InvoiceCalculator: Calculating final amount including taxes and discounts." << std::endl;
        // In a real app, apply tax rules and discounts to rawData.amount
        InvoiceData calculatedData = rawData;
        calculatedData.amount *= 1.10; // Example: Apply 10% tax
        std::cout << "InvoiceCalculator: Calculated amount is " << calculatedData.amount << std::endl;
        return calculatedData;
    }
};

// Responsibility: Rendering an invoice into a specific format (HTML, PDF, CSV).
// Reason to change: If the rendering format détails change (e.g., new PDF library, HTML template update).
class InvoiceRenderer {
public:
    RenderedInvoice render(const InvoiceData& data, const std::string& format) {
        std::cout << "InvoiceRenderer: Rendering invoice data to " << format << " format." << std::endl;
        std::string content = "Rendered content for amount: " + std::to_string(data.amount) + " in " + format;
        std::cout << "InvoiceRenderer: Content: \"" << content << "\"" << std::endl;
        return {content, format};
    }
};

// Responsibility: Sending a rendered invoice to a customer.
// Reason to change: If the method of sending changes (e.g., different email API, SMS integration).
class InvoiceSender {
public:
    void send(const RenderedInvoice& renderedInvoice, const std::string& customerEmail) {
        std::cout << "InvoiceSender: Sending " << renderedInvoice.format
                  << " invoice to " << customerEmail << "." << std::endl;
        // In a real app, this would use an email library or service.
        std::cout << "InvoiceSender: Content sent: \"" << renderedInvoice.content << "\"" << std::endl;
    }
};

// Responsibility: Coordinating the invoice generation process.
// It delegates tasks to other classes, each with its own single responsibility.
// Reason to change: If the overall process flow changes (e.g., adding a logging step).
class InvoiceManager {
private:
    InvoiceCalculator calculator;
    InvoiceRenderer renderer;
    InvoiceSender sender;

public:
    InvoiceManager() : calculator(), renderer(), sender() {}

    void processInvoice(const InvoiceData& rawData, const std::string& customerEmail, const std::string& format) {
        std::cout << "\nInvoiceManager: Starting invoice processing for email: " << customerEmail << std::endl;

        // 1. Calculate the invoice details
        InvoiceData calculatedData = calculator.calculate(rawData);

        // 2. Render the invoice to the desired format
        RenderedInvoice renderedInvoice = renderer.render(calculatedData, format);

        // 3. Send the rendered invoice
        sender.send(renderedInvoice, customerEmail);

        std::cout << "InvoiceManager: Invoice processing finished." << std::endl;
    }

    // The 'run' function to demonstrate the process
    void run() {
        std::cout << "--- C++ InvoiceManager SRP Example ---" << std::endl;
        InvoiceData rawOrderData = {100.0}; // Base amount for the invoice
        std::string customerEmail = "customer@example.com";

        // Process as HTML
        processInvoice(rawOrderData, customerEmail, "HTML");

        // Process as PDF
        processInvoice(rawOrderData, "another_customer@example.com", "PDF");
        std::cout << "--- C++ InvoiceManager SRP Example End ---" << std::endl;
    }
};

/*
g++ invoice_manager_solution.cpp -o invoice_manager_solution
./invoice_manager_solution
*/
int main() {
    InvoiceManager manager;
    manager.run();
    return 0;
}