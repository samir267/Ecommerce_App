namespace server.Dto
{
    public class addCommentDto
    {
        public int Id { get; set; }
        public string content { get; set; }
        public int productId { get; set; }
        public int userId { get; set; }

    }
}
