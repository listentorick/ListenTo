using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using ListenTo.Shared.Interfaces.Actions;
using System.Threading;
using Common.Logging;

namespace ListenTo.Core.Actions
{

    public class ActionPublicationQueue : IActionPublicationQueue
    {
        private static readonly ILog LOG = LogManager.GetLogger(typeof(ActionPublicationQueue));
       
        public IActionPublisherFactory ActionPublisherFactory { get; set; }

        public class WaitCallbackData
        {
            public WaitCallbackData(IActionPublisher actionPublisher, ListenTo.Shared.DO.Action action)
            {
                ActionPublisher = actionPublisher;
                Action = action;
            }

            public IActionPublisher ActionPublisher { get; set; }
            public ListenTo.Shared.DO.Action Action { get; set; }
        }

        public void PublishAction(ListenTo.Shared.DO.Action action)
        {
            IList<IActionPublisher> publishers = ActionPublisherFactory.GetPublishers(action);

            foreach (IActionPublisher publisher in publishers)
            {
                WaitCallbackData data = new WaitCallbackData(publisher, action);
                ThreadPool.QueueUserWorkItem(new WaitCallback(Publish), data);               
            }
        }

        private static void Publish(object data)
        {
            try
            {
                IActionPublisher actionPublisher = ((WaitCallbackData)data).ActionPublisher;
                ListenTo.Shared.DO.Action action = ((WaitCallbackData)data).Action;
                actionPublisher.Publish(action);
            }
            catch (Exception e)
            {
                //log the issue BUT consume the exception since we do not 
                //actually care if the actionPublisher completes, but we dont want to tear 
                //down the thread

                LOG.Error("Publication of action has failed",e);
            }

        }

    }
}
