using Microsoft.AspNetCore.Mvc;
using Microsoft.IdentityModel.Tokens;
using server.Models;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;
using System.Threading.Tasks;
using Microsoft.EntityFrameworkCore;

namespace server.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class LoginController : ControllerBase
    {
        private readonly IConfiguration _configuration;
        private readonly AppDbContext _context;

        public LoginController(IConfiguration configuration, AppDbContext context)
        {
            _configuration = configuration;
            _context = context;
        }

        [HttpPost]
        [Route("PostLoginDetails")]
        public async Task<IActionResult> PostLoginDetails([FromBody] Dto.AuthDto _authDto)
        {
            if (_authDto != null)
            {
                var resultLoginCheck = await _context.Users
                    .Where(e => e.Email == _authDto.Email)
                    .FirstOrDefaultAsync();

                if (resultLoginCheck == null || !BCrypt.Net.BCrypt.Verify(_authDto.Password, resultLoginCheck.Password))
                {
                    return BadRequest("Invalid Credentials");
                }
                else
                {
                    var accessTokenClaims = new List<Claim>
                    {
                        new Claim(JwtRegisteredClaimNames.Sub, _configuration["Jwt:Subject"] ?? string.Empty),
                        new Claim(JwtRegisteredClaimNames.Jti, Guid.NewGuid().ToString()),
                        new Claim(JwtRegisteredClaimNames.Iat, DateTime.UtcNow.ToString()),
                        new Claim("UserId", resultLoginCheck.Id.ToString()),
                        //new Claim("DisplayName", resultLoginCheck.Username ?? string.Empty),
                        //new Claim("Email", resultLoginCheck.Email ?? string.Empty)
                    };

                    var key = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(_configuration["Jwt:Key"]));
                    var signIn = new SigningCredentials(key, SecurityAlgorithms.HmacSha256);

                    var accessToken = new JwtSecurityToken(
                        _configuration["Jwt:Issuer"],
                        _configuration["Jwt:Audience"],
                        accessTokenClaims,
                        expires: DateTime.UtcNow.AddMinutes(30), // Expiration courte
                        signingCredentials: signIn);

                    var refreshTokenClaims = new List<Claim>
                    {
                        new Claim(JwtRegisteredClaimNames.Sub, _configuration["Jwt:Subject"] ?? string.Empty),
                        new Claim(JwtRegisteredClaimNames.Jti, Guid.NewGuid().ToString()),
                        new Claim("UserId", resultLoginCheck.Id.ToString())
                    };

                    var refreshToken = new JwtSecurityToken(
                        _configuration["Jwt:Issuer"],
                        _configuration["Jwt:Audience"],
                        refreshTokenClaims,
                        expires: DateTime.UtcNow.AddDays(7), // Expiration plus longue pour le Refresh Token
                        signingCredentials: signIn);

                    resultLoginCheck.RefreshToken = new JwtSecurityTokenHandler().WriteToken(refreshToken);

                    _context.Users.Update(resultLoginCheck);
                    await _context.SaveChangesAsync();

                    var accessTokenString = new JwtSecurityTokenHandler().WriteToken(accessToken);
                    return Ok(new { UserId = resultLoginCheck.Id, AccessToken = accessTokenString });
                }
            }
            else
            {
                return BadRequest("No Data Posted");
            }
        }
    }
}
