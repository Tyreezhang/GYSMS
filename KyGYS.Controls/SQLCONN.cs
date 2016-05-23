using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data.SqlClient;
using System.Data;
using System.Collections;
using UltraDbEntity;
using PetaPoco;


namespace KyGYS.Controls
{

    public class SQLCONN
    {
        private static string connString = string.Empty;

        private static string ultraServerImageStr = string.Empty;

        private static string imageStr = string.Empty;
        /// <summary>
        /// 设置连接字符串
        /// </summary>
        public static string Conn
        {
            set { connString = value; }
            get
            {
                if (string.IsNullOrEmpty(connString))
                {
                    try
                    {
                        connString = KyGYS.Common.Util.Decrypt(CommonUtil.ConnStr);
                    }
                    catch { }
                }
                return connString;
            }
        }

        public static string UltraServerImageStr
        {
            set { ultraServerImageStr = value; }
            get
            {
                if (string.IsNullOrEmpty(ultraServerImageStr))
                {
                    try
                    {
                        ultraServerImageStr = KyGYS.Common.Util.Decrypt(CommonUtil.UltraServerImageStr);
                    }
                    catch { }
                }
                return ultraServerImageStr;
            }
        }

        public static string ImageStr
        {
            set { imageStr = value; }
            get
            {
                if (string.IsNullOrEmpty(imageStr))
                {
                    try
                    {
                        imageStr = KyGYS.Common.Util.Decrypt(CommonUtil.ImageStr);
                    }
                    catch { }
                }
                return imageStr;
            }
        }
    }
}
