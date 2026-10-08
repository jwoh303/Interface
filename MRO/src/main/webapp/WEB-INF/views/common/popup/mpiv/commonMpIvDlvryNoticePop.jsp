<%--
**********************************************
* 메뉴 : 
* 화면 : 납품시 공지 팝업
* 기능 : 배송차량정보를 확인하고 선택할 수 있는 팝업(협력사에서)
* 프로그램 ID : 
* 담당자 : 
* 착수일 : 
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../../common/include/head.jspf"  %>
 

<%
	@SuppressWarnings (value="unchecked")
	String st_type = CommonUtil.nvl((String) request.getParameter("st_type"),"");
%>

<script type="text/javascript">
function setReturn() {
<%if("TYPE90".equals(st_type)){%>
	var box = eval("document.forms.commonMpIvDlvryNoticePop.st_type90_checkbox");
	if(box.checked == false){
		alert("위 내용을 확인하신 후 체크를 먼저 해주세요.");
		return;
	}
	
	kepAjaxPopFormCall("/mpiv/updateCommonMpIvDlvryNoticePop.do","commonMpIvDlvryNoticePop","save");
<%}else{%>
	window.close();
	opener.setDlvryNotice();	
<%}%>
}

/**
* ajax 공통 호출후 성공시 처리 함수
*/ 
function kepAjaxPopSuccess(pMethod, response) {
	if(pMethod == "save"){
		opener.setDlvryNotice2();
		this.close();
	}
}

/**
* ajax 공통 호출후 에러시 처리 함수
*/
function  kepAjaxPopError(pMethod, response) {
	alert("처리 하던중 오류가 발생하였습니다.");
}

</script>
</head>
<body style="overflow:hidden">
<form name="commonMpIvDlvryNoticePop" id="commonMpIvDlvryNoticePop" method="post" >
	<input type="hidden" name="st_user_id" id="st_user_id" value="${sessionInfo.userId}">
	<input type="hidden" name="st_com_code" id="st_com_code" value="${sessionInfo.comCode}">
	
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다 / 500*500-->
	<div id="popWrapper" >
<%if("TYPE1".equals(st_type)){%>	
    	<div id="popHeader">
        	<h1 class="title">납품절차 및 유의사항</h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/s_btn_popclose.gif" alt="닫기버튼" /></a></p>
        </div>
        <div id="popContainer" style="line-height:18px">
        	<img src="/resources/images/commonMpIvDlvryNoticePop.jpg" /> <br /><br />
            <b style="color:#000">◆ 납품절차 ◆</b><br />
            1. 납품서류 작성<br />
            &nbsp; &nbsp; - 거래명세서 : 기본 5장 출력 후 편지봉투 동봉하여 박스 겉면 부착<br />
            &nbsp; &nbsp; - K-tag : 박스당 개별 부착<br />
            &nbsp; &nbsp; - 물품명세표 : 박스당 개별 부착 (삼성전기만 해당)<br />
            2. 사진과 같이 납품서류 박스 겉면 부착<span style="text-decoration:underline; color:#F00"> (삼성전기 물품명세표 부착 必)</span><br />
            3. KOREAB2B 내 납품관리 - 납품실적등록 완료 필수<br /><br />
            <b style="color:#000">◆ 유의사항 ◆</b><br />
            1. 박스포장 필수 (비닐포장 및 비닐합포장 불가)<br />
            2. KEP 물류센터, 금장 -> 택배발송 가능<br />
            &nbsp; &nbsp;직납 -> 직접배송 원칙 , 삼성전기 세종/부산사업장 택배 가능<br />
            &nbsp; &nbsp;(단, 부산사업장 납품 시 <span style="text-decoration:underline; color:#F00">경동택배 “신호 326영업소”</span> 만 가능)<br /><br />
            &nbsp; &nbsp;※. 8월 부로 수원물류센터 주소 이전 되었으니 발주서 하단 납품장소 재 확인 하시어 <br />
			&nbsp; &nbsp;납품 진행 부탁 드리겠습니다.<br />
			<span style="color:#36F">- 변경 배송지: 경기 군포시 부곡동 1231 군포복합물류터미널 I동 3구획(1층)</span><br /> 
			<span style="color:#36F">- 물류센터 연락처: 031-8061-8050~8050~4</span><br /> 
        </div>
<%}else if("TYPE2".equals(st_type)){%>
		<div id="popHeader">
        	<h1 class="title">유의사항</h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/s_btn_popclose.gif" alt="닫기버튼" /></a></p>
        </div>
        <div id="popContainer" style="line-height:18px">
        	<div style="text-align:center">
        		<img src="/resources/images/commonMpIvDlvryNoticePopType2.jpg" /><br /><br />
        	</div>
            <b style="color:#000">◆ 유의사항 ◆</b><br />
            1. <span style="text-decoration:underline; color:#F00">냉장/냉동 품목 납품시 필히 유저 및 KeP 담당자에 입고 일정 공유 (수취 지연 이슈 예방)</span><br />
            2. 유저 연락처가 명세서에 기재되지 않은 경우 KeP에 문의<br />
            3. 입고 예정일<br />
            &nbsp; &nbsp; - 변동시 b2b 사이트에 업데이트 반영<br />
            4. 거래명세서<br />
            &nbsp; &nbsp; - 누락되지 않도록 재확인<br />
            &nbsp; &nbsp; - KeP 거래명세서(납품서) 1부만 동봉할 것<br />
            &nbsp; &nbsp; - 납품 박스 겉면에 부착 (윗면 또는 옆면)<br />
        </div>
<%}else if("TYPE3".equals(st_type)){%>
		<div id="popHeader">
        	<h1 class="title">유의사항</h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/s_btn_popclose.gif" alt="닫기버튼" /></a></p>
        </div>
        <div id="popContainer" style="line-height:18px">
        	<div style="text-align:center">
        		<img src="/resources/images/commonMpIvDlvryNoticePopType3.jpg" /><br /><br />
        	</div>
            <b style="color:#000">◆ 유의사항 ◆</b><br />
            1. <span style="text-decoration:underline; color:#F00">냉장/냉동 품목 납품시 필히 유저 및 KeP 담당자에 입고 일정 공유 (수취 지연 이슈 예방)</span><br />
            2. 유저 연락처가 명세서에 기재되지 않은 경우 KeP에 문의<br />
            3. 입고 예정일<br />
            &nbsp; &nbsp; - 변동시 b2b 사이트에 업데이트 반영<br />
            4. 거래명세서<br />
            &nbsp; &nbsp; - 누락되지 않도록 재확인<br />
            &nbsp; &nbsp; - KeP 거래명세서(납품서) 1부만 동봉할 것<br />
            &nbsp; &nbsp; - 거래명세서 미동봉시 이월 발생 될 수 있음<br />
        </div>
<%}else if("TYPE4".equals(st_type)){%>
		<div id="popHeader">
        	<h1 class="title">시약/화공약품 입고 담당자 및 하차장소 변경 및 유의사항</h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/s_btn_popclose.gif" alt="닫기버튼" /></a></p>
        </div>
        <div id="popContainer" style="line-height:18px">
        	1. 적용 고객사 : 코오롱인더스트리(주) 중앙기술원<br/><br/>
        	2. 납품 방법<br/>
        	&nbsp; &nbsp; 납품 방법 및 일정 입고를 아래 <b style="color:#F00">담당자에게 사전 공유 후 납품</b><br/>
        	&nbsp; &nbsp; (택배발송 시 : 택배 수령자 또한 발주연구원이 아닌 아래 담당자로 기재)<br/><br/>
        	3. 시약 납품/하차 장소<br/>
        	&nbsp; &nbsp; 코오롱 원앤온리타워 1층(마곡) 주차장 출입구 좌측 "옥외 위험물 창고"<br/>
        	&nbsp; &nbsp; <span style="text-decoration:underline; color:#F00"><b>(직납 시, 문서수발실 시약/화공약품 납품 절대 금지)</b></span><br/><br/>
        	4. 시행시기 : 2019년 7월 1일 납품분부터 적용<br/><br/>
        	5. 시약 수령 담당자<br/>
        	&nbsp; &nbsp; 개발지원팀 정문호 사원(010-9150-7168, octoho27@kolon.com)<br/>
        	&nbsp; &nbsp; 부재시, 개발지원팀 윤미선 과장(010-4221-4403, fucidin@kolon.com)<br/>
        	&nbsp; &nbsp; <span style="text-decoration:underline;">입고 일정 및 납품 방법에 대해 메일로 문의 시 수신인 "정문호 사원", 참조인 "윤미선 과장" 으로 적용 바랍니다.</span><br/><br/>
        	6. <span style="text-decoration:underline;">냉장/냉동 품목 납품시</span> 필히 유저 및 KeP 담당자에 입고 일정 공유(수취 지연 이슈 방지)
        </div>
<%}else if("TYPE5".equals(st_type)){%>
		<div id="popHeader">
        	<h1 class="title">유의사항</h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/s_btn_popclose.gif" alt="닫기버튼" /></a></p>
        </div>
        <div id="popContainer" style="line-height:18px; text-align:center;">
        	<br/><b>필히 납품 시 납품서 내<br/><span style="text-decoration:underline; color:#F00">하단 비고사항 담당자 , 부서, 연락처</span><br/>확인 후 납품바랍니다.</b><br/><br/>
        </div>
<%}else if("TYPE6".equals(st_type)){%>
		<div id="popHeader">
        	<h1 class="title">※ 경농 입고 담당자 우선 순위</h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/s_btn_popclose.gif" alt="닫기버튼" /></a></p>
        </div>
        <div id="popContainer" style="line-height:18px">
        	1순위 : 거래명세서 하단 비고란 담당자<br/><br/>
        	2순위 : 비고란 담당자 미기입 시 발주 담당자<br/><br/>
        	&nbsp; → 납품 시 상기 입고 담당자에 연락 必<br/>
        </div>
<%}else if("TYPE7".equals(st_type)){%>
		<div id="popHeader">
        	<h1 class="title">유의사항</h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/s_btn_popclose.gif" alt="닫기버튼" /></a></p>
        </div>
        <div id="popContainer" style="line-height:18px">
        	<div style="text-align:center">
        		<img src="/resources/images/commonMpIvDlvryNoticePopType7.jpg" /><br /><br />
        	</div>
            <b style="color:#000">◆ 유의사항 ◆</b><br />
			※ 박스 좌측 상단에 "KEP" 표기 및 거래명세서는 외부에 부착하여 배송 요청드립니다.
        </div>
<%}else if("TYPE8".equals(st_type)){%>
		<div id="popHeader">
        	<h1 class="title">삼성전자 직납 발주 납품 진행 가이드</h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/s_btn_popclose.gif" alt="닫기버튼" /></a></p>
        </div>
        <div id="popContainer" style="line-height:18px">
         	<div id="cont_searchA" style=" font-size:13px;  ">
                 <b style="font-size:15px;" >■ <b style="color:red;font-size:14px;">필수 준수 사항 </b>  </b><br/>
                ① 직납/택배: 인수자 물품 인수 확인 후 배송 확정 처리 必<br/><br/>
                ② 납품실적등록 (필수)<br/>
                - 납품 증빙서류 첨부 (인수증 or 송장번호)<br/>
                 -  미납 품목에 대해 사전 납품실적 등록 금지 (KeP 사전협의 건 제외)<br/>
                <b style="color:red">※ 미 준수 시 정상적인 정산이 되지 않으며 거래에 있어 페널티를<br/> &nbsp; &nbsp; 받을 수 있으니 꼭 준수 바랍니다.</b><br/><br/>
                . 문의처: 02-3016-7243 / 02-3016-7248<br/>
                . 메일: chorong.kim@koreab2b.com / jsjeon@koreab2b.com<br/>                             
            </div>
        </div>
<%}else if("TYPE9".equals(st_type)){%>
		<style type="text/css">
			body { margin:0;  border:0; background-color:#fff;  overflow:hidden; overflow-x:hidden;font-family:"맑은 고딕";
			.tit{height:50px;  line-height:55px; font-size:20px; font-weight:bold;  color:#FFF; letter-spacing:-1.5px;   background-color:#485259;  text-align:center; }
			.popuptxt{ text-align:center; font-size:14px;padding:25px 20px 30px 20px;line-height:22px;  letter-spacing:-0.8px; }
			.red{color:#e96969; font-weight:bold;  }
			a:link {color:#fff; text-decoration:none;}
			a:hover {color:#fff; text-decoration:none;}
			a:visited {color:#fff; text-decoration:none;} 
			table{ border-collapse:collapse; width:100%; margin:0 auto; clear:both; border:#b4c9d1 1px solid ; margin-bottom:15px }
			table th{ text-align:center; font-size:14px;  border:#d8d8d8 1px solid; }
			table td{ text-align:left;  border:#d8d8d8 1px solid;  padding:8px 15px;  color:#333;line-height:21px; font-weight:600   }
		</style>
		<div id="popHeader">
			<div style="height:50px; position:relative; background:url(https://www.koreab2b.com/resources/images/blue_pattern.gif); border-bottom:1px solid #3b5077;">
			<div style="position:absolute; font-size:20px; font-weight:bold; color:#fff; top:14px; left:20px; letter-spacing:-1px">유한킴벌리 납품 시 유의사항 안내</div>
			<p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/s_btn_popclose.gif" alt="닫기버튼" /></a></p>
		</div>
		<div class="popuptxt" >
			<table>
				<tr>
					<th colspan="2" height="40px"  bgcolor="#d3eaf4"  style=" font-size:15px;  color:#02358a; border:#90bdce 1px solid;" ><b>KeP 거래명세서 작성 전 유의사항</b></th>
				</tr>
				<tr>
		        <tr>
					<th bgcolor="#f4f3f3" width="55px" style="font-size:13px">1</th> 
					<td width="300px" >거래명세표를 반드시 동봉해 주세요.</td> 
				</tr>
				<tr>
					<th  bgcolor="#f4f3f3" >2</th> 
					<td>현품에 **현품표(K-TAG)**를 부착해 주세요.</td> 
				</tr>
				<tr>
					<th bgcolor="#f4f3f3">3</th> 
					<td>수령인 정보(성함 및 연락처)를 필수로 기재해 주세요.</td> 
				</tr>
			</table>
			<b class="red">물품 분실 및 납품 확인 지연 등의 사유로 입고 누락을 방지하기 위함이오니, <br/>상기 담당자에게 필히 납품 진행 부탁드립니다.</b>  
		</div>
<%}else if("TYPE90".equals(st_type)){%>
		<style type="text/css">
			body { margin:0;  border:0; background-color:#1b1b1b;  overflow:hidden; overflow-x:hidden;font-family:"맑은 고딕";}
			#Popup{ width:100%;margin:0;  border:0;background-color:#fff; }
			.tit{height:60px;  line-height:65px; font-size:22px; font-weight:bold;  color:#fff; letter-spacing:-1.5px;   background-color:#021b2f;  text-align:center; }
			.popuptxt{font-family:"맑은 고딕"; text-align:center; font-size:15px; margin:20px 0px; color:#000; line-height:20px;  letter-spacing:-1px;}
			.red{color:#ea0000;font-weight:bold; text-decoration:underline}
			.blue{color:#0000ff;font-weight:bold; text-decoration:underline}
			.yellow{ color:#ffff00}
			.close{width:100%; height:50px; line-height:50px; text-align:right;  font-size:13px; color:#FFF; background-color:#1b1b1b; clear:both}
			.close span{ border:1px solid #666; padding:5px 20px}
			.close input{ vertical-align:middle; border:0}
			a:link 	  {text-decoration:none; color:#fff;}
			a:visited {text-decoration:none; color:#1b1b1b;}
			a:active  {text-decoration:none; color:#1b1b1b;}
			a:hover   {text-decoration:none; color:#fff;} 
			
			table{ margin:0 auto; border-collapse:collapse;      clear:both;  margin-bottom:5px; margin-top:10px; }
			table th{ padding:8px 0;  font-weight:bold; font-size:16px;  text-align:center; color:#ffff00; }
			table td{ padding:5px 10px; text-align:center;   color:#333; font-size:15px;letter-spacing:-1.5px;line-height:23px;background-color:#fff;   }
		</style>
		<div id="Popup">
		    <div class="tit">물류센터 TR납품 방식 변경 안내</div>
		    <div class="popuptxt" >  
		        <div style="width:90%; margin:0 auto; text-align:left; line-height:22px; margin-bottom:10px">① 기존 : 발주건별 납품명세서 동봉 <br/><br/>
		        <b>
		        ② 변경 : 입고번호(IV번호)별 박스 소포장 후 입고라벨 부착 (납품명세서 동봉 불필요)<br/>
		        &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; 합포장시, 외부 박스에 [합포장] 수기 기재 (내부 박스 수량대로 입고라벨 부착)</b><br/>
		        ㆍ품목별 라벨 부착을 요구하는 고객사 납품건도 입고라벨 함께 부착<br/>
		        ㆍ삼성그룹은 기존 납품방식 유지 (납품명세서 5장, 품목 라벨, 물품명세표 부착)<br/><br/>
		        <b class="red">
		        ■ 개시 일정 : 2025년 9월 29일 월요일 부터 <br/>
		        ■ 대상 : KeP물류센터에 TR 납품하는 모든 공급사(협력사)</b> 
		        </div>
				<div style="cursor:pointer;position:relative;display:inline-block; width:38%; margin:0 auto; font-weight:bold;font-size:18px; color:#fff; line-height:35px; margin-top:10px;padding:15px 15px;text-align:center; border-radius:5px;background-color:#028f6c"
		        onclick="window.open('../../../../resources/html/main/notice/LogisticsCenter_Guide_manual.pdf', '_blank', 'width=800,height=450')" > 
		        협력사 TR납품 매뉴얼 <br/> <span style=" display:inline-block; padding:0px 25px;  border-radius:50px; font-size:14px; line-height:35px; background-color:#06554a"> 다운로드 열기 ▼</span>
		        </div>  
		        <div style="cursor:pointer;position:relative; display:inline-block; width:38%; margin:0 auto; font-weight:bold;font-size:18px; color:#fff; line-height:35px; margin-top:10px; padding:15px 15px;text-align:center; border-radius:5px;
		        background-color:#465cb2; margin-left:10px"  onclick="window.open('../../../../resources/html/main/notice/LogisticsCenter_Guide_manual.mp4', '_blank', 'width=800,height=450')">
		        협력사 TR납품 포장 방식 <br/> <span style="display:inline-block; padding:0px 25px;  border-radius:50px; font-size:14px; line-height:35px;background-color:#182d83"> 동영상 열기 ▼</span></div>        
				<br/><br/>
				<input id="st_type90_checkbox" name="st_type90_checkbox" type="checkbox" value="" style="width:25px; height:25px; vertical-align:middle"> 위 내용을 확인하였으며, 정해진 TR 납품 방식을 준수하겠습니다. <br/><br/>
			</div>
		</div>
<%} %>
        <div style="border-top:1px solid #535353; text-align:center; padding:10px; background-color:#dcdcdc">
        	상기 내용 확인 후 거래명세서를 작성하시겠습니까?
            <div class="btnArea" style="text-align:center;" >
                <span class="btn_04"><a href="javascript:setReturn();">확인</a></span> <span class="btn_04"><a href="javascript:self.close()">취소</a></span> 
            </div>
        </div>
	</div>        
</div>
</form> 
</body>
</html>


