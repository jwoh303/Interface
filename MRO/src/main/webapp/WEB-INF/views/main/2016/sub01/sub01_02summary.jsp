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
            <div class="subbannerimg"><img src="/resources/images/2016/SB03.jpg" /></div>
            <div class="subbannertxt" > 
            	<p class="sbtit">개요</p>
            	<p>B2B시장의 플랫폼 비즈니스 리더</p>
            </div>
            <div class="subbannerbg" > </div>
        </div>
        <div class="subtab">
        	<div class="subtabBg"></div>
            <div class="subtabList01">
            	<ul>
            		<a href="javascript:MovePage_2016('<%=httpurl%>','01', '01');"><li>CEO메시지</li></a><a href="javascript:MovePage_2016('<%=httpurl%>','01', '02');"><li class="subtabOn">개요</li></a><a href="javascript:MovePage_2016('<%=httpurl%>','01', '03');"><li>연혁</li></a><a href="javascript:MovePage_2016('<%=httpurl%>','01', '04');"><li>비전</li></a><a href="javascript:MovePage_2016('<%=httpurl%>','01', '06');"><li>공고</li></a><a href="http://www.ekdp.com/ethics/main/main.asp" target="_blank"><li>윤리경영</li></a><a href="javascript:MovePage_2016('<%=httpurl%>','01', '05');"><li>오시는길</li></a>
                </ul>   
            </div>
        </div>
        <div class="subcontent">
            <div class="sub01_01summary">
            	코리아e플랫폼은 IT와 물류인프라를 기반으로 MRO구매대행 서비스를 제공하는 B2B전문기업입니다.<br/>
                고객사에게는 전자조달 실현 및  아웃소싱을 통한 구매비용 절감을 제공하며<br/> 협력사에게는 새로운 시장 진출의 기회를 제공하고 있습니다.<br/><br/><br/><br/>
                <span style="font-size:45px; line-height:65px; height:60px; font-weight:bold; color:#ee3212">코리아e플랫폼 주식회사</span><br/>
                <span style="font-size:20px; line-height:20px; height:30px; font-weight:bold">Korea e Platform Co.Ltd.</span><br/><br/>
                <div style="position:relative; background-image:url(/resources/images/2016/bg01.gif); width:708px; height:285px; margin:0 auto ; ">
                    <p class="subcontentTit" style="position:absolute; width:80px; top:100px; left:100px" >업종</p>
                    <p class="subcontentTxt02" style="position:absolute; top:170px; left:77px" >인터넷 전자상거래</p>
                    <p class="subcontentTit" style="position:absolute; width:80px; top:100px; left:315px" >설립일</p>
                    <p class="subcontentTxt02" style="position:absolute; top:170px; left:295px" >2000년 6월 27일</p>
                    <p class="subcontentTit" style="position:absolute; width:150px; top:100px; left:493px" >자기자본</p>
                    <p class="subcontentTxt02" style="position:absolute; top:170px; left:493px" >65,075백만원(23년)</p>
                </div>
                <div style="position:relative; margin-top:90px; margin-bottom:90px ">
                    <p class="subcontentTit" >주주사</p>
                    <p class="subcontentTxt02" >광동제약, HDC주식회사, SK네트웍스 등 9개 회사</p><br/><br/><br/><br/><br/><br/>
                    <p class="subcontentTit" >연락처</p>
                    <p class="subcontentTxt02" >서울특별시 강남구 개포로 619 서울강남우체국빌딩 7층 코리아e플랫폼<br/>TEL : 02-3016-8989<br/>FAX : 02-569-6724</p>
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

