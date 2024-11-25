using Microsoft.AspNetCore.Mvc;
using System.Threading.Tasks;
using server.Models;
using server.Services;
using server.Dto; // Assurez-vous d'importer le namespace de votre DTO

namespace server.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class UserController : ControllerBase
    {
        private readonly UserService _userService;

        public UserController(UserService userService)
        {
            _userService = userService;
        }

        // CREATE: Créer un nouvel utilisateur
        [HttpPost("Register")]
        public async Task<IActionResult> Register([FromBody] UserModel user)
        {
            if (user == null)
            {
                return BadRequest("No Data Posted");
            }

            var createdUser = await _userService.RegisterAsync(user);

            return Ok(createdUser);
        }

        // READ: Obtenir un utilisateur par ID
        [HttpGet("{id}")]
        public async Task<ActionResult<UserModel>> GetUser(int id)
        {
            var user = await _userService.GetUserByIdAsync(id);

            if (user == null)
            {
                return NotFound("User not found");
            }

            return Ok(user);
        }

        // UPDATE: Mettre à jour un utilisateur
        [HttpPut("{id}")]
        public async Task<IActionResult> UpdateUser(int id, [FromBody] UpdateUserDto userDto) // Changer UserModel en UpdateUserDto
        {
            if (userDto == null ) // Assurez-vous d'ajouter une propriété Id dans UpdateUserDto
            {
                return BadRequest("Invalid user data");
            }

            var existingUser = await _userService.GetUserByIdAsync(id);
            if (existingUser == null)
            {
                return NotFound("User not found");
            }

            await _userService.UpdateUserAsync(id, userDto); // Passer le userDto au service

            return Ok("User updated successfully");
        }

        // DELETE: Supprimer un utilisateur
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteUser(int id)
        {
            var existingUser = await _userService.GetUserByIdAsync(id);
            if (existingUser == null)
            {
                return NotFound("User not found");
            }

            await _userService.DeleteUserAsync(id);

            return Ok("User deleted successfully");
        }

        // READ: Obtenir tous les utilisateurs
        [HttpGet]
        public async Task<IActionResult> GetAllUsers()
        {
            var users = await _userService.GetAllUsersAsync();
            return Ok(users);
        }
    }
}
