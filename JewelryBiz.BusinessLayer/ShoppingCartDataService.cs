using JewelryBiz.DataAccess;
using JewelryBiz.DataAccess.Models;
using System.Collections.Generic;

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

        public void UpdateCartItemQuantity(string userSessionId, int productId, int quantity)
        {
            new ShoppingCartDataDAL().UpdateCartItemQuantity(userSessionId, productId, quantity);
        }

        public void Clear(string userSessionId)
        {
            new ShoppingCartDataDAL().Clear(userSessionId);
        }

        public IList<CartItem> GetCurrentUserCartItems(string userSessionId)
        {
           return new ShoppingCartDataDAL().GetCurrentUserCartItems(userSessionId);
        }

        public void ExecuteChangeInQuantity(string userSessionId, int productId, string action)
        {
            new ShoppingCartDataDAL().ExecuteChangeInQuantity(userSessionId, productId, action);
        }
    }
}
