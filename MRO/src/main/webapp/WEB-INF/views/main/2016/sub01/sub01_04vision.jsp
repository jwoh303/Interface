<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!doctype html>
<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=Edge;" />
</head>
<body> 
	<div class="wrap" >
		<!-----------------------------------------------------------------------------------------------header------------------------------------------------------------------------------------------------------->
		<%@ include file="/WEB-INF/views/common/include/2016/mainHeader.jsp" %>
		<!-----------------------------------------------------------------------------------------------header------------------------------------------------------------------------------------------------------->
   <!--컨텐츠-->
    <div class="subcontentsArea">
    	<div class="subbanner" >
        	 
            <div class="subbannerimg"><img src="/resources/images/2016/SB02.jpg" /></div>
            <div class="subbannertxt" > 
            	<p class="sbtit">비전</p>
            	<p>B2B시장의 플랫폼 비즈니스 리더</p>
            </div>
            <div class="subbannerbg" > </div>
        </div>
        <div class="subtab">
        	<div class="subtabBg"></div>
            <div class="subtabList01">
            	<ul>
            		<a href="javascript:MovePage_2016('<%=httpurl%>','01', '01');"><li>CEO메시지</li></a><a href="javascript:MovePage_2016('<%=httpurl%>','01', '02');"><li>개요</li></a><a href="javascript:MovePage_2016('<%=httpurl%>','01', '03');"><li>연혁</li></a><a href="javascript:MovePage_2016('<%=httpurl%>','01', '04');"><li class="subtabOn">비전</li></a><a href="javascript:MovePage_2016('<%=httpurl%>','01', '06');"><li>공고</li></a><a href="http://www.ekdp.com/ethics/main/main.asp" target="_blank"><li>윤리경영</li></a><a href="javascript:MovePage_2016('<%=httpurl%>','01', '05');"><li>오시는길</li></a>
                </ul>   
            </div>
        </div>
        <div class="subcontent">
            <div class="sub01_01summary">
                <div style="position:relative; margin-bottom:90px ">
                    <p class="subcontentTit" >미션</p>
                    <p style="color:#ee3212; font-weight:bold;font-size:34px;line-height:45px;" >우리는 새로운 가치 창출을 통해<br/> 고객의 경쟁력 향상에 기여한다.</p>
                    <br/>
                    <br/><br/><br/><br/>
                    <p class="subcontentTit" >비전</p>
                    <p style=" font-weight:bold; font-size:34px; height:235px; line-height:45px; color:#ee3212;" >B2B 플랫폼 비즈니스 리더<br/>
                    <img src="/resources/images/2016/img03.gif" /><br/><br/> </p>
                    <p class="subcontentTxt01" >구매전문성, 표준화된 상품정보, IT/물류인프라를 기반으로 한 차별화 플랫폼을 통해<br/>
                    기업고객에게 지속적으로 value를 제공하는 플랫폼 비즈니스 리더로서의 역할을 수행해 나가겠습니다.</p>
                    <br/><br/><br/><br/><br/>
                	<p class="subcontentTit" >핵심역량</p>
                    <table  class="table01">
                        <tr>
                            <th width="30%" >차별적 구매 전문성</th>
                            <td width="70%" align="left" >
                                고객의 기대수준을 뛰어넘는 제품지식, 공급망관리, 가격경쟁력확보를 위해<br/> 
                                고객의 제품/서비스에 대한 Needs를 기반으로, 제조/유통시장을 분석하고 가격/납기/윤리성 등이 우수한 <br/>
                                공급사 Pool을 확보하며, TCO(Total Cost of Ownership)관점의 다양한 구매기법을 활용함.</td>
                        </tr>
                        <tr>
                            <th width="30%" >효율적 운영 리더십</th>
                            <td width="70%" align="left" >
                                저비용, 고효율 구조의 확장 가능한 플랫폼 비즈니스를 구축하기 위해, <br/> 
                                사업 계획, 운영의 기반이 되는 IT운영능력의 고도화를 통해 사업효율을 높이고, 다양한 고객의 니즈 충족과 시장 확장이<br/> 
                                 가능한 효과적 물류네트워크 기반을 마련하여 건설유통모델과 같은 효율적으로 확장 가능한 비즈니스모델을 체계화함.</td>
                        </tr>
                        <tr>
                            <th width="30%" >강력한 고객 파트너십</th>
                            <td width="70%" align="left" >
                                시장변동성 확대, 시장경쟁심화에도 불구, 고객과의 장기적 거래관계 유지를 위해, <br/> 
                                 니즈기반 고객 Segmentation 및 핵심 고객사를 재정의 하고 시장의 경쟁자와 다른 새롭고 차별적인 Value제공으로 <br/> 
                                 지속적 고객만족을 도모하고 장기적 고객유지 및 서비스 범위 확대를 실현함.</td>
                        </tr>
                        <tr>
                            <th width="30%" >정보 표준화</th>
                            <td width="70%" align="left" >
                                사업운영에 수반되는 다양한 정보의 효율적 활용을 위해,<br/> 
                                카탈로그, 공급망, 계약정보를 표준화, 정형화 하고, 주문, 납품실적의 분석을 통해 예측 가능한 정보자산화 하고<br/> 
                                내부 사용자의 업무효율 개선 및 고객확장을 위한 전사적 활용 도모.</td>
                        </tr>
                    </table>
                    <br/><br/><br/><br/><br/>
                	<p class="subcontentTit" >핵심가치</p>
                    <div style="position:relative; margin:0 auto; height:320px;color:#fff; font-size:15px;text-align:center; line-height:22px ">
                        <p style="position:absolute; background-color:#eeeeee; border:1px solid #e5e5e5; border-top:2px solid #4b4948; width:263px; left:270px;   height:150px;text-align:center; line-height:18px;" > <br/><br/> <img src="/resources/images/2016/img01.png" /></p>
                        <p style="position:absolute; background-color:#eeeeee; border:1px solid #e5e5e5; border-top:2px solid #4b4948; width:263px; left:540px; height:150px;text-align:center; line-height:20px" > <br/><br/> <img src="/resources/images/2016/img02.png" /></p>
                        <p style="position:absolute; background-color:#eeeeee; border:1px solid #e5e5e5; border-top:2px solid #4b4948; width:263px; left:0px; height:150px;text-align:center; line-height:20px" > <br/><br/> <img src="/resources/images/2016/img03.png" /></p>
                        <p style="position:absolute; background-color:#eeeeee; border:1px solid #e5e5e5; border-top:2px solid #4b4948; width:263px; left:810px; height:150px;text-align:center; line-height:20px" > <br/><br/> <img src="/resources/images/2016/img04.png" /></p>
                        <p style="position:absolute; background:url(/resources/images/2016/dot03.png); background-color:#ee3212; border:1px solid #e5e5e5; width:263px; left:270px;  top:151px; height:180px;" > <br/><br/><span class="subcontentTxt03">끊임없는 <b>도전과 열정</b></span> <br/> <br/>
                        목표 달성을 위한 끊임없는 시도<br/> 
                        나와 회사의 미래를 향한 뜨거운 마음</p>
                        <p style="position:absolute; background:url(/resources/images/2016/dot03.png); background-color:#ee3212; width:265px; left:540px;top:151px; height:180px;" > <br/><br/><span class="subcontentTxt03">사내/외 <b>소통과 협력</b></span> <br/> <br/>
                        상대방에 대한 배려와 경청<br/> 
                        내외부 협업을 통한 성과창출</p>
                        <p style="position:absolute; background:url(/resources/images/2016/dot03.png); background-color:#ee3212; width:265px; left:0px;top:151px; height:180px;" ><br/><br/><span class="subcontentTxt03">책임을 다하는 <b>주인 의식</b></span> <br/> <br/>
                        비전에 대한 공감과 나의 역할 인식<br/> 
                        적극적 사고와 주도적인 자세</p>
                        <p style="position:absolute; background:url(/resources/images/2016/dot03.png); background-color:#ee3212; width:265px; left:810px;top:151px; height:180px;" > <br/><br/><span class="subcontentTxt03">고객의 <b>신뢰와 감동</b></span> <br/> <br/>
                        고객가치의 지속적 제공<br/> 
                        기대이상의 솔루션 제안</p>
                    </div>
                </div>
            </div>
        </div>
        
    </div>
    <!--컨텐츠 끝-->
			<!------------------------------------------------------------------------------------------------footer-------------------------------------------------------------------------------------------------------------->
			<%@ include file="/WEB-INF/views/common/include/2016/mainFooter.jsp" %>
			<!------------------------------------------------------------------------------------------------footer-------------------------------------------------------------------------------------------------------------->
	</div>
</body>
</html>
