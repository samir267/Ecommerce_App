using System.Collections.Generic;
using System.Threading.Tasks;
using server.Dto;
using server.models;
using server.Models;
using server.Repositories;

namespace server.Services
{
    public class CategoryService
    {
        private readonly CategoryRepository _categoryRepository;

        public CategoryService(CategoryRepository categoryRepository)
        {
            _categoryRepository = categoryRepository;
        }

        // Ajouter une nouvelle catégorie
        public async Task<CategoryModel> CreateCategoryAsync(CategoryModel category)
        {
            return await _categoryRepository.AddCategoryAsync(category);
        }

        // Récupérer une catégorie par ID
        public async Task<CategoryModel> GetCategoryByIdAsync(int id)
        {
            return await _categoryRepository.GetCategoryByIdAsync(id);
        }

        // Récupérer toutes les catégories
        public async Task<IEnumerable<CategoryModel>> GetAllCategoriesAsync()
        {
            return await _categoryRepository.GetAllCategoriesAsync();
        }

        // Mettre à jour une catégorie
        public async Task<CategoryModel> UpdateCategoryAsync(int id, updateCategory updateCategoryDto)
        {
            return await _categoryRepository.UpdateCategoryAsync(id, updateCategoryDto);
        }

        // Supprimer une catégorie par ID
        public async Task<bool> DeleteCategoryAsync(int id)
        {
            return await _categoryRepository.DeleteCategoryAsync(id);
        }
    }
}
