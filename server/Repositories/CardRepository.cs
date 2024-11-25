using Microsoft.EntityFrameworkCore;
using server.interfaces;
using server.models.server.Models;
using server.Models;
using static server.interfaces.ICartRepositry;

namespace server.Repositories
{
    public class CartRepository : ICartRepositry
    {
        private readonly AppDbContext _context;

        public CartRepository(AppDbContext context)
        {
            _context = context;
        }

        public async Task<CartModel> CreateCartAsync(CartModel cart)
        {
            _context.Cart.Add(cart);
            await _context.SaveChangesAsync();
            return cart;
        }

        public async Task<CartModel> GetCartByIdAsync(int id)
        {
            return await _context.Cart.Include(c => c.Product).FirstOrDefaultAsync(c => c.Id == id);
        }

        public async Task<IEnumerable<CartModel>> GetCartsByUserIdAsync(int userId)
        {
            return await _context.Cart.Where(c => c.UserId == userId)
                                       .Include(c => c.Product)
                                       .ToListAsync();
        }

        public async Task<CartModel> UpdateCartAsync(CartModel cart)
        {
            var existingCart = await _context.Cart.FindAsync(cart.Id);
            if (existingCart == null) return null;

            existingCart.Quantity = cart.Quantity; 
            await _context.SaveChangesAsync();
            return existingCart;
        }
        public async Task<CartModel> UpdateCartQuantAsync(int userId, int productId, int quantity)
        {
            var existingCart = await _context.Cart
                .FirstOrDefaultAsync(c => c.UserId == userId && c.ProductId == productId);

            // If no cart item is found, return null
            if (existingCart == null) return null;

            existingCart.Quantity = quantity;

            await _context.SaveChangesAsync();

            return existingCart;
        }

        public async Task<bool> DeleteCartAsync(int id)
        {
            var cart = await _context.Cart.FindAsync(id);
            if (cart == null) return false;

            _context.Cart.Remove(cart);
            await _context.SaveChangesAsync();
            return true;
        }


        public async Task<bool> CheckProductInCartAsync(int userId, int productId)
        {
            return await _context.Cart.AnyAsync(c => c.UserId == userId && c.ProductId == productId);
        }

        public async Task<int> GetCartItemCountAsync(int userId)
        {
            return await _context.Cart.Where(c => c.UserId == userId).SumAsync(c => c.Quantity);
        }
        public async Task<CartModel> GetCartByUserIdAndProductIdAsync(int userId, int productId)
        {
            return await _context.Cart
                                 .FirstOrDefaultAsync(c => c.UserId == userId && c.ProductId == productId);
        }
        public async Task<bool> ClearCartByUserIdAsync(int userId)
        {
            // Get all cart items for the user
            var cartItems = await _context.Cart.Where(c => c.UserId == userId).ToListAsync();

            // If no items found, return false
            if (cartItems.Count == 0) return false;

            // Remove all the cart items
            _context.Cart.RemoveRange(cartItems);

            // Save changes to the database
            await _context.SaveChangesAsync();

            return true;
        }

    }

}
