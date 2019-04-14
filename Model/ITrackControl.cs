using System;
using System.Collections.Generic;
using System.Text;

namespace TrackIt.Model
{
    public enum TrackControlTypes { CheckPoint=1, Temperature=2 }
    public interface ITrackControl
    {
        Track Track{get;set;}
        string TempKey { get; }

        void Save();
        void Create();
    }
}
