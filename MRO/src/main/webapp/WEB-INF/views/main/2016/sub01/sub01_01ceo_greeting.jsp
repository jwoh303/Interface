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
        	 
            <div class="subbannerimg"><img src="/resources/images/2016/SB01.jpg" /></div>
            <div class="subbannertxt" > 
            	<p class="sbtit">CEO메시지</p>
            	<p>B2B시장의 플랫폼 비즈니스 리더</p>
            </div>
            <div class="subbannerbg" > </div>
        </div>
        <div class="subtab">
        	<div class="subtabBg"></div>
            <div class="subtabList01">
            	<ul>
            		<a href="javascript:MovePage_2016('<%=httpurl%>','01', '01');"><li class="subtabOn">CEO메시지</li></a><a href="javascript:MovePage_2016('<%=httpurl%>','01', '02');"><li>개요</li></a><a href="javascript:MovePage_2016('<%=httpurl%>','01', '03');"><li>연혁</li></a><a href="javascript:MovePage_2016('<%=httpurl%>','01', '04');"><li>비전</li></a><a href="javascript:MovePage_2016('<%=httpurl%>','01', '06');"><li>공고</li></a><a href="http://www.ekdp.com/ethics/main/main.asp" target="_blank"><li>윤리경영</li></a><a href="javascript:MovePage_2016('<%=httpurl%>','01', '05');"><li>오시는길</li></a>
                </ul>   
            </div>
        </div>
        <div class="subcontent">
            <div style=" position:relative; height:960px; background-color:#eeeeee; padding:100px 90px 90px 90px;  font-size:17px; letter-spacing:-0.5px; line-height:27px; background-image:url(/resources/images/2016/ceo_BG.jpg)"> 
                <p style="font-size:30px; font-weight:800">안녕하십니까?</p><br/><br/>
                MRO 서비스가 도입된 2000년대 초반만 해도 국내기업들에게 구매 아웃소싱은 굉장히 낯선 개념이었으나, 지금은 구매 혁신을 추구하는 모든 기업에게 필수적이면서도 매력적인 전략 Tool로 인정받고 있습니다.<br/><br/>
                
                그룹 계열사의 통합구매 조직으로 시작하여 자체 물량으로 성장한 타 MRO 기업과 달리,
                저희 코리아e플랫폼은 B2B 벤처기업으로 출발하여 수주 경쟁이 치열한 비주주 고객사 시장에서 
                뛰어난 성과를 거두면서 독자적으로 성장해 왔습니다.<br/><br/>
                
                탁월한 영업력을 바탕으로 국내 유수의 대기업 그룹을 연속 수주 하였으며, 
                고객 이익을 우선시 하는 마인드와 최적의 협력사 Pool 및 Process 기반의 서비스를
                제공함으로써 고객사가 신뢰 할 수 있는 사업파트너로 자리매김 하고 있습니다.<br/><br/>
                
                이러한 구매대행 서비스의 가치가 고객사에만 한정되는 것은 아닙니다. 당사는 중소 협력사들이
                독자적으로 영업하기 어려운 대기업 고객과의 거래를 연결하여 협력사들의 시장 확대를 지원할 
                뿐만 아니라, 특히 납품대금 회수 관련 위험이 큰 건설시장에서 협력사들에게 안정적인
                자금 결제를 보장함으로써 공급네트워크의 안정성 강화에도 기여하고 있습니다.<br/><br/>
                
                저희 코리아e플랫폼은 지금까지의 성과에 만족하지 않고 구매전문성 강화를 위해 지속적으로
                투자하고 있으며, 맞춤형 IT/물류인프라와 표준화된 상품정보 기반의 차별화된 플랫폼 구축을 
                통해 새로운 고객가치를 제공하고자 끊임없이 노력해 갈 것입니다. <br/><br/>
                
                "B2B 플랫폼 비즈니스 리더" 라는 새로운 Vision을 향한 당사의 거침없는 여정에 많은 관심 부탁드립니다.<br/><br/>
                
                감사합니다. <br/><br/>
                
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

