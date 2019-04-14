using System;
using System.Collections.Generic;
using System.Text;
using Common.DBAdapter;

namespace Limovka.Transmission.Model
{
    [Table("Organizations",Level=1)]
    public class Organization : Company
    {        

        public override int ObjectType
        {
            get
            {
                return 2;
            }
            set
            {
            }
        }

        int baseID = -1;
        [Column(Level = 1)]
        public int BaseID
        {
            get { return baseID; }
            set { baseID = value; }
        }

        string inn = "";
        [Column(100,Level = 1)]
        public string Inn
        {
            get { return inn; }
            set { inn = value; }
        }
        string kpp = "";
        [Column(100, Level = 1)]
        public string Kpp
        {
            get { return kpp; }
            set { kpp = value; }
        }
        string bik = "";
        [Column(100, Level = 1)]
        public string Bik
        {
            get { return bik; }
            set { bik = value; }
        }
        string okved = "";
        [Column(100, Level = 1)]
        public string Okved
        {
            get { return okved; }
            set { okved = value; }
        }
        string bank = "";
        [Column(100, Level = 1)]
        public string Bank
        {
            get { return bank; }
            set { bank = value; }
        }
        string rAccount = "";
        [Column(100, Level = 1)]
        public string RAccount
        {
            get { return rAccount; }
            set { rAccount = value; }
        }
        string kAccount = "";
        [Column(100, Level = 1)]
        public string KAccount
        {
            get { return kAccount; }
            set { kAccount = value; }
        }
    }
}
