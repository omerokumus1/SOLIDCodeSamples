import Foundation

// Represents invoice data (simplified)
struct InvoiceData {
    var amount: Double
    // other details like customerId, items, etc.
}

// Represents a rendered invoice (e.g., as a string for this example)
struct RenderedInvoice {
    let content: String
    let format: String // "HTML", "PDF", "CSV"
}

// --- SRP Applied: Each class below has one responsibility ---

// Responsibility: Calculating invoice totals, including taxes and discounts.
// Reason to change: If tax rules or discount logic changes.
class InvoiceCalculator {
    func calculate(rawData: InvoiceData) -> InvoiceData {
        print("InvoiceCalculator: Calculating final amount including taxes and discounts.")
        // In a real app, apply tax rules and discounts to rawData.amount
        var calculatedData = rawData
        calculatedData.amount *= 1.10 // Example: Apply 10% tax
        print("InvoiceCalculator: Calculated amount is \(calculatedData.amount)")
        return calculatedData
    }
}

// Responsibility: Rendering an invoice into a specific format (HTML, PDF, CSV).
// Reason to change: If the rendering format details change (e.g., new PDF library, HTML template update).
class InvoiceRenderer {
    func render(data: InvoiceData, format: String) -> RenderedInvoice {
        print("InvoiceRenderer: Rendering invoice data to \(format) format.")
        let content = "Rendered content for amount: \(data.amount) in \(format)"
        print("InvoiceRenderer: Content: \"\(content)\"")
        return RenderedInvoice(content: content, format: format)
    }
}

// Responsibility: Sending a rendered invoice to a customer.
// Reason to change: If the method of sending changes (e.g., different email API, SMS integration).
class InvoiceSender {
    func send(renderedInvoice: RenderedInvoice, customerEmail: String) {
        print("InvoiceSender: Sending \(renderedInvoice.format) invoice to \(customerEmail).")
        // In a real app, this would use an email library or service.
        print("InvoiceSender: Content sent: \"\(renderedInvoice.content)\"")
    }
}

// Responsibility: Coordinating the invoice generation process.
// It delegates tasks to other classes, each with its own single responsibility.
// Reason to change: If the overall process flow changes (e.g., adding a logging step).
class InvoiceManager {
    private let calculator: InvoiceCalculator
    private let renderer: InvoiceRenderer
    private let sender: InvoiceSender

    init() {
        self.calculator = InvoiceCalculator()
        self.renderer = InvoiceRenderer()
        self.sender = InvoiceSender()
    }

    func processInvoice(rawData: InvoiceData, customerEmail: String, format: String) {
        print("\nInvoiceManager: Starting invoice processing for email: \(customerEmail)")

        // 1. Calculate the invoice details
        let calculatedData = calculator.calculate(rawData: rawData)

        // 2. Render the invoice to the desired format
        let renderedInvoice = renderer.render(data: calculatedData, format: format)

        // 3. Send the rendered invoice
        sender.send(renderedInvoice: renderedInvoice, customerEmail: customerEmail)

        print("InvoiceManager: Invoice processing finished.")
    }

    // The 'run' function to demonstrate the process
    func run() {
        print("--- Swift InvoiceManager SRP Example ---")
        let rawOrderData = InvoiceData(amount: 800.0) // Base amount
        let customerEmail = "swift.customer@example.com"

        // Process as HTML
        processInvoice(rawData: rawOrderData, customerEmail: customerEmail, format: "HTML")

        // Process as PDF
        processInvoice(rawData: rawOrderData, customerEmail: "another.swift.customer@example.com", format: "PDF")
        print("--- Swift InvoiceManager SRP Example End ---")
    }
}

// Main execution (e.g., in a main.swift file or a Playground)
func main() {
    let manager = InvoiceManager()
    manager.run()
}

main()