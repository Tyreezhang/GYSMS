using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Web;
using KyGYS.Controls;
using UltraDbEntity;
using KyGYS;

namespace Demo.server
{
    /// <summary>
    /// fileupload 的摘要说明
    /// </summary>
    public class fileupload : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "text/plain";

            //指定字符集
            context.Response.ContentEncoding = Encoding.UTF8;
            if (context.Request["REQUEST_METHOD"] == "OPTIONS")
            {
                context.Response.End();
            }
            if (context.Request["ImageSession"] == null || context.Request["UserName"] == null)
            {
                context.Response.Write("操作失败");
                return;
            }
            if (!string.IsNullOrEmpty(context.Request["ImageSession"].ToString()) && !string.IsNullOrEmpty(context.Request["UserName"].ToString()))
            {
                var str = SaveFile(SQLCONN.UltraServerImageStr, context.Request["ImageSession"].ToString(), context.Request["UserName"].ToString());
               if (str != "")
               {
                   context.Response.Write(str);
               }
            }
        }
        /// <summary>
        /// 文件保存操作
        /// </summary>
        /// <param name="basePath"></param>
        private string SaveFile(string basePath, string ImageSession,string username)
        {
            var name = string.Empty;
            basePath = (basePath.IndexOf("~") > -1) ? System.Web.HttpContext.Current.Server.MapPath(basePath) :
            basePath;
            HttpFileCollection files = System.Web.HttpContext.Current.Request.Files;
            //如果目录不存在，则创建目录
            if (!Directory.Exists(basePath))
            {
                Directory.CreateDirectory(basePath);
            }

            var hx = files[0].FileName.LastIndexOf('.');
            if (hx < 0)
            {
                return "上传无效:" + files[0].FileName;
            }
            var suffix = files[0].FileName.Substring(hx, files[0].FileName.Length - hx);
            //获取文件格式
            var _suffix = suffix;

            var _temp = Guid.NewGuid() + _suffix;
            //文件保存
            var full = basePath + _temp;
            files[0].SaveAs(full);
            using (var db = new PetaPoco.Database(SQLCONN.Conn))
            {
                db.Execute("exec P_ERP_ImageUploadify @0,@1,@2", ImageSession, _temp, username);
            }
            return "";
        }

        public bool IsReusable
        {
            get
            {
                return false;
            }
        }
    }
}