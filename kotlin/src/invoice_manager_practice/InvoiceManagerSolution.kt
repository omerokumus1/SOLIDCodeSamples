package invoice_manager_practice

// Represents invoice data (simplified)
data class InvoiceData(var amount: Double)
// other details like customerId, items, etc. could be added

// Represents a rendered invoice (e.g., as a string for this example)
data class RenderedInvoice(val content: String, val format: String) // "HTML", "PDF", "CSV"

// --- SRP Applied: Each class below has one responsibility ---

// Responsibility: Calculating invoice totals, including taxes and discounts.
// Reason to change: If tax rules or discount logic changes.
class InvoiceCalculator {
    fun calculate(rawData: InvoiceData): InvoiceData {
        println("InvoiceCalculator: Calculating final amount including taxes and discounts.")
        // In a real app, apply tax rules and discounts to rawData.amount
        val calculatedData = rawData.copy()
        calculatedData.amount *= 1.10 // Example: Apply 10% tax
        println("InvoiceCalculator: Calculated amount is ${calculatedData.amount}")
        return calculatedData
    }
}

// Responsibility: Rendering an invoice into a specific format (HTML, PDF, CSV).
// Reason to change: If the rendering format details change (e.g., new PDF library, HTML template update).
class InvoiceRenderer {
    fun render(data: InvoiceData, format: String): RenderedInvoice {
        println("InvoiceRenderer: Rendering invoice data to $format format.")
        val content = "Rendered content for amount: ${data.amount} in $format"
        println("InvoiceRenderer: Content: \"$content\"")
        return RenderedInvoice(content, format)
    }
}

// Responsibility: Sending a rendered invoice to a customer.
// Reason to change: If the method of sending changes (e.g., different email API, SMS integration).
class InvoiceSender {
    fun send(renderedInvoice: RenderedInvoice, customerEmail: String) {
        println("InvoiceSender: Sending ${renderedInvoice.format} invoice to $customerEmail.")
        // In a real app, this would use an email library or service.
        println("InvoiceSender: Content sent: \"${renderedInvoice.content}\"")
    }
}

// Responsibility: Coordinating the invoice generation process.
// It delegates tasks to other classes, each with its own single responsibility.
// Reason to change: If the overall process flow changes (e.g., adding a logging step).
class InvoiceManager {
    private val calculator = InvoiceCalculator()
    private val renderer = InvoiceRenderer()
    private val sender = InvoiceSender()

    fun processInvoice(rawData: InvoiceData, customerEmail: String, format: String) {
        println("\nInvoiceManager: Starting invoice processing for email: $customerEmail")

        // 1. Calculate the invoice details
        val calculatedData = calculator.calculate(rawData)

        // 2. Render the invoice to the desired format
        val renderedInvoice = renderer.render(calculatedData, format)

        // 3. Send the rendered invoice
        sender.send(renderedInvoice, customerEmail)

        println("InvoiceManager: Invoice processing finished.")
    }

    // The 'run' function to demonstrate the process
    fun run() {
        println("--- Kotlin InvoiceManager SRP Example ---")
        val rawOrderData = InvoiceData(amount = 600.0) // Base amount
        val customerEmail = "kotlin.customer@example.com"

        // Process as HTML
        processInvoice(rawOrderData, customerEmail, "HTML")

        // Process as PDF
        processInvoice(rawOrderData, "another.kotlin.customer@example.com", "PDF")
        println("--- Kotlin InvoiceManager SRP Example End ---")
    }
}

// Main function to execute the example
fun main() {
    val manager = InvoiceManager()
    manager.run()
}