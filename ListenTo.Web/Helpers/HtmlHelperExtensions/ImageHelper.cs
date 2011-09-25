using System;
using System.Collections;
using System.Text;
using System.Web;
using System.Web.Mvc;
using System.Collections.Generic;
using ListenTo.Shared.DO;
using ListenTo.Shared.Helpers;
using System.Web.Routing;
using ListenTo.Shared.Interfaces.Helpers;
using ListenTo.Shared.Interfaces.Do;
using ListenTo.Shared.DTO;

namespace ListenTo.Web.Helpers.HtmlHelperExtensions
{

    public static class ImageHelpers
    {
        private const string ARTIST_PROFILE_IMAGE_PATH = "/content/images/thumbnails/thumb-artist.gif";

        public static string RenderArtistProfileImage(this HtmlHelper helper, Artist artist)
        {
            ImageMetaData imageMetaData = null;
            if (artist.ProfileImage != null)
            {
                imageMetaData = artist.ProfileImage;
            }
            return RenderArtistProfileImageThumbnail(helper, imageMetaData, "", "", null);
        }

        public static string RenderArtistProfileImageThumbnail(this HtmlHelper helper, Artist artist)
        {
            return RenderArtistProfileImageThumbnail(helper,artist,"","",null);
        }

        public static string RenderArtistProfileImageThumbnail(this HtmlHelper helper, ArtistSummary artist)
        {
            return RenderArtistProfileImageThumbnail(helper, artist, "", "", null);
        }

        public static string RenderArtistProfileImageThumbnail(this HtmlHelper helper, ArtistSummary artistSummary, string id, string alternateText, object htmlAttributes)
        {
            ImageMetaData imageMetaData = null;
            if (artistSummary.Thumbnail != null)
            {
                imageMetaData = artistSummary.Thumbnail;
            }
            return RenderArtistProfileImageThumbnail(helper, imageMetaData, id, alternateText, htmlAttributes);
        }

        public static string RenderArtistProfileImageThumbnail(this HtmlHelper helper, Artist artist, string id, string alternateText, object htmlAttributes)
        {
            ImageMetaData imageMetaData = null;
            if(artist.ProfileImage!=null && artist.ProfileImage.Thumbnail!=null){
                imageMetaData = artist.ProfileImage.Thumbnail;
            }
            return RenderArtistProfileImageThumbnail(helper, imageMetaData, id, alternateText, htmlAttributes);
        }

        public static string RenderArtistProfileImageThumbnail(this HtmlHelper helper, ImageMetaData imageMetaData, string id, string alternateText, object htmlAttributes)
        {
            string output = string.Empty;

            if (imageMetaData != null)
            {
                output = RenderImage(helper, imageMetaData, id, alternateText, htmlAttributes); 
            }
            else
            {
                output = RenderImage(helper, ARTIST_PROFILE_IMAGE_PATH, id, alternateText, htmlAttributes);
            }

            return output;
        }

        public static string RenderImage(this HtmlHelper helper, ImageMetaData imageMetaData)
        {
            return RenderImage(helper,imageMetaData,"","",null);
        }

        public static string RenderImage(this HtmlHelper helper, ImageMetaData imageMetaData, string id, string alternateText, object htmlAttributes)
        {
            string output = "";

            if (imageMetaData != null)
            {
                string url = ListenTo.Shared.Helpers.ImageHelpers.ConstructImageUrl(imageMetaData);
                output = RenderImage(helper, url, id, alternateText, htmlAttributes);
            }
            return output;
        }

        public static string RenderTemporaryImage(this HtmlHelper helper, IHasBinaryData binaryData, string id, string alternateText, object htmlAttributes)
        {
            ITemporaryFileStrategy temporaryFileStrategy = IOCHelper.GetTemporaryFileStrategy();
            string path = temporaryFileStrategy.ConstructTempFileURL(binaryData);
            string output = output = RenderImage(helper, path, id, alternateText, htmlAttributes);
            return output;
        }

        public static string RenderImage(this HtmlHelper helper, string url, string id, string alternateText, object htmlAttributes)
        {
            string output = "";

            // Create tag builder
            var builder = new TagBuilder("img");

            // Create valid id
            builder.GenerateId(id);

            // Add attributes
            builder.MergeAttribute("src", url);
            builder.MergeAttribute("alt", alternateText);
            builder.MergeAttributes(new RouteValueDictionary(htmlAttributes));

            // Render tag
            output = builder.ToString(TagRenderMode.SelfClosing);
            return output;
        }

    }
}