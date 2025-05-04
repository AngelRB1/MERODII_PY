using System.ComponentModel.DataAnnotations;

namespace Merodii_Beta.Models
{
    public class E_Categoria
    {
        [Key]
        public int IdCategoria { get; set; }
        public string NombreCategoria { get; set; }

        public string DescripcionCategoria { get; set; } 

        public bool Estado {  get; set; }
        
        
    }
}
