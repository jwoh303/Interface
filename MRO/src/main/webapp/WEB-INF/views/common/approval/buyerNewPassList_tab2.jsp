<%--
**********************************************
* 메뉴 : 결재관리
* 화면 : 결재대기 탭
* 기능 : 결재대기 탭
* 프로그램 ID : BU0701001
* 담당자 : 최찬규  
* 착수일 : 2026-02-02
**********************************************
--%> 
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.*"%> 
<%@ page import="java.sql.Timestamp"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.util.CommonLang"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>

<script type="text/javascript">
var mySheet2 = new ibsheetObject();

window.tabs = window.tabs || {};
tabs.buyerNewPass_tab2 = {
	//alert layer용
	but1text : "<%=CommonLang.get("HTITLE516")%>",/* 확인 */
	but1func : "javascript:closePopText2(); return false;",
	but1funcSearch : "javascript:tabs.buyerNewPass_tab2.thisPopClose(); return false;",
	but1width : "120px",
	pagingMode : "N",
	current_page: "1",
		
	init:function(){
// 		if($("#st_from_date_2").val() ==  ""){
// 			$("#st_from_date_2").val(kepToMonthAdd("1","M"));
// 			$("#st_to_date_2").val(kepGetNowTimeStr('YYYYMMDD','/'));
// 		}
		
		var initsheet2 = {};
		initsheet2.Cfg = {MergeSheet:msHeaderOnly,     HeaderRowHeight: 50, DataRowHeight: 30,    Alternate : 0,UseNoDataRow:1};
		initsheet2.Cols = [
				 { Align:"Center",	SaveName:"sStatus",				Header:"<%=CommonLang.get("HTITLE255")%>",				Type:"Status",		Width:60,	Edit:false,	EditLen:0,		Hidden:true} /*상태*/
				,{ Align:"Center",	SaveName:"SELECTED",			Header:"",					Type:"DummyCheck",	Width:40,	Edit:true,	EditLen:100,	Hidden:false}
				,{ Align:"Center",	SaveName:"NO",					Header:"<%=CommonLang.get("HTITLE44")%>",				Type:"Text",		Width:60,	Edit:false,	EditLen:100,	Hidden:false} /*번호*/
				,{ Align:"Center",	SaveName:"COMPANY_NAME",		Header:"<%=CommonLang.get("HTITLE604")%>",				Type:"Text",		Width:120,	Edit:false,	EditLen:100,	Hidden:true} /*고객사*/
				,{ Align:"Center",	SaveName:"EXTIF_TP_TEXT",		Header:"<%=CommonLang.get("HTITLE770")%>",				Type:"Text",		Width:120,	Edit:false,	EditLen:100,	Hidden:false} /*결재대상*/
				,{ Align:"Center",	SaveName:"EXTIF_TP",			Header:"<%=CommonLang.get("HTITLE770")%>",				Type:"Text",		Width:120,	Edit:false,	EditLen:100,	Hidden:true} /*결재대상*/
				
				,{ Align:"Center",	SaveName:"GUBUN",				Header:"<%=CommonLang.get("HTITLE1040")%>",				Type:"Text",		Width:100,	Edit:false,	EditLen:100,	Hidden:false} /*결재유형*/
				,{ Align:"Center",	SaveName:"PASS_STATUS",			Header:"<%=CommonLang.get("HTITLE1041")%>",				Type:"Text",		Width:120,	Edit:false,	EditLen:100,	Hidden:false, FontColor:"#3a72c7", Cursor:"Pointer"} /*결재상태*/
				,{ Align:"Left",	SaveName:"DOCU_TITLE",			Header:"<%=CommonLang.get("HTITLE304")%>",		Type:"Text",	Width:370,	Edit:false,	EditLen:100,	Hidden:false, FontColor:"#3a72c7", Cursor:"Pointer"} /*제목*/
				,{ Align:"Right",	SaveName:"PRICE",				Header:"<%=CommonLang.get("HTITLE1093")%>",				Type:"Float",		Width:90,	Edit:false,	EditLen:100,	Hidden:false, Format:"${priceFormat}"}/*결재금액*/
				,{ Align:"Center",	SaveName:"USER_NM",				Header:"<%=CommonLang.get("HTITLE1042")%>",				Type:"Text",		Width:105,	Edit:false,	EditLen:100,	Hidden:false}/*상신자*/				,{ Align:"Center",	SaveName:"START_DATE",			Header:"<%=CommonLang.get("HTITLE1043")%>",				Type:"Text",		Width:150,	Edit:false,	EditLen:100,	Hidden:false} /*상신일*/
				,{ Align:"Center",	SaveName:"NEXT_USER_NM",		Header:"<%=CommonLang.get("HTITLE1044")%>",		Type:"Text",		Width:125,	Edit:false,	EditLen:100,	Hidden:false} /*다음 결재(합의)자*/
				,{ Align:"Center",	SaveName:"NEXT_USER_ID",		Header:"NEXT_USER_ID",		Type:"Text",		Width:125,	Edit:false,	EditLen:100,	Hidden:true}
				
				,{ Align:"Center",	SaveName:"DOCU_NO",				Header:"DOCU_NO",				Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
				,{ Align:"Center",	SaveName:"PASS_TP",				Header:"PASS_TP",				Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
				,{ Align:"Center",	SaveName:"COMPANY",				Header:"COMPANY",				Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
				,{ Align:"Center",	SaveName:"DOC_TYPE",			Header:"DOC_TYPE",				Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
		];
		
		IBS_InitSheet(mySheet2, initsheet2, this.pagingMode);
		mySheet2.SetHighlightAfterSort(2);
		
		mySheet2.SetHeaderBackColor("#f2f7ff");
		mySheet2.SetTheme("DB", "DeepBlue");
		
	},
	
	search:function(){
		if (kep_dateSearchCheck($("#st_from_date_2").val(),$("#st_to_date_2").val()) == false) return;
		var diff = kepGetDateDiff('st_from_date_2','st_to_date_2','D');
		if (eval(diff)>372){
			var text = "<%=CommonLang.msg("MSG617")%>"; //1년 이내 조회만 가능합니다
			openLayerPopText2(text,this.but1text,this.but1func,this.but1width);
			return;
		}
		kepSearch_v2(document.searchCondition2, mySheet2, "/buyerNewPassList_v2.do?page="+this.current_page, this.pagingMode);
	},
	reload:function(){
		kepReload_v2('searchCondition2');
		kepMonth_v2('st_from_date_2','st_to_date_2','1');
		mySheet2.RemoveAll();
	},
	doPop:function(str,value1,value2,value3,value4){
		switch (str) {
		case "myPage":
			openSearchPopup('/common/approval/getBuyerCommonMyPagePop.do','?COMPANY='+value1+'&DOCU_NO='+value2+'&PASS_TP='+value3+'&tab_id=buyerNewPass_tab2','1620,750,no');
			
//	 		var src = '/common/approval/getBuyerCommonMyPagePop.do?COMPANY='+value1+'&DOCU_NO='+value2+'&PASS_TP='+value3+'&tab_id=buyerNewPass_tab2';
//	 		openLayerPop(src,"1620px","750px");
			break;

		default:
			break;
		}
	},
	doAction:function(str){
		switch (str) {
		case "allprocess1":	 //일괄결재
			this.allprocess(1);
			break; 
		
		case "allprocess3":	 //일괄반려
			this.allprocess(3);
			break; 
		
		}
	},
	allprocess:function(value){
		var checkRows = mySheet2.FindCheckedRow("SELECTED");
		var arrRow = checkRows.split("|");
		
		if(checkRows == ""){
			//하나 이상의 대상이 선택되어야 합니다.
			var text = "<%=CommonLang.msg("MSG259") %>";
			openLayerPopText2(text,this.but1text,this.but1func,this.but1width);
			return;
		}
		
		for(var idx=0; idx<arrRow.length; idx++){
			var pass_status = mySheet2.GetCellValue(arrRow[idx],"PASS_STATUS");
			if(pass_status != "결재대기"){
				//선택하신 결재건은 현재 결재자가 아니므로 처리 불가능합니다
	    		var text = "<%=CommonLang.msg("MSG387") %>";
	    		openLayerPopText2(text,this.but1text,this.but1func,this.but1width);
	    		return;
			}
		}
	    
		 $("#PASS_KN").val(value);  
		// 사유입력
// 	    openSearchPopup('/mppo/showBuyerMpPoApprovalReasonPop.do','?openYn=Y&st_pass_kn='+value+'&tab_id=buyerNewPass_tab2'+'&total_cnt='+arrRow.length , '500,340,no');
		var src = '/mppo/showBuyerMpPoApprovalReasonPop.do?openYn=Y&st_pass_kn='+value+'&tab_id=buyerNewPass_tab2'+'&total_cnt='+arrRow.length;
		openLayerPop(src,"500px","340px");
	},
	setReason:function(value){
		$("#PASS_ADD").val(value); //  사유 
		 
	     this.allbizprocess();
	},
	allbizprocess:function(){
		var checkRows = mySheet2.FindCheckedRow("SELECTED");
		var arrRow = checkRows.split("|");
		
		if(checkRows == ""){
			//하나 이상의 대상이 선택되어야 합니다.
			var text = "<%=CommonLang.msg("MSG259") %>";
			openLayerPopText2(text,this.but1text,this.but1func,this.but1width);
			return;
		}
		
		var query = "";
		for(var idx=0; idx<arrRow.length; idx++){
			var company = mySheet2.GetCellValue(arrRow[idx],"COMPANY");
			var docu_no = mySheet2.GetCellValue(arrRow[idx],"DOCU_NO");
			query += company+"@@"+docu_no+"&&";
		}
	    
	    $("#APPROVAL_TEXT").val(query); //  사유
	    kepAjaxFormCallTab("/common/approval/AllCommonApproval.do","processForm","ALLSAVE","buyerNewPass_tab2"); 
	},
	kepAjaxSuccess:function(pMethod , response){
		if(pMethod == "ALLSAVE"){
			var msg = "";
		    if ($("#PASS_KN").val() == 1 ){
		    	msg = "<%=CommonLang.get("HTITLE310") %>";		//결재
		    }else{
		    	msg = "<%=CommonLang.get("HTITLE238") %>";		//반려
		    }
		    var text = "<%=CommonLang.msg("MSG260") %> "+msg+" <%=CommonLang.msg("MSG391") %>"; //정상적으로 처리되었습니다. 
			openLayerPopText2(text,this.but1text,this.but1funcSearch,this.but1width);
		}
	},
	kepAjaxError:function(pMethod , response){
		//오류발생하였습니다.다시 한 번 시도해 주시기 바랍니다.
		 var text = "<%=CommonLang.msg("MSG163") %>  ";  
		 openLayerPopText2(text,this.but1text,this.but1func,this.but1width);
	},
	thisPopClose:function(){
		closePopText2();
		this.search();
	},
	pageSearch:function(param){
		this.current_page = param.page;
		kepSearch_v2(document.searchCondition2, mySheet2, "/buyerNewPassList_v2.do?page="+this.current_page, this.pagingMode);
	}
};
//조회 후처리
function mySheet2_OnSearchEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}	

	var getMultiApprFlag = '<%=request.getParameter("getMultiApprFlag")%>';
	if(getMultiApprFlag == "Y"){
		mySheet2.SetColHidden("COMPANY_NAME",false);
		mySheet2.SetColWidth("DOCU_TITLE",260);
		$("#buyerListMulti_2").show();
	}
	
	var sTitle = "[" + "<%=CommonLang.get("HTITLE842")%>" + "]"; //선입고
	var fTitle = "[" + "<%=CommonLang.get("HTITLE840")%>" + "]"; //긴급발주
	for(var i = 1; i<=mySheet2.RowCount(); i++){
		var doc_type = mySheet2.GetCellValue(i,"DOC_TYPE");
		if(doc_type == "S"){
			mySheet2.SetCellValue(i,"DOCU_TITLE",sTitle+mySheet2.GetCellValue(i,"DOCU_TITLE"));
		}else if(doc_type == "F"){
			mySheet2.SetCellValue(i,"DOCU_TITLE",fTitle+mySheet2.GetCellValue(i,"DOCU_TITLE"));
		}
	}
	
	makePageIndex_v3( mySheet2 , tabs.buyerNewPass_tab2.current_page , document.searchCondition2.onepagerow.value,"buyerNewPass_tab","2");	
	
	if (msg != "") {
// 		alert(msg);
		var text = msg;
		openLayerPopText2(text,tabs.buyerNewPass_tab2.but1text,tabs.buyerNewPass_tab2.but1func,tabs.buyerNewPass_tab2.but1width);
	}
}
//그리드 셀클릭 이벤트
function mySheet2_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = mySheet2.ColSaveName(mySheet2.GetSelectCol());
	
	var company = mySheet2.GetCellValue(Row,"COMPANY");
	var docu_no = mySheet2.GetCellValue(Row,"DOCU_NO");
	var pass_tp = mySheet2.GetCellValue(Row,"PASS_TP");
	var title = mySheet2.GetCellValue(Row,"DOCU_TITLE");
	var type_text = mySheet2.GetCellValue(Row,"EXTIF_TP_TEXT");
	var type = mySheet2.GetCellValue(Row,"EXTIF_TP");
	
	if(column == "DOCU_TITLE"){ // 제목 클릭 시
		if(type == "PR" || type == "PX"){
			openSearchPopup('/common/approval/getBuyerCommonMyPagePop.do','?COMPANY='+company+'&DOCU_NO='+docu_no+'&PASS_TP='+pass_tp+'&tab_id=buyerNewPass_tab2','1640,820,no');
		}else{
			openSearchPopup('/common/approval/getBuyerCommonMyPagePop.do','?COMPANY='+company+'&DOCU_NO='+docu_no+'&PASS_TP='+pass_tp+'&tab_id=buyerNewPass_tab2','1380,820,no');
		}
				
// 		var src = '/common/approval/getBuyerCommonMyPagePop.do?COMPANY='+company+'&DOCU_NO='+docu_no+'&PASS_TP='+pass_tp+'&tab_id=buyerNewPass_tab2';
// 		openLayerPop(src,"1620px","750px");
	}else if(column == "PASS_STATUS"){ //결재상태 클릭 시
		openSearchPopup('/common/popup/approval/buyerCommonPassStatusPop.do','?COMPANY='+company+'&DOCU_NO='+docu_no+'&title='+title+'&type='+type_text ,'1100,550,no');
		
// 		var src = '/common/popup/approval/buyerCommonPassStatusPop.do?COMPANY='+company+'&DOCU_NO='+docu_no+'&title='+title+'&type='+type;
// 		openLayerPop(src,"1100px","550px");
	}
	return;
}
</script>
<form id="searchCondition2" name="searchCondition2" method="post">
		<input type="hidden" name="s_SAVENAME" />
		<input type="hidden" name="st_com_code" id="st_com_code_2" value="${sessionInfo.comCode}">
		<input type="hidden" id="BUYER_2"  name="BUYER" value="${sessionInfo.comCode}">
        <input type="hidden" id="USERID_2"  name="USERID" value="${sessionInfo.userId}">
        <input type="hidden" name="onepagerow" id="onepagerow_2" value="<%=request.getParameter("rowCnt")%>">
        <input type="hidden" id="pageflag_2" name="pageflag" value="1" />
	<div id="Search2" class="SearchContent">
      <div class="Importance"><img src="/resources/imgs/Icon_Importance.png" /> <%=CommonLang.msg("MSG963")%><!--결재할 대상을 확인하고, 결재 또는 반려 처리를 할 수 있습니다..--></div>
      <table class="TabSearchTable" >
        <colgroup>
          <col width="90px" />
          <col width="350px" />
          <col width="90px" />
          <col width="350px" />
          <col width="90px" />
          <col width="310px" />
        </colgroup>           	
        <tr>
          <th><%=CommonLang.get("HTITLE1043")%><!--상신일--></th>
          <td colspan="3">
            <div class="Buyer-datepicker-wrap" style=" width:231px; margin-right:8px">
              <div class="Buyer-date-input"  data-datepicker><input type="text" placeholder="" id="st_from_date_2" name="st_from_date" readonly /><span></span></div>
              <span class="Buyer-dash">~</span>
              <div class="Buyer-date-input" data-datepicker><input type="text" placeholder="" id="st_to_date_2" name="st_to_date" readonly /><span></span></div>
            </div>
            <button class="But_Month" style="width:73px" onclick="javascript:kepMonth_v2('st_from_date_2','st_to_date_2','1'); return false;">1<%=CommonLang.get("HTITLE602") %><!-- 개월 --></button> 
            <button class="But_Month" style="width:73px" onclick="javascript:kepMonth_v2('st_from_date_2','st_to_date_2','2'); return false;">2<%=CommonLang.get("HTITLE602") %><!-- 개월 --></button>
            <button class="But_Month" style="width:73px" onclick="javascript:kepMonth_v2('st_from_date_2','st_to_date_2','3'); return false;">3<%=CommonLang.get("HTITLE602") %><!-- 개월 --></button>
            <button class="But_Month" style="width:73px" onclick="javascript:kepMonth_v2('st_from_date_2','st_to_date_2','12'); return false;">1<%=CommonLang.get("HTITLE424") %><!-- 년 --></button>
          </td>
          <th><%=CommonLang.get("HTITLE1041")%><!--결재상태--></th>
          <td>
            <select name="st_status" class="Select40" style="width:310px;" disabled="disabled">
              <option value = "결재대기" selected="selected"><%=CommonLang.get("HTITLE1046")%><!--결재대기--></option>
            </select>  
          </td>                     
        </tr>
		<tr>
          <th><%=CommonLang.get("HTITLE1040")%><!--결재유형--></th>
          <td><select name="st_status1" class="Select40" style="width:310px">
              <option value = ""><%=CommonLang.get("HTITLE29") %><!-- 전체 --></option>
              <option value = "0"><%=CommonLang.get("HTITLE1047")%><!--상신--></option>
              <option value = "1"><%=CommonLang.get("HTITLE310") %><!-- 결재 --></option>
              <option value = "2"><%=CommonLang.get("HTITLE311") %><!-- 참조 --></option>
              <option value = "3"><%=CommonLang.get("HTITLE792") %><!-- 합의 --></option>
              </select>
           </td>
          <th><%=CommonLang.get("HTITLE770") %><!-- 결재대상 --></th>
          <td><select name="st_gubun" class="Select40" style="width:310px">
              <% 
				Map<String, String> _map = new HashMap<String, String>();
	            _map.put("TEXT5","B");
	          %>
			<%= CommonUtil.getCodeComboQueryIdList("common.getApprCodeList","ALL",_map,"") %>
              </select>
          </td>
          <th><%=CommonLang.get("HTITLE552") %><!-- 검색어 --></th>
          <td>
            <select name="st_keyword_type" class="Select40" style=" float:left;width:100px; margin-right:5px">
              <option value="ALL"><%=CommonLang.get("HTITLE29") %><!-- 전체 --></option>
              <option value="NAME"><%=CommonLang.get("HTITLE29") %><!-- 이름 --></option>
              <option value="ID"><%=CommonLang.get("HTITLE324") %><!-- 아이디 --></option>
              <option value="SUBJECT"><%=CommonLang.get("HTITLE304") %><!-- 제목 --></option>
              <option value="CONT"><%=CommonLang.get("HTITLE441") %><!-- 내용 --></option>
            </select>  
            <input class="input40" style="width:183px" name="st_keyword" id="st_keyword_2" type="text" onKeyDown="kepEnter_v3('buyerNewPass_tab2')"/>
          </td>
		</tr>
		<tr id="buyerListMulti_2" style="display: none;">
          <th><%=CommonLang.get("HTITLE604") %><!-- 고객사 --></th>
          <td><select name="st_buyer_list" class="Select40" style="width:310px">
          <%
           	_map.put("CODE2",request.getParameter("user_id")); // 로그인 ID로 세팅된 고객사 목록(ICOMCOD3.TYPE=M-APPR)
           %>
           <%=CommonUtil.getCodeComboQueryIdList("common.getMultiApprComNameList","ALL",_map,"")%>
              </select>
           </td>
        </tr>           
      </table>
      <div class="SearchBtnBox">
        <button class="ButOutline_Medium" onclick="javascript:tabs.buyerNewPass_tab2.reload(); return false;"><%=CommonLang.get("HTITLE8") %><!-- 초기화 --></button> 
        <button class="ButDarkGray_Medium" onclick="javascript:tabs.buyerNewPass_tab2.search(); return false;" ><%=CommonLang.get("HTITLE7") %><!-- 조회 --></button> 
      </div>
      <div class="ArraySub mt30 mb10">
        <div class="buttonRight">
          <button class="ButM_Outline" onclick="javascript:tabs.buyerNewPass_tab2.doAction('allprocess3'); return false;"><%=CommonLang.get("HTITLE238") %><!-- 반려 --></button>
         <button class="ButMPrimary" onclick="javascript:tabs.buyerNewPass_tab2.doAction('allprocess1'); return false;"><%=CommonLang.get("HTITLE310") %><!-- 결재 --></button> 
        </div>
	  </div>
      <div class="IBSheetBuyer">
      	<script type="text/javascript">
          	createIBSheet("mySheet2", "", "100%");
        </script>
      </div><!--IBSheetBuyer 끝 -->
      <div class="PagingCenter mt10" id="pageindex2"></div>  
      <div class="h50"></div>         
    </div><!--Tab2끝 -->
</form>
<form name="processForm" id="processForm">
<input type=hidden name="PASS_KN" id="PASS_KN">  
<input type=hidden name="PASS_ADD" id="PASS_ADD">  
<input type=hidden name="DOCU_CONT" id="DOCU_CONT">  
<input type=hidden name="APPROVAL_TEXT" id="APPROVAL_TEXT">  
</form> 