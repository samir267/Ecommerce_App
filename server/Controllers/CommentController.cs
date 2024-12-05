using Microsoft.AspNetCore.Mvc;
using server.Dto;
using server.models;
using server.Models;
using server.Services;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace server.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class CommentController : ControllerBase
    {
        private readonly CommentService _commentService;

        public CommentController(CommentService commentService)
        {
            _commentService = commentService;
        }   

        // POST: api/comment
        [HttpPost]
        public async Task<ActionResult<addCommentDto>> CreateComment([FromBody] addCommentDto commentDto)
        {
            if (commentDto == null)
            {
                return BadRequest("Le commentaire est vide.");
            }

            var createdCommentDto = await _commentService.AddCommentAsync(commentDto);

            // Assurez-vous que l'action GetCommentById existe et attend un paramètre id
            return CreatedAtAction(nameof(GetCommentById), new { id = createdCommentDto.Id }, createdCommentDto);
        }



        // GET: api/comment/{id}
        [HttpGet("{id}")]
        public async Task<ActionResult<CommentModel>> GetCommentById(int id)
        {
            var comment = await _commentService.GetCommentByIdAsync(id);

            if (comment == null)
            {
                return NotFound();
            }

            return Ok(comment);
        }

        // GET: api/comment/product/{productId}
        [HttpGet("product/{productId}")]
        public async Task<ActionResult<IEnumerable<CommentModel>>> GetCommentsByProductId(int productId)
        {
            var comments = await _commentService.GetCommentsByProductIdAsync(productId);

            if (comments == null )
            {
                return NotFound();
            }

            return Ok(comments);
        }

        // PUT: api/comment/{id}
        [HttpPut("{id}")]
        public async Task<ActionResult<CommentModel>> UpdateComment(int id, [FromBody] string content)
        {
            var updatedComment = await _commentService.UpdateCommentAsync(id, content);

            if (updatedComment == null)
            {
                return NotFound();
            }

            return Ok(updatedComment);
        }

        // DELETE: api/comment/{id}
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteComment(int id)
        {
            var success = await _commentService.DeleteCommentAsync(id);

            if (!success)
            {
                return NotFound();
            }

            return NoContent();
        }
    }
}
