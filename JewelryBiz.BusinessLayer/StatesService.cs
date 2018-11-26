using JewelryBiz.DataAccess;
using System.Collections.Generic;

namespace JewelryBiz.BusinessLayer
{
   public class StatesService
    {
        public static List<object> GetStates()
        {
            return Helpers.GetStates();
        }
    }
}
