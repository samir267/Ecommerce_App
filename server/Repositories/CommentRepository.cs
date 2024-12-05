using server.Models;
using Microsoft.EntityFrameworkCore;
using server.models;
using server.Dto;

namespace server.Repositories
{
    public class CommentRepository
    {
        private readonly AppDbContext _context;

        public CommentRepository(AppDbContext context)
        {
            _context = context;
        }

        public async Task<addCommentDto> CreateCommentAsync(addCommentDto commentDto)
        {
            // Mapper le DTO vers le modèle de la base de données
            var comment = new CommentModel
            {
                Content = commentDto.content,
                ProductId = commentDto.productId,
                UserId = commentDto.userId
            };

            _context.Comment.Add(comment);  
            await _context.SaveChangesAsync(); 

            return commentDto;
        }

        public async Task<CommentModel> GetCommentByIdAsync(int id)
        {
            return await _context.Comment
                .Include(c => c.Product)
                .Include(c => c.User)
                .FirstOrDefaultAsync(c => c.Id == id);
        }

        public async Task<List<CommentModel>> GetCommentsByProductIdAsync(int productId)
        {
            return await _context.Comment
                .Where(c => c.ProductId == productId)
                .Select(c => new CommentModel
                {
                    Id = c.Id,
                    Content = c.Content,
                    ProductId = c.ProductId,
                    UserId = c.UserId,
                    Product = new ProductModel
                    {
                        Id = c.Product.Id,
                        Name = c.Product.Name,
                        Description = c.Product.Description,
                        Price = c.Product.Price,
                        // Ajouter d'autres propriétés nécessaires
                    },
                    User = new UserModel
                    {
                        Id = c.User.Id,
                        Username = c.User.Username,
                        Email = c.User.Email,
                        Address = c.User.Address,
                        Role = c.User.Role,
                        Phone = c.User.Phone,
                        State = c.User.State,
                        //ProfileImage = c.User.ProfileImage,
                        CreatedAt = c.User.CreatedAt,
                        UpdatedAt = c.User.UpdatedAt,
                        // Ajouter d'autres propriétés nécessaires
                    }
                })
                .ToListAsync();
        }

        public async Task<CommentModel> UpdateCommentAsync(int id, string content)
        {
            var comment = await _context.Comment.FindAsync(id);
            if (comment == null)
            {
                return null;
            }

            comment.Content = content;
            _context.Comment.Update(comment);
            await _context.SaveChangesAsync();

            return comment;
        }

        public async Task<bool> DeleteCommentAsync(int id)
        {
            var comment = await _context.Comment.FindAsync(id);
            if (comment == null)
            {
                return false;
            }

            _context.Comment.Remove(comment);
            await _context.SaveChangesAsync();

            return true;
        }
    }
}
