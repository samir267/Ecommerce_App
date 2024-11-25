using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace server.Models
{
    public class UserModel
    {
        [Key]
        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public int Id { get; set; }

        [Required(ErrorMessage = "Le nom d'utilisateur est requis.")]
        [StringLength(50, ErrorMessage = "Le nom d'utilisateur ne peut pas dépasser 50 caractères.")]
        public string? Username { get; set; }

        [Required(ErrorMessage = "L'email est requis.")]
        [EmailAddress(ErrorMessage = "L'email n'est pas valide.")]
        public string? Email { get; set; }

        [Required(ErrorMessage = "L'adresse est requise.")]
        [StringLength(200, ErrorMessage = "L'adresse ne peut pas dépasser 200 caractères.")]
        public string? Address { get; set; }

        [Required(ErrorMessage = "Le mot de passe est requis.")]
        [StringLength(100, MinimumLength = 6, ErrorMessage = "Le mot de passe doit contenir entre 6 et 100 caractères.")]
        public string? Password { get; set; }

        [Required(ErrorMessage = "Le rôle est requis.")]
        public UserRole Role { get; set; } // Rôle non nullable

        [Phone(ErrorMessage = "Le numéro de téléphone n'est pas valide.")]
        public string? Phone { get; set; }

        public string? State { get; set; }

        public string? AccessToken { get; set; }

        public string? RefreshToken { get; set; }

        [Column(TypeName = "datetime")]
        public DateTime CreatedAt { get; set; } = DateTime.UtcNow;

        [Column(TypeName = "datetime")]
        public DateTime UpdatedAt { get; set; } = DateTime.UtcNow;
    }
}
