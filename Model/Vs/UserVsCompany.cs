using System;
using System.Collections.Generic;
using System.Text;
using Common.Attributes;

namespace TrackIt.Model
{
    /// <summary>
    /// ������� ����������� ������������ � �����������
    /// ������� � ���������� ������������� ����� ����� * *
    /// </summary>
    [Table("UserVsCompany")]
    public class UserVsCompany : modelObject<UserVsCompany>
    {

        WebUser user;
        [ReferenceTo("UserID", NotNull = true)]
        public WebUser User
        {
            get { return user; }
            set { user = value; }
        }
        Company company;
        [ReferenceTo("CompanyID", NotNull = true)]
        public Company Company
        {
            get { return company; }
            set { company = value; }
        }
    }
}
