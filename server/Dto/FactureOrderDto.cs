using server.Dto;

namespace server.Dto
{
    public class FactureProductDto
    {
        public int ProductId { get; set; }
        public string ProductName { get; set; }
        public decimal ProductPrice { get; set; }
        public string ProductDescription { get; set; }
        public string ProductImage { get; set; }
        public int Quantity { get; set; }
        public decimal TotalPrice { get; set; }
    }

    public class FactureUserDto
    {
        public string Username { get; set; }
        public string Email { get; set; }
    }

    public class ProductsDto
    {
        public List<FactureProductDto> values { get; set; }
    }

    public class FactureOrderDto
    {
        public int OrderId { get; set; }
        public DateTime OrderDate { get; set; }
        public decimal TotalAmount { get; set; }
        public string OrderStatus { get; set; }
        public string ShippingAddress { get; set; }
        public string PaymentMethod { get; set; }
        public string PaymentStatus { get; set; }
        public FactureUserDto User { get; set; }
        public ProductsDto Products { get; set; }
    }
}
