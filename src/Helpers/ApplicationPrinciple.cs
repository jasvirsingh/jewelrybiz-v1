using System.Security.Principal;

namespace JewelryBiz.UI.Helpers
{
    public class ApplicationPrinciple : IPrincipal
    {
        public IIdentity Identity { get; set; }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="id"></param>
        /// <param name="roles"></param>
        public ApplicationPrinciple(IIdentity identity, string roles)
        {
            Identity = identity;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="role"></param>
        /// <returns></returns>
        public bool IsInRole(string role)
        {
            return true;
        }

    }
}