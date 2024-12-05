namespace server.Dto
{
    public class RegisterUserDto
    {
        public string Username { get; set; }
        public string Email { get; set; }
        public string Address { get; set; }
        public string Password { get; set; }
        public int Role { get; set; }
        public string Phone { get; set; }
        public string State { get; set; }
        //public IFormFile ProfileImage { get; set; } // Ajout de l'image
    }

}
