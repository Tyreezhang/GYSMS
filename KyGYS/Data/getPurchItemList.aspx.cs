using KyGYS.Controls;
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
    public partial class getPurchItemList : BasicSecurity
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            base.Page_Load(sender, e);
            string SuppPurchGuid = Request.QueryString["SuppPurchGuid"];
            if (SuppPurchGuid != null && !string.IsNullOrEmpty(SuppPurchGuid))
            {
                GetItem(SuppPurchGuid);
            }
        }

        private void GetItem(string SuppPurchGuid)
        {
            List<V_ERP_PurchItemIsCard> items = null;
            using (var db = new Database(SQLCONN.Conn))
            {
                if (!string.IsNullOrEmpty(UserName) && UserName != "admin")
                {
                    items = db.Fetch<V_ERP_PurchItemIsCard>("select * from V_ERP_PurchItemIsCard where SuppPurchGuid=@0  and SuppName =@1 and  isnull(Num,0) > 0", SuppPurchGuid, UserName);
                }
                else
                {
                    items = db.Fetch<V_ERP_PurchItemIsCard>("select * from V_ERP_PurchItemIsCard where SuppPurchGuid=@0", SuppPurchGuid);
                }  
                items.ForEach(j =>
                {
                    j.Reserved2 = "http://101.251.96.120:30000/Item_Images/MSTest/" + KyGYS.Controls.CommonUtil.GetItemImgFileName(j.OuterIid + j.OuterSkuId + ".jpg");
                    if (j.IsCard)
                    {
                        j.SKImageUrl = "http://101.251.96.120:30000/Images/" + j.SKImageUrl.Remove(0, 6);
                    }
                    else
                    {
                        j.SKImageUrl = "";
                    }
                });
                var grd = new EasyGridData<V_ERP_PurchItemIsCard>();
                grd.total = items.Count().ToString();
                grd.rows = items;
                string data = Newtonsoft.Json.JsonConvert.SerializeObject(grd);
                Response.Write(data);
                Response.End();
            }
        }
    }
}