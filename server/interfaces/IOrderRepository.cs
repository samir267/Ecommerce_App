using server.Dto;
using server.Dto.server.Dto;
using server.models;
using server.Models;

namespace server.interfaces
{
    public interface IOrderRepository
    {
        Task<OrderModel> CreateOrderWithItemsAsync(OrderModel order, List<OrderProductModel> orderItems);
        Task<object> GetOrdersByUserIdAsync(int userId);
        Task<FactureOrderDto> GetOrderByIdAsync(int orderId);
    }
}
