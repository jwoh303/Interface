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
            <div class="subbannerimg"><img src="/resources/images/2016/SB06.jpg" /></div>
            <div class="subbannertxt" > 
            	<p class="sbtit">부자재구매대행</p>
            	<p>차별화된 가치를 제공하는 KeP의 서비스를 만나 보세요</p>
            </div>
            <div class="subbannerbg" > </div>
        </div>
        <div class="subtab">
        	<div class="subtabBg"></div>
            <div class="subtabList02">
            	<ul>
                    <a href="javascript:MovePage_2016('<%=httpurl%>','02', '01');"><li>MRO구매대행</li></a><a href="javascript:MovePage_2016('<%=httpurl%>','02', '02');"><li class="subtabOn">부자재구매대행</li></a><a href="javascript:MovePage_2016('<%=httpurl%>','02', '03');"><li>건설MRO소개</li></a><a href="javascript:MovePage_2016('<%=httpurl%>','02', '04');"><li>해외법인</li></a><a href="javascript:MovePage_2016('<%=httpurl%>','02', '05');"><li>구매시스템</li></a><a href="javascript:MovePage_2016('<%=httpurl%>','02', '06');"><li >물류센터</li></a>
                </ul> 
            </div>
        </div>
        <div class="subcontent">
            <div class="sub02_Bmodel">
                저희 코리아e플랫폼은 구매전문성과 소싱인프라를 기반으로 기업 부자재에 대한 구매대행 서비스를 제공하고 있습니다.<br/> 
                MRO품목과 구매특성이 상이한 부자재에 대해 체계적인 관리 프로세스를 구축하여 효과적인 전략구매 및 조달구매 서비스를 제공하고 있습니다. <br/><br/><br/><br/>
                <p class="subcontentTit" >부자재 특성</p>
                부자재란 제품 품질에 직접적인 영향을 미치지는 않으면서 제품의 원활한 생산과 배송에 사용되는 중요한 자재로서,<br/>구매금액이 크면서 품질관리가 중요한 자재입니다.<br/><br/>

                <table  class="Mro01table" style="margin-bottom:100px; width:480px">
                     <colgroup>
                      <col width="20%" />
                      <col width="40%" />
                      <col width="40%" />
                      </colgroup>
                    <tr>
                        <th style="color:#fff; background:#4b4948; background-image:url(/resources/images/2016/dot04.png); height:56px;border-right:1px solid #6c6b6b;" >구분</th>
                        <th style="color:#fff; background:#ee3212 ">부자재</th>
                        <th style="color:#fff; background:#4b4948">MRO</th>
                    </tr>
                    <tr>
                        <th style=" border-right:1px solid #cdcdcd; background:#eeeeee" >협력사 수</th>
                        <td style="border-right:1px solid #cdcdcd;color:#ee3212">소수</td>
                        <td >다수</td>
                    </tr>
                    <tr>
                        <th style=" border-right:1px solid #cdcdcd; background:#eeeeee" >품목 수</th>
                        <td style="border-right:1px solid #cdcdcd;color:#ee3212">적음</td>
                        <td>많음</td>
                    </tr>
                    <tr>
                        <th style=" border-right:1px solid #cdcdcd; background:#eeeeee" >구매금액</th>
                        <td style="border-right:1px solid #cdcdcd;color:#ee3212">많음</td>
                        <td >적음</td>
                    </tr>
                    <tr>
                        <th style=" border-right:1px solid #cdcdcd; background:#eeeeee" >중요도</th>
                        <td style="border-right:1px solid #cdcdcd;color:#ee3212">대체 어려움</td>
                        <td >대체 가능</td>
                    </tr>
                    <tr>
                        <th style=" border-right:1px solid #cdcdcd; background:#eeeeee" >구매 Cost </th>
                        <td style="border-right:1px solid #cdcdcd;color:#ee3212">높음</td>
                        <td >낮음</td>
                    </tr>
                    <tr>
                        <th style=" border-right:1px solid #cdcdcd; background:#eeeeee" >구매 주기</th>
                        <td style="border-right:1px solid #cdcdcd;color:#ee3212">정기</td>
                        <td >비정기</td>
                    </tr>
                    <tr>
                        <th style=" border-right:1px solid #cdcdcd; background:#eeeeee" >관리포인트</th>
                        <td style="border-right:1px solid #cdcdcd;color:#ee3212">품질관리/가격 관리</td>
                        <td >납기관리/프로세스 효율화</td>
                    </tr>
           	 	</table>
                <table  style="position:absolute;top:294px; left:530px; width:545px; margin-bottom:80px;border:1px solid #cdcdcd; font-size:14px; ">
                     <tr>
                        <td colspan="3" width="15%" height="100px" style="border-right:1px solid #cdcdcd; background:#eeeeee" ><b style="color:#ee3212;font-size:18px;">대상품목</b><br/>
                        <p style="line-height:18px; font-weight:normal; font-size:15px; margin-top:5px">팔레트, 랙, 목재, 골판지박스, 백, 포장용필름, 수처리약품 등  </p></td>
                    </tr>
                    <tr>
                        <td width="15%" height="149px" style="border-right:1px solid #e5e5e5;border-bottom:1px solid #e5e5e5;" ><img src="/resources/images/2016/PRD16.gif" /><br/>팔레트</td>
                        <td width="15%" style="border-right:1px solid #e5e5e5;border-bottom:1px solid #e5e5e5;;" ><img src="/resources/images/2016/PRD17.gif" /><br/>랙</td>
                        <td width="15%" style="border-bottom:1px solid #e5e5e5;" ><img src="/resources/images/2016/PRD18.gif" /><br/>목재</td>
                    </tr>
                    <tr>
                        <td width="15%" height="149px" style="border-right:1px solid #e5e5e5;border-bottom:1px solid #cdcdcd;" ><img src="/resources/images/2016/PRD19.gif" /><br/>골판지박스</td>
                        <td width="15%" style="border-right:1px solid #e5e5e5;border-bottom:1px solid #cdcdcd;" ><img src="/resources/images/2016/PRD20.gif" /><br/>백</td>
                        <td width="15%"  style="border-bottom:1px solid #cdcdcd;"><img src="/resources/images/2016/PRD21.gif" /><br/>포장용필름</td>
                    </tr>
                  
           	 	</table>
                <p class="subcontentTit" >고객사 제공가치 </p>
                 <div class="materielList"  style="position:relative; margin-top:10px; margin-bottom:100px; height:320px; min-height:320px ">
                    <ul>
                      <li style="width:260px;">
                      	<p><img src="/resources/images/2016/img07.png" /></p>
                      	<div style="background-color:#e1e1e1; background-image:url(/resources/images/2016/dot03.png); padding:35px 15px; height:120px">
                            <p style="color:#ee3212; font-size:18px; margin-bottom:10px; font-weight:bold">전략구매 컨설팅 제공</p>
                            품목별 구매전문가가 해당 시장의 분석을 통해 고객사에 적합한 맞춤형 구매 솔루션을 제공합니다.
                        </div>
                      </li>
                      <li style="width:280px;">
                      	<img src="/resources/images/2016/img27.png" />
                      	<div style="background-color:#e1e1e1; background-image:url(/resources/images/2016/dot03.png); padding:35px 15px; height:120px">
                            <p style="color:#ee3212; font-size:18px; margin-bottom:10px; font-weight:bold">원가 절감</p>
                            구매 단가와 같은 직접구매비용 뿐만 아니라, 인건비, 시스템 개발/유지/보수 비용, 거래처 관리비용 등 간접비용의 절감도 제공하고 있습니다.
                        </div>
                      </li>
                      <li style="width:265px;">
                      	<img src="/resources/images/2016/img28.png" />
                      	<div style="background-color:#e1e1e1; background-image:url(/resources/images/2016/dot03.png); padding:35px 15px; height:120px">
                            <p style="color:#ee3212; font-size:18px; margin-bottom:10px; font-weight:bold">품질관리</p>
                            품질표준 관리, 협력사 실사, 외부기관 품질테스트 등을 통해 철저한 품질관리를 시행하고 있습니다.
                        </div>
                      </li>
                      <li style="width:250px;">
                      	<img src="/resources/images/2016/img29.png" />
                      	<div style="background-color:#e1e1e1; background-image:url(/resources/images/2016/dot03.png); padding:35px 15px; height:120px">
                            <p style="color:#ee3212; font-size:18px; margin-bottom:10px; font-weight:bold">납기관리</p>
                            체계적인 납기관리 시스템을 통해 적기 납품서비스를 제공하고 있습니다.
                        </div>
                      </li>
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

