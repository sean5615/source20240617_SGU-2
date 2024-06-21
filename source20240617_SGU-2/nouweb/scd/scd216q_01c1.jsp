<%/*
----------------------------------------------------------------------------------
File Name		: scd216q_01c1
Author			: 黎岩慶
Description		: SCD018M_查詢當學期成績 - 控制頁面 (javascript)
Modification Log	:

Vers		Date       	By            	Notes
--------------	--------------	--------------	----------------------------------
0.0.3       096/11/08   POTO        條件都改為非必填
0.0.2       096/05/15   WEN         依SPEC重新修改
                                    1.Table欄位
                                    2.改成DAO的格式
                                    3.修改整個匯出的方式
0.0.1		096/03/13	黎岩慶    	Code Generate Create
----------------------------------------------------------------------------------
*/%>
<%@ page contentType="text/html; charset=UTF-8" errorPage="/utility/errorpage.jsp" pageEncoding="MS950"%>
<%@ include file="/utility/header.jsp"%>
<%@ include file="/utility/jspageinit.jsp"%>

/** 匯入 javqascript Class */
doImport ("Query.js, ErrorHandle.js, LoadingBar_0_2.js, Form.js, Ajax_0_2.js, ArrayUtil.js, ReSize.js, SortTable.js");

/** 初始設定頁面資訊 */
var	printPage		=	"/scd/scd216q_01p1.jsp";	//列印頁面
var	editMode		=	"ADD";				//編輯模式, ADD - 新增, MOD - 修改
var	lockColumnCount		=	-1;				//鎖定欄位數
var	listShow		=	false;				//是否一進入顯示資料
var	_privateMessageTime	=	-1;				//訊息顯示時間(不自訂為 -1)
var	pageRangeSize		=	10;				//畫面一次顯示幾頁資料
var	controlPage		=	"/scd/scd216q_01c2.jsp";	//控制頁面
var	checkObj		=	new checkObj();			//核選元件
var	queryObj		=	new queryObj();			//查詢元件
var	importSelect		=	false;				//匯入選取欄位功能
var	noPermissAry		=	new Array();			//沒有權限的陣列

/** 網頁初始化 */
function page_init()
{
	page_init_start();

	editMode	=	"NONE";
	/** 權限檢核 */
	securityCheck();

	/** === 初始欄位設定 === */
	/** 初始上層帶來的 Key 資料 */
	iniMasterKeyColumn();

	/** 初始查詢欄位 */
	Form.iniFormSet('QUERY', 'AYEAR','F',3,'N', 'R', 0,'M',3,'S',3);
	Form.iniFormSet('QUERY', 'SMS', 'R', 0,'D',0);	
	Form.iniFormSet('QUERY', 'CENTER_CODE', 'N1', 'M',  2, 'A');
	Form.iniFormSet('QUERY', 'CRSNO', 'N','M', 6, 'A');
	Form.iniFormSet('QUERY', 'CRS_NAME', 'M',  6, 'A');
	Form.iniFormSet('QUERY', 'STNO', 'M',  9, 'EN','A','u');

	/** 初始編輯欄位 */
	loadind_.showLoadingBar (15, "初始欄位完成");
	/** ================ */

	/** === 設定檢核條件 === */
	/** 查詢欄位 */
	Form.iniFormSet('QUERY', 'AYEAR', 'AA', 'chkForm', '學年');
	Form.iniFormSet('QUERY', 'SMS', 'AA', 'chkForm', '學期');
	Form.iniFormSet('QUERY', 'CENTER_CODE', 'AA', 'chkForm', '中心別');
	/*
	Form.iniFormSet('QUERY', 'CRSNO', 'AA', 'chkForm', '科目');
	Form.iniFormSet('QUERY', 'CLASS_CODE', 'AA', 'chkForm', '班級');
	*/

	/** 編輯欄位 */
	loadind_.showLoadingBar (20, "設定核條件完成");
	/** ================ */

	page_init_end();
}

/**
初始化 Grid 內容
@param	stat	呼叫狀態(init -> 網頁初始化)
*/
function iniGrid(stat)
{
	var	gridObj	=	new Grid();

	iniGrid_start(gridObj)

	/** 設定表頭 */
	gridObj.heaherHTML.append
	(
		"<table id=\"RsultTable\" class='sortable' width=\"100%\" border=\"1\" cellpadding=\"2\" cellspacing=\"0\" bordercolor=\"#E6E6E6\" summary=\"排版用表格\">\
			<tr class=\"mtbGreenBg\">\
				<td width=20 style= 'display:none'>&nbsp;</td>\
				<td width=20>&nbsp;</td>\
				<td resize='on' nowrap>學年期</td>\
				<td resize='on' nowrap>學號</td>\
				<td resize='on' nowrap>姓名</td>\
				<td resize='on' nowrap>績優生類別</td>\
				<td resize='on' nowrap>中心別</td>\
				<td resize='on' nowrap>科目名稱</td>\
			</tr>"
	);

	if (stat == "init" && !listShow)
	{
		/** 初始化及不顯示資料只秀表頭 */
		document.getElementById("grid-scroll").innerHTML	=	gridObj.heaherHTML.toString().replace(/\t/g, "") + "</table>";
		Message.hideProcess();
	}
	else
	{
		/** 頁次區間同步 */
		Form.setInput ("QUERY", "pageSize",	Form.getInput("RESULT", "_scrollSize"));
		Form.setInput ("QUERY", "pageNo",	Form.getInput("RESULT", "_goToPage"));

		/** 處理連線取資料 */
		var	callBack	=	function iniGrid.callBack(ajaxData)
		{
			if (ajaxData == null)
				return;

			/** 設定表身 */
			var	keyValue	=	"";
			var	DkeyValue	=	"";
			var	editStr		=	"";
			var	delStr		=	"";

			for (var i = 0; i < ajaxData.data.length; i++, gridObj.rowCount++)
			{
				keyValue	=	"AYEAR|" + ajaxData.data[i].AYEAR + "|SMS|" + ajaxData.data[i].SMS + "|KIND|" + ajaxData.data[i].KIND + "|STNO|" + ajaxData.data[i].STNO + "|CRSNO|" + ajaxData.data[i].CRSNO;
				
				/** 判斷權限 */
				if (chkSecure("DEL"))
					delStr	=	"onkeypress=\"doDelete('" + keyValue + "');\"onclick=\"doDelete('" + keyValue + "');\"><a href=\"javascript:void(0)\">刪</a>";
				else
					delStr	=	">刪";

				if (chkSecure("UPD"))
					editStr	=	"onkeypress=\"doEdit('" + keyValue + "');\"onclick=\"doEdit('" + keyValue + "');\"><a href=\"javascript:void(0)\">修課</a>";
				else
					editStr	=	">修課";
					
				var doPrint1 = "doPrint('../scd/scd216q_01p1.jsp?control_type=PRINT_MODE&PROG_CODE=&AYEAR="+ajaxData.data[i].AYEAR+"&SMS="+ajaxData.data[i].SMS+"&STNO="+ajaxData.data[i].STNO+"&CENTER_CODE="+ajaxData.data[i].CENTER_CODE+"&CRSNO="+ajaxData.data[i].CRSNO+"&KIND="+ajaxData.data[i].KIND+"&print_type="+ajaxData.data[i].KIND+"');";
                
                var printStr1	=	"onclick=\""+doPrint1+"\"><a href=\"javascript:void(0)\">獎狀</a>";
				//var printStr1 ="";
				gridObj.gridHtml.append
				(
					"<tr class=\"listColor0" + ((gridObj.rowCount % 2) + 1) + "\">\
						<td  style= 'display:none' align=center><input type=checkbox name='chkBox' value=\"" + keyValue + "\"></td>\
						<td align=center " + printStr1 + "</td>\
						<td>" + ajaxData.data[i].AYEAR_NAME + ajaxData.data[i].SMS_NAME + "&nbsp;</td>\
						<td>" + ajaxData.data[i].STNO + "&nbsp;</td>\
						<td>" + ajaxData.data[i].NAME + "&nbsp;</td>\
						<td>" + ajaxData.data[i].KIND_NAME + "&nbsp;</td>\
						<td>" + ajaxData.data[i].CENTER_CODE_NAME + "　" + "&nbsp;</td>\
						<td>" + ajaxData.data[i].CRS_NAME + "&nbsp;</td>\
					</tr>"
				);
			}
			gridObj.gridHtml.append ("</table>");

			/** 無符合資料 */
			if (ajaxData.data.length == 0)
				gridObj.gridHtml.append ("<font color=red><b>　　　查無符合資料!!</b></font>");

			iniGrid_end(ajaxData, gridObj);			
		}
		sendFormData("QUERY", controlPage, "QUERY_MODE", callBack);
	}
}

/** 查詢功能時呼叫 */
function doQuery()
{
	doQuery_start();


	return doQuery_end();
}

function doExport() {	
	var CRSNO = Form.getInput("QUERY", "CRSNO");
	var CENTER_CODE = Form.getInput("QUERY", "CENTER_CODE");
	var STNO = Form.getInput("QUERY", "STNO");	
	if((STNO==""||STNO==null)&&(CENTER_CODE==""||CENTER_CODE==null)&&(CRSNO==""||CRSNO==null)){		
		alert("科目，中心別，學號，請擇一輸入");
		return;
	}
	Form.setInput('QUERY', 'control_type','EXPORT_ALL_MODE');
	Form.doSubmit('QUERY',controlPage,'post','');		
}


/** 新增功能時呼叫 */
function doAdd(){}

/** 修改功能時呼叫 */
function doModify(){}

/** 存檔功能時呼叫 */
function doSave(){}

/** ============================= 欲修正程式放置區 ======================================= */
/** 設定功能權限 */
function securityCheck()
{
	try
	{
		/** 查詢 */
		if (!<%=AUTICFM.securityCheck (session, "QRY")%>)
		{
			noPermissAry[noPermissAry.length]	=	"QRY";
			try{Form.iniFormSet("QUERY", "QUERY_BTN", "D", 1);}catch(ex){}
		}
		/** 新增 */
		if (!<%=AUTICFM.securityCheck (session, "ADD")%>)
		{
			noPermissAry[noPermissAry.length]	=	"ADD";
			editMode	=	"NONE";
			try{Form.iniFormSet("EDIT", "ADD_BTN", "D", 1);}catch(ex){}
		}
		/** 修改 */
		if (!<%=AUTICFM.securityCheck (session, "UPD")%>)
		{
			noPermissAry[noPermissAry.length]	=	"UPD";
		}
		/** 新增及修改 */
		if (!chkSecure("ADD") && !chkSecure("UPD"))
		{
			try{Form.iniFormSet("EDIT", "SAVE_BTN", "D", 1);}catch(ex){}
		}
		/** 刪除 */
		if (!<%=AUTICFM.securityCheck (session, "DEL")%>)
		{
			noPermissAry[noPermissAry.length]	=	"DEL";
			try{Form.iniFormSet("RESULT", "DEL_BTN", "D", 1);}catch(ex){}
		}
		/** 匯出 */
		if (!<%=AUTICFM.securityCheck (session, "EXP")%>)
		{
			noPermissAry[noPermissAry.length]	=	"EXP";
			try{Form.iniFormSet("RESULT", "EXPORT_BTN", "D", 1);}catch(ex){}
			try{Form.iniFormSet("QUERY", "EXPORT_ALL_BTN", "D", 1);}catch(ex){}
		}
		/** 列印 */
		if (!<%=AUTICFM.securityCheck (session, "PRT")%>)
		{
			noPermissAry[noPermissAry.length]	=	"PRT";
			try{Form.iniFormSet("RESULT", "PRT_BTN", "D", 1);}catch(ex){}
			try{Form.iniFormSet("QUERY", "PRT_ALL_BTN", "D", 1);}catch(ex){}
		}
	}
	catch (ex)
	{
	}
}
/** 檢查權限 - 有權限/無權限(true/false) */
function chkSecure(secureType)
{
	if (noPermissAry.toString().indexOf(secureType) != -1)
		return false;
	else
		return true
}
/** ====================================================================================== */
/** 初始上層帶來的 Key 資料 */
function iniMasterKeyColumn()
{
	/** 非 Detail 頁面不處理 */
	if (typeof(keyObj) == "undefined")
		return;
	/** 塞值 */
	for (keyName in keyObj)
	{
		try {Form.iniFormSet("QUERY", keyName, "V", keyObj[keyName], "R", 0);}catch(ex){};
		try {Form.iniFormSet("EDIT", keyName, "V", keyObj[keyName], "R", 0);}catch(ex){};
	}
	Form.iniFormColor();
}
/** 處理列印動作 */
function doPrint1(url)
{
	/** 取消 onsubmit 功能防止重複送出 */
	event.returnValue	=	false;

	/** 開始處理 */
	Message.showProcess();

	var	printWin	=	WindowUtil.openPrintWindow("", "Print");

	Form.doSubmit("RESULT", url, "post", "Print");

	printWin.focus();

	/** 停止處理 */
	Message.hideProcess();
}