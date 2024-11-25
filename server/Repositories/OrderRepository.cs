using server.Models;
using System.Collections.Generic;
using System.Threading.Tasks;
using server.interfaces;
using server.models;
using Microsoft.EntityFrameworkCore;
using server.Dto;

namespace server.Repositories
{
    public class OrderRepository : IOrderRepository
    {
        private readonly AppDbContext _context;

        public OrderRepository(AppDbContext context)
        {
            _context = context;
        }

        public async Task<OrderModel> CreateOrderWithItemsAsync(OrderModel order, List<OrderProductModel> orderItems)
        {
            // Add the order to the database
            await _context.Order.AddAsync(order);
            await _context.SaveChangesAsync();

            // Associate order items with the created order ID
            foreach (var item in orderItems)
            {
                item.OrderId = order.OrderId;
                await _context.OrderProduct.AddAsync(item);
            }

            // Save all changes (order items)
            await _context.SaveChangesAsync();

            return order;
        }
        public async Task<object> GetOrdersByUserIdAsync(int userId)
        {
            var orders = await _context.Order
                .Where(o => o.UserId == userId) // Ensure that UserId is a property and not a method
                .Include(o => o.User)  // Include User details (username, email)
                .Include(o => o.OrderProducts)  // Include OrderProduct details
                    .ThenInclude(op => op.Product)  // Include Product details (name, price, etc.)
                .Select(o => new
                {
                    OrderId = o.OrderId,
                    OrderDate = o.OrderDate,
                    TotalAmount = o.TotalAmount,
                    OrderStatus = o.OrderStatus,
                    ShippingAddress = o.ShippingAddress,
                    PaymentMethod = o.PaymentMethod,
                    PaymentStatus = o.PaymentStatus,
                    CreatedAt = o.CreatedAt,
                    User = new
                    {
                        Username = o.User.Username,
                        Email = o.User.Email
                    },
                    Products = o.OrderProducts.Select(op => new
                    {
                        ProductId = op.ProductId,
                        ProductName = op.Product.Name,
                        ProductPrice = op.UnitPrice,
                        ProductDescription = op.Product.Description,
                        PrudctImage = op.Product.Image,
                        Quantity = op.Quantity,
                        TotalPrice = op.Quantity * op.UnitPrice // Calculate total price per product in the order
                    }).ToList()
                }) 
                .ToListAsync();

            return orders;
        }
        public async Task<FactureOrderDto> GetOrderByIdAsync(int orderId)
        {
            var order = await _context.Order
                .Where(o => o.OrderId == orderId)
                .Include(o => o.User)
                .Include(o => o.OrderProducts)
                    .ThenInclude(op => op.Product)
                .Select(o => new FactureOrderDto
                {
                    OrderId = o.OrderId,
                    OrderDate = o.OrderDate,
                    TotalAmount = o.TotalAmount,
                    OrderStatus = o.OrderStatus,
                    ShippingAddress = o.ShippingAddress,
                    PaymentMethod = o.PaymentMethod,
                    PaymentStatus = o.PaymentStatus,
                    User = new FactureUserDto
                    {
                        Username = o.User.Username,
                        Email = o.User.Email
                    },
                    Products = new ProductsDto
                    {
                values = o.OrderProducts.Select(op => new FactureProductDto
                         {
                             ProductId = op.ProductId,
                             ProductName = op.Product.Name,
                             ProductPrice = op.UnitPrice,
                             ProductDescription = op.Product.Description,
                             ProductImage = op.Product.Image,
                             Quantity = op.Quantity,
                             TotalPrice = op.Quantity * op.UnitPrice
                         }).ToList()
                    }
                })
                .FirstOrDefaultAsync();

            return order;
        }

    }
}
