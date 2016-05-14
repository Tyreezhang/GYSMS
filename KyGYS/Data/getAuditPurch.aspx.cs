﻿using KyGYS.Controls;
using KyGYS.Controls.Caller;
using PetaPoco;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace KyGYS.Data
{
    public partial class getAuditPurch : BasicSecurity
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            base.Page_Load(sender, e);
            string page = Request.QueryString["page"];
            string rows = Request.QueryString["rows"];
            if (!string.IsNullOrEmpty(page) && !string.IsNullOrEmpty(rows))
            {
                try
                {
                    int rs = int.Parse(rows);
                }
                catch (Exception ex)
                {
                    rows = "10";
                }
                Refreash(int.Parse(page), int.Parse(rows));
                Response.End();
            }
        }

        private void Refreash(int page, int rows)
        {
            string[] list = null;
            var objs = new List<object>();
            string whr = " where  IsAudit=1 and IsDel = 0";
            string prefixWhr = string.Empty;
            var idx = 0;
            if (Session["PurStr"] != null)
            {
                string queryStr = Session["PurStr"].ToString();
                list = queryStr.Split(',');
            }
            if (IsManager != null && UserName != "")
            {
                if (IsManager != "True" && UserName != "admin")
                {
                    whr += "  and SuppName in (select UserName from T_ERP_MapUser where SuppName = @" + (idx++).ToString() + ")";
                    objs.Add(UserName);
                    prefixWhr = "select * from T_ERP_SuppPurch ";
                }
                else
                {
                    prefixWhr = "select * from T_ERP_SuppPurch ";
                }
                if (list != null && list.Count() > 0)
                {
                    if (!string.IsNullOrEmpty(list[0]))
                    {
                        whr += " and PurchNo=@" + (idx++).ToString();
                        objs.Add(list[0].ToString());
                    }
                }
                using (var db = new Database(SQLCONN.Conn))
                {
                    whr += " order by CreateDate  desc";
                    var pages = db.Page<UltraDbEntity.T_ERP_SuppPurch>(page, rows, prefixWhr + whr, objs.ToArray());
                    var grd = new EasyGridData<UltraDbEntity.T_ERP_SuppPurch>();
                    grd.Init(pages);
                    string data = Newtonsoft.Json.JsonConvert.SerializeObject(grd);
                    Response.Write(data);
                }
            }
            else
            {
                string data = "{\"IsError\":\"true\",\"ErrMsg\":\"登录失效,请刷新页面重新登录\"}";
                Response.Write(data);
            }
        }

        [System.Web.Services.WebMethod]
        public static string UpdatePrint(string guid)
        {
            string userName = HttpUtility.UrlDecode(HttpContext.Current.Request.Cookies["Login"]["UserName"].ToString());
            if (string.IsNullOrEmpty(guid) || userName == "") return "登陆超时";
            string msg = string.Empty;
            if (string.IsNullOrEmpty(guid)) return "";
            Ultra.Logic.ResultData rd = SerNoCaller.Calr_SuppPurch.ExecSql("Update T_ERP_SuppPurch set Reserved1 = 1 where guid =@0 and SuppName = @1", guid, userName);

            if (rd.QueryCount > 0)
            {
                //msg = "作废成功";
            }
            else
            {
                msg = rd.ErrMsg;
            }
            return msg;
        }
    }
}