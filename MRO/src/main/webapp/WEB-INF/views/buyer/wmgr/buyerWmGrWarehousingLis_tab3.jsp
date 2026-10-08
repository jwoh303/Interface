<%--
**********************************************
* 메뉴 : 입고관리
* 화면 : 부서별입고집계 탭
* 기능 : 부서별입고집계 탭
* 프로그램 ID : BU0402003
* 담당자 : 최찬규
* 착수일 : 2026-05-11
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.*"%> 
<%@ page import="java.sql.Timestamp"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.util.CommonLang"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<%
// 공통
@SuppressWarnings (value="unchecked")
String grSttsType = CommonUtil.getKepBuyerFlagColumnReturn(request.getParameter("buyer"), "GR_STTS_TYPE"); // A:계정번호, B:관리번호, N:사용안함

//엑셀다운로드 기능 통제
boolean p170000001 = CommonUtil.getSpecialCheckReturn(request.getParameter("buyer"),"P17-0000001");
	
%>
<script type="text/javascript">
var mySheet3 = new ibsheetObject();
window.tabs = window.tabs || {};
tabs.buyerWmGrWarehousingLis_tab3 = {
	//alert layer용
	but1text : "<%=CommonLang.get("HTITLE516")%>",/* 확인 */
	but1func : "javascript:closePopText2(); return false;",
	but1funcSearch : "javascript:tabs.buyerWmGrWarehousingLis_tab3.thisPopClose(); return false;",
	but1width : "120px",
	pagingMode : "N",
	current_page : "1",
	popupSel : "",
	grbRow : "",
	grbStatus: "",
	grbGrDate:"",
	init:function(){
		if($("#st_from_date_3").val() ==  ""){
			$("#st_from_date_3").val(kepToMonthAdd("1","M"));
			$("#st_to_date_3").val(kepGetNowTimeStr('YYYYMMDD','/'));
		}
		
		var initsheet3 = {};
		initsheet3.Cfg = {MergeSheet:msHeaderOnly,     HeaderRowHeight: 50, DataRowHeight: 30,    Alternate : 0,UseNoDataRow:1};
		initsheet3.Cols = [
				 { Align:"Center",	SaveName:"sStatus",				Header:"<%=CommonLang.get("HTITLE255")%>",				Type:"Status",		Width:60,	Edit:false,	EditLen:0,		Hidden:true} /*상태*/
				,{ Align:"Center",	SaveName:"BUYER",			Header:"<%=CommonLang.get("HTITLE290")%>",				Type:"Text",		Width:150,	Edit:false,	EditLen:100,	Hidden:false} /*고객사코드*/
				,{ Align:"Left",	SaveName:"BUYER_NAME",		Header:"<%=CommonLang.get("HTITLE291")%>",				Type:"Text",		Width:240,	Edit:false,	EditLen:100,	Hidden:false} /*고객사명*/
				,{ Align:"Center",	SaveName:"REQ_DEPT",				Header:"<%=CommonLang.get("HTITLE292")%>",				Type:"Text",		Width:150,	Edit:false,	EditLen:100,	Hidden:false} /*요청부서코드*/
				,{ Align:"Left",	SaveName:"REQ_DEPT_NAME",				Header:"<%=CommonLang.get("HTITLE135")%>",				Type:"Text",		Width:520,	Edit:false,	EditLen:100,	Hidden:false, FontColor:"#3a72c7", Cursor:"Pointer"} /*요청부서*/
				,{ Align:"Center",	SaveName:"BUDGET_DEPT",			Header:"<%=CommonLang.get("HTITLE568")%>",				Type:"Text",		Width:100,	Edit:false,	EditLen:100,	Hidden:true} /*예산부서코드*/
				,{ Align:"Left",	SaveName:"BUDGET_DEPT_NAME",	Header:"<%=CommonLang.get("HTITLE268")%>",				Type:"Text",		Width:120,	Edit:false,	EditLen:100,	Hidden:true}/*예산부서*/
				,{ Align:"Center",	SaveName:"ACCOUNT_TYPE",		Header:"<%=CommonLang.get("HTITLE984")%>",				Type:"Text",		Width:100,	Edit:false,	EditLen:100,	Hidden:true} /*예산계정코드*/
				,{ Align:"Left",	SaveName:"ACCOUNT_NAME",		Header:"<%=CommonLang.get("HTITLE966")%>",				Type:"Text",		Width:120,	Edit:false,	EditLen:100,	Hidden:true} /*예산계정*/
				,{ Align:"Left",	SaveName:"REF_PR_NO",				Header:"<%=CommonLang.get("HTITLE18")%>",				Type:"Text",		Width:360,	Edit:false,	EditLen:100,	Hidden:true} /*관리번호*/
				
				,{ Align:"Right",	SaveName:"GR_AMT",				Header:"<%=CommonLang.get("HTITLE294")%>",				Type:"Float",		Width:120,	Edit:false,	EditLen:100,	Hidden:false, Format:"${priceFormat}"}/*입고집계금액*/
				,{ Align:"Center",	SaveName:"AR_BILL_FLAG",				Header:"<%=CommonLang.get("HTITLE289")%>",				Type:"Text",		Width:100,	Edit:false,	EditLen:100,	Hidden:false} /*정산여부*/
		];
		
		IBS_InitSheet(mySheet3, initsheet3, this.pagingMode);
		mySheet3.SetHighlightAfterSort(2);
		
		mySheet3.SetHeaderBackColor("#f2f7ff");
		mySheet3.SetTheme("DB", "DeepBlue");
		
		
	},
	search:function(value){
		if (kep_dateSearchCheck($("#st_from_date_3").val(),$("#st_to_date_3").val()) == false) return;
		var diff = kepGetDateDiff('st_from_date_3','st_to_date_3','D');
		if (eval(diff)>372){
			var text = "<%=CommonLang.msg("MSG617")%>";//1년 이내 조회만 가능합니다.
			openLayerPopText2(text,this.but1text,this.but1func,this.but1width);
			return;
		}
		$("#st_all_page_3").val("N");
		this.current_page = 1;
		kepSearch_v2(document.searchCondition3, mySheet3, "/wmgr/getBuyerWmGrWarehousingTotList_v2.do?page="+this.current_page, this.pagingMode);
	},
	reload:function(){
		kepReload_v2('searchCondition3');
		kepMonth_v2('st_from_date_3','st_to_date_3','1');
		$("#st_req_dept_code_3").val("");
		mySheet3.RemoveAll();
		
		$("#tot_amt_3").html("<%=CommonLang.get("HTITLE1469")%>"+ " : "+"0"+"<%=CommonLang.get("HTITLE660")%>");// 합계금액 : 0원
	},
	doAction:function(str,value1){
		switch (str) {
		case "departmentErase":
			$("#st_req_dept_code_3").val("");
			$("#st_req_dept_name_3").val("");
			break;
		case "excelDown":
			if (kep_dateSearchCheck($("#st_from_date_3").val(),$("#st_to_date_3").val()) == false) return;
			var diff = kepGetDateDiff('st_from_date_3','st_to_date_3','D');
			if (eval(diff)>372){
				var text = "<%=CommonLang.msg("MSG617")%>";//1년 이내 조회만 가능합니다.
				openLayerPopText2(text,this.but1text,this.but1func,this.but1width);
				return;
			}
			
			$("#st_all_page_3").val("Y");
			
			document.forms.searchCondition3.action = "/wmgr/excelBuyerWmGrWarehousingTotList_v2.do";
			document.forms.searchCondition3.submit();
			break;
		default:
			break;
		}
	},
	doPop:function(str,value1,value2,value3,value4){
		this.popupSel = str;
		var com_code = $("#st_com_code_3").val();
		switch (str) {
		case "department":
			openSearchPopup('/common/deptCodeAdminPop.do', "?open=Y&com_code="+com_code+"&tab_id=buyerWmGrWarehousingLis_tab3", "720,580,no"); 
			break;
		default:
			break;
		}
	},
	pageSearch:function(param){
		$("#st_all_page_3").val("N");
		this.current_page = param.page;
		kepSearch_v2(document.searchCondition3, mySheet3, "/wmgr/getBuyerWmGrWarehousingTotList_v2.do?page="+this.current_page, this.pagingMode);
	},
	setPopupReturn:function(value1,value2,value3){
		if(this.popupSel == "department") {
			$("#st_req_dept_code_3").val(value1);
			$("#st_req_dept_name_3").val(value2);
		}
	},
	kepAjaxSuccess:function(pMethod , response){
		var sMsg = response.msg.MSG;   
	},
	kepAjaxError:function(pMethod , response){
		//오류발생하였습니다.다시 한 번 시도해 주시기 바랍니다.
		 var text = "<%=CommonLang.msg("MSG163") %>  ";  
		 openLayerPopText2(text,this.but1text,this.but1func,this.but1width);
	},
	thisPopClose:function(){
		closePopText2();
		this.search();
	}
	
	
};
//조회 후처리
function mySheet3_OnSearchEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}	
	
	var grSttsType = "<%=grSttsType%>";
	
	if(grSttsType == "A"){
		mySheet3.SetColHidden("BUDGET_DEPT",false);
		mySheet3.SetColHidden("BUDGET_DEPT_NAME",false);
		mySheet3.SetColHidden("ACCOUNT_TYPE",false);
		mySheet3.SetColHidden("ACCOUNT_NAME",false);
		mySheet3.SetColWidth("BUYER_NAME",200);
		mySheet3.SetColWidth("BUYER",100);
		mySheet3.SetColWidth("REQ_DEPT_NAME",170);
		
	}else if(grSttsType == "B"){
		mySheet3.SetColHidden("REF_PR_NO",false);
		mySheet3.SetColWidth("BUYER_NAME",200);
		mySheet3.SetColWidth("BUYER",110);
		mySheet3.SetColWidth("REQ_DEPT_NAME",240);
	}
	
	var tot_amt = 0;
	for(var i = 1; i<=mySheet3.RowCount(); i++){
		tot_amt += mySheet3.GetCellValue(i,"GR_AMT");
	}
	
	$("#tot_amt_3").html("<%=CommonLang.get("HTITLE1469")%>"+ " : "+kepCommaNum(tot_amt)+"<%=CommonLang.get("HTITLE660")%>");// 합계금액 : x원
	
	makePageIndex_v3( mySheet3 , tabs.buyerWmGrWarehousingLis_tab3.current_page , document.searchCondition3.onepagerow.value,"buyerWmGrWarehousingLis_tab","3");	
	
}
//그리드 셀클릭 이벤트
function mySheet3_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = mySheet3.ColSaveName(mySheet3.GetSelectCol());
	tabs.buyerWmGrWarehousingLis_tab3.grbRow = Row;
	
	var user_id = $("#st_user_id_3").val();
	var buyer = mySheet3.GetCellValue(Row,"BUYER");
	var pr_no = mySheet3.GetCellValue(Row,"PR_NO");
	var pr_seq = mySheet3.GetCellValue(Row,"PR_SEQ");
	var po_no = mySheet3.GetCellValue(Row,"PO_NO");
	var po_seq = mySheet3.GetCellValue(Row,"PO_SEQ");
	var recv_flag = mySheet3.GetCellValue(Row,"RECV_FLAG");
	
	var gw_no = mySheet3.GetCellValue(Row,"GW_NO");
	
	var seller = mySheet3.GetCellValue(Row,"SELLER");
	var inv_no = mySheet3.GetCellValue(Row,"INV_NO");
	var purchaser_id = mySheet3.GetCellValue(Row,"PURCHASER_ID");
	var agent_code = mySheet3.GetCellValue(Row,"AGENT_CODE");
	var warehouse_code = mySheet3.GetCellValue(Row,"WAREHOUSE_CODE");
	var ref_pr_no = mySheet3.GetCellValue(Row,"REF_PR_NO");
	var req_dept = mySheet3.GetCellValue(Row,"REQ_DEPT");
	var ar_bill_flag = mySheet3.GetCellValue(Row,"AR_BILL_FLAG");
	
	if(column == "PR_NO"){ //PR번호 클릭 시
		if(pr_no != ""){
			if(gw_no != ""){
				openSearchPopup('/mpiv/getCommonMpIvOdrreqDetailPop_v2.do','?BUYER='+buyer+'&PR_NO='+pr_no+'&PR_SEQ='+pr_seq+'&RECV_FLAG='+recv_flag+"&gw_no="+gw_no , "1330,890,no"); 
			}else{
				openSearchPopup('/mpiv/getCommonMpIvOdrreqDetailPop_v2.do','?BUYER='+buyer+'&PR_NO='+pr_no+'&PR_SEQ='+pr_seq+'&RECV_FLAG='+recv_flag+"&gw_no="+gw_no , "1330,690,no"); 
			}
		}
	}else if(column == "PO_NO"){ //PO번호 클릭 시
		if(po_no != ""){
			openSearchPopup('/mpiv/getCommonMpIvBuyerOrderDetailInfoPop_v2.do','?buyer='+buyer+'&po_no='+po_no+'&po_seq='+po_seq+'&recv_flag='+recv_flag , "1330,800,no"); 
		}
	}else if(column == "INV_NO"){ //거래명세서번호 클릭 시
		if(inv_no != ""){
			if(inv_no.substring(0,2) == "IV") {
				openSearchPopup("/mpiv/getCommonMpIvInvoiceDetailIVPop_v2.do", "?buyer="+buyer+"&seller="+seller+"&inv_no="+inv_no+"&po_no="+po_no+"&pur_id="+purchaser_id+"&user_id="+user_id, "1330,700,no");
			}else{
				openSearchPopup("/mpiv/getCommonMpIvInvoiceDetailIKPop_v2.do", "?buyer="+buyer+"&seller="+seller+"&inv_no="+inv_no+"&po_no="+po_no+"&warehouse_code="+warehouse_code, "1330,700,no");
			}
		}
	}else if(column == "AGENT_NAME"){
		getAgentDisplayPop_v2(agent_code);
	}else if(column == "REQ_DEPT_NAME"){
		var popFromDate = $("#st_from_date_3").val();
		var popToDate = $("#st_to_date_3").val();
		popFromDate = popFromDate.replace(/[/]/gi,"");
		popToDate = popToDate.replace(/[/]/gi,"");
		
		openSearchPopup("/wmgr/getBuyerWmGrWarehousingDetailPop.do", "?buyer="+buyer+"&req_dept="+req_dept+"&fromDate="+popFromDate+"&toDate="+popToDate+"&closing_yn="+ar_bill_flag, "1200,520,no");
	}
	return;
}
</script>
<form id="searchCondition3" name="searchCondition3" method="post">
		<input type="hidden" name="s_SAVENAME" />
		<!-- 화면 내 정의 -->
		<input type="hidden" name="st_dept_name" id="st_dept_name_3" value="${sessionInfo.departmentName}">
		<input type="hidden" name="st_user_id" id="st_user_id_3" value="${sessionInfo.userId}">
		<input type="hidden" name="st_user_name" id="st_user_name_3" value="${sessionInfo.userNameLoc}">
		<input type="hidden" name="st_com_name" id="st_com_name_3" value="${sessionInfo.comNameLoc}">
		<input type="hidden" name="st_com_code" id="st_com_code_3" value="${sessionInfo.comCode}">
			
		<input type="hidden" name="st_query" id="st_query_3" value ="">
		<input type="hidden" name="st_close_date" id="st_close_date_3" value ="">
		
        <input type="hidden" name="onepagerow" id="onepagerow_3" value="<%=request.getParameter("rowCnt")%>">
        <input type="hidden" id="pageflag_3" name="pageflag" value="1" />
        <input type="hidden" id="st_all_page_3" name="st_all_page" value="N" />
        <input type="hidden" name="st_search_type" 	id="st_search_type"	value="" />
		<input type="hidden" id="st_excel_type" name="st_excel_type"	value="" />
		
		<input type="hidden" id="st_gr_stts_type" name="st_gr_stts_type"	value="<%=grSttsType%>" />
	<div id="Search3" class="SearchContent">
      <div class="Importance"><img src="/resources/imgs/Icon_Importance.png" /> <%=CommonLang.msg("MSG817")%><!--조회 기간 및 요청부서를 설정해 부서별 확정 마감 금액을 확인할 수 있습니다--></div>
      <table class="TabSearchTable" >
        <colgroup>
          <col width="120px" />
          <col width="240px" />
          <col width="120px" />
          <col width="270px" />
          <col width="120px" />
          <col width="280px" />
        </colgroup>           	
        <tr>
          <th><%=CommonLang.get("HTITLE272")%><!-- 입고일자 --></th>
          <td colspan="3">
            <div class="Buyer-datepicker-wrap" style=" width:231px; margin-right:8px">
              <div class="Buyer-date-input"  data-datepicker><input style=" " type="text" placeholder="" readonly id="st_from_date_3" name="st_from_date"/><span> </span></div>
              <span class="Buyer-dash">~</span>
              <div class="Buyer-date-input" data-datepicker><input type="text" placeholder="" readonly id="st_to_date_3" name="st_to_date"/><span></span></div>
            </div>
            <button class="But_Month" style="width:73px" onclick="javascript:kepMonth_v2('st_from_date_3','st_to_date_3','1'); return false;">1<%=CommonLang.get("HTITLE602") %><!-- 개월 --></button> 
            <button class="But_Month" style="width:73px" onclick="javascript:kepMonth_v2('st_from_date_3','st_to_date_3','2'); return false;">2<%=CommonLang.get("HTITLE602") %><!-- 개월 --></button>
            <button class="But_Month" style="width:73px" onclick="javascript:kepMonth_v2('st_from_date_3','st_to_date_3','3'); return false;">3<%=CommonLang.get("HTITLE602") %><!-- 개월 --></button>
            <button class="But_Month" style="width:73px" onclick="javascript:kepMonth_v2('st_from_date_3','st_to_date_3','12'); return false;">1<%=CommonLang.get("HTITLE424") %><!-- 년 --></button>
          </td>
          <th><%=CommonLang.get("HTITLE135") %><!-- 요청부서 --></th>
          <td><div class="TabShIconTwo" style="width:280px ">
            <input type="text"  name="st_req_dept_name" id="st_req_dept_name_3" value=""  style=" width:212px;" readonly>
            <input type="hidden" name="st_req_dept_code" id="st_req_dept_code_3" value="">
            <button class="Search" type="button" onclick="javascript:tabs.buyerWmGrWarehousingLis_tab3.doPop('department'); return false;"></button><button class="Delete" type="button" onclick="javascript:tabs.buyerWmGrWarehousingLis_tab3.doAction('departmentErase'); return false;"></button></div></td>
        </tr>
		<tr>
		  <th><%=CommonLang.get("HTITLE289") %><!-- 정산여부 --></th>
		      <td>
			      <select name="st_closing_yn" id="st_closing_yn" class="Select40" style=" float:left; width:300px; margin-right:7px">
			        <option value="ALL"><%=CommonLang.get("HTITLE29")%><!-- 전체 --></option>
					<option value="Y">Y</option>
					<option value="N">N</option>
			       </select>
		      </td>
		</tr>
      </table>
      <div class="SearchBtnBox">
        <button class="ButOutline_Medium" onclick="javascript:tabs.buyerWmGrWarehousingLis_tab3.reload(); return false;"><%=CommonLang.get("HTITLE8") %><!-- 초기화 --></button> 
        <button class="ButDarkGray_Medium" onclick="javascript:tabs.buyerWmGrWarehousingLis_tab3.search(); return false;" ><%=CommonLang.get("HTITLE7") %><!-- 조회 --></button> 
      </div>
      <div class="ArraySub mt30 mb10">
      	<div class="buttonLeft">
      	<%if(p170000001 == false){%>
       			<button class="But_ExcelDown40" onclick="tabs.buyerWmGrWarehousingLis_tab3.doAction('excelDown'); return false;"><%=CommonLang.get("HTITLE150") %><!-- 엑셀다운로드 --></button>
        <%} %>
        </div>
        <div class="buttonRight">
        
        </div>
	  </div>
      <div class="IBSheetBuyer">
      	<script type="text/javascript">
          	createIBSheet("mySheet3", "", "100%");
        </script>
      </div><!--IBSheetBuyer 끝 -->
      <div class="ArraySub mt10">
        <div class="buttonRight"><span class="allprice" id="tot_amt_3"></span></div>
	   </div>
      <div class="PagingCenter mt10" id="pageindex3"></div> 
      <div class="h50"></div>         
    </div><!--Tab1끝 -->
</form>
