using server.Dto.server.Dto;
using server.interfaces;
using server.Models;
using System.Threading.Tasks;
using System.Linq;
using server.models;
using server.Dto;

namespace server.Services
{
    public class OrderService : IOrderService
    {
        private readonly IOrderRepository _orderRepository;
        private readonly ICartService _cartService; // Use CartService instead of CartRepository

        public OrderService(IOrderRepository orderRepository, ICartService cartService)
        {
            _orderRepository = orderRepository;
            _cartService = cartService;
        }

        public async Task<OrderModel> CreateOrderAsync(CreateOrderDto orderDto)
        {
            // Fetch cart details from CartService for the user
            var (cartItems, totalPrice, totalItemCount) = await _cartService.GetCartDetailsByUserIdAsync(orderDto.UserId);

            // If cart is empty, return null or throw an error as needed
            if (!cartItems.Any())
            {
                throw new InvalidOperationException("Cannot create an order with an empty cart.");
            }

            // Populate the OrderModel with details
            var order = new OrderModel
            {
                UserId = orderDto.UserId,
                ShippingAddress = orderDto.ShippingAddress,
                PaymentMethod = orderDto.PaymentMethod,
                OrderDate = DateTime.Now,
                OrderStatus = "Pending", // Default status
                PaymentStatus = "Unpaid", // Default status
                CreatedAt = DateTime.Now,
                TotalAmount = totalPrice
            };

            // Map cart items to OrderProductModels
            var orderItems = cartItems.Select(cartItem => new OrderProductModel
            {
                ProductId = cartItem.Product.Id,
                Quantity = cartItem.Quantity,
                UnitPrice = cartItem.Product.Price
            }).ToList();

            // Create the order using OrderRepository
            var createdOrder = await _orderRepository.CreateOrderWithItemsAsync(order, orderItems);

            // Clear the user's cart after placing the order
           // await _cartService.ClearCartByUserIdAsync(orderDto.UserId);

            return createdOrder;
        }
        public async Task<object> GetOrdersByUserIdAsync(int userId)
        {
            var orders = await _orderRepository.GetOrdersByUserIdAsync(userId);

            // Optionally, you can add business logic here if needed before returning the result
            return orders;
        }
        public async Task<FactureOrderDto> GetOrderByIdAsync(int orderId)
        {
            return await _orderRepository.GetOrderByIdAsync(orderId);
        }
    }
}
