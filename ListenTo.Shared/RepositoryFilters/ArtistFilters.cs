using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using ListenTo.Shared.DO;

namespace ListenTo.Shared.RepositoryFilters
{
    public static class ArtistFilters
    {

        public static IQueryable<Artist> WithID(this IQueryable<Artist> qry, Guid Id)
        {
            return from artist in qry
                   where artist.ID == Id
                   select artist;
        }

        public static IQueryable<Artist> WithID(this IQueryable<Artist> qry, IQueryable<Guid> Ids)
        {
            return from artist in qry 
                   where Ids.Contains(artist.ID)
                   select artist;
        }

        public static IQueryable<Artist> WithNameLike(this IQueryable<Artist> qry, string name)
        {
            return from artist in qry
                   where artist.Name.Contains(name)
                   select artist;
        }

        public static IQueryable<Artist> WithName(this IQueryable<Artist> qry, string name)
        {
            return from artist in qry
                   where artist.Name.ToLower() == name.ToLower()
                   select artist;
        }


        public static IQueryable<Artist> WithProfileAddress(this IQueryable<Artist> qry, string profileAddress)
        {
            return from artist in qry
                   where artist.ProfileAddress.ToLower() == profileAddress.ToLower()
                   select artist;
        }

        public static IQueryable<Artist> WithOwner(this IQueryable<Artist> qry, Guid ownerId)
        {
            return from artist in qry
                   where artist.OwnerID == ownerId
                   select artist;
        }

        public static IQueryable<Artist> WithStyle(this IQueryable<Artist> qry, Guid styleId)
        {
            return from artist in qry
                   where artist.Style.ID == styleId
                   select artist;
        }
    }
}
