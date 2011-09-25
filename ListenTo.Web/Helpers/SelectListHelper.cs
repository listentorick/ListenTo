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
using System.Collections.Generic;
using System.Web.Mvc;
using ListenTo.Shared.Interfaces.DO;
using System.Globalization;

namespace ListenTo.Web.Helpers
{
    public static class SelectListHelper
    {
        public static SelectList CreateAmPm(bool isPm)
        {
            string selectedValue = "am";
            if (isPm) { selectedValue = "pm"; } 
            List<string> amPm = new List<string>() { "am", "pm"};
            return new SelectList(amPm,selectedValue);
        }

        public static SelectList CreateHours(int start, int finish, int step, int selected)
        {
            return new SelectList(CreateListOfInts(start, finish, step), selected);
        }

        public static SelectList CreateMinutes(int start, int finish, int step, int selected)
        {
            return new SelectList(CreateListOfInts(start, finish, step), selected);
        }

        public static SelectList CreateDays(int start, int finish, int step, int selected)
        {
            return new SelectList(CreateListOfInts(start, finish, step), selected);
        }

        public static SelectList CreateYears(int start, int finish, int step, int selected)
        {
            return new SelectList(CreateListOfInts(start, finish, step), selected);
        }

        public static SelectList CreateMonths(int start, int finish, int step, int selected)
        {

            List<KeyValuePair<int, string>> months = new List<KeyValuePair<int, string>>();

            for (int i = start; i <= finish; i += step)
            {
                KeyValuePair<int, string> kvp = new KeyValuePair<int, string>(i, CultureInfo.CurrentCulture.DateTimeFormat.GetMonthName(i));
                months.Add(kvp);
            }

            return new SelectList(months, "key", "value", selected);
        }

        public static SelectList CreateSelectList<T>(IList<T> things, Guid? selectedKey) where T : INamedDO
        {
            if (!selectedKey.HasValue && things.Count > 0)
            {
                selectedKey = Guid.Empty;
            }

            KeyValuePair<Guid,string> makeSelection = new KeyValuePair<Guid,string>(Guid.Empty,"-- select --");

            IList<KeyValuePair<Guid, string>> kvp = Adapt<T>(things);
            kvp.Insert(0, makeSelection);

            return CreateSelectList(kvp, selectedKey);
        }

        public static SelectList CreateSelectList(IList<KeyValuePair<Guid, string>> kvpList, Guid? selectedKey)
        {
            SelectList selectList = null;

            if (selectedKey != null)
            {
                selectList = new SelectList(kvpList, "key", "value", selectedKey);
            }
            else
            {
                selectList = new SelectList(kvpList, "key", "value");
            }

            return selectList;
        }

        public static List<KeyValuePair<Guid, string>> Adapt<T>(IList<T> things) where T : INamedDO
        {
            List<KeyValuePair<Guid, string>> kvpList = new List<KeyValuePair<Guid, string>>();

            foreach (T thing in things)
            {
                KeyValuePair<Guid, string> kvp = new KeyValuePair<Guid, string>(thing.ID, thing.Name);
                kvpList.Add(kvp);
            }

            return kvpList;
        }

        public static List<int> CreateListOfInts(int start, int finish, int step)
        {
            List<int> numbers = new List<int>();

            for (int i = start; i <= finish; i += step)
            {
                numbers.Add(i);
            }

            return numbers;

        }

    }
}
