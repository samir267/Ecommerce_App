using CloudinaryDotNet.Actions;
using CloudinaryDotNet;
using dotenv.net;
using Microsoft.AspNetCore.Mvc;
using server.Dto;
using server.Models;
using server.Services;



[Route("api/[controller]")]
[ApiController]
public class ProductController : ControllerBase
{
    private readonly ProductService _productService;
    private readonly Cloudinary _cloudinary;


    public ProductController(ProductService productService)
    {
        _productService = productService;
        DotEnv.Load();

        var cloudinaryUrl = Environment.GetEnvironmentVariable("CLOUDINARY_URL");
        if (cloudinaryUrl == null)
        {
            throw new InvalidOperationException("CLOUDINARY_URL is not set in environment variables.");
        }

        _cloudinary = new Cloudinary(cloudinaryUrl);
    }

    // CREATE : Ajouter un produit
    [HttpPost]
    public async Task<IActionResult> AddProduct([FromForm] addProductDto productDto)
    {
        Console.WriteLine("Début de l'upload d'image...");
        var start = DateTime.Now;

        // Vérification de l'image
        if (productDto.Image == null || productDto.Image.Length == 0)
        {
            return BadRequest(new { message = "Veuillez fournir une image valide." });
        }


        // Upload vers Cloudinary
        using var stream = productDto.Image.OpenReadStream();
        var uploadParams = new ImageUploadParams
        {
            File = new FileDescription(productDto.Image.FileName, stream),
            UseFilename = true,
            UniqueFilename = false,
            Overwrite = true
        };

        var uploadStart = DateTime.Now;
        var uploadResult = await _cloudinary.UploadAsync(uploadParams);
        Console.WriteLine("Upload Cloudinary terminé en {0}s", (DateTime.Now - uploadStart).TotalSeconds);

        if (uploadResult.StatusCode != System.Net.HttpStatusCode.OK)
        {
            return BadRequest(new { message = "L'upload de l'image a échoué." });
        }

        // Création du produit
        var product = new ProductModel
        {
            Name = productDto.Name,
            Description = productDto.Description,
            Quantity = productDto.Quantity,
            Image = uploadResult.SecureUrl.ToString(),
            Price = productDto.Price,
            CategoryId = productDto.CategoryId,
            UserId = productDto.UserId
        };

        Console.WriteLine("Ajout du produit dans la base de données...");
        var dbStart = DateTime.Now;
        var createdProduct = await _productService.AddProductAsync(product);
        Console.WriteLine("Produit ajouté à la base en {0}s", (DateTime.Now - dbStart).TotalSeconds);

        var total = DateTime.Now - start;
        Console.WriteLine("Opération complète terminée en {0}s", total.TotalSeconds);

        return CreatedAtAction(nameof(GetProductById), new { id = createdProduct.Id }, createdProduct);
    }

    // READ : Récupérer un produit par ID
    [HttpGet("{id}")]
    public async Task<IActionResult> GetProductById(int id)
    {
        var product = await _productService.GetProductByIdAsync(id);
        if (product == null)
        {
            return NotFound();
        }
        return Ok(product);
    }

    // READ : Récupérer tous les produits
    [HttpGet]
    public async Task<ActionResult<IEnumerable<ProductModel>>> GetAllProducts()
    {
        var products = await _productService.GetAllProductsAsync();
        return Ok(products);
    }

    // UPDATE : Mettre à jour un produit
    [HttpPut("{id}")]
    public async Task<IActionResult> UpdateProduct(int id, [FromBody] UpdateProductDto product)
    {
        if (product == null)
        {
            return BadRequest();
        }

        var updatedProduct = await _productService.UpdateProductAsync(id, product);
        if (updatedProduct == null)
        {
            return NotFound();
        }
        return Ok(updatedProduct);
    }

    // DELETE : Supprimer un produit
    [HttpDelete("{id}")]
    public async Task<IActionResult> DeleteProduct(int id)
    {
        var result = await _productService.DeleteProductAsync(id);
        if (!result)
        {
            return NotFound();
        }
        return NoContent();
    }
}
