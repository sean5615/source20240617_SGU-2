<%/*
----------------------------------------------------------------------------------
File Name		: scd216q_01c2.jsp
Author			: 黎岩慶
Description		: SCD018M_查詢當學期成績 - 控制頁面(JSP)
Modification Log	:

Vers		Date       	By            	Notes
--------------	--------------	--------------	----------------------------------
0.0.1		096/03/13	黎岩慶    	Code Generate Create
----------------------------------------------------------------------------------
*/%>
<%@ page errorPage="/utility/ajaxerrorpage.jsp" pageEncoding="MS950"%>
<%@ page import="com.nou.aut.*"%>
<%@ include file="/utility/header.jsp"%>
<%@ include file="/utility/controlpageinit.jsp"%>
<%@ include file="scd216q_01m1.jsp"%>

<%
int	logFlag	=	-1;
try
{
	/** 起始 Log */
	logger		=	new MyLogger(request.getRequestURI().toString() + "(" + control_type + ")");
	logger.iniUserInfo(Log4jInit.getIP(request));
	
	/** 起始 DBManager Container */
	dbManager	=	new DBManager(logger);

	/** 查詢 Grid 資料 */
	if (AUTICFM.securityCheck (session, "QRY") && control_type.equals("QUERY_MODE"))
	{
		logFlag	=	4;
		doQuery(out, dbManager, requestMap, session);
	}
	/** 匯出選取資料 */
	else if (AUTICFM.securityCheck (session, "EXP") && control_type.equals("EXPORT_MODE"))
	{
		logFlag	=	6;
		doExport(response, out, requestMap, session);
	}
	/** 匯出查詢資料 */
	else if (AUTICFM.securityCheck (session, "EXP") && control_type.equals("EXPORT_ALL_MODE"))
	{
		logFlag	=	6;
		doExportAll(response, out, dbManager, requestMap, session);
	}
	
	if (logFlag == -1)
		throw new Exception ("必須設定異動註記!!");
}
catch(Exception ex)
{
	logErrMessage(ex, logger);
	throw ex;
}
finally
{
	try
	{
		/** 異動註記 */
		if (logFlag != -2)
		{
			com.nou.aut.AUTLOG	autlog	=	new com.nou.aut.AUTLOG(dbManager);
			autlog.setUSER_ID((String)session.getAttribute("USER_ID_CD"));
			autlog.setPROG_CODE("scd216q");
			autlog.setUPD_MK(String.valueOf(logFlag));
			autlog.setIP_ADDR(Log4jInit.getIP(request));
			autlog.execute();
		}
		
		dbManager.close();
	}
	catch(Exception ex)
	{
		logErrMessage(ex, logger);
		throw ex;
	}

	if (logger != null)
	{
		long	endTime	=	System.currentTimeMillis();
		logger.append("全部執行時間：" + String.valueOf(endTime - startTime) + " ms");
		logger.log();
	}

	requestMap	=	null;
	logger		=	null;
}
%>