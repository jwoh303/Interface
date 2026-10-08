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
        	 
            <div class="subbannerimg"><img src="/resources/images/2016/SB21.jpg" /></div>
            <div class="subbannertxt" > 
            	<p class="sbtit">인사제도</p>
            	<p>진취적이고 역량 있는 인재를 모집합니다.</p>
            </div>
            <div class="subbannerbg" ></div>
        </div>
        <div class="subtab">
        	<div class="subtabBg"></div>
            <div class="subtabList03">
            	<ul>
                    <a href="javascript:MovePage_2016('<%=httpurl%>','03', '04');"><li>인재상</li></a><a href="javascript:MovePage_2016('<%=httpurl%>','03', '05');"><li  class="subtabOn">인사제도</li></a><a href="javascript:MovePage_2016('<%=httpurl%>','03', '06');"><li >채용정보</li></a>
                </ul>   
            </div>
        </div>
		<div class="subcontent">
        	<div class="sub03_recruit">
            <p class="subcontentTit" >성과주의문화</p>
            
            <div style="position:relative">
                <table  class="recruittable02" style="margin-bottom:150px;">
                     <colgroup>
                      <col width="25%" />
                      <col width="25%" />
                      <col width="25%" />
                      <col width="25%" />
                      </colgroup>
                    <tr>
                        <th height="120px" >성과관리 시스템</th>
                        <th style="background:#eeeeee" >인사평가 시스템</th>
                        <th >기본연봉체계</th>
                        <th style="background:#eeeeee">인센티브제도</th>
                    </tr>
                    <tr>
                        <td style="vertical-align:top" >회사의 비젼 달성과 전략실행을 위해 직원 개인의 목표와 회사의 사업목표와의 연계를 정립시키는 성과관리</br>프로세스</td>
                        <td style="background:#eeeeee;vertical-align:top" >개인과 부서의 성과목표를 기반으로 달성정도를 평가하고 직무별 역량을 점검하여 보상과 배치 등 인사관리에 활용함으로써 투명성과 공정성 확보</td>
                        <td style="vertical-align:top">성과에 따라 전 임직원에게 공통적</br>으로 적용되는 기본 연봉체계</td>
                        <td style="background:#eeeeee;vertical-align:top" >회사의 성과 및 개인의 성과에 따라 전 직원들에게 적용되는 보상제도</br>로서 PS-PI-영업인센티브제도 운영</td>
                    </tr>
                </table>
                <p style="position:absolute; top:110px; left:115px"><img src="/resources/images/2016/br02.png" /></p>
                <p style="position:absolute; top:110px; left:390px"><img src="/resources/images/2016/br02.png" /></p>
                <p style="position:absolute; top:110px; left:660px"><img src="/resources/images/2016/br02.png" /></p>
                <p style="position:absolute; top:110px; left:930px"><img src="/resources/images/2016/br02.png" /></p>
            </div>
            <p class="subcontentTit" >직급체계</p>
            <div style="position:relative;height:300px" >
                <table  class="recruittable03" style=" position:absolute; left:12%; z-index:1; width:76%; letter-spacing:1px">
                     <colgroup>
                      <col width="25%" />
                      <col width="25%" />
                      <col width="25%" />
                      <col width="25%" />
                      </colgroup>
                    <tr>
                        <td height="180px" style="background:url(/resources/images/2016/m21.png) no-repeat center" >사원</td>
                        <td style="background:#eeeeee;background:url(/resources/images/2016/m20.png) no-repeat center" >주임</td>
                        <td style="background:url(/resources/images/2016/m21.png) no-repeat center">선임</td>
                        <td style="background:#eeeeee;background:url(/resources/images/2016/m20.png) no-repeat center">책임</td>                        
                    </tr>
                </table>
                <p style="position:absolute; top:75px; left:320px; z-index:1"><img src="/resources/images/2016/arrow04.png" /></p>
                <p style="position:absolute; top:75px; left:520px; z-index:1"><img src="/resources/images/2016/arrow04.png" /></p>
                <p style="position:absolute; top:75px; left:720px; z-index:1"><img src="/resources/images/2016/arrow04.png" /></p>
                <p style="position:absolute; top:91px; left:0px; height:1px; background-color:#cdcdcd; width:1080px; z-index:0"></p>              
            </div>
            
            <p class="subcontentTit" >평가/보상</p>
            <div style="position:relative;background:url(/resources/images/2016/sub_bg01.jpg)">
                <table  class="recruittable05" style="margin-bottom:150px;">
                     <colgroup>
                      <col width="20%" />
                      <col width="20%" />
                      <col width="30%" />
                      <col width="30%" />
                      </colgroup>
                    <tr>
                        <th  rowspan="2" style=" background-color:#e5e5e5; border-right:1px solid #fff;border-top:3px solid #4b4948;border-bottom:1px solid #707070; color:#1b1b1b;background-image:url(/resources/images/2016/dot03.png);font-size:18px;" >
                        회사와 직원의</br> 지속적인 성장</th>
                        <th  rowspan="2" style="background:#FFF;border-top:3px solid #ee3212;border-bottom:1px solid #707070;font-size:18px; color:#ee3212" >직원의 만족과</br> 동기부여</th>
                        <td height="170px" style=" border-right:1px solid #707070;border-bottom:1px solid #707070; ;color:#FFF;line-height:22px;border-top:3px solid #4b4948;">
                        목표수립, 중간점검, 평가, 보상반영 등 </br> 평가 Process로 투명성, 공정성 확보</td>
                        <td  style="border-bottom:1px solid #707070;color:#FFF;line-height:22px;border-top:3px solid #4b4948;">
                        성과의 과정 및 결과에 대한  </br>정확한 최종평가</td>
                    </tr>
                   
                    <tr>
                        
                        <td height="170px" style="border-right:1px solid #707070;color:#FFF;line-height:22px;border-bottom:1px solid #707070;">평가결과에 따른 누적식 연봉인상</br> (성과와 능력 수준에 따라 </br>급여가 상승하는 구조)</td>
                        <td style="color:#FFF;line-height:22px;border-bottom:1px solid #707070;"  >최종평가 결과를 승진심사, </br>연봉인상, 변동급지급(PI)에 반영</br> 경영성과에 따른 성과급(PS)지급 </td>
                    </tr>
                </table>
                <p style="position:absolute; top:156px; left:195px; z-index:1"><img src="/resources/images/2016/arrow04.png" /></p>
                <p style="position:absolute; top:156px; left:410px; z-index:1"><img src="/resources/images/2016/arrow02.png" /></p>
            </div>
            
            
            <p class="subcontentTit" >인재육성</p>
            <div style="position:relative;">
                <table  class="recruittable04" style="margin-bottom:150px">
                     <colgroup>
                      <col width="25%" />
                      <col width="25%" />
                      <col width="25%" />
                      <col width="25%" />
                      </colgroup>
                    <tr>
                        <th height="70px" style="background:#ee3212;background-image:url(/resources/images/2016/dot03.png); border-right:1px solid #999898; color:#FFF">핵심가치</th>
                        <th style="background:#707070;background-image:url(/resources/images/2016/dot03.png);border-right:1px solid #999898; color:#FFF" >리더육성</th>
                        <th style="background:#ee3212;background-image:url(/resources/images/2016/dot03.png);border-right:1px solid #999898; color:#FFF">핵심인재</th>
                        <th style="background:#707070;background-image:url(/resources/images/2016/dot03.png);color:#FFF">직무전문가</th>
                    </tr>
                    <tr>
                        <td style="vertical-align:top;line-height:22px" >전임직원 대상 핵심가치내재화 공유 강화 및 기본 소양을 배양하는 교육 과정</td>
                        <td style="background:#eeeeee;vertical-align:top;line-height:22px" >계층별 업무수행에 필요한 리더쉽 및 업무능력 향상에 필요한 지식과 기능 함양</td>
                        <td style="vertical-align:top;line-height:22px">차별적인 교육과정을 구성하여 지속성장을 위한 핵심역량을 유지, 발전</td>
                        <td style="background:#eeeeee;vertical-align:top;line-height:22px" >직무전문성 함양에 필요한 e-learning, 외부교육을 learning directory화 제공</td>
                    </tr>
                    <tr>
                        <td style="vertical-align:top; text-align:left" >- 핵심가치 내재화 </br>- 조직활성화 </br>- 변화혁신 특강</td>
                        <td style="background:#eeeeee;vertical-align:top; text-align:left" >- 관리자 리더쉽과정 </br> - 성과관리 과정 </br> - Consultative Selling 스킬</td>
                        <td style="vertical-align:top; text-align:left">- 외부 MBA 위탁과정</td>
                        <td style="background:#eeeeee;vertical-align:top; text-align:left" >- PM역량향상과정 </br>- 협상력 향상과정 </br>  - 전략구매과정</td>
                    </tr>
                </table>
                <p style="position:absolute; top:185px; left:115px"><img src="/resources/images/2016/br01.png" /></p>
                <p style="position:absolute; top:185px; left:390px"><img src="/resources/images/2016/br03.png" /></p>
                <p style="position:absolute; top:185px; left:660px"><img src="/resources/images/2016/br01.png" /></p>
                <p style="position:absolute; top:185px; left:930px"><img src="/resources/images/2016/br03.png" /></p>
            </div>
            
            
            <p class="subcontentTit" >복리후생</p>
            <p style="position:relative;left:0px; height:2px; background-color:#4b4948; width:1080px; z-index:0"></p>
            <table  class="recruittable04" style="margin-bottom:100px;">
                 <colgroup>
                  <col width="25%" />
                  <col width="25%" />
                  <col width="25%" />
                  <col width="25%" />
                  </colgroup>
                <tr>
                    <th height="230px" style="border-right:1px solid #e5e5e5;" ><img src="/resources/images/2016/index_img055.png" style="margin-bottom:5px" /></br>생활안정지원</th>
                    <th  style="border-right:1px solid #e5e5e5;"><img src="/resources/images/2016/index_img08.png" style="margin-bottom:5px" /></br>가족친화제도</th>
                    <th style="border-right:1px solid #e5e5e5;" ><img src="/resources/images/2016/index_img07.png" style="margin-bottom:5px" /></br>여가/레져 지원</th>
                    <th ><img src="/resources/images/2016/index_img066.png" style="margin-bottom:5px" /></br>기타복리후생</th>
                </tr>
                <tr>
                    <td style="background:url(/resources/images/2016/dot03.png); background-color:#d2d2d2; border-right:1px solid #fff; vertical-align:top">- 자녀 학자금 지원</br>
                    - 사우회 공제회 운영</br>
                    - 주택자금 대출</td>
                    <td style="background:url(/resources/images/2016/dot03.png); background-color:#d2d2d2;border-right:1px solid #fff; vertical-align:top" >- 기념일 축하 케익 발송</br>
                    - 건강검진 실시</br>
                    - 패밀리Day 시행</td>
                    <td style="background:url(/resources/images/2016/dot03.png); background-color:#d2d2d2;border-right:1px solid #fff; vertical-align:top">- 사내동호회 활동 지원</br>
                    - 휴양소 및 콘도 지원</br>
                    - 우수사원 해외여행</br>
                    - 워크샵/송년회/창립기념행사</td>
                    <td style="background:url(/resources/images/2016/dot03.png); background-color:#d2d2d2; vertical-align:top " >- 장기근속자 포상</br>
                    - 기념품지급(명절/창립일)</br>
                    - 경조금및 경조휴가</td>
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
</body>
</html>

