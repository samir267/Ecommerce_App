namespace server.Dto
{
    // CreateOrderDto.cs
    using System.Collections.Generic;

    namespace server.Dto
    {
        public class CreateOrderDto
        {
            public int UserId { get; set; }
            public string ShippingAddress { get; set; }
            public string PaymentMethod { get; set; }
        }

        public class OrderItemDto
        {
            public int ProductId { get; set; }
            public int Quantity { get; set; }
        }
    }

}
