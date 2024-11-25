using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore.Metadata.Internal;
using server.interfaces;
using System.Reflection.Metadata;
using iText.Kernel.Pdf;
using iText.Layout;
using iText.Layout.Element;

using server.Dto.server.Dto;
using iText.Layout.Properties;
using iText.Kernel.Exceptions;
using Document = iText.Layout.Document;
using Table = iText.Layout.Element.Table;

namespace server.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class OrderController : ControllerBase
    {
        private readonly IOrderService _orderService;

        public OrderController(IOrderService orderService)
        {
            _orderService = orderService;
        }

        [HttpPost]
        [Route("create")]
        public async Task<IActionResult> CreateOrder([FromBody] CreateOrderDto orderDto)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            try
            {
                var order = await _orderService.CreateOrderAsync(orderDto);

                if (order == null)
                {
                    return BadRequest("Order could not be created.");
                }

                return Ok(new { Message = "Order created successfully", Order = order });
            }
            catch (Exception ex)
            {
                return StatusCode(500, "An error occurred while creating the order.");
            }
        }

        [HttpGet]
        [Route("get-orders/{userId}")]
        public async Task<IActionResult> GetOrdersByUserId(int userId)
        {
            try
            {
                var orders = await _orderService.GetOrdersByUserIdAsync(userId);

                if (orders == null)
                {
                    return NotFound("No orders found for the specified user.");
                }

                return Ok(orders);
            }
            catch (Exception ex)
            {
                return StatusCode(500, "An error occurred while retrieving orders.");
            }
        }

        [HttpGet]
        [Route("get-order/{orderId}")]
        public async Task<IActionResult> GetOrderById(int orderId)
        {
            try
            {
                var order = await _orderService.GetOrderByIdAsync(orderId);

                if (order == null)
                {
                    return NotFound($"Order with ID {orderId} not found.");
                }

                return Ok(order);
            }
            catch (Exception ex)
            {
                return StatusCode(500, "An error occurred while retrieving the order.");
            }
        }



[HttpGet]
    [Route("print-facture/{orderId}")]
    public async Task<IActionResult> PrintFacture(int orderId)
    {
        try
        {
            // Call the service to get the order by ID
            var order = await _orderService.GetOrderByIdAsync(orderId);

            if (order == null)
            {
                return NotFound($"Order with ID {orderId} not found.");
            }

            // Create a memory stream to store the PDF
            using (var memoryStream = new MemoryStream())
            {
                // Initialize PdfWriter and Document
                var writer = new PdfWriter(memoryStream);
                var pdfDocument = new PdfDocument(writer);
                var document = new iText.Layout.Document(pdfDocument);  // Use iText.Layout.Document explicitly

                // Company Header
                document.Add(new Paragraph("Ecom-DMWM")
                    .SetTextAlignment(iText.Layout.Properties.TextAlignment.CENTER)
                    .SetFontSize(24)
                    .SetBold());

                // Add some space after company name
                document.Add(new Paragraph("\n"));

                // User and Order Details
                document.Add(new Paragraph($"Order ID: {order.OrderId}"));
                document.Add(new Paragraph($"Order Date: {order.OrderDate.ToString("yyyy-MM-dd")}"));
                document.Add(new Paragraph($"Username: {order.User.Username}"));
                document.Add(new Paragraph($"Email: {order.User.Email}"));
                document.Add(new Paragraph($"Shipping Address: {order.ShippingAddress}"));
                document.Add(new Paragraph($"Payment Method: {order.PaymentMethod}"));
                document.Add(new Paragraph($"Payment Status: {order.PaymentStatus}"));
                document.Add(new Paragraph($"Total Amount: {order.TotalAmount:C}"));

                // Add some space before the product table
                document.Add(new Paragraph("\n"));

                // Create Table for Products
                var productTable = new iText.Layout.Element.Table(5);  // Use iText.Layout.Element.Table explicitly

                // Add headers to the table
                productTable.AddHeaderCell("Product ID");
                productTable.AddHeaderCell("Product Name");
                productTable.AddHeaderCell("Product Price");
                productTable.AddHeaderCell("Quantity");
                productTable.AddHeaderCell("Total Price");

                // Add products to the table
                foreach (var product in order.Products.values)
                {
                    productTable.AddCell(product.ProductId.ToString());
                    productTable.AddCell(product.ProductName);
                    productTable.AddCell(product.ProductPrice.ToString("C"));
                    productTable.AddCell(product.Quantity.ToString());
                    productTable.AddCell(product.TotalPrice.ToString("C"));
                }

                // Add the table to the document
                document.Add(productTable);

                // Close the document and write the PDF to memory stream
                document.Close();

                // Set the memory stream position back to the beginning
                memoryStream.Position = 0;

                // Return the PDF as a download
                return File(memoryStream, "application/pdf", $"Facture_{order.OrderId}.pdf");
            }
        }
        catch (Exception ex)
        {
                return StatusCode(500, $"An error occurred while generating the facture: {ex.Message}");
            }
        }


    }
}
