using System;
namespace TrackIt.Model
{
    /// <summary>
    /// Имеет обладателя.
    /// </summary>
    public interface IOwned
    {
        int ID { get; set; }
        /// <summary>
        /// ID обладателя
        /// </summary>
        int OwnerID { get; set; }
        /// <summary>
        /// Тип обладателя
        /// </summary>
        int OwnerType { get; set; }
    }
}
