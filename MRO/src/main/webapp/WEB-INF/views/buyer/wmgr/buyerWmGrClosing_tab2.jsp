<%--
**********************************************
* 메뉴 : 입고 > 마감관리 > 마감상세조회 탭
* 화면 : 마감상세조회 탭
* 기능 : 마감상세조회 탭
* 프로그램 ID : 
* 담당자 : 최찬규
* 착수일 : 2026-09-02
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.*"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.util.CommonLang"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<%
	SessionInfo _si2 = (SessionInfo) request.getSession().getAttribute("sessionInfo");
	String buyer2 = CommonUtil.nvl(_si2.getComCode());
	String userId2 = CommonUtil.nvl(_si2.getUserId());
	String p170000001_2 = CommonUtil.nvl(request.getParameter("p170000001"), "false");
%>
<script type="text/javascript">
var mySheet2 = new ibsheetObject();
var mySheet3 = new ibsheetObject();

window.tabs = window.tabs || {};
tabs.buyerWmGrClosing_tab2 = {
	//alert layer용
	but1text : "<%=CommonLang.get("HTITLE516")%>",/* 확인 */
	but1func : "javascript:closePopText2(); return false;",
	but1funcSearch : "javascript:tabs.buyerWmGrClosing_tab2.thisPopClose(); return false;",
	but1width : "120px",
	pagingMode : "N",
	current_page : "1",

	init: function(){
		if($("#st_from_date_2").val() ==  ""){
			$("#st_from_date_2").val(kepToMonthAdd("1","M"));
			$("#st_to_date_2").val(kepGetNowTimeStr('YYYYMMDD','/'));
		}
		var initsheet2 = {};
		initsheet2.Cfg = {MergeSheet:msHeaderOnly, HeaderRowHeight:35, DataRowHeight:30, Alternate:0, UseNoDataRow:1};
		initsheet2.Cols = [
			 {Align:"Center", SaveName:"sStatus",        Header:"상태",       Type:"Status", Width:50,  Edit:false, Hidden:true}
			,{Align:"Center", SaveName:"PR_NO",           Header:"주문요청번호",   Type:"Text",   Width:100,  Edit:false, Hidden:false}
			,{Align:"Center", SaveName:"PO_NO",           Header:"발주번호",   Type:"Text",  Width:100,  Edit:false, Hidden:false}
			,{Align:"Center", SaveName:"GR_NO",           Header:"입고번호",   Type:"Text",   Width:100,  Edit:false, Hidden:false}
			,{Align:"Center", SaveName:"REF_PR_NO",       Header:"관리번호",   Type:"Text",   Width:100,  Edit:false, Hidden:false}
			,{Align:"Center", SaveName:"CHANGE_DATE",     Header:"주문일",     Type:"Date",   Width:100,  Edit:false, Hidden:false,Format:"yyyy-MM-dd"}
			,{Align:"Center", SaveName:"PO_CREATE_DATE",  Header:"발주일",     Type:"Date",   Width:100,  Edit:false, Hidden:false,Format:"yyyy-MM-dd"}
			,{Align:"Center", SaveName:"GR_DATE",         Header:"입고일",     Type:"Date",   Width:100,  Edit:false, Hidden:false,Format:"yyyy-MM-dd"}
			,{Align:"Left",   SaveName:"BUYER_ITEM_NO",   Header:"품목코드",   Type:"Text",   Width:120,  Edit:false, Hidden:false}
			,{Align:"Left",   SaveName:"DESCRIPTION",     Header:"품목명",       Type:"Text",   Width:120, Edit:false, Hidden:false}
			,{Align:"Left",   SaveName:"SPECIFICATION",   Header:"규격",       Type:"Text",   Width:150, Edit:false, Hidden:false}
			,{Align:"Right",  SaveName:"UNIT_PRICE",      Header:"단가",   Type:"Float",  Width:90,  Edit:false, Hidden:false, Format:"#,###"}
			,{Align:"Right",  SaveName:"ITEM_AMT",        Header:"입고금액",   Type:"Float",  Width:100,  Edit:false, Hidden:false, Format:"#,###"}
			,{Align:"Right",  SaveName:"PO_ITEM_QTY",     Header:"발주수량",   Type:"Float",  Width:80,  Edit:false, Hidden:false}
			,{Align:"Right",  SaveName:"GR_ITEM_QTY",     Header:"입고수량",   Type:"Float",  Width:80,  Edit:false, Hidden:false}
			,{Align:"Right",  SaveName:"GR_QTY",          Header:"총입고수량", Type:"Float",  Width:80,  Edit:false, Hidden:false}
			,{Align:"Left",   SaveName:"CLOSE_STATUS",   Header:"상태",       Type:"Text",   Width:120, Edit:false, Hidden:false}
			,{Align:"Left",   SaveName:"AGENT_NAME",   Header:"협력사",       Type:"Text",   Width:120, Edit:false, Hidden:false}
			/* hidden */
			,{Align:"Center", SaveName:"BUYER",           Header:"BUYER",      Type:"Text",   Width:80,  Edit:false, Hidden:true}
			,{Align:"Center", SaveName:"AGENT",           Header:"AGENT",      Type:"Text",   Width:80,  Edit:false, Hidden:true}
			,{Align:"Center", SaveName:"BYIT_COMORG_CODE",Header:"BYIT",       Type:"Text",   Width:80,  Edit:false, Hidden:true}
			,{Align:"Center", SaveName:"CONTRACT_NO",     Header:"CONTRACT_NO",Type:"Text",   Width:80,  Edit:false, Hidden:true}
			,{Align:"Center", SaveName:"CONTRACT_SEQ",    Header:"CONTRACT_SEQ",Type:"Text",  Width:80,  Edit:false, Hidden:true}
			,{Align:"Center", SaveName:"RECV_FLAG",       Header:"RECV_FLAG",  Type:"Text",   Width:80,  Edit:false, Hidden:true}
		];
		IBS_InitSheet(mySheet2, initsheet2, this.pagingMode);
		IBS_InitSheet(mySheet3, initsheet2, this.pagingMode);
		
		mySheet2.SetHighlightAfterSort(2);
		mySheet2.SetHeaderBackColor("#f2f7ff");
		mySheet2.SetTheme("DB", "DeepBlue");
	},

	search: function(){
		if (kep_dateSearchCheck($("#st_from_date_2").val(),$("#st_to_date_2").val()) == false) return;
		var diff = kepGetDateDiff('st_from_date_2','st_to_date_2','D');
		if (eval(diff)>372){
			var text = "<%=CommonLang.msg("MSG617")%>";//1년 이내 조회만 가능합니다.
			openLayerPopText2(text,this.but1text,this.but1func,this.but1width);
			return;
		}
		$("#st_all_page_2").val("N");
		this.current_page = 1;
		kepSearch_v2(document.searchCondition2, mySheet2, "/wmgr/getBuyerWmGrClosingList_v2.do?page="+this.current_page, this.pagingMode);
		
	},
	search2: function(){
		if (kep_dateSearchCheck($("#st_from_date_2").val(),$("#st_to_date_2").val()) == false) return;
		var diff = kepGetDateDiff('st_from_date_2','st_to_date_2','D');
		if (eval(diff)>372){
			var text = "<%=CommonLang.msg("MSG617")%>";//1년 이내 조회만 가능합니다.
			openLayerPopText2(text,this.but1text,this.but1func,this.but1width);
			return;
		}
		$("#st_all_page_2").val("Y");
		kepSearch_v2(document.searchCondition2, mySheet3, "/wmgr/getBuyerWmGrClosingList_v2.do", this.pagingMode);
	},

	reload: function(){
		kepReload_v2('searchCondition2');
		kepMonth_v2('st_from_date_2','st_to_date_2','1');
		
		mySheet2.RemoveAll();
		$("#tot_amt_2").html("<%=CommonLang.get("HTITLE1469")%>"+ " : "+"0"+"<%=CommonLang.get("HTITLE660")%>");// 합계금액 : 0원
	},
	pageSearch:function(param){
		$("#st_all_page_2").val("N");
		this.current_page = param.page;
		kepSearch_v2(document.searchCondition2, mySheet2, "/wmgr/getBuyerWmGrClosingList_v2.do?page="+this.current_page, this.pagingMode);
	},
	excelDown: function(){
		if(mySheet3.RowCount() == 0){
			var text ="<%=CommonLang.msg("MSG347")%>"; //"조회된 데이터가 없습니다.";
			openLayerPopText2(text,this.but1text,this.but1func,this.but1width);
			return;
		}
		
		mySheet3.SetWaitImageVisible(true);
		
		var downRow = "|0";
		for(var i = 1; i <= mySheet3.RowCount(); i++) {
			downRow += "|"+i;
		}
		
		var downCol = "";
		for(var i=0; i<= mySheet3.LastCol(); i++){
			if(!mySheet3.GetColHidden(i) && mySheet3.ColSaveName(i) !="SELECTED" && mySheet3.GetCellProperty(1, i, "Type") != "Image"){
				downCol += "|"+i;
			}
		}
		
		if(downRow == "|0"){
			downRow = "";
		}
		var nowTime = kepGetNowTimeStr("YYYYMMDDHHMI","");
		
		var fileName = "마감상세조회_";
		
		var param = {FileName:fileName+nowTime, SheetName:fileName, DownRows:downRow, DownCols:downCol, DownHeader:1, DownSum:1, Merge:0, SheetDesign:0, CheckBoxOnValue:'Y', CheckBoxOffValue:'N', DownCombo:'TEXT', OnlyHeaderMerge:1};
		mySheet3.Down2Excel(param);
	}

};
</script>
<form id="searchCondition2" name="searchCondition2" method="post">
		<input type="hidden" name="s_SAVENAME" />
		<!-- 화면 내 정의 -->
		<input type="hidden" name="st_com_code" id="st_com_code" value="${sessionInfo.comCode}">
		<input type="hidden" name="st_user_id" id="st_user_id" value="${sessionInfo.userId}">
        <input type="hidden" name="onepagerow" id="onepagerow_2" value="<%=request.getParameter("rowCnt")%>">
        <input type="hidden" id="pageflag_2" name="pageflag" value="1" />
        <input type="hidden" id="st_all_page_2" name="st_all_page" value="N" />
<div id="Search2" class="SearchContent">
	<div class="Importance"><img src="/resources/imgs/Icon_Importance.png" /> 발주번호 단위로 확정 내역을 조회할 수 있습니다.</div>
	<table class="TabSearchTable">
		<colgroup>
          <col width="120px" />
          <col width="240px" />
          <col width="120px" />
          <col width="270px" />
          <col width="120px" />
          <col width="280px" />
        </colgroup>           	
        <tr>
          <th><%=CommonLang.get("HTITLE423")%><!-- 기간 --></th>
          <td colspan="3">
            <select name="st_check_date" id="st_check_date_2" class="Select40" style=" float:left; width:132px; margin-right:7px">
              <option value="GR"><%=CommonLang.get("HTITLE283") %><!-- 입고일 --></option>
              <option value="PR"><%=CommonLang.get("HTITLE1235") %><!-- 주문요청일 --></option>
            </select>               
            <div class="Buyer-datepicker-wrap" style=" width:231px; margin-right:8px">
              <div class="Buyer-date-input"  data-datepicker><input style=" " type="text" placeholder="" readonly id="st_from_date_2" name="st_from_date"/><span> </span></div>
              <span class="Buyer-dash">~</span>
              <div class="Buyer-date-input" data-datepicker><input type="text" placeholder="" readonly id="st_to_date_2" name="st_to_date"/><span></span></div>
            </div>
            <button class="But_Month" style="width:73px" onclick="javascript:kepMonth_v2('st_from_date_2','st_to_date_2','1'); return false;">1<%=CommonLang.get("HTITLE602") %><!-- 개월 --></button> 
            <button class="But_Month" style="width:73px" onclick="javascript:kepMonth_v2('st_from_date_2','st_to_date_2','2'); return false;">2<%=CommonLang.get("HTITLE602") %><!-- 개월 --></button>
            <button class="But_Month" style="width:73px" onclick="javascript:kepMonth_v2('st_from_date_2','st_to_date_2','3'); return false;">3<%=CommonLang.get("HTITLE602") %><!-- 개월 --></button>
            <button class="But_Month" style="width:73px" onclick="javascript:kepMonth_v2('st_from_date_2','st_to_date_2','12'); return false;">1<%=CommonLang.get("HTITLE424") %><!-- 년 --></button>
          </td>
          <th><%=CommonLang.get("HTITLE12")%><!-- 품목코드 --></th>
		  <td>
          	<input type="text"  class="input40" name="st_buyer_item_no" id="st_buyer_item_no_2" value=""  style=" width:278px;" onKeyDown="kepEnter_v3('buyerWmGrClosing_tab2')">
        </tr>
		<tr>
			<th>상태</th>
			<td>
            <select name="st_status"  id="st_status_2" class="Select40" style="width:300px;">
            	<option value=""><%=CommonLang.get("HTITLE29")%><!-- 전체 --></option>
				<option value="마감완료"><%=CommonLang.get("HTITLE284")%><!-- 마감완료 --></option>
				<option value="국세청전송"><%=CommonLang.get("HTITLE285")%><!-- 국세청전송 --></option>
            </select>  
          </td>
		</tr>
	</table>
	<div class="SearchBtnBox">
		<button class="ButOutline_Medium" onclick="tabs.buyerWmGrClosing_tab2.reload(); return false;">초기화</button>
		<button class="ButDarkGray_Medium" onclick="tabs.buyerWmGrClosing_tab2.search(); return false;">조회</button>
	</div>
	<div class="ArraySub mt30 mb10">
		<div class="buttonLeft">
		<%if(p170000001_2.equals("false")){%>
			<button class="But_ExcelDown40" onclick="tabs.buyerWmGrClosing_tab2.search2(); return false;">엑셀 다운로드</button>
		<%} %>
		</div>
		<div class="buttonRight"></div>
	</div>
	<div class="IBSheetBuyer">
		<script type="text/javascript">createIBSheet("mySheet2", "100%", "100%");</script>
	</div>
	<div class="IBSheetBuyer" style="display: none;">
		<script type="text/javascript">createIBSheet("mySheet3", "100%", "100%");</script>
	</div>
	<div class="ArraySub mt10">
        <div class="buttonRight"><span class="allprice" id="tot_amt_2"></span></div>
	   </div>
	<div class="PagingCenter mt10" id="pageindex2"></div> 
	<div class="h50"></div>
</div>
</form>
<script type="text/javascript">
function mySheet2_OnSearchEnd(code, msg, stCode, stMsg) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}
	
	var tot_amt = 0;
	var startRow = mySheet2.HeaderRows();
	var endRow = mySheet2.LastRow();
	
	for(var i = startRow; i<=endRow; i++){
		//조회된 데이터 행(status:R)이 아닌 경우 제외(필터행,합계행 등)
		if(mySheet2.GetCellValue(i,"sStatus") != "R") continue;
		
		//필터링 등으로 화면에서 숨겨진 행 제외
		if(mySheet2.GetRowHidden(i)) continue;
		
		//정상데이터 금액 합산(Number 로 NaN방지)
		tot_amt += Number(mySheet2.GetCellValue(i,"ITEM_AMT")) || 0;
	}
	
	$("#tot_amt_2").html("<%=CommonLang.get("HTITLE1469")%>"+ " : "+kepCommaNum(tot_amt)+"<%=CommonLang.get("HTITLE660")%>");// 합계금액 : 원
	
	makePageIndex_v3( mySheet2 , tabs.buyerWmGrClosing_tab2.current_page , document.searchCondition2.onepagerow.value,"buyerWmGrClosing_tab","2");
}

function mySheet3_OnSearchEnd(code, msg, stCode, stMsg){
	loader_obj("N");
	if(!checkedSession(stCode)){return;}
	
	tabs.buyerWmGrClosing_tab2.excelDown();
}

</script>
