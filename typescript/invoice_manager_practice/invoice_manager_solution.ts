// Represents invoice data (simplified)
interface InvoiceData {
  amount: number;
  // other details like customerId, items, etc.
}

// Represents a rendered invoice (e.g., as a string for this example)
interface RenderedInvoice {
  content: string;
  format: 'HTML' | 'PDF' | 'CSV';
}

// --- SRP Applied: Each class below has one responsibility ---

// Responsibility: Calculating invoice totals, including taxes and discounts.
// Reason to change: If tax rules or discount logic changes.
class InvoiceCalculator {
  public calculate(rawData: InvoiceData): InvoiceData {
    console.log(
      'InvoiceCalculator: Calculating final amount including taxes and discounts.'
    );
    // In a real app, apply tax rules and discounts to rawData.amount
    const calculatedData = { ...rawData };
    calculatedData.amount *= 1.1; // Example: Apply 10% tax
    console.log(
      `InvoiceCalculator: Calculated amount is ${calculatedData.amount}`
    );
    return calculatedData;
  }
}

// Responsibility: Rendering an invoice into a specific format (HTML, PDF, CSV).
// Reason to change: If the rendering format details change (e.g., new PDF library, HTML template update).
class InvoiceRenderer {
  public render(
    data: InvoiceData,
    format: 'HTML' | 'PDF' | 'CSV'
  ): RenderedInvoice {
    console.log(`InvoiceRenderer: Rendering invoice data to ${format} format.`);
    const content = `Rendered content for amount: ${data.amount} in ${format}`;
    console.log(`InvoiceRenderer: Content: "${content}"`);
    return { content, format };
  }
}

// Responsibility: Sending a rendered invoice to a customer.
// Reason to change: If the method of sending changes (e.g., different email API, SMS integration).
class InvoiceSender {
  public send(renderedInvoice: RenderedInvoice, customerEmail: string): void {
    console.log(
      `InvoiceSender: Sending ${renderedInvoice.format} invoice to ${customerEmail}.`
    );
    // In a real app, this would use an email library or service.
    console.log(`InvoiceSender: Content sent: "${renderedInvoice.content}"`);
  }
}

// Responsibility: Coordinating the invoice generation process.
// It delegates tasks to other classes, each with its own single responsibility.
// Reason to change: If the overall process flow changes (e.g., adding a logging step).
class InvoiceManager {
  private calculator: InvoiceCalculator;
  private renderer: InvoiceRenderer;
  private sender: InvoiceSender;

  constructor() {
    this.calculator = new InvoiceCalculator();
    this.renderer = new InvoiceRenderer();
    this.sender = new InvoiceSender();
  }

  public processInvoice(
    rawData: InvoiceData,
    customerEmail: string,
    format: 'HTML' | 'PDF' | 'CSV'
  ): void {
    console.log(
      `\nInvoiceManager: Starting invoice processing for email: ${customerEmail}`
    );

    // 1. Calculate the invoice details
    const calculatedData = this.calculator.calculate(rawData);

    // 2. Render the invoice to the desired format
    const renderedInvoice = this.renderer.render(calculatedData, format);

    // 3. Send the rendered invoice
    this.sender.send(renderedInvoice, customerEmail);

    console.log('InvoiceManager: Invoice processing finished.');
  }

  // The 'run' function to demonstrate the process
  public run(): void {
    console.log('--- TypeScript InvoiceManager SRP Example ---');
    const rawOrderData: InvoiceData = { amount: 900.0 }; // Base amount
    const customerEmail = 'ts.customer@example.com';

    // Process as HTML
    this.processInvoice(rawOrderData, customerEmail, 'HTML');

    // Process as PDF
    this.processInvoice(rawOrderData, 'another.ts.customer@example.com', 'PDF');
    console.log('--- TypeScript InvoiceManager SRP Example End ---');
  }
}

// Main execution
function main(): void {
  const manager = new InvoiceManager();
  manager.run();
}

main();

// To compile and run (ensure you have Node.js and TypeScript installed):
// 1. tsc <filename>.ts
// 2. node <filename>.js
export {};
