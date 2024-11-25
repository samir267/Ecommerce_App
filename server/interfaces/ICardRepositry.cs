using server.models.server.Models;

namespace server.interfaces
{
    public interface ICartRepositry
    {
        

        
            Task<CartModel> CreateCartAsync(CartModel cart);
            Task<CartModel> GetCartByIdAsync(int id);
            Task<IEnumerable<CartModel>> GetCartsByUserIdAsync(int userId);
            Task<CartModel> UpdateCartAsync(CartModel cart);
            Task<CartModel> UpdateCartQuantAsync(int userId, int productId, int quantity);

            Task<bool> DeleteCartAsync(int id);
            Task<bool> CheckProductInCartAsync(int userId, int productId);
            Task<int> GetCartItemCountAsync(int userId);
            Task<CartModel> GetCartByUserIdAndProductIdAsync(int userId, int productId);
            Task<bool> ClearCartByUserIdAsync(int userId);
        

    }
}
