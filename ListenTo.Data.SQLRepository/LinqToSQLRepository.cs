using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using ListenTo.Shared.Interfaces.Repository;
using ListenTo.Shared.RepositoryFilters;
using System.Collections;
using ListenTo.Shared.Utility;
using ListenTo.Data.LinqToSQL.Adapters;
using ListenTo.Shared.DTO;
using ListenTo.Shared.DO;
using ListenTo.Shared.Enums;
using ListenTo.Shared.EqualityComparers;


namespace ListenTo.Data.LinqToSQL
{
    public class LinqToSQLRepository : IRepository 
    {

        #region ListenToDataContext

        public ListenToDataContext DBContext { get; set; }

        #endregion

        #region IRepository Members

        /// <summary>
        /// Note that gigs which are deleted will also be returned here
        /// </summary>
        /// <returns></returns>
        public IQueryable<ListenTo.Shared.DO.Gig> GetGigs()
        {
            return from g in DBContext.Gigs
                   let acts = GetActs(g.ID)
                   join venue in DBContext.Venues on g.VenueID equals venue.ID
                   select new ListenTo.Shared.DO.Gig
                   {
                       ID = g.ID,
                       Name = g.Name,
                       Acts = new List<ListenTo.Shared.DO.Act>(acts),
                       Description  = g.Description,
                       StartDate    = g.Date,
                       EndDate      = g.EndDate,
                       //Temporary hack - the delete method of a venue should really logically delete all associated gigs
                       //REMOVE THIS
                       IsDeleted    = venue.IsDeleted ? true : g.IsDeleted,
                       Created      = g.Created,
                       TicketPrice  = g.TicketPrice,
                       Venue        =  new ListenTo.Shared.DO.Venue { 
                                        ID = venue.ID, 
                                        Name = venue.Name, 
                                        Address = venue.Address,
                                        Telephone = venue.Telephone,
                                        URL = venue.Website 
                       },
                       OwnerID =  g.UserID
                                       
                   };
        }

        /// <summary>
        /// Note that deleted gigs will not be returned from this method..
        /// </summary>
        /// <param name="nGigs"></param>
        /// <param name="siteId"></param>
        /// <param name="startDate"></param>
        /// <returns></returns>
        public IQueryable<ListenTo.Shared.DO.Gig> GetNRandomGigsBySiteAfterDate(int nGigs, Guid siteId, DateTime startDate)
        {
            //Select n Random Ids
            var qry = (from gig in DBContext.Gigs
                       join siteTown in DBContext.SiteTowns on gig.Venue.TownID equals siteTown.TownId
                       where siteTown.SiteId == siteId && gig.Date > startDate 
                       //We only care about gigs that are NOT logically deleted
                       && gig.IsDeleted==false
                       //The venue must also not be deleted
                       && gig.Venue.IsDeleted == false
                       orderby DBContext.Random()
                       select gig.ID).Take(nGigs); //1st round-trip

            return this.GetGigs().WithID(qry); // 2nd round-trip will occur when this statement is resolved
        }

        public IList<ListenTo.Shared.DO.Gig> GetGigsAtVenue(Guid venueId)
        {
            return this.GetGigs().AtVenue(venueId).ToList();
        }

        /// <summary>
        /// Currently I dont seem to be able to query the acts collection directly from GetGigs() using filters.
        /// This appears to be related to using the nested let acts = GetActs(g.id)
        /// Deleted gigs will not be returned here
        /// </summary>
        /// <param name="artistID"></param>
        /// <returns></returns>
        public IQueryable<ListenTo.Shared.DO.Gig> GetGigsByArtist(Guid artistID)
        {

            var gigIds = from a in DBContext.Acts
                         join gig in DBContext.Gigs on a.GigID equals gig.ID
                         join venue in DBContext.Venues on gig.VenueID equals venue.ID
                         where a.ArtistID == (Guid?)artistID && gig.IsDeleted == false && venue.IsDeleted == false
                         select a.GigID;


            //Note that GetGigs only returns gigs which arent logically deleted 
            //arent asssoicated with deleted venues
            return from g in GetGigs()
                   where gigIds.Contains(g.ID)
                   select g;
        }

        public IQueryable<ListenTo.Shared.DO.Comment> GetComments()
        {
            return from c in DBContext.Comments
                   orderby c.Created descending
                   select new ListenTo.Shared.DO.Comment
                   {
                       ID       = c.ID,
                       Body     = c.Body,
                       Created  = c.Created,
                       TargetId = c.TargetListenToTypeID,
                       OwnerID  = c.UserID
                   };
        }

        public IQueryable<ListenTo.Shared.DTO.CommentSummary> GetCommentSummaries()
        {
            return from c in DBContext.Comments
                   join user in DBContext.Users on c.UserID equals user.ID

                   join i in DBContext.Images on user.AvatarImageID equals i.ID into tempImages
                   from image in tempImages.DefaultIfEmpty()

                   join i2 in DBContext.Images on image.ThumbnailID equals i2.ID into tempImages2
                   from thumbnail in tempImages2.DefaultIfEmpty()

                   orderby c.Created descending
                   //join thumbnail in DBContext.Images on image.ThumbnailID equals thumbnail.ID
                   select new ListenTo.Shared.DTO.CommentSummary
                   {
                        ID = c.ID,
                        Body = c.Body,
                        OwnerId = user.ID,
                        OwnerUsername = user.Username,
                        OwnerThumbnail = image == null || thumbnail == null ? null : new ListenTo.Shared.DO.ImageMetaData
                        {
                            ID = thumbnail.ID,
                            Height = thumbnail.height,
                            Width = thumbnail.width
                        },
                        TargetId = c.TargetListenToTypeID,
                        Created = c.Created
                   };

        }


        public ListenTo.Shared.DO.Comment SaveComment(ListenTo.Shared.DO.Comment comment)
        {
            ListenTo.Data.LinqToSQL.Comment dbComment = DBContext.Comments.Where(x => x.ID == comment.ID).SingleOrDefault();

            if (dbComment == null)
            {
                dbComment = new ListenTo.Data.LinqToSQL.Comment();
                dbComment.ID = comment.ID;
                dbComment.Created = DateTime.Now;
                DBContext.Comments.InsertOnSubmit(dbComment);
            }

            dbComment.Body = comment.Body;
            dbComment.TargetListenToTypeID = comment.TargetId;
            dbComment.ContentType = (int)comment.ContentType;
            dbComment.UserID = comment.OwnerID;
            DBContext.SubmitChanges();
            return comment;
        }

        public IQueryable<ListenTo.Shared.DO.Act> GetActs()
        {
            return from a in DBContext.Acts
                   let artist = GetArtist(a.ArtistID.GetValueOrDefault())
                   select new ListenTo.Shared.DO.Act
                   {
                        ID = a.ID,
                        Name = a.Name,
                        Artist = artist,
                        GigId = a.GigID

                   };
        }

        IQueryable<ListenTo.Shared.DO.Act> GetActs(Guid gigId)
        {
            return GetActs().WithGigID(gigId);
        }

        /// <summary>
        /// Note that this method WILL return venues which have been deleted!
        /// </summary>
        /// <returns></returns>
        public IQueryable<ListenTo.Shared.DO.Venue> GetVenues()
        {
            return from v in DBContext.Venues
                   let town = GetTown(v.TownID)
                   select new ListenTo.Shared.DO.Venue
                   {
                       ID           = v.ID,
                       Name         = v.Name,
                       Address      = v.Address,
                       Telephone    = v.Telephone,
                       URL          = v.Website,
                       Town         = town,
                       IsDeleted    = v.IsDeleted
                      // Created     = v.Created.GetValueOrDefault()
                       
                   };
        }

        ListenTo.Shared.DO.Venue GetVenue(Guid venueId)
        {
            return GetVenues().WithID(venueId).Single();
        }

        public IQueryable<ListenTo.Shared.DO.Artist> GetArtists()
        {
            return from a in DBContext.Artists
                   //join Town in DBContext.Towns on v.TownID equals Town.
                   //join style in DBContext.Styles on a.StyleID equals style.ID
                   let style = GetStyle(a.StyleID)
                   let town = GetTown(a.TownID)
                   let image = GetImageMetaData(a.LogoImageID.GetValueOrDefault())
                   orderby a.Name 
                   select new ListenTo.Shared.DO.Artist
                   {
                       ID = a.ID,
                       Name = a.Name,
                       Created = a.Created,
                       Profile = a.Profile,
                       Style = style,
                       OfficalWebsiteURL = a.OfficalWebsiteURL,
                       ProfileAddress= a.ProfileAddress,
                       Town = town,
                       ProfileImage = image,
                       OwnerID = a.UserID,
                       Formed = a.Formed.GetValueOrDefault(),
                       Email = a.EmailAddress
                      
                   };
        }

        public IPageOfList<ListenTo.Shared.DO.Artist> GetArtistsByStyle(int pageSize, int currentPageIndex, Guid styleId)
        {
            return this.GetArtists().WithStyle(styleId).ToPageOfList(currentPageIndex, pageSize);  
        }


        public IQueryable<ListenTo.Shared.DO.Artist> GetArtistsByOwner(Guid ownerId)
        {
            return this.GetArtists().WithOwner(ownerId);
        }

        /// <summary>
        /// Returns the number of Artists
        /// </summary>
        /// <returns></returns>
        public int GetNumberOfArtists()
        {
            var qry = (from artist in DBContext.Artists
                       select artist);

            int count = qry.Count(); 
            return count;
        }

        /// <summary>
        /// Returns the number of Artists
        /// </summary>
        /// <returns></returns>
        public int GetNumberOfArtistsBySite(Guid siteId)
        {
            var qry = (from artist in DBContext.Artists
                       join siteTown in DBContext.SiteTowns on artist.TownID equals siteTown.TownId
                       where siteTown.SiteId == siteId
                       select artist);

            int count = qry.Count();
            return count;
        }


        private ListenTo.Shared.DO.Artist GetArtist(Guid artistId)
        {
            return this.GetArtists().WithID(artistId).SingleOrDefault();
        }


        public IQueryable<ListenTo.Shared.DO.Artist> GetNRandomArtists(int numberOfArtists)
        {
            //Select n Random Ids
            var qry = (from artist in DBContext.Artists
                       orderby DBContext.Random()
                       select artist.ID).Take(numberOfArtists); //1st round-trip

            return this.GetArtists().WithID(qry); // 2nd round-trip will occur when this statement is resolved
        }


        public IQueryable<ListenTo.Shared.DO.Artist> GetNRandomArtistsBySite(Guid siteId, int numberOfArtists)
        {
            //Select n Random Ids
            var qry = (from artist in DBContext.Artists
                       join siteTown in DBContext.SiteTowns on artist.TownID equals siteTown.TownId
                      where siteTown.SiteId == siteId
                      orderby DBContext.Random()
                      select artist.ID).Take(numberOfArtists); //1st round-trip

            return this.GetArtists().WithID(qry); // 2nd round-trip will occur when this statement is resolved
        }


        public IList<ArtistSummary> GetNRandomArtistSummaries(int numberOfArtists)
        {
            //Select n Random Ids
            var qry = (from artist in DBContext.Artists
                       orderby DBContext.Random()
                       select artist.ID).Take(numberOfArtists); //1st round-trip

            return this.GetArtistSummaries().WithID(qry).ToList(); // 2nd round-trip will occur when this statement is resolved

        }

        public IList<ArtistSummary> GetNRandomArtistSummariesBySite(Guid siteId, int numberOfArtists)
        {
            //Select n Random Ids
            var qry = (from artist in DBContext.Artists
                       join town in DBContext.Towns on artist.TownID equals town.ID
                       join siteTowns in DBContext.SiteTowns on town.ID equals siteTowns.TownId 
                       where siteTowns.SiteId == siteId
                       orderby DBContext.Random()
                       select artist.ID).Take(numberOfArtists); //1st round-trip

            return this.GetArtistSummaries().WithID(qry).ToList(); // 2nd round-trip will occur when this statement is resolved

        }

        private IQueryable<ListenTo.Shared.DTO.ArtistSummary> GetArtistSummaries()
        {
            return from artist in DBContext.Artists
                   join user in DBContext.Users on artist.UserID equals user.ID
                   join style in DBContext.Styles on artist.StyleID equals style.ID
                   join town in DBContext.Towns on artist.TownID equals town.ID
                   join siteTowns in DBContext.SiteTowns on town.ID equals siteTowns.TownId 
                   join i in DBContext.Images on artist.LogoImageID equals i.ID into tempImages
                   from image in tempImages.DefaultIfEmpty()
                   join i2 in DBContext.Images on image.ThumbnailID equals i2.ID into tempImages2
                   from thumbnail in tempImages2.DefaultIfEmpty()
           
                   //join thumbnail in DBContext.Images on image.ThumbnailID equals thumbnail.ID
                   orderby artist.Name 
                   select new ListenTo.Shared.DTO.ArtistSummary
                   {
                       ID = artist.ID,
                       Name = artist.Name,
                       OwnerID = user.ID,
                       OwnerUsername = user.Username,
                       Thumbnail = image == null || thumbnail == null ? null : new ListenTo.Shared.DO.ImageMetaData
                       {
                           ID = thumbnail.ID,
                           Height = thumbnail.height,
                           Width = thumbnail.width
                       },
                       Created = artist.Created,
                       StyleID = style.ID,
                       StyleName = style.Name,
                       TownName = town.Name,
                       SiteId = siteTowns.SiteId,
                       ProfileAddress = artist.ProfileAddress
                   };

        }
     
        public int GetNumberOfArtistsOwnedBy(Guid ownerId)
        {
            var qry = from artists in DBContext.Artists
                   where artists.UserID == ownerId
                   select artists.ID;
            int count = qry.Count();
            return count;
        }
        
        public ListenTo.Shared.Utility.IPageOfList<ListenTo.Shared.DTO.ArtistSummary> GetArtistSummariesBySiteAndStyle(int pageSize, int currentPageIndex, Guid siteId, Guid styleId)
        {
            return this.GetArtistSummaries().WithStyleId(styleId).WithSiteId(siteId).ToPageOfList(currentPageIndex, pageSize);
        }

        public ListenTo.Shared.Utility.IPageOfList<ListenTo.Shared.DTO.ArtistSummary> GetArtistSummariesBySite(int pageSize, int currentPageIndex, Guid siteId)
        {
            return this.GetArtistSummaries().WithSiteId(siteId).ToPageOfList(currentPageIndex, pageSize);
        }

        public ListenTo.Shared.Utility.IPageOfList<ListenTo.Shared.DTO.ArtistSummary> GetArtistSummariesByOwner(int pageSize, int currentPageIndex, Guid ownerId)
        {
            return this.GetArtistSummaries().WithOwnerId(ownerId).ToPageOfList(currentPageIndex, pageSize);
        }

        public ListenTo.Shared.DO.Gig SaveGig(ListenTo.Shared.DO.Gig gig)
        {
                ListenTo.Data.LinqToSQL.Gig dbGig = DBContext.Gigs.Where(x => x.ID == gig.ID).SingleOrDefault();

                if (dbGig == null)
                {
                    dbGig = new ListenTo.Data.LinqToSQL.Gig();
                    dbGig.ID = gig.ID;
                    dbGig.Created = DateTime.Now;
                    DBContext.Gigs.InsertOnSubmit(dbGig);
                }

                dbGig.Name          = gig.Name;
                dbGig.TicketPrice   = gig.TicketPrice;
                dbGig.Date          = gig.StartDate;
                dbGig.Description   = gig.Description;
                dbGig.VenueID       = gig.Venue.ID;
                dbGig.UserID        = gig.OwnerID;
                dbGig.IsDeleted = gig.IsDeleted;
                //ManageVenue(gig.Venue);

                //Remove all references to the current acts
                if(dbGig.Acts!=null) {
                    DBContext.Acts.DeleteAllOnSubmit(dbGig.Acts);
                }

                dbGig.Acts.AddRange(ManageActs(gig.Acts));

                DBContext.SubmitChanges();
                //DBContext.Refresh(System.Data.Linq.RefreshMode.OverwriteCurrentValues);
          
                return gig;
        }

        private IList<ListenTo.Data.LinqToSQL.Act> ManageActs(IList<ListenTo.Shared.DO.Act> acts)
        {
            List<ListenTo.Data.LinqToSQL.Act> dbActs = new List<ListenTo.Data.LinqToSQL.Act>(); 

            foreach (ListenTo.Shared.DO.Act act in acts)
            {
                dbActs.Add(ManageAct(act));
            }

            return dbActs;
        }

        private ListenTo.Data.LinqToSQL.Act ManageAct(ListenTo.Shared.DO.Act act)
        {
            ListenTo.Data.LinqToSQL.Act dbAct = DBContext.Acts.Where(x => x.ID == act.ID).SingleOrDefault();

            if (dbAct == null)
            {
                dbAct = new ListenTo.Data.LinqToSQL.Act();
                dbAct.ID = act.ID;
                //dbAct.Created = DateTime.Now;
                DBContext.Acts.InsertOnSubmit(dbAct);
            }

            dbAct.Name = act.Name;
            dbAct.GigID = act.GigId;
           
            if (act.Artist!=null)
            {
                dbAct.ArtistID = act.Artist.ID;
            }

            return dbAct;
        }

        private ListenTo.Shared.DO.Venue ManageVenue(ListenTo.Shared.DO.Venue venue)
        {
            ListenTo.Data.LinqToSQL.Venue dbVenue = DBContext.Venues.Where(x => x.ID == venue.ID).SingleOrDefault();
            
            if (dbVenue == null)
            {
                dbVenue = new ListenTo.Data.LinqToSQL.Venue();
                dbVenue.ID = venue.ID;
                dbVenue.Created = DateTime.Now;
                DBContext.Venues.InsertOnSubmit(dbVenue);
            }

            dbVenue.IsDeleted = venue.IsDeleted; 
            dbVenue.Name = venue.Name;

            return venue;
        }

        public ListenTo.Shared.DO.Venue SaveVenue(ListenTo.Shared.DO.Venue venue)
        {
            venue = ManageVenue(venue);
            DBContext.SubmitChanges();
            return venue;
        }

        public IQueryable<ListenTo.Shared.DO.UserProfile> GetUserProfiles()
        {
            return from u in DBContext.Users
                   let usersPreferredStyles = GetUsersPreferredStyles(u.ID)
                   let image = GetImageMetaData(u.AvatarImageID.GetValueOrDefault())
                   let town = GetTown(u.TownID.GetValueOrDefault())
                   select new ListenTo.Shared.DO.UserProfile
                   {
                       ID = u.ID,
                       Username = u.Username,
                       Forename = u.Forename,
                       Surname = u.Surname,
                       Styles = new LazyList<ListenTo.Shared.DO.Style>(usersPreferredStyles),
                       RecievesNewsletter = u.RecievesNewsletter.GetValueOrDefault(false),
                       Profile = u.Profile,
                       ProfileImage = image,
                       Town = town,
                       OwnerID = u.ID,
                       Created = u.Created.GetValueOrDefault(),
                       Email = u.EmailAddress
                   };
        }

        public ListenTo.Shared.DO.UserProfile GetUserProfile(Guid id)
        {
            return GetUserProfiles().WithID(id).SingleOrDefault();
        }

        public ListenTo.Shared.DO.UserProfile GetUserProfileByUsername(string username)
        {
            return GetUserProfiles().WithUsername(username).SingleOrDefault();
        }

        public IQueryable<ListenTo.Shared.DO.Style> GetStyles()
        {
            return from s in DBContext.Styles
                   orderby s.Name 
                   select new ListenTo.Shared.DO.Style
                   {
                       ID = s.ID,
                       Name = s.Name
                   };
        }

        public ListenTo.Shared.DO.Style GetStyleWithName(string name)
        {
            return GetStyles().WithName(name).SingleOrDefault();
        }

        public IList<ListenTo.Shared.DTO.StyleSummary> GetStyleSummaries(Guid siteId)
        {

            var qry = from s in DBContext.Styles
                      join artist in DBContext.Artists on s.ID equals artist.StyleID into a
                      join track in DBContext.Tracks on s.ID equals track.StyleID into t
                      orderby s.Name
                      select new ListenTo.Shared.DTO.StyleSummary
                      {
                          ID = s.ID,
                          Name = s.Name,
                          NumberOfArtists = a.Count(),
                          NumberOfTracks = t.Count()
                      };


            return qry.ToList();
        }

        private ListenTo.Shared.DO.Style GetStyle(Guid styleId)
        {
            return this.GetStyles().WithID(styleId).SingleOrDefault();
        }


        private IQueryable<ListenTo.Shared.DO.Style> GetUsersPreferredStyles(Guid userId)
        {
            return from s in DBContext.UsersPreferredStyles
                   join styles in DBContext.Styles on s.StyleID equals styles.ID
                   where s.UserID == userId
                   select new ListenTo.Shared.DO.Style
                   {
                       ID = styles.ID,
                       Name = styles.Name
                   };
       
        }

        public ListenTo.Shared.DO.UserProfile SaveUserProfile(ListenTo.Shared.DO.UserProfile userProfile)
        {
            Guid userId = userProfile.ID;

            ListenTo.Data.LinqToSQL.User dbUser = DBContext.Users.Where(x => x.ID == userProfile.ID).SingleOrDefault();

            if (dbUser == null)
            {
                throw new Exception("UserProfile cannot be saved since parent user does not exist");
            }

            dbUser.Forename = userProfile.Forename;
            dbUser.Surname = userProfile.Surname;
            dbUser.RecievesNewsletter = userProfile.RecievesNewsletter;
            dbUser.Profile = userProfile.Profile;

            if (userProfile.ProfileImage!=null)
            {
                dbUser.AvatarImageID = userProfile.ProfileImage.ID;
            }
            else
            {
                dbUser.AvatarImageID = null;
            }

            //Remove existing user styles
            IQueryable<ListenTo.Data.LinqToSQL.UsersPreferredStyle> userPreferredStyles = DBContext.UsersPreferredStyles.Where(x => x.UserID == userProfile.ID);
            DBContext.UsersPreferredStyles.DeleteAllOnSubmit(userPreferredStyles);

            //Adapt new styles
            IList<UsersPreferredStyle> prefStyles = new List<UsersPreferredStyle>();
            foreach(ListenTo.Shared.DO.Style s in userProfile.Styles){
                UsersPreferredStyle prefStyle = new UsersPreferredStyle();
                prefStyle.StyleID = s.ID;
                prefStyle.UserID = userId;
                prefStyles.Add(prefStyle);
            }

            DBContext.UsersPreferredStyles.InsertAllOnSubmit(prefStyles);

            DBContext.SubmitChanges();

            return userProfile;
        }

        public IQueryable<ListenTo.Shared.DO.User> GetUsers()
        {
            IQueryable<User> users = DBContext.Users;
            return new Adapters.UserAdapters().Adapt(users);
        }


        public ListenTo.Shared.DO.User SaveUser(ListenTo.Shared.DO.User user)
        {
            Guid id = user.ID;

            ListenTo.Data.LinqToSQL.User dbUser = DBContext.Users.Where(x => x.ID == id).SingleOrDefault();

            if (dbUser == null)
            {
                dbUser = new ListenTo.Data.LinqToSQL.User();
                dbUser.ID = id;
                DBContext.Users.InsertOnSubmit(dbUser);
            }

            dbUser.Username = user.Username;
            dbUser.Password = user.Password;
            dbUser.EmailAddress = user.EmailAddress;
            dbUser.IsUserValidated = user.IsValidated;
            dbUser.Created = user.Created;

            DBContext.SubmitChanges();

            return user;
        }

        public ListenTo.Shared.DO.ImageMetaData SaveImageMetaData(ListenTo.Shared.DO.ImageMetaData imageMetaData)
        {
            Guid id = imageMetaData.ID;

            ListenTo.Data.LinqToSQL.Image dbImage = DBContext.Images.Where(x => x.ID == id).SingleOrDefault();

            if (dbImage==null)
            {
                dbImage = new ListenTo.Data.LinqToSQL.Image();
                dbImage.ID = id;
                DBContext.Images.InsertOnSubmit(dbImage);
            }

            if (imageMetaData.Thumbnail != null)
            {
                //Persist the Thumbnail
                SaveImageMetaData(imageMetaData.Thumbnail);
                dbImage.ThumbnailID = imageMetaData.Thumbnail.ID;
            }

            dbImage.width = imageMetaData.Width;
            dbImage.height = imageMetaData.Height;

            DBContext.SubmitChanges();

            return imageMetaData;
        }

        public IQueryable<ListenTo.Shared.DO.ImageMetaData> GetImageMetaDatas()
        {
            return from images in DBContext.Images
                   let thumb = GetImageMetaData(images.ThumbnailID.GetValueOrDefault())
                   select new ListenTo.Shared.DO.ImageMetaData
                   {
                       ID = images.ID,
                       Width = images.width,
                       Height = images.height,
                       Thumbnail = thumb
                   };
        }

        public ListenTo.Shared.DO.ImageMetaData GetImageMetaData(Guid id)
        {
            return this.GetImageMetaDatas().WithID(id).SingleOrDefault();
        }

        public void DeleteImageMetaData(Guid id)
        {
            ListenTo.Data.LinqToSQL.Image dbImage = DBContext.Images.Where(x => x.ID == id).SingleOrDefault();
            if (dbImage!=null)
            {
                DBContext.Images.DeleteOnSubmit(dbImage);
            }

        }

        public ListenTo.Shared.DO.Artist SaveArtist(ListenTo.Shared.DO.Artist artist)
        {
            ListenTo.Data.LinqToSQL.Artist dbArtist = DBContext.Artists.Where(x => x.ID == artist.ID).SingleOrDefault();

            if (dbArtist == null)
            {
                dbArtist = new ListenTo.Data.LinqToSQL.Artist();

                dbArtist.ID = artist.ID;
                dbArtist.Created = DateTime.Now;
                DBContext.Artists.InsertOnSubmit(dbArtist);
            }

            dbArtist.Name = artist.Name;

            if (artist.ProfileImage != null)
            {
                //Check that the image actually exists
                dbArtist.LogoImageID = artist.ProfileImage.ID;
            }
            else
            {
                dbArtist.LogoImageID = null;
            }

            if (artist.Style != null)
            {
                dbArtist.StyleID = artist.Style.ID;
            }

            if (artist.Town != null)
            {
                dbArtist.TownID = artist.Town.ID;
            }

            dbArtist.Name = artist.Name;
            dbArtist.Profile = artist.Profile;
            dbArtist.ProfileAddress = artist.ProfileAddress;
            dbArtist.EmailAddress = artist.Email;
            dbArtist.OfficalWebsiteURL = artist.OfficalWebsiteURL;
            dbArtist.UserID = artist.OwnerID;
            dbArtist.Formed = artist.Formed;
            DBContext.SubmitChanges();
          
            return artist;
        }

        public IQueryable<ListenTo.Shared.DO.Town> GetTowns()
        {
            return from t in DBContext.Towns
                   let sites = GetSitesByTownID(t.ID)
                   select new ListenTo.Shared.DO.Town
                   {
                       ID = t.ID,
                       Name = t.Name,
                       Sites = new List<ListenTo.Shared.DO.Site>(sites),
                       IsDeleted = t.IsDeleted
                   };
        }

        public ListenTo.Shared.DO.Town GetTown(Guid id)
        {
            return GetTowns().WithID(id).SingleOrDefault();
        }

        public IQueryable<ListenTo.Shared.DTO.TrackSummary> GetTrackSummaries()
        {
            return this.GetTrackSummaries(true);
        }

        public IQueryable<ListenTo.Shared.DTO.TrackSummary> GetTrackSummaries(bool orderByCreated)
        {
            var qry = from t in DBContext.Tracks

                   join artist in DBContext.Artists on t.ArtistID equals artist.ID

                   join siteTown in DBContext.SiteTowns on artist.TownID equals siteTown.TownId

                   join user in DBContext.Users on t.UserID equals user.ID
                   join style in DBContext.Styles on t.StyleID equals style.ID

                   join i in DBContext.Images on artist.LogoImageID equals i.ID into tempImages
                   from image in tempImages.DefaultIfEmpty()

                   join i2 in DBContext.Images on image.ThumbnailID equals i2.ID into tempImages2
                   from thumbnail in tempImages2.DefaultIfEmpty()
                   //orderby t.created descending
                   //join thumbnail in DBContext.Images on image.ThumbnailID equals thumbnail.ID
                   
                   select new ListenTo.Shared.DTO.TrackSummary
                   {
                       ID = t.ID,
                       ArtistId = artist.ID,
                       ArtistName = artist.Name,
                       ArtistProfileAddress = artist.ProfileAddress,
                       Name = t.Title,
                       Description = t.Description,
                       StyleId =  style.ID,
                       StyleName = style.Name,
                       SiteId = siteTown.SiteId,
                       OwnerID = user.ID,
                       OwnerUsername = user.Username,
                       ArtistThumbnail = image == null || thumbnail == null ? null : new ListenTo.Shared.DO.ImageMetaData
                       {
                           ID = thumbnail.ID,
                           Height = thumbnail.height,
                           Width = thumbnail.width
                       },
                        Created = t.created.GetValueOrDefault()
                      
                   };

            if(orderByCreated) {
                qry = qry.OrderBy(t => t.Name);
            }

            return qry;
        }

        public IQueryable<ListenTo.Shared.DTO.TrackSummary> GetTrackSummariesBySite(Guid siteId)
        {
            return this.GetTrackSummaries().WithSiteID(siteId);
        }

        public IQueryable<ListenTo.Shared.DTO.TrackSummary> GetTrackSummariesByArtist(Guid artistId)
        {
            return this.GetTrackSummaries().WithArtistID(artistId);
        }

        public ListenTo.Shared.Utility.IPageOfList<ListenTo.Shared.DTO.TrackSummary> GetTrackSummariesBySiteAndStyle(int pageSize, int currentPageIndex, Guid siteId, Guid styleId)
        {
            return this.GetTrackSummaries().WithSiteID(siteId).WithStyleID(styleId).ToPageOfList(currentPageIndex, pageSize);
        }

        public IList<ListenTo.Shared.DTO.TrackSummary> GetNRandomlyOrderedTrackSummariesBySiteAndStylesAndArtists(int num, Guid siteId, IList<Guid> styleIds, IList<Guid> artistIds)
        {
            List<Guid> styleIdList = null;
            List<Guid> artistIdList = null;

            IQueryable<Guid> qry;

            if (styleIds != null)
            {
                styleIdList = styleIds.ToList();
            }

            if (artistIds != null)
            {
                artistIdList = artistIds.ToList();
            }

            if (styleIdList != null && artistIdList != null)
            {
                 qry = (from track in DBContext.Tracks
                           join artist in DBContext.Artists on track.ArtistID equals artist.ID
                           join siteTown in DBContext.SiteTowns on artist.TownID equals siteTown.TownId
                           join style in DBContext.Styles on track.StyleID equals style.ID
                           where siteTown.SiteId == siteId &&
                           artistIdList.Contains(artist.ID) &&
                           styleIdList.Contains(style.ID)
                           orderby DBContext.Random()
                           select track.ID).Take(num);
            }
            else if (styleIdList != null)
            {
                 qry = (from track in DBContext.Tracks
                           join artist in DBContext.Artists on track.ArtistID equals artist.ID
                           join siteTown in DBContext.SiteTowns on artist.TownID equals siteTown.TownId
                           join style in DBContext.Styles on track.StyleID equals style.ID
                           where siteTown.SiteId == siteId &&
                           styleIdList.Contains(style.ID)
                           orderby DBContext.Random()
                           select track.ID).Take(num);
            }
            else if (artistIdList != null)
            {
                qry = (from track in DBContext.Tracks
                       join artist in DBContext.Artists on track.ArtistID equals artist.ID
                       join siteTown in DBContext.SiteTowns on artist.TownID equals siteTown.TownId
                       join style in DBContext.Styles on track.StyleID equals style.ID
                       where siteTown.SiteId == siteId &&
                       artistIdList.Contains(artist.ID)
                       orderby DBContext.Random()
                       select track.ID).Take(num);
            }
            else
            {
                qry = (from track in DBContext.Tracks
                       join artist in DBContext.Artists on track.ArtistID equals artist.ID
                       join siteTown in DBContext.SiteTowns on artist.TownID equals siteTown.TownId
                       join style in DBContext.Styles on track.StyleID equals style.ID
                       where siteTown.SiteId == siteId 
                       orderby DBContext.Random()
                       select track.ID).Take(num);
            }


            //Note that the first query is resolved before the 2nd is executed
            //This is because the first request contains "locally created collections"
            //The distinct statement is called after the 2nd request is resolved since the comparer cannot be resolved into sql.
            return this.GetTrackSummaries(false).WithID(qry.ToList()).ToList().Distinct(new TrackSummaryEqualityComparer()).ToList();

        }


        public ListenTo.Shared.Utility.IPageOfList<ListenTo.Shared.DTO.TrackSummary> GetTrackSummariesBySiteAndStylesAndArtists(int pageSize, int currentPageIndex, Guid siteId, IList<Guid> styleIds, IList<Guid> artistIds)
        {
            IQueryable<TrackSummary> trackSummaries =  this.GetTrackSummaries().WithSiteID(siteId);

            if (artistIds!=null && artistIds.Count > 0)
            {
                trackSummaries = trackSummaries.WithArtistID(artistIds);
            }

            if (styleIds!=null && styleIds.Count > 0)
            {
                trackSummaries = trackSummaries.WithStyleID(styleIds);
            }

            return trackSummaries.ToPageOfList(currentPageIndex, pageSize);
        }


        public IQueryable<ListenTo.Shared.DO.TrackMetaData> GetTrackMetaDatas()
        {
            return from t in DBContext.Tracks
                   let style = GetStyle(t.StyleID)
                   let artist = GetArtist(t.ArtistID.GetValueOrDefault())
                   select new ListenTo.Shared.DO.TrackMetaData
                   {
                       ID = t.ID,
                       Name = t.Title,
                       OwnerID = t.UserID,
                       Style = style,
                       Artist = artist,
                       Studio = t.Studio,
                       Engineer = t.Engineer,
                       Producer = t.Producer,
                       Description = t.Description
                        
                   };
        }

        public ListenTo.Shared.DO.TrackMetaData SaveTrackMetaData(ListenTo.Shared.DO.TrackMetaData trackMetaData)
        {
            Guid id = trackMetaData.ID;

            ListenTo.Data.LinqToSQL.Track dbTrack = DBContext.Tracks.Where(x => x.ID == id).SingleOrDefault();

            if (dbTrack == null)
            {
                dbTrack = new ListenTo.Data.LinqToSQL.Track();
                dbTrack.ID = id;
                DBContext.Tracks.InsertOnSubmit(dbTrack);
            }

            if (trackMetaData.Artist != null)
            {
                dbTrack.ArtistID = trackMetaData.Artist.ID;
            }

            if (trackMetaData.Style != null)
            {
                dbTrack.StyleID = trackMetaData.Style.ID;
            }

            dbTrack.Title = trackMetaData.Name;
            dbTrack.Description = trackMetaData.Description;
            dbTrack.Producer = trackMetaData.Producer;
            dbTrack.Engineer = trackMetaData.Engineer;
            dbTrack.Studio = trackMetaData.Studio;
            dbTrack.UserID = trackMetaData.OwnerID;
            dbTrack.created = trackMetaData.Created;
            DBContext.SubmitChanges();

            return trackMetaData;
        }


        public IQueryable<ListenTo.Shared.DO.Site> GetSites()
        {
            return from s in DBContext.Sites
                   
                   select new ListenTo.Shared.DO.Site
                   {
                       ID = s.ID,
                       Description = s.Description,
                       URL = s.URL
                   };
        }

        private IQueryable<ListenTo.Shared.DO.Site> GetSitesByTownID(Guid townId)
        {
            //Select n Random Ids
            var qry = (from siteTowns in DBContext.SiteTowns
                       where siteTowns.TownId == townId
                       select siteTowns.SiteId); //1st round-trip

            return this.GetSites().WithID(qry);
        }


        public ListenTo.Shared.DO.Site GetSiteByURL(string url)
        {
            return this.GetSites().WithURL(url).SingleOrDefault();
        }

        private IQueryable<ListenTo.Shared.DO.Site> GetSitesByNewsItem(Guid newsItemId)
        {
            //Select n Random Ids
            var qry = (from site in DBContext.Sites
                       join articleSite in DBContext.ArticlesTargetSites on site.ID equals articleSite.SiteID
                       where articleSite.ArticleID == newsItemId
                       select site.ID); //1st round-trip

            return this.GetSites().WithID(qry);
        }


        public IQueryable<ListenTo.Shared.DO.NewsItem> GetNewsItems()
        {
            return from article in DBContext.Articles

                   let sites = GetSitesByNewsItem(article.ID)
                   let image = GetImageMetaData(article.ImageID.GetValueOrDefault())
                   select new ListenTo.Shared.DO.NewsItem
                   {
                       ID = article.ID,
                       Description = article.Description,
                       Name = article.Name,
                       Body = article.Body,
                       Created = article.Created,
                       OwnerID = article.UserID,
                       IsPublished = article.IsPublished.GetValueOrDefault(),
                       TargetSites = new List<ListenTo.Shared.DO.Site>(sites),
                       Image = GetImageMetaData(article.ImageID.GetValueOrDefault()),
                       ResourceURL = article.ResourceURL,
                       IsDeleted = article.IsDeleted
                   };
        }

        /// <summary>
        /// This summary object will only return newsitems which have NOT been deleted
        /// </summary>
        /// <returns></returns>
        public IQueryable<ListenTo.Shared.DTO.NewsItemSummary> GetNewsItemSummary()
        {
            return from article in DBContext.Articles
                   join user in DBContext.Users on article.UserID equals user.ID

                   join i in DBContext.Images on article.ImageID equals i.ID into tempImages
                   from image in tempImages.DefaultIfEmpty()

                   join i2 in DBContext.Images on image.ThumbnailID equals i2.ID into tempImages2
                   from thumbnail in tempImages2.DefaultIfEmpty()
                   //Note that only articles which have not been deleted are returned!
                   where article.IsDeleted==false
                   orderby article.Created descending
                   //join thumbnail in DBContext.Images on image.ThumbnailID equals thumbnail.ID
                   select new ListenTo.Shared.DTO.NewsItemSummary
                   {
                       ID = article.ID,
                       Name = article.Name,
                       Description = article.Description,
                       OwnerID = user.ID,
                       OwnerUsername = user.Username,
                       Thumbnail = image == null || thumbnail == null ? null : new ListenTo.Shared.DO.ImageMetaData
                       {
                           ID = thumbnail.ID,
                           Height = thumbnail.height,
                           Width = thumbnail.width
                       },
                       Created = article.Created,
                       IsPublished = article.IsPublished.GetValueOrDefault()
                   };

        }

        public IQueryable<NewsItemSummary> GetNewsItemSummaryBySite(Guid siteId)
        {
            //Select article ids 
            var qry = (from site in DBContext.Sites
                       join articleSite in DBContext.ArticlesTargetSites on site.ID equals articleSite.SiteID
                       where articleSite.SiteID == siteId
                       select articleSite.ArticleID); //1st round-trip

            return this.GetNewsItemSummary().WithID(qry);
        }

        public ListenTo.Shared.Utility.IPageOfList<ListenTo.Shared.DTO.NewsItemSummary> GetNewsItemSummaryBySite(int pageSize, int currentPageIndex, Guid siteId)
        {
            return GetNewsItemSummaryBySite(siteId).ToPageOfList(currentPageIndex, pageSize);
        }
        
        public IQueryable<ListenTo.Shared.DTO.NewsItemSummary> GetPublishedNewsItemSummaryBySite(Guid siteId)
        {
            return this.GetNewsItemSummaryBySite(siteId).IsPublished();
        }

        public ListenTo.Shared.Utility.IPageOfList<ListenTo.Shared.DTO.NewsItemSummary> GetPublishedNewsItemSummaryBySite(int pageSize, int currentPageIndex, Guid siteId)
        {
            return GetPublishedNewsItemSummaryBySite(siteId).ToPageOfList(currentPageIndex, pageSize);
        }

        public IList<ListenTo.Shared.DTO.NewsItemSummary> GetPublishedNewsItemSummaryByIds(IList<Guid> ids)
        {
            return GetNewsItemSummary().IsPublished().WithID(ids.AsQueryable<Guid>()).ToList();
        }

        public IPageOfList<ListenTo.Shared.DTO.NewsItemSummary> GetNewsItemSummariesByOwner(int pageSize, int currentPageIndex, Guid userId)
        {
            return this.GetNewsItemSummary().WithOwnerID(userId).ToPageOfList(currentPageIndex, pageSize);
        }
        
        public NewsItem GetNewsItemById(Guid id)
        {
            return GetNewsItems().WithID(id).SingleOrDefault();
        }

        public ListenTo.Shared.DO.NewsItem SaveNewsItem(ListenTo.Shared.DO.NewsItem newsItem)
        {
            ListenTo.Data.LinqToSQL.Article dbArticle = DBContext.Articles.Where(x => x.ID == newsItem.ID).SingleOrDefault();

            if (dbArticle == null)
            {
                dbArticle = new ListenTo.Data.LinqToSQL.Article();
                dbArticle.ID = newsItem.ID;
                dbArticle.Created = DateTime.Now;
                DBContext.Articles.InsertOnSubmit(dbArticle);
            }

            dbArticle.Name = newsItem.Name;
            dbArticle.Description = newsItem.Description;
            dbArticle.Body = newsItem.Body;
            dbArticle.IsPublished = newsItem.IsPublished;
            dbArticle.UserID = newsItem.OwnerID;
            dbArticle.ResourceURL = newsItem.ResourceURL;

            if (newsItem.Image != null)
            {
                //Check that the image actually exists
                dbArticle.ImageID = newsItem.Image.ID;
            }
            else
            {
                dbArticle.ImageID = null;
            }

            //Delete current associations...
            IList<ArticlesTargetSite> currentArticlesTargetSites = DBContext.ArticlesTargetSites.Where(x => x.ArticleID == newsItem.ID).ToList();
            DBContext.ArticlesTargetSites.DeleteAllOnSubmit(currentArticlesTargetSites);

            //Associate...
            foreach (ListenTo.Shared.DO.Site site in newsItem.TargetSites)
            {
                ArticlesTargetSite articlesTargetSite = new ListenTo.Data.LinqToSQL.ArticlesTargetSite();
                articlesTargetSite.ArticleID = newsItem.ID;
                articlesTargetSite.SiteID = site.ID;
                DBContext.ArticlesTargetSites.InsertOnSubmit(articlesTargetSite);
            }

            DBContext.SubmitChanges();

            return newsItem;
        }


        private IQueryable<WhatsNew> GetWhatsNewSummaries(int pageSize, int currentPageIndex, Guid siteId)
        {

            var qry = (from articles in DBContext.Articles
                       join articleSite in DBContext.ArticlesTargetSites on articles.ID equals articleSite.ArticleID
                       where articleSite.SiteID == siteId
                       select new WhatsNew { ContentID = articles.ID, ContentOwnerID = articles.UserID }).Union(from gigs in DBContext.Gigs
                                                                                         join siteTown in DBContext.SiteTowns on gigs.Venue.TownID equals siteTown.TownId
                                                                                         where siteTown.SiteId == siteId
                                                                                         select new WhatsNew { ContentID = gigs.ID, ContentOwnerID = gigs.UserID }).Union(from artists in DBContext.Artists
                                                                                                                select new WhatsNew { ContentID = artists.ID, ContentOwnerID = artists.UserID }).Union(from tracks in DBContext.Tracks
                                                                                                                                        join artist in DBContext.Artists on tracks.ArtistID equals artist.ID
                                                                                                                                        join artistSiteTown in DBContext.SiteTowns on artist.TownID equals artistSiteTown.TownId
                                                                                                                                        where artistSiteTown.SiteId == siteId
                                                                                                                                        select new WhatsNew { ContentID = tracks.ID, ContentOwnerID = tracks.UserID });
            return qry;


        }

        public ListenTo.Shared.Utility.IPageOfList<Guid> GetWhatsNewSummariesForSite(int pageSize, int currentPageIndex, Guid siteId)
        {
            return (from whatsNew in this.GetWhatsNewSummaries(pageSize, currentPageIndex, siteId)
                    select whatsNew.ContentID).ToPageOfList(currentPageIndex, pageSize);    
        }

        public ListenTo.Shared.Utility.IPageOfList<Guid> GetWhatsNewSummariesOwnedByUser(int pageSize, int currentPageIndex, Guid siteId, Guid userId)
        {
            return (from whatsNew in this.GetWhatsNewSummaries(pageSize, currentPageIndex, siteId)
                    where whatsNew.ContentOwnerID == userId
                    select whatsNew.ContentID ).ToPageOfList(currentPageIndex, pageSize);
        }

        public ListenTo.Shared.DO.Action SaveAction(ListenTo.Shared.DO.Action action)
        {
            ListenTo.Data.LinqToSQL.Action dbAction = DBContext.Actions.Where(x => x.ID == action.ID).SingleOrDefault();

            if (dbAction == null)
            {
                dbAction = new ListenTo.Data.LinqToSQL.Action();
                dbAction.ID = action.ID;
                dbAction.Created = DateTime.Now;
                DBContext.Actions.InsertOnSubmit(dbAction);
            }

            dbAction.ActionType = (int)action.ActionType;
            dbAction.ContentType = (int)action.ContentType;
            dbAction.ContentID = action.ContentID;

            dbAction.PropertyType = (int)action.PropertyType;
            dbAction.OldValue = action.OldValue;
            dbAction.NewValue = action.NewValue;

            dbAction.OwnerID = action.OwnerID;

            //Delete current associated artists......
            IList<LinqToSQL.ActionsArtist> currentActionsArtists = DBContext.ActionsArtists.Where(x => x.ActionID == action.ID).ToList();
            DBContext.ActionsArtists.DeleteAllOnSubmit(currentActionsArtists);

            //Associate... the current artists
            foreach (Guid artistId in action.AssociatedArtistIds)
            {
                ActionsArtist actionsArtist = new ListenTo.Data.LinqToSQL.ActionsArtist();
                actionsArtist.ActionID = action.ID;
                actionsArtist.ArtistID = artistId;
                DBContext.ActionsArtists.InsertOnSubmit(actionsArtist);
            }

            //Delete current associated sites......
            IList<LinqToSQL.ActionsTargetSite> currentActionsSites = DBContext.ActionsTargetSites.Where(x => x.ActionID == action.ID).ToList();
            DBContext.ActionsTargetSites.DeleteAllOnSubmit(currentActionsSites);

            //Associate... the current artists
            foreach (Guid siteId in action.TargetSites)
            {
                ActionsTargetSite actionsTargetSite = new ListenTo.Data.LinqToSQL.ActionsTargetSite();
                actionsTargetSite.ActionID = action.ID;
                actionsTargetSite.SiteID = siteId;
                DBContext.ActionsTargetSites.InsertOnSubmit(actionsTargetSite);
            }

            DBContext.SubmitChanges();

            return action;

        }

        #endregion

        #region IRepository Members


        public IQueryable<Guid> GetActionsArtists(Guid actionId) {

            return from actionsArtists in DBContext.ActionsArtists
                   where actionsArtists.ActionID == actionId
                   select actionsArtists.ArtistID;
        }

        public IQueryable<Guid> GetActionsSites(Guid actionId)
        {
            return from actionsTargetSites in DBContext.ActionsTargetSites
                   where actionsTargetSites.ActionID == actionId
                   select actionsTargetSites.SiteID;
        }


        public IQueryable<ListenTo.Shared.DO.Action> GetActions()
        {

            return from action in DBContext.Actions

                   let associatedArtists = GetActionsArtists(action.ID)
                   let targetSites = GetActionsSites(action.ID)
                   join user in DBContext.Users on action.OwnerID equals user.ID
                   orderby action.Created descending
                   select new ListenTo.Shared.DO.Action
                   {
                        ID = action.ID,
                        Created = action.Created,
                        ActionType = (ActionType)Enum.ToObject(typeof(ActionType), action.ActionType),
                        OwnerID = action.OwnerID,
                        ContentID = action.ContentID,
                        ContentType =  (ContentType)Enum.ToObject(typeof(ContentType), action.ContentType),
                        PropertyType = (PropertyType)Enum.ToObject(typeof(PropertyType), action.PropertyType),
                        OldValue = action.OldValue,
                        NewValue = action.NewValue,
                        AssociatedArtistIds = new LazyList<Guid>(associatedArtists),
                        TargetSites = new LazyList<Guid>(targetSites),
                        OwnerUsername = user.Username
                        
                   };
        }

        public IPageOfList<ListenTo.Shared.DO.Action> GetUsersLatestActions(int pageSize, int currentPageIndex, Guid userId)
        {
            return GetActions().WithOwnerId(userId).ToPageOfList(currentPageIndex, pageSize);  
        }

        //public IPageOfList<ListenTo.Shared.DO.Action> GetLatestActionsForSite(int pageSize, int currentPageIndex, Guid siteId)
        //{
        //    //This should filter on SiteID but because of the execution order... we cant do this...
        //    return GetActions().ToPageOfList(currentPageIndex, pageSize);  
        //}

        /// <summary>
        /// Note that we EXPLICITY DONT return actions associated with Comments
        /// </summary>
        /// <param name="pageSize"></param>
        /// <param name="currentPageIndex"></param>
        /// <param name="siteId"></param>
        /// <returns></returns>
        public IPageOfList<ListenTo.Shared.DO.Action> GetLatestActionsForSite(int pageSize, int currentPageIndex, Guid siteId)
        {
            //Select n Random Ids
            var qry = (from action in DBContext.Actions
                       join actionsTargetSite in DBContext.ActionsTargetSites on action.ID equals actionsTargetSite.ActionID
                       where actionsTargetSite.SiteID == siteId && action.ContentType != (int)ContentType.COMMENT


                       select action.ID); //1st round-trip

            return this.GetActions().WithID(qry).ToPageOfList(currentPageIndex, pageSize);  
        }


        public ListenTo.Shared.DO.Relationship SaveRelationship(ListenTo.Shared.DO.Relationship relationship)
        {
            ListenTo.Data.LinqToSQL.Relationship dbRelationship = DBContext.Relationships.Where(x => x.ID == relationship.ID).SingleOrDefault();

            if (dbRelationship == null)
            {
                dbRelationship = new ListenTo.Data.LinqToSQL.Relationship();
                dbRelationship.ID = relationship.ID;
                //dbRelationship.Created = DateTime.Now;
                DBContext.Relationships.InsertOnSubmit(dbRelationship);
            }

            dbRelationship.SourceID = relationship.SourceId;
            dbRelationship.SourceType = (int)relationship.SourceContentType;
            dbRelationship.TargetID = relationship.TargetId;
            dbRelationship.TargetType = (int)relationship.TargetContentType;

            DBContext.SubmitChanges();

            return relationship;

        }


        private IQueryable<ArtistFanRelationshipSummary> GetArtistFanRelationshipSummary()
        {
            return from relationship in DBContext.Relationships

                   join artist in DBContext.Artists on relationship.TargetID equals artist.ID
                   join user in DBContext.Users on relationship.SourceID equals user.ID
                 
                   join artistImage in DBContext.Images on artist.LogoImageID equals artistImage.ID into tempImages
                   from artistImage in tempImages.DefaultIfEmpty()

                   join artistThumbnail in DBContext.Images on artistImage.ThumbnailID equals artistThumbnail.ID into tempImages2
                   from artistThumbnail in tempImages2.DefaultIfEmpty()

                   join userImage in DBContext.Images on user.AvatarImageID equals userImage.ID into tempImages3
                   from userImage in tempImages3.DefaultIfEmpty()

                   join userThumbnail in DBContext.Images on userImage.ThumbnailID equals userThumbnail.ID into tempImages4
                   from userThumbnail in tempImages4.DefaultIfEmpty()

                   select new ArtistFanRelationshipSummary
                   {
                       //ID = relationship.ID,
                       ArtistThumbnail = artistImage == null || artistThumbnail == null ? null : new ListenTo.Shared.DO.ImageMetaData
                       {
                           ID = artistThumbnail.ID,
                           Height = artistThumbnail.height,
                           Width = artistThumbnail.width
                       },
                       UserThumbnail = userImage == null || userThumbnail == null ? null : new ListenTo.Shared.DO.ImageMetaData
                       {
                           ID = userThumbnail.ID,
                           Height = userThumbnail.height,
                           Width = userThumbnail.width
                       },
                       ArtistName = artist.Name,
                       ArtistId = artist.ID,
                       ArtistProfileAddress = artist.ProfileAddress,
                       UserId = user.ID,
                       Username = user.Username
                   };
        }

        public IPageOfList<ArtistFanRelationshipSummary> GetArtistFanRelationshipSummaryForUser(int pageSize, int currentPageIndex, Guid userId)
        {
            return GetArtistFanRelationshipSummary().WithUserId(userId).ToPageOfList(currentPageIndex, pageSize);  
        }

        public IPageOfList<ArtistFanRelationshipSummary> GetArtistFanRelationshipSummaryForArtist(int pageSize, int currentPageIndex, Guid artistId)
        {
            return GetArtistFanRelationshipSummary().WithArtistId(artistId).ToPageOfList(currentPageIndex, pageSize);
        }

        public bool DoesRelationshipExist(ListenTo.Shared.DO.Relationship relationship)
        {
            var qry = from r in DBContext.Relationships
                      where r.SourceID == relationship.SourceId &&
                      r.TargetID == relationship.TargetId
                      select r.ID;
            int count = qry.Count();

            return count > 0;
        }
 

        #endregion


    }
}
