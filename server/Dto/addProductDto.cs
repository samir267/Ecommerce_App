using Microsoft.AspNetCore.Http;
using System.ComponentModel.DataAnnotations;

namespace server.Dto
{
    public class addProductDto
    {
        [Required]
        [MaxLength(100)]
        public string Name { get; set; }

        [MaxLength(500)]
        public string Description { get; set; }

        [Required]
        public int Quantity { get; set; }

        [Required]
        public IFormFile Image { get; set; }

        [Required]
        public decimal Price { get; set; }

        // Référence à la catégorie
        [Required]
        public int CategoryId { get; set; }

        // Référence à l'utilisateur
        [Required]
        public int UserId { get; set; }
    }
}
