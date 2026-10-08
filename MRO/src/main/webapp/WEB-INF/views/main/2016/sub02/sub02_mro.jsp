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
            <div class="subbannerimg"><img src="/resources/images/2016/SB05.jpg" /></div>
            <div class="subbannertxt" > 
            	<p class="sbtit">MRO구매대행</p>
            	<p>차별화된 가치를 제공하는 KeP의 서비스를 만나 보세요</p>
            </div>
            <div class="subbannerbg" > </div>
        </div>
        <div class="subtab">
        	<div class="subtabBg"></div>
            <div class="subtabList02">
            	<ul>
                    <a href="javascript:MovePage_2016('<%=httpurl%>','02', '01');"><li class="subtabOn">MRO구매대행</li></a><a href="javascript:MovePage_2016('<%=httpurl%>','02', '02');"><li>부자재구매대행</li></a><a href="javascript:MovePage_2016('<%=httpurl%>','02', '03');"><li>건설MRO소개</li></a><a href="javascript:MovePage_2016('<%=httpurl%>','02', '04');"><li>해외법인</li></a><a href="javascript:MovePage_2016('<%=httpurl%>','02', '05');"><li>구매시스템</li></a><a href="javascript:MovePage_2016('<%=httpurl%>','02', '06');"><li >물류센터</li></a>
                </ul> 
            </div>
        </div>
        <div class="subcontent">
            <div class="sub02_Bmodel">
                저희 코리아e플랫폼은 구매전문성과 소싱인프라를 기반으로 <br/>한국을 대표하는 다수의 제조기업을 대상으로 MRO 구매대행 서비스를 제공하고 있습니다. <br/><br/><br/><br/>
                <p class="subcontentTit" >MRO 특성</p>
                Maintenance(유지), Repair(보수), Operation(운영)의 약어로 원자재 및 대형설비를 제외한 모든 기업 소모성자재를 의미합니다.<br/> 협력사 수가 많고 발주빈도가 높은 대신 품목당 거래금액이 적어 관리하기 힘든 자재입니다.<br/><br/>
                <table  class="Mro01table" style="margin-bottom:80px; width:480px">
                     <colgroup>
                      <col width="20%" />
                      <col width="45%" />
                      <col width="35%" />
                      </colgroup>
                    <tr>
                        <th style="color:#fff; background:#4b4948; background-image:url(/resources/images/2016/dot04.png); height:58px;border-right:1px solid #6c6b6b;" >구분</th>
                        <th style="color:#fff; background:#ee3212">MRO</th>
                        <th style="color:#fff; background:#4b4948">부자재</th>
                    </tr>
                    <tr>
                        <th style=" border-right:1px solid #cdcdcd; background:#eeeeee" >협력사 수</th>
                        <td style=" border-right:1px solid #cdcdcd;color:#ee3212" >다수</td>
                        <td >소수</td>
                    </tr>
                    <tr>
                        <th style=" border-right:1px solid #cdcdcd; background:#eeeeee" >품목 수</th>
                        <td style=" border-right:1px solid #cdcdcd;color:#ee3212" >많음</td>
                        <td >적음</td>
                    </tr>
                    <tr>
                        <th style=" border-right:1px solid #cdcdcd; background:#eeeeee" >구매금액</th>
                        <td style=" border-right:1px solid #cdcdcd;color:#ee3212" >적음</td>
                        <td >많음</td>
                    </tr>
                    <tr>
                        <th style=" border-right:1px solid #cdcdcd; background:#eeeeee" >중요도</th>
                        <td style=" border-right:1px solid #cdcdcd;color:#ee3212" >대체 가능</td>
                        <td >대체 어려움</td>
                    </tr>
                    <tr>
                        <th style=" border-right:1px solid #cdcdcd; background:#eeeeee" >구매 Cost </th>
                        <td style=" border-right:1px solid #cdcdcd;color:#ee3212" >낮음</td>
                        <td >높음</td>
                    </tr>
                    <tr>
                        <th style=" border-right:1px solid #cdcdcd; background:#eeeeee" >구매 주기</th>
                        <td style=" border-right:1px solid #cdcdcd;color:#ee3212" >비정기</td>
                        <td >정기</td>
                    </tr>
                    <tr>
                        <th style=" border-right:1px solid #cdcdcd; background:#eeeeee" >관리포인트</th>
                        <td style=" border-right:1px solid #cdcdcd;color:#ee3212" >납기관리/프로세스 효율화</td>
                        <td >품질관리/가격 관리</td>
                    </tr>
           	 	</table>
                <table  style="position:absolute;top:294px; left:530px; width:545px; margin-bottom:80px;border:1px solid #cdcdcd; font-size:13px; ">
                     <tr>
                        <td colspan="5" width="15%" height="100px" style="border-right:1px solid #cdcdcd; background:#eeeeee" ><b style="color:#ee3212;font-size:18px;">MRO 대상품목</b><br/>
                        <p style="line-height:18px; font-weight:normal; font-size:14px; margin-top:5px;">공작기계, 용접기기, 유압공구, 절삭공구, 측정공구, 배관자재, 펌프, 가스켓,<br/> 볼트/너트, 모터, 베어링, 사무가구, 생활용품, 안전용품, 사무용품 등</p></td>
                    </tr>
                    <tr>
                        <td width="15%" height="100px" style="border-right:1px solid #e5e5e5;border-bottom:1px solid #e5e5e5;" ><img src="/resources/images/2016/PRD15.gif" /><br/>공작기계</td>
                        <td width="15%" style="border-right:1px solid #e5e5e5;border-bottom:1px solid #e5e5e5;;" ><img src="/resources/images/2016/PRD14.gif" /><br/>용접기기</td>
                        <td width="15%" style="border-right:1px solid #e5e5e5;border-bottom:1px solid #e5e5e5;;" ><img src="/resources/images/2016/PRD13.gif" /><br/>유압공구</td>
                        <td width="15%" style="border-right:1px solid #e5e5e5;border-bottom:1px solid #e5e5e5;;" ><img src="/resources/images/2016/PRD12.gif" /><br/>절삭공구</td>
                        <td width="15%" style="border-bottom:1px solid #e5e5e5;" ><img src="/resources/images/2016/PRD11.gif" /><br/>측정공구</td>
                    </tr>
                    <tr>
                        <td width="15%" height="100px" style="border-right:1px solid #e5e5e5;border-bottom:1px solid #cdcdcd;" ><img src="/resources/images/2016/PRD10.gif" /><br/>배관자재</td>
                        <td width="15%" style="border-right:1px solid #e5e5e5;border-bottom:1px solid #cdcdcd;" ><img src="/resources/images/2016/PRD09.gif" /><br/>펌프</td>
                        <td width="15%" style="border-right:1px solid #e5e5e5;border-bottom:1px solid #cdcdcd;" ><img src="/resources/images/2016/PRD08.gif" /><br/>가스켓</td>
                        <td width="15%" style="border-right:1px solid #e5e5e5;border-bottom:1px solid #cdcdcd;" ><img src="/resources/images/2016/PRD07.gif" /><br/>볼트/너트</td>
                        <td width="15%"  style="border-bottom:1px solid #cdcdcd;"><img src="/resources/images/2016/PRD06.gif" /><br/>모터</td>
                    </tr>
                  <tr>
                        <td width="15%" height="100px" style="border-right:1px solid #e5e5e5;border-bottom:1px solid #cdcdcd;" ><img src="/resources/images/2016/PRD05.gif" /><br/>베어링</td>
                        <td width="15%" style="border-right:1px solid #e5e5e5;border-bottom:1px solid #cdcdcd;" ><img src="/resources/images/2016/PRD04.gif" /><br/>사무가구</td>
                        <td width="15%" style="border-right:1px solid #e5e5e5;border-bottom:1px solid #cdcdcd;" ><img src="/resources/images/2016/PRD02.gif" /><br/>생활용품</td>
                        <td width="15%" style="border-right:1px solid #e5e5e5;border-bottom:1px solid #cdcdcd;" ><img src="/resources/images/2016/PRD03.gif" /><br/>안전용품</td>
                        <td width="15%"  style="border-bottom:1px solid #cdcdcd;"><img src="/resources/images/2016/PRD01.gif" /><br/>사무용품</td>
                    </tr>
           	 	</table>
                <p class="subcontentTit" >고객사 제공가치 </p>
                
                
                
                <div class="valueList"  style="position:relative; margin-top:20px; margin-bottom:110px; ">
                    <ul>
                      <li style="width:350px; background:url(/resources/images/2016/img_j01.jpg) no-repeat top; "><p  style="margin-top:240px; padding:0 30px"><b style="color:#ee3212; font-size:18px; line-height:38px">TCO 관점의 비용 절감</b><br/>
                        구매 단가와 같은 직접구매비용 뿐만 아니라, 인건비, 시스템 개발/유지/보수 비용, 거래처 관리비용, 재고유지비용 등 간접비용의 절감도 제공하고 있습니다. </p></li>
                      <li style="width:350px; background:url(/resources/images/2016/img_j03.jpg) no-repeat top;"><p  style="margin-top:240px; padding:0 30px"><b style="color:#ee3212; font-size:18px; line-height:38px">구매투명성 확보</b><br/>
                       공정하고 투명한 프로세스와 e-Sourcing 시스템을 통해 투명한 구매관리가 가능합니다.</p></li>
                      <li style="width:355px; background:url(/resources/images/2016/img_j02.jpg) no-repeat top;"><p  style=" margin-top:240px; padding:0 28px"><b style="color:#ee3212; font-size:18px; line-height:38px">프로세스 효율화 </b><br/>
                        협력사 관리, 신규품목 소싱, 마감 등의 복잡한 업무가 아웃소싱을 통해 간소화되며, 체계적인 납기관리시스템을 통해 구매 Lead Time 단축도 가능합니다. 또한, 통합배송 서비스를 통해 현장의 업무 효율성 개선에도 일조하고 있습니다.</p></li>
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
</body>
</html>

