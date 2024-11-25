using server.Models;
using Microsoft.EntityFrameworkCore;

namespace server.Repositories
{
    public class UserRepository
    {
        private readonly AppDbContext _context; // Utilisation du type AppDbContext

        public UserRepository(AppDbContext context)
        {
            _context = context;
        }

        // Get all users
        public async Task<IEnumerable<UserModel>> GetAllUsersAsync()
        {
            return await _context.Users.ToListAsync();
        }

        // Get user by ID
        public async Task<UserModel?> GetUserByIdAsync(int id)
        {
            return await _context.Users.FindAsync(id);
        }

        // Add new user
        public async Task AddUserAsync(UserModel user)
        {
            await _context.Users.AddAsync(user);
            await _context.SaveChangesAsync();
        }

        // Update existing user
        public async Task UpdateUserAsync(UserModel user)
        {
            _context.Users.Update(user);
            await _context.SaveChangesAsync();
        }

        // Delete user by ID
        public async Task DeleteUserAsync(int id)
        {
            var user = await GetUserByIdAsync(id);
            if (user != null)
            {
                _context.Users.Remove(user);
                await _context.SaveChangesAsync();
            }
        }
    }
}
