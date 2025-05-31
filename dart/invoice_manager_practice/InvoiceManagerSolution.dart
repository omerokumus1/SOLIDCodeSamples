// Represents invoice data (simplified)
class InvoiceData {
  double amount;
  // other details like customerId, items, etc.
  InvoiceData({required this.amount});
}

// Represents a rendered invoice (e.g., as a string for this example)
class RenderedInvoice {
  String content;
  String format; // "HTML", "PDF", "CSV"
  RenderedInvoice({required this.content, required this.format});
}

// --- SRP Applied: Each class below has one responsibility ---

// Responsibility: Calculating invoice totals, including taxes and discounts.
// Reason to change: If tax rules or discount logic changes.
class InvoiceCalculator {
  InvoiceData calculate(InvoiceData rawData) {
    print('InvoiceCalculator: Calculating final amount including taxes and discounts.');
    // In a real app, apply tax rules and discounts to rawData.amount
    InvoiceData calculatedData = InvoiceData(amount: rawData.amount);
    calculatedData.amount *= 1.10; // Example: Apply 10% tax
    print('InvoiceCalculator: Calculated amount is ${calculatedData.amount}');
    return calculatedData;
  }
}

// Responsibility: Rendering an invoice into a specific format (HTML, PDF, CSV).
// Reason to change: If the rendering format details change (e.g., new PDF library, HTML template update).
class InvoiceRenderer {
  RenderedInvoice render(InvoiceData data, String format) {
    print('InvoiceRenderer: Rendering invoice data to $format format.');
    String content = 'Rendered content for amount: ${data.amount} in $format';
    print('InvoiceRenderer: Content: "$content"');
    return RenderedInvoice(content: content, format: format);
  }
}

// Responsibility: Sending a rendered invoice to a customer.
// Reason to change: If the method of sending changes (e.g., different email API, SMS integration).
class InvoiceSender {
  void send(RenderedInvoice renderedInvoice, String customerEmail) {
    print('InvoiceSender: Sending ${renderedInvoice.format} invoice to $customerEmail.');
    // In a real app, this would use an email library or service.
    print('InvoiceSender: Content sent: "${renderedInvoice.content}"');
  }
}

// Responsibility: Coordinating the invoice generation process.
// It delegates tasks to other classes, each with its own single responsibility.
// Reason to change: If the overall process flow changes (e.g., adding a logging step).
class InvoiceManager {
  final InvoiceCalculator _calculator;
  final InvoiceRenderer _renderer;
  final InvoiceSender _sender;

  InvoiceManager()
      : _calculator = InvoiceCalculator(),
        _renderer = InvoiceRenderer(),
        _sender = InvoiceSender();

  void processInvoice(InvoiceData rawData, String customerEmail, String format) {
    print('\nInvoiceManager: Starting invoice processing for email: $customerEmail');

    // 1. Calculate the invoice details
    InvoiceData calculatedData = _calculator.calculate(rawData);

    // 2. Render the invoice to the desired format
    RenderedInvoice renderedInvoice = _renderer.render(calculatedData, format);

    // 3. Send the rendered invoice
    _sender.send(renderedInvoice, customerEmail);

    print('InvoiceManager: Invoice processing finished.');
  }

  // The 'run' function to demonstrate the process
  void run() {
    print('--- Dart InvoiceManager SRP Example ---');
    InvoiceData rawOrderData = InvoiceData(amount: 300.0); // Base amount
    String customerEmail = 'dart.customer@example.com';

    // Process as HTML
    processInvoice(rawOrderData, customerEmail, 'HTML');

    // Process as PDF
    processInvoice(rawOrderData, 'another.dart.customer@example.com', 'PDF');
    print('--- Dart InvoiceManager SRP Example End ---');
  }
}

void main() {
  InvoiceManager manager = InvoiceManager();
  manager.run();
}