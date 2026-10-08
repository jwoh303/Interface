<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!doctype html>
<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=Edge;" />
<script type="text/javascript">
</script>
</head>
<body> 
<form id="loginForm" name="loginForm" method="post">
	<div class="wrap" >
		<!-----------------------------------------------------------------------------------------------header------------------------------------------------------------------------------------------------------->
		<%@ include file="/WEB-INF/views/common/include/2016/mainHeader.jsp" %>
		<!-----------------------------------------------------------------------------------------------header------------------------------------------------------------------------------------------------------->
     <!--컨텐츠-->
    <div class="subcontentsArea">
    	<div class="subbanner" >
        	 
            <div class="subbannerimg"><img src="/resources/images/2016/SB24.jpg" /></div>
            <div class="subbannertxt" > 
            	<p class="sbtit">구매대행 도입문의</p>
            	<p>KeP서비스 이용을 통해 경쟁력을 높여 보세요</p>
            </div>
            <div class="subbannerbg" ></div>
        </div>
        <div class="subtab">
        	<div class="subtabBg"></div>
            <div class="subtabList04">
            	<ul>
                    <a href="javascript:MovePage_2016('<%=httpurl%>','03', '01');"><li>FAQ</li></a><a href="javascript:MovePage_2016('<%=httpurl%>','03', '02');"><li>업무처리 프로세스</li></a><a href="javascript:MovePage_2016('<%=httpurl%>','03', '07');"><li class="subtabOn">구매대행 도입문의</li></a><a href="javascript:MovePage_2016('<%=httpurl%>','04', '01');"><li>신규협력사 가입안내</li></a><a href="javascript:MovePage_2016('<%=httpurl%>','04', '02');"><li>회원가입하기</li></a><a href="javascript:MovePage_2016('<%=httpurl%>','04', '03');"><li>계약서류 다운로드</li></a>
                </ul>  
            </div>
        </div>
		<div class="subcontent">
        	<div class="sub04_newcustomer">
            	원가절감 및 구매 프로세스 혁신을 위해  </br>당사와의 거래를 원하는 고객은 아래 연락처로 문의 바랍니다.</br></br></br>
                <p class="subcontentTit" >구매대행 도입 문의</p>
                <table  class="table_newcustomer" style="margin-bottom:100px;">
                   <tr>
                        <th width="100%" height="50px" >전략영업팀 송리군 책임</th>
                    </tr>
                    <tr>
                        <td align="left" >E-메일 : <a href="mailto:ysjung@koreab2b.com"><u>ligun129@koreab2b.com</u></a></br>전화 : 02-3016-7228 </td>
                    </tr>
                 </table>
                <p class="subcontentTit" >협력사 가입 문의</p>
                <table  class="table_newcustomer" style="margin-bottom:100px;">
                	<tr>
                        <th width="100%" height="50px" >박지수 선임</th>
                    </tr>
                    <tr>
                        <td align="left" >E-메일 : <a href="mailto:musenh@koreab2b.com"><u>musenh@koreab2b.com</u></a></br>전화 : 02-3016-7251 </td>
                    </tr>
                 </table>
                <p class="subcontentTit" >구매대행 도입절차</p>
                <div class="newcustomer" style="position:relative; margin-top:30px; margin-bottom:100px; font-size:15px; line-height:20px">
                 <ul>
                  <li class="newcustomer_box"><img src="/resources/images/2016/img30.png"  /></br> 고객 니즈 파악 <p>고객 니즈 파악 및<br> 서비스 방안 제안</p></li>
                  <li style="width:60px; line-height:25px; text-align:center "></br></br><img src="/resources/images/2016/arrow04.png" /></li>
                  <li class="newcustomer_box"><img src="/resources/images/2016/img31.png"  /></br> 거래 조건 합의 <p>거래규모 및 절감율 합의</p></li>
                  <li style="width:60px; line-height:25px; text-align:center "></br></br><img src="/resources/images/2016/arrow04.png" /></li>
                  <li class="newcustomer_box"><img src="/resources/images/2016/img32.png"  /></br> 거래 준비 <p>- 소싱 및 단가확정</br>- 시스템 구축</br>- 계약</p></li>
                  <li style="width:60px; line-height:25px; text-align:center "></br></br><img src="/resources/images/2016/arrow04.png" /></li>
                  <li class="newcustomer_box"><img src="/resources/images/2016/img33.png"  /></br> 거래 개시 <p>거래 개시</p></li>
                 </ul>
                </div> 
            </div>
        </div>
    </div>
    <!--컨텐츠 끝-->
			<!------------------------------------------------------------------------------------------------footer-------------------------------------------------------------------------------------------------------------->
			<%@ include file="/WEB-INF/views/common/include/2016/mainFooter.jsp" %>
			<!------------------------------------------------------------------------------------------------footer-------------------------------------------------------------------------------------------------------------->
	</div>
</form>
</body>
</html>

