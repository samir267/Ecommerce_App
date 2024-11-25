using System.ComponentModel.DataAnnotations.Schema;
using System.ComponentModel.DataAnnotations;
using server.models;

namespace server.Models
{
    public class OrderModel
    {
        [Key]
        public int OrderId { get; set; }

        [Required]
        public int UserId { get; set; }  // Foreign key to User

        [Required]
        public DateTime OrderDate { get; set; }

        [Required]
        public decimal TotalAmount { get; set; }

        [Required]
        [MaxLength(50)]
        public string OrderStatus { get; set; }

        [MaxLength(50)]
        public string PaymentStatus { get; set; }

        [MaxLength(500)]
        public string ShippingAddress { get; set; }

        [MaxLength(50)]
        public string PaymentMethod { get; set; }

        public decimal? Discount { get; set; }

        [Column(TypeName = "datetime")]
        public DateTime CreatedAt { get; set; } = DateTime.UtcNow;

        [Column(TypeName = "datetime")]
        public DateTime? UpdatedAt { get; set; }

        // Navigation property for User
        [ForeignKey("UserId")]
        public virtual UserModel User { get; set; }

        // Navigation property for OrderProduct (linking products with the order)
        public virtual ICollection<OrderProductModel> OrderProducts { get; set; }
    }
}
