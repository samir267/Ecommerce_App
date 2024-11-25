using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Tokens;
using server.Models;
using server.Services;
using server.Repositories;
using System.Text;
using back_wachify.Data_Layer;
using AutoMapper;
using static server.interfaces.ICartRepositry;
using server.interfaces;
using System.Text.Json.Serialization;
using dotenv.net;
using CloudinaryDotNet;

DotEnv.Load();

var builder = WebApplication.CreateBuilder(args);

// Configure connection string for AppDbContext
builder.Services.AddDbContext<AppDbContext>(options =>
    options.UseSqlServer(builder.Configuration.GetConnectionString("DefaultConnection")));

// Ajout des services pour le contrôle API
builder.Services.AddControllers();

// Register repositories and services
builder.Services.AddScoped<UserRepository>();
builder.Services.AddScoped<UserService>();
builder.Services.AddScoped<CategoryRepository>();
builder.Services.AddScoped<CategoryService>();
builder.Services.AddScoped<ProductRepository>();
builder.Services.AddScoped<ProductService>();
builder.Services.AddScoped<ICartRepositry, CartRepository>();
builder.Services.AddScoped<ICartService, CartService>();
builder.Services.AddScoped<IOrderService, OrderService>();
builder.Services.AddScoped<IOrderRepository, OrderRepository>();

// Configure CORS
builder.Services.AddCors(options =>
{
    options.AddPolicy("AllowSpecificOrigins", policy =>
    {
        // Retirer la barre oblique à la fin de l'URL
        policy.WithOrigins("http://localhost:65357")  // URL de votre front-end Flutter
              .AllowAnyHeader()
              .AllowAnyMethod()
              .AllowCredentials();  // Si vous utilisez des cookies ou des sessions
    });
});

// Configuration pour Cloudinary
builder.Services.AddSingleton(provider =>
{
    var cloudinaryUrl = Environment.GetEnvironmentVariable("CLOUDINARY_URL");
    if (string.IsNullOrEmpty(cloudinaryUrl))
    {
        throw new InvalidOperationException("CLOUDINARY_URL est manquant dans les variables d'environnement.");
    }

    return new Cloudinary(cloudinaryUrl);
});

// In ConfigureServices method in Startup.cs or directly in Program.cs if using minimal APIs
builder.Services.AddControllers()
    .AddJsonOptions(options =>
    {
        options.JsonSerializerOptions.ReferenceHandler = ReferenceHandler.Preserve;
    });

// Configure JWT authentication
builder.Services.AddAuthentication(options =>
{
    options.DefaultAuthenticateScheme = JwtBearerDefaults.AuthenticationScheme;
    options.DefaultChallengeScheme = JwtBearerDefaults.AuthenticationScheme;
}).AddJwtBearer(options =>
{
    options.RequireHttpsMetadata = false;
    options.SaveToken = true;
    options.TokenValidationParameters = new TokenValidationParameters
    {
        ValidateIssuer = true,
        ValidateAudience = true,
        ValidateLifetime = true,
        ValidateIssuerSigningKey = true,
        ValidIssuer = builder.Configuration["Jwt:Issuer"],
        ValidAudience = builder.Configuration["Jwt:Audience"],
        IssuerSigningKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(builder.Configuration["Jwt:Key"]))
    };
});

// Add Swagger/OpenAPI for API documentation
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

// Configure AutoMapper with the MappingProfile
var mapperConfig = new MapperConfiguration(mc =>
{
    mc.AddProfile(new MappingProfile());
});
IMapper mapper = mapperConfig.CreateMapper();
builder.Services.AddSingleton(mapper);

// Build the application
var app = builder.Build();

// Configure the HTTP request pipeline
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseHttpsRedirection();

// Use CORS
app.UseCors("AllowSpecificOrigins");

// Use authentication and authorization
app.UseAuthentication();
app.UseAuthorization();

// Map controller routes
app.MapControllers();

app.Run();
