using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace ListenTo.Shared.DO
{
    public class UserProfile: BaseDO
    {
        public string Username { get; set; }
        public string Profile { get; set; }
        public IList<Style> Styles { get; set; }
        public Town Town { get; set; }
        public string Forename { get; set; }
        public string Surname { get; set; }
        public bool RecievesNewsletter { get; set; }
        public ImageMetaData ProfileImage { get; set; }
        public string Email { get; set; }
    }
}
