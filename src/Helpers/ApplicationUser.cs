using System.Security.Principal;

namespace JewelryBiz.UI.Helpers
{
    public class ApplicationUser : IIdentity
    {
        public string Name { get; set; }

        public string Password { get; set; }

        //==========================
        public string AuthenticationType
        {
            get { return "Custom"; }
            set { }
        }

        public bool IsAuthenticated
        {
            get
            {
                if (!string.IsNullOrEmpty(Name))
                {
                    return true;
                }
                else
                {
                    return false;
                }

            }
            set
            {
            }
        }

        /// <summary>
        /// 
        /// </summary>
        public ApplicationUser()
        {
        }
    }
}