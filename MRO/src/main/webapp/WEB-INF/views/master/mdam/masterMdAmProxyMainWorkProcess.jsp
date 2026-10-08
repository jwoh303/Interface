<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<%@ page import="java.util.*"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
	SessionInfo sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
	//사용자 타입 가져옴
	String st_user_type = sessionInfo.getUserType();

%>
<script type="text/javascript">

var gingeubCnt = 0;
var bsRegCnt = 0;
var bsFinishCnt = 0;
var bsPartialCnt = 0;
var bsCancelCnt = 0;

function getMasterMdAmProxyMainWorkProcess(){
	var search_yn = $("#search_yn").val();
	var st_user_type =  "<%=st_user_type%>";
	if(st_user_type=="SS"||st_user_type=="SM"||st_user_type=="DSM"||st_user_type=="ST"||st_user_type=="SOF"){//소싱파트, SM, DSM, 소싱팀장
		kepAjaxFormCall("/mdam/getMasterMdAmProxyMainWorkProcess.do","contentForm","initSearch");
	}else{
		if(search_yn == "N"){
			$("#search_yn").val("Y");
			$("#buyer").val("");
			kepAjaxFormCall("/mdam/getMasterMdAmProxyMainWorkProcess.do","contentForm","initSearch");
		}else{
			layerView('layerMainWorkProcess','show');
		}
	}
}

var x = 0;
// 재집계
function getReCount(buyer, seq){

	if(confirm("해당 고객사를 재집계하시겠습니까?")){
		
		$("#buyer").val(buyer);
		x = seq;
		
		kepAjaxFormCall("/mdam/getMasterMdAmProxyBuyerRecount.do","contentForm","reCount");
	}
	return;
}

//ajax 공통 호출후 성공시 처리 함수
function kepAjaxSuccess(pMethod , response){
	
	if(pMethod == "initSearch"){
		
		var authGbn = response.authGbn;		
		$("#divHeaderDL").hide();
		$("#divTLSubTable").hide();
		$("#divHeaderMB").hide();
		$("#divSubTable").hide();
		if(authGbn == "SS"){//소싱지원 대시보드
			showWorkProcessSS(response);
		}else if(authGbn == "SM"){//SM 대시보드
			showWorkProcessSM(response);
		}else if(authGbn == "DSM"){//DSM 대시보드
			showWorkProcessDSM(response);
		}else if(authGbn == "ST"||authGbn == "SOF"){//소싱팀장
			showWorkProcessST(response);
		}else if(authGbn == "DL" || authGbn == "BL"){
			// DL : KEP200417
			// BL : KEP2109035 KEP200040
			
			$("#divHeaderDL").show();
			
			$("#divTLSubTable").hide();
			$("#divHeaderMB").hide();
			$("#divSubTable").hide();
			
			showWorkProcessDL(response);
			
		} else if(authGbn == "TL"){
			// KEP200076
			$("#divHeaderDL").show();
			$("#divTLSubTable").show();
			
			$("#divHeaderMB").hide();
			$("#divSubTable").hide();
			
			var deptNm = $("#dept_name").val();
			$("#spanDeptNm").html(deptNm);
			
			showWorkProcessTL(response);
		} else {
			
			$("#divHeaderDL").hide();
			$("#divTLSubTable").hide();
			
			$("#divHeaderMB").show();
			$("#divSubTable").show();
			
			// 나의주요업무처리 리스트
			var mainWorkProcessList = response.mainWorkProcessList;
			
			// 나의주요업무처리 합계
			var mainWorkProcessSum = response.mainWorkProcessSum;
			
			// 긴급납기/선입고 리스트
			var docTypeFPoList = response.docTypeFPoList;
		
			//console.log("response.mainWorkProcessList ==>>> " + JSON.stringify(mainWorkProcessList));
			//console.log("response.mainWorkProcessSum ==>>> " + JSON.stringify(mainWorkProcessSum));
			//console.log("response.docTypeFPoList ==>>> " + JSON.stringify(docTypeFPoList));
			
			$("#tbWorkProcList").empty();
			// 나의주요업무처리 리스트 row data
			if(mainWorkProcessList.length > 0){
				for(var i = 0; i < mainWorkProcessList.length; i++){
					
					$("#tbWorkProcList").append( setWorkProcRow(mainWorkProcessList[i], i) );
					
				}
				
				$("#tbWorkProcList").append( setWorkProcSumRow(mainWorkProcessSum) );
				
			} else {
				$("#tbWorkProcList").append( setEmptyRow("19") );
			}
		
			$("#tbGinGeubList").empty();
		
			gingeubCnt = 0;
			bsRegCnt = 0;
			bsFinishCnt = 0;
			bsPartialCnt = 0;
			bsCancelCnt = 0;
			
			// 긴급납기/선입고 리스트 row data
			if(docTypeFPoList.length > 0){
				for(var i = 0; i < docTypeFPoList.length; i++){
					
					$("#tbGinGeubList").append( setGinGeubRow("row", docTypeFPoList[i]) );
					
				}
				
				$("#tbGinGeubList").append( setGinGeubRow("sum", "") );
				
			} else {
				$("#tbGinGeubList").append( setEmptyRow("6") );
			}
			
			layerView('layerMainWorkProcess','show');
		}
	} else if(pMethod == "reCount"){
		// 재집계 실행한 고객사 데이터 변경
		var msg = response.msg;
		
		if(!isEmpty(msg)){
			alert(msg);
		}
		
		// 나의주요업무처리 리스트
		var mainWorkProcessList = response.mainWorkProcessList;
		// 나의주요업무처리 합계
		var mainWorkProcessSum = response.mainWorkProcessSum;
		
		if(mainWorkProcessList.length > 0){
			// 재집계한 고객사 데이터
			var data = mainWorkProcessList[0];

			$("a[name='if_err_cnt']").eq(x).text(addComma(data.IF_ERR_CNT));								// I/F오류_오류
			$("a[name='if_stop_cnt']").eq(x).text(addComma(data.IF_STOP_CNT));								// I/F오류_임시저장
			$("a[name='iv_do_no_cnt']").eq(x).text(addComma(data.IV_DO_NO_CNT));							// 수주접수_미접수
			$("a[name='iv_long_do_no_cnt']").eq(x).text(addComma(data.IV_LONG_DO_NO_CNT));					// 수주접수_장기미접수
			$("a[name='iv_expect_delay_cnt']").eq(x).text(addComma(data.IV_EXPECT_DELAY_CNT));				// 납기_지연예상
			$("a[name='iv_delay_cnt']").eq(x).text(addComma(data.IV_DELAY_CNT));							// 납기_지연
			$("a[name='iv_long_expect_delay_cnt']").eq(x).text(addComma(data.IV_LONG_EXPECT_DELAY_CNT));	// 납기_장기지연
			$("a[name='iv_bad_delay_cnt']").eq(x).text(addComma(data.IV_BAD_DELAY_CNT));					// 납기_악성지연
			$("a[name='iv_di_no_cnt']").eq(x).text(addComma(data.IV_DI_NO_CNT));							// 납기_실적미등록
			$("a[name='gr_no_cnt']").eq(x).text(addComma(data.GR_NO_CNT));									// 납기_고객사미입고
			$("a[name='qt_recv_cnt']").eq(x).text(addComma(data.QT_RECV_CNT));								// 견적_의뢰건
			$("a[name='qt_delay_cnt']").eq(x).text(addComma(data.QT_DELAY_CNT));							// 견적_제출지연
			$("a[name='qt_long_delay_cnt']").eq(x).text(addComma(data.QT_LONG_DELAY_CNT));					// 견적_장기지연
			$("a[name='nw_itm_spec_req_cnt']").eq(x).text(addComma(data.NW_ITM_SPEC_REQ_CNT));				// 신규품목_규격의뢰
			$("a[name='nw_itm_spec_chk_cnt']").eq(x).text(addComma(data.NW_ITM_SPEC_CHK_CNT));				// 신규품목_확인
			$("a[name='qt_nego_req_cnt']").eq(x).text(addComma(data.QT_NEGO_REQ_CNT));						// Nogo의뢰
			
			var procDt = data.PROC_DT;
			var procTm = data.PROC_TM;
			
			if(isEmpty(procDt)){
				procDt = "";
			} else {
				procDt = kepDateSlashAdd(procDt);
			}
			
			if(isEmpty(procTm)){
				procTm = "";
			}
			
			$("td[name='proc_dttm']").eq(x).html(procDt+"<br>"+procTm);							// 최종집계의뢰일시
			
			// 나의주요업무처리 합계
			$("td[name='sum_if_err_cnt']").text(addComma(mainWorkProcessSum.IF_ERR_CNT));
			$("td[name='sum_if_stop_cnt']").text(addComma(mainWorkProcessSum.IF_STOP_CNT));
			$("td[name='sum_iv_do_no_cnt']").text(addComma(mainWorkProcessSum.IV_DO_NO_CNT));
			$("td[name='sum_iv_long_do_no_cnt']").text(addComma(mainWorkProcessSum.IV_LONG_DO_NO_CNT));
			$("td[name='sum_iv_expect_delay_cnt']").text(addComma(mainWorkProcessSum.IV_EXPECT_DELAY_CNT));
			$("td[name='sum_iv_delay_cnt']").text(addComma(mainWorkProcessSum.IV_DELAY_CNT));
			$("td[name='sum_iv_long_expect_delay_cnt']").text(addComma(mainWorkProcessSum.IV_LONG_EXPECT_DELAY_CNT));
			$("td[name='sum_iv_bad_delay_cnt']").text(addComma(mainWorkProcessSum.IV_BAD_DELAY_CNT));
			$("td[name='sum_iv_di_no_cnt']").text(addComma(mainWorkProcessSum.IV_DI_NO_CNT));
			$("td[name='sum_gr_no_cnt']").text(addComma(mainWorkProcessSum.GR_NO_CNT));
			$("td[name='sum_qt_recv_cnt']").text(addComma(mainWorkProcessSum.QT_RECV_CNT));
			$("td[name='sum_qt_delay_cnt']").text(addComma(mainWorkProcessSum.QT_DELAY_CNT));
			$("td[name='sum_qt_long_delay_cnt']").text(addComma(mainWorkProcessSum.QT_LONG_DELAY_CNT));
			$("td[name='sum_nw_itm_spec_req_cnt']").text(addComma(mainWorkProcessSum.NW_ITM_SPEC_REQ_CNT));
			$("td[name='sum_nw_itm_spec_chk_cnt']").text(addComma(mainWorkProcessSum.NW_ITM_SPEC_CHK_CNT));
			$("td[name='sum_qt_nego_req_cnt']").text(addComma(mainWorkProcessSum.QT_NEGO_REQ_CNT));
			
		}
	}
	
	return;
}

//ajax 공통 호출후 실패시 처리 함수
function kepAjaxError(pMethod , response){
	
	if(pMethod == "initSearch"){
		
		alert("나의 주요업무처리 조회 중 에러가 발생했습니다.");
		$("#search_yn").val("N");
	
	} else if(pMethod == "reCount"){
		
		$("#buyer").val("");
		alert("고객사별 의뢰 재집계 중 에러가 발생했습니다.");		
	}
	
	return;
}

function doActionTab(str, buyer, buyer_name) {
	
	var upperId = $("#upperId").val();
	
	switch (str) {
		case "ifErr":	 // I/F오류_오류
			var param = "search_yn=Y&st_buyer_code="+buyer+"&st_buyer_name="+buyer_name;
			param = encodeURI(param);
			//http://localhost:8080/master/masterFrame.do?upperId=m00201070000
			if(upperId == "m00200000000"){
// 			if(upperId == "m00201070000"){
				location.href="/master/masterFrame.do?upperId=m00201070000&tabId="+str+"&"+param;
			} else {
				tab("발주오류현황","/mpif/showMasterMpIfErrorStateMain.do?"+param);
				layerView('layerMainWorkProcess','');
			}
			break;
			
		case "ifStop":	// I/F오류_임시저장
			var param = "search_yn=Y&st_buyer_code="+buyer+"&st_buyer_name="+buyer_name;
			param = encodeURI(param);
			if(upperId == "m00200000000"){
// 			if(upperId == "m00201070000"){
				location.href="/master/masterFrame.do?upperId=m00201070000&tabId="+str+"&"+param;
			} else {
				tab("I/F발주대기","/mpif/showMasterMpIfOrderStandby.do?"+param);
				layerView('layerMainWorkProcess','');
			}
			break;
			
		case "ivDoNo":	 // 수주접수_미접수
			var param = "search_yn=Y&st_buyer_code="+buyer+"&st_buyer_name="+buyer_name+"&st_gubun=IV_DO_NO";
			param = encodeURI(param);
			if(upperId == "m00200000000"){
// 			if(upperId == "m00201060000"){
				location.href="/master/masterFrame.do?upperId=m00201060000&tabId="+str+"&"+param;
			} else {
				tab("발주접수지연목록","/mpiv/showMasterMpIvOrderReceiptDelayList.do?"+param);
				layerView('layerMainWorkProcess','');
			}
			break;
			
		case "ivLongDoNo":	 // 수주접수_장기미접수
			var param = "search_yn=Y&st_buyer_code="+buyer+"&st_buyer_name="+buyer_name+"&st_gubun=IV_LONG_DO_NO";
			param = encodeURI(param);
			if(upperId == "m00200000000"){
// 			if(upperId == "m00201060000"){
				location.href="/master/masterFrame.do?upperId=m00201060000&tabId="+str+"&"+param;
			} else {
				tab("발주접수지연목록","/mpiv/showMasterMpIvOrderReceiptDelayList.do?"+param);
				layerView('layerMainWorkProcess','');
			}
			break;
			
		case "ivExpectDelay":	 // 납기_지연예상
			var param = "search_yn=Y&st_buyer_code="+buyer+"&st_buyer_name="+buyer_name+"&st_iv_delay_gubun=IV_EXPECT_DELAY";
			param = encodeURI(param);
			if(upperId == "m00200000000"){
// 			if(upperId == "m00201060000"){
				location.href="/master/masterFrame.do?upperId=m00201060000&tabId="+str+"&"+param;
			} else {
				tab("납기지연예상발주 조치","/mpiv/showMasterMpIvDeadlineDelayForecastOrderAction.do?"+param);
				layerView('layerMainWorkProcess','');
			}
			break;
			
		case "ivDelay":	 // 납기_지연
			var param = "search_yn=Y&st_buyer_code="+buyer+"&st_buyer_name="+buyer_name+"&st_iv_delay_gubun=IV_DELAY";
			param = encodeURI(param);
			if(upperId == "m00200000000"){
// 			if(upperId == "m00201060000"){
				location.href="/master/masterFrame.do?upperId=m00201060000&tabId="+str+"&"+param;
			} else {
				tab("납기지연예상발주 조치","/mpiv/showMasterMpIvDeadlineDelayForecastOrderAction.do?"+param);
				layerView('layerMainWorkProcess','');
			}
			break;
			
		case "ivLongExpectDelay":	 // 납기_장기지연
			var param = "search_yn=Y&st_buyer_code="+buyer+"&st_buyer_name="+buyer_name+"&st_iv_delay_gubun=IV_LONG_EXPECT_DELAY";
			param = encodeURI(param);
			if(upperId == "m00200000000"){
// 			if(upperId == "m00201060000"){
				location.href="/master/masterFrame.do?upperId=m00201060000&tabId="+str+"&"+param;
			} else {
				tab("납기지연예상발주 조치","/mpiv/showMasterMpIvDeadlineDelayForecastOrderAction.do?"+param);
				layerView('layerMainWorkProcess','');
			}
			break;
			
		case "ivBadDelayCnt":	 // 납기_악성지연
			var param = "search_yn=Y&st_buyer_code="+buyer+"&st_buyer_name="+buyer_name+"&st_iv_delay_gubun=IV_BAD_DELAY";
			param = encodeURI(param);
			if(upperId == "m00200000000"){
// 			if(upperId == "m00201060000"){
				location.href="/master/masterFrame.do?upperId=m00201060000&tabId="+str+"&"+param;
			} else {
				tab("납기지연예상발주 조치","/mpiv/showMasterMpIvDeadlineDelayForecastOrderAction.do?"+param);
				layerView('layerMainWorkProcess','');
			}
			break;
			
		case "ivDiNoCnt":	 // 납기_실적미등록
			var param = "search_yn=Y&st_buyer_code="+buyer+"&st_buyer_name="+buyer_name;
			param = encodeURI(param);
			if(upperId == "m00200000000"){
// 			if(upperId == "m00201060000"){
				location.href="/master/masterFrame.do?upperId=m00201060000&tabId="+str+"&"+param;
			} else {
				tab("납품실적 관리","/mpiv/showMasterMpIvDeliveryRecordManage.do?"+param);
				layerView('layerMainWorkProcess','');
			}
			break;
			
		case "grNo":	 // 납기_고객사미입고
			var param = "search_yn=Y&st_buyer_code="+buyer+"&st_buyer_name="+buyer_name;
			param = param + "&st_mainOpen=Y";
			param = encodeURI(param);
			if(upperId == "m00200000000"){
// 		if(upperId == "m00201060000"){
				location.href="/master/masterFrame.do?upperId=m00201060000&tabId="+str+"&"+param;
			} else {
				tab("고객사 미입고 목록","/mpiv/showMasterMpIvBuyerNywarhsngList.do?"+param);
				layerView('layerMainWorkProcess','');
			}
			break;
			
		case "qtRecv":	 // 견적_의뢰건
			var param = "search_yn=Y&st_buyer_code="+buyer+"&st_buyer_name="+buyer_name;
			param = encodeURI(param);
			if(upperId == "m00200000000"){
// 			if(upperId == "m00201030000"){
				location.href="/master/masterFrame.do?upperId=m00201030000&tabId="+str+"&"+param;
			} else {
				tab("견적의뢰접수","/mprq/showMasterMpRqReqQuotReceipt.do?"+param);
				layerView('layerMainWorkProcess','');
			}
			break;
			
		case "qtDelay":	 // 견적_제출지연
			var item_group = buyer_name;
			openSearchPopup('/mpiv/showMasterMpIvQuotationSendDelayPop.do','?st_buyer='+buyer+'&st_item_group='+item_group,'800,400,no');
			break;
			
		case "qtLongDelay":	 // 견적_장기지연
			var item_group = buyer_name;
			openSearchPopup('/mpiv/showMasterMpIvQuotationSendLngtermDelayPop.do','?st_buyer='+buyer+'&st_item_group='+item_group,'800,400,no');
			break;
			
		case "nwItmSpecReq":	 // 품목정비
			var param = "search_yn=Y&st_buyer_code="+buyer+"&st_buyer_name="+buyer_name;
			if(upperId == "m00200000000"){
				location.href="/master/masterFrame.do?upperId=m00201030000&tabId="+str+"&"+param;
			} else {
				tab("카탈로그 매핑 관리","/mdcm/showMasterMdCmCatalogMappingList.do?"+param);
				layerView('layerMainWorkProcess','');
			}
			break;
			
		case "nwItmSpecChk":	 // 물질정보관리
			var param = "search_yn=Y&st_buyer_code="+buyer+"&st_buyer_name="+buyer_name;
			param = encodeURI(param);
			if(upperId == "m00200000000"){
				location.href="/master/masterFrame.do?upperId=m00201030000&tabId="+str+"&"+param;
			} else {
				tab("물질정보 등록관리","/mdcm/showMasterMdCmChemicalMatMngList.do?"+param);
				layerView('layerMainWorkProcess','');
			}
			break;
			
		case "qtNegoReq":	 // Nogo의뢰
			if(upperId == "m00200000000"){
// 			if(upperId == "m00201030000"){
				location.href="/master/masterFrame.do?upperId=m00201030000&tabId="+str;
			} else {
				tab("Nego견적접수","/mprq/showMasterMpRqReqNegoReceipt.do");
				layerView('layerMainWorkProcess','');
			}
			break;
			
		case "gingeub":	// 긴급납기
			openSearchPopup('/mpiv/showMasterMpIvUrgentManagementPop.do','?1=1','800,500,no');
			break;
		case "req":	 // 견적_의뢰건
			var param = "search_yn=Y";
			param = encodeURI(param);
			if(upperId == "m00200000000"){
				location.href="/master/masterFrame.do?upperId=m00201030000&tabId="+str+"&"+param;
			} else {
				tab("견적의뢰접수","/mprq/showMasterMpRqReqQuotReceipt.do?"+param);
			}
			layerView('layerMainWorkSourPartProcess','');//소싱지원
			layerView('layerMainWorkSTProcess','');//팀장
			break;
		case "sendQuotation":	 // 업체선정및견적제출
			var param = "search_yn=N";
			param = encodeURI(param);
			if(upperId == "m00200000000"){
				location.href="/master/masterFrame.do?upperId=m00201030000&tabId="+str+"&"+param;
			} else {
				tab("업체선정 및 견적제출","/mprq/showMasterMpRqCmpySelQuotationSend.do");
			}
			layerView('layerMainWorkDSMProcess','');//DSM
			layerView('layerMainWorkSTProcess','');//팀장
			break;
		case "quotationList":	 // 견적진행조회
			var param = "search_yn=N";
			param = encodeURI(param);
			if(upperId == "m00200000000"){
				location.href="/master/masterFrame.do?upperId=m00201030000&tabId="+str+"&"+param;
			} else {
				tab("견적진행조회","/mprq/showMasterMpRqQuotationProceState.do");
			}
			layerView('layerMainWorkDSMProcess','');//DSM
			layerView('layerMainWorkSTProcess','');//팀장
			break;
		case "voc":	 // voc
			var param = "search_yn=N";
			param = encodeURI(param);
			if(upperId == "m00200000000"){
				location.href="/master/masterFrame.do?upperId=m00801000000&tabId="+str+"&"+param;
			} else {
				tab("VOC 진행현황","/mpvo/showMasterMpVoVocProgressState.do");
			}
			layerView('layerMainWorkSMProcess','');//SM
			layerView('layerMainWorkDSMProcess','');//DSM
			layerView('layerMainWorkSTProcess','');//팀장
			break;
	}
}

function setEmptyRow(col){
	var row = "";
	
	row += "<tr>";
	row += "	<td colspan='"+col+"' class='time'  height='50'>";
	row += "		조회된 데이타가 없습니다.";
	row += "	</td>";
	row += "</tr>";
	
	return row;
}

// 나의 주요업무처리 리스트 ROW
function setWorkProcRow(data, seq){
	var rowStr = "";
	
	var procDt = data.PROC_DT;
	var procTm = data.PROC_TM;
	
	if(isEmpty(procDt)){
		procDt = "";
	} else {
		procDt = kepDateSlashAdd(procDt);
	}
	
	if(isEmpty(procTm)){
		procTm = "";
	}
	
	rowStr += "<tr>";
	rowStr += "	<th class='row' scope='row' name='buyer_name'>" + data.BUYER_NAME_LOC + "</th>";	// 고객사
	
	rowStr += "	<td>";	// I/F오류_오류
	rowStr += "		<a href='javascript:doActionTab(\"ifErr\",\""+data.BUYER+"@\",\""+data.BUYER_NAME_LOC+"\");' name='if_err_cnt'>" + addComma(data.IF_ERR_CNT) + "</a>";
	rowStr += "	</td>";
	
	rowStr += "	<td>";	// I/F오류_임시저장
	rowStr += "		<a href='javascript:doActionTab(\"ifStop\",\""+data.BUYER+"\",\""+data.BUYER_NAME_LOC+"\");' name='if_stop_cnt'>" + addComma(data.IF_STOP_CNT) + "</a>";
	rowStr += "	</td>";
	
	rowStr += "	<td>";	// 수주접수_미접수
	rowStr += "		<a href='javascript:doActionTab(\"ivDoNo\",\""+data.BUYER+"\",\""+data.BUYER_NAME_LOC+"\");' name='iv_do_no_cnt'>" + addComma(data.IV_DO_NO_CNT) + "</a>";
	rowStr += "	</td>";
	
	rowStr += "	<td>";	// 수주접수_장기미접수
	rowStr += "		<a href='javascript:doActionTab(\"ivLongDoNo\",\""+data.BUYER+"\",\""+data.BUYER_NAME_LOC+"\");' name='iv_long_do_no_cnt'>" + addComma(data.IV_LONG_DO_NO_CNT) + "</a>";
	rowStr += "	</td>";
	
	rowStr += "	<td>";	// 납기_지연예상
	rowStr += "		<a href='javascript:doActionTab(\"ivExpectDelay\",\""+data.BUYER+"\",\""+data.BUYER_NAME_LOC+"\");' name='iv_expect_delay_cnt'>" + addComma(data.IV_EXPECT_DELAY_CNT) + "</a>";
	rowStr += "	</td>";
	
	rowStr += "	<td>";	// 납기_지연
	rowStr += "		<a href='javascript:doActionTab(\"ivDelay\",\""+data.BUYER+"\",\""+data.BUYER_NAME_LOC+"\");' name='iv_delay_cnt'>" + addComma(data.IV_DELAY_CNT) + "</a>";
	rowStr += "	</td>";
	
	rowStr += "	<td>";	// 납기_장기지연
	rowStr += "		<a href='javascript:doActionTab(\"ivLongExpectDelay\",\""+data.BUYER+"\",\""+data.BUYER_NAME_LOC+"\");' name='iv_long_expect_delay_cnt'>" + addComma(data.IV_LONG_EXPECT_DELAY_CNT) + "</a>";
	rowStr += "	</td>";
	
	rowStr += "	<td>";	// 납기_악성지연
	rowStr += "		<a href='javascript:doActionTab(\"ivBadDelayCnt\",\""+data.BUYER+"\",\""+data.BUYER_NAME_LOC+"\");' name='iv_bad_delay_cnt'>" + addComma(data.IV_BAD_DELAY_CNT) + "</a>";
	rowStr += "	</td>";
	
	rowStr += "	<td>";	// 납기_실적미등록
	rowStr += "		<a href='javascript:doActionTab(\"ivDiNoCnt\",\""+data.BUYER+"\",\""+data.BUYER_NAME_LOC+"\");' name='iv_di_no_cnt'>" + addComma(data.IV_DI_NO_CNT) + "</a>";
	rowStr += "	</td>";
	
	rowStr += "	<td>";	// 납기_고객사미입고
	rowStr += "		<a href='javascript:doActionTab(\"grNo\",\""+data.BUYER+"\",\""+data.BUYER_NAME_LOC+"\");' name='gr_no_cnt'>" + addComma(data.GR_NO_CNT) + "</a>";
	rowStr += "	</td>";
	
	rowStr += "	<td>";	// 견적_의뢰건
	rowStr += "		<a href='javascript:doActionTab(\"qtRecv\",\""+data.BUYER+"\",\""+data.BUYER_NAME_LOC+"\");' name='qt_recv_cnt'>" + addComma(data.QT_RECV_CNT) + "</a>";
	rowStr += "	</td>";
	
	rowStr += "	<td>";	// 견적_제출지연
	rowStr += "		<a href='javascript:doActionTab(\"qtDelay\",\""+data.BUYER+"\",\""+data.ITEM_GROUP+"\");' name='qt_delay_cnt'>" + addComma(data.QT_DELAY_CNT) + "</a>";
	rowStr += "	</td>";
	
	rowStr += "	<td>";	// 견적_장기지연
	rowStr += "		<a href='javascript:doActionTab(\"qtLongDelay\",\""+data.BUYER+"\",\""+data.ITEM_GROUP+"\");' name='qt_long_delay_cnt'>" + addComma(data.QT_LONG_DELAY_CNT) + "</a>";
	rowStr += "	</td>";
	
	rowStr += "	<td>";	// 신규품목_규격의뢰
	rowStr += "		<a href='javascript:doActionTab(\"nwItmSpecReq\",\""+data.BUYER+"\",\""+data.BUYER_NAME_LOC+"\");' name='nw_itm_spec_req_cnt'>" + addComma(data.NW_ITM_SPEC_REQ_CNT) + "</a>";
	rowStr += "	</td>";
	
	rowStr += "	<td>";	// 신규품목_확인
	rowStr += "		<a href='javascript:doActionTab(\"nwItmSpecChk\",\""+data.BUYER+"\",\""+data.BUYER_NAME_LOC+"\");' name='nw_itm_spec_chk_cnt'>" + addComma(data.NW_ITM_SPEC_CHK_CNT) + "</a>";
	rowStr += "	</td>";
	
	rowStr += "	<td>";	// Nogo의뢰
	rowStr += "		<a href='javascript:doActionTab(\"qtNegoReq\");' name='qt_nego_req_cnt'>" + addComma(data.QT_NEGO_REQ_CNT) + "</a>";
	rowStr += "	</td>";
	
	rowStr += "	<td class='time' style='font-size:11px;' name='proc_dttm'>";	// 최종집계의뢰일시
	rowStr += 		procDt +"<br>" + procTm;
	rowStr += "	</td>";
	
	rowStr += "	<td class='time last'><span class='btn_reset'>";	// 고객사별의뢰재집계
	rowStr += "		<a href=\"javascript:getReCount('"+data.BUYER+"', "+seq+");\">재집계</a>";		// 재집계 클릭시 KEP.PROC_KEP_PM_PA_DB(BUYER) 프로시저 호출-->
	rowStr += "	</span></td>";
	
	rowStr += "</tr>";
	
	return rowStr;
}

// 나의 주요업무처리 리스트 합계 ROW
function setWorkProcSumRow(data){
	
	var rowStr = "";
	
	rowStr += "<tr class='last'>";
	rowStr += "	<th class='row' scope='row'>합계</th>";
	
	rowStr += "	<td name='sum_if_err_cnt'>" + addComma(data.IF_ERR_CNT) + "</td>";
	rowStr += "	<td name='sum_if_stop_cnt'>" + addComma(data.IF_STOP_CNT) + "</td>";
	rowStr += "	<td name='sum_iv_do_no_cnt'>" + addComma(data.IV_DO_NO_CNT) + "</td>";
	rowStr += "	<td name='sum_iv_long_do_no_cnt'>" + addComma(data.IV_LONG_DO_NO_CNT) + "</td>";
	rowStr += "	<td name='sum_iv_expect_delay_cnt'>" + addComma(data.IV_EXPECT_DELAY_CNT) + "</td>";
	rowStr += "	<td name='sum_iv_delay_cnt'>" + addComma(data.IV_DELAY_CNT) + "</td>";
	rowStr += "	<td name='sum_iv_long_expect_delay_cnt'>" + addComma(data.IV_LONG_EXPECT_DELAY_CNT) + "</td>";
	rowStr += "	<td name='sum_iv_bad_delay_cnt'>" + addComma(data.IV_BAD_DELAY_CNT) + "</td>";
	rowStr += "	<td name='sum_iv_di_no_cnt'>" + addComma(data.IV_DI_NO_CNT) + "</td>";
	rowStr += "	<td name='sum_gr_no_cnt'>" + addComma(data.GR_NO_CNT) + "</td>";
	rowStr += "	<td name='sum_qt_recv_cnt'>" + addComma(data.QT_RECV_CNT) + "</td>";
	rowStr += "	<td name='sum_qt_delay_cnt'>" + addComma(data.QT_DELAY_CNT) + "</td>";
	rowStr += "	<td name='sum_qt_long_delay_cnt'>" + addComma(data.QT_LONG_DELAY_CNT) + "</td>";
	rowStr += "	<td name='sum_nw_itm_spec_req_cnt'>" + addComma(data.NW_ITM_SPEC_REQ_CNT) + "</td>";
	rowStr += "	<td name='sum_nw_itm_spec_chk_cnt'>" + addComma(data.NW_ITM_SPEC_CHK_CNT) + "</td>";
	rowStr += "	<td name='sum_qt_nego_req_cnt'>" + addComma(data.QT_NEGO_REQ_CNT) + "</td>";
	
	rowStr += "	<td></td>";
	rowStr += "	<td class='last'></td>";
	rowStr += "</tr>";
	
	return rowStr;	
}

// 긴급납기/선입고 리스트 ROW
function setGinGeubRow(gbn, data){
	var rowStr = "";
	
	if(gbn == "sum"){
		
		// 합계 ROW
		rowStr += "<tr class='last'>";
		rowStr += "	<th class='row' scope='row'>합계</th>";
		rowStr += "	<td>" + addComma(gingeubCnt) + "</td>";
		rowStr += "	<td>" + addComma(bsRegCnt) + "</td>";
		rowStr += "	<td>" + addComma(bsFinishCnt) + "</td>";
		rowStr += "	<td>" + addComma(bsPartialCnt) + "</td>";
		rowStr += "	<td class='last'>" + addComma(bsCancelCnt) + "</td>";
		rowStr += "</tr>";

	} else {
		
		// 합계데이터 만듬..
		gingeubCnt		+= parseInt(data.GINGEUB_CNT);
		bsRegCnt		+= parseInt(data.BS_REG_CNT);
		bsFinishCnt		+= parseInt(data.BS_FINISH_CNT);
		bsPartialCnt	+= parseInt(data.BS_PARTIAL_CNT);
		bsCancelCnt		+= parseInt(data.BS_CANCEL_CNT);
		
		rowStr += "<tr>";
		rowStr += "	<th class='row' scope='row'>" + data.BUYER_NAME + "</th>";	// 고객사
		
		rowStr += "	<td>";	// 긴급납기
		rowStr += "		<a href='javascript:doActionTab(\"gingeub\");'>" + addComma(data.GINGEUB_CNT) + "</a>";
		rowStr += "	</td>";
		
		rowStr += "	<td>" + addComma(data.BS_REG_CNT) + "</td>";
		rowStr += "	<td>" + addComma(data.BS_FINISH_CNT) + "</td>";
		rowStr += "	<td>" + addComma(data.BS_PARTIAL_CNT) + "</td>";
		rowStr += "	<td class='last'>" + addComma(data.BS_CANCEL_CNT) + "</td>";
		
		rowStr += "</tr>";
	}
	
	return rowStr;
}

function showWorkProcessDL(response){
	// 나의주요업무처리 리스트
	var mainWorkProcessList = response.mainWorkProcessList;
	
	$("#tbWorkProcListDL").empty();
	// 나의주요업무처리 리스트 row data
	if(mainWorkProcessList.length > 0){
		
		var IF_ERR_CNT					= 0;
		var IV_DO_NO_CNT				= 0;
		var IV_LONG_DO_NO_CNT			= 0;
		var IV_EXPECT_DELAY_CNT			= 0;
		var IV_DELAY_CNT				= 0;
		var IV_LONG_EXPECT_DELAY_CNT	= 0;
		var IV_BAD_DELAY_CNT			= 0;
		var IV_DI_NO_CNT				= 0;
		var GR_NO_DELAY					= 0;
		var QT_RECV_CNT					= 0;
		var QT_DELAY_CNT				= 0;
		var QT_LONG_DELAY_CNT			= 0;
		
		var rowStr = "";
		
		for(var i = 0; i < mainWorkProcessList.length; i++){
			
			var data = mainWorkProcessList[i];
			//CODE
			rowStr = "";
			rowStr += "<tr>";
			rowStr += "	<th class='row' scope='row'>" + data.DEPT_NAME + "</th>";	// 고객사
			
			rowStr += "	<td>" + addComma(data.IF_ERR_CNT) + "</td>";	// I/F오류_오류
			rowStr += "	<td>" + addComma(data.IV_DO_NO_CNT) + "</td>";	// 수주접수_미접수
			rowStr += "	<td>" + addComma(data.IV_LONG_DO_NO_CNT) + "</td>";	// 수주접수_장기미접수
			rowStr += "	<td>" + addComma(data.IV_EXPECT_DELAY_CNT) + "</td>";	// 납기_지연예상
			rowStr += "	<td>" + addComma(data.IV_DELAY_CNT) + "</td>";	// 납기_지연
			rowStr += "	<td>" + addComma(data.IV_LONG_EXPECT_DELAY_CNT) + "</td>";	// 납기_장기지연
			rowStr += "	<td>" + addComma(data.IV_BAD_DELAY_CNT) + "</td>";	// 납기_악성지연
			rowStr += "	<td>" + addComma(data.IV_DI_NO_CNT) + "</td>";	// 납기_실적미등록
			rowStr += "	<td>" + addComma(data.GR_NO_DELAY) + "</td>";	// 납기_고객사미입고
			rowStr += "	<td>" + addComma(data.QT_RECV_CNT) + "</td>";	// 견적_의뢰건
			rowStr += "	<td>" + addComma(data.QT_DELAY_CNT) + "</td>";	// 견적_제출지연
			rowStr += "	<td>" + addComma(data.QT_LONG_DELAY_CNT) + "</td>";	// 견적_장기지연
			
			rowStr += "</tr>";
			
			$("#tbWorkProcListDL").append( rowStr );
			
			IF_ERR_CNT					+= parseInt(data.IF_ERR_CNT);
			IV_DO_NO_CNT				+= parseInt(data.IV_DO_NO_CNT);
			IV_LONG_DO_NO_CNT			+= parseInt(data.IV_LONG_DO_NO_CNT);
			IV_EXPECT_DELAY_CNT			+= parseInt(data.IV_EXPECT_DELAY_CNT);
			IV_DELAY_CNT				+= parseInt(data.IV_DELAY_CNT);
			IV_LONG_EXPECT_DELAY_CNT	+= parseInt(data.IV_LONG_EXPECT_DELAY_CNT);
			IV_BAD_DELAY_CNT			+= parseInt(data.IV_BAD_DELAY_CNT);
			IV_DI_NO_CNT				+= parseInt(data.IV_DI_NO_CNT);
			GR_NO_DELAY					+= parseInt(data.GR_NO_DELAY);
			QT_RECV_CNT					+= parseInt(data.QT_RECV_CNT);
			QT_DELAY_CNT				+= parseInt(data.QT_DELAY_CNT);
			QT_LONG_DELAY_CNT			+= parseInt(data.QT_LONG_DELAY_CNT);
		}
		
		rowStr = "";
		rowStr += "<tr class='last'>";
		rowStr += "	<th class='row' scope='row'>총합</th>";
		
		rowStr += "	<td>" + addComma(IF_ERR_CNT) + "</td>";	// I/F오류_오류
		rowStr += "	<td>" + addComma(IV_DO_NO_CNT) + "</td>";	// 수주접수_미접수
		rowStr += "	<td>" + addComma(IV_LONG_DO_NO_CNT) + "</td>";	// 수주접수_장기미접수
		rowStr += "	<td>" + addComma(IV_EXPECT_DELAY_CNT) + "</td>";	// 납기_지연예상
		rowStr += "	<td>" + addComma(IV_DELAY_CNT) + "</td>";	// 납기_지연
		rowStr += "	<td>" + addComma(IV_LONG_EXPECT_DELAY_CNT) + "</td>";	// 납기_장기지연
		rowStr += "	<td>" + addComma(IV_BAD_DELAY_CNT) + "</td>";	// 납기_악성지연
		rowStr += "	<td>" + addComma(IV_DI_NO_CNT) + "</td>";	// 납기_실적미등록
		rowStr += "	<td>" + addComma(GR_NO_DELAY) + "</td>";	// 납기_고객사미입고
		rowStr += "	<td>" + addComma(QT_RECV_CNT) + "</td>";	// 견적_의뢰건
		rowStr += "	<td>" + addComma(QT_DELAY_CNT) + "</td>";	// 견적_제출지연
		rowStr += "	<td>" + addComma(QT_LONG_DELAY_CNT) + "</td>";	// 견적_장기지연
		
		rowStr += "</tr>";
		
		$("#tbWorkProcListDL").append( rowStr );
		
	} else {
		$("#tbWorkProcListDL").append( setEmptyRow("13") );
	}
	
	layerView('layerMainWorkProcess','show');
}

function showWorkProcessTL(response){
	// 나의주요업무처리 리스트
	var mainWorkProcessList = response.mainWorkProcessList;
	
	// 담당자별 처리현황
	var workProcessListByUser = response.workProcessListByUser;
	
	$("#tbWorkProcListDL").empty();
	$("#tbWorkProcListTL").empty();
	
	// 나의주요업무처리 리스트 row data
	if(mainWorkProcessList.length > 0){
		
		var IF_ERR_CNT					= 0;
		var IV_DO_NO_CNT				= 0;
		var IV_LONG_DO_NO_CNT			= 0;
		var IV_EXPECT_DELAY_CNT			= 0;
		var IV_DELAY_CNT				= 0;
		var IV_LONG_EXPECT_DELAY_CNT	= 0;
		var IV_BAD_DELAY_CNT			= 0;
		var IV_DI_NO_CNT				= 0;
		var GR_NO_CNT					= 0;
		var QT_RECV_CNT					= 0;
		var QT_DELAY_CNT				= 0;
		var QT_LONG_DELAY_CNT			= 0;
		
		var rowStr = "";
		
		for(var i = 0; i < mainWorkProcessList.length; i++){
			
			var data = mainWorkProcessList[i];
			//CODE
			rowStr = "";
			rowStr += "<tr>";
			rowStr += "	<th class='row' scope='row'>" + data.BUYER_NAME_LOC + "</th>";	// 고객사
			
			rowStr += "	<td>";	// I/F오류_오류
			rowStr += "		<a href='javascript:doActionTab(\"ifErr\",\""+data.BUYER+"\",\""+data.BUYER_NAME_LOC+"\");' name='if_err_cnt'>" + addComma(data.IF_ERR_CNT) + "</a>";
			rowStr += "	</td>";
			rowStr += "	<td>";	// 수주접수_미접수
			rowStr += "		<a href='javascript:doActionTab(\"ivDoNo\",\""+data.BUYER+"\",\""+data.BUYER_NAME_LOC+"\");' name='iv_do_no_cnt'>" + addComma(data.IV_DO_NO_CNT) + "</a>";
			rowStr += "	</td>";
			rowStr += "	<td>";	// 수주접수_장기미접수
			rowStr += "		<a href='javascript:doActionTab(\"ivLongDoNo\",\""+data.BUYER+"\",\""+data.BUYER_NAME_LOC+"\");' name='iv_long_do_no_cnt'>" + addComma(data.IV_LONG_DO_NO_CNT) + "</a>";
			rowStr += "	</td>";
			rowStr += "	<td>";	// 납기_지연예상
			rowStr += "		<a href='javascript:doActionTab(\"ivExpectDelay\",\""+data.BUYER+"\",\""+data.BUYER_NAME_LOC+"\");' name='iv_expect_delay_cnt'>" + addComma(data.IV_EXPECT_DELAY_CNT) + "</a>";
			rowStr += "	</td>";
			rowStr += "	<td>";	// 납기_지연
			rowStr += "		<a href='javascript:doActionTab(\"ivDelay\",\""+data.BUYER+"\",\""+data.BUYER_NAME_LOC+"\");' name='iv_delay_cnt'>" + addComma(data.IV_DELAY_CNT) + "</a>";
			rowStr += "	</td>";
			rowStr += "	<td>";	// 납기_장기지연
			rowStr += "		<a href='javascript:doActionTab(\"ivLongExpectDelay\",\""+data.BUYER+"\",\""+data.BUYER_NAME_LOC+"\");' name='iv_long_expect_delay_cnt'>" + addComma(data.IV_LONG_EXPECT_DELAY_CNT) + "</a>";
			rowStr += "	</td>";
			rowStr += "	<td>";	// 납기_악성지연
			rowStr += "		<a href='javascript:doActionTab(\"ivBadDelayCnt\",\""+data.BUYER+"\",\""+data.BUYER_NAME_LOC+"\");' name='iv_bad_delay_cnt'>" + addComma(data.IV_BAD_DELAY_CNT) + "</a>";
			rowStr += "	</td>";
			rowStr += "	<td>";	// 납기_실적미등록
			rowStr += "		<a href='javascript:doActionTab(\"ivDiNoCnt\",\""+data.BUYER+"\",\""+data.BUYER_NAME_LOC+"\");' name='iv_di_no_cnt'>" + addComma(data.IV_DI_NO_CNT) + "</a>";
			rowStr += "	</td>";
			rowStr += "	<td>";	// 납기_고객사미입고
			rowStr += "		<a href='javascript:doActionTab(\"grNo\",\""+data.BUYER+"\",\""+data.BUYER_NAME_LOC+"\");' name='gr_no_cnt'>" + addComma(data.GR_NO_CNT) + "</a>";
			rowStr += "	</td>";
			rowStr += "	<td>";	// 견적_의뢰건
			rowStr += "		<a href='javascript:doActionTab(\"qtRecv\",\""+data.BUYER+"\",\""+data.BUYER_NAME_LOC+"\");' name='qt_recv_cnt'>" + addComma(data.QT_RECV_CNT) + "</a>";
			rowStr += "	</td>";
			rowStr += "	<td>";	// 견적_제출지연
			rowStr += "		<a href='javascript:doActionTab(\"qtDelay\",\""+data.BUYER+"\",\""+data.ITEM_GROUP+"\");' name='qt_delay_cnt'>" + addComma(data.QT_DELAY_CNT) + "</a>";
			rowStr += "	</td>";
			rowStr += "	<td>";	// 견적_장기지연
			rowStr += "		<a href='javascript:doActionTab(\"qtLongDelay\",\""+data.BUYER+"\",\""+data.ITEM_GROUP+"\");' name='qt_long_delay_cnt'>" + addComma(data.QT_LONG_DELAY_CNT) + "</a>";
			rowStr += "	</td>";
			
			rowStr += "</tr>";
			
			$("#tbWorkProcListDL").append( rowStr );
			
			IF_ERR_CNT					+= parseInt(data.IF_ERR_CNT);
			IV_DO_NO_CNT				+= parseInt(data.IV_DO_NO_CNT);
			IV_LONG_DO_NO_CNT			+= parseInt(data.IV_LONG_DO_NO_CNT);
			IV_EXPECT_DELAY_CNT			+= parseInt(data.IV_EXPECT_DELAY_CNT);
			IV_DELAY_CNT				+= parseInt(data.IV_DELAY_CNT);
			IV_LONG_EXPECT_DELAY_CNT	+= parseInt(data.IV_LONG_EXPECT_DELAY_CNT);
			IV_BAD_DELAY_CNT			+= parseInt(data.IV_BAD_DELAY_CNT);
			IV_DI_NO_CNT				+= parseInt(data.IV_DI_NO_CNT);
			GR_NO_CNT					+= parseInt(data.GR_NO_CNT);
			QT_RECV_CNT					+= parseInt(data.QT_RECV_CNT);
			QT_DELAY_CNT				+= parseInt(data.QT_DELAY_CNT);
			QT_LONG_DELAY_CNT			+= parseInt(data.QT_LONG_DELAY_CNT);
		}
		
		rowStr = "";
		rowStr += "<tr class='last'>";
		rowStr += "	<th class='row' scope='row'>총합</th>";
		
		rowStr += "	<td>" + addComma(IF_ERR_CNT) + "</td>";	// I/F오류_오류
		rowStr += "	<td>" + addComma(IV_DO_NO_CNT) + "</td>";	// 수주접수_미접수
		rowStr += "	<td>" + addComma(IV_LONG_DO_NO_CNT) + "</td>";	// 수주접수_장기미접수
		rowStr += "	<td>" + addComma(IV_EXPECT_DELAY_CNT) + "</td>";	// 납기_지연예상
		rowStr += "	<td>" + addComma(IV_DELAY_CNT) + "</td>";	// 납기_지연
		rowStr += "	<td>" + addComma(IV_LONG_EXPECT_DELAY_CNT) + "</td>";	// 납기_장기지연
		rowStr += "	<td>" + addComma(IV_BAD_DELAY_CNT) + "</td>";	// 납기_악성지연
		rowStr += "	<td>" + addComma(IV_DI_NO_CNT) + "</td>";	// 납기_실적미등록
		rowStr += "	<td>" + addComma(GR_NO_CNT) + "</td>";	// 납기_고객사미입고
		rowStr += "	<td>" + addComma(QT_RECV_CNT) + "</td>";	// 견적_의뢰건
		rowStr += "	<td>" + addComma(QT_DELAY_CNT) + "</td>";	// 견적_제출지연
		rowStr += "	<td>" + addComma(QT_LONG_DELAY_CNT) + "</td>";	// 견적_장기지연
		
		rowStr += "</tr>";
		
		$("#tbWorkProcListDL").append( rowStr );
		
	} else {
		$("#tbWorkProcListDL").append( setEmptyRow("13") );
	}
	
	// 담당자별 처리현황
	if(workProcessListByUser.length > 0){
		
		var IF_ERR_CNT					= 0;
		var IV_DO_NO_CNT				= 0;
		var IV_LONG_DO_NO_CNT			= 0;
		var IV_EXPECT_DELAY_CNT			= 0;
		var IV_DELAY_CNT				= 0;
		var IV_LONG_EXPECT_DELAY_CNT	= 0;
		var IV_BAD_DELAY_CNT			= 0;
		var IV_DI_NO_CNT				= 0;
		var GR_NO_CNT					= 0;
		var QT_RECV_CNT					= 0;
		var QT_DELAY_CNT				= 0;
		var QT_LONG_DELAY_CNT			= 0;
		
		var rowStr = "";
		
		for(var i = 0; i < workProcessListByUser.length; i++){
			
			var data = workProcessListByUser[i];
			//CODE
			rowStr = "";
			rowStr += "<tr>";
			rowStr += "	<th class='row' scope='row'>" + data.KEP_USER_NAME + "</th>";	// 고객사
			
			rowStr += "	<td>" + addComma(data.IF_ERR_CNT) + "</td>";	// I/F오류_오류
			rowStr += "	<td>" + addComma(data.IV_DO_NO_CNT) + "</td>";	// 수주접수_미접수
			rowStr += "	<td>" + addComma(data.IV_LONG_DO_NO_CNT) + "</td>";	// 수주접수_장기미접수
			rowStr += "	<td>" + addComma(data.IV_EXPECT_DELAY_CNT) + "</td>";	// 납기_지연예상
			rowStr += "	<td>" + addComma(data.IV_DELAY_CNT) + "</td>";	// 납기_지연
			rowStr += "	<td>" + addComma(data.IV_LONG_EXPECT_DELAY_CNT) + "</td>";	// 납기_장기지연
			rowStr += "	<td>" + addComma(data.IV_BAD_DELAY_CNT) + "</td>";	// 납기_악성지연
			rowStr += "	<td>" + addComma(data.IV_DI_NO_CNT) + "</td>";	// 납기_실적미등록
			rowStr += "	<td>" + addComma(data.GR_NO_DELAY_CNT) + "</td>";	// 납기_고객사미입고
			rowStr += "	<td>" + addComma(data.QT_RECV_CNT) + "</td>";	// 견적_의뢰건
			rowStr += "	<td>" + addComma(data.QT_DELAY_CNT) + "</td>";	// 견적_제출지연
			rowStr += "	<td>" + addComma(data.QT_LONG_DELAY_CNT) + "</td>";	// 견적_장기지연
			
			rowStr += "</tr>";
			
			$("#tbWorkProcListTL").append( rowStr );
			
			IF_ERR_CNT					+= parseInt(data.IF_ERR_CNT);
			IV_DO_NO_CNT				+= parseInt(data.IV_DO_NO_CNT);
			IV_LONG_DO_NO_CNT			+= parseInt(data.IV_LONG_DO_NO_CNT);
			IV_EXPECT_DELAY_CNT			+= parseInt(data.IV_EXPECT_DELAY_CNT);
			IV_DELAY_CNT				+= parseInt(data.IV_DELAY_CNT);
			IV_LONG_EXPECT_DELAY_CNT	+= parseInt(data.IV_LONG_EXPECT_DELAY_CNT);
			IV_BAD_DELAY_CNT			+= parseInt(data.IV_BAD_DELAY_CNT);
			IV_DI_NO_CNT				+= parseInt(data.IV_DI_NO_CNT);
			GR_NO_CNT					+= parseInt(data.GR_NO_DELAY_CNT);
			QT_RECV_CNT					+= parseInt(data.QT_RECV_CNT);
			QT_DELAY_CNT				+= parseInt(data.QT_DELAY_CNT);
			QT_LONG_DELAY_CNT			+= parseInt(data.QT_LONG_DELAY_CNT);
		}
		
		rowStr = "";
		rowStr += "<tr class='last'>";
		rowStr += "	<th class='row' scope='row'>총합</th>";
		
		rowStr += "	<td>" + addComma(IF_ERR_CNT) + "</td>";	// I/F오류_오류
		rowStr += "	<td>" + addComma(IV_DO_NO_CNT) + "</td>";	// 수주접수_미접수
		rowStr += "	<td>" + addComma(IV_LONG_DO_NO_CNT) + "</td>";	// 수주접수_장기미접수
		rowStr += "	<td>" + addComma(IV_EXPECT_DELAY_CNT) + "</td>";	// 납기_지연예상
		rowStr += "	<td>" + addComma(IV_DELAY_CNT) + "</td>";	// 납기_지연
		rowStr += "	<td>" + addComma(IV_LONG_EXPECT_DELAY_CNT) + "</td>";	// 납기_장기지연
		rowStr += "	<td>" + addComma(IV_BAD_DELAY_CNT) + "</td>";	// 납기_악성지연
		rowStr += "	<td>" + addComma(IV_DI_NO_CNT) + "</td>";	// 납기_실적미등록
		rowStr += "	<td>" + addComma(GR_NO_CNT) + "</td>";	// 납기_고객사미입고
		rowStr += "	<td>" + addComma(QT_RECV_CNT) + "</td>";	// 견적_의뢰건
		rowStr += "	<td>" + addComma(QT_DELAY_CNT) + "</td>";	// 견적_제출지연
		rowStr += "	<td>" + addComma(QT_LONG_DELAY_CNT) + "</td>";	// 견적_장기지연
		
		rowStr += "</tr>";
		
		$("#tbWorkProcListTL").append( rowStr );
		
	} else {
		$("#tbWorkProcListTL").append( setEmptyRow("13") );
	}
	
	layerView('layerMainWorkProcess','show');
}
//소싱지원 대시보드
function showWorkProcessSS(response){

	var mainWorkProcessList = response.mainWorkProcessList;
	$("#tbWorkTobody").empty();
	// 나의주요업무처리 리스트 row data
	if(mainWorkProcessList.length > 0){
		var rowStr = "";
		for(var i = 0; i < mainWorkProcessList.length; i++){
			var data = mainWorkProcessList[i];			
			//CODE
			rowStr = "";
			rowStr += "<tr>";
			rowStr += "	<th>" + data.DEPT + "</th>";	// 부서
			rowStr += "	<td>";
			rowStr += "		<a href='javascript:doActionTab(\"req\",\""+data.DEPT+"\",\""+data.DEPT+"\");'>" + addComma(data.TOT_3_TARGET) + "</a>";
			rowStr += "	</td>";
			rowStr += "	<td class='last'>";
			rowStr += 		addComma(data.TOT_RATE);
			rowStr += "	</td>";
			rowStr += "</tr>";
			$("#tbWorkTobody").append(rowStr);
		}
	} else {
		$("#tbWorkTobody").append(setEmptyRow("1"));
	}
	layerView('layerMainWorkSourPartProcess','show');
}
//SM 대시보드
function showWorkProcessSM(response){

	var mainWorkProcessList = response.mainWorkProcessList;
	$("#tbWorkTobody2").empty();
	// 나의주요업무처리 리스트 row data
	if(mainWorkProcessList.length > 0){
		var rowStr = "";
		for(var i = 0; i < mainWorkProcessList.length; i++){
			var data = mainWorkProcessList[i];			
			//CODE
			rowStr = "";
			rowStr += "<tr>";
			rowStr += "	<th>" + data.USER_DEPT_NM + "</th>";//부서
			rowStr += "	<td>" + data.USR_NM + "</td>";//담당자
			rowStr += "	<td>" + addComma(data.T_ITEM_CNT) + "</td>";//전체품목수
			rowStr += "	<td>" + addComma(data.EXPIRED_ITEM_CNT) + "</td>";//유효기간 지난품목
			rowStr += "	<td>" + addComma(data.MON_01) + "</td>";
			rowStr += "	<td>" + addComma(data.MON_02) + "</td>";
			rowStr += "	<td>" + addComma(data.MON_03) + "</td>";
			rowStr += "	<td>" + addComma(data.MON_04) + "</td>";
			rowStr += "	<td>" + addComma(data.MON_05) + "</td>";
			rowStr += "	<td>" + addComma(data.MON_06) + "</td>";
			rowStr += "	<td>" + addComma(data.MON_07) + "</td>";
			rowStr += "	<td>" + addComma(data.MON_08) + "</td>";
			rowStr += "	<td>" + addComma(data.MON_09) + "</td>";
			rowStr += "	<td>" + addComma(data.MON_10) + "</td>";
			rowStr += "	<td>" + addComma(data.MON_11) + "</td>";
			rowStr += "	<td>" + addComma(data.MON_12) + "</td>";
			rowStr += "	<td>";
			rowStr += "		<a href='javascript:doActionTab(\"voc\",\""+data.USER_DEPT_NM+"\",\""+data.USER_DEPT_NM+"\");'>" +addComma(data.UNPROCESSED_VOC_CNT)  + "</a>";
			rowStr += "	</td>";
			rowStr += "</tr>";
			$("#tbWorkTobody2").append(rowStr);
		}
		
	} else {
		$("#tbWorkTobody2").append(setEmptyRow("1"));
	}
	layerView('layerMainWorkSMProcess','show');
}
//DSM 대시보드
function showWorkProcessDSM(response){

	var mainWorkProcessList = response.mainWorkProcessList;
	$("#tbWorkTobody3").empty();
	// 나의주요업무처리 리스트 row data
	if(mainWorkProcessList.length > 0){
		var rowStr = "";
		for(var i = 0; i < mainWorkProcessList.length; i++){
			var data = mainWorkProcessList[i];			
			//CODE
			rowStr = "";
			rowStr += "<tr>";
			rowStr += "	<th>" + data.USER_DEPT_NM + "</th>";//부서
			rowStr += "	<td>" + data.USR_NM + "</td>";//담당자
			rowStr += "	<td>";
			rowStr += "		<a href='javascript:doActionTab(\"quotationList\",\""+data.USER_DEPT_NM+"\",\""+data.USER_DEPT_NM+"\");'>" +addComma(data.SOURCING_CM_CNT)  + "</a>";
			rowStr += "	</td>";
			rowStr += "	<td>";
			rowStr += "		<a href='javascript:doActionTab(\"sendQuotation\",\""+data.USER_DEPT_NM+"\",\""+data.USER_DEPT_NM+"\");'>" +addComma(data.SOURCING_CM_1DAY)  + "</a>";
			rowStr += "	</td>";
			rowStr += "	<td>";
			rowStr += "		<a href='javascript:doActionTab(\"sendQuotation\",\""+data.USER_DEPT_NM+"\",\""+data.USER_DEPT_NM+"\");'>" +addComma(data.SOURCING_CM_2DAY)  + "</a>";
			rowStr += "	</td>";
			rowStr += "	<td>";
			rowStr += "		<a href='javascript:doActionTab(\"sendQuotation\",\""+data.USER_DEPT_NM+"\",\""+data.USER_DEPT_NM+"\");'>" +addComma(data.SOURCING_CM_3_4DAY)  + "</a>";
			rowStr += "	</td>";
			rowStr += "	<td>";
			rowStr += "		<a href='javascript:doActionTab(\"sendQuotation\",\""+data.USER_DEPT_NM+"\",\""+data.USER_DEPT_NM+"\");'>" +addComma(data.SOURCING_CM_5DAY_OVER)  + "</a>";
			rowStr += "	</td>";
			rowStr += "	<td>";
			rowStr += "		<a href='javascript:doActionTab(\"voc\",\""+data.USER_DEPT_NM+"\",\""+data.USER_DEPT_NM+"\");'>" +addComma(data.UNPROCESSED_VOC_CNT)  + "</a>";
			rowStr += "	</td>";
			rowStr += "</tr>";
			$("#tbWorkTobody3").append(rowStr);
		}
		
	} else {
		$("#tbWorkTobody3").append(setEmptyRow("1"));
	}
	layerView('layerMainWorkDSMProcess','show');
}
//DSM 대시보드
function showWorkProcessST(response){
	//소싱지원파트
	var mainWorkProcessSSList = response.mainWorkProcessSSList;
	$("#tbWorkTobody4").empty();
	// 나의주요업무처리 리스트 row data
	if(mainWorkProcessSSList.length > 0){
		var rowStr = "";
		for(var i = 0; i < mainWorkProcessSSList.length; i++){
			var data = mainWorkProcessSSList[i];			
			//CODE
			rowStr = "";
			rowStr += "<tr>";
			rowStr += "	<th>" + data.DEPT + "</th>";	// 부서
			rowStr += "	<td>";
			rowStr += "		<a href='javascript:doActionTab(\"req\",\""+data.DEPT+"\",\""+data.DEPT+"\");'>" + addComma(data.TOT_3_TARGET) + "</a>";
			rowStr += "	</td>";
			rowStr += "	<td class='last'>";
			rowStr += 		addComma(data.TOT_RATE);
			rowStr += "	</td>";
			rowStr += "</tr>";
			$("#tbWorkTobody4").append(rowStr);
		}
	}
	//DSM
	var mainWorkProcessDSMList = response.mainWorkProcessDSMList;
	$("#tbWorkTobody5").empty();
	// 나의주요업무처리 리스트 row data
	var st_sourcing_cm_cnt = 0;
	var st_sourcing_cm_cnt_1 = 0;
	var st_sourcing_cm_cnt_2 = 0;
	var st_sourcing_cm_cnt_3 = 0;
	var st_sourcing_cm_cnt_5 = 0;
	var st_voc_cnt_5 = 0;
	if(mainWorkProcessDSMList.length > 0){
		var rowStr = "";
		for(var i = 0; i < mainWorkProcessDSMList.length; i++){
			var data = mainWorkProcessDSMList[i];
			//합계 구하는 수식
			st_sourcing_cm_cnt = data.SOURCING_CM_CNT + st_sourcing_cm_cnt;
			st_sourcing_cm_cnt_1 = data.SOURCING_CM_1DAY + st_sourcing_cm_cnt_1;
			st_sourcing_cm_cnt_2 = data.SOURCING_CM_2DAY + st_sourcing_cm_cnt_2;
			st_sourcing_cm_cnt_3 = data.SOURCING_CM_3_4DAY + st_sourcing_cm_cnt_3;
			st_sourcing_cm_cnt_5 = data.SOURCING_CM_5DAY_OVER + st_sourcing_cm_cnt_5;
			st_voc_cnt_5 = data.UNPROCESSED_VOC_CNT + st_voc_cnt_5;
			//CODE
			rowStr = "";
			rowStr += "<tr>";
			rowStr += "	<th>" + data.USER_DEPT_NM + "</th>";//부서
			rowStr += "	<td>" + data.USR_NM + "</td>";//담당자
			rowStr += "	<td>";
			rowStr += "		<a href='javascript:doActionTab(\"quotationList\",\""+data.USER_DEPT_NM+"\",\""+data.USER_DEPT_NM+"\");'>" +addComma(data.SOURCING_CM_CNT)  + "</a>";
			rowStr += "	</td>";
			rowStr += "	<td>";
			rowStr += "		<a href='javascript:doActionTab(\"sendQuotation\",\""+data.USER_DEPT_NM+"\",\""+data.USER_DEPT_NM+"\");'>" +addComma(data.SOURCING_CM_1DAY)  + "</a>";
			rowStr += "	</td>";
			rowStr += "	<td>";
			rowStr += "		<a href='javascript:doActionTab(\"sendQuotation\",\""+data.USER_DEPT_NM+"\",\""+data.USER_DEPT_NM+"\");'>" +addComma(data.SOURCING_CM_2DAY)  + "</a>";
			rowStr += "	</td>";
			rowStr += "	<td>";
			rowStr += "		<a href='javascript:doActionTab(\"sendQuotation\",\""+data.USER_DEPT_NM+"\",\""+data.USER_DEPT_NM+"\");'>" +addComma(data.SOURCING_CM_3_4DAY)  + "</a>";
			rowStr += "	</td>";
			rowStr += "	<td>";
			rowStr += "		<a href='javascript:doActionTab(\"sendQuotation\",\""+data.USER_DEPT_NM+"\",\""+data.USER_DEPT_NM+"\");'>" +addComma(data.SOURCING_CM_5DAY_OVER)  + "</a>";
			rowStr += "	</td>";
			rowStr += "	<td>";
			rowStr += "		<a href='javascript:doActionTab(\"voc\",\""+data.USER_DEPT_NM+"\",\""+data.USER_DEPT_NM+"\");'>" +addComma(data.UNPROCESSED_VOC_CNT)  + "</a>";
			rowStr += "	</td>";
			rowStr += "</tr>";
			$("#tbWorkTobody5").append(rowStr);
		}
		rowStr = "";
		rowStr += "<tr>";
		rowStr += "	<th>합계</th>";
		rowStr += "	<td></td>";
		rowStr += "	<td>"+addComma(st_sourcing_cm_cnt)+"</td>";
		rowStr += "	<td>"+addComma(st_sourcing_cm_cnt_1)+"</td>";
		rowStr += "	<td>"+addComma(st_sourcing_cm_cnt_2)+"</td>";
		rowStr += "	<td>"+addComma(st_sourcing_cm_cnt_3)+"</td>";
		rowStr += "	<td>"+addComma(st_sourcing_cm_cnt_5)+"</td>";
		rowStr += "	<td>"+addComma(st_voc_cnt_5)+"</td>";
		rowStr += "</tr>";
		$("#tbWorkTobody5").append(rowStr);
		
	} else {
		$("#tbWorkTobody5").append(setEmptyRow("1"));
	}
	//SM
	var mainWorkProcessSMList = response.mainWorkProcessSMList;
	$("#tbWorkTobody6").empty();
	// 나의주요업무처리 리스트 row data
	var st_t_item_cnt = 0;
	var st_expired_cnt = 0;
	var st_mon_1 = 0;
	var st_mon_2 = 0;
	var st_mon_3 = 0;
	var st_mon_4 = 0;
	var st_mon_5 = 0;
	var st_mon_6 = 0;
	var st_mon_7 = 0;
	var st_mon_8 = 0;
	var st_mon_9 = 0;
	var st_mon_10 = 0;
	var st_mon_11 = 0;
	var st_mon_12 = 0;
	var st_voc_cnt = 0;
	if(mainWorkProcessSMList.length > 0){
		var rowStr = "";
		for(var i = 0; i < mainWorkProcessSMList.length; i++){
			var data = mainWorkProcessSMList[i];			
			//CODE
			st_t_item_cnt = data.T_ITEM_CNT + st_t_item_cnt;
			st_expired_cnt = data.EXPIRED_ITEM_CNT + st_expired_cnt;
			st_mon_1 = data.MON_01 + st_mon_1;
			st_mon_2 = data.MON_02 + st_mon_2;
			st_mon_3 = data.MON_03 + st_mon_3;
			st_mon_4 = data.MON_04 + st_mon_4;
			st_mon_5 = data.MON_05 + st_mon_5;
			st_mon_6 = data.MON_06 + st_mon_6;
			st_mon_7 = data.MON_07 + st_mon_7;
			st_mon_8 = data.MON_08 + st_mon_8;
			st_mon_9 = data.MON_09 + st_mon_9;
			st_mon_10 = data.MON_10 + st_mon_10;
			st_mon_11 = data.MON_11 + st_mon_11;
			st_mon_12 = data.MON_12 + st_mon_12;
			st_voc_cnt = data.UNPROCESSED_VOC_CNT + st_voc_cnt;
			rowStr = "";
			rowStr += "<tr>";
			rowStr += "	<th>" + data.USER_DEPT_NM + "</th>";//부서
			rowStr += "	<td>" + data.USR_NM + "</td>";//담당자
			rowStr += "	<td>" + addComma(data.T_ITEM_CNT) + "</td>";//전체품목수
			rowStr += "	<td>" + addComma(data.EXPIRED_ITEM_CNT) + "</td>";//유효기간 지난품목
			rowStr += "	<td>" + addComma(data.MON_01) + "</td>";
			rowStr += "	<td>" + addComma(data.MON_02) + "</td>";
			rowStr += "	<td>" + addComma(data.MON_03) + "</td>";
			rowStr += "	<td>" + addComma(data.MON_04) + "</td>";
			rowStr += "	<td>" + addComma(data.MON_05) + "</td>";
			rowStr += "	<td>" + addComma(data.MON_06) + "</td>";
			rowStr += "	<td>" + addComma(data.MON_07) + "</td>";
			rowStr += "	<td>" + addComma(data.MON_08) + "</td>";
			rowStr += "	<td>" + addComma(data.MON_09) + "</td>";
			rowStr += "	<td>" + addComma(data.MON_10) + "</td>";
			rowStr += "	<td>" + addComma(data.MON_11) + "</td>";
			rowStr += "	<td>" + addComma(data.MON_12) + "</td>";
			rowStr += "	<td>";
			rowStr += "		<a href='javascript:doActionTab(\"voc\",\""+data.USER_DEPT_NM+"\",\""+data.USER_DEPT_NM+"\");'>" +addComma(data.UNPROCESSED_VOC_CNT)  + "</a>";
			rowStr += "	</td>";
			rowStr += "</tr>";
			$("#tbWorkTobody6").append(rowStr);
		}
		rowStr = "";
		rowStr += "<tr>";
		rowStr += "	<th>합계</th>";
		rowStr += "	<td></td>";
		rowStr += "	<td>"+addComma(st_t_item_cnt)+"</td>";
		rowStr += "	<td>"+addComma(st_expired_cnt)+"</td>";
		rowStr += "	<td>"+addComma(st_mon_1)+"</td>";
		rowStr += "	<td>"+addComma(st_mon_2)+"</td>";
		rowStr += "	<td>"+addComma(st_mon_3)+"</td>";
		rowStr += "	<td>"+addComma(st_mon_4)+"</td>";
		rowStr += "	<td>"+addComma(st_mon_5)+"</td>";
		rowStr += "	<td>"+addComma(st_mon_6)+"</td>";
		rowStr += "	<td>"+addComma(st_mon_7)+"</td>";
		rowStr += "	<td>"+addComma(st_mon_8)+"</td>";
		rowStr += "	<td>"+addComma(st_mon_9)+"</td>";
		rowStr += "	<td>"+addComma(st_mon_10)+"</td>";
		rowStr += "	<td>"+addComma(st_mon_11)+"</td>";
		rowStr += "	<td>"+addComma(st_mon_12)+"</td>";
		rowStr += "	<td>"+addComma(st_voc_cnt)+"</td>";
		rowStr += "</tr>";
		$("#tbWorkTobody6").append(rowStr);
		
	}
	layerView('layerMainWorkSTProcess','show');
}
</script>

<form id="contentForm" name="contentForm" method="post">
<input type="hidden" id="search_yn" value="N" />
<input type="hidden" id="upperId" name="upperId" value="${param.upperId}"/>
<input type="hidden" id="com_code" name="com_code" value="${sessionInfo.comCode}"/>
<input type="hidden" id="user_id" name="user_id" value="${sessionInfo.userId}"/>
<input type="hidden" id="dept_code" name="dept_code" value="${sessionInfo.department}"/>
<input type="hidden" id="dept_name" name="dept_name" value="${sessionInfo.departmentName}"/>
<input type="hidden" id="user_type" name="user_type" value="${sessionInfo.userType}"/>
<input type="hidden" id="buyer" name="buyer" value=""/>

<div id="admin_home" style="margin:0px 0px 0px 0px;">
	<div id="main_table_div" style="margin-bottom:0px;">
		<!-- 
		<div class="main_table_summ">
			<div class="LinkImg" >
				<ul>
					<li class="bgNo"> <a href="javascript:layerView('layerMainWorkProcess','show');"><img src="/resources/images/m_link_img5.gif" /> <p>나의 주요업무처리</br><span>바로가기 >></span></p></a></li>
					<li class="bgYes"><a href="javascript:layerView('layerManageIndexDefine','show');"><img src="/resources/images/m_link_img6.gif" /> <p>관리지표정의</br><span>바로가기 >></span></p></a></li>
					<li class="bgYes"><a href="#"><img src="/resources/images/m_link_img7.gif" /> <p>회원사관리</br><span>바로가기 >></span></p></a></li>
					<li class="bgYes"><a href="#"><img src="/resources/images/m_link_img8.gif" /> <p>관리고객사지정</br><span>바로가기 >></span></p></a></li>
				</ul>
			</div>
		</div>
		 -->
		<!-- 소싱지원 대시보드-->
		<div id="layerMainWorkSourPartProcess" class="Dashboard_sourcing" style="top:180px; left:300px; display:none;" >
		  <div class="LayerPopup_Close">  <a href="javascript:layerView('layerMainWorkSourPartProcess','');">X</a> </div>
		  <div class="Dashboard_sourcing_Tit">구매기획팀</div>  
		  <table class="DashboardsourcingTable">
		      <colgroup>
		          <col width="150px"> 
		          <col width="150px"> 
		          <col width="150px">  
		      </colgroup>
		      <thead>
		        <tr>
		          <th>담당부서</th>
		          <th>견적 SG미분류건</th>
		          <th>견적 진행률(%)</th>
		        </tr>
		      <thead>
			  <tbody id="tbWorkTobody">
			  </tbody>
		    </table>
    		<div style="margin:0 auto;width:450px;color:#fff;line-height:35px;">※ 견적 SG 미분류건은 최근 7일 기준이며, 견적 진행률은 D-1, D일에 대한 </div> 
    		<div style="margin:0 auto;width:450px;color:#fff;line-height:0px;">SG분류 진행률 입니다.</div> 
		</div>
		<!-- SM -->
		<div id="layerMainWorkSMProcess" class="DB_SM" style="top:180px; left:100px; display:none;" >
		  <div class="LayerPopup_Close">  <a href="javascript:layerView('layerMainWorkSMProcess','');">X</a> </div>
		  <div class="DB_SM_Tit ">갱신 카탈로그</div>  
		  <table class="DB_SMTable"    >
		      <colgroup>
		          <col width="90px"> 
		          <col width="90px"> 
		          <col width="90px"> 
		          <col width="90px">  
		          <col width="45px"> 
		          <col width="45px"> 
		          <col width="45px"> 
		          <col width="45px"> 
		          <col width="45px"> 
		          <col width="45px"> 
		          <col width="45px"> 
		          <col width="45px"> 
		          <col width="45px"> 
		          <col width="45px"> 
		          <col width="45px"> 
		          <col width="45px"> 
		          <col width="70px">   
		      
		      </colgroup>
		      <thead>
		        <tr>
		          <th rowspan="2" >구분</th>
		          <th rowspan="2" >담당자명</th>
		          <th rowspan="2" >전체품목수</th>
		          <th rowspan="2">유효기간 <br/>지난품목수</th>
		          <th colspan="12" >매입단가 유효기간 종료 예정월</th>
		          <th rowspan="2">VOC <br/>미처리건</th>
		        </tr>
		        <tr>
		          <td >1월</td>
		          <td >2월</td>
		          <td >3월</td>
		          <td >4월</td>
		          <td >5월</td>
		          <td >6월</td>
		          <td >7월</td>
		          <td >8월</td>
		          <td >9월</td>
		          <td >10월</td>
		          <td >11월</td>
		          <td >12월</td>
		        </tr>
		      <thead>
		      <tbody id="tbWorkTobody2">
		      </tbody>
		    </table>
		    <div style="margin:0 auto;width:950px;color:#fff;line-height:35px;">※ 데이터 집계는 30분 단위로 실행 됩니다. </div>
		</div>
		<!-- DSM -->
		<div id="layerMainWorkDSMProcess" class="DB_DSM" style="top:180px; left:200px; display:none" >
		  <div class="LayerPopup_Close">  <a href="javascript:layerView('layerMainWorkDSMProcess','');">X</a> </div>
		  <div class="DB_DSM_Tit ">DSM</div>  
		  <table class="DB_DSMTable"    >
		      <colgroup>
		          <col width="100px"> 
		          <col width="100px"> 
		          <col width="100px"> 
		          <col width="80px"> 
		          <col width="80px"> 
		          <col width="80px"> 
		          <col width="80px"> 
		          <col width="100px">   
		      
		      </colgroup>
		      <thead>
		        <tr>
		          <th rowspan="2" >구분</th>
		          <th rowspan="2" >담당자명</th>
		          <th rowspan="2">소싱 <br/>미완료 건수</th>
		          <th colspan="4" >소싱 미완료 리드타임</th>
		          <th rowspan="2">VOC <br/>미처리건</th>
		        </tr>
		        <tr>
		          <td >1일</td>
		          <td >2일</td>
		          <td >3~4일</td>
		          <td >5일이상</td> 
		        </tr>
		      <thead>
		      <tbody id="tbWorkTobody3">
		      </tbody>
		    </table>
		    <div style="margin:0 auto;width:700px;color:#fff;line-height:35px;">※ 데이터 집계는 30분 단위로 실행 됩니다. </div>
		</div>
		<!-- 팀장 -->
		<div id="layerMainWorkSTProcess" class="DB_TL" style="top:140px; left:80px; display:none">
		  <div class="LayerPopup_Close">  <a href="javascript:layerView('layerMainWorkSTProcess','');">X</a> </div>
		  <div class="DB_TL_Tit ">구매본부</div> 
		  	<table class="DB_TL_SCTable"    >
		      <colgroup>
		          <col width="100px"> 
		          <col width="100px"> 
		          <col width="100px">  
		      </colgroup>
		      <thead>
		        <tr>
		          <th>담당팀</th>
		          <th>SG미분류건</th>
		          <th>진행률(%)</th>
		        </tr>
		      <thead>
		      <tbody id="tbWorkTobody4">
		      </tbody>
		    </table>  
		  	<table class="DB_TL_DSMTable"    >
		      <colgroup>
		          <col width="80px"> 
		          <col width="80px"> 
		          <col width="100px"> 
		          <col width="80px"> 
		          <col width="80px"> 
		          <col width="80px"> 
		          <col width="80px"> 
		          <col width="80px">   
		      </colgroup>
		      <thead>
		        <tr>
		          <th rowspan="2" >담당팀</th>
		          <th rowspan="2" >DSM<br/>담당자명</th>
		          <th rowspan="2">소싱 <br/>미완료 건수</th>
		          <th colspan="4" >소싱 미완료 리드타임</th>
		          <th rowspan="2">VOC <br/>미처리건</th>
		        </tr>
		        <tr>
		          <td >1일</td>
		          <td >2일</td>
		          <td >3~4일</td>
		          <td >5일이상</td> 
		        </tr>
		      <thead>
		      <tbody id="tbWorkTobody5">
		      </tbody>
		    </table>
		    <table class="DB_TL_SMTable"    >
		      <colgroup>
		          <col width="90px"> 
		          <col width="90px"> 
		          <col width="90px"> 
		          <col width="90px">  
		          <col width="45px"> 
		          <col width="45px"> 
		          <col width="45px"> 
		          <col width="45px"> 
		          <col width="45px"> 
		          <col width="45px"> 
		          <col width="45px"> 
		          <col width="45px"> 
		          <col width="45px"> 
		          <col width="45px"> 
		          <col width="45px"> 
		          <col width="45px"> 
		          <col width="70px">   
		      </colgroup>
		      <thead>
		        <tr>
		          <th rowspan="2" >담당팀</th>
		          <th rowspan="2" >SM<br/>담당자명</th>
		          <th rowspan="2" >전체품목수</th>
		          <th rowspan="2">유효기간 <br/>지난품목수</th>
		          <th colspan="12" >매입단가 유효기간 종료 예정월</th>
		          <th rowspan="2">VOC <br/>미처리건</th>
		        </tr>
		        <tr>
		          <td >1월</td>
		          <td >2월</td>
		          <td >3월</td>
		          <td >4월</td>
		          <td >5월</td>
		          <td >6월</td>
		          <td >7월</td>
		          <td >8월</td>
		          <td >9월</td>
		          <td >10월</td>
		          <td >11월</td>
		          <td >12월</td>
		        </tr>
		      <thead>
		      <tbody id="tbWorkTobody6">
		      </tbody>
		    </table>
    		<div style="margin:0 auto;width:950px;color:#fff;line-height:35px;">※ 견적 SG 미분류건은 최근 7일 기준이며, 견적 진행률은 D-1, D일에 대한  SG분류 진행률 입니다.</div> 
		    <div style="margin:0 auto;width:950px;color:#fff;line-height:0px;">※ 데이터 집계는 30분 단위로 실행 됩니다. </div>
		</div>
		<!-- 레이어 나의 주요업무처리 팝업입니다.-->
		<div id="layerMainWorkProcess" class="main_table_LayerPopup" style="top:130px; left:60px; display:none; z-index: 100; overflow-y:hidden;" >
			<div class="LayerPopup_Tit">나의 주요업무처리<span><a href="javascript:layerView('layerMainWorkProcess','');"><img src="/resources/images/m_btn_popclose.gif" alt="닫기버튼" /></a></span></div>
			
			<div class="scrollArea" style="height:455px">
				<p class="B2BTit"><span>※ 기준 : 데이타 집계 30분, (예외 : I/F오류건 실시간)</span></p>
				<div class="wrap_tbl" id="divHeaderMB">
					<table class="t_masterMain05" summary="주요처리업무" width="1040px" >
						<colgroup>
							<col width="120px"><!--고객사-->
							<col width="45px"><!--오류-->
							<col width="50px"><!--임시저장-->
							<col width="45px"><!--미접수-->
							<col width="55px"><!--장기미접수-->
							<col width="50px"><!--지연예상-->
							<col width="45px"><!--지연-->
							<col width="50px"><!--장기지연-->
							<col width="50px"><!--악성지연-->
							<col width="55px"><!--실적미등록-->
							<col width="65px"><!--고객사미입고-->
							<col width="45px"><!--의뢰건-->
							<col width="50px"><!--제출지연-->
							<col width="50px"><!--장기지연-->
							<col width="50px"><!--규격의뢰-->
							<col width="45px"><!--확인-->
							<col width="40px"><!--nego의뢰-->
							<col width="70px"><!--최종집계의뢰일시-->
							<col width="60px"><!--고객사별의뢰재집계-->
						</colgroup>
						<thead>
							<tr>
								<th rowspan="2" class="BGblue">고객사</th>
								<th colspan="2" class="BGgrey">I/F오류</th>
								<th colspan="2" class="BGgrey">수주접수</th>
								<th colspan="6" class="BGgrey">납기</th>
								<th colspan="3" class="BGgrey">견적</th>
								<th colspan="2" class="BGgrey">품목</th>
								<th rowspan="2" class="BGblue_S">Nego<br/>의뢰</th>
								<th rowspan="2" class="BGblue_S">최종집계<br/>의뢰일시</th>
								<th rowspan="2" class="BGblue_S">고객사별<br/>의뢰재집계</th>
							</tr>
							<tr>
								<th class="BGgreen_S">오류</th>
								<th class="BGgreen_S">임시저장</th>
								<th class="BGgreen_S">미접수</th>
								<th class="BGgreen_S">장기미접수</th>
								<th class="BGblue_S">지연예상</th>
								<th class="BGblue_S">지연</th>
								<th class="BGblue_S">장기지연</th>
								<th class="BGblue_S">악성지연</th>
								<th class="BGblue_S">실적미등록</th>
								<th class="BGblue_S">고객사미입고</th>
								<th class="BGred_S">의뢰건</th>
								<th class="BGred_S">제출지연</th>
								<th class="BGred_S">장기지연</th>
								<th class="BGgreen_S">품목정비</th>
								<th class="BGgreen_S">물질정보</th>
							</tr>
						</thead>
						<tbody id="tbWorkProcList">
							<tr>
								<td colspan="19" class="time"  height="50">
									조회된 데이타가 없습니다.
								</td>
							</tr>
						</tbody>
					</table>
				</div>
				<div class="wrap_tbl" id="divHeaderDL">
					<table class="t_masterMain05" summary="주요처리업무" width="1040px" >
						<colgroup>
							<col width="150px"><!--부서-->
							<col width="70px"><!--오류-->
							<col width="70px"><!--미접수-->
							<col width="70px"><!--장기미접수-->
							<col width="70px"><!--지연예상-->
							<col width="70px"><!--지연-->
							<col width="70px"><!--장기지연-->
							<col width="75px"><!--악성지연-->
							<col width="75px"><!--실적미등록-->
							<col width="90px"><!--고객사미입고-->
							<col width="75px"><!--의뢰건-->
							<col width="75px"><!--제출지연-->
							<col width="75px"><!--장기지연-->
						</colgroup>
						<thead>
							<tr>
								<th rowspan="2" class="BGblue"><span id="spanDeptNm">부서</span></th>
								<th rowspan="2" class="BGgrey">I/F오류</th>
								<th colspan="2" class="BGgrey">수주접수</th>
								<th colspan="6" class="BGgrey">납기</th>
								<th colspan="3" class="BGgrey">견적</th>
							</tr>
							<tr>
								<th class="BGgreen_S">미접수</th>
								<th class="BGgreen_S">장기미접수</th>
								<th class="BGblue_S">지연예상</th>
								<th class="BGblue_S">지연</th>
								<th class="BGblue_S">장기지연</th>
								<th class="BGblue_S">악성지연</th>
								<th class="BGblue_S">실적미등록</th>
								<th class="BGblue_S">고객사미입고</th>
								<th class="BGred_S">의뢰건</th>
								<th class="BGred_S">제출지연</th>
								<th class="BGred_S">장기지연</th>
							</tr>
						</thead>
						<tbody id="tbWorkProcListDL">
							<tr>
								<td colspan="13" class="time"  height="50">
									조회된 데이타가 없습니다.
								</td>
							</tr>
						</tbody>
					</table>
				</div>
				
				<div id="divSubTable">
					<p class="B2BTit ">긴급납기 / 선입고</p>
					<div class="wrap_tbl">
						<table class="t_masterMain05" summary="긴급납기 / 선입고"  width="1040px" >
							<colgroup>
								<col width="120px">
								<col width="179px">
								<col width="179px">
								<col width="179px">
								<col width="179px">
								<col width="179px">
							</colgroup>
							<thead>
								<tr>
									<th rowspan="2" class="BGblue">부서</th>
									<th rowspan="2" class="BGred">긴급납기</th>
									<th colspan="4" class="BGgreen">선입고</th>
								</tr>
								<tr>
									<th class="BGgrey">선입고요청</th>
									<th class="BGgrey">발주완료</th>
									<th class="BGgrey">부분완료</th>
									<th class="BGgrey">선입고취소</th>
								</tr>
							</thead>
							<tbody id="tbGinGeubList">
								<tr>
									<td colspan="6" class="time"  height="50">
										조회된 데이타가 없습니다.
									</td>
								</tr>
							</tbody>
						</table>
					</div>
				</div>
				<div id="divTLSubTable">
					<p class="B2BTit ">담당자별 처리현황</p>
					<div class="wrap_tbl">
						<table class="t_masterMain05" summary="담당자별 처리현황" width="1040px" >
							<colgroup>
								<col width="150px"><!--부서-->
								<col width="70px"><!--오류-->
								<col width="70px"><!--미접수-->
								<col width="70px"><!--장기미접수-->
								<col width="70px"><!--지연예상-->
								<col width="70px"><!--지연-->
								<col width="70px"><!--장기지연-->
								<col width="75px"><!--악성지연-->
								<col width="75px"><!--실적미등록-->
								<col width="90px"><!--고객사미입고-->
								<col width="75px"><!--의뢰건-->
								<col width="75px"><!--제출지연-->
								<col width="75px"><!--장기지연-->
							</colgroup>
							<thead>
								<tr>
									<th rowspan="2" class="BGblue"><span id="spanDeptNm">부서</span></th>
									<th rowspan="2" class="BGgrey">I/F오류</th>
									<th colspan="2" class="BGgrey">수주접수</th>
									<th colspan="6" class="BGgrey">납기</th>
									<th colspan="3" class="BGgrey">견적</th>
								</tr>
								<tr>
									<th class="BGgreen_S">미접수</th>
									<th class="BGgreen_S">장기미접수</th>
									<th class="BGblue_S">지연예상</th>
									<th class="BGblue_S">지연</th>
									<th class="BGblue_S">장기지연</th>
									<th class="BGblue_S">악성지연</th>
									<th class="BGblue_S">실적미등록</th>
									<th class="BGblue_S">고객사미입고</th>
									<th class="BGred_S">의뢰건</th>
									<th class="BGred_S">제출지연</th>
									<th class="BGred_S">장기지연</th>
								</tr>
							</thead>
							<tbody id="tbWorkProcListTL">
								<tr>
									<td colspan="13" class="time"  height="50">
										조회된 데이타가 없습니다.
									</td>
								</tr>
							</tbody>
						</table>
					</div>
				</div>
			</div>
		</div>
		
		<!-- 레이어 관리지표정의 팝업입니다.-->
		<div id="layerManageIndexDefine" class="main_table_LayerPopup02" style="top:130px; left:160px; display:none;" >
			<div class="LayerPopup_Tit">관리지표정의<span><a href="javascript:layerView('layerManageIndexDefine','');"><img src="/resources/images/m_btn_popclose.gif" alt="닫기버튼" /></a></span></div>
			<div class="wrap_tbl">
				<table class="t_masterMain06" summary="관리지표정의" >
					<colgroup>
						<col width="130px">
						<col width="630px">
					</colgroup>
					<tbody>
						<tr>
							<th class="first">수주 미접수 관리</th>
							<td>고객사 발주건에 대하여 협력사 수주접수가 2일 이상 7일 미만 지연되고있는건 관리</td>
						</tr>
						<tr>
							<th>수주 미접수 장기건 관리</th>
							<td>고객사 발주건을 협력사에서 7일 이상 수주접수를 하고 있지 않는 장기 지연건 관리</td>
						</tr>
						<tr>
							<th>납품 지연 예상건 관리</th>
							<td>고객사 납품요청일이 아직 도래 하지 않은 발주건 중 "납품요청일" 대비, 협력사의 "납품예정일"이 늦는건에 대하여 사전 납기지연관리</td>
						</tr>
						<tr>
							<th>납품 지연건 관리</th>
							<td>고객사의 "납품요청일" 대비, "납품확정일자" or "입고일자"가 1일이상 7일미만 기간동안 확정되지 않은 지연건 관리(PA)</td>
						</tr>
						<tr>
							<th>납품 지연 장기건 관리</th>
							<td>고객사의 "납품요청일" 대비, "납품확정일자" or "입고일자"가 7일이상 30일미만 기간동안 확정되지 않은 장기지연건 관리(PM)</td>
						</tr>
						<tr>
							<th>납품 지연 악성건 관리</th>
							<td>고객사의 "납품요청일" 대비, "납품확정일자" or "입고일자"가 30일이상 확정되지 않은 장기 악성 지연건(사업담당자)</td>
						</tr>
						<tr>
							<th>납품 실적 미등록 관리</th>
							<td>협력사 납품실적 미등록 건</td>
						</tr>
						<tr>
							<th>미입고건</th>
							<td>협력사 납품실적등록까지 완료되었으나 고객사에서 입고실적 등록을 하지 않은 건</td>
						</tr>
						<tr>
							<th>의뢰건</th>
							<td>고객사에서 견적의뢰한 건중, CMS접수 및 할당 처리가 안된 건 </td>
						</tr>
						<tr>
							<th>견적제출 지연건 관리</th>
							<td>고객사 "견적회신요청일" 기준 "견적제출"이 15일 미만 지연되고 있는 건</td>
						</tr>
						<tr>
							<th>견적지연 장기건 관리</th>
							<td>고객사 "견적회신요청일" 기준 15일 이상 지나도록 고객사에 견적을 제출하고 있지 않는 건</td>
						</tr>
					</tbody>
				</table>
			</div>
		</div>
	</div>
</div>
</form>
