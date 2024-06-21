<%/*
----------------------------------------------------------------------------------
File Name		: scd216q
Author			: sRu
Description		: SCD018M_查詢成績登錄狀況 - 主要頁面
Modification Log	:

Vers		Date       	By            	Notes
--------------	--------------	--------------	----------------------------------
0.0.1		096/06/11	sRu    	Code Generate Create
----------------------------------------------------------------------------------
*/%>
<%@ page contentType="text/html;charset=UTF-8" pageEncoding="MS950"%>
<%@ include file="/utility/header.jsp"%>
<%@ include file="/utility/titleSetup.jsp"%>
<script>
	<%
	/** 傳遞 Key 參數 */
	String	keyParam	=	com.acer.util.Utility.checkNull(request.getParameter("keyParam"), "");
	
    java.text.SimpleDateFormat dateTimeFormat = new java.text.SimpleDateFormat("yyyyMMdd");	
	java.util.Calendar cal = java.util.Calendar.getInstance();
	String today = dateTimeFormat.format(cal.getTime());
    com.acer.log.MyLogger logger = new com.acer.log.MyLogger("scd216q");
    com.acer.db.DBManager dbManager = new com.acer.db.DBManager(logger);
	com.nou.scd.bo.SCDGETSMSDATA sys = new com.nou.scd.bo.SCDGETSMSDATA(dbManager);
	sys.setSYS_DATE(today);
	// 1.當期 2.前期 3.後期 4.前學年 5.後學年
	sys.setSMS_TYPE("2");
	//result=1表成功,-1表示失敗
	int result = sys.execute();
	//設定參數,移至下頁時可用之參數,因此利用sys取得學年學期來作為參數,sms:學期,ayear:學年,exam_type:考試別
	if(result == 1) {
        if(!keyParam.equals("") && keyParam.length() > 0) {
            keyParam += "&AYEAR=" + sys.getAYEAR() + "&SMS=" + sys.getSMS()+"&AYEAR_SCD=" + sys.getAYEAR() + "&SMS_SCD=" + sys.getSMS();
        } else {
            keyParam = "?AYEAR=" + sys.getAYEAR() + "&SMS=" + sys.getSMS()+"&AYEAR_SCD=" + sys.getAYEAR() + "&SMS_SCD=" + sys.getSMS();
        }        
	}
	
	/** 學期 下拉選單*/
	session.setAttribute("SYST001_01_SELECT", "NOU#SELECT CODE AS SELECT_VALUE, CODE_NAME AS SELECT_TEXT FROM SYST001 WHERE KIND='[KIND]' ORDER BY SELECT_VALUE, SELECT_TEXT ");	
		
	%>
	top.viewFrame.location.href	=	'about:blank';
	top.hideView();
	/** 導向第一個處理的頁面 */
	top.mainFrame.location.href	=	'scd216q_01v1.jsp<%=keyParam%>';

</script>