<%@ Page Language="C#" AutoEventWireup="true" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <script src="js/jquery-1.8.2.min.js"></script>
    <title></title>
    <link href="js/jquery.fancybox.css" rel="stylesheet" />
    <script src="js/jquery.fancybox.pack.js"></script>

    <script type="text/javascript">
        $(document).ready(function () {
            $(".v").fancybox({
                maxWidth: 800,
                maxHeight: 800,
                fitToView: false,
                width: '90%',
                height: '90%',
                autoSize: false,
                closeClick: false,
                openEffect: 'none',
                closeEffect: 'none'
            });
        });
    </script>
</head>
<script runat="server">
    protected void Page_Load(object sender, EventArgs e)
    {
        StringBuilder sb = new StringBuilder();
        if (Request.QueryString["ImageSession"] == null)
        {
            return; 
        }
        if (Request.QueryString["UserName"] == null)
        {
            return;
        }
        string ImageSession = Request.QueryString["ImageSession"];
        string UserName = Request.QueryString["UserName"];
        if (string.IsNullOrEmpty(ImageSession) || string.IsNullOrEmpty(UserName))
        {
            return; 
        }
        var list = KyGYS.Controls.Caller.SerNoCaller.Calr_V_ERP_GetImg.Get("select a.* from MSTest..T_ERP_Image a join  MSTest.dbo.F_ERP_SplitStr(@0,',') b on b.F1<>'' and a.Session=cast (b.F1 as uniqueidentifier) where a.Creator= @1 ", ImageSession, UserName);

        if (list == null || list.Count < 1) return;
        string path = KyGYS.Controls.SQLCONN.ImageStr;
        foreach (UltraDbEntity.V_ERP_GetImg img in list)
        {
            sb.AppendFormat("<a class='v fancybox' rel='g' href=\"{0}\" target=\"_blank\"><img src='{1}' style=\"width:120px;height:80px;cursor:pointer;\"  /></a>", path + KyGYS.Controls.CommonUtil.GetItemImgFileName(img.SavedFileName), path + KyGYS.Controls.CommonUtil.GetItemImgFileName(img.SavedFileName));
        }
        ltlImg.Text = sb.ToString();

    }
    
</script>
<body>
    <form id="form1" runat="server">
        <asp:Literal runat="server" ID="ltlImg">
        </asp:Literal>
    </form>
</body>
</html>
