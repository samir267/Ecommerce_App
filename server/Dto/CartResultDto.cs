using server.Migrations;

namespace server.Dto
{
    public class CartResultDto
    {
        public int Id { get; set; }
        public int Quantity { get; set; }
        public ProductDto Product { get; set; } // Update the type to ProductDto
        public int UserId { get; set; }
        public DateTime CreatedAt { get; set; }
    }

}
