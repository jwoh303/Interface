<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!doctype html>
<html>
<head>
<%
	String com_code =  CommonUtil.nvl((String) request.getParameter("com_code"), "");
	String type =  CommonUtil.nvl((String) request.getParameter("type"), "");
%>
<meta http-equiv="X-UA-Compatible" content="IE=Edge;" />
</head>
<body>
		<div class="wrap">
			<!-----------------------------------------------------------------------------------------------header------------------------------------------------------------------------------------------------------->
			<%@ include file="/WEB-INF/views/common/include/2016/mainHeader.jsp"%>
			<!-----------------------------------------------------------------------------------------------header------------------------------------------------------------------------------------------------------->
    <!--컨텐츠-->
    <div class="subcontentsArea">
    	<div class="subbanner" >
        	 
            <div class="subbannerimg"><img src="/resources/images/2016/SB22.jpg" /></div>
            <div class="subbannertxt" > 
            	<p class="sbtit">회원가입 완료</p>
            	<p>KeP서비스 이용을 통해 경쟁력을 높여 보세요</p>
            </div>
            <div class="subbannerbg" ></div>
        </div>
        <div class="subtab">
        	<div class="subtabBg"></div>
            <div class="subtabList04">
            	<ul>
                    <a href="javascript:MovePage_2016('<%=httpurl%>','03', '01');"><li>FAQ</li></a><a href="javascript:MovePage_2016('<%=httpurl%>','03', '02');"><li>업무처리 프로세스</li></a><a href="javascript:MovePage_2016('<%=httpurl%>','04', '01');"><li>신규협력사 가입안내</li></a><a href="javascript:MovePage_2016('<%=httpurl%>','04', '02');"><li  class="subtabOn">회원가입하기</li></a><a href="javascript:MovePage_2016('<%=httpurl%>','04', '03');"><li>계약서류 다운로드</li></a>
                </ul>  
            </div>
        </div>
		<div class="subcontent">
        	<div class="sub04_join">
                <p class="subcontentTit" >회원가입 완료</p>
                Koreab2b.com 회원가입을 환영합니다. <br/><br/>
                <div class="idpwSearch" style="height:540px"><br/>
                    <img src="/resources/images/2016/img26.png" /><br/> 
						<% if (type.equals("U")) { %>
						<b>사용자 등록이 완료 되었습니다.</b><br /><br />
						<% } else if (type.equals("B")) { %>
						<b>고객사 등록<span class="FontRed">(<%=com_code%>)</span> 및 사용자 등록이 완료 되었습니다.</b><br /><br />
						<% } else if (type.equals("S")) { %>
						<b>협력사 등록<span class="FontRed">(<%=com_code%>)</span> 및 사용자 등록이 완료 되었습니다.</b><br /><br />
						<% } %>
                    	인터넷 전자상거래 업체의 최고를 추구하는 KeP(www.koreab2b.com)에 회원가입 하신 것을 진심으로 감사드리며, <br/>별도의 연락을 드린 후 소정의 회원승인 심사 기간을 거쳐 승인이 이루어 집니다. <br/><br/>
                    	<b>최종승인 전 전자계약이 발송되며, 전자계약 진행 시에는 인증서가 필요합니다.</b><br/><br/>
                    	기업용 인증서(범용/용도제한)를 보유한 기업의 경우 해당 인증서로 계약을 진행할 수 있으며,<br/>
                    	미발급 기업인 경우 범용인증서나 KEP 전용 인증서를 발급 받은 후 계약이 진행됨을 알려드립니다.<br/><br/>
                    	관련한 문의사항은 (Tel:02-3016-7251) 으로 연락바랍니다.<br/>
                    	고객서비스 향상에 더욱 충실한 KeP가 될 것이며 회원가입 하심에 대해 다시 한번 감사드립니다.  <br/><br/><br/><br/>
                    <div class="joinBtn" ><a href="/main.do">확인</a> </div>
                </div>
            </div>
        </div>
    </div>
    <!--컨텐츠 끝-->
			<!------------------------------------------------------------------------------------------------footer-------------------------------------------------------------------------------------------------------------->
			<%@ include file="/WEB-INF/views/common/include/2016/mainFooter.jsp"%>
			<!------------------------------------------------------------------------------------------------footer-------------------------------------------------------------------------------------------------------------->
		</div>
</body>
<script type="text/javascript">
<% if (type.equals("S")) { %>
	alert("공급사등록("+ "<%=com_code%>" +")이 정상적으로 이루어 졌습니다.");
<% } %>
</script>
</html>

