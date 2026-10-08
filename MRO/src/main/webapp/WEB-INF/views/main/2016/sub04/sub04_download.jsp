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
        	 
            <div class="subbannerimg"><img src="/resources/images/2016/SB17.jpg" /></div>
            <div class="subbannertxt" > 
            	<p class="sbtit">계약서류 다운로드</p>
            	<p>KeP서비스 이용을 통해 경쟁력을 높여 보세요</p>
            </div>
            <div class="subbannerbg" ></div>
        </div>
        <div class="subtab">
        	<div class="subtabBg"></div>
            <div class="subtabList04">
            	<ul>
                    <a href="javascript:MovePage_2016('<%=httpurl%>','03', '01');"><li>FAQ</li></a><a href="javascript:MovePage_2016('<%=httpurl%>','03', '02');"><li>업무처리 프로세스</li></a><a href="javascript:MovePage_2016('<%=httpurl%>','03', '07');"><li>구매대행 도입문의</li></a><a href="javascript:MovePage_2016('<%=httpurl%>','04', '01');"><li>신규협력사 가입안내</li></a><a href="javascript:MovePage_2016('<%=httpurl%>','04', '02');"><li>회원가입하기</li></a><a href="javascript:MovePage_2016('<%=httpurl%>','04', '03');"><li class="subtabOn">계약서류 다운로드</li></a>
                </ul>  
            </div>
        </div>
		<div class="subcontent">
        	<div class="sub04_join">
                <p class="subcontentTit" >협력업체 등록</p>
                <table  class="jointable01" style="margin-bottom:100px;">
                   <tr>
                        <th >구매카드 사용안내 </th>
                        <td align="left" ><a href="/resources/excel/work/MAIN/E-bondUse.zip">- 전자채권(구매카드)사용안내 [MS_WORD]</a></td>
                    </tr>
                 </table>
                <p class="subcontentTit" >전자입찰 역경매참여 협력업체 등록</p>
                <table  class="jointable01" style="margin-bottom:100px;">
                    <tr>
                        <th width="30%">전자입찰 역경매참여 협력업체 등록</th>
                        <td width="70%" align="left" >
                        	<a href="/resources/excel/work/MAIN/ebasiccontractbid_doc.zip">- 기본계약서 [MS_WORD]</a><br/>
                          	<a href="/resources/excel/work/MAIN/ebasiccontractbid_hwp.zip">- 기본계약서 [아래한글]</a>
                        </td>
                    </tr>
                 </table>
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

