using System.ComponentModel.DataAnnotations;

namespace server.Dto
{
    public class UpdateProductDto
    {
        [MaxLength(100)]
        public string Name { get; set; }

        [MaxLength(500)]
        public string Description { get; set; }

        public int Quantity { get; set; } 

        
        public string Image { get; set; }

        public decimal Price { get; set; }

        public int CategoryId { get; set; }

        public int UserId { get; set; }
    }
}
