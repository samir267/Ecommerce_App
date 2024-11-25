using System.Collections.Generic;
using System.Threading.Tasks;
using Microsoft.EntityFrameworkCore;
using server.Dto; // N'oubliez pas d'importer le namespace pour le DTO si vous l'utilisez.
using server.Models;

namespace server.Repositories
{
    public class ProductRepository
    {
        private readonly AppDbContext _context;

        public ProductRepository(AppDbContext context)
        {
            _context = context;
        }

        // CREATE : Ajouter un nouveau produit
        public async Task<ProductModel> AddProductAsync(ProductModel product)
        {
            // Vérifiez si la catégorie et l'utilisateur existent
            if (!await _context.Categories.AnyAsync(c => c.Id == product.CategoryId) ||
                !await _context.Users.AnyAsync(u => u.Id == product.UserId))
            {
                return null; // La catégorie ou l'utilisateur n'existe pas
            }

            _context.Products.Add(product);
            await _context.SaveChangesAsync();
            return product;
        }

        // READ : Récupérer un produit par son ID
        public async Task<ProductModel> GetProductByIdAsync(int id)
        {
            return await _context.Products.FindAsync(id);
        }

        // READ : Récupérer tous les produits
        public async Task<IEnumerable<ProductModel>> GetAllProductsAsync()
        {
            return await _context.Products.ToListAsync();
        }

        // UPDATE : Mettre à jour un produit existant
        public async Task<ProductModel> UpdateProductAsync(int productId, UpdateProductDto productDto)
        {
            var existingProduct = await _context.Products.FindAsync(productId);
            if (existingProduct == null)
            {
                return null; // Le produit n'existe pas
            }

            // Mettez à jour uniquement les propriétés fournies
                existingProduct.Name = productDto.Name;

                existingProduct.Description = productDto.Description;

                existingProduct.Quantity = productDto.Quantity;

                existingProduct.Image = productDto.Image;

                existingProduct.Price = productDto.Price;

            // Enregistrez les modifications
            await _context.SaveChangesAsync();
            return existingProduct;
        }

        // DELETE : Supprimer un produit par son ID
        public async Task<bool> DeleteProductAsync(int id)
        {
            var product = await _context.Products.FindAsync(id);
            if (product == null)
            {
                return false; // Le produit n'existe pas
            }

            _context.Products.Remove(product);
            await _context.SaveChangesAsync();
            return true;
        }
    }
}
