using Microsoft.EntityFrameworkCore;
using server.models;
using server.models.server.Models;

namespace server.Models
{
    public class AppDbContext : DbContext
    {
        public AppDbContext(DbContextOptions<AppDbContext> options) : base(options)
        {
        }

        public DbSet<UserModel> Users { get; set; }
        public DbSet<CategoryModel> Categories { get; set; } 
        public DbSet<ProductModel> Products { get; set; }
        public DbSet<CartModel> Cart { get; set; }
        public DbSet<OrderProductModel> OrderProduct { get; set; }
        public DbSet<OrderModel> Order { get; set; }

    }
}
