using Microsoft.EntityFrameworkCore.Migrations;
using server.Models;


#nullable disable

namespace server.Migrations
{
    public partial class product : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {

        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {

        }

        public static implicit operator product(ProductModel v)
        {
            throw new NotImplementedException();
        }
    }
}
