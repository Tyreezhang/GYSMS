<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="upimg.aspx.cs" Inherits="OYWebSite.image_upload.upimg" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <link rel="stylesheet" type="text/css" href="../../css/webuploader.css" />
    <link rel="stylesheet" type="text/css" href="./style.css" />
    <style type="text/css">
        .hidden {
            color:white;
        }
    </style>
</head>
<body>
    <form runat="server">
        <input id="txtimgSession" type="hidden" runat="server" />
        <input id="txtUser"  type="hidden" runat="server"/>
        <div id="wrapper">
            <div id="container">
                <!--头部，相册选择和格式选择-->

                <div id="uploader">
                    <div class="queueList">
                        <div id="dndArea" class="placeholder">
                            <div id="filePicker"></div>
                            <p>或将照片拖到这里，单次最多可选10张</p>
                        </div>
                    </div>
                    <div class="statusBar" style="display: none;">
                        <div class="progress">
                            <span class="text">0%</span>
                            <span class="percentage"></span>
                        </div>
                        <div class="info"></div>
                        <div class="btns">
                            <div id="filePicker2"></div>
                            <div class="uploadBtn">开始上传</div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <script type="text/javascript" src="./jquery.js"></script>
        <script type="text/javascript" src="../../dist/webuploader.js"></script>
        <script type="text/javascript" src="./upload.js"></script>
    </form>
</body>
</html>
