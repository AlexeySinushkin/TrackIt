using System;
using System.Collections.Generic;
using System.Text;
using System.Text.RegularExpressions;


namespace Common
{       

    //public class Expression
    //{

    //    /// <summary>
    //    /// Удаляет символы % _ ' update insert select delete
    //    /// </summary>
    //    /// <param name="input"></param>
    //    /// <returns></returns>
    //    public static string Clean(string input)
    //    {
    //        string output;
    //        output = input.Trim();
    //        output = output.Replace("%", "");
    //        output = output.Replace("_", "");
    //        //удаляем select update insert delete
    //        Regex r = new Regex("(select)|(update)|(insert)|(delete)", System.Text.RegularExpressions.RegexOptions.IgnoreCase);
    //        try
    //        {
    //            output = r.Replace(output, "");
    //        }
    //        catch (Exception ex)
    //        {
    //            Ex.Add(ex);
    //            output = "";
    //        }
    //        return output;
    //    }

    //    /// <summary>
    //    /// Удаляет символы % _ ' update insert select delete
    //    /// и обрубает строку слева
    //    /// </summary>
    //    /// <param name="input"></param>
    //    /// <returns></returns>
    //    public static string Clean(string input, int leftCount)
    //    {
    //        return Str.Left(Clean(input), leftCount);
    //    }






    //    public static ICriterion Eq(string column, object value)
    //    {
    //        return new EqExpression(column, value);
    //    }
    //    public static ICriterion In(string column,params object[] value)
    //    {
    //        return new InExpression(column, value);
    //    }
    //    public static ICriterion Sql(SQLString sql, object[] values, IType[] types)
    //    {
    //        return new SqlExpression(sql, values, types);
    //    }
    //}
    //public class Order : NHibernate.Expression.Order
    //{
    //    public Order(string propertyName, bool ascending)
    //        : base(propertyName, ascending)
    //    {
    //    }
    //}
    //public class EqExpression : NHibernate.Expression.EqExpression,ICriterion
    //{
    //    public EqExpression(string column, object value) : base(column, value) { }
    //    public EqExpression(string column, object value, bool ignoreCASE) : base(column, value, ignoreCASE) { }
    //}
    //public class InExpression:NHibernate.Expression.InExpression,ICriterion
    //{
    //    public InExpression(string column, params object[] values):base(column, values){}
    //}
    //public class SqlExpression : NHibernate.Expression.SQLCriterion,ICriterion
    //{
    //    public SqlExpression(SQLString sql, object[] values, IType[] types):base(sql,values,types)
    //    {

    //    }


    //}
}
