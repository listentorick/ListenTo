using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using ListenTo.Shared.DO;
using ListenTo.Shared.DTO;

namespace ListenTo.Shared.Interfaces.Repository
{
    public interface IRepository
    {
        IQueryable<ListenTo.Shared.DO.Gig> GetGigs();
        IQueryable<ListenTo.Shared.DO.Gig> GetGigsByArtist(Guid artistID);
        IQueryable<ListenTo.Shared.DO.Gig> GetNRandomGigsBySiteAfterDate(int nGigs, Guid siteId, DateTime startDate);
        IList<ListenTo.Shared.DO.Gig> GetGigsAtVenue(Guid venueId);
        IQueryable<ListenTo.Shared.DO.Venue> GetVenues();
        ListenTo.Shared.DO.Venue SaveVenue(ListenTo.Shared.DO.Venue venue);

        IQueryable<ListenTo.Shared.DO.Artist> GetArtists();
        ListenTo.Shared.Utility.IPageOfList<Artist> GetArtistsByStyle(int pageSize, int currentPageIndex, Guid styleId);
        IQueryable<ListenTo.Shared.DO.Artist> GetNRandomArtists(int numberOfArtists);
        IList<ArtistSummary> GetNRandomArtistSummaries(int numberOfArtists);
        IList<ArtistSummary> GetNRandomArtistSummariesBySite(Guid siteId, int numberOfArtists);
        IQueryable<ListenTo.Shared.DO.Artist> GetNRandomArtistsBySite(Guid siteId, int numberOfArtists);
        IQueryable<ListenTo.Shared.DO.Artist> GetArtistsByOwner(Guid ownerId);
        int GetNumberOfArtists();
        int GetNumberOfArtistsBySite(Guid siteId);
        ListenTo.Shared.DO.Artist SaveArtist(ListenTo.Shared.DO.Artist artist);

        ListenTo.Shared.Utility.IPageOfList<ListenTo.Shared.DTO.ArtistSummary> GetArtistSummariesBySite(int pageSize, int currentPageIndex, Guid siteId);
        ListenTo.Shared.Utility.IPageOfList<ListenTo.Shared.DTO.ArtistSummary> GetArtistSummariesBySiteAndStyle(int pageSize, int currentPageIndex, Guid siteId, Guid styleId);
        ListenTo.Shared.Utility.IPageOfList<ListenTo.Shared.DTO.ArtistSummary> GetArtistSummariesByOwner(int pageSize, int currentPageIndex, Guid ownerId);
        ListenTo.Shared.Utility.IPageOfList<ListenTo.Shared.DTO.NewsItemSummary> GetNewsItemSummariesByOwner(int pageSize, int currentPageIndex, Guid userId);
       
        int GetNumberOfArtistsOwnedBy(Guid ownerId);

        ListenTo.Shared.DO.Gig SaveGig(ListenTo.Shared.DO.Gig gig);
        IQueryable<ListenTo.Shared.DO.User> GetUsers();
        ListenTo.Shared.DO.User SaveUser(ListenTo.Shared.DO.User user);
        
        IQueryable<ListenTo.Shared.DO.UserProfile> GetUserProfiles();
        ListenTo.Shared.DO.UserProfile GetUserProfile(Guid id);
        ListenTo.Shared.DO.UserProfile SaveUserProfile(ListenTo.Shared.DO.UserProfile userProfile);
        ListenTo.Shared.DO.UserProfile GetUserProfileByUsername(string username);

        ListenTo.Shared.DO.ImageMetaData SaveImageMetaData(ListenTo.Shared.DO.ImageMetaData imageMetaData);
        IQueryable<ListenTo.Shared.DO.ImageMetaData> GetImageMetaDatas();
        void DeleteImageMetaData(Guid id);
        
        IQueryable<ListenTo.Shared.DO.Style> GetStyles();
        IList<ListenTo.Shared.DTO.StyleSummary> GetStyleSummaries(Guid siteId);
        ListenTo.Shared.DO.Style GetStyleWithName(string name);


        IQueryable<ListenTo.Shared.DO.Town> GetTowns();
        ListenTo.Shared.DO.Town GetTown(Guid id);
        IQueryable<ListenTo.Shared.DO.Act> GetActs();
        IQueryable<ListenTo.Shared.DO.Comment> GetComments();
        ListenTo.Shared.DO.Comment SaveComment(ListenTo.Shared.DO.Comment comment);
        IQueryable<ListenTo.Shared.DTO.CommentSummary> GetCommentSummaries();
        IQueryable<ListenTo.Shared.DO.TrackMetaData> GetTrackMetaDatas();
        IQueryable<ListenTo.Shared.DTO.TrackSummary> GetTrackSummaries();
        IQueryable<ListenTo.Shared.DTO.TrackSummary> GetTrackSummariesBySite(Guid siteId);
        IQueryable<ListenTo.Shared.DTO.TrackSummary> GetTrackSummariesByArtist(Guid artistId);
        ListenTo.Shared.Utility.IPageOfList<ListenTo.Shared.DTO.TrackSummary> GetTrackSummariesBySiteAndStyle(int pageSize, int currentPageIndex, Guid siteId, Guid styleId);
        ListenTo.Shared.Utility.IPageOfList<ListenTo.Shared.DTO.TrackSummary> GetTrackSummariesBySiteAndStylesAndArtists(int pageSize, int currentPageIndex, Guid siteId, IList<Guid> styleIds, IList<Guid> artistIds);
        IList<ListenTo.Shared.DTO.TrackSummary> GetNRandomlyOrderedTrackSummariesBySiteAndStylesAndArtists(int num, Guid siteId, IList<Guid> styleIds, IList<Guid> artistIds);
 

        ListenTo.Shared.DO.TrackMetaData SaveTrackMetaData(ListenTo.Shared.DO.TrackMetaData trackMetaData);
        IQueryable<ListenTo.Shared.DO.Site> GetSites();
        ListenTo.Shared.DO.Site GetSiteByURL(string url);

        IQueryable<ListenTo.Shared.DO.NewsItem> GetNewsItems();
        IQueryable<ListenTo.Shared.DTO.NewsItemSummary> GetNewsItemSummary();
        IQueryable<NewsItemSummary> GetNewsItemSummaryBySite(Guid siteId);
        ListenTo.Shared.Utility.IPageOfList<ListenTo.Shared.DTO.NewsItemSummary> GetNewsItemSummaryBySite(int pageSize, int currentPageIndex, Guid siteId);
        IQueryable<ListenTo.Shared.DTO.NewsItemSummary> GetPublishedNewsItemSummaryBySite(Guid siteId);
        ListenTo.Shared.Utility.IPageOfList<ListenTo.Shared.DTO.NewsItemSummary> GetPublishedNewsItemSummaryBySite(int pageSize, int currentPageIndex, Guid siteId);
        NewsItem GetNewsItemById(Guid id);
        NewsItem SaveNewsItem(ListenTo.Shared.DO.NewsItem newsItem);
        IList<ListenTo.Shared.DTO.NewsItemSummary> GetPublishedNewsItemSummaryByIds(IList<Guid> ids);

        ListenTo.Shared.Utility.IPageOfList<Guid> GetWhatsNewSummariesForSite(int pageSize, int currentPageIndex, Guid siteId);
        ListenTo.Shared.Utility.IPageOfList<Guid> GetWhatsNewSummariesOwnedByUser(int pageSize, int currentPageIndex, Guid siteId, Guid userId);

        ListenTo.Shared.DO.Action SaveAction(ListenTo.Shared.DO.Action action);
        ListenTo.Shared.Utility.IPageOfList<ListenTo.Shared.DO.Action> GetUsersLatestActions(int pageSize, int currentPageIndex, Guid userId);
        ListenTo.Shared.Utility.IPageOfList<ListenTo.Shared.DO.Action> GetLatestActionsForSite(int pageSize, int currentPageIndex, Guid siteId);

        ListenTo.Shared.DO.Relationship SaveRelationship(ListenTo.Shared.DO.Relationship relationship);
        ListenTo.Shared.Utility.IPageOfList<ArtistFanRelationshipSummary> GetArtistFanRelationshipSummaryForUser(int pageSize, int currentPageIndex, Guid userId);
        ListenTo.Shared.Utility.IPageOfList<ArtistFanRelationshipSummary> GetArtistFanRelationshipSummaryForArtist(int pageSize, int currentPageIndex, Guid artistId);

        bool DoesRelationshipExist(Relationship relationship);
    }
}
