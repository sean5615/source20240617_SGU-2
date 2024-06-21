<%/*
----------------------------------------------------------------------------------
File Name		: scd216q_01c1
Author			: �����y
Description		: SCD018M_�d�߷�Ǵ����Z - ����� (javascript)
Modification Log	:

Vers		Date       	By            	Notes
--------------	--------------	--------------	----------------------------------
0.0.3       096/11/08   POTO        ���󳣧אּ�D����
0.0.2       096/05/15   WEN         ��SPEC���s�ק�
                                    1.Table���
                                    2.�令DAO���榡
                                    3.�ק��ӶץX���覡
0.0.1		096/03/13	�����y    	Code Generate Create
----------------------------------------------------------------------------------
*/%>
<%@ page contentType="text/html; charset=UTF-8" errorPage="/utility/errorpage.jsp" pageEncoding="MS950"%>
<%@ include file="/utility/header.jsp"%>
<%@ include file="/utility/jspageinit.jsp"%>

/** �פJ javqascript Class */
doImport ("Query.js, ErrorHandle.js, LoadingBar_0_2.js, Form.js, Ajax_0_2.js, ArrayUtil.js, ReSize.js, SortTable.js");

/** ��l�]�w������T */
var	printPage		=	"/scd/scd216q_01p1.jsp";	//�C�L����
var	editMode		=	"ADD";				//�s��Ҧ�, ADD - �s�W, MOD - �ק�
var	lockColumnCount		=	-1;				//��w����
var	listShow		=	false;				//�O�_�@�i�J��ܸ��
var	_privateMessageTime	=	-1;				//�T����ܮɶ�(���ۭq�� -1)
var	pageRangeSize		=	10;				//�e���@����ܴX�����
var	controlPage		=	"/scd/scd216q_01c2.jsp";	//�����
var	checkObj		=	new checkObj();			//�ֿ露��
var	queryObj		=	new queryObj();			//�d�ߤ���
var	importSelect		=	false;				//�פJ������\��
var	noPermissAry		=	new Array();			//�S���v�����}�C

/** ������l�� */
function page_init()
{
	page_init_start();

	editMode	=	"NONE";
	/** �v���ˮ� */
	securityCheck();

	/** === ��l���]�w === */
	/** ��l�W�h�a�Ӫ� Key ��� */
	iniMasterKeyColumn();

	/** ��l�d����� */
	Form.iniFormSet('QUERY', 'AYEAR','F',3,'N', 'R', 0,'M',3,'S',3);
	Form.iniFormSet('QUERY', 'SMS', 'R', 0,'D',0);	
	Form.iniFormSet('QUERY', 'CENTER_CODE', 'N1', 'M',  2, 'A');
	Form.iniFormSet('QUERY', 'CRSNO', 'N','M', 6, 'A');
	Form.iniFormSet('QUERY', 'CRS_NAME', 'M',  6, 'A');
	Form.iniFormSet('QUERY', 'STNO', 'M',  9, 'EN','A','u');

	/** ��l�s����� */
	loadind_.showLoadingBar (15, "��l��짹��");
	/** ================ */

	/** === �]�w�ˮֱ��� === */
	/** �d����� */
	Form.iniFormSet('QUERY', 'AYEAR', 'AA', 'chkForm', '�Ǧ~');
	Form.iniFormSet('QUERY', 'SMS', 'AA', 'chkForm', '�Ǵ�');
	Form.iniFormSet('QUERY', 'CENTER_CODE', 'AA', 'chkForm', '���ߧO');
	/*
	Form.iniFormSet('QUERY', 'CRSNO', 'AA', 'chkForm', '���');
	Form.iniFormSet('QUERY', 'CLASS_CODE', 'AA', 'chkForm', '�Z��');
	*/

	/** �s����� */
	loadind_.showLoadingBar (20, "�]�w�ֱ��󧹦�");
	/** ================ */

	page_init_end();
}

/**
��l�� Grid ���e
@param	stat	�I�s���A(init -> ������l��)
*/
function iniGrid(stat)
{
	var	gridObj	=	new Grid();

	iniGrid_start(gridObj)

	/** �]�w���Y */
	gridObj.heaherHTML.append
	(
		"<table id=\"RsultTable\" class='sortable' width=\"100%\" border=\"1\" cellpadding=\"2\" cellspacing=\"0\" bordercolor=\"#E6E6E6\" summary=\"�ƪ��Ϊ��\">\
			<tr class=\"mtbGreenBg\">\
				<td width=20 style= 'display:none'>&nbsp;</td>\
				<td width=20>&nbsp;</td>\
				<td resize='on' nowrap>�Ǧ~��</td>\
				<td resize='on' nowrap>�Ǹ�</td>\
				<td resize='on' nowrap>�m�W</td>\
				<td resize='on' nowrap>�Z�u�����O</td>\
				<td resize='on' nowrap>���ߧO</td>\
				<td resize='on' nowrap>��ئW��</td>\
			</tr>"
	);

	if (stat == "init" && !listShow)
	{
		/** ��l�ƤΤ���ܸ�ƥu�q���Y */
		document.getElementById("grid-scroll").innerHTML	=	gridObj.heaherHTML.toString().replace(/\t/g, "") + "</table>";
		Message.hideProcess();
	}
	else
	{
		/** �����϶��P�B */
		Form.setInput ("QUERY", "pageSize",	Form.getInput("RESULT", "_scrollSize"));
		Form.setInput ("QUERY", "pageNo",	Form.getInput("RESULT", "_goToPage"));

		/** �B�z�s�u����� */
		var	callBack	=	function iniGrid.callBack(ajaxData)
		{
			if (ajaxData == null)
				return;

			/** �]�w�� */
			var	keyValue	=	"";
			var	DkeyValue	=	"";
			var	editStr		=	"";
			var	delStr		=	"";

			for (var i = 0; i < ajaxData.data.length; i++, gridObj.rowCount++)
			{
				keyValue	=	"AYEAR|" + ajaxData.data[i].AYEAR + "|SMS|" + ajaxData.data[i].SMS + "|KIND|" + ajaxData.data[i].KIND + "|STNO|" + ajaxData.data[i].STNO + "|CRSNO|" + ajaxData.data[i].CRSNO;
				
				/** �P�_�v�� */
				if (chkSecure("DEL"))
					delStr	=	"onkeypress=\"doDelete('" + keyValue + "');\"onclick=\"doDelete('" + keyValue + "');\"><a href=\"javascript:void(0)\">�R</a>";
				else
					delStr	=	">�R";

				if (chkSecure("UPD"))
					editStr	=	"onkeypress=\"doEdit('" + keyValue + "');\"onclick=\"doEdit('" + keyValue + "');\"><a href=\"javascript:void(0)\">�׽�</a>";
				else
					editStr	=	">�׽�";
					
				var doPrint1 = "doPrint('../scd/scd216q_01p1.jsp?control_type=PRINT_MODE&PROG_CODE=&AYEAR="+ajaxData.data[i].AYEAR+"&SMS="+ajaxData.data[i].SMS+"&STNO="+ajaxData.data[i].STNO+"&CENTER_CODE="+ajaxData.data[i].CENTER_CODE+"&CRSNO="+ajaxData.data[i].CRSNO+"&KIND="+ajaxData.data[i].KIND+"&print_type="+ajaxData.data[i].KIND+"');";
                
                var printStr1	=	"onclick=\""+doPrint1+"\"><a href=\"javascript:void(0)\">����</a>";
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
						<td>" + ajaxData.data[i].CENTER_CODE_NAME + "�@" + "&nbsp;</td>\
						<td>" + ajaxData.data[i].CRS_NAME + "&nbsp;</td>\
					</tr>"
				);
			}
			gridObj.gridHtml.append ("</table>");

			/** �L�ŦX��� */
			if (ajaxData.data.length == 0)
				gridObj.gridHtml.append ("<font color=red><b>�@�@�@�d�L�ŦX���!!</b></font>");

			iniGrid_end(ajaxData, gridObj);			
		}
		sendFormData("QUERY", controlPage, "QUERY_MODE", callBack);
	}
}

/** �d�ߥ\��ɩI�s */
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
		alert("��ءA���ߧO�A�Ǹ��A�оܤ@��J");
		return;
	}
	Form.setInput('QUERY', 'control_type','EXPORT_ALL_MODE');
	Form.doSubmit('QUERY',controlPage,'post','');		
}


/** �s�W�\��ɩI�s */
function doAdd(){}

/** �ק�\��ɩI�s */
function doModify(){}

/** �s�ɥ\��ɩI�s */
function doSave(){}

/** ============================= ���ץ��{����m�� ======================================= */
/** �]�w�\���v�� */
function securityCheck()
{
	try
	{
		/** �d�� */
		if (!<%=AUTICFM.securityCheck (session, "QRY")%>)
		{
			noPermissAry[noPermissAry.length]	=	"QRY";
			try{Form.iniFormSet("QUERY", "QUERY_BTN", "D", 1);}catch(ex){}
		}
		/** �s�W */
		if (!<%=AUTICFM.securityCheck (session, "ADD")%>)
		{
			noPermissAry[noPermissAry.length]	=	"ADD";
			editMode	=	"NONE";
			try{Form.iniFormSet("EDIT", "ADD_BTN", "D", 1);}catch(ex){}
		}
		/** �ק� */
		if (!<%=AUTICFM.securityCheck (session, "UPD")%>)
		{
			noPermissAry[noPermissAry.length]	=	"UPD";
		}
		/** �s�W�έק� */
		if (!chkSecure("ADD") && !chkSecure("UPD"))
		{
			try{Form.iniFormSet("EDIT", "SAVE_BTN", "D", 1);}catch(ex){}
		}
		/** �R�� */
		if (!<%=AUTICFM.securityCheck (session, "DEL")%>)
		{
			noPermissAry[noPermissAry.length]	=	"DEL";
			try{Form.iniFormSet("RESULT", "DEL_BTN", "D", 1);}catch(ex){}
		}
		/** �ץX */
		if (!<%=AUTICFM.securityCheck (session, "EXP")%>)
		{
			noPermissAry[noPermissAry.length]	=	"EXP";
			try{Form.iniFormSet("RESULT", "EXPORT_BTN", "D", 1);}catch(ex){}
			try{Form.iniFormSet("QUERY", "EXPORT_ALL_BTN", "D", 1);}catch(ex){}
		}
		/** �C�L */
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
/** �ˬd�v�� - ���v��/�L�v��(true/false) */
function chkSecure(secureType)
{
	if (noPermissAry.toString().indexOf(secureType) != -1)
		return false;
	else
		return true
}
/** ====================================================================================== */
/** ��l�W�h�a�Ӫ� Key ��� */
function iniMasterKeyColumn()
{
	/** �D Detail �������B�z */
	if (typeof(keyObj) == "undefined")
		return;
	/** ��� */
	for (keyName in keyObj)
	{
		try {Form.iniFormSet("QUERY", keyName, "V", keyObj[keyName], "R", 0);}catch(ex){};
		try {Form.iniFormSet("EDIT", keyName, "V", keyObj[keyName], "R", 0);}catch(ex){};
	}
	Form.iniFormColor();
}
/** �B�z�C�L�ʧ@ */
function doPrint1(url)
{
	/** ���� onsubmit �\�ਾ��ưe�X */
	event.returnValue	=	false;

	/** �}�l�B�z */
	Message.showProcess();

	var	printWin	=	WindowUtil.openPrintWindow("", "Print");

	Form.doSubmit("RESULT", url, "post", "Print");

	printWin.focus();

	/** ����B�z */
	Message.hideProcess();
}