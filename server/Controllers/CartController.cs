using Microsoft.AspNetCore.Mvc;
using server.interfaces;

[ApiController]
[Route("api/[controller]")]
public class CartController : ControllerBase
{
    private readonly ICartService _cartService;

    public CartController(ICartService cartService)
    {
        _cartService = cartService;
    }

    [HttpPost("add")]
    public async Task<IActionResult> AddProductToCart(int userId, int productId, int quantity)
    {
        try
        {
            var result = await _cartService.AddProductToCartAsync(userId, productId, quantity);
            return Ok(new { success = true, cart = result });
        }
        catch (ArgumentException ex)
        {
            return BadRequest(new { message = ex.Message });
        }
    }

    [HttpGet("user/{userId}")]
    public async Task<IActionResult> GetCartByUserId(int userId)
    {
        try
        {
            var result = await _cartService.GetCartDetailsByUserIdAsync(userId);
            return Ok(new
            {
                cartItems = result.CartItems,
                totalPrice = result.TotalPrice,
                totalItemCount = result.TotalItemCount
            });
        }
        catch (ArgumentException ex)
        {
            return NotFound(new { message = ex.Message });
        }


    }

    [HttpDelete("{cartId}")]
    public async Task<IActionResult> DeleteCart(int cartId)
    {
        try
        {
            var success = await _cartService.DeleteCartAsync(cartId);
            if (success)
            {
                return NoContent();
            }
            return NotFound(new { message = "Cart item not found" });
        }
        catch (ArgumentException ex)
        {
            return NotFound(new { message = ex.Message });
        }
    }

    [HttpGet("count/{userId}")]
    public async Task<IActionResult> CountCartItems(int userId)
    {
        try
        {
            var count = await _cartService.CountCartItemsAsync(userId);
            return Ok(count);
        }
        catch (ArgumentException ex)
        {
            return NotFound(new { message = ex.Message });
        }
    }
    [HttpPut("update")]
    public async Task<IActionResult> UpdateCartItem(int userId, int productId, int quantity)
    {
        // Call the service to update the cart item
        var updatedCart = await _cartService.UpdateCartItemAsync(userId, productId, quantity);

        // If the cart item was not found, return a 404 Not Found response
        if (updatedCart == null)
        {
            return NotFound(new { Message = "Cart item not found." });
        }

        // Return the updated cart item in the response
        return Ok(updatedCart);
    }
    [HttpDelete("clear/{userId}")]
    public async Task<IActionResult> ClearCart(int userId)
    {
        var result = await _cartService.ClearCartByUserIdAsync(userId);

        if (result)
        {
            return Ok(new { message = "Cart cleared successfully." });
        }

        return NotFound(new { message = "No items found in the cart for this user." });
    }

}
