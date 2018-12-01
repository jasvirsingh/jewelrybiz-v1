using System;
using System.Threading.Tasks;
using System.Web;
using System.Web.Mvc;
using Microsoft.AspNet.Identity;
using Microsoft.AspNet.Identity.Owin;
using Microsoft.Owin.Security;
using JewelryBiz.UI.Models;
using JewelryBiz.BusinessLayer;
using JewelryBiz.UI.Helpers;
using System.Web.Security;
using JewelryBiz.DataAccess.Models;
using System.Collections.Generic;
using System.Linq;

namespace JewelryBiz.UI.Controllers
{
    [Authorize]
    public class AccountController : BaseController
    {
        private ApplicationSignInManager _signInManager;
        private ApplicationUserManager _userManager;
        private ApplicationRoleManager _roleManager;

        public AccountController()
        {
        }

        public AccountController(ApplicationUserManager userManager, ApplicationSignInManager signInManager, ApplicationRoleManager roleManager )
        {
            UserManager = userManager;
            SignInManager = signInManager;
            RoleManager = roleManager;
        }

        public ApplicationSignInManager SignInManager
        {
            get
            {
                return _signInManager ?? HttpContext.GetOwinContext().Get<ApplicationSignInManager>();
            }
            private set
            {
                _signInManager = value;
            }
        }

        public ApplicationUserManager UserManager
        {
            get
            {
                return _userManager ?? HttpContext.GetOwinContext().GetUserManager<ApplicationUserManager>();
            }
            private set
            {
                _userManager = value;
            }
        }

        public ApplicationRoleManager RoleManager
        {
            get {
                var role  = _roleManager ?? HttpContext.GetOwinContext().Get<ApplicationRoleManager>();
                return role;
            }
            private set {
                _roleManager = value;
            }
        }

        //
        // GET: /Account/Login
        [AllowAnonymous]
        public ActionResult Login(string returnUrl)
        {
            ShoppingBag();
            ViewBag.ReturnUrl = returnUrl;
            return View();
        }

        //
        // POST: /Account/Login
        [HttpPost]
        [AllowAnonymous]
        [ValidateAntiForgeryToken]
        public async Task<ActionResult> Login(LoginViewModel model, string returnUrl)
        {
            if (!ModelState.IsValid)
            {
                return View(model);
            }

            // This doesn't count login failures towards account lockout
            // To enable password failures to trigger account lockout, change to shouldLockout: true
            var userService = new UserService();
            var user = userService.VerifyUser(model.UserName, model.Password);
            var result = user != null ? SignInStatus.Success : SignInStatus.Failure;
            switch (result)
            {
                case SignInStatus.Success:
                    Response.Cookies["User"]["Email"] = user.Email;
                    //Response.Cookies["User"]["FirstName"] = user.FirstName;
                    //Response.Cookies["User"]["LastName"] = user.LastName;
                    Response.Cookies["User"]["Role"] = user.RoleId == 1 ?"Admin" : "Customer";
                    //Response.Cookies["User"].Expires = DateTime.Now.AddHours(1);

                    FormsAuthenticationTicket ticket = new FormsAuthenticationTicket(
                        1,
                        user.Email,
                        DateTime.Now,
                        DateTime.Now.AddMinutes(60),
                        true,
                        user.RoleId.ToString(),
                        FormsAuthentication.FormsCookiePath);
                    string hash = FormsAuthentication.Encrypt(ticket);
                    HttpCookie cookie = new HttpCookie(FormsAuthentication.FormsCookieName, hash);

                    if (ticket.IsPersistent)
                    {
                        cookie.Expires = ticket.Expiration;
                    }
                    Response.Cookies.Add(cookie);
                    var sm = new UserSecurityManager();
                    sm.AuthorizeUser(user);
                    FormsAuthentication.SetAuthCookie(model.UserName, true);
                    Session["MyMenu"] = null;
                    if(Session["Checkout"]!=null)
                    {
                        if(Session["Checkout"].ToString() == "FromCheckout")
                        {
                            return RedirectToAction("Purchase", "Checkout");
                        }
                    }
                    return RedirectToAction("Index", "Admin");
                case SignInStatus.Failure:
                default:
                    ModelState.AddModelError("", "Invalid login attempt.");
                    return View(model);
            }
        }

              //
        // GET: /Account/Register
        [AllowAnonymous]
        public ActionResult Register()
        {
            SetStates();
            return View();
        }

        // GET: /Account/EmailsSignup
        [AllowAnonymous]
        public ActionResult EmailsSignup()
        {
            ShoppingBag();
            return View();
        }

        // GET: /Account/Signup
        [HttpPost]
        [AllowAnonymous]
        public ActionResult Signup(EmailSignupModel model)
        {
            if (!ModelState.IsValid)
            {
                return View("EmailsSignup",model);
            }
            Subscription subscription = new Subscription()
            {
                Email = model.Email,
                IsActive = true
            };
            var subscriptionService = new SubscriptionService();
            subscriptionService.Subscribe(model.Email);
            ViewBag.Message = "You have subscriber successfully.";
            return View("EmailsSignup");
        }

        // GET: /Account/Signup

        [AllowAnonymous]
        public ActionResult Logout()
        {
            Response.Cookies["User"].Expires = DateTime.Now.AddDays(-1);
            FormsAuthentication.SignOut();
            Session["MyMenu"] = null;
            return View("Logout");
        }

        //
        // POST: /Account/Register
        [HttpPost]
        [AllowAnonymous]
        [ValidateAntiForgeryToken]
        public async Task<ActionResult> Register(User model)
        {
            if (ModelState.IsValid)
            {
                var u = new User
                {
                    Email = model.Email,
                    Password = model.Password,
                };

                var userService = new UserService();
                userService.Create(u);
                ViewBag.Message = "User created successfully.";
                SetStates();
                var customer = new Customer
                {
                    Email = model.Email
                };

                return View("PersonalInfo", customer);
            }
            return View(model);
        }

        [HttpPost]
        [AllowAnonymous]
        [ValidateAntiForgeryToken]
        public async Task<ActionResult> SavePersonalInfo(Customer customer)
        {
            customer.CardType = "X";
            customer.CardNo = "X";
            customer.ExpDate = DateTime.Now.AddMonths(12);
            SetStates();
            if (ModelState.IsValid)
            {
                  var c = new Customer
                    {
                        FName = customer.FName,
                        LName = customer.LName,
                        Email = Request.Cookies["User"] == null ? customer.Email : Request.Cookies["User"]["Email"],
                        Phone = customer.Phone,
                        Address1 = customer.Address1,
                        Address2 = customer.Address2,
                        Postcode = customer.Postcode,
                        State = customer.State
                        //CardType = customer.CardType,
                        //CardNo = customer.CardNo,
                        //ExpDate = customer.ExpDate
                    };

                    var customerService = new CustomerService();
                    customerService.SavePersonalInfo(c, Session.SessionID);

                    return View("AccountConfirmation");
            }
            else
            {
                ViewBag.States = StatesService.GetStates();
            }
            List<ModelError> errors = new List<ModelError>();
            foreach (ModelState modelState in ViewData.ModelState.Values)
            {
                foreach (ModelError error in modelState.Errors)
                {
                    errors.Add(error);
                }
            }

            return View("PersonalInfo", customer);
        }

        //
        // GET: /Account/ConfirmEmail
        [AllowAnonymous]
        public async Task<ActionResult> ConfirmEmail(string userId, string code)
        {
            if (userId == null || code == null)
            {
                return View("Error");
            }
            var result = await UserManager.ConfirmEmailAsync(userId, code);
            return View(result.Succeeded ? "ConfirmEmail" : "Error");
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult LogOff()
        {
            AuthenticationManager.SignOut(DefaultAuthenticationTypes.ApplicationCookie);
            return RedirectToAction("Index", "Home");
        }

        protected override void Dispose(bool disposing)
        {
            if (disposing)
            {
                if (_userManager != null)
                {
                    _userManager.Dispose();
                    _userManager = null;
                }

                if (_signInManager != null)
                {
                    _signInManager.Dispose();
                    _signInManager = null;
                }
            }

            base.Dispose(disposing);
        }
        
        private void SetStates()
        {
            ViewBag.States = StatesService.GetStates();
        }
        #region Helpers
        // Used for XSRF protection when adding external logins
        private const string XsrfKey = "XsrfId";

        private IAuthenticationManager AuthenticationManager
        {
            get
            {
                return HttpContext.GetOwinContext().Authentication;
            }
        }

        private void AddErrors(IdentityResult result)
        {
            foreach (var error in result.Errors)
            {
                ModelState.AddModelError("", error);
            }
        }

        private ActionResult RedirectToLocal(string returnUrl)
        {
            if (Url.IsLocalUrl(returnUrl))
            {
                return Redirect(returnUrl);
            }
            return RedirectToAction("Index", "Home");
        }

        internal class ChallengeResult : HttpUnauthorizedResult
        {
            public ChallengeResult(string provider, string redirectUri)
                : this(provider, redirectUri, null)
            {
            }

            public ChallengeResult(string provider, string redirectUri, string userId)
            {
                LoginProvider = provider;
                RedirectUri = redirectUri;
                UserId = userId;
            }

            public string LoginProvider { get; set; }
            public string RedirectUri { get; set; }
            public string UserId { get; set; }

            public override void ExecuteResult(ControllerContext context)
            {
                var properties = new AuthenticationProperties { RedirectUri = RedirectUri };
                if (UserId != null)
                {
                    properties.Dictionary[XsrfKey] = UserId;
                }
                context.HttpContext.GetOwinContext().Authentication.Challenge(properties, LoginProvider);
            }
        }
        #endregion


        private void ShoppingBag()
        {
            if (Session != null)
            {
                var currentUserCartItems = new ShoppingCartDataService().GetCurrentUserCartItems(Session.SessionID);
                if (currentUserCartItems != null)
                {
                    ViewBag.CartTotalPrice = currentUserCartItems.Sum(c => c.Quantity * c.UnitPrice);
                    ViewBag.Cart = currentUserCartItems;
                    ViewBag.CartUnits = currentUserCartItems.Count();
                }
            }
        }
    }
}