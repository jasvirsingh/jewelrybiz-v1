using JewelryBiz.DataAccess.Domain;
using JewelryBiz.DataAccess.Models;
using System.Collections.Generic;

namespace JewelryBiz.DataLayer.Domain
{
    public class SelectedItem
    {
        public int ProductId { get; set; }
        public string ProductName { get; set; }
        public string Description { get; set; }
        public decimal UnitPrice { get; set; }
        public int OnHand { get; set; }
        public int Quantity { get; set; }
        public string Image { get; set; }
        public string PCategoryName { get; set; }
        //public int SizeMaterialId { get; set; }
        //public int ClaspMaterialId { get; set; }
        //public int StrandMaterialId { get; set; }
        public string Strand1 { get; set; }
        public string Strand2 { get; set; }
        public string Strand3 { get; set; }
        public string Strand4 { get; set; }
        public SelectedMotherBraceletMaterial MotherBraceletMaterial { get; set; }
        public IList<JewelryBiz.DataAccess.Models.ProductMaterial> Materials { get; set; }
    }
}
