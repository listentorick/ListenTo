using System;
using System.Drawing.Imaging;
using System.Drawing;
using System.Drawing.Drawing2D;
using System.IO;

namespace ListenTo.Shared.Helpers
{

    public abstract class TrackHelpers
    {
        public static string ConstructTrackPath(ListenTo.Shared.DO.TrackMetaData trackMetaData)
        {
            var absolutePath = System.Configuration.ConfigurationSettings.AppSettings["ApplicationPath"] + System.Configuration.ConfigurationSettings.AppSettings["ApplicationRelativeTrackDirectoryPath"];
            absolutePath += "/" + trackMetaData.ID.ToString() + ".mp3";
            return absolutePath;
        }

        public static string ConstructTrackUrl(ListenTo.Shared.DO.TrackMetaData trackMetaData)
        {
            return System.Configuration.ConfigurationSettings.AppSettings["ApplicationRelativeTrackDirectoryPath"] + "/" + trackMetaData.ID.ToString() + ".mp3";
        }


        public static bool ContainsMP3Data(byte[] data)
        {
            MemoryStream s = new MemoryStream(data);
            ListenTo.Core.Audio.MP3Info mp3Info = new ListenTo.Core.Audio.MP3Info();
            return mp3Info.ReadMP3Information(s);
        }

        public static bool TrackContainsMP3Data(ListenTo.Shared.DO.Track track)
        {
            bool containsMP3Data = false;

            if (track!=null && track.Data!=null)
            {
                containsMP3Data = ContainsMP3Data(track.Data);
            }
            return containsMP3Data;

        }
    }
}
