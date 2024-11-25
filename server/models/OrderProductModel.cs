using server.Models;
using System.ComponentModel.DataAnnotations.Schema;
using System.ComponentModel.DataAnnotations;

namespace server.models
{
    public class OrderProductModel
    {
        [Key]
        public int OrderProductId { get; set; }

        [Required]
        public int OrderId { get; set; }

        [Required]
        public int ProductId { get; set; }

        [Required]
        public int Quantity { get; set; }  // Quantity of the product in the order

        [Required]
        public decimal UnitPrice { get; set; }  // The price of the product at the time of the order

        // Navigation properties
        [ForeignKey("OrderId")]
        public virtual OrderModel Order { get; set; }

        [ForeignKey("ProductId")]
        public virtual ProductModel Product { get; set; }
    }

}
