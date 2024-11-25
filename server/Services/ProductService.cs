using System.Collections.Generic;
using System.Threading.Tasks;
using server.Dto;
using server.models;
using server.Models;
using server.Repositories;

namespace server.Services
{
    public class ProductService
    {
        private readonly ProductRepository _productRepository;

        public ProductService(ProductRepository productRepository)
        {
            _productRepository = productRepository;
        }

        public async Task<ProductModel> AddProductAsync(ProductModel product)
        {
            return await _productRepository.AddProductAsync(product);
        }

        public async Task<ProductModel> GetProductByIdAsync(int id)
        {
            return await _productRepository.GetProductByIdAsync(id);
        }

        public async Task<IEnumerable<ProductModel>> GetAllProductsAsync()
        {
            return await _productRepository.GetAllProductsAsync();
        }

        public async Task<ProductModel> UpdateProductAsync(int id ,UpdateProductDto product)
        {
            return await _productRepository.UpdateProductAsync(id,product);
        }

        public async Task<bool> DeleteProductAsync(int id)
        {
            return await _productRepository.DeleteProductAsync(id);
        }
    }
}
