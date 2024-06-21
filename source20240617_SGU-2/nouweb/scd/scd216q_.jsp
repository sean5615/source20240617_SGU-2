<%/*
----------------------------------------------------------------------------------
File Name		: scd216q
Author			: sRu
Description		: SCD018M_�d�ߦ��Z�n�����p - �D�n����
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
	/** �ǻ� Key �Ѽ� */
	String	keyParam	=	com.acer.util.Utility.checkNull(request.getParameter("keyParam"), "");
	
    java.text.SimpleDateFormat dateTimeFormat = new java.text.SimpleDateFormat("yyyyMMdd");	
	java.util.Calendar cal = java.util.Calendar.getInstance();
	String today = dateTimeFormat.format(cal.getTime());
    com.acer.log.MyLogger logger = new com.acer.log.MyLogger("scd216q");
    com.acer.db.DBManager dbManager = new com.acer.db.DBManager(logger);
	com.nou.scd.bo.SCDGETSMSDATA sys = new com.nou.scd.bo.SCDGETSMSDATA(dbManager);
	sys.setSYS_DATE(today);
	// 1.��� 2.�e�� 3.��� 4.�e�Ǧ~ 5.��Ǧ~
	sys.setSMS_TYPE("2");
	//result=1���\,-1��ܥ���
	int result = sys.execute();
	//�]�w�Ѽ�,���ܤU���ɥi�Τ��Ѽ�,�]���Q��sys���o�Ǧ~�Ǵ��ӧ@���Ѽ�,sms:�Ǵ�,ayear:�Ǧ~,exam_type:�ҸէO
	if(result == 1) {
        if(!keyParam.equals("") && keyParam.length() > 0) {
            keyParam += "&AYEAR=" + sys.getAYEAR() + "&SMS=" + sys.getSMS()+"&AYEAR_SCD=" + sys.getAYEAR() + "&SMS_SCD=" + sys.getSMS();
        } else {
            keyParam = "?AYEAR=" + sys.getAYEAR() + "&SMS=" + sys.getSMS()+"&AYEAR_SCD=" + sys.getAYEAR() + "&SMS_SCD=" + sys.getSMS();
        }        
	}
	
	/** �Ǵ� �U�Կ��*/
	session.setAttribute("SYST001_01_SELECT", "NOU#SELECT CODE AS SELECT_VALUE, CODE_NAME AS SELECT_TEXT FROM SYST001 WHERE KIND='[KIND]' ORDER BY SELECT_VALUE, SELECT_TEXT ");	
		
	%>
	top.viewFrame.location.href	=	'about:blank';
	top.hideView();
	/** �ɦV�Ĥ@�ӳB�z������ */
	top.mainFrame.location.href	=	'scd216q_01v1.jsp<%=keyParam%>';

</script>