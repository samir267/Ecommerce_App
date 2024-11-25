using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.EntityFrameworkCore;
using server.Dto;
using server.models;
using server.Models;

namespace server.Repositories
{
    public class CategoryRepository
    {
        private readonly AppDbContext _context;

        public CategoryRepository(AppDbContext context)
        {
            _context = context;
        }

        // CREATE : Ajouter une nouvelle catégorie
        public async Task<CategoryModel> AddCategoryAsync(CategoryModel category)
        {
            _context.Categories.Add(category);
            await _context.SaveChangesAsync();
            return category;
        }

        // READ : Récupérer une catégorie par son ID
        public async Task<CategoryModel> GetCategoryByIdAsync(int id)
        {
            return await _context.Categories.FindAsync(id);
        }

        // READ : Récupérer toutes les catégories
        public async Task<IEnumerable<CategoryModel>> GetAllCategoriesAsync()
        {
            return await _context.Categories.ToListAsync();
        }

        // UPDATE : Mettre à jour une catégorie existante
        public async Task<CategoryModel> UpdateCategoryAsync(int id, updateCategory updateCategoryDto)
        {   
            var existingCategory = await _context.Categories.FindAsync(id);
            if (existingCategory == null)
            {
                return null;
            }

            // Mettre à jour les champs avec les valeurs du DTO
            existingCategory.Name = updateCategoryDto.Name;
            existingCategory.IsActive = updateCategoryDto.IsActive;

            await _context.SaveChangesAsync();
            return existingCategory;
        }

        // DELETE : Supprimer une catégorie par son ID
        public async Task<bool> DeleteCategoryAsync(int id)
        {
            var category = await _context.Categories.FindAsync(id);
            if (category == null)
            {
                return false;
            }

            _context.Categories.Remove(category);
            await _context.SaveChangesAsync();
            return true;
        }
    }
}
