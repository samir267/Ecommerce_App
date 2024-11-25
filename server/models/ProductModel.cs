using server.models;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace server.Models
{
    public class ProductModel
    {
        [Key]
        public int Id { get; set; }

        [Required]
        [MaxLength(100)]
        public string Name { get; set; }

        [MaxLength(500)]
        public string Description { get; set; }

        [Required]
        public int Quantity { get; set; }

        [Required]
        public string Image { get; set; }

        [Required]
        public decimal Price { get; set; }

        // Foreign key to Category
        [ForeignKey("Category")]
        public int CategoryId { get; set; }


        // Foreign key to User
        [ForeignKey("User")]
        public int UserId { get; set; }

    }
}
