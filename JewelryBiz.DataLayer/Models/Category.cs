namespace JewelryBiz.DataAccess.Models
{
   public class Category
    {
        public int CategoryId { get; set; }

        public string CategoryName { get; set; }

        public int ParentCategoryId { get; set; }
    }
}
