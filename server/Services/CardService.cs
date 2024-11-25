using server.Dto;
using server.interfaces;
using server.models.server.Models;
using server.Services;

public class CartService : ICartService
{
    private readonly ICartRepositry _cartRepository;
    private readonly ProductService _productService;
    private readonly UserService _userService;
    public CartService(ICartRepositry cartRepository, ProductService productService, UserService userService)
    {
        _cartRepository = cartRepository;
        _productService = productService;
        _userService = userService;
    }
    public async Task<CartModel> AddProductToCartAsync(int userId, int productId, int quantity)
    {
        // Check if user exists (example: assuming _userService is available for checking user existence)
        var userExists = await _userService.CheckUserExistsByIdAsync(userId); // Implement this method in your UserService
        if (!userExists)
        {
            throw new ArgumentException("User not found", nameof(userId));
        }

        var product = await _productService.GetProductByIdAsync(productId);
        if (product == null)
        {
            throw new ArgumentException("Product not found", nameof(productId));
        }

        if (await _cartRepository.CheckProductInCartAsync(userId, productId))
        {
            // Update the quantity of the existing cart item
            var existingCart = await _cartRepository.GetCartByUserIdAndProductIdAsync(userId, productId);
            existingCart.Quantity += quantity;
            return await _cartRepository.UpdateCartAsync(existingCart);
        }
        else
        {
            var newCart = new CartModel { UserId = userId, ProductId = productId, Quantity = quantity };
            return await _cartRepository.CreateCartAsync(newCart);
        }
    }
    public async Task<(IEnumerable<CartResultDto> CartItems, decimal TotalPrice, int TotalItemCount)> GetCartDetailsByUserIdAsync(int userId)
    {
        // Check if the user exists
        var userExists = await _userService.CheckUserExistsByIdAsync(userId);
        if (!userExists)
        {
            throw new ArgumentException("User with specified ID does not exist.", nameof(userId));
        }

        // Retrieve all cart items for the given user
        var cartItems = await _cartRepository.GetCartsByUserIdAsync(userId);
        if (!cartItems.Any())
        {
            // Return early if the cart is empty
            return (Enumerable.Empty<CartResultDto>(), 0, 0);
        }

        var cartDtos = new List<CartResultDto>();
        decimal totalPrice = 0;
        int totalItemCount = 0;

        foreach (var cartItem in cartItems)
        {
            // Retrieve the associated product
            var product = await _productService.GetProductByIdAsync(cartItem.ProductId);
            if (product == null)
            {
                throw new ArgumentException($"Product with ID {cartItem.ProductId} not found for CartItem with ID {cartItem.Id}.", nameof(cartItem.ProductId));
            }

            // Calculate total price for the cart item and update overall totals
            decimal itemTotal = product.Price * cartItem.Quantity;
            totalPrice += itemTotal;
            totalItemCount += cartItem.Quantity;

            // Add the cart item details to the list of DTOs
            cartDtos.Add(new CartResultDto
            {
                Id = cartItem.Id,
                Quantity = cartItem.Quantity,
                Product = new ProductDto // assuming you define ProductDto to include only necessary fields
                {
                    Id = product.Id,
                    Name = product.Name,
                    Description = product.Description,
                    Price = product.Price,
                    Image = product.Image
                },
                UserId = cartItem.UserId,
                CreatedAt = cartItem.CreatedAt,
            });
        }

        // Return the cart items, total price, and total item count
        return (cartDtos, totalPrice, totalItemCount);
    }

    public async Task<bool> DeleteCartAsync(int cartId)
    {
        var cart = await _cartRepository.GetCartByIdAsync(cartId);
        if (cart == null)
        {
            throw new ArgumentException("Cart item not found", nameof(cartId));
        }

        return await _cartRepository.DeleteCartAsync(cartId);
    }

    public async Task<int> CountCartItemsAsync(int userId)
    {
        var userExists = await _userService.CheckUserExistsByIdAsync(userId); // Assuming you have a UserService to check users
        if (!userExists)
        {
            throw new ArgumentException("User not found", nameof(userId));
        }

        return await _cartRepository.GetCartItemCountAsync(userId);
    }
    public async Task<CartModel> UpdateCartItemAsync(int userId, int productId, int quantity)
    {
        var updatedCart = await _cartRepository.UpdateCartQuantAsync(userId, productId, quantity);

        return updatedCart;
    }
    public async Task<bool> ClearCartByUserIdAsync(int userId)
    {
        return await _cartRepository.ClearCartByUserIdAsync(userId);
    }



}
