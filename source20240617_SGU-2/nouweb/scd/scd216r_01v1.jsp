<%/*
----------------------------------------------------------------------------------
File Name		: scd216r_01v1
Author			: north
Description		: SCD216R_列印績優生獎狀 - 顯示頁面
Modification Log	:

Vers		Date       	By            	Notes
--------------	--------------	--------------	----------------------------------
0.0.2		097/03/13	sRu			1.查詢條件加上學制及學號，學制預設在空大
0.0.1		096/08/10	north    	Code Generate Create
----------------------------------------------------------------------------------
*/%>
<%@ page contentType="text/html; charset=UTF-8" errorPage="/utility/errorpage.jsp" pageEncoding="MS950"%>
<%@ include file="/utility/header.jsp"%>
<html>
<head>
	<%@ include file="/utility/viewpageinit.jsp"%>
	<script src="<%=vr%>script/framework/query3_1_0_2.jsp"></script>
	<script src="scd216r_01c1.jsp"></script>
	<noscript>
		<p>您的瀏覽器不支援JavaScript語法，但是並不影響您獲取本網站的內容</p>
	</noscript>
</head>
<body background="<%=vr%>images/ap_index_bg.jpg" alt="背景圖" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">

<!-- 定義查詢的 Form 起始 -->
<form name="QUERY" method="post" onsubmit="doQuery();" style="margin:0,0,5,0;">
	<input type=hidden name="control_type">
	<input type=hidden name="REAL_USED_NO">
	<input type=hidden name="print_type">

	<!-- 查詢全畫面起始 -->
	<TABLE id="QUERY_DIV" width="96%" border="0" align="center" cellpadding="0" cellspacing="0" summary="排版用表格">
		<tr>
			<td width="13"><img src="<%=vr%>images/ap_search_01.jpg" alt="排版用圖示" width="13" height="12"></td>
			<td width="100%"><img src="<%=vr%>images/ap_search_02.jpg" alt="排版用圖示" width="100%" height="12"></td>
			<td width="13"><img src="<%=vr%>images/ap_search_03.jpg" alt="排版用圖示" width="13" height="12"></td>
		</tr>
		<tr>
			<td width="13" background="<%=vr%>images/ap_search_04.jpg" alt="排版用圖示">&nbsp;</td>
			<td width="100%" valign="top" bgcolor="#C5E2C3">
				<!-- 按鈕畫面起始 -->
				<table width="100%" border="0" align="center" cellpadding="2" cellspacing="0" summary="排版用表格">
					<tr class="mtbGreenBg">
						<td align=left>【列印畫面】</td>
						<td align=right>
							<div id="serach_btn">
								<input type=button class="btn" value='清  除' onclick='doReset();' onkeypress='doReset();'>
								<input type=submit class="btn" name="PRT_ALL_BTN" value='產製獎狀證號暨批次列印' onclick='doPrint();' onkeypress='doPrint();'>
							</div>
						</td>
					</tr>
				</table>
				<!-- 按鈕畫面結束 -->

				<!-- 查詢畫面起始 -->
				<table id="table1" width="100%" border="0" align="center" cellpadding="2" cellspacing="1" summary="排版用表格">
					<tr>
						<td align='right'>
							學年期<font color=red>＊</font>：
						</td>
						<td align='left' colspan ='1'>
							<input type='text' name='AYEAR'>
							<select name='SMS'>
								<option value=''>請選擇</option>
								<script>Form.getSelectFromPhrase("scd216rSMS_SELECT", "KIND", "SMS");</script>
							</select>
						</td>
						<td align='right'>
							學制：
						</td>
						<td align='left' colspan ='1'>
							<select name='ASYS'>
								<option value=''>請選擇</option>
								<option value='1'>大學部</option>
								<option value='2'>專科部</option>
							</select>
						</td>
					</tr>
					<tr>
						<td align='right'>
							類別<font color=red>＊</font>：
						</td>
						<td>
							<select name='TYPE'>
								<option value=''>請選擇</option>
								<option value='1|1'>(大學部)全校前 20 名</option>
								<option value='2|1'>(專科部)全校前 3 名</option>								
								<option value='1|2'>(大學部)各中心第 1 名</option>
								<option value='2|2'>(專科部)各中心第 1 名</option>								
								<option value='|4'>(大學部、專科部)各中心各科第 1 名</option>									
							</select>
						</td>
						<td align='right'>中心：</td>
						<td>
							<select name='CENTER_CODE'>
								<option value=''>請選擇</option>
								<script>Form.getSelectFromPhrase("SCD216R_01_SELECT", "", "");</script>
							</select>
						</td>
					</tr>
					<tr>						
						<td align='right'>
							學號：
						</td>
						<td>
							<input type='text' name='STNO'>
						</td>
						<td align='right'>是否自訂證號：</td>
						<td>
							<select name='USE_USER_SET' onchange="openUsedNo(this.value);">
								<option value='N'>否</option>
								<option value='Y'>是</option>
							</select>
						</td>
					</tr>
					<tr>
						<td align='right'>下一個證號<font color=red>＊</font>：</td>
						<td align='left' colspan="3" >年度:<input type="text" name="YEAR">證號:<input type="text" name="USED_NO"></td>						
					</tr>
				</table>
				<!-- 查詢畫面結束 -->
			</td>
			<td width="13" background="<%=vr%>images/ap_search_06.jpg" alt="排版用圖示">&nbsp;</td>
		</tr>
		<tr>
			<td width="13"><img src="<%=vr%>images/ap_search_07.jpg" alt="排版用圖示" width="13" height="13"></td>
			<td width="100%"><img src="<%=vr%>images/ap_search_08.jpg" alt="排版用圖示" width="100%" height="13"></td>
			<td width="13"><img src="<%=vr%>images/ap_search_09.jpg" alt="排版用圖示" width="13" height="13"></td>
		</tr>
	</table>
	<!-- 查詢全畫面結束 -->
</form>
<!-- 定義查詢的 Form 結束 -->

<!-- 標題畫面起始 -->
<table width="96%" border="0" align="center" cellpadding="4" cellspacing="0" summary="排版用表格">
	<tr>
		<td>
			<table width="500" height="27" border="0" cellpadding="0" cellspacing="0">
				<tr>
					<td background="<%=vr%>images/ap_index_title.jpg" alt="排版用圖示">
						　　<span class="title">SCD216R_列印績優生獎狀</span>
					</td>
				</tr>
			</table>
		</td>
	</tr>
</table>
<!-- 標題畫面結束 -->

<script>
	document.write ("<font color=\"white\">" + document.lastModified + "</font>");
	window.attachEvent("onload", page_init);
	window.attachEvent("onload", onloadEvent);
</script>
</body>
</html>