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
<script type="text/javascript"> 
$(function () {	
	tab('#PRtab',0);	
});

function tab(e, num){
    var menu = $(e).children();
    var con = $(e+'_con').children();
    var select = $(menu).eq(num);
    var i = num;

    select.addClass('on');
    con.eq(num).show();

    menu.click(function(){
        if(select!==null){
            select.removeClass("on");
            con.eq(i).hide();
        }

        select = $(this);	
        i = $(this).index();

        select.addClass('on');
        con.eq(i).show();
    });
}
</script> 
<script type="text/javascript"> 
$(function () {	
	tab('#PStab',0);	
});

function tab(e, num){
    var menu = $(e).children();
    var con = $(e+'_con').children();
    var select = $(menu).eq(num);
    var i = num;

    select.addClass('on');
    con.eq(num).show();

    menu.click(function(){
        if(select!==null){
            select.removeClass("on");
            con.eq(i).hide();
        }

        select = $(this);	
        i = $(this).index();

        select.addClass('on');
        con.eq(i).show();
    });
}
</script> 
    <!--컨텐츠-->
    <div class="subcontentsArea">
    	<div class="subbanner" >
        	 
            <div class="subbannerimg"><img src="/resources/images/2016/SB19.jpg" /></div>
            <div class="subbannertxt" > 
            	<p class="sbtit">업무처리 프로세스</p>
            	<p>작은 목소리에도 귀 기울이는 KeP!</p>
            </div>
            <div class="subbannerbg" ></div>
        </div>
       
        
        
        <div class="subtab">
        	<div class="subtabBg"></div>
            <div class="subtabList04">
            	<ul>
                    <a href="javascript:MovePage_2016('<%=httpurl%>','03', '01');"><li>FAQ</li></a><a href="javascript:MovePage_2016('<%=httpurl%>','03', '02');"><li class="subtabOn">업무처리 프로세스</li></a><a href="javascript:MovePage_2016('<%=httpurl%>','03', '07');"><li>구매대행 도입문의</li></a><a href="javascript:MovePage_2016('<%=httpurl%>','04', '01');"><li>신규협력사 가입안내</li></a><a href="javascript:MovePage_2016('<%=httpurl%>','04', '02');"><li>회원가입하기</li></a><a href="javascript:MovePage_2016('<%=httpurl%>','04', '03');"><li>계약서류 다운로드</li></a>
                </ul>   
            </div>
        </div>
        
        
		<div class="subcontent">
          <div class="sub03_process">
                <p class="subcontentTit" >고객사 업무처리 프로세스</p>
                <div class="process01" style="background:url(/resources/images/2016/m12.png) no-repeat 0px 55px;">
                	<p style="position:relative;width:100%; height:50px; line-height:50px; background:url(/resources/images/2016/br04.gif) bottom repeat-x;background-color:#e5e5e5; text-align:center; font-weight:bold; font-size:18px; ">
               	  	<p style="position:absolute; width:553px;height:50px; line-height:50px; top:0px;left:0px;background:url(/resources/images/2016/dot06.png) ; font-weight:bold">요청부서</p>
                    <p style="position:absolute; width:530px;height:50px; line-height:50px; top:0px;left:550px; background:url(/resources/images/2016/dot06.png) ; font-weight:bold ">발주부서</p>
                    <p style="position:absolute; width:1px; height:192px; top:0px;left:552px; background:url(/resources/images/2016/br05.gif) repeat-y;"></p>
                    </p>
                    <p style="position:absolute;top:140px;left:60px; font-size:15px; font-weight:bold ">신규상품신청</p>
                    <p style="position:absolute;top:110px;left:165px; font-size:15px; font-weight:bold ; color:#ee3212">NO</p>
                    <p style="position:absolute;top:110px;left:195px; font-size:15px; font-weight:bold ; color:#ee3212">YES</p>
                    <p style="position:absolute;top:110px;left:495px; font-size:15px; font-weight:bold ; color:#ee3212">NO</p>
                    <p style="position:absolute;top:110px;left:615px; font-size:15px; font-weight:bold ; color:#ee3212">NO</p>
                    <ul style="margin-top:30px">
                    	<li>상품검색</li>
                        <li><img src="/resources/images/2016/arrow10.png" /></li>
                        <li>상품유무확인</li>
                        <li><img src="/resources/images/2016/arrow10.png" /></li>
                        <li>장바구니</li>
                        <li><img src="/resources/images/2016/arrow10.png" /></li>
                        <li>결재</li>
                        <li><img src="/resources/images/2016/arrow10.png" /></li>
                        <li>구매요청</li>
                        <li><img src="/resources/images/2016/arrow10.png" /></li>
                        <li>구매요청접수</li>
                        <li><img src="/resources/images/2016/arrow10.png" /></li>
                        <li>발주</li>
                        <li><img src="/resources/images/2016/arrow10.png" /></li>
                        <li>납기관리</li>
                        <li><img src="/resources/images/2016/arrow10.png" /></li>
                        <li>입고처리</li>
                        <li><img src="/resources/images/2016/arrow10.png" /></li>
                        <li>정산</li>
                    </ul>
                </div>
           		<div style="position:relative;width:100%; height:50px; line-height:50px; margin-top:10px ; font-weight: ">
                    <p style="position:absolute; width:300px;height:50px; line-height:50px; top:0px;left:0px; font-size:18px; text-align:center; background-color:#ee3212; color:#fff">프로세스절차</p>
                    <p style="position:absolute; width:778px;height:50px; line-height:50px; top:0px;left:301px; font-size:18px; text-align:center; background-color:#4b4948; color:#fff">ssss</p>
                </div>
                <div class="PR01" style="margin-bottom:90px">
                    <ul class="PRtab" id="PRtab">
                        <li class="on">상품검색</li>
                        <li>신규상품신청</li>
                        <li>장바구니</li>
                        <li>구매요청</li>
                        <li>결재</li>
                        <li>구매요청 접수 및 주문</li>
                        <li>납기관리</li>
                        <li>입고처리</li>
                        <li>정산</li>
                      </ul>
                      <div class="PRtab_con" id="PRtab_con">
                        <div>
                        	<p class="PRtit"> <b >상품검색 -</b> 사용자가 카탈로그에서 필요한 물품을 검색하여 장바구니에 담는 단계</p>
                            <p class="PRimg" ><img src="/resources/images/2016/PR01.gif" /></p>
                            <p class="PRtxt" style=" padding-top:15px">koreab2b.com의 상품검색은 크게 3가지 입니다.</br> <span style="color:#ee3212"> ①구매대행 계약된 공통/전용 카탈로그 검색, ②이전에 주문했던 내역이 담긴 이력상품검색, </br> 
                            ③사용자가 등록한 관심상품검색  </span>모든 검색 시 카테고리, 상품명, 규격, 제조사 등 다양한 검색기능을 제공합니다.</p>
                        </div>
                        <div>
                        	<p class="PRtit"> <b >신규상품신청 -</b> 상품검색 후 원하는 상품이 미등록 되었을 경우 kep담당자에게 의뢰 입력하는 단계</p>
                            <p class="PRimg" ><img src="/resources/images/2016/PR02.gif" /></p>
                            <p class="PRtxt" style=" padding-top:25px">koreab2b.com에 미등록 되어 있는 상품을 견적 입력하고 kep담당자에게 의뢰하여 상품등록을 요청합니다.</br> 견적서 접수 후 단가합의하면 상품등록이 완료됩니다.</p>
                        </div>
                        <div>
                        	<p class="PRtit"> <b >장바구니 -</b> 상품을 검색하여 선택 후 장바구니에 담은 품목을 주문하는 단계</p>
                            <p class="PRimg" ><img src="/resources/images/2016/PR03.gif" /></p>
                            <p class="PRtxt" style=" padding-top:25px">카탈로그 검색 후 장바구니에 담은 상품을 선택하여 <span style="color:#ee3212">“바로주문”</span>을 클릭하면 구매요청 단계로 넘어가며</br> 
                            “관심상품등록” 을 클릭하면 <span style="color:#ee3212">관심상품등록</span>에 저장되어 자주 구매요청을 하는 상품을 쉽게 검색/요청할 수 있습니다</p>
                        </div>
                        <div>
                        	<p class="PRtit"> <b >구매요청 -</b> 장바구니에서 주문한 주문정보 및 배송정보 확인 후 최종 구매요청하는 단계</p>
                            <p class="PRimg" ><img src="/resources/images/2016/PR04.gif" /></p>
                            <p class="PRtxt" style=" padding-top:25px">장바구니에서 주문을 하면 주문정보 및 배송정보를 확인하며 변경 할 수 있습니다.</br> 
                            최종 확인 후 <span style="color:#ee3212">“주문하기</span>” 버튼을 클릭하면 부서 내 결재자 에게 결재 상신되며, 결재함에서 결재상신한 내역과결재상태를 조회하게 됩니다. </p>
                        </div>
                        <div>
                        	<p class="PRtit"> <b >결재 -</b> 요청부서내의 결재자가 구매요청 된 사항을 조회하고 구매부서로 구매요청을 승인하는 단계</p>
                            <p class="PRimg" ><img src="/resources/images/2016/PR05.gif" /></p>
                            <p class="PRtxt" style=" padding-top:15px">요청부서의 결재자는 구매요청자가 결재상신한 내역을 조회한 뒤, 승인 또는 반려할 수 있으며, 결재 시 결재자의 </br>  의견 및 반려사유를 입력하여 구매요청자 메세지를 전달할 수 있습니다. 
                            결재자의 승인이 이루어지면 구매부서로</br> 자동 구매 요청되어지고, 주문자는 결재진행내역을 상신함에서 조회할 수 있습니다. </p>
                        </div>
                        <div>
                        	<p class="PRtit"> <b >구매요청접수 및 주문 -</b> 구매부서가 요청부서의 승인된 구매요청 내역을 조회하고, 협력사로 주문하는 단계</p>
                            <p class="PRimg" ><img src="/resources/images/2016/PR06.gif" /></p>
                            <p class="PRtxt" style=" padding-top:15px">구매부서의 담당자는 요청부서에서 구매요청한 내역을 조회한 뒤, 주문하거나 반려할 수 있습니다.</br>
                            주문서 입력시 필요에 따라 승인수량 및 납기요청일을 수정할 수 있습니다. 반려 시에는 반려사유를 입력함으로써 주문처리가 </br>승인되면 주문내역이 협력사에게 실시간으로 전달됩니다. </p>
                        </div>
                       <div>
                        	<p class="PRtit"> <b >납기관리 -</b> 협력사가 입력한 납품예정일, 주문수량, 납품수량 등을 조회하며 납기요청일내에 납품되도록 관리하는 단계</p>
                            <p class="PRimg" ><img src="/resources/images/2016/PR07.gif" /></p>
                            <p class="PRtxt" style=" padding-top:25px">주문한 목록을 다양한 조건으로 조회하고 주문진행상태를 확인할 수 있습니다.</br> 납기요청일, 주문수량, 납품예정일 등을 조회하여 납품지연을 사전에 예방할 수 있습니다. </p>
                        </div>
                        <div>
                        	<p class="PRtit"> <b >입고처리 -</b> 납품된 품목을 시스템에 입고등록하는 단계</p>
                            <p class="PRimg" ><img src="/resources/images/2016/PR08.gif" /></p>
                            <p class="PRtxt" style=" padding-top:15px">납품명세서 번호, 주문번호별 조회할 수 있으며, 협력사가 납품 시 제출한 거래명세서를 바탕으로 납품된 품목을 찾아</br>입고 등록을 하게 됩니다. 
                            입고수량과 송장수량은 일치해야 하며 불일치 시 협력사에게 납품수량만큼 거래명세서를 </br>다시 재수정 요청할 수 있습니다.</p>
                        </div>
                        <div>
                        	<p class="PRtit"> <b >정산 -</b> 해당 기간동안 입고처리 된 내역을 조회하는 단계</p>
                            <p class="PRimg" ><img src="/resources/images/2016/PR09.gif" /></p>
                            <p class="PRtxt" style=" padding-top:35px">입고완료, 마감완료별로 내역을 조회합니다.</p>
                        </div>
                      </div>
                  </div>
                   <p class="subcontentTit" >협력사 업무처리 프로세스</p>
                   <div class="process02" >
                	<p style="position:relative;width:100%; height:50px; line-height:50px; background:url(/resources/images/2016/br04.gif) bottom repeat-x;background-color:#e5e5e5; text-align:center; font-weight:bold;font-size:18px; ">
                   	 <p style="position:absolute; width:633px;height:50px; line-height:50px; top:0px;left:0px;background:url(/resources/images/2016/dot06.png) ; font-weight:bold">납품 전</p>
                        <p style="position:absolute; width:445px;height:50px; line-height:50px; top:0px;left:634px; background:url(/resources/images/2016/dot06.png) ; font-weight:bold ">납품 후</p>
                        <p style="position:absolute; width:1px; height:127px; top:0px;left:633px; background:url(/resources/images/2016/br05.gif) repeat-y;"></p>
                    </p>
                    <ul style="margin-top:25px">
                    	<li>수주접수</li>
                        <li><img src="/resources/images/2016/arrow10.png" /></li>
                        <li>납기관리</li>
                        <li><img src="/resources/images/2016/arrow10.png" /></li>
                        <li>송장작성</li>
                        <li><img src="/resources/images/2016/arrow10.png" /></li>
                        <li>납품실적등록</li>
                        <li><img src="/resources/images/2016/arrow10.png" /></li>
                        <li>정산</li>
                    </ul>
                   </div>
                   <div style="position:relative;width:100%; height:50px; line-height:50px; margin-top:10px  ">
                    <p style="position:absolute; width:300px;height:50px; line-height:50px; top:0px;left:0px; font-size:18px; text-align:center; background-color:#ee3212; color:#fff">프로세스절차</p>
                    <p style="position:absolute; width:778px;height:50px; line-height:50px; top:0px;left:301px; font-size:18px; text-align:center; background-color:#4b4948; color:#fff">ssss</p>
                   </div>
                   <div class="PS01" style="margin-bottom:90px">
                    <ul class="PStab" id="PStab">
                        <li class="on">수주접수</li>
                        <li>납기관리</li>
                        <li>거래명세서 작성</li>
                        <li>납품실적등록</li>
                        <li>정산</li>
                     </ul>
                      <div class="PStab_con" id="PStab_con">
                        <div>
                        	<p class="PRtit"> <b >수주접수 -</b> 고객사로부터 주문된 내역을 확인하고 납품예정일 및 납품예정 수량을 입력하는 단계</p>
                            <p class="PRimg" ><img src="/resources/images/2016/PR10.gif" /></p>
                            <p class="PRtxt" style=" padding-top:15px">고객사에서 주문된 내역을 확인하고, 고객사의 납기요청일과 납품가능일을 참고하여 </br> 납품예정일과 수량을 입력함으로써 고객사에게 납품계획일정을 알려준다. 
                            납품예정일이 납기요청일 이후</br>  일자를 입력하는 경우는 지연사유를 간략히 입력하게 되며, 입력한 사유는 고객사에서 열람할 수 있다.</p>
                        </div>
                        <div>
                        	<p class="PRtit"> <b >납기관리 -</b> 납품계획일정에 따라 납품할 수 있도록 관리하는 단계</p>
                            <p class="PRimg" ><img src="/resources/images/2016/PR11.gif" /></p>
                            <p class="PRtxt" style=" padding-top:35px">납기요청일이 지났는데도 아직 납품실적되지 않은 내역을 조회함으로써 납품계획 일정에 따라 납품할 수 있도록 납기를 관리합니다.</p>
                        </div>
                        <div>
                        	<p class="PRtit"> <b >거래명세서 작성 -</b> 거래명세서를 생성하고 납품 시 제출할 납품명세서를 출력하는  단계</p>
                            <p class="PRimg" ><img src="/resources/images/2016/PR12.gif" /></p>
                            <p class="PRtxt" style=" padding-top:15px">수주접수한 내역 중에서 납품준비된 내역을 선택하여 등록버튼을 클릭합니다.
                            실제 납품할 일자 및 수량을 입력하여</br>  납품명세서를 생성하면, 납품 시 필요한 납품명세서 출력화면이 생성됩니다.
                            납품명세서 생성 후 실제 납품일자가 </br> 변경된 경우는 납품명세서 조회 화면에서 납품일을 변경하여 거래명세서를 새로 출력하여 사용할 수 있습니다.</p>
                        </div>
                        <div>
                        	<p class="PRtit"> <b >납품실적등록 -</b> 납품 후 시스템에 납품실적을 등록하는  단계</p>
                            <p class="PRimg" ><img src="/resources/images/2016/PR13.gif" /></p>
                            <p class="PRtxt" style=" padding-top:15px">납품실적등록에서 납품명세서 생성한 내역을 조회할 수 있습니다. 조회된 내역 중에서 </br> 납품실적 등록할 내역을 선택한 후 납품한 일자 및 수량을 입력하여 
                            납품이 완료되었음을 시스템에 등록합니다.</br> 납품실적등록 자료는 고객사에서 송부한 입고자료와 비교하여 정산하므로 납품 후 반드시 실적등록을 해야 합니다.
                        </div>
                        <div>
                        	<p class="PRtit"> <b >정산 -</b> 해당기간 동안 입고된 내역을 조회하고 세금계산서를 발행하는 단계</p>
                            <p class="PRimg" ><img src="/resources/images/2016/PR14.gif" /></p>
                            <p class="PRtxt" style=" padding-top:15px">마감정보 조회에서 해당기간 동안 입고된 내역 및 집계를 고객사별로 확인 할 수 있습니다.</br>
                            전체 고객사의 입고금액 합계를 확인하고 코리아이플랫폼(주)으로 세금계산서를 발행합니다. </br>이때, 조회된 상세 마감내역은 엑셀로 다운로드 받아 내부 자료로 활용할 수 있습니다. </p>
                        </div>
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

