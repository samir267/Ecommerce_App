using server.Dto;
using server.Dto.server.Dto;
using server.Models;

namespace server.interfaces
{
    public interface IOrderService
    {
        Task<OrderModel> CreateOrderAsync(CreateOrderDto orderDto);
        Task<object> GetOrdersByUserIdAsync(int userId);
        Task<FactureOrderDto> GetOrderByIdAsync(int orderId);
    }
}
