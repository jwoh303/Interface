<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.*"%> 
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%
    /* ============================================================================== */
    /* =   환경 설정 파일 Include                                                   = */
    /* = -------------------------------------------------------------------------- = */
    /* =   ※ 필수                                                                  = */
    /* =   테스트 및 실결제 연동시 site_conf_inc.jsp 파일을 수정하시기 바랍니다.    = */
    /* = -------------------------------------------------------------------------- = */
%>
<%@ include file="../cfg/site_conf_inc.jsp" %>
<%
	request.setCharacterEncoding ( "utf-8" ) ;
    /* = -------------------------------------------------------------------------- = */
    /* =   환경 설정 파일 Include END                                               = */
    /* ============================================================================== */
%> 
<%

	//셋팅 파라메타
	String item_name = CommonUtil.nvl((String)request.getParameter("st_item_name"),"");
	String tot_price = CommonUtil.nvl((String)request.getParameter("nu_tot_price"),"");
	String user_id = CommonUtil.nvl((String)request.getParameter("st_user_id"),"");
	String user_name = CommonUtil.nvl((String)request.getParameter("st_user_name"),"");
	String email = CommonUtil.nvl((String)request.getParameter("st_email"),"");
	String tel_no = CommonUtil.nvl((String)request.getParameter("st_tel_no"),"");
	String mobile_no = CommonUtil.nvl((String)request.getParameter("st_mobile_no"),"");

%>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml" >

<head>
    <title>한국사이버결제 플러그인 설치 페이지</title>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta http-equiv="Cache-Control" content="no-cache"/>
    <meta http-equiv="Expires" content="0"/>
    <meta http-equiv="Pragma" content="no-cache"/>
    <link rel="stylesheet" href="css/sample.css" type="text/css" />

    <script type="text/javascript" src="http://pay.kcp.co.kr/plugin/payplus.js"></script>

    <script type="text/javascript">
	StartSmartUpdate();

	function  jsf__chk_plugin()
	{
		// IE 일경우 기존 로직을 타게끔
		if ((navigator.userAgent.indexOf('MSIE') > 0) || (navigator.userAgent.indexOf('Trident/7.0') > 0))
		{
			if ( document.Payplus.object != null )
			{
//				window.location = "order.jsp";///swf
				document.forms[0].target="_self";
				document.forms[0].method="post";
				document.forms[0].action="order.jsp";
				document.forms[0].submit();
			}
		}
		// 그 외 브라우져에서는 체크로직이 변경됩니다.
		else
		{
			var inst = 0;
			for (var i = 0; i < navigator.plugins.length; i++)
			{
				if (navigator.plugins[i].name == "KCP")
				{
					inst = 1;
				}		
			}

			if (inst == 1)
			{
//				window.location = "order.jsp";
				document.forms[0].target="_self";
				document.forms[0].method="post";
				document.forms[0].action="order.jsp";
				document.forms[0].submit();
			}
			else
			{
				document.location.href=GetInstallFile();
			}
		}

	}
    </script>

    <script type="text/javascript">
    	setTimeout("jsf__chk_plugin()","1000");
    </script>
</head>

<body>
<div align="center">
<form name="order_info" method="post">
    <input type="hidden" name="st_item_name" value="<%=item_name%>" />
    <input type="hidden" name="st_tot_price" value="<%=tot_price%>" />
    <input type="hidden" name="st_user_id" value="<%=user_id%>" />
    <input type="hidden" name="st_user_name" value="<%=user_name%>" />
    <input type="hidden" name="st_email" value="<%=email%>" />
    <input type="hidden" name="st_tel_no" value="<%=tel_no%>" />
    <input type="hidden" name="st_mobile_no" value="<%=mobile_no%>" />
	<!-- 구매대행 주문화면에서 넘어오는 파라미터swf  -->
<%
     String po_create_date    = CommonUtil.nvl((String)request.getParameter("st_po_create_date"),"");
    String gr_flag           = CommonUtil.nvl((String)request.getParameter("st_gr_flag"),"");
//    String tel_no              = buyr_tel1;//CommonUtil.nvl((String)request.getParameter("st_tel_no"),"");
    String fax_no              = CommonUtil.nvl((String)request.getParameter("st_fax_no"),"");
//    String user_name           = buyr_name;//CommonUtil.nvl((String)request.getParameter("st_user_name"),"");
//    String email               = buyr_mail;//CommonUtil.nvl((String)request.getParameter("st_email"),"");
    String query_cart          = CommonUtil.nvl((String)request.getParameter("st_query_cart"),"");
    String recv_date2          = CommonUtil.nvl((String)request.getParameter("st_recv_date2"),"");
    String st_query_cart_date          = CommonUtil.nvl((String)request.getParameter("st_query_cart_date"),"");

    String remark              = CommonUtil.nvl((String)request.getParameter("st_remark"),"");
    String location_name       = CommonUtil.nvl((String)request.getParameter("st_location_name"),"");
    String location_code       = CommonUtil.nvl((String)request.getParameter("st_location_code"),"");
    String purchase_dept_name  = CommonUtil.nvl((String)request.getParameter("st_purchase_dept_name"),"");
    String purchase_dept_code  = CommonUtil.nvl((String)request.getParameter("st_purchase_dept_code"),"");
    String GW_NO               = CommonUtil.nvl((String)request.getParameter("GW_NO"),"");
    String recvFlag            = CommonUtil.nvl((String)request.getParameter("recvFlag"),"");
    String account_type        = CommonUtil.nvl((String)request.getParameter("st_account_type"),"");
    String hongik_type           = CommonUtil.nvl((String)request.getParameter("st_hongik_type"),"");
    
    String st_person_author           = CommonUtil.nvl((String)request.getParameter("st_person_author"),"");
    
    
%>
	<input type="hidden" name="st_po_create_date" value="<%=po_create_date%>">
	<input type="hidden" name="st_gr_flag" value="<%=gr_flag %>">
	<input type="hidden" name="st_fax_no" value="<%=fax_no %>">
	<input type="hidden" name="st_query_cart" value="<%=query_cart %>">
	<input type="hidden" name="st_recv_date2" value="<%=recv_date2 %>">
	<input type="hidden" name="st_query_cart_date" value="<%=st_query_cart_date %>">
	<input type="hidden" name="st_remark" value="<%=remark %>">
	<input type="hidden" name="st_location_name" value="<%=location_name %>">
	<input type="hidden" name="st_location_code" value="<%=location_code %>">
	<input type="hidden" name="st_purchase_dept_name" value="<%=purchase_dept_name %>">
	<input type="hidden" name="st_purchase_dept_code" value="<%=purchase_dept_code %>">
	<input type="hidden" name="GW_NO" value="<%=GW_NO %>">
	<input type="hidden" name="recvFlag" value="<%=recvFlag %>">
	<input type="hidden" name="st_account_type" value="<%=account_type %>">
	<input type="hidden" name="st_hongik_type" value="<%=hongik_type %>">
 	<input type="hidden" name="st_person_author" value="<%=st_person_author %>">
 
 
	<table style="width:600px"  >
	    <tr>
	        <td><img src="/module/kcp/sample/img/kcp_plug_img01.gif" width="600" height="84" alt=""/></td>
	    </tr>
	    <tr>
	        <td style="background-image:url('/module/kcp/sample/img/kcp_plug_bg01.gif');">
	            <table style="width:550;text-align:center">
	            <tr>
	                <td height="50" colspan="2" align="center" >고객님의 안전한 결제를 위해 결제 정보를 암호화하는 프로그램을 확인(설치)하는 중입니다.</td>
	            </tr>
	            <tr>
	                <td height="60" colspan="2" align="center" valign="top"><img src="/module/kcp/sample/img/kcp_ing.gif" style="width:481px;height:31px;" alt=""/></td>
	            </tr>
	            <tr>
	                <td colspan="2" style="padding-left:50px;text-align:left;">
	                    1. 페이지 상단의 알림표시줄이 나타났을 경우 알림표시줄에서 마우스 오른쪽 버튼을 눌러 <br />
	                    <span class="red bold">"ActiveX 컨트롤 설치"</span>를 선택하여 주십시오. <br />
	                    2. <u>보안경고 창이 나타나면 <span class="red bold">"설치"</span> 또는 <span class="red bold">"예"</span> 버튼을 눌러
	                    설치를 진행하여 주십시오.</u> <br />
	                    &nbsp;&nbsp;&nbsp;통신 환경에 따라 2-3초에서 수분이 걸릴수도 있습니다. <br />
	                </td>
	            </tr>
	            <tr>
	                <td height="30" colspan="2" align="center"><img src="/module/kcp/sample/img/kcp_plug_img02.gif" style="width:530px;height:11px;" alt="" /></td>
	            </tr>
	            <tr>
	                <td width="153" rowspan="2" align="center"><img src="/module/kcp/sample/img/kcp_plug_img03.gif" style="width:103px;height:97px;" alt="" /></td>
	                <td style="width:397px;height:30px;text-align:left;"><img src="/module/kcp/sample/img/kcp_plug_img04.gif" style="width:14px;height:14px" alt="" />
	                    <span class="bold">프로그램이 자동으로 설치가 되지 않는 경우</span>
	                </td>
	            </tr>
	            <tr>
    	            <td style="text-align:left;">
	                    1. <a href="http://pay.kcp.co.kr/plugin/file_vista/PayplusWizard.exe"><span class="red bold">이곳</span></a>을 눌러
	                    설치 파일을 다운로드하여 주십시오.<br />
	                    2. 다운받은 프로그램을 실행하시면 설치가 진행됩니다.<br />
	                    3. 설치가 완료된 후 키보드의 &quot;F5&quot; 버튼을 눌러 새로고침을 하면<br />
	                    &nbsp;&nbsp;&nbsp;다음 결제 페이지로 이동합니다.
	                </td>
	            </tr>
	            </table>
    	    </td>
	    </tr>
	    <tr>
	        <td><img src="/module/kcp/sample/img/kcp_plug_img05.gif" width="600" height="20" alt="" /></td>
	    </tr>
	</table>
</form>
</div>
</body>
</html>
