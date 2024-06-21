<%/*
----------------------------------------------------------------------------------
File Name		: scd216q_01c2.jsp
Author			: �����y
Description		: SCD018M_�d�߷�Ǵ����Z - �����(JSP)
Modification Log	:

Vers		Date       	By            	Notes
--------------	--------------	--------------	----------------------------------
0.0.1		096/03/13	�����y    	Code Generate Create
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
	/** �_�l Log */
	logger		=	new MyLogger(request.getRequestURI().toString() + "(" + control_type + ")");
	logger.iniUserInfo(Log4jInit.getIP(request));
	
	/** �_�l DBManager Container */
	dbManager	=	new DBManager(logger);

	/** �d�� Grid ��� */
	if (AUTICFM.securityCheck (session, "QRY") && control_type.equals("QUERY_MODE"))
	{
		logFlag	=	4;
		doQuery(out, dbManager, requestMap, session);
	}
	/** �ץX������ */
	else if (AUTICFM.securityCheck (session, "EXP") && control_type.equals("EXPORT_MODE"))
	{
		logFlag	=	6;
		doExport(response, out, requestMap, session);
	}
	/** �ץX�d�߸�� */
	else if (AUTICFM.securityCheck (session, "EXP") && control_type.equals("EXPORT_ALL_MODE"))
	{
		logFlag	=	6;
		doExportAll(response, out, dbManager, requestMap, session);
	}
	
	if (logFlag == -1)
		throw new Exception ("�����]�w���ʵ��O!!");
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
		/** ���ʵ��O */
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
		logger.append("��������ɶ��G" + String.valueOf(endTime - startTime) + " ms");
		logger.log();
	}

	requestMap	=	null;
	logger		=	null;
}
%>