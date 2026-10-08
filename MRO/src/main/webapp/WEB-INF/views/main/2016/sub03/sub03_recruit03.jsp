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
        	 
            <div class="subbannerimg"><img src="/resources/images/2016/SB11.jpg" /></div>
            <div class="subbannertxt" > 
            	<p class="sbtit">채용정보</p>
            	<p>진취적이고 역량 있는 인재를 모집합니다.</p>
            </div>
            <div class="subbannerbg" ></div>
        </div>
        <div class="subtab">
        	<div class="subtabBg"></div>
            <div class="subtabList03">
            	<ul>
                    <a href="javascript:MovePage_2016('<%=httpurl%>','03', '04');"><li>인재상</li></a><a href="javascript:MovePage_2016('<%=httpurl%>','03', '05');"><li>인사제도</li></a><a href="javascript:MovePage_2016('<%=httpurl%>','03', '06');"><li class="subtabOn">채용정보</li></a>
                </ul>   
            </div>
        </div>
		<div class="subcontent">
        	<div class="sub03_recruit">
            MRO 구매대행 사업의 선두주자인 KeP는 <br/>“플랫폼 비즈니스 리더”라는 Vision을 함께 만들어갈 진취적이고 역량 있는 인재를 모집합니다.<br/><br/><br/><br/>
            
            <p class="subcontentTit" >채용 절차</p>
            <div class="recruiList" style="position:relative; margin-top:20px; margin-bottom:150px;z-index:1">
             <ul>
              <li ><img src="/resources/images/2016/img04.gif" /></br></br><p class="subcontentTxt02" style="line-height:20px"><span style="color:#ee3212">step1.</span> 지원접수</p></li>
              <li style="width:50px;"><img src="/resources/images/2016/arrow12.png" /></li>
              <li><img src="/resources/images/2016/img05.gif" /></br></br><p class="subcontentTxt02" style="line-height:20px"><span style="color:#ee3212">step2.</span> 서류전형</p></li>
              <li style="width:50px;"><img src="/resources/images/2016/arrow12.png" /></li>
              <li><img src="/resources/images/2016/img06.gif" /></br></br><p class="subcontentTxt02" style="line-height:20px"><span style="color:#ee3212">step3.</span> 1차면접</p></li>
              <li style="width:50px;"><img src="/resources/images/2016/arrow12.png" /></li>
              <li><img src="/resources/images/2016/img06.gif" /></br></br><p class="subcontentTxt02" style="line-height:20px"><span style="color:#ee3212">step4.</span> 2차면접</p></li>
              <li style="width:50px;"><img src="/resources/images/2016/arrow12.png" /></li>
              <li><img src="/resources/images/2016/img07.gif" /></br></br><p class="subcontentTxt02" style="line-height:20px"><span style="color:#ee3212">step5.</span> 건강진단</p></li>
              <li style="width:50px;"><img src="/resources/images/2016/arrow12.png" /></li>
              <li><img src="/resources/images/2016/img07_.gif" /></br></br><p class="subcontentTxt02" style="line-height:20px"><span style="color:#ee3212">step6.</span> 최종합격</p></li>
             </ul>
             
            </div>
            <p style="position:absolute; top:294px; left:0px; height:1px; background-color:#e5e5e5; width:1080px; z-index:0"></p>
            <p class="subcontentTit" >공개 채용</p>
            <table  class="recruittable06" style="margin-bottom:20px; margin-top:15px ">
                 <colgroup>
        				  <col width="9%" />
                          <col width="12%" />
        				  <col width="33%" />
        				  <col width="35%" />
        				  <col width="11%" />
        				</colgroup>
                <tr>
                    <th colspan="2" height="70" bgcolor="#eeeeee" >모집부분</th>
                    <th bgcolor="#eeeeee">담당업무</th>
                    <th bgcolor="#eeeeee">자격조건</th>
                    <th bgcolor="#eeeeee">근무지</th>
                </tr>
                <tr>
                    <td  style=" border-right:solid 1px #cdcdcd;"  rowspan="2" >영업</td>
                    <td  style=" border-right:solid 1px #cdcdcd;" >제조<br/>건설<br/>서비스</td>
                    <td style=" text-align:left;border-right:solid 1px #cdcdcd;" >
                        - 담당 고객사 매출/매익 관리<br/>
                        - 담당 고객사 계약 관리 <br/>
                        - 담당 고객사 거래 프로세스 개선 <br/>
                        - 신규 고객사 set-up(거래 준비) 
                    </td>
                    <td style=" text-align:left; border-right:solid 1px #cdcdcd;" >
                        - 신입 및 경력 10년 이하 <br/>
                        - 대졸 및 졸업 예정자 <br/>
                        - 대기업/중견기업 구매 또는 영업 3년이상 우대 <br/>
                        - 건설회사 또는 MRO업체 경력자 우대 <br/>
                        - 동종업계 경력자 우대 <br/>
                        - CPSM 자격증 보유자 우대
                    </td>
                    <td style=" text-align:left; ">
                    	- 본사<br/>
                        - 대전<br/>
                        - 창원 등
                    </td>
                </tr>
                <tr>
                    <td  style=" border-right:solid 1px #cdcdcd;" >신규<br/>영업</td>
                    <td style=" text-align:left;border-right:solid 1px #cdcdcd;" >
                        - 신규 고객 수주 영업 <br/>
                        - 신규 입찰 참여 및 계약 <br/> 
                    </td>
                    <td style=" text-align:left; border-right:solid 1px #cdcdcd;" >- 상 동 </td>
                    <td style=" text-align:left; ">- 본사 </td>
                </tr>
                <tr>
                    <td colspan="2"  style=" border-right:solid 1px #cdcdcd;" >운영</td>
                    <td style=" text-align:left;border-right:solid 1px #cdcdcd;" >
                        - 담당 고객사 주문현황 및 납기 관리<br/>
                        - 담당 고객사 마감 관리<br/>
                        - VOC 대응
                    </td>
                    <td style=" text-align:left; border-right:solid 1px #cdcdcd;" >
                        - 신입 및 경력 10년 이하<br/>
                        - 고등학교/초대졸 및 졸업 예정자<br/>
                        - 상경계열 전공자<br/>
                        - MRO업체 근무경험자 우대<br/>
                        - 동종업계 경력자 우대
                    </td>
                    <td style=" text-align:left; ">
                    	- 본사<br/>
                        - 대전<br/>
                        - 창원 등
                    </td>
                </tr>
                <tr>
                    <td colspan="2"  style=" border-right:solid 1px #cdcdcd;" >구매</td>
                    <td style=" text-align:left;border-right:solid 1px #cdcdcd;" >
                        - 담당 품목 정기 소싱 수행<br/>
                        - 신규 입찰 프로젝트 소싱 수행<br/>
                        - 기존 고객 재계약/품목 확대 소싱 수행<br/>
                        - 담당 품목 협력사 관리<br/>
                         - 담당 품목 카달로그 표준화
                    </td>
                    <td style=" text-align:left; border-right:solid 1px #cdcdcd;" >
                        - 신입 및 경력 10년 이하<br/>
                        - 대졸 및 졸업 예정자<br/>
                        - 상경/이공계열 졸업자 우대<br/>
                        - 대기업/중견기업 구매 3년이상 경력자 우대<br/>
                        - 동종업계 경력자 우대<br/>
                        - 구매전략 수립 및 프로세스 개선 경험자<br/>
                        - CPSM 자격증 보유자 우대
                    </td>
                    <td style=" text-align:left; ">
                    	- 본사<br/>
                        - 대전<br/>
                        - 창원 등
                    </td>
                </tr>                  
            </table>
            <table  class="recruittable" style="margin-bottom:5px;">
                 <colgroup>
                  <col width="20%" />
                  <col width="80%" />
                  </colgroup>
                <tr>
                    <th >공통사항</th>
                    <td align="left" >
                    1. 해외 여행에 결격사유가 없는 자, 남성의 경우 군필 또는 면제자 </br>
                    2. 취업보호대상자, 장애인, 보훈대상자 우대</br>
                    3. 채용 후 수습기간 3개월 적용 </br>
                    </td>
                </tr>
                <tr>
                    <th >모집기간 및 제출서류</th>
                    <td align="left" >
                      	1. 모집기간 : ~채용시까지<br/>
                        2. 제출서류<br/>
                        &nbsp; &nbsp;1) 입사지원서(자사양식)<br/>
                        &nbsp; &nbsp;2) e-mail 제출 - keprecruit@koreab2b.com (파일명 : 성명_지원분야_지역)<br/>
                        &nbsp; &nbsp; &nbsp; &nbsp; - 이력서에 모집부문, 희망지역 및 연락처 반드시 기재
                    </td>
                </tr>
            </table>            
            <div style="text-align:left; font-size:15px; line-height:22px;margin-bottom:90px;">
            ※ 채용 과정에서 오프라인으로 제출한 서류가 있을 경우, 해당 공고의 채용여부가 확정된 이후 14일 이내에 원본서류 반환을 요청할 수 있습니다.</br>
            &nbsp; &nbsp; &nbsp;반환 희망 시 문의처를 통해 반환을 청구해 주시기 바라며, 접수 후 14일 내 요청 서류를 등기 우편으로 발송해 드립니다. </br>
            &nbsp; &nbsp; &nbsp;오프라인으로 제출한 서류는 당사자가 반환을 청구하지 않을 경우 즉시 파기됩니다.</br>
            &nbsp; &nbsp; &nbsp;단, 홈페이지 또는 전자우편을 통해 제출한 일체의 서류, 당사의 요청이 없음에도 자발적으로 제출한 서류는 반환청구대상에 포함되지 않으며, </br>
            &nbsp; &nbsp; &nbsp;당사 개인정보방침에 따라 180일간 보관 후 파기됩니다.
            </div></br>
            
            <p class="subcontentTit" >상시 지원</p>
           희망분야에 상시 지원해주시면 충원 필요시 우선 검토하겠습니다. <br/><br/>
            <p class="recruitBtn" style="margin-bottom:40px;"><a href="/resources/excel/work/MAIN/KeP.docx">이력서 다운로드 </a></p>

            <table  class="recruittable" style="margin-bottom:100px;">
                 <colgroup>
                  <col width="20%" />
                  <col width="80%" />
                  </colgroup> 
                <tr>
                    <th >접수방법</th>
                    <td align="left" >e-메일접수에 한함, e-mail : keprecruit@koreab2b.com</td>
                </tr>
                <tr>
                    <th >제출서류</th>
                    <td align="left" >
                        - 이력서, 자기소개서 </br>
                        - 경력기술서(경력자에 한함)</br> 
                    </td>
                </tr>
                <tr>
                    <th >문의사항</th>
                    <td align="left" >인사팀 채용 담당자(02-3016-8992)</td>
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

