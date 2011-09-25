using System;
using System.Drawing.Imaging;
using System.Drawing;
using System.Drawing.Drawing2D;
using System.IO;
using System.Text.RegularExpressions;

namespace ListenTo.Shared.Helpers
{

    public abstract class FormatHelpers
    {

        private static Regex isGuid = new Regex(@"^(\{){0,1}[0-9a-fA-F]{8}\-[0-9a-fA-F]{4}\-[0-9a-fA-F]{4}\-[0-9a-fA-F]{4}\-[0-9a-fA-F]{12}(\}){0,1}$", RegexOptions.Compiled);
        private static Regex isEmail = new Regex(@"^([a-zA-Z0-9_\-\.]+)@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.)|(([a-zA-Z0-9\-]+\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\]?)$", RegexOptions.Compiled);
        private static Regex isAlphaNumeric = new Regex("^([A-Za-z0-9]+)$");

        public static bool IsGuid(string candidate)
        {
            if (candidate != null)
            {
                if (isGuid.IsMatch(candidate))
                {
                    return true;
                }
            }

            return false;
        }

        public static bool IsEmptyGuid(string candidate)
        {
            string emptyGuid = Guid.Empty.ToString();
            return candidate == emptyGuid;
        }

        public static bool IsEmail(string emailAddress)
        {
            return isEmail.IsMatch(emailAddress);
        }


        public static bool IsURL(string url)
        {
            string strRegex = @"^(http|ftp)://(www\.)?.+\.(com|net|org|co.uk)$";

            Regex re = new Regex(strRegex);
            if (re.IsMatch(url))
                return (true);
            else
                return (false);
        }

        public static bool IsAlphaNumeric(string strToCheck)
        {
            bool result = false;
            if (strToCheck!=null)
            {
                result = isAlphaNumeric.IsMatch(strToCheck);
            }
            return result;
        }

    }
}
