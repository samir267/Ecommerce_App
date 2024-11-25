using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace server.models
{
    public class CategoryModel
    {
        [Key]
        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public int Id { get; set; }


        [Required]
        [MaxLength(100)]
        public string? Name { get; set; }

        public DateTime CreatedAt { get; set; } = DateTime.Now;

        public bool? IsActive { get; set; } = true;
    }
}
