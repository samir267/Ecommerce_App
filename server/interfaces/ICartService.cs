using server.Dto;
using server.models.server.Models;

namespace server.interfaces
{
    public interface ICartService
    {
        Task<CartModel> AddProductToCartAsync(int userId, int productId, int quantity);

        // Retrieves cart details for a given user (cart items, total price, and total item count)
        Task<(IEnumerable<CartResultDto> CartItems, decimal TotalPrice, int TotalItemCount)> GetCartDetailsByUserIdAsync(int userId);

        // Deletes a cart item by its ID
        Task<bool> DeleteCartAsync(int cartId);

        // Counts the total number of items in the user's cart
        Task<int> CountCartItemsAsync(int userId);

        Task<CartModel> UpdateCartItemAsync(int userId, int productId, int quantity);
        Task<bool> ClearCartByUserIdAsync(int userId);

    }
}
