using System.Collections.Generic;
using Microsoft.EntityFrameworkCore;
using Merodii_Beta.Models;

namespace Merodii_Beta.Servicios
{
    public class ContextoBD : DbContext // Asegúrate de heredar de DbContext
    {
        public ContextoBD(DbContextOptions<ContextoBD> options) : base(options) // Usa DbContextOptions<ContextoBD>
        {
        }

        public required DbSet<E_Categoria> Categoria { get; set; }
    }
}
