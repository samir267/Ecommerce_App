namespace server.Dto
{
   
        public class CartDto
    {
            public int Id { get; set; }
            public int Quantity { get; set; }
            public int ProductId { get; set; }
            public int UserId { get; set; }
            public DateTime CreatedAt { get; set; }
        }
    

}
