using System;
using System.Collections.Generic;
using System.Text;
using System.Threading;
using Castle.ActiveRecord;
using Common;
using NHibernate.Expression;

namespace TrackIt.Model
{
    public class StateManager
    {
        bool isWorking = false;

        public void Stop()
        {
            isWorking = false;
        }
        /// <summary>
        /// Запускать в другом потоке
        /// </summary>
        public void Start()
        {
            isWorking = true;
            while (isWorking)
            {
                try
                {
                    processWaitingTracks();
                    Thread.Sleep(2000);
                    processTrackingTracks();
                    Thread.Sleep(2000);
                }
                catch (Exception ex)
                {
                    Ex.Add(ex);
                }
                
            }
        }

        void processWaitingTracks()
        {
            using (TransactionScope ts = new TransactionScope())
            {
                //если невозможно подключиться к базе
                if (ts == null) return;
                foreach (Track track in Track.FindAllActive(Order.Asc("ID"),
                    Expression.Eq("Status",(TrackStatus)TrackStatus.TrackStatuses.WaitingOfStart)))
                {

                    if (Timestamp.Now() >= track.StartCheckPoint.ExpectedDateTo.AddMinutes(-1))
                    {
                        track.StartDate = Timestamp.Now();
                        track.Status = TrackStatus.TrackStatuses.Tracking;
                        track.Update();
                    }
                }

                ts.VoteCommit();                
            }
        }

        void processTrackingTracks()
        {
            using (TransactionScope ts = new TransactionScope())
            {
                //если невозможно подключиться к базе
                if (ts == null) return;
                foreach (Track track in Track.FindAllActive(Order.Asc("ID"),
                    Expression.Eq("Status", (TrackStatus)TrackStatus.TrackStatuses.Tracking)))
                {
                    if (Timestamp.Now() >= track.StopCheckPoint.ExpectedDateTo.AddDays(1))
                    {
                        track.StopDate = Timestamp.Now();
                        track.Status = TrackStatus.TrackStatuses.Finished;
                        track.Update();
                    }
                }

                ts.VoteCommit();
            }
        }
    }
}
