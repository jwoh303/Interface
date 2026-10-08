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
<form id="board" name="board" method="post"> 
	<input type="hidden" name="BID" id="BID" value="" />
	<input type="hidden" name="BTYPE" id="BTYPE" value="" />
</form>
<form id="loginForm" name="loginForm" method="post">
	<div class="wrap" >
		<!-----------------------------------------------------------------------------------------------header------------------------------------------------------------------------------------------------------->
		<%@ include file="/WEB-INF/views/common/include/2016/mainHeader.jsp" %>
		<!-----------------------------------------------------------------------------------------------header------------------------------------------------------------------------------------------------------->
    <div class="subcontentsArea">
    	<div class="subbanner" >
        	 
            <div class="subbannerimg"><img src="/resources/images/2016/SB15.jpg" /></div>
            <div class="subbannertxt" > 
            	<p class="sbtit">신규협력사 가입안내</p>
            	<p>KeP서비스 이용을 통해 경쟁력을 높여 보세요</p>
            </div>
            <div class="subbannerbg" ></div>
        </div>
       
        
        
        <div class="subtab">
        	<div class="subtabBg"></div>
            <div class="subtabList04">
            	<ul>
                    <a href="javascript:MovePage_2016('<%=httpurl%>','03', '01');"><li>FAQ</li></a><a href="javascript:MovePage_2016('<%=httpurl%>','03', '02');"><li>업무처리 프로세스</li></a><a href="javascript:MovePage_2016('<%=httpurl%>','03', '07');"><li>구매대행 도입문의</li></a><a href="javascript:MovePage_2016('<%=httpurl%>','04', '01');"><li  class="subtabOn">신규협력사 가입안내</li></a><a href="javascript:MovePage_2016('<%=httpurl%>','04', '02');"><li>회원가입하기</li></a><a href="javascript:MovePage_2016('<%=httpurl%>','04', '03');"><li>계약서류 다운로드</li></a>
                </ul>  
            </div>
        </div>
        
        
		<div class="subcontent">
        	<div class="sub04_join">
            KeP는 다양한 분야에서 협력사와의 상생협력을 통해 제조업 경쟁력 향상에 기여하고 있습니다.</br>
            KeP와 새롭게 거래를 원하는 협력사는 아래로 연락주기시 바랍니다. </br>담당자 : 박지수 선임,&nbsp;&nbsp;  Tel : 02-3016-7251,&nbsp;&nbsp;  E-mail : musenh@koreab2b.com</br></br></br></br>
            <p class="subcontentTit" >협력사 등록절차</p>
             Koreab2b.com사이트를 이용하시려면, 먼저 협력사 등록을 하셔야 합니다.
            <div class="join" style="position:relative; margin-top:30px; margin-bottom:100px; font-size:15px; line-height:20px">
             <ul>
              <li style="background:url(/resources/images/2016/m15.png) center no-repeat; width:120px; height:124px; color:#fff;line-height:20px;font-weight:bold; letter-spacing:0px" ></br></br>협력사 </br>등록절차</li>
              <li style="width:40px; line-height:25px; text-align:center "></br></br><img src="/resources/images/2016/arrow04.png" /></li>
              <li style="background:url(/resources/images/2016/m05.png) center no-repeat; width:120px; height:124px" ><img src="/resources/images/2016/img16.png" /></br>약관동의</li>
              <li style="width:20px; line-height:25px; text-align:center  "></br></br><img src="/resources/images/2016/arrow10.png" /></li>
              <li style="background:url(/resources/images/2016/m05.png) center no-repeat; width:120px; height:124px" ><img src="/resources/images/2016/img17.png" /></br>협력사  정보입력</li>
              <li style="width:20px; line-height:25px; text-align:center  "></br></br><img src="/resources/images/2016/arrow10.png" /></li>
              <li style="background:url(/resources/images/2016/m05.png) center no-repeat; width:120px; height:124px" ><img src="/resources/images/2016/img18.png" /></br>업체운영자</br> 정보입력</li>
              <li style="width:20px; line-height:25px; text-align:center  "></br></br><img src="/resources/images/2016/arrow10.png" /></li>
              <li style="background:url(/resources/images/2016/m05.png) center no-repeat; width:120px; height:124px" ><img src="/resources/images/2016/img19.png" /></br>서류송부</li>
              <li style="width:20px; line-height:25px; text-align:center  "></br></br><img src="/resources/images/2016/arrow10.png" /></li>
              <li style="background:url(/resources/images/2016/m05.png) center no-repeat; width:120px; height:124px" ><img src="/resources/images/2016/img20.png" /></br>서류검토 후 송부</li>
              <li style="width:20px; line-height:25px; text-align:center  "></br></br><img src="/resources/images/2016/arrow10.png" /></li>
              <li style="background:url(/resources/images/2016/m05.png) center no-repeat; width:120px; height:124px" ><img src="/resources/images/2016/img21.png" /></br>등록정보</li>
             </ul>
            </div>
            <div class="join" style="position:relative; margin-top:30px; margin-bottom:120px; font-size:15px; line-height:20px"">
             <ul>
              <li style="background:url(/resources/images/2016/m15.png) center no-repeat; width:120px; height:124px; color:#fff;line-height:20px;font-weight:bold;letter-spacing:0px" ></br></br>사용자 </br>등록절차</li>
              <li style="width:40px; line-height:25px; text-align:center "></br></br><img src="/resources/images/2016/arrow04.png" /></li>
              <li style="background:url(/resources/images/2016/m05.png) center no-repeat; width:120px; height:124px" ><img src="/resources/images/2016/img17.png" /></br>협력사 찾기</li>
              <li style="width:20px; line-height:25px; text-align:center  "></br></br><img src="/resources/images/2016/arrow10.png" /></li>
              <li style="background:url(/resources/images/2016/m05.png) center no-repeat; width:120px; height:124px" ><img src="/resources/images/2016/img16.png"  /></br>약관동의</li>
              <li style="width:20px; line-height:25px; text-align:center  "></br></br><img src="/resources/images/2016/arrow10.png" /></li>
              <li style="background:url(/resources/images/2016/m05.png) center no-repeat; width:120px; height:124px" ><img src="/resources/images/2016/img23.png" /></br>회원가입</li>
              <li style="width:20px; line-height:25px; text-align:center  "></br></br><img src="/resources/images/2016/arrow10.png" /></li>
              <li style="background:url(/resources/images/2016/m05.png) center no-repeat; width:120px; height:124px" ><img src="/resources/images/2016/img24.png" /></br>회원승인 </br> (업체운영자)</li>
             </ul>
            </div>
            <p class="subcontentTit" >신용평가서 발급안내</p>
            당사는 공정하고 투명한 협력사 운영관리 및 거래 안정성 확보를 위하여, </br>신용평가 전문기관에서 발급된 전자 신용인증서를 제출 받아 협력사별 평가 자료로 활용하고 있습니다. </br>
            신규 협력사는 신용평가서를 온라인으로 제출해야 승인 및 등록완료가 가능합니다.</br></br>
            <div class="join01Btn" style="margin-bottom:90px"><a href="/resources/excel/work/MAIN/Credit_Certificate_issued_notices.zip">신용평가서 발급안내 - Down Load </a></div></br></br>
            
           
            <p class="subcontentTit" >업체등록시 제출 서류</p>
            <table  class="jointable" style="margin-bottom:120px;">
                <tr>
                    <th width="20%">제출서류</th>
                    <td align="left"width="80%">
                    - 물품거래기본계약서 전자계약 체결</br>
                    - 전자계약시 업로드 할 첨부서류</br>
                    &nbsp;&nbsp;1. 사업자등록증 1부</br>
                    &nbsp;&nbsp;2. 거래통장 사본(법인 또는 대표자명의) 1부</br>
                    ▶ 전자계약 Site : 모두싸인</br>
                    </td>
                </tr>
             </table>
            </div>
          
        </div>

        
    </div>
			<!------------------------------------------------------------------------------------------------footer-------------------------------------------------------------------------------------------------------------->
			<%@ include file="/WEB-INF/views/common/include/2016/mainFooter.jsp" %>
			<!------------------------------------------------------------------------------------------------footer-------------------------------------------------------------------------------------------------------------->
	</div>
</form>
</body>
</html>

