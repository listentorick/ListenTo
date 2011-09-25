using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using ListenTo.Shared.Interfaces.Actions;
using Dimebrain.TweetSharp.Fluent;
using ListenTo.Shared.Interfaces;
using System.Collections;
using ListenTo.Shared.Helpers;
using Common.Logging;
namespace ListenTo.Core.Actions
{
    public class TwitterPublisher : IActionPublisher
    {
        private static readonly ILog LOG = LogManager.GetLogger(typeof(TwitterPublisher));
        private const string TWITTER_USERNAME = "listentomanc";
        private const string TWITTER_PASSWORD = "transparent";

        public IActionDataHelper ActionDataHelper {get;set;}
        public IActionUrlHelper ActionUrlHelper {get;set;}
        public ITemplateEngine TempateEngine { get; set; }
        public IUrlShortener UrlShortener { get; set; }
        public string TemplateFilename { get; set; }

        #region IActionPublisher Members

        public void Publish(ListenTo.Shared.DO.Action action)
        {
            LOG.Info("Publish an action to twitter");

            try
            {
                //This executes in a seperate thread
                //which doesnt have access to the request scopes linqtosql repository
                //until ive solved this we cant use the ActionDataHelper

                object data = ActionDataHelper.GetActionData(action);
                action.ActionData = data;
                string url = ActionUrlHelper.GetUrl(action);

                url = UrlShortener.ShortenUrl(url);

                Hashtable templateParameters = new Hashtable();
                templateParameters.Add("Action", action);
                templateParameters.Add("Url", url);
                string templatePath = TemplateFilename;

                templatePath = TemplateHelpers.GetTemplateFromFilename(TemplateFilename);

                string content = TempateEngine.Process(templatePath, templateParameters);

                //var twitter = FluentTwitter.CreateRequest()
                //    .AuthenticateAs(TWITTER_USERNAME, TWITTER_PASSWORD)
                //    .Statuses().Update(content)
                //    .AsJson();

                //var response = twitter.Request();
            }
            catch (Exception e)
            {
                LOG.Error("Error Tweeting", e);
                //log here
                throw;
            }
  
        }

        #endregion
    }
}
