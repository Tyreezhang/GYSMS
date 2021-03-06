﻿<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="UnSendGoodsList.aspx.cs" Inherits="KyGYS.UnSendGoodsList" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <link href="jquery-easyui-1.4.2/themes/icon.css" rel="stylesheet" />
    <link href="jquery-easyui-1.4.2/demo/demo.css" rel="stylesheet" />
    <script src="js/jquery-1.8.2.min.js"></script>
    <script src="jquery-easyui-1.4.2/jQuery.easyui.min.js"></script>
    <script src="jquery-easyui-1.4.2/locale/easyui-lang-zh_CN.js"></script>
    <link href="jquery-easyui-1.4.2/themes/metro/easyui.css" rel="stylesheet" />
    <script src="js/tip.js"></script>
    <script src="js/LodopFuncs.js"></script>
    <script src="image-upload/jquery.uploadify.js"></script>
    <link href="image-upload/uploadify.css" rel="stylesheet" />
</head>
<body>
    <object id="LODOP_OB" classid="clsid:2105C259-1E0C-4534-8141-A753534CB4CA" width="0" height="0">
        <embed id="LODOP_EM" type="application/x-print-lodop" width="0" height="0" pluginspage="install_lodop32.exe"></embed>
    </object>
    <form runat="server">
        <div id="p" class="easyui-panel" style="width: 99%; height: 38px; padding: 4px;">
            <asp:Button runat="server" CssClass="easyui-linkbutton" ID="btnRef" Text="查  询" OnClick="btnRef_Click" Style="width: 80px; height: 28px;"></asp:Button>
             收货人:
            <asp:TextBox runat="server" ID="txtReceiverName"></asp:TextBox>&nbsp;
             手机号:
            <asp:TextBox runat="server" ID="txtReceiverMobile"></asp:TextBox>&nbsp;
              地址:
            <asp:TextBox runat="server" ID="txtReceiverAddress"></asp:TextBox>&nbsp;

        </div>
        <input type="hidden" id="txtBatchId" />
        <div style="margin: 6px 0;"></div>
        <table title="" id="tt" rownumbers="true" pagination="true" style="width: 99%; height: 320px"
            data-options="singleSelect:true,collapsible:true,url:'/data/getUnSendList.aspx',onSelect:SelectRow,toolbar:toolbar,method:'get',remoteSort:false,multiSort:true,pageSize:1,pageList:[10,20,50,100,200]">
            <thead>
                <tr>
                    <th data-options="field:'OrderTime',width:143,sortable:true" formatter="datestr">下单时间</th>
                    <th data-options="field:'BatchItemCount',width:55, align: 'center', sortable:true">商品总数</th>
                    <th data-options="field:'ReceiverName',width:120,sortable:true">收货人</th>
                    <th data-options="field:'Reserved1',width:150,align: 'center',sortable:true" formatter="formatprint">是否打印</th>
                    <th data-options="field:'ReceiverAddress',width:400,sortable:true">收货地址</th>
                </tr>
            </thead>
        </table>

        <div style="margin: 6px 0;"></div>

        <table title="" class="easyui-datagrid" id="orderlist" rownumbers="true" style="width: 99%; height: 150px"
            data-options="singleSelect:true,collapsible:true,remoteSort:false,multiSort:true">
            <thead>
                <tr>
                </tr>
            </thead>
        </table>
    </form>
    <script>
        function formatprint(val, row) {
            if (val == 1) {
                return '<span style="color:red;">' + '是' + '</span>';
            } else {
                return '否';
            }
        }

        function datestr(value, row, index) {
            if (typeof (value) != "undefined" && value != null) {
                value = value.replace(/\T/g, ' ');
                if (value.lastIndexOf('.') > 0) {
                    value = value.substring(0, value.lastIndexOf('.'));
                }
            }
            var unixTimestamp = value;
            return unixTimestamp;
        };
    </script>
    <script type="text/javascript">
        $(function () {
            openwid();
            $('#btnsendok').click(function () {
                var logisno = $('#txtLogisNo').val();
                var logisname = $('#txtLogisName').val();
                var logiscost = $('#txtLogisCost').val();
                var logismobile = $('#txtLogisMobile').val();

                if (logisno == '') {
                    msgShow('系统提示', '请输入物流单号！', 'warning');
                    return false;
                }
                if (logisname == '') {
                    msgShow('系统提示', '请输入物流公司！', 'warning');
                    return false;
                }

                if (logiscost == '') {
                    msgShow('系统提示', '请输入实际运费', 'warning');
                    return false;
                }
                var guid = "";
                close();
                $.messager.confirm("系统提示", "您确定要发货吗？", function (data) {
                    if (!data) {
                        return false;
                    }
                    else {
                        guid = $('#txtbchGuid').val();
                        if (guid == null) {
                            return false;
                        }
                        $.ajax({
                            url: "/data/getUnSendList.aspx/SendGoods",
                            type: "POST",
                            data: "{'guids':'" + guid + "','logisNo':'" + logisno + "','logisName':'" + logisname + "','logisCost':'" + logiscost + "','logisMobile':'" + logismobile + "'}",
                            dataType: 'json',
                            contentType: "application/json; charset=utf-8",
                            error: function (err) {
                                msgShow('系统提示', '发货失败！', 'error');
                            },
                            success: function (data) {
                                msgShow('系统提示', data.d, 'info');
                                $('#tt').datagrid('reload');
                                $('#orderlist').datagrid('loadData', { total: 0, rows: [] });
                            }
                        });
                        return false;
                    }
                });
            })

            $('#btncancel').click(function () {
                $('#txtLogisNo').val("");
                $('#txtLogisName').val("");
                $('#txtLogisCost').val("");
                $('#txtLogisMobile').val("");
                $('#txtbchGuid').val("");
                close();
            })
            $('#tt').datagrid({
                //singleSelect: (this.value == 0),
                onLoadSuccess: function (data) {
                    $('#tt').datagrid('doCellTip', { cls: { 'background-color': '#E6E6E6' }, delay: 300 });
                    $('#tt').datagrid('selectRow', 0);
                },
                onLoadError: function () {
                    msgShow('系统提示', '正在加载中！', 'warning');
                    return false;
                },
                loadFilter: function (data) {
                    if (data.IsError) {
                        alert("登录超时,请重新登录！");
                        if (window == top) { window.location.href = '../Login.aspx'; } else { top.location.href = '../Login.aspx'; }
                        return {
                            total: 0,
                            rows: []
                        };
                    } else {
                        return data;
                    }
                }
            });
        });
        //设置登录窗口
        function openwid() {
            $("#import_panel").panel('open');
            $("#import_panel").show();
            $('#logis').window({
                title: '填写物流信息',
                width: 380,
                modal: true,
                shadow: true,
                closed: true,
                height: 320,
                onBeforeClose: function () {
                    $('#txtLogisNo').val("");
                    $('#txtLogisName').val("");
                    $('#txtLogisCost').val("");
                    $('#txtLogisMobile').val("");
                },
                resizable: false
            });
        }
        //关闭登录窗口
        function close() {
            $('#logis').window('close');
        }
        // 对Date的扩展，将 Date 转化为指定格式的String
        // 月(M)、日(d)、小时(h)、分(m)、秒(s)、季度(q) 可以用 1-2 个占位符， 
        // 年(y)可以用 1-4 个占位符，毫秒(S)只能用 1 个占位符(是 1-3 位的数字) 
        // 例子： 
        // (new Date()).Format("yyyy-MM-dd hh:mm:ss.S") ==> 2006-07-02 08:09:04.423 
        // (new Date()).Format("yyyy-M-d h:m:s.S")      ==> 2006-7-2 8:9:4.18 
        Date.prototype.Format = function (fmt) { //author: meizz 
            var o = {
                "M+": this.getMonth() + 1, //月份 
                "d+": this.getDate(), //日 
                "h+": this.getHours(), //小时 
                "m+": this.getMinutes(), //分 
                "s+": this.getSeconds(), //秒 
                "q+": Math.floor((this.getMonth() + 3) / 3), //季度 
                "S": this.getMilliseconds() //毫秒 
            };
            if (/(y+)/.test(fmt)) fmt = fmt.replace(RegExp.$1, (this.getFullYear() + "").substr(4 - RegExp.$1.length));
            for (var k in o)
                if (new RegExp("(" + k + ")").test(fmt)) fmt = fmt.replace(RegExp.$1, (RegExp.$1.length == 1) ? (o[k]) : (("00" + o[k]).substr(("" + o[k]).length)));
            return fmt;
        }
        //弹出信息窗口 title:标题 msgString:提示信息 msgType:信息类型 [error,info,question,warning]
        function msgShow(title, msgString, msgType) {
            $.messager.alert(title, msgString, msgType);
        }
        $("div[class='tabs-panels']").attr('overflow', 'hidden');
        var toolbar = [
            {
                text: '打印预览',
                iconCls: 'icon-print',
                handler: function () {
                    var select = $('#tt').datagrid('getSelected');
                    if (!select) {
                        // msgShow('系统提示', '请选择数据！', 'warning');
                        return false;
                    }
                    $.ajax({
                        url: "/data/print.aspx/Print",
                        type: "POST",
                        data: "{'guid':'" + select.Guid + "'}",
                        dataType: 'json',
                        contentType: "application/json; charset=utf-8",
                        error: function (err) {
                            if (window == top) {
                                window.location.href = '../Login.aspx';
                            } else {
                                top.location.href = '../Login.aspx';
                            }
                        },
                        success: function (data) {
                            var LODOP;
                            if (data.d == "操作失败") {
                                if (window == top) {
                                    window.location.href = '../Login.aspx';
                                } else {
                                    top.location.href = '../Login.aspx';
                                }
                                return false;
                            }
                            if (data.d == "未财审") {
                                msgShow('系统提示', '订单数据信息需要在ERP里财审才可以打印哦！', 'warning');
                                return false;
                            }
                            LODOP = getLodop(document.getElementById('LODOP_OB'), document.getElementById('LODOP_EM'));
                            //LODOP.SET_PRINT_PAGESIZE(3, "208mm", "139mm", "");
                            LODOP.SET_PRINT_PAGESIZE(3, 0, 0, "A4");
                            LODOP.SET_PRINT_STYLE("FontSize", 18);
                            LODOP.SET_PRINT_STYLE("Bold", 1);
                            //LODOP.ADD_PRINT_TEXT(20, 320, 260, 39, "发货单");
                            LODOP.ADD_PRINT_HTM(4, 0, 500, 1200, data.d);
                            LODOP.SET_SHOW_MODE("NP_NO_RESULT", true);
                            LODOP.SET_PRINT_STYLEA(0, "HtmWaitMilSecs", 200);
                            if (LODOP.CVERSION) {  //用CVERSION属性判断是否云打印
                                LODOP.On_Return = function (TaskID, Value) {
                                    if (Value == "1") {
                                        $.ajax({
                                            url: "/data/getUnSendList.aspx/UpdatePrint",
                                            type: "POST",
                                            data: "{'guid':'" + select.Guid + "'}",
                                            dataType: 'json',
                                            contentType: "application/json; charset=utf-8",
                                            error: function (err) {
                                            },
                                            success: function (data) {
                                                $('#tt').datagrid('reload');
                                            }
                                        });
                                        return;
                                    }
                                };
                                LODOP.PREVIEW();
                                return;
                            };

                        }
                    });
                }
            }, '-',
            {
                text: '发货',
                iconCls: 'icon-redo',
                handler: function () {
                    var select = $('#tt').datagrid('getSelected');
                    if (!select) {
                        // msgShow('系统提示', '请选择数据！', 'warning');
                        return false;
                    }
                    $('#txtbchGuid').val(select.Guid);
                    $('#logis').window('open');
                }
            }, '-', {
                text: '导出',
                iconCls: 'icon-save',
                handler: function () {
                    window.location.href = "/data/export.aspx?send=0";
                }
            }
        ];
        function clearNoNum(obj) {
            obj.value = obj.value.replace(/[^\d.]/g, ""); //清除"数字"和"."以外的字符
            obj.value = obj.value.replace(/^\./g, ""); //验证第一个字符是数字而不是
            obj.value = obj.value.replace(/\.{2,}/g, "."); //只保留第一个. 清除多余的
            obj.value = obj.value.replace(".", "$#$").replace(/\./g, "").replace("$#$", ".");
            obj.value = obj.value.replace(/^(\-)*(\d+)\.(\d\d).*$/, '$1$2.$3'); //只能输入两个小数
        }
        function SelectRow(rowIndex, rowData) {
            if (typeof (rowData) == "undefined") {
                return false;
            }
            var SuppBatchGuid = rowData.Guid;
            if ($('#txtBatchId').val() == SuppBatchGuid) {
                return false;
            }
            $('#txtBatchId').val(SuppBatchGuid);
            $('#orderlist').datagrid({
                url: "/data/getItemList.aspx?SuppBatchGuid=" + SuppBatchGuid,
                columns: [[
                                 {
                                     field: 'Reserved2', title: '商品图片', width: '60', align: 'center', formatter: function (value, row) {
                                         var str = "";
                                         if (value != "" || value != null) {
                                             if (typeof (value) != "undefined") {
                                                 str = " <a class='various fancybox.iframe' style='margin-left:10px;' href='./showImg2.aspx?ImageSession=" + value + "' target='_blank'><img  onerror=\"this.style.display='none'\" style=\"height: 33px;width: 33px;\" alt='无' src=\"" + value + "\"/></a>";
                                             } else {
                                                 str = " <a class='various fancybox.iframe' style='margin-left:10px;' href='./showImg2.aspx?ImageSession=" + value + "' target='_blank'><img onerror=\"this.style.display='none'\" style=\"height: 33px;width: 33px;\" alt='无' /></a>";
                                             }
                                             return str;
                                         }
                                     }
                                 },
                                //{ field: 'ItemName', title: '商品名称', width: '230', sortable: true },
                                //{ field: 'SkuProperties', title: '规格名称', width: '190', sortable: true },
                                { field: 'OuterIid', title: '商品编码', width: '150', sortable: true, align: 'left' },
                                { field: 'OuterSkuId', title: '规格编码', width: '150', sortable: true, align: 'left' },
                                { field: 'Num', title: '数量', width: '40', sortable: true },
                                { field: 'PackageCount', title: '包件数', width: '40', sortable: true },
                                { field: 'BusVolume', title: '体积', width: '60', sortable: true, align: 'left' },
                                { field: 'Color', title: '颜色', width: '100', sortable: true, align: 'left' },
                                { field: 'Size', title: '尺寸', width: '70', sortable: true, align: 'left' },
                                { field: 'Remark', title: '备注', width: '120', sortable: true, align: 'left' }
                ]],
            });
            $('#orderlist').datagrid({
                onLoadSuccess: function (data) {
                    $('#orderlist').datagrid('doCellTip', { cls: { 'background-color': '#E6E6E6' }, delay: 300 });
                },
                onLoadError: function () {
                    msgShow('系统提示', '正在加载中！', 'warning');
                    return false;
                },
                loadFilter: function (data) {
                    if (data.IsError) {
                        alert("登录超时,请重新登录！");
                        if (window == top) { window.location.href = '../Login.aspx'; } else { top.location.href = '../Login.aspx'; }
                        return {
                            total: 0,
                            rows: []
                        };
                    } else {
                        return data;
                    }
                }
            });
        }
    </script>

    <div class="easyui-panel" data-options="closed:true" id="import_panel" style="display: none; border: hidden">
        <div id="logis" class="easyui-window" title="填写物流信息" collapsible="false" minimizable="false"
            maximizable="false" icon="icon-save" style="width: 500px; height: 500px;background: #fafafa;">
            <div class="easyui-layout" fit="true">
                <div region="center" border="false" style="padding: 20px; background: #fff; border: 1px solid #ccc;">
                    <table cellpadding="3">
                        <tr>
                            <td>物流单号：</td>
                            <td>
                                <input id="txtLogisNo" type="text" class="txt01" />
                                <input id="txtbchGuid" type="hidden" />
                            </td>

                        </tr>
                        <tr>
                            <td>物流公司：</td>
                            <td>
                                <input id="txtLogisName" type="text" class="txt01" /></td>
                        </tr>
                        <tr>
                            <td>实际运费：</td>
                            <td>
                                <input id="txtLogisCost" type="text" class="txt01" onkeyup="clearNoNum(this)" />
                                元</td>
                        </tr>
                        <tr>
                            <td>联系号码：</td>
                            <td>
                                <input id="txtLogisMobile" type="text" class="txt01" /></td>
                        </tr>
                        <tr>
                             <td>
                            <label for="Attachment_GUID">上传凭证：</label>
                        </td>
                        <td>                            
                            <div>
                                <input class="easyui-validatebox" type="hidden" id="Attachment_GUID" name="Attachment_GUID" />
                                <input id="file_upload" name="file_upload" type="file" multiple="multiple" />

                                <a href="javascript:void(0)" class="easyui-linkbutton" id="btnUpload" data-options="plain:true,iconCls:'icon-save'"
                                    onclick="javascript: $('#file_upload').uploadify('upload', '*')">上传</a>
                                <a href="javascript:void(0)" class="easyui-linkbutton" id="btnCancelUpload" data-options="plain:true,iconCls:'icon-cancel'"
                                    onclick="javascript: $('#file_upload').uploadify('cancel', '*')">取消</a>

                                <div id="fileQueue" class="fileQueue"></div>
                                <div id="div_files"></div>
                                <br />
                            </div>
                        </td>
                        </tr>
                    </table>
                </div>
                <div region="south" border="false" style="text-align: right; height: 30px; line-height: 30px;">
                    <a id="btnsendok" class="easyui-linkbutton" icon="icon-ok" href="javascript:void(0)">确定</a> <a id="btncancel" class="easyui-linkbutton" icon="icon-cancel" href="javascript:void(0)">取消</a>
                </div>
            </div>
        </div>
    </div>

    <link href="js/jquery.fancybox.css" rel="stylesheet" />
    <script src="js/jquery.fancybox.pack.js"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            $(".various").fancybox({
                //maxWidth: 800,
                //maxHeight: 600,
                fitToView: false,
                width: '80%',
                height: '80%',
                autoSize: false,
                closeClick: false,
                openEffect: 'none',
                closeEffect: 'none'
            });
        });
    </script>
        <script type="text/javascript">
            $(function () {
                //添加界面的附件管理
                $('#file_upload').uploadify({
                    'swf': 'image-upload/uploadify.swf',  //FLash文件路径
                    'buttonText': '浏  览',                                 //按钮文本
                    'uploader': '../server/fileupload.ashx',                       //处理文件上传Action
                    'queueID': 'fileQueue',                        //队列的ID
                    'queueSizeLimit': 3,                          //队列最多可上传文件数量，默认为999
                    'auto': false,                                 //选择文件后是否自动上传，默认为true
                    'multi': true,                                 //是否为多选，默认为true
                    'removeCompleted': true,                       //是否完成后移除序列，默认为true
                    'fileSizeLimit': '10MB',                       //单个文件大小，0为无限制，可接受KB,MB,GB等单位的字符串值
                    'fileTypeDesc': 'Image Files',                 //文件描述
                    'fileTypeExts': '*.gif; *.jpg; *.png; *.bmp;',  //上传的文件后缀过滤器
                    'onQueueComplete': function (event, data) {                 //所有队列完成后事件
                       // ShowUpFiles($("#Attachment_GUID").val(), "div_files");  //完成后更新已上传的文件列表
                        //提示完成      
                        $.messager.alert("提示", "上传完毕！");
                    },
                    'onUploadStart': function (file) {
                        $("#file_upload").uploadify("settings", 'formData', { 'ImageSession': $('#txtbchGuid').val() }); //动态传参数
                    },
                    "onUploadComplete": function (event, data, response) {

                    }, "onUploadSuccess": function (file, data, response) {
                        //$.messager.alert("提示", "上传完毕！");
                        if (data != undefined && data != "") {
                            $.messager.alert("提示", data);
                        }
                    }
                });
            });
        </script>
</body>
</html>
