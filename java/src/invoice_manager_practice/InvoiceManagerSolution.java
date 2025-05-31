package invoice_manager_practice;

// Represents invoice data (simplified)
class InvoiceData {
    public double amount;
    // other details like customerId, items, etc.

    public InvoiceData(double amount) {
        this.amount = amount;
    }
}

// Represents a rendered invoice (e.g., as a string for this example)
class RenderedInvoice {
    public String content;
    public String format; // "HTML", "PDF", "CSV"

    public RenderedInvoice(String content, String format) {
        this.content = content;
        this.format = format;
    }
}

// --- SRP Applied: Each class below has one responsibility ---

// Responsibility: Calculating invoice totals, including taxes and discounts.
// Reason to change: If tax rules or discount logic changes.
class InvoiceCalculator {
    public InvoiceData calculate(InvoiceData rawData) {
        System.out.println("InvoiceCalculator: Calculating final amount including taxes and discounts.");
        // In a real app, apply tax rules and discounts to rawData.amount
        InvoiceData calculatedData = new InvoiceData(rawData.amount);
        calculatedData.amount *= 1.10; // Example: Apply 10% tax
        System.out.println("InvoiceCalculator: Calculated amount is " + calculatedData.amount);
        return calculatedData;
    }
}

// Responsibility: Rendering an invoice into a specific format (HTML, PDF, CSV).
// Reason to change: If the rendering format details change (e.g., new PDF library, HTML template update).
class InvoiceRenderer {
    public RenderedInvoice render(InvoiceData data, String format) {
        System.out.println("InvoiceRenderer: Rendering invoice data to " + format + " format.");
        String content = "Rendered content for amount: " + data.amount + " in " + format;
        System.out.println("InvoiceRenderer: Content: \"" + content + "\"");
        return new RenderedInvoice(content, format);
    }
}

// Responsibility: Sending a rendered invoice to a customer.
// Reason to change: If the method of sending changes (e.g., different email API, SMS integration).
class InvoiceSender {
    public void send(RenderedInvoice renderedInvoice, String customerEmail) {
        System.out.println("InvoiceSender: Sending " + renderedInvoice.format + " invoice to " + customerEmail + ".");
        // In a real app, this would use an email library or service.
        System.out.println("InvoiceSender: Content sent: \"" + renderedInvoice.content + "\"");
    }
}

// Responsibility: Coordinating the invoice generation process.
// It delegates tasks to other classes, each with its own single responsibility.
// Reason to change: If the overall process flow changes (e.g., adding a logging step).
class InvoiceManager {
    private final InvoiceCalculator calculator;
    private final InvoiceRenderer renderer;
    private final InvoiceSender sender;

    public InvoiceManager() {
        this.calculator = new InvoiceCalculator();
        this.renderer = new InvoiceRenderer();
        this.sender = new InvoiceSender();
    }

    public void processInvoice(InvoiceData rawData, String customerEmail, String format) {
        System.out.println("\nInvoiceManager: Starting invoice processing for email: " + customerEmail);

        // 1. Calculate the invoice details
        InvoiceData calculatedData = calculator.calculate(rawData);

        // 2. Render the invoice to the desired format
        RenderedInvoice renderedInvoice = renderer.render(calculatedData, format);

        // 3. Send the rendered invoice
        sender.send(renderedInvoice, customerEmail);

        System.out.println("InvoiceManager: Invoice processing finished.");
    }

    // The 'run' function to demonstrate the process
    public void run() {
        System.out.println("--- Java InvoiceManager SRP Example ---");
        InvoiceData rawOrderData = new InvoiceData(400.0); // Base amount
        String customerEmail = "java.customer@example.com";

        // Process as HTML
        processInvoice(rawOrderData, customerEmail, "HTML");

        // Process as PDF
        processInvoice(rawOrderData, "another.java.customer@example.com", "PDF");
        System.out.println("--- Java InvoiceManager SRP Example End ---");
    }
}

// Main class to execute the example
public class InvoiceManagerSolution {
    public static void main(String[] args) {
        InvoiceManager manager = new InvoiceManager();
        manager.run();
    }
}