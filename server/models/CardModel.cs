namespace server.models
{
    using global::server.Models;
    using System;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;

    namespace server.Models
    {
        public class CartModel
        {
            [Key]
            public int Id { get; set; }

            [Required]
            public int Quantity { get; set; }

            // Foreign key to User
            [ForeignKey("User")]
            public int UserId { get; set; }

            // Foreign key to Product
            [ForeignKey("Product")]
            public int ProductId { get; set; }

            // Navigation property for Product
            public ProductModel Product { get; set; }

            // Navigation property for User
            public UserModel User { get; set; }

            [Column(TypeName = "datetime")]
            public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
        }
    }

}
