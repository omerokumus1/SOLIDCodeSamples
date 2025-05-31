class InvoiceData:
    """Represents invoice data (simplified)."""
    def __init__(self, amount: float):
        self.amount = amount
        # other details like customer_id, items, etc.

class RenderedInvoice:
    """Represents a rendered invoice (e.g., as a string for this example)."""
    def __init__(self, content: str, format_type: str):
        self.content = content
        self.format_type = format_type  # "HTML", "PDF", "CSV"

# --- SRP Applied: Each class below has one responsibility ---

class InvoiceCalculator:
    """Responsibility: Calculating invoice totals, including taxes and discounts.
       Reason to change: If tax rules or discount logic changes."""
    def calculate(self, raw_data: InvoiceData) -> InvoiceData:
        print("InvoiceCalculator: Calculating final amount including taxes and discounts.")
        # In a real app, apply tax rules and discounts to raw_data.amount
        calculated_data = InvoiceData(amount=raw_data.amount)
        calculated_data.amount *= 1.10  # Example: Apply 10% tax
        print(f"InvoiceCalculator: Calculated amount is {calculated_data.amount}")
        return calculated_data

class InvoiceRenderer:
    """Responsibility: Rendering an invoice into a specific format (HTML, PDF, CSV).
       Reason to change: If rendering format details change (e.g., new PDF library, HTML template update)."""
    def render(self, data: InvoiceData, format_type: str) -> RenderedInvoice:
        print(f"InvoiceRenderer: Rendering invoice data to {format_type} format.")
        content = f"Rendered content for amount: {data.amount} in {format_type}"
        print(f'InvoiceRenderer: Content: "{content}"')
        return RenderedInvoice(content=content, format_type=format_type)

class InvoiceSender:
    """Responsibility: Sending a rendered invoice to a customer.
       Reason to change: If the method of sending changes (e.g., different email API, SMS integration)."""
    def send(self, rendered_invoice: RenderedInvoice, customer_email: str):
        print(f"InvoiceSender: Sending {rendered_invoice.format_type} invoice to {customer_email}.")
        # In a real app, this would use an email library or service.
        print(f'InvoiceSender: Content sent: "{rendered_invoice.content}"')

class InvoiceManager:
    """Responsibility: Coordinating the invoice generation process.
       It delegates tasks to other classes, each with its own single responsibility.
       Reason to change: If the overall process flow changes (e.g., adding a logging step)."""
    def __init__(self):
        self.calculator = InvoiceCalculator()
        self.renderer = InvoiceRenderer()
        self.sender = InvoiceSender()

    def process_invoice(self, raw_data: InvoiceData, customer_email: str, format_type: str):
        print(f"\nInvoiceManager: Starting invoice processing for email: {customer_email}")

        # 1. Calculate the invoice details
        calculated_data = self.calculator.calculate(raw_data)

        # 2. Render the invoice to the desired format
        rendered_invoice = self.renderer.render(calculated_data, format_type)

        # 3. Send the rendered invoice
        self.sender.send(rendered_invoice, customer_email)

        print("InvoiceManager: Invoice processing finished.")

    def run(self):
        """The 'run' function to demonstrate the process."""
        print("--- Python InvoiceManager SRP Example ---")
        raw_order_data = InvoiceData(amount=700.0)  # Base amount
        customer_email = "python.customer@example.com"

        # Process as HTML
        self.process_invoice(raw_order_data, customer_email, "HTML")

        # Process as PDF
        self.process_invoice(raw_order_data, "another.python.customer@example.com", "PDF")
        print("--- Python InvoiceManager SRP Example End ---")

# Main execution block
if __name__ == "__main__":
    manager = InvoiceManager()
    manager.run()