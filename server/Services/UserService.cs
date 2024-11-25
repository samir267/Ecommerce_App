using server.Models;
using server.Repositories;
using BCrypt.Net;
using server.Dto;

namespace server.Services
{
    public class UserService
    {
        private readonly UserRepository _userRepository;

        public UserService(UserRepository userRepository)
        {
            _userRepository = userRepository;
        }

        // Enregistrer un nouvel utilisateur
        public async Task<UserModel> RegisterAsync(UserModel user)
        {
            // Hacher le mot de passe avant de l'enregistrer
            user.Password = HashPassword(user.Password);

            // Ajouter l'utilisateur au repository
            await _userRepository.AddUserAsync(user);

            return user;
        }

        // Hacher le mot de passe
        private string HashPassword(string password)
        {
            return BCrypt.Net.BCrypt.HashPassword(password);
        }

        // Obtenir tous les utilisateurs
        public async Task<IEnumerable<UserModel>> GetAllUsersAsync()
        {
            return await _userRepository.GetAllUsersAsync();
        }

        // Obtenir un utilisateur par ID
        public async Task<UserModel?> GetUserByIdAsync(int id)
        {
            return await _userRepository.GetUserByIdAsync(id);
        }

        // Mettre à jour un utilisateur
        // Mettre à jour un utilisateur
        public async Task UpdateUserAsync(int userId, UpdateUserDto userDto)
        {
            var existingUser = await _userRepository.GetUserByIdAsync(userId);
            if (existingUser == null)
            {
                throw new Exception("User not found");
            }

            existingUser.Username = userDto.Username ?? existingUser.Username;
            existingUser.Email = userDto.Email ?? existingUser.Email;
            existingUser.Address = userDto.Address ?? existingUser.Address;
            existingUser.Phone = userDto.Phone ?? existingUser.Phone;

            if (!string.IsNullOrEmpty(userDto.Password))
            {
                existingUser.Password = HashPassword(userDto.Password);
            }

            await _userRepository.UpdateUserAsync(existingUser);
        }

        // Supprimer un utilisateur
        public async Task DeleteUserAsync(int id)
        {
            var user = await _userRepository.GetUserByIdAsync(id);
            if (user == null)
            {
                throw new Exception("User not found");
            }

            await _userRepository.DeleteUserAsync(id);
        }
        public async Task<bool> CheckUserExistsByIdAsync(int userId)
        {
            // Check if a user with the given userId exists
            var user = await _userRepository.GetUserByIdAsync(userId);

            // Return true if the user exists, otherwise false
            return user != null;
        }

    }
}
