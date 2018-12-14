namespace JewelryBiz.DataAccess.Models
{
   public class Category
    {
        public int CategoryId { get; set; }

        public string CategoryName { get; set; }

        public string CategoryDescription { get; set; }

        public int ParentCategoryId { get; set; }
    }
}
