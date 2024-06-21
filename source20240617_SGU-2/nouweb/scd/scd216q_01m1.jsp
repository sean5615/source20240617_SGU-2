
<%
	/*
	 ----------------------------------------------------------------------------------
	 File Name		: scd216q_01m1.jsp
	 Author			: �����y
	 Description		: SCD018M_�d�߷�Ǵ����Z - �B�z�޿譶��
	 Modification Log	:

	 Vers		Date       	By            	Notes
	 --------------	--------------	--------------	----------------------------------
	 0.0.2       096/05/15   WEN         ��SPEC���s�ק�
	 1.Table���
	 2.�令DAO���榡
	 3.�ק��ӶץX���覡
	 0.0.1		096/03/13	�����y    	Code Generate Create
	 0.0.3		096/10/04	poto    	���վ�
	 ----------------------------------------------------------------------------------
	 */
%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="MS950"%>
<%@ include file="/utility/header.jsp"%>
<%@ include file="/utility/modulepageinit.jsp"%>
<%@page
	import="com.nou.scd.dao.* ,
                com.acer.util.DateUtil ,
                com.nou.sys.dao.* ,
                com.nou.cou.* "%>


<%!/** �B�z�d�� Grid ��� */

	public void doQuery(JspWriter out, DBManager dbManager, Hashtable requestMap, HttpSession session) throws Exception {
		try {
			Connection conn = dbManager.getConnection(AUTCONNECT.mapConnect("COU", session));
			int pageNo = Integer.parseInt(Utility.checkNull(requestMap.get("pageNo"), "1"));
			int pageSize = Integer.parseInt(Utility.checkNull(requestMap.get("pageSize"), "10"));

			SCDT021GATEWAY scd021gateway = new SCDT021GATEWAY(dbManager, conn, pageNo, pageSize);

			Vector result = scd021gateway.getScd216qQuery(requestMap);

			out.println(DataToJson.vtToJson(scd021gateway.getTotalRowCount(), result));
		} catch (Exception ex) {
			throw ex;
		} finally {
			dbManager.close();
		}
	}

	/** �ץX������ */
	public void doExport(HttpServletResponse response, JspWriter out, Hashtable requestMap, HttpSession session) throws Exception {

	}

	/** �ץX�d�߸�� */
	public void doExportAll(HttpServletResponse response, JspWriter out, DBManager dbManager, Hashtable requestMap, HttpSession session) throws Exception {
	}

	private void doPrint(JspWriter out, DBManager dbManager, Hashtable requestMap, HttpSession session) throws Exception {
		try {
			Connection conn = dbManager.getConnection(AUTCONNECT.mapConnect("NOU", session));
			SCDT021GATEWAY scd021gateway = new SCDT021GATEWAY(dbManager, conn);
			Vector vt = scd021gateway.getMainDataToPrintForSCD216Q(requestMap, session); // �p�����s������,���o��s�᪺���
			if (vt.size() == 0) {
				out.println("<script>top.close();alert(\"�L�ŦX��ƥi�ѦC�L!!\"); window.close(); </script>");
				return;
			}
			/** ��l�� rptFile */
			RptFile rptFile = new RptFile(session.getId());
			rptFile.setColumn("��_1,��_2");

			// ���o�e�ݦC�L����
			String rank = (String) requestMap.get("print_type");
			String ASYS = Utility.dbStr(requestMap.get("ASYS"));
			String tmpstr = "";
			String tmpstr1 = "";
			String asys_name = "";

			if ("1".equals(Utility.dbStr(requestMap.get("ASYS")))) {
				asys_name = "�j�ǳ�";
			} else {
				asys_name = "�M�쳡";
			}

			if (rank.equals("1"))
				tmpstr1 = "�W�C";
			else if (rank.equals("2"))
				tmpstr1 = "�W�C����";
			else if (rank.equals("3"))
				tmpstr1 = "�W�C";
			else if (rank.equals("4"))
				tmpstr1 = "�W�C���߲�";

			for (int i = 0; i < vt.size(); i++) {
				Hashtable content = (Hashtable) vt.get(i);
				String centerName = this.getCenterNameStyle(content.get("CENTER_CODE_NAME").toString());
				String name = this.getNameStyle(content.get("NAME").toString());
				String crsName = this.getCrsrNameStyle(content.get("CRS_NAME").toString());
				String ayearSms = this.getYearSmsStyle(toChanisesFullChar((String) ((Hashtable) vt.get(i)).get("AYEAR")) + "�Ǧ~��" + ((Hashtable) vt.get(i)).get("SMS_NAME"));

				// ���ئW�٤֩�7�Ӧr��,�ݦA�h�@��ťզ�
				int nameLength = content.get("NAME").toString().length();
				int centerNameLength = ((Hashtable) vt.get(i)).get("CENTER_CODE_NAME").toString().length();
				String addSpace = nameLength + centerNameLength + tmpstr.length() <= 20 ? "<tr><td colspan='3' style='height:1.5cm'></td></tr>" : "";
				String contentHtml = "<table width=100% >" + "<tr><td align=center colspan='4' valign=top class=title><font class=title1>��ߪŤ��j�Ǽ���</font></td></tr>" + "<tr><td align=right colspan='4' valign=top style='height:0.5cm;'><font class=title2>(" + Integer.parseInt(Utility.checkNull(Utility.checkNull(content.get("PRNYEAR"), ""), "0")) + ")�Ťj�Ǽ��r��" + ((Hashtable) vt.get(i)).get("AWARD_NO") + "��</font></td></tr>" + "<tr><td colspan='4' class=space1>�@</td></tr></table>";

				if (rank.equals("1")) {
					contentHtml += "<table width=100% ><tr style='line-height = 1.5cm;'>" + centerName + "<td width='13%' style='font-size=24pt;font-family:�з���;letter-spacing = 0.07cm;'>�ǥ�</td>" + name + "</tr></table><table width=100% >" + "<tr style='line-height = 1.5cm;'><td colspan='4' align='left' style='font-size=24pt;font-family:�з���;letter-spacing = 0.07cm;text-align:justify;text-justify:distribute-all-lines;text-align-last:justify;'>"
							+ toChanisesFullChar((String) ((Hashtable) vt.get(i)).get("AYEAR")) + "�Ǧ~��" + ((Hashtable) vt.get(i)).get("SMS_NAME") + "�Ƿ~���Z�u�}<br>" + tmpstr1 + ((Hashtable) vt.get(i)).get("STNO_ASYS_NAME") + "���ղ�" + toChanisesFullChar(String.valueOf(Integer.parseInt((String) ((Hashtable) vt.get(i)).get("RANK")))) + "�W </td></tr>"
							+ "<tr style='line-height = 1.5cm;'><td colspan='4' style='font-size=24pt;font-family:�з���;letter-spacing = 0.07cm;text-align:justify;'>����ų\�S�{�����H�깪�y</td></tr>";
				} else if (rank.equals("2")) {
					contentHtml += "<table width=100% ><tr style='line-height = 1.5cm;'>" + centerName + "<td width='13%' style='font-size=24pt;font-family:�з���;letter-spacing = 0.07cm;'>�ǥ�</td>" + name + "</tr></table><table width=100% >" + "<tr style='line-height = 1.5cm;'><td colspan='4' align='left' style='font-size=24pt;font-family:�з���;letter-spacing = 0.07cm;text-align:justify;text-justify:distribute-all-lines;text-align-last:justify;'>"
							+ toChanisesFullChar((String) ((Hashtable) vt.get(i)).get("AYEAR")) + "�Ǧ~��" + ((Hashtable) vt.get(i)).get("SMS_NAME") + "�Ƿ~���Z�u�}<br>" + tmpstr1 + ((Hashtable) vt.get(i)).get("STNO_ASYS_NAME") + "��" + toChanisesFullChar(String.valueOf(Integer.parseInt((String) ((Hashtable) vt.get(i)).get("RANK")))) + "�W </td></tr>"
							+ "<tr style='line-height = 1.5cm;'><td colspan='4' style='font-size=24pt;font-family:�з���;letter-spacing = 0.07cm;text-align:justify;'>����ų\�S�{�����H�깪�y</td></tr>";
				} else if (rank.equals("3")) {
					contentHtml += "<table width=100% ><tr style='line-height = 1.5cm;'>" + centerName + "<td width='13%' style='font-size=24pt;font-family:�з���;letter-spacing = 0.07cm;'>�ǥ�</td>" + name + "</tr></table><table width=100% >" + "<tr style='line-height = 1.5cm;'>" + ayearSms + crsName + "</tr>"
							+ "<tr style='line-height = 1.5cm;'><td colspan='4' style='font-size=24pt;font-family:�з���;letter-spacing = 0.07cm;text-align:justify;text-justify:distribute-all-lines;text-align-last:justify;'>���Z�u�}" + tmpstr1 + ((Hashtable) vt.get(i)).get("STNO_ASYS_NAME") + "���ղ�" + toChanisesFullChar(String.valueOf(Integer.parseInt((String) ((Hashtable) vt.get(i)).get("RANK")))) + "�W����ų\</td></tr>"
							+ "<tr style='line-height = 1.5cm;'><td colspan='4' style='font-size=24pt;font-family:�з���;letter-spacing = 0.07cm;'>�S�{�����H�깪�y </td></tr>";

				} else if (rank.equals("4")) {
					contentHtml += "<table width=100% ><tr style='line-height = 1.5cm; style='font-size=22pt;'>" + centerName + "<td style='font-size=22pt;font-family:�з���;'>" + ((Hashtable) vt.get(i)).get("STNO_ASYS_NAME") + "�ǥ�</td>" + name + "</tr></table><table width=100% >" + "<tr style='line-height = 1.5cm;'>" + ayearSms + crsName + "</tr>"
							+ "<tr style='line-height = 1.5cm;'><td colspan='4' style='font-size=24pt;font-family:�з���;letter-spacing = 0.07cm;text-align:justify;text-justify:distribute-all-lines;text-align-last:justify;'>���Z�u�}" + tmpstr1 + toChanisesFullChar(String.valueOf(Integer.parseInt((String) ((Hashtable) vt.get(i)).get("RANK")))) + "�W����ų\</td></tr>" + "<tr style='line-height = 1.5cm;'><td colspan='4' style='font-size=24pt;font-family:�з���;letter-spacing = 0.07cm;'>�S�{�����H�깪�y </td></tr>";

				}

				String ayear = Utility.checkNull(content.get("PRNYEAR"), "");
				String month = Utility.checkNull(content.get("PRNMONTH"), "");
				String day = Utility.checkNull(content.get("PRNDAY"), "");
				System.out.println("ayear=" + ayear);
				if (ayear.length() > 0 && ayear.charAt(0) == '0')
					ayear = ayear.substring(1);
				if (month.length() > 0 && month.charAt(0) == '0')
					month = month.substring(1);
				if (day.length() > 0 && day.charAt(0) == '0')
					day = day.substring(1);
				contentHtml += addSpace + "<tr><td colspan='4' class=space2>�@</td></tr>" + "<tr><td colspan='4' align=left valign=top class=down>&nbsp;��&nbsp;��&nbsp;��&nbsp;��&nbsp;&nbsp;" + toChanisesFullChar(ayear) + "&nbsp;&nbsp;�~&nbsp;&nbsp;" + toChanisesFullChar(month) + "&nbsp;&nbsp;��&nbsp;" + toChanisesFullChar(day) + "&nbsp;&nbsp;��</td></tr>" + "</table>";

				rptFile.add(contentHtml);
				rptFile.add("<!--" + i + "-->");
			}

			if (rptFile.size() == 0) {
				out.println("<script>top.close();alert(\"�L�ŦX��ƥi�ѦC�L!!\");window.close();</script>");
				return;
			}

			/** ��l�Ƴ����� */
			report report_ = new report(dbManager, conn, out, "scd216q_01r1", report.onlineHtmlMode);

			/** �R�A�ܼƳB�z */
			Hashtable ht = new Hashtable();
			report_.setDynamicVariable(ht);

			/** �}�l�C�L */
			report_.genReport(rptFile);
		} catch (Exception ex) {
			throw ex;
		} finally {
			dbManager.close();
		}
	}

	//�N�m�W�ন�ҭn��ܪ��榡
	private String getNameStyle(String name) {
		String result = name;

		// �m�W2-8�Ӧr
		int nameLength = name.length();
		if (nameLength <= 5)
			result = "<td width=28% align='center' colspan='2' style='font-size=24pt;font-family:�з���;letter-spacing = 0.02cm;'>" + name + "</td>";
		else if (nameLength == 6)
			result = "<td width=28% colspan='2' style='font-size=18pt;font-family:�з���;letter-spacing = 0.02cm;text-align:justify;text-justify:distribute-all-lines;text-align-last:justify;'>" + name + "</td>";
		else if (nameLength == 7)
			result = "<td width=28% colspan='2' style='font-size=17pt;font-family:�з���;letter-spacing = 0.02cm;text-align:justify;text-justify:distribute-all-lines;text-align-last:justify;'>" + name + "</td>";
		else if (nameLength > 7)
			result = "<td width=28% colspan='2' style='font-size=15pt;font-family:�з���;letter-spacing = 0.02cm;text-align:justify;text-justify:distribute-all-lines;text-align-last:justify;'>" + name + "</td>";

		return result;
	}

	//�N�����ন�ҭn��ܪ��榡
	private String getCenterNameStyle(String centerName) {
		String result = centerName;

		int centerNameLength = centerName.length();
		if (centerNameLength <= 8)
			result = "<td style='font-size=23pt;font-family:�з���;letter-spacing = 0.01cm;text-align:justify;text-justify:distribute-all-lines;text-align-last:justify;'>" + centerName + "</td>";
		// �x�_�ĤG�ǲ߫��ɤ���<====�w�g�ܦ� �x�_(�G)�ǲ߫��ɤ��� ���A�έ쥻���r����׵���10   20090519  by barry
		//�令���פj��8�N�ΤU����style    20090519  by barry
		else
			result = "<td style='font-size=20pt;font-family:�з���;letter-spacing = 0.01cm;text-align:justify;text-justify:distribute-all-lines;text-align-last:justify;'>" + centerName + "</td>";

		return result;
	}

	//�N��ئW���ন�ҭn��ܪ��榡
	private String getCrsrNameStyle(String crsName) {
		String result = crsName;

		// �W�L20�Ӧr�h�����20�Ӧr(�t��r�@21�Ӧr)
		crsName = crsName.length() > 21 ? crsName.substring(0, 21) : crsName;

		int crsNameLength = this.caluateStringLength(crsName); // �]�^��r���e�שM����r�e�רä��ۦP,�]���b��r����ܪ��ɭԷ|�����D,�γo��method�Ӳʲ�����i�H��h�֤��^��r
		if (crsNameLength <= 6)
			result = "<td align='center' colspan='2' style='font-size=24pt;font-family:�з���;'>" + crsName + "</td><td width='6%' style='font-size=24pt;font-family:�з���;'>��</td>";
		else if (crsNameLength == 7)
			result = "<td align='center' colspan='2'><font style='font-size:23pt;font-family:�з���;'>" + crsName + "</font></td><td width='6%' style='font-size=24pt;font-family:�з���;'>��</td>";
		else if (crsNameLength == 8)
			result = "<td align='center' colspan='2'><font style='font-size:20pt;font-family:�з���;'>" + crsName + "</font></td><td width='6%' style='font-size=24pt;font-family:�з���;'>��</td>";
		else if (crsNameLength == 9)
			result = "<td align='center' colspan='2'><font style='font-size:18pt;font-family:�з���;'>" + crsName + "</font></td><td width='6%' style='font-size=24pt;font-family:�з���;'>��</td>";
		else if (crsNameLength == 10)
			result = "<td align='center' colspan='2'><font style='font-size:16pt;font-family:�з���;'>" + crsName + "</font></td><td width='6%' style='font-size=24pt;font-family:�з���;'>��</td>";
		else if (crsNameLength == 11)
			result = "<td align='center' colspan='2'><font style='font-size:14pt;font-family:�з���;'>" + crsName + "</font></td><td width='6%' style='font-size=24pt;font-family:�з���;'>��</td>";
		else if (crsNameLength == 12)
			result = "<td align='center' colspan='2'><font style='font-size:13pt;font-family:�з���;'>" + crsName + "</font></td><td width='6%' style='font-size=24pt;font-family:�з���;'>��</td>";
		else if (crsNameLength == 13)
			result = "<td align='center' colspan='2'><font style='font-size:12pt;font-family:�з���;'>" + crsName + "</font></td><td width='6%' style='font-size=24pt;font-family:�з���;'>��</td>";
		else if (crsNameLength == 14)
			result = "<td align='center' colspan='2'><font style='font-size:11pt;font-family:�з���;'>" + crsName + "</font></td><td width='6%' style='font-size=24pt;font-family:�з���;'>��</td>";
		else if (crsNameLength == 15 || crsNameLength == 16)
			result = "<td align='center' colspan='2'><font style='font-size:10pt;font-family:�з���;'>" + crsName + "</font></td><td width='6%' style='font-size=24pt;font-family:�з���;'>��</td>";
		else if (crsNameLength == 17 || crsNameLength == 18)
			result = "<td align='center' colspan='2'><font style='font-size:9pt;font-family:�з���;'>" + crsName + "</font></td><td width='6%' style='font-size=24pt;font-family:�з���;'>��</td>";
		else if (crsNameLength == 19 || crsNameLength == 20)
			result = "<td align='center' colspan='2'><font style='font-size:8pt;font-family:�з���;'>" + crsName + "</font></td><td width='6%' style='font-size=24pt;font-family:�з���;'>��</td>";

		return result;
	}

	//�N�Ǧ~���ন�ҭn��ܪ��榡
	private String getYearSmsStyle(String yearSms) {
		String result = yearSms;

		int yearSmsLength = yearSms.length();
		if (yearSmsLength <= 8)
			result = "<td  style='font-size=24pt;font-family:�з���;letter-spacing = 0.05cm;text-align:justify;text-justify:distribute-all-lines;text-align-last:justify;'>" + yearSms + "</td>";
		// �~�צp��100�~��,�h���r��̦h��9�Ӧr
		else if (yearSmsLength == 9)
			result = "<td  style='font-size=24pt;font-family:�з���;letter-spacing = 0.05cm;text-align:justify;text-justify:distribute-all-lines;text-align-last:justify;'>" + yearSms + "</td>";

		return result;
	}

	//�P�_�r�ꪺ����(2�ӭ^��r��1�Ӫ���,1�Ӥ���r��1�Ӫ���)
	private int caluateStringLength(String string) {
		int result = 0;

		char[] stringArray = string.toCharArray();
		int notChineseCount = 0; // �Ӧr��@���h�֫D����r
		for (int i = 0; i < stringArray.length; i++) {
			// ��ܬ��^��--�ʲ����P�_
			if (stringArray[i] < 200)
				notChineseCount++;
			else
				result++;
		}

		return result + (int) Math.ceil(notChineseCount / 2.2);
	}

	/** �ন��������r */
	public static String toChanisesFullChar(String s) {
		if (s == null || s.equals("")) {
			return "";
		}

		char[] ca = s.toCharArray();
		for (int i = 0; i < ca.length; i++) {
			if (ca[i] > '\200') {
				continue;
			} //�W�L�o�����ӳ��O����r�F�K
			if (ca[i] == 32) {
				ca[i] = (char) 12288;
				continue;
			} //�b���ť��ন�����ť�
			if (Character.isLetterOrDigit(ca[i])) {
				ca[i] = (char) (ca[i] + 65248);
				continue;
			} //�O���w�q���r�B�Ʀr�βŸ�

			ca[i] = (char) 12288; //�䥦���X�n�D���A�����ন�����ťաC
		}

		return String.valueOf(ca);
	}%>