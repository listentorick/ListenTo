using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using ListenTo.Shared.DO;
using ListenTo.Shared.Enums;
using ListenTo.Shared.Interfaces.Managers;
using ListenTo.Shared.DTO;
namespace ListenTo.Core.Managers
{
    /// <summary>
    /// For generating lists of relationships we will define summary objects which will derive from relationship
    /// These contain additional data required to represent the relation to a user.
    /// We will have bespoke methods on the Manager to 
    /// 
    /// </summary>
    public class RelationshipManager: BaseManager, IRelationshipManager, IManager<Relationship>
    {
        #region IManager<Relationship> Members

        public Relationship GetByID(Guid id)
        {
            throw new NotImplementedException();
        }

        public Relationship Save(ListenTo.Shared.Interfaces.DO.IDO dO, UserCredentials userCredentials)
        {
            return this.Repository.SaveRelationship((Relationship)dO);
        }

        public void Delete(Guid id, UserCredentials userCredentials)
        {
            throw new NotImplementedException();
        }

        #endregion

        #region IRelationshipManager Members

        public bool IsUserFanOfArtist(UserCredentials userCredentials, Guid artistId, Guid userId)
        {
            Relationship relationship = new Relationship();
            relationship.SourceContentType = ContentType.USER;
            relationship.SourceId = userId;
            relationship.TargetContentType = ContentType.ARTIST;
            relationship.TargetId = artistId;

            return this.Repository.DoesRelationshipExist(relationship);
        }

        public Relationship AddArtistFan(UserCredentials userCredentials, Guid artistId, Guid userId)
        {
        
            //We may want a specific validator here... i.e. is it a valid artist etc
            Relationship relationship = new Relationship();
            relationship.ID = Guid.NewGuid();
            relationship.SourceContentType = ContentType.USER;
            relationship.SourceId = userId;
            relationship.TargetContentType = ContentType.ARTIST;
            relationship.TargetId = artistId;

            return this.AddRelationship(userCredentials, relationship);
        }

        public Relationship AddRelationship(UserCredentials userCredentials, Relationship relationship)
        {
            //calls onto save and performs any other particular type of action
            this.Save(relationship,userCredentials);

            return relationship;
        }


        public ListenTo.Shared.Utility.IPageOfList<ArtistFanRelationshipSummary> GetArtistFanRelationshipSummaryForArtist(UserCredentials user, int pageSize, int currentPageIndex, Guid artistId)
        {
            return this.Repository.GetArtistFanRelationshipSummaryForArtist(pageSize, currentPageIndex, artistId);
        }

        public ListenTo.Shared.Utility.IPageOfList<ArtistFanRelationshipSummary> GetArtistFanRelationshipSummaryForUser(UserCredentials user, int pageSize, int currentPageIndex, Guid userId)
        {
            return this.Repository.GetArtistFanRelationshipSummaryForUser(pageSize, currentPageIndex, userId);
        }

        #endregion

    }
}
