using System;
using System.Data;
using System.Configuration;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Xml.Linq;
using System.Web.Mvc;
using Spring.Core.IO;
using Spring.Objects.Factory;
using Spring.Objects.Factory.Xml;

namespace ListenTo.Web
{
    public class SpringControllerFactory : IControllerFactory
    {
        #region IControllerFactory Members

        IController IControllerFactory.CreateController(System.Web.Routing.RequestContext context, string controllerName)
        {
            if (string.IsNullOrEmpty(controllerName))
                throw new ArgumentNullException("controllerName");
            

            Spring.Context.IConfigurableApplicationContext ctx = (Spring.Context.IConfigurableApplicationContext)Spring.Context.Support.WebApplicationContext.Current;
            Spring.Objects.Factory.Config.IConfigurableListableObjectFactory objectFactory = ctx.ObjectFactory;
            IController controller = (IController)objectFactory.GetObject(controllerName);
            return controller;
        }

	    public void ReleaseController(IController controller)
	    {
			var disposable = controller as IDisposable;

			if (disposable != null) 
			{
				disposable.Dispose();
			}
	    }

        #endregion
    }
}


