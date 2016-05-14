﻿using KyGYS.Controls;
using PetaPoco;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using UltraDbEntity;

namespace KyGYS.Data
{
    public partial class getMapUserList : BasicSecurity
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            base.Page_Load(sender, e);
            Reflesh();
        }

        private void Reflesh()
        {
            using (var db = new Database(SQLCONN.Conn))
            {
                var items = db.Fetch<V_ERP_MapUser>("select * from V_ERP_MapUser");
                var grd = new EasyGridData<V_ERP_MapUser>();
                grd.total = items.Count().ToString();
                grd.rows = items;
                string data = Newtonsoft.Json.JsonConvert.SerializeObject(grd);
                Response.Write(data);
                Response.End();
            }
        }
    }
}