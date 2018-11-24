using JewelryBiz.DataAccess;
using JewelryBiz.DataAccess.Models;

namespace JewelryBiz.BusinessLayer
{
    public class ShoppingCartDataService
    {
        public CartItem GetByProductId(string userSessionId, int productId)
        {
            return new ShoppingCartDataDAL().GetByProductId(userSessionId, productId);
        }

        public void AddCartItem(CartItem cartItem)
        {
           new ShoppingCartDataDAL().AddCartItem(cartItem);
        }

        public void IncreaseCartItemQuantity(string userSessionId, int productId)
        {
            new ShoppingCartDataDAL().IncreaseCartItemQuantity(userSessionId, productId);
        }
    }
}
