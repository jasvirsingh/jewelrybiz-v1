using Microsoft.Owin;
using Owin;

[assembly: OwinStartupAttribute(typeof(JewelryBiz.UI.Startup))]
namespace JewelryBiz.UI
{
    public partial class Startup
    {
        public void Configuration(IAppBuilder app)
        {
            ConfigureAuth(app);
        }
    }
}
