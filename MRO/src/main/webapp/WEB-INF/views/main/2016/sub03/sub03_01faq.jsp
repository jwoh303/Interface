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
	tab('#faqtab',0);	
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
//TAB
function initToggle(tabContainer) {
	triggers = tabContainer.getElementsByTagName("a");

	for(i = 0; i < triggers.length; i++) {
		if (triggers.item(i).href.split("#")[1])
			triggers.item(i).targetEl = document.getElementById(triggers.item(i).href.split("#")[1]);

		if (!triggers.item(i).targetEl)
			continue;

		triggers.item(i).targetEl.style.display = "none";
		triggers.item(i).onclick = function () {
			if (tabContainer.current == this) {
				this.targetEl.style.display = "none";
				tabContainer.current = null;
			} else {
				if (tabContainer.current) {
					tabContainer.current.targetEl.style.display = "none";
				}
				this.targetEl.style.display = "block";
				tabContainer.current = this;
			}
			return false;
		}
	}
};
</script>
    <!--컨텐츠-->
    <div class="subcontentsArea">
    	<div class="subbanner" >
        	 
            <div class="subbannerimg"><img src="/resources/images/2016/SB12.jpg" /></div>
            <div class="subbannertxt" > 
            	<p class="sbtit">FAQ</p>
            	<p>작은 목소리에도 귀 기울이는 KeP!</p>
            </div>
            <div class="subbannerbg" ></div>
        </div>
        <div class="subtab">
        	<div class="subtabBg"></div>
            <div class="subtabList04">
            	<ul>
                    <a href="javascript:MovePage_2016('<%=httpurl%>','03', '01');"><li class="subtabOn">FAQ</li></a><a href="javascript:MovePage_2016('<%=httpurl%>','03', '02');"><li >업무처리 프로세스</li></a><a href="javascript:MovePage_2016('<%=httpurl%>','03', '07');"><li>구매대행 도입문의</li></a><a href="javascript:MovePage_2016('<%=httpurl%>','04', '01');"><li>신규협력사 가입안내</li></a><a href="javascript:MovePage_2016('<%=httpurl%>','04', '02');"><li>회원가입하기</li></a><a href="javascript:MovePage_2016('<%=httpurl%>','04', '03');"><li>계약서류 다운로드</li></a>
                </ul>   
            </div>
        </div>
		<div class="subcontent">
          <ul class="faqtab" id="faqtab">
            <li class="on" style="width:359px;">공용</li>
            <li style="width:360px;">고객사</li>
            <li style="width:360px;">협력사</li>
          </ul>
          <div class="faqtab_con" id="faqtab_con">
            <div >
                <table class="faqtable" id="faq-list">
                  <colgroup>
                  <col width="32%" />
                  <col width="68%" />
                  </colgroup>
                    <tr>
                      <th>시스템</th>
                      <td ><a href="#answer2">매뉴얼은 어디서 볼 수 있나요?</a></td>
                    </tr>
                    <tr>
                      <td colspan="2" style="padding:0; border-bottom:0"><div id="answer2" class="answer" >
                      고객사 사이트 또는 협력사 사이트로 로그인하신 후 아랫쪽 [매뉴얼 다운로드]에서 해당 매뉴얼을 다운로드 하실수 있습니다.</div>
                      </td>
                    </tr>
                    
                    <tr>
                      <th >시스템</th>
                      <td><a href="#answer3">비밀번호 및 주소변경은 어디서 할 수 있나요?</a></td>
                    </tr>
                    <tr>
                      <td colspan="2" style="padding:0; border-bottom:0" ><div id="answer3" class="answer">고객사는 로그인 후 개인정보 수정화면에서, 협력사는 로그인 후 상단의 개인정보에서 수정하실 수 있습니다. </div></td>
                    </tr>
                    
                    <tr>
                      <th >회원가입</th>
                      <td><a href="#answer4">회원사 및 사용자 가입은 어떻게 하나요?</a></td>
                    </tr>
                    <tr>
                      <td colspan="2" style="padding:0; border-bottom:0"><div id="answer4" class="answer">
                      koreab2b.com 접속후, “이용안내 > 회원가입하기”에서  회원사 등록에 필요한 정보를 입력하고, 등록승인에 필요한 제출서류를 우편으로 송부하시면 됩니다.  </div></td>
                    </tr>
                    
                     <tr>
                      <th >회원가입</th>
                      <td><a href="#answer5">회원사 등록 승인이 지연됩니다.</a></td>
                    </tr>
                    <tr>
                      <td colspan="2" style="padding:0; border-bottom:0"><div id="answer5" class="answer">
                      회원사 등록승인은 송부하신 서류 도착 후 1~2일 정도가 소요됩니다. <br />등록승인이 지연되면 당사 사업팀 담당자에게 문의하시기 바랍니다. </div></td>
                    </tr>
                    <tr>
                      <th >회원가입</th>
                      <td><a href="#answer6">ID, 비밀번호를 잊어버렸어요.</a></td>
                    </tr>
                    <tr>
                      <td colspan="2" style="padding:0; border-bottom:0"><div id="answer6" class="answer">
                       로그인 입력 부분 아래쪽 ID/PW 찾기를 이용하시면, 이메일 혹은 휴대폰으로  
                       임시 비밀번호를 발급받으실수 있습니다. (문의전화 : 02-3016-7251)</div></td>
                    </tr>
                    <tr>
                      <th >회원가입</th>
                      <td><a href="#answer7">회사정보가 변경 되었습니다.</a></td>
                    </tr>
                    <tr>
                      <td colspan="2" style="padding:0; border-bottom:0"><div id="answer7" class="answer">회사의 담당자 및 연락처 정보는 Admin사용자가 수정하실 수 있습니다. <br />
                        다만, 귀사의 사업자 등록증이 변경된 경우는 당사 사업팀 담당자에게 변경된 사항에 대한 서류를 송부해 주시면 변경해 드립니다.</div></td>
                    </tr> 
                    <tr>
                      <th >회원가입</th>
                      <td><a href="#answer8">회원가입 시 입력하는 개인정보에 대한 유출의 우려는 없나요?</a></td>
                    </tr>
                    <tr>
                      <td colspan="2" style="padding:0; border-bottom:0"><div id="answer8" class="answer">
                     koreab2b.com은 개인정보에 대한 수집, 보유 등의 활동에 있어 철저한 보안을 유지하기 위해 한국인터넷진흥원에서 주관하는<br />
                     정보보호 인증제도인 ISMS(Information Security Management System) 인증을 획득하였고, 이 기준에 맞추어 관리 운영하고 있습니다.</div></td>
                    </tr>
                    <tr>
                      <th >회원가입</th>
                      <td><a href="#answer9">회원가입 관련문의</a></td>
                    </tr>
                    <tr>
                      <td colspan="2" style="padding:0; border-bottom:0" ><div id="answer9" class="answer"><b><span class="FontBlue">콜센터 전화</span></b> - 
                        서울 : 02-3016-8989  // 창원 : 055-270-6200  </div></td>
                    </tr>
                </table> 
                <script type="text/javascript">
                initToggle(document.getElementById("faq-list"));
                </script>   
            </div>
            <div>
                <table class="faqtable" id="faq-list02">
                  <colgroup>
                  <col width="32%" />
                  <col width="68%" />
                  </colgroup>
                  <tr>
                    <th scope="col">주문배송</th>
                    <td ><a href="#answer10" >배송은 언제쯤 받을 수 있나요?</a></td>
                  </tr>
                  <tr>
                    <td colspan="2" style="padding:0; border-bottom:0"><div id="answer10" class="answer" >
                    	협력사는 수주접수시 납품예정일을 입력하게 됩니다. <br />
                        협력사가 입력한 납품예정일, 송장생성일, 납품실적 등록일의 진행현황은
                        “주문관리 > 배송조회”에서 조회해 보실 수 있습니다.<br />
                        부득이 통상적인 예상납기보다 급히 상품이 필요한 경우는  KeP담당자나 콜센터로 전화 주시면 처리해 드리겠습니다.<br /><br />
                        <b><span class="FontBlue">콜센터 전화 -</span></b>                        서울 : 02-3016-8989  // 창원 : 055-270-6200 
                        </div></td>
                  </tr>
                  <tr>
                    <th scope="col">주문배송</th>
                    <td ><a href="#answer11" >주문한 상품이 다른 상품으로 잘못 배송 됐습니다.</a></td>
                  </tr>
                  <tr>
                    <td colspan="2" style="padding:0; border-bottom:0" ><div id="answer11" class="answer" >
                    	품질불만, 고객의 변심 등에 의해 교환/반품을 원하실 경우는 진행상황에 따라 처리하셔야 합니다.<br /><br />
                        ① 배송전 주문취소의 경우에는 "주문관리 > 주문진행현황”에서 해당 주문을 조회하신 후 주문취소 처리하시면됩니다.<br />
                        ② 납품완료, 정산완료 후 반품은 "주문관리 > 주문진행현황”에서 해당 주문을 조회하신 후 반품/교환으로 처리하시면 KeP 담당자의 접수 후 직접 연락을 드리겠습니다.<br /><br />
                        <b><span class="FontBlue">콜센터 전화 - </span></b>
                        서울 : 02-3016-8989  // 창원 : 055-270-6200 </div></td>
                  </tr>
                  <tr>
                    <th scope="col">주문배송</th>
                    <td ><a href="#answer12" >납품된 수량이 발주낸 수량보다 모자랍니다</a></td>
                  </tr>
                  <tr>
                    <td colspan="2" style="padding:0; border-bottom:0"><div id="answer12" class="answer" >납품된 수량이 거래명세서의 수량보다 작을 경우, 아래 세가지 방법 중 하나를 택하시면 됩니다. <br /> <br />
                        ① 전체수량이 준비될 때 함께 납품하도록 납품받지 않는 방법<br />
                        ② 납품된 수량만 납품을 받고 시스템상에 그 수량 만큼만 입고처리하는 방법(이때, 부족한 수량은 다시 발주 내시면 됩니다.)<br />
                        ③ 납품된 수량만큼은 납품을 받고 나머지 수량이 납품되면 입고처리하는 방법</div></td>
                  </tr>
                  <tr>
                    <th scope="col">주문배송</th>
                    <td ><a href="#answer13" >배송하시는 분이 불친절해요.</a></td>
                  </tr>
                  <tr>
                    <td colspan="2" style="padding:0; border-bottom:0"><div id="answer13" class="answer" >당사에서는 가격경쟁력은 물론 품질, 납기, 서비스 등의 요소를 바탕으로 협력사 평가를 시행하고 있습니다. <br />
                        협력사 평가에서 좋지 않은 평가를 받게 되면 향후 거래물량 및 거래조건에 있어서 패널티를 적용합니다. <br />
                        불편한 사항이 있으시면 당사 콜센터로 전화주시면 신속히 처리해 드리겠습니다.</div></td>
                  </tr>
                  <tr>
                    <th scope="col">주문배송</th>
                    <td ><a href="#answer14" >사무용품 발주/배송 관련문의</a></td>
                  </tr>
                  <tr>
                    <td colspan="2" style="padding:0; border-bottom:0"><div id="answer14" class="answer" >사업팀 사무용품담당자 (02-3016-8939)</div></td>
                  </tr>
                  <tr>
                    <th scope="col">주문배송</th>
                    <td ><a href="#answer15" >공장용품 발주/배송 관련문의</a></td>
                  </tr>
                  <tr>
                    <td colspan="2" style="padding:0; border-bottom:0" ><div id="answer15" class="answer" ><b><span class="FontBlue">콜센터 전화</span></b> - 
                        서울 : 02-3016-8989  // 창원 : 055-270-6200 </div></td>
                  </tr>
                  <tr>
                    <th scope="col">수주납품 및 견적관련</th>
                    <td ><a href="#answer16" >당월 정산내역을 어디서 볼 수 있나요?</a></td>
                  </tr>
                  <tr>
                    <td colspan="2" style="padding:0; border-bottom:0"><div id="answer16" class="answer" >“입고관리 > 마감조회”에서 해당 월의 마감내역을 조회하실 수 있습니다.</div></td>
                  </tr>
                  <tr>
                    <th scope="col">수주납품 및 견적관련</th>
                    <td ><a href="#answer17" >마감일을 무조건 말일로 해야 하나요?</a></td>
                  </tr>
                  <tr>
                    <td colspan="2" style="padding:0; border-bottom:0"><div id="answer17" class="answer" >현재 마감일을 25일, 말일 중 하나를 선택함이 원칙이나 부득이 다른 일자를 원하시면 당사 사업팀과 협의하여 조정하시기 바랍니다.</div></td>
                  </tr>
                  <tr>
                    <th scope="col">수주납품 및 견적관련</th>
                    <td ><a href="#answer18" >마감을 월 2회 할 수 있나요?</a></td>
                  </tr>
                  <tr>
                    <td colspan="2" style="padding:0; border-bottom:0" ><div id="answer18" class="answer" >당사는 월 1회 마감이 원칙이나 구매회원사의 정산주기에 따라 2회(15일, 말일) 정산이 가능 합니다.</div></td>
                  </tr>
                  <tr>
                    <th scope="col">수주납품 및 견적관련</th>
                    <td ><a href="#answer19" >사업장별 또는 품목별로 세금계산서 발행이 가능하나요?</a></td>
                  </tr>
                  <tr>
                    <td colspan="2" style="padding:0; border-bottom:0" ><div id="answer19" class="answer" >사전에 연락을 주시면 사업장별 세금계산서 발행이 가능하며, 품목별로 발행을 원하시는 경우는 <br />
                        사무용품과 공장소모자재로 구분하여 발행이 가능하오니 당사 사업팀으로 문의바랍니다.</div></td>
                  </tr>
                  <tr>
                    <th scope="col">수주납품 및 견적관련</th>
                    <td ><a href="#answer20" >대금결제방식은 어떤 것이 있나요?</a></td>
                  </tr>
                  <tr>
                    <td colspan="2" style="padding:0; border-bottom:0" ><div id="answer20" class="answer" >구매회원사의 결제조건에 따라 현금지급, 신용카드결제, 30일 또는 60일 어음지급 조건 중 협의가 가능하며, <br />
                        구매자금대출, 구매카드제도 등의 전자결제제도를 이용하시면 업무효율화, 세제지원 등의 혜택이 있습니다.</div></td>
                  </tr>
                  <tr>
                    <th scope="col">수주납품 및 견적관련</th>
                    <td ><a href="#answer21" >정산/결제 관련문의</a></td>
                  </tr>
                  <tr>
                    <td colspan="2" style="padding:0; border-bottom:0" ><div id="answer21" class="answer" ><b><span class="FontBlue">콜센터 전화 - </span></b>
                        서울 : 02-3016-8989  // 창원 : 055-270-6200  </div></td>
                  </tr>
                </table>
                <script type="text/javascript">
                initToggle(document.getElementById("faq-list02"));
                </script>
            
            
            </div>
            <div>
            	<table class="faqtable" id="faq-list03">
                  <colgroup>
                  <col width="32%" />
                  <col width="68%" />
                  </colgroup>
                  <tr>
                    <th scope="col">회원가입</th>
                    <td ><a href="#answer22" >당사의 공급업체로 등록을 하시려면?</a></td>
                  </tr>
                  <tr>
                    <td colspan="2" style="padding:0; border-bottom:0" ><div id="answer22" class="answer" >
                    	당사는 귀사와의 거래를 함에 있어 아래의 서류들을 필히 보관하고 있어야 하오니 아래 서류를 당사 사업팀 담당자에게 우편 송부하여 주시면 감사하겠습니다.<br />
                        ※아래서류 중 거래약정서는 다운로드에서 거래약정서를 클릭하셔서 당사 소정양식을 프린트하시어 2부를 작성 날인하여 당사로 송부해 주시면 당사에서 날인하여 1부를 재송부해 드리겠습니다. <br />
                        <br />
                        ※ 당사 요청자료 <br />
                        1. 사업자사본<br />
                        2. 통장사본(정산용으로 법인명의 혹은 대표이사 명의 통장)<br />
                        3. <a href="/resources/excel/work/MAIN/Basic_goods_trading_contract_W.docx"> <b> <font color="#ee3212"> <u style="color: #ee3212; ">거래약정서</u> </font> </b> </a> (MS_WORD양식), 
                        <a href="/resources/excel/work/MAIN/useSeal.zip"> <b> <font color="#ee3212"> <u style="color: #ee3212;">사용인감계</u> </font> </b> </a>(MS_WORD양식)<br />
                        4. 결제계좌신고서 (당사 Site 회원등록 시, 작성 및 출력)<br />
                        5. 법인인감증명서<br />
                        <br />
                        ※ 관련문의 - 당사 콜센터  서울 : 02-3016-8989 // 창원 : 055-270-6200</div></td>
                  </tr>
                  <!--tr>
                    <th scope="col">회원가입</th>
                    <td ><a href="#answer23" >다운로드가 안되시나요?</a></td>
                  </tr>
                  <tr>
                    <td colspan="2" style="padding:0; border-bottom:0"><div id="answer23" class="answer" >Windows XP의 경우에 다운로드가 안되실 수 있습니다.<br />
                        <br />
                        조치 방법은 인터넷 브라우져 상단 메뉴중 [도구 >> 인터넷 옵션 >> 고급 탭]으로 이동하시어 하단 리스트 중에 탐색 항목중 맨 마지막 항목인 URL을 항상 UTF-8로 보냄(다시 시작해야 함)  
                        부분에 체크가 되어 있는것을 체크 해제 해 주시고 브라우져를 다시 로딩 하시어 다운로드 하시면 정상적으로 다운로드 됩니다. </div></td>
                  </tr-->
                  <tr>
                    <th scope="col">회원가입</th>
                    <td ><a href="#answer24" >구매카드 사용안내</a></td>
                  </tr>
                  <tr>
                    <td colspan="2" style="padding:0; border-bottom:0" ><div id="answer24" class="answer" ><a href="/resources/excel/work/MAIN/buyCardUseGuide.zip"> <b> <font color="#ee3212"> <u style="color: #ee3212; font-size: 15px;">구매카드이용안내</u> </font> </b> </a>(MS_WORD양식), <a href="/resources/excel/work/MAIN/buyCardUseGuide_H.zip"> <b> <font color="#ee3212"> <u style="color: #ee3212; font-size: 15px;">구매카드이용안내</u> </font> </b> </a>(아래한글양식)<br />
                        <br />
                        자세한 문의는 하나은행 구매카드 담당부서나 당사 자금팀으로 연락주시기 바랍니다.<br />
                        <!--☎ 하나은행 구매카드 담당부서 02) 3709-6381~3 <br /-->
                        ☎ 당사 자금팀 구매카드 담당 02) 3016-8971 </div></td>
                  </tr>
                  <tr>
                    <th scope="col">회원가입</th>
                    <td ><a href="#answer25" >당사의 전자입찰/역경매 참여 공급업체로 등록을 하시려면?</a></td>
                  </tr>
                  <tr>
                    <td colspan="2" style="padding:0; border-bottom:0"><div id="answer25" class="answer" >당사는 귀사와의 거래를 함에 있어 아래의 서류들을 필히 보관하고 있어야 하오니 아래 서류를 당사로 우편 송부하여 주시면 감사하겠습니다.<br />
                        <br />
                        ※아래서류 중 기본계약서는 다운로드에서 기본계약서를 클릭하셔서 당사 소정양식을 프린트하시어  2부를 작성 날인하여당사로 송부해 주시면 당사에서 날인하여 1부를 재송부해 드리겠습니다. <br />
                        <br />
                        1. 사업자사본<br />
                        2. <a href="/resources/excel/work/MAIN/elecBidContract.zip"> <b> <font color="#ee3212"> <u style="color: #ee3212; font-size: 15px;">입찰계약서</u> </font> </b> </a>, <a href="/resources/excel/work/MAIN/elecBidContract_H.zip"> <b> <font color="#ee3212"> <u style="color: #ee3212; font-size: 15px;">입찰계약서</u> </font> </b> </a>(아래한글양식)<br />
                        3. 법인인감증명서<br />
                        <br />
                        ※ 관련문의 : 사업팀 (02-3016-8976)</div></td>
                  </tr>
                  <tr>
                    <th scope="col">로그인</th>
                    <td ><a href="#answer26" >윈도우10 변경 후 하드디스크의 인증서가 조회되지 않나요?</a></td>
                  </tr>
                  <tr>
                    <td colspan="2" style="padding:0; border-bottom:0"><div id="answer26" class="answer" >
                    	1.코리아이플랫폼 웹브라우저를 모두 닫습니다.<br/>
                    	2.제어판 > 프로그램 및 기능 > 프로그램 제거 또는 변경 에서 "CrossCertWeb v2.0" 을 제거합니다.<br/>
                    	3.인증서 로그인 모듈을 하기 수동 프로그램 설치를 통하여 재설치하시기 바랍니다.<br />
                        <br />
                        <br />
                        <a href="/resources/crosscert/one_click_setup.zip"> <b> <font color="#ee3212"> <u style="color: #ee3212; font-size: 15px;">수동 프로그램 설치</u> </font> </b> </a><br />
                        </div></td>
                  </tr>
                  <tr>
                    <th scope="col">수주납품 및 견적관련</th>
                    <td ><a href="#answer27" >수주는 어떻게 하나요?</a></td>
                  </tr>
                  <tr>
                    <td colspan="2" style="padding:0; border-bottom:0" ><div id="answer27" class="answer" >
                    “납품관리 > 수주접수”에서 발주내역을 확인할 수 있으며 납품예정일을 등록함으로써 수주처리가 됩니다.<br />
                      이때 납품예정일은 고객사의 납기 요청일을 참고하여 납품 가능한 일자를 입력하시기 바랍니다.</div></td>
                  </tr>
                  <tr>
                    <th scope="col">수주납품 및 견적관련</th>
                    <td ><a href="#answer28" >거래명세서 작성은 어떻게 합니까?</a></td>
                  </tr>
                  <tr>
                    <td colspan="2" style="padding:0; border-bottom:0" ><div id="answer28" class="answer" >
                    “납품관리 > 거래명세서 > 거래명세서 작성”에서 실제 납품 일을 입력한 후 거래명세서를 생성합니다. <br />
                      거래명세서 생성이 완료되면 양식을 출력할 수 있는 창이 생성됩니다. 여기서 거래명세서를 2장 출력하시면 됩니다.</div></td>
                  </tr>
                  <tr>
                    <th scope="col">수주납품 및 견적관련</th>
                    <td ><a href="#answer29" >납품시 처리해야할 업무가 있습니까?</a></td>
                  </tr>
                  <tr>
                    <td colspan="2" style="padding:0; border-bottom:0"><div id="answer29" class="answer" >
                    거래명세서 2장을 지참하여 납품하신 후, 현장부서 담당자의 서명을 받아 증빙으로 보관하시고,<br />
                     납품 후, koreab2b.com에 로그인하시어 “납품관리 > 납품등록 > 납품실적등록”에서 납품 등록하시면 됩니다.<br />
                     이때 등록한 납품실적은 고객사의 입고자료와 비교하여 월마감 자료로 이용되오니 반드시 처리 하셔야 합니다.</div></td>
                  </tr>
                  <tr>
                    <th scope="col">수주납품 및 견적관련</th>
                    <td ><a href="#answer30" >신규 구매요청건에 대한 견적제출은 어떻게 합니까?</a></td>
                  </tr>
                  <tr>
                    <td colspan="2" style="padding:0; border-bottom:0" ><div id="answer30" class="answer" >
                    로그인 후, “견적관리 > 견적요청서 접수”에서 신규 구매 요청된 내역을 조회하여 견적제출 하실 수 있으며,<br />
                    “제출견적진행조회”에서 견적제출한 내역을 조회하실 수 있습니다.</div></td>
                  </tr>
                  <tr>
                    <th scope="col">수주납품 및 견적관련</th>
                    <td ><a href="#answer31" >수주납품 및 견적관련 문의</a></td>
                  </tr>
                  <tr>
                    <td colspan="2" style="padding:0; border-bottom:0"><div id="answer31" class="answer" ><b><span class="FontBlue">콜센터 전화</span></b> - 
                        서울 : 02-3016-8989  // 창원 : 055-270-6200  </div></td>
                  </tr>
                  <tr>
                    <th scope="col">정산 및 결제관련</th>
                    <td ><a href="#answer32" >월마감 내역은 어디서 확인할 수 있나요?</a></td>
                  </tr>
                  <tr>
                    <td colspan="2" style="padding:0; border-bottom:0"><div id="answer32" class="answer" >
                    “정산관리 > 마감정보조회”에서 해당월의 송장금액, 입고금액을 비교 조회하실 수 있습니다.<br />
                      “고객사별집계”버튼을 클릭하면 고객사별 입고된 금액의 합계가 요약되며 이 금액이 납품한 내역과 일치하면  <br />
                       구매 담당자가 전송해주는 전자세금계산서를 역전송 해주시면 됩니다.</div></td>
                  </tr>
                  <tr>
                    <th scope="col">정산 및 결제관련</th>
                    <td ><a href="#answer33" >세금계산서 발행 내용에 대해 알려 주세요</a></td>
                  </tr>
                  <tr>
                    <td colspan="2" style="padding:0; border-bottom:0" ><div id="answer33" class="answer" >당사의 협력사 세금계산서 수취방식은 역발행 전자세금계산서입니다. 절차 및 방법은 아래와 같습니다. <br /><br />
                        ① 매월 말 정산담당자와 통화 후 마감금액 확정합니다.<br />
                        ② 협력사 사이트의 &ldquo;마감정보조회"에서 당월마감내역 확인 후 세금계산서 출력버튼을 클릭하면 전자세금계산서발행 화면으로 이동합니다.<br />
                        ③ 전자세금계산서 발행을 위한 인증서 다운 후 매출 보관함에서 세금계산서 내용을 확인하신 후 전송을 클릭해주시면 발행 완료됩니다.</div></td>
                  </tr>
                  <tr>
                    <th scope="col">정산 및 결제관련</th>
                    <td ><a href="#answer34" >대금결제는 언제 되나요?</a></td>
                  </tr>
                  <tr>
                    <td colspan="2" style="padding:0; border-bottom:0" ><div id="answer34" class="answer" >구매팀과 협의된 거래조건에 의해 결제되며 회원사 가입시 제출한 결제계좌신고서에 기재토록 되어 있습니다.</div></td>
                  </tr>
                  <tr>
                    <th scope="col">정산 및 결제관련</th>
                    <td ><a href="#answer35" >구매카드제도가 무엇입니까?</a></td>
                  </tr>
                  <tr>
                    <td colspan="2" style="padding:0; border-bottom:0" ><div id="answer35" class="answer" >
                    	당사는 2002년 6월 정산분 부터 구매카드제도를 시행합니다. 구매카드는 기존의 실물어음 발행으로 인한 연쇄부도를 방지하기 위한 전자어음 제도입니다.<br />
                        구매카드제도를 도입하면 다음과 같은 이점이 있습니다. <br />
                        <br />
                        ① 대금지급 보증 : 금융기관(은행)에서 대금지급 보증<br />
                        ② 편리한 현금화 : 원하는 시점에 전액 또는 부분 할인이 가능<br />
                        ③ 저렴한 할인율 : 실물어음 할인시보다 저렴한 할인율이 적용<br />
                        ④ 업무의 효율화 : 인터넷을 통한 실시간 채권관리가 가능</div></td>
                  </tr>
                  <tr>
                    <th scope="col">정산 및 결제관련</th>
                    <td ><a href="#answer36" >정산 및 결제관련 문의</a></td>
                  </tr>
                  <tr>
                    <td colspan="2" style="padding:0; border-bottom:0" ><div id="answer36" class="answer" ><b><span class="FontBlue">콜센터 전화</span></b> - 
                        서울 : 02-3016-8989  // 창원 : 055-270-6200   </div></td>
                  </tr>
                </table>
                <script type="text/javascript">
                initToggle(document.getElementById("faq-list03"));
                </script>
            
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
<script type="text/javascript">
//ID찾기
function findId(){  
	$('#id_search').attr("method", "post");
    $('#id_search').attr("action", "/main/2016/sub04/getIdFindUserInfo.do");
    $('#id_search').submit();

} 
//패스워드찾기
function findPw(){ 
	var no = document.getElementById("st_phone_num").options.selectedIndex;
	var num1 = document.getElementById("st_phone_num").options[no].value; 
	 
	$('#st_phone_num1').val(num1);
	$('#pw_search').attr("method", "post");
    $('#pw_search').attr("action", "/main/2016/sub04/getPwFind.do");
    $('#pw_search').submit();
} 
</script>
</html>

