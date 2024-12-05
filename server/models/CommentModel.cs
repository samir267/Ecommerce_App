using server.Models;
using System.ComponentModel.DataAnnotations.Schema;
using System.ComponentModel.DataAnnotations;

namespace server.models
{
    public class CommentModel
    {
        [Key]
        public int Id { get; set; }

        [Required]
        [MaxLength(1000)]  
        public string Content { get; set; }

        [ForeignKey("Product")]
        public int ProductId { get; set; }

        [ForeignKey("User")]
        public int UserId { get; set; }

        public ProductModel Product { get; set; }
        public UserModel User { get; set; }
    }
}
