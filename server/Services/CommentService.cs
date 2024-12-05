using server.Dto;
using server.models;
using server.Models;
using server.Repositories;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace server.Services
{
    public class CommentService
    {
        private readonly CommentRepository _commentRepository;

        public CommentService(CommentRepository commentRepository)
        {
            _commentRepository = commentRepository;
        }

        public async Task<addCommentDto> AddCommentAsync(addCommentDto commentDto)
        {
            // Mapper le DTO vers le modèle CommentModel
            var comment = new CommentModel
            {
                Content = commentDto.content,
                ProductId = commentDto.productId,
                UserId = commentDto.userId
            };

            // Appeler le repository pour créer le commentaire
            var createdCommentDto = await _commentRepository.CreateCommentAsync(commentDto);

      
            return commentDto;  // Retourner le DTO avec l'ID du commentaire créé
        }


        public async Task<CommentModel> GetCommentByIdAsync(int id)
        {
            return await _commentRepository.GetCommentByIdAsync(id);
        }

        public async Task<IEnumerable<CommentModel>> GetCommentsByProductIdAsync(int productId)
        {
            return await _commentRepository.GetCommentsByProductIdAsync(productId);
        }

        public async Task<CommentModel> UpdateCommentAsync(int id, string content)
        {
            return await _commentRepository.UpdateCommentAsync(id, content);
        }

        public async Task<bool> DeleteCommentAsync(int id)
        {
            return await _commentRepository.DeleteCommentAsync(id);
        }
    }
}
