using System;

namespace InvoiceManagerSolution
{
    // Represents invoice data (simplified)
    public class InvoiceData
    {
        public double Amount { get; set; }
        // other details like CustomerId, Items, etc.
    }

    // Represents a rendered invoice (e.g., as a string for this example)
    public class RenderedInvoice
    {
        public string Content { get; set; }
        public string Format { get; set; } // "HTML", "PDF", "CSV"
    }

    // --- SRP Applied: Each class below has one responsibility ---

    // Responsibility: Calculating invoice totals, including taxes and discounts.
    // Reason to change: If tax rules or discount logic changes.
    public class InvoiceCalculator
    {
        public InvoiceData Calculate(InvoiceData rawData)
        {
            Console.WriteLine("InvoiceCalculator: Calculating final amount including taxes and discounts.");
            // In a real app, apply tax rules and discounts to rawData.Amount
            InvoiceData calculatedData = new InvoiceData { Amount = rawData.Amount };
            calculatedData.Amount *= 1.10; // Example: Apply 10% tax
            Console.WriteLine($"InvoiceCalculator: Calculated amount is {calculatedData.Amount}");
            return calculatedData;
        }
    }

    // Responsibility: Rendering an invoice into a specific format (HTML, PDF, CSV).
    // Reason to change: If the rendering format details change (e.g., new PDF library, HTML template update).
    public class InvoiceRenderer
    {
        public RenderedInvoice Render(InvoiceData data, string format)
        {
            Console.WriteLine($"InvoiceRenderer: Rendering invoice data to {format} format.");
            string content = $"Rendered content for amount: {data.Amount} in {format}";
            Console.WriteLine($"InvoiceRenderer: Content: \"{content}\"");
            return new RenderedInvoice { Content = content, Format = format };
        }
    }

    // Responsibility: Sending a rendered invoice to a customer.
    // Reason to change: If the method of sending changes (e.g., different email API, SMS integration).
    public class InvoiceSender
    {
        public void Send(RenderedInvoice renderedInvoice, string customerEmail)
        {
            Console.WriteLine($"InvoiceSender: Sending {renderedInvoice.Format} invoice to {customerEmail}.");
            // In a real app, this would use an email library or service.
            Console.WriteLine($"InvoiceSender: Content sent: \"{renderedInvoice.Content}\"");
        }
    }

    // Responsibility: Coordinating the invoice generation process.
    // It delegates tasks to other classes, each with its own single responsibility.
    // Reason to change: If the overall process flow changes (e.g., adding a logging step).
    public class InvoiceManager
    {
        private readonly InvoiceCalculator _calculator;
        private readonly InvoiceRenderer _renderer;
        private readonly InvoiceSender _sender;

        public InvoiceManager()
        {
            _calculator = new InvoiceCalculator();
            _renderer = new InvoiceRenderer();
            _sender = new InvoiceSender();
        }

        public void ProcessInvoice(InvoiceData rawData, string customerEmail, string format)
        {
            Console.WriteLine($"\nInvoiceManager: Starting invoice processing for email: {customerEmail}");

            // 1. Calculate the invoice details
            InvoiceData calculatedData = _calculator.Calculate(rawData);

            // 2. Render the invoice to the desired format
            RenderedInvoice renderedInvoice = _renderer.Render(calculatedData, format);

            // 3. Send the rendered invoice
            _sender.Send(renderedInvoice, customerEmail);

            Console.WriteLine("InvoiceManager: Invoice processing finished.");
        }

        // The 'Run' function to demonstrate the process
        public void Run()
        {
            Console.WriteLine("--- C# InvoiceManager SRP Example ---");
            InvoiceData rawOrderData = new InvoiceData { Amount = 200.0 }; // Base amount
            string customerEmail = "csharp.customer@example.com";

            // Process as HTML
            ProcessInvoice(rawOrderData, customerEmail, "HTML");

            // Process as PDF
            ProcessInvoice(rawOrderData, "another.csharp.customer@example.com", "PDF");
            Console.WriteLine("--- C# InvoiceManager SRP Example End ---");
        }
    }

    public class Program
    {
        public static void Main(string[] args)
        {
            InvoiceManager manager = new InvoiceManager();
            manager.Run();
        }
    }
}