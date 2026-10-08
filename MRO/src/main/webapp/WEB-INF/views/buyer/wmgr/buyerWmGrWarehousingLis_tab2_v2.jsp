<%--
**********************************************
* 메뉴 : 입고관리
* 화면 : 입고대상 탭
* 기능 : 입고대상 탭
* 프로그램 ID : BU0402003
* 담당자 : 최찬규
* 착수일 : 2026-09-30
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
Map<String,String> _sLogicMap = (Map<String,String>)request.getAttribute("sLogicInfo"); // 특수로직 조회된 결과

String rowCntYn 	= "";	// 그리드 행개수
String rowCnt 		= request.getParameter("rowCnt");	// 그리드 default 개수
String cardYn 		= "";	// 신용카드 사용 고객사 여부
String deptFix 		= "";	// 요청부서 
String prUserFix 	= "";	// 요청자만 selectbox
String poUserFix 	= "";	// 발주자만 selectbox

String extrReportBtn= "";	// 추가리포트버튼명	
String extrReportId = "";	// 추가리포트아이디
String clsdDnldYn 	= "";	// 마감다운로드버튼 여부

// 최초 화면띄울때만 db조회, 이후 조회시에는 input 값으로 가지고다님.
if(_sLogicMap != null){
	rowCntYn 	= CommonUtil.nvl(_sLogicMap.get("ROW_CNT_YN"));
	cardYn 		= CommonUtil.nvl(_sLogicMap.get("CARD_YN"));
	deptFix 	= CommonUtil.nvl(_sLogicMap.get("DEPT_FIX"));
	prUserFix 	= CommonUtil.nvl(_sLogicMap.get("PR_USER_FIX")); 
	poUserFix 	= CommonUtil.nvl(_sLogicMap.get("PO_USER_FIX"));
} else {
	
	rowCntYn 	= CommonUtil.nvl((String)request.getParameter("st_row_cnt_yn"));
	cardYn 		= CommonUtil.nvl((String)request.getParameter("st_card_yn"));
	deptFix 	= CommonUtil.nvl((String)request.getParameter("st_dept_fix"));
	prUserFix 	= CommonUtil.nvl((String)request.getParameter("st_pr_user_fix")); 
	poUserFix 	= CommonUtil.nvl((String)request.getParameter("st_po_user_fix"));
}

@SuppressWarnings (value="unchecked")
List<Map<String,String>> _gridList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된 결과

String st_legacy_po_no = CommonUtil.nvl((String)request.getParameter("st_legacy_po_no"),"");  
String st_ref_pr_no = CommonUtil.nvl((String)request.getParameter("st_ref_pr_no"),"");  
String st_buyer_item_no = CommonUtil.nvl((String)request.getParameter("st_buyer_item_no"),"");

SessionInfo sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");

String sessionComCode = sessionInfo.getComCode();
String sessionUserType = sessionInfo.getUserType();
String sessionDeptCode = sessionInfo.getDepartment();
String sessionDeptName = sessionInfo.getDepartmentName();
String SessionUserId            = sessionInfo.getUserId();
String SessionUserNameLoc = sessionInfo.getUserNameLoc();
//예산계정 사용유무 추가.
String sessionBudget_flag =  CommonUtil.nvl((String)sessionInfo.getBudgetFlag());

String dept_type = CommonUtil.nvl((String)request.getParameter("st_dept_type"), "");
String req_dept_code = CommonUtil.nvl((String)request.getParameter("st_req_dept_code"), "");
String req_dept_name = CommonUtil.nvl((String)request.getParameter("st_req_dept_name"), "");
String po_user_id = "";
String po_user_name = "";
String acnt_cd = CommonUtil.nvl((String)request.getParameter("st_acnt_cd"), "");
String acnt_nm = CommonUtil.nvl((String)request.getParameter("st_acnt_nm"), "");

if(dept_type.equals("")){
	dept_type = "PR";
}

if(deptFix.equals("Y")){
	req_dept_code = sessionDeptCode;
	req_dept_name = sessionDeptName;
}
if(prUserFix.equals("Y") || poUserFix.equals("Y")){
	po_user_id = SessionUserId;
	po_user_name = SessionUserNameLoc;
}

String p060000029_type = CommonUtil.getSpecialCheckReturn(request.getParameter("buyer"),"P06-0000029","COL01_DATA");
String p060000029_form = CommonUtil.getSpecialCheckReturn(request.getParameter("buyer"),"P06-0000029","COL03_DATA");
String user_type = CommonUtil.nvl((String)request.getParameter("st_user_type"),"");
if(user_type.equals("")){
   user_type = "PO";
}
/*
P06-0000080 
장바구니 필드추가 제어, 엑셀 다운로드시 컬럼 조절 
-TYPE1: 윈체  수량길이 필드 추가
-TYPE2: 대덕전자 
-TYPE3: 넥센 택배사정보, 배송증빙 추가
-TYPE11: 한컴라이프케어 관리번호 (회계단위^원각^코스트센터^계정^프로젝트코드) 추가
*/
String p060000080 =  CommonUtil.getSpecialCheckReturn(request.getParameter("buyer"),"P06-0000080","COL01_DATA");
//그룹기준 사업장 조회
boolean getCodeTGCM = CommonUtil.getCode3CheckReturn("TGCM", SessionUserId, request.getParameter("buyer"));
String st_com_code = CommonUtil.nvl((String) request.getParameter("st_com_code"),"");  // 계열사정보
String group_mng_flag = "N";

if(getCodeTGCM == true){
	   group_mng_flag = "Y"; 
}

// 고객사 입고관리 화면 내 입고등록, 입고취소 버튼 숨김
boolean p070000024 = CommonUtil.getSpecialCheckReturn(request.getParameter("buyer"),"P07-0000024");

//엑셀다운로드 기능 통제
boolean p170000001 = CommonUtil.getSpecialCheckReturn(request.getParameter("buyer"),"P17-0000001");

//롯데칠성 입고 결재 상신 기능
boolean p110000005 = CommonUtil.getSpecialCheckReturn(request.getParameter("buyer"),"P11-0000005");

//배송완료 체크 불가 고객사리스트
boolean p070000030 = CommonUtil.getSpecialCheckReturn(request.getParameter("buyer"),"P07-0000030");

//솔브레인 고객사인지 체크(SRM 발주 입고 등록 제어를 위해)
boolean st_solb_buyer = CommonUtil.getCodeCheckReturn("SOLB01",request.getParameter("buyer"));



SimpleDateFormat sdf = new SimpleDateFormat("dd");
Date now = new Date();
int int_dd = Integer.parseInt(sdf.format(now)); //현재 일

// 주문통제 특수로직
	Map<String, String> p060000101 = CommonUtil.getSpecialCheckReturnMap(request.getParameter("buyer"),"P06-0000101");
	
	String grRole = "";
 
	// 입고통제 from/ too/ 메세지
	// 입고통제 기능 P06-0000109 과 P06-0000139 차이점
	// P06-0000109는 주문통제 일자와 무관하게 입고 통제만 관리한다.  P06-0000139은 주문통제(P06-0000101)와 연결되어 주문통제의 날짜를 공유한다. 
	Map<String, String> p060000139 = CommonUtil.getSpecialCheckReturnMap(request.getParameter("buyer"),"P06-0000139");
  String p060000101_from= ""; 
  String p060000101_to = "";    
  
  if(p060000139 != null){
 	 p060000101_from = CommonUtil.nvl(p060000101.get("COL01_DATA"),p060000101_from); // 입고통제 from
 	 p060000101_to = CommonUtil.nvl(p060000101.get("COL02_DATA"),p060000101_to);       // 입고통제 to
 	 
 	  int int_day = Integer.parseInt(sdf.format(now)); //현재 일
      int int_from_day = Integer.parseInt(p060000101_from);//통제 시작일
      int int_to_day = Integer.parseInt(p060000101_to);//통제 종료일
 	 
 	 //통제 조건
      if(int_from_day <= int_day && int_day <= int_to_day){         	
     	 grRole = "-"; // 입고(취소) 불가
      } else {
     	 grRole = "+";
      }
  }
  
	//SLOGIC-BEGIN(P06-0000072) - 장바구니 중복 등록 허용 고객사
	boolean p060000072 = CommonUtil.getSpecialCheckReturn(request.getParameter("buyer"),"P06-0000072");
	
	String dup_add_posb_yn = "N";
	
	if(p060000072 == true){
		dup_add_posb_yn = "Y";
    }
	
	//SLOGIC-BEGIN(P06-0000036)
	String defaultUrl = "/mpso/getBuyerMpSoCartList.do?upperId=b00000000000&leftMenu=N";
	String p060000036 = CommonUtil.getSpecialCheckReturn(request.getParameter("buyer"),"P06-0000036","COL02_DATA", request); // 권한별URL
	if (p060000036 == null){
		p060000036 = defaultUrl;
	}else if ("".equals(p060000036)){
		p060000036 = defaultUrl;
	}
	
	boolean bgr00002 = CommonUtil.getSpecialCheckReturn(request.getParameter("buyer"),"BGR00002");
	
%>
<style>
	#calendarContainer{
		z-index:99999 !important;
	}
</style>
<script type="text/javascript">
var mySheet2 = new ibsheetObject();
window.tabs = window.tabs || {};
tabs.buyerWmGrWarehousingLis_tab2 = {
	//alert layer용
	but1text : "<%=CommonLang.get("HTITLE516")%>",/* 확인 */
	but1func : "javascript:closePopText2(); return false;",
	but1funcSearch : "javascript:tabs.buyerWmGrWarehousingLis_tab2.thisPopClose(); return false;",
	but1width : "120px",
	pagingMode : "N",
	current_page : "1",
	popupSel : "",
	grbRow : "",
	grbStatus: "",
	grbGrDate:"",
	tot_gr_amt:0,
	init:function(){
		if($("#st_from_date_2").val() ==  ""){
			$("#st_from_date_2").val(kepToMonthAdd("1","M"));
			$("#st_to_date_2").val(kepGetNowTimeStr('YYYYMMDD','/'));
		}
		
		var initsheet2 = {};
		initsheet2.Cfg = {FrozenCol:2,MergeSheet:msHeaderOnly,     HeaderRowHeight: 50, DataRowHeight: 30,    Alternate : 0,UseNoDataRow:1};
		initsheet2.Cols = [
				 { Align:"Center",	SaveName:"sStatus",				Header:"<%=CommonLang.get("HTITLE255")%>",				Type:"Status",		Width:60,	Edit:false,	EditLen:0,		Hidden:true} /*상태*/
				,{ Align:"Center",	SaveName:"SELECTED",			Header:"",					Type:"DummyCheck",	Width:40,	Edit:true,	EditLen:100,	Hidden:false}
				,{ Align:"Left",	SaveName:"COM_NAME_LOC",		Header:"<%=CommonLang.get("HTITLE291")%>",				Type:"Text",		Width:120,	Edit:false,	EditLen:100,	Hidden:true} /*고객사명*/
				,{ Align:"Center",	SaveName:"GR_DATE",			Header:"<%=CommonLang.get("HTITLE283")%>",				Type:"Date",		Width:100,	Edit:true,	EditLen:100,	Hidden:false,Format:"yyyy-MM-dd",Sort:false,BackColor:"${optColor}"} /*입고일*/
				,{ Align:"Center",	SaveName:"DELIVERY_DATE",			Header:"<%=CommonLang.get("HTITLE1539")%>",				Type:"Date",		Width:100,	Edit:false,	EditLen:100,	Hidden:false,Format:"yyyy-MM-dd",Sort:false} /*실적등록일*/
				,{ Align:"Center",	SaveName:"PR_NO",		Header:"<%=CommonLang.get("HTITLE1179")%>",				Type:"Text",		Width:100,	Edit:false,	EditLen:100,	Hidden:false, FontColor:"#3a72c7", Cursor:"Pointer"} /*주문요청번호*/
				,{ Align:"Center",	SaveName:"PO_NO",			Header:"<%=CommonLang.get("HTITLE203")%>",				Type:"Text",		Width:100,	Edit:false,	EditLen:100,	Hidden:false , FontColor:"#3a72c7", Cursor:"Pointer"} /*발주번호*/
				,{ Align:"Center",	SaveName:"INV_NO",				Header:"<%=CommonLang.get("HTITLE784")%>",				Type:"Text",		Width:100,	Edit:false,	EditLen:100,	Hidden:false , FontColor:"#3a72c7", Cursor:"Pointer"} /*거래명세서번호*/
				,{ Align:"Left",	SaveName:"REF_PR_NO",				Header:"<%=CommonLang.get("HTITLE18")%>",				Type:"Text",		Width:150,	Edit:false,	EditLen:100,	Hidden:false} /*관리번호*/
				,{ Align:"Left",	SaveName:"BUYER_ITEM_NO",				Header:"<%=CommonLang.get("HTITLE12")%>",				Type:"Text",		Width:100,	Edit:false,	EditLen:100,	Hidden:false} /*품목코드*/
				,{ Align:"Left",	SaveName:"DESCRIPTION",				Header:"<%=CommonLang.get("HTITLE13")%>",				Type:"Text",		Width:120,	Edit:false,	EditLen:100,	Hidden:false} /*품목명*/
				,{ Align:"Left",	SaveName:"SPECIFICATION",				Header:"<%=CommonLang.get("HTITLE14")%>",				Type:"Text",		Width:150,	Edit:false,	EditLen:100,	Hidden:false} /*규격*/
				,{ Align:"Right",	SaveName:"UNIT_PRICE",				Header:"<%=CommonLang.get("HTITLE174")%>",				Type:"Float",		Width:90,	Edit:false,	EditLen:100,	Hidden:false, Format:"${priceFormat}"}/*단가*/
				,{ Align:"Center",	SaveName:"UNIT_MEASURE",				Header:"<%=CommonLang.get("HTITLE52")%>",				Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:false}/*단위*/
				,{ Align:"Right",	SaveName:"PO_QTY",				Header:"<%=CommonLang.get("HTITLE217")%>",				Type:"Float",		Width:90,	Edit:false,	EditLen:100,	Hidden:false}/*발주수량*/
				,{ Align:"Right",	SaveName:"PO_AMT",				Header:"<%=CommonLang.get("HTITLE1059")%>",				Type:"Float",		Width:90,	Edit:false,	EditLen:100,	Hidden:false, Format:"${priceFormat}"}/*주문금액*/
				,{ Align:"Right",	SaveName:"INV_QTY",				Header:"<%=CommonLang.get("HTITLE263")%>",				Type:"Float",		Width:90,	Edit:false,	EditLen:100,	Hidden:false}/*송장수량*/
				,{ Align:"Right",	SaveName:"AVAIL_GR_QTY",				Header:"<%=CommonLang.get("HTITLE274")%>",				Type:"Float",		Width:90,	Edit:false,	EditLen:100,	Hidden:false}/*입고가능수량*/
				,{ Align:"Right",	SaveName:"GR_QTY",				Header:"<%=CommonLang.get("HTITLE273")%>",				Type:"Float",		Width:90,	Edit:false,	EditLen:100,	Hidden:false}/*기입고수량*/
				,{ Align:"Center",	SaveName:"PR_CHANGE_DATE",			Header:"<%=CommonLang.get("HTITLE1235")%>",				Type:"Date",		Width:100,	Edit:false,	EditLen:100,	Hidden:false,Format:"yyyy-MM-dd"} /*주문요청일*/
				,{ Align:"Center",	SaveName:"PO_CREATE_DATE",			Header:"<%=CommonLang.get("HTITLE185")%>",				Type:"Date",		Width:100,	Edit:false,	EditLen:100,	Hidden:false,Format:"yyyy-MM-dd"} /*주문일*/
				,{ Align:"Left",	SaveName:"PR_USER_NAME",				Header:"<%=CommonLang.get("HTITLE133")%>",				Type:"Text",		Width:100,	Edit:false,	EditLen:100,	Hidden:false} /*요청자*/
				,{ Align:"Left",	SaveName:"REQ_DEPT_NAME",				Header:"<%=CommonLang.get("HTITLE135")%>",				Type:"Text",		Width:100,	Edit:false,	EditLen:100,	Hidden:false} /*요청부서*/
				,{ Align:"Left",	SaveName:"PO_CREATOR",				Header:"<%=CommonLang.get("HTITLE187")%>",				Type:"Text",		Width:100,	Edit:false,	EditLen:100,	Hidden:false} /*발주자*/
				,{ Align:"Left",	SaveName:"PO_CREATE_DEPT_NAME",				Header:"<%=CommonLang.get("HTITLE188")%>",				Type:"Text",		Width:100,	Edit:false,	EditLen:100,	Hidden:false} /*발주부서*/
				,{ Align:"Left",	SaveName:"BUDGET_DEPT",			Header:"<%=CommonLang.get("HTITLE268")%>",				Type:"Text",		Width:100,	Edit:false,	EditLen:100,	Hidden:true} /*예산부서*/
				,{ Align:"Left",	SaveName:"ACCOUNT_NAME",				Header:"<%=CommonLang.get("HTITLE966")%>",				Type:"Text",		Width:100,	Edit:false,	EditLen:100,	Hidden:true} /*예산계정*/
				,{ Align:"Left",	SaveName:"PARCEL_INFO",				Header:"<%=CommonLang.get("HTITLE673")%>",				Type:"Text",		Width:120,	Edit:false,	EditLen:100,	Hidden:true} /*택배사정보*/
				,{ Align:"Center",	SaveName:"IMAGE_KEY_BUTTON",			Header:"<%=CommonLang.get("HTITLE675")%>",				Type:"Button",		Width:100,	Edit:false,	EditLen:100,	Hidden:true,ClassName:'Type03'}/*배송증빙*/
				,{ Align:"Center",	SaveName:"AGENT_NAME",			Header:"<%=CommonLang.get("HTITLE567")%>",				Type:"Text",		Width:120,	Edit:false,	EditLen:100,	Hidden:false, FontColor:"#3a72c7", Cursor:"Pointer"}/*협력사명*/
				,{ Align:"Center",	SaveName:"CART_BUTTON",			Header:"<%=CommonLang.get("HTITLE11")%>",				Type:"Image",		Width:80,	Edit:false,	EditLen:100,	Hidden:false,Cursor:"Pointer", ImgHeight:20}/*장바구니*/
				,{ Align:"Center",	SaveName:"GR_BUTTON",			Header:"<%=CommonLang.get("HTITLE270")%>",				Type:"Button",		Width:100,	Edit:false,	EditLen:100,	Hidden:true,ClassName:'Type03'}/*입고*/
				,{ Align:"Left",	SaveName:"PH_REMARK",				Header:"<%=CommonLang.get("HTITLE1532")%>",				Type:"Text",		Width:150,	Edit:false,	EditLen:100,	Hidden:true} /*실제요청자*/
				
				,{ Align:"Center",	SaveName:"RECV_FLAG",			Header:"RECV_FLAG",				Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
				,{ Align:"Center",	SaveName:"BUYER",			Header:"BUYER",				Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
				,{ Align:"Center",	SaveName:"CONTRACT_NO",			Header:"CONTRACT_NO",				Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
				,{ Align:"Center",	SaveName:"CONTRACT_SEQ",			Header:"CONTRACT_SEQ",				Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
				,{ Align:"Center",	SaveName:"BYIT_COMORG_CODE",			Header:"BYIT_COMORG_CODE",				Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
				,{ Align:"Center",	SaveName:"AGENT",			Header:"AGENT",				Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
				,{ Align:"Center",	SaveName:"AGENT_CODE",			Header:"AGENT_CODE",				Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
				,{ Align:"Center",	SaveName:"PURCHASER_ID",	Header:"PURCHASER_ID",				Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
				,{ Align:"Center",	SaveName:"SELLER",			Header:"SELLER",				Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
				,{ Align:"Center",	SaveName:"PR_SEQ",			Header:"PR_SEQ",				Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
				,{ Align:"Center",	SaveName:"PO_SEQ",			Header:"PO_SEQ",				Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
				,{ Align:"Center",	SaveName:"INV_SEQ",			Header:"INV_SEQ",				Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
				
				,{ Align:"Center",	SaveName:"AUTO_GR_FLAG",			Header:"AUTO_GR_FLAG",				Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
				,{ Align:"Center",	SaveName:"BUDGET_DEPT_CODE",			Header:"BUDGET_DEPT_CODE",				Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
				,{ Align:"Center",	SaveName:"ACCOUNT_TYPE",			Header:"ACCOUNT_TYPE",				Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
				,{ Align:"Center",	SaveName:"PX_NO",			Header:"PX_NO",				Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
				,{ Align:"Center",	SaveName:"GW_NO",			Header:"GW_NO",				Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
				,{ Align:"Center",	SaveName:"IMAGE_KEY_INV",			Header:"IMAGE_KEY_INV",				Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
				,{ Align:"Center",	SaveName:"IMAGE_KEY_SIGN",			Header:"IMAGE_KEY_SIGN",				Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
				,{ Align:"Center",	SaveName:"WAREHOUSE_CODE",			Header:"WAREHOUSE_CODE",				Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
				,{ Align:"Center",	SaveName:"IV_EXIST",			Header:"IV_EXIST",				Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
				,{ Align:"Center",	SaveName:"AGENT_PRICE",			Header:"AGENT_PRICE",				Type:"Float",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
				,{ Align:"Center",	SaveName:"PCO_LEGACY_PO_NO",			Header:"PCO_LEGACY_PO_NO",				Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
				,{ Align:"Center",	SaveName:"GR_LOCK_MONTH",			Header:"GR_LOCK_MONTH",				Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
				
				
				
		];
		
		IBS_InitSheet(mySheet2, initsheet2, this.pagingMode);
		mySheet2.SetHighlightAfterSort(2);
		
		mySheet2.SetHeaderBackColor("#f2f7ff");
		mySheet2.SetTheme("DB", "DeepBlue");
		
		
	},
	search:function(value){
		if (kep_dateSearchCheck($("#st_from_date_2").val(),$("#st_to_date_2").val()) == false) return;
		var diff = kepGetDateDiff('st_from_date_2','st_to_date_2','D');
		if (eval(diff)>372){
			var text = "<%=CommonLang.msg("MSG617")%>";//1년 이내 조회만 가능합니다.
			openLayerPopText2(text,this.but1text,this.but1func,this.but1width);
			return;
		}
		$("#st_all_page_2").val("N");
		
		var com_code = $("#st_com_code_2").val();
		if(com_code.indexOf("GROUP") >=0){
			$("#st_group_info_2").val(com_code);
		}else{
			$("#st_group_info_2").val("");
		}
		this.current_page = 1;
		kepSearch_v2(document.searchCondition2, mySheet2, "/wmgr/getBuyerWmGrWarehousingRegList_v3.do?page="+this.current_page, this.pagingMode);
	},
	reload:function(){
		kepReload_v2('searchCondition2');
		kepMonth_v2('st_from_date_2','st_to_date_2','1');
		$("#st_pur_dept_code_2").val("");
		$("#st_req_dept_code_2").val("");
		$("#st_dept_code_2").val("");
		$("#st_ref_pr_no_2").val("");
		$("#st_ref_pr_no_text_2").val("");
		mySheet2.RemoveAll();
		
		this.tot_gr_amt = 0;
		$("#tot_amt_2").html("<%=CommonLang.get("HTITLE1469")%>"+ " : "+"0"+"<%=CommonLang.get("HTITLE660")%>");// 합계금액 : 0원
	},
	doAction:function(str,value1){
		switch (str) {
		case "reqDepartmentErase":
			$("#st_req_dept_code_2").val("");
			$("#st_req_dept_name_2").val("");
			break;
		case "purDepartmentErase":
			$("#st_pur_dept_code_2").val("");
			$("#st_pur_dept_name_2").val("");
			break;
		case "refPrNoErase":
			$("#st_ref_pr_no_2").val("");
			$("#st_ref_pr_no_text_2").val("");
			break;
		case "grSave":
			this.grSave();
			break;
		case "departmentErase":
			$("#st_req_dept_code_2").val("");
			$("#st_req_dept_name_2").val("");
			break;
		case "excelDown":
			if (kep_dateSearchCheck($("#st_from_date_2").val(),$("#st_to_date_2").val()) == false) return;
			var diff = kepGetDateDiff('st_from_date_2','st_to_date_2','D');
			if (eval(diff)>372){
				var text = "<%=CommonLang.msg("MSG617")%>";//1년 이내 조회만 가능합니다.
				openLayerPopText2(text,this.but1text,this.but1func,this.but1width);
				return;
			}
			var com_code = $("#st_com_code_2").val();
			if(com_code.indexOf("GROUP") >=0){
				$("#st_group_info_2").val(com_code);
			}else{
				$("#st_group_info_2").val("");
			}
			
			$("#st_all_page_2").val("Y");
			
			document.forms.searchCondition2.action = "/wmgr/excelBuyerWmGrWarehousingRegList_v2.do";
			document.forms.searchCondition2.submit();
			break;
		case "GrAppSend": //롯데칠성 입고 결재 상신
			this.setAppListGr();
			break;
		default:
			break;
		}
	},
	doPop:function(str,value1,value2,value3,value4){
		this.popupSel = str;
		var com_code = $("#st_com_code_2").val();
		if(com_code == ""){
			var text = "<%=CommonLang.msg("MSG239")%>";//고객사를 전체 아닌 값으로 선택해야 합니다.
			openLayerPopText2(text,this.but1text,this.but1func,this.but1width);
			return;
		}
		switch (str) {
		case "purDepartment":
			openSearchPopup('/common/deptCodeAdminPop.do', "?open=Y&com_code="+com_code+"&tab_id=buyerWmGrWarehousingLis_tab2", "720,580,no"); 
			break;
		case "reqDepartment":
			openSearchPopup('/common/deptCodeAdminPop.do', "?open=Y&com_code="+com_code+"&tab_id=buyerWmGrWarehousingLis_tab2", "720,580,no"); 
			break;
		case "purUser":
			openSearchPopup('/common/misUserSelectDeptPop.do', '?open=Y&com_code='+com_code+'&dept_code='+"&tab_id=buyerWmGrWarehousingLis_tab2", "780,550,no");
			break;
		case "reqUser":
			openSearchPopup('/common/misUserSelectDeptPop.do', '?open=Y&com_code='+com_code+'&dept_code='+"&tab_id=buyerWmGrWarehousingLis_tab2", "780,550,no");
			break;
		case "department":
			openSearchPopup('/common/deptCodeAdminPop.do', "?open=Y&com_code="+com_code+"&tab_id=buyerWmGrWarehousingLis_tab2", "720,580,no"); 
			break;
		case "refPrNo":
			var buyer  = $("#st_com_code_2").val();
			var ref_no = $("#st_ref_pr_no_2").val();
			//TYPE4,7 은 해당 타이틀과 컬럼명
			var st_gbn = "<%=CommonLang.get("HTITLE1260")%>"; //Cost Center 명
			var st_title = "<%=CommonLang.get("HTITLE1259")%>"; //CostCenter
			
			$("#st_buyer_2").val(buyer);
			$("#st_ref_no_2").val(ref_no);
			$("#st_type_2").val("M014");

			if($("#st_pop_type_2").val() == "TYPE5"){
				st_title = "하이트진로㈜ 이천공장 현장소모품 팀";
				st_gbn = "현장소모품팀";
			}
			
			$("#st_gbn_2").val(st_gbn);
			$("#st_title_2").val(st_title);
			openSearchPopupPost("/common/showBuyerRefPrNoPop_v2.do","refPrNoForm_2","showBuyerRefPrNoPop_v2","width=695,height=500,resizable=no,scrollbars=no");
			break;
		default:
			break;
		}
	},
	pageSearch:function(param){
		$("#st_all_page_2").val("N");
		this.current_page = param.page;
		kepSearch_v2(document.searchCondition2, mySheet2, "/wmgr/getBuyerWmGrWarehousingRegList_v3.do?page="+this.current_page, this.pagingMode);
	},
	setPopupReturn:function(value1,value2,value3){
		if (this.popupSel == "purDepartment") {
			$("#st_pur_dept_code_2").val(value1);
			$("#st_pur_dept_name_2").val(value2);
		}else if(this.popupSel == "reqDepartment") {
			$("#st_req_dept_code_2").val(value1);
			$("#st_req_dept_name_2").val(value2);
		}else if(this.popupSel == "purUser") {
			$("#st_pur_user_id_2").val(value1);
			$("#st_pur_user_name_2").val(value2);
		}else if(this.popupSel == "reqUser") {
			$("#st_req_user_id_2").val(value1);
			$("#st_req_user_name_2").val(value2);
		}else if(this.popupSel == "department") {
			$("#st_req_dept_code_2").val(value1);
			$("#st_req_dept_name_2").val(value2);
		}else if(this.popupSel == "refPrNo"){ // value1 은 st_row , value2 가 code/text
			$("#st_ref_pr_no_2").val(value2);
		}else if(this.popupSel == "refPrNoSave"){
			mySheet2.SetCellValue(this.grbRow,"REF_PR_NO",value2);
		}
	},
	grSave:function(){
		var checkRows = mySheet2.FindCheckedRow("SELECTED");
		var arrRow = checkRows.split("|");
		
		if(checkRows == ""){
			//하나 이상의 대상이 선택되어야 합니다.
			var text = "<%=CommonLang.msg("MSG259") %>";
			openLayerPopText2(text,this.but1text,this.but1func,this.but1width);
			return;
		}

		var grRole = '<%=grRole%>';
		
		if(grRole == '-'){
			// 마감 기간으로 입고가 불가합니다. KEP담당자에게 문의 부탁드립니다.
			var text = "<%=CommonLang.msg("MSG600") %>";
			openLayerPopText2(text,this.but1text,this.but1func,this.but1width);
			return;		
		}
		
		var user_id = $("#st_user_id_2").val();
		
		var query = "";
		for(var idx = 0; idx<arrRow.length; idx++){
			var gr_date		= mySheet2.GetCellValue(arrRow[idx],"GR_DATE");
			var delivery_date = mySheet2.GetCellValue(arrRow[idx],"DELIVERY_DATE");
			if(gr_date == ""){
				//입고일을 입력해주세요
				var text = "<%=CommonLang.msg("MSG816")%> ";
				mySheet2.SelectCell(arrRow[idx],"GR_DATE");
				openLayerPopText2(text,this.but1text,this.but1func,this.but1width);
				return
			}else{
				if(gr_date<delivery_date){
					//입고일은 실적등록일 이전 날짜로 할 수 없습니다.
					var text = "<%=CommonLang.msg("MSG1008")%> ";
					mySheet2.SelectCell(arrRow[idx],"GR_DATE");
					openLayerPopText2(text,this.but1text,this.but1func,this.but1width);
					return
				}
			}
			var buyer = mySheet2.GetCellValue(arrRow[idx],"BUYER");
			var seller = mySheet2.GetCellValue(arrRow[idx],"SELLER");
			var po_no = mySheet2.GetCellValue(arrRow[idx],"PO_NO");
			var po_seq = mySheet2.GetCellValue(arrRow[idx],"PO_SEQ");
			var inv_no = mySheet2.GetCellValue(arrRow[idx],"INV_NO");
			var inv_seq = mySheet2.GetCellValue(arrRow[idx],"INV_SEQ");
			var agent = mySheet2.GetCellValue(arrRow[idx],"AGENT");
			var agent_price = mySheet2.GetCellValue(arrRow[idx],"AGENT_PRICE");
			var gr_qty = mySheet2.GetCellValue(arrRow[idx],"AVAIL_GR_QTY");
			var gr_ref_pr_no = mySheet2.GetCellValue(arrRow[idx],"REF_PR_NO");
			var db_auto_gr = mySheet2.GetCellValue(arrRow[idx],"AUTO_GR_FLAG");
			var buyer_item_no = mySheet2.GetCellValue(arrRow[idx],"BUYER_ITEM_NO");
			var legacy_po_no = mySheet2.GetCellValue(arrRow[idx],"PCO_LEGACY_PO_NO");
			var gr_lock_month = mySheet2.GetCellValue(arrRow[idx],"GR_LOCK_MONTH");
			
			// 통제년월 vs 입력년월
			if(gr_lock_month >= gr_date.substr(0,6)){
				// 월마감이 종료되어 해당 월로 입고 불가합니다.
				var text = "<%=CommonLang.msg("MSG585") %>";
				openLayerPopText2(text,this.but1text,this.but1func,this.but1width);
				return;
			}
			
			if(<%=st_solb_buyer%>) { // 솔브레인 SRM 인터페이스 발주 입고 등록 못하도록 변경( PODT.LEGACY_PO_NO 4로 시작할 때)
				if(legacy_po_no != '' || legacy_po_no != null) {
					if(legacy_po_no.substr(0, 1) == "4" ) {
						var text = "<%=CommonLang.msg("MSG581") %>";
						openLayerPopText2(text,this.but1text,this.but1func,this.but1width);
						return;
					}
				}
			}
			document.forms.searchCondition2.st_com_code.value = buyer;
			
			if(db_auto_gr == "Y"){
				//번째 입고 자료는 자동입고 처리 건이므로 입고취소가 불가능 합니다.
				var text = "<%=CommonLang.msg("MSG241") %>";
				openLayerPopText2(text,this.but1text,this.but1func,this.but1width);
				return;
			}
			
			query +=  buyer			+ "@@";
			query +=  seller		+ "@@";
			query +=  po_no			+ "@@";
			query +=  po_seq		+ "@@";
			query +=  inv_no		+ "@@";
			query +=  inv_seq		+ "@@";
			query +=  user_id		+ "@@";
			query +=  agent			+ "@@";
			query +=  agent_price	+ "@@";
			query +=  gr_date		+ "@@";
			query +=  gr_qty		+ "@@";
			query +=  gr_ref_pr_no	+ "@@";
			query +=  buyer_item_no + "@@";
			query +=  "&&" ;
		}
		
		//선택하신 품목을 입고 처리 하시겠습니까?
		var text = "<%=CommonLang.msg("MSG245")%>"; 
		var but1textC = "<%=CommonLang.get("HTITLE516")%>"; //확인
		var but2textC = "<%=CommonLang.get("HTITLE229")%>"; //취소
     	var but1funcC = "javascript:tabs.buyerWmGrWarehousingLis_tab2.grSaveConfirm('"+query+"'); return false;";
     	var but2funcC = "javascript:closePopText1(); return false;";
     	var but1widthC = "120px";
     	var but2widthC = "120px";
     	openLayerPopText(text,but1textC,but2textC,but1funcC,but2funcC,but1widthC,but2widthC);
     	return;
		
		
	},
	grSaveConfirm:function(query){
		closePopText1();
		document.searchCondition2.st_query.value  = query;
        kepAjaxFormCallTab("/wmgr/saveBuyerWmGrWarehousingRegList.do","searchCondition2","btnSave","buyerWmGrWarehousingLis_tab2");
	},
	setAppListGr:function(){
		var checkRows = mySheet2.FindCheckedRow("SELECTED");
		var arrRow = checkRows.split("|");
		
		if(checkRows == ""){
			//하나 이상의 대상이 선택되어야 합니다.
			var text = "<%=CommonLang.msg("MSG259") %>";
			openLayerPopText2(text,this.but1text,this.but1func,this.but1width);
			return;
		}
		
		var user_id = $("#st_user_id_2").val();
		var query = "";
		
		for(var idx = 0; idx < arrRow.length; idx++){
			var gr_date		= mySheet2.GetCellValue(arrRow[idx],"GR_DATE");
			if(gr_date == ""){
				//입고일을 입력해주세요
				var text = "<%=CommonLang.msg("MSG816")%> ";
				mySheet2.SelectCell(arrRow[idx],"GR_DATE");
				openLayerPopText2(text,this.but1text,this.but1func,this.but1width);
				return
			}
			var buyer		= mySheet2.GetCellValue(arrRow[idx],"BUYER");
			var po_no		= mySheet2.GetCellValue(arrRow[idx],"PO_NO");
			var po_seq		= mySheet2.GetCellValue(arrRow[idx],"PO_SEQ");
			var inv_no		= mySheet2.GetCellValue(arrRow[idx],"INV_NO");
			var inv_seq		= mySheet2.GetCellValue(arrRow[idx],"INV_SEQ");
			
			
			var buyer_item_no = mySheet2.GetCellValue(arrRow[idx],"BUYER_ITEM_NO");
			document.forms.searchCondition2.st_com_code.value = buyer;
			
			query +=  buyer			+ "@@";
			query +=  po_no			+ "@@";
			query +=  po_seq		+ "@@";
			query +=  inv_no		+ "@@";
			query +=  inv_seq		+ "@@";
			query +=  user_id		+ "@@";
			query +=  buyer_item_no + "@@";
			query +=  gr_date		+ "@@";
			query +=  "&&" ;
		}
		//선택하신 품목을 입고 처리 하시겠습니까?
		var text = "<%=CommonLang.msg("MSG245")%>"; 
		var but1textC = "<%=CommonLang.get("HTITLE516")%>"; //확인
		var but2textC = "<%=CommonLang.get("HTITLE229")%>"; //취소
     	var but1funcC = "javascript:tabs.buyerWmGrWarehousingLis_tab2.setAppListGrConfirm('"+query+"'); return false;";
     	var but2funcC = "javascript:closePopText1(); return false;";
     	var but1widthC = "120px";
     	var but2widthC = "120px";
     	openLayerPopText(text,but1textC,but2textC,but1funcC,but2funcC,but1widthC,but2widthC);
		
	},
	//입고일 일괄등록 확인하기
	grDateAll:function(){
		var checkRows = mySheet2.FindCheckedRow("SELECTED");
		var arrRow = checkRows.split("|");
		
		if(checkRows == ""){
			//하나 이상의 대상이 선택되어야 합니다.
			var text = "<%=CommonLang.msg("MSG259") %>";
			openLayerPopText2(text,this.but1text,this.but1func,this.but1width);
			return;
		}
		$("#grDateSelOverlay").show();
		$("#grDateSel").show();
	},
	grDateCancel:function(){
		$("#grDateSelOverlay").hide();
		$("#grDateSel").hide();
	},
	grDateSel:function(recvFlag){
		var cur_date = kepGetNowTimeStr("YYYYMMDD","");
		var imsi_gr_date = $("#imsi_gr_date_2").val().replace(/[/]/gi,"");
		if($("#imsi_gr_date_2").val() == ""){
			//입고일을 입력해주세요
			var text = "<%=CommonLang.msg("MSG816")%> ";
			openLayerPopText2(text,this.but1text,this.but1func,this.but1width);
			return;
		}
		var valid_chk_date = kepToMonthAdd("1","M","noslash").substr(0,6)+"01";
		if(imsi_gr_date < valid_chk_date && imsi_gr_date !=""){
			//입고일은 이후로 입력 가능합니다. \n입고일을 다시 입력해 주시기 바랍니다.
			var text = "<%=CommonLang.msg("MSG244")%> " + kepDateSlashAdd(valid_chk_date)+" <%=CommonLang.msg("MSG386")%>";
			openLayerPopText2(text,this.but1text,this.but1func,this.but1width);
			return;
		}
		$("#grDateSelOverlay").hide();
		$("#grDateSel").hide();
		
		var checkRows = mySheet2.FindCheckedRow("SELECTED");
		var arrRow = checkRows.split("|");
		
		if(checkRows == ""){
			//하나 이상의 대상이 선택되어야 합니다.
			var text = "<%=CommonLang.msg("MSG259") %>";
			openLayerPopText2(text,this.but1text,this.but1func,this.but1width);
			return;
		}
		
		for(var idx = 0; idx < arrRow.length; idx++){
			mySheet2.SetCellValue(arrRow[idx],"GR_DATE",imsi_gr_date);
		}
	},
	setAppListGrConfirm:function(query){
		closePopText1();
		
		document.searchCondition2.st_query.value  = query;
        kepAjaxFormCallTab("/wmgr/getBuyerWmGrWarehousingRegGrAppSendList.do","searchCondition","AppGrSend","buyerWmGrWarehousingLis_tab2");
		
	},
	kepAjaxSuccess:function(pMethod , response){
		var sMsg = response.msg.MSG;   
		if(pMethod == "SAVE"){
			if (sMsg == "UPDATE_OK"){
				if(pMethod == "SAVE"){
					var text = "<%=CommonLang.msg("MSG507") %> "; //정상적으로 처리되었습니다. 
					openLayerPopText2(text,this.but1text,this.but1funcSearch,this.but1width);
				}
			} else {
				this.search();
			}  
		}else if(pMethod == "CsaveProcess"){
			if (sMsg == "CREATE_OK"){
				//장바구니에 추가되었습니다. 장바구니로 이동하시겠습니까?
				var text = "<%=CommonLang.msg("MSG695")%>" +" "+ "<%=CommonLang.msg("MSG364")%>"; 
				var but1textC = "<%=CommonLang.get("HTITLE516")%>"; //확인
				var but2textC = "<%=CommonLang.get("HTITLE229")%>"; //취소
	         	var but1funcC = "javascript:tabs.buyerWmGrWarehousingLis_tab2.goCart(); return false;";
	         	var but2funcC = "javascript:closePopText1(); return false;";
	         	var but1widthC = "120px";
	         	var but2widthC = "120px";
	         	openLayerPopText(text,but1textC,but2textC,but1funcC,but2funcC,but1widthC,but2widthC);
			} else{
				//이미 장바구니에 담긴 품목입니다.\n선택하신 수량이 추가되었습니다. 장바구니로 이동하시겠습니까?
				var text = sMsg +"<br/>"+ "<%=CommonLang.msg("MSG364")%>";
				var but1textC = "<%=CommonLang.get("HTITLE516")%>"; //확인
				var but2textC = "<%=CommonLang.get("HTITLE229")%>"; //취소
	         	var but1funcC = "javascript:tabs.buyerWmGrWarehousingLis_tab2.goCart(); return false;";
	         	var but2funcC = "javascript:closePopText1(); return false;";
	         	var but1widthC = "120px";
	         	var but2widthC = "120px";
	         	openLayerPopText(text,but1textC,but2textC,but1funcC,but2funcC,but1widthC,but2widthC);
			}
		}else if(pMethod == "btnSave"){
			//입고가 정상적으로 이루어 졌습니다.
			var text = "<%=CommonLang.msg("MSG242") %> "; 
			openLayerPopText2(text,this.but1text,this.but1funcSearch,this.but1width);
		}else if(pMethod == "AppGrSend"){
			var post_url = response.APP.callback;
			var post_chk = response.APP.chk;
			var post_msg = response.APP.msg;
			
			if (post_chk == "OK"){
				window.open(post_url);
				this.doAction('search');
			} else {
				var text = post_msg; 
				openLayerPopText2(text,this.but1text,this.but1funcSearch,this.but1width);
				return;
			}
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
	cartInsert:function(){
		closePopText1();
		
		var query = "";
		query += mySheet2.GetCellValue(this.grbRow,"BUYER_ITEM_NO") + "@@" + "1" + "@@" + mySheet2.GetCellValue(this.grbRow,"AGENT_CODE") + "@@" + mySheet2.GetCellValue(this.grbRow,"CONTRACT_NO") + "@@" + mySheet2.GetCellValue(this.grbRow,"CONTRACT_SEQ") + "@@" + mySheet2.GetCellValue(this.grbRow,"BYIT_COMORG_CODE");
		query += "&&";
		
		document.forms.processForm_2.st_pf_my_group.value = "";
		document.forms.processForm_2.st_use_flag.value = "C"; 
		document.forms.processForm_2.st_query2.value = query;
		document.forms.processForm_2.st_dup_add_flag.value = "<%=dup_add_posb_yn%>";
		kepAjaxFormCallTab("/mdcm/saveBuyerMdCmGoodsLisList.do","processForm_2","CsaveProcess","buyerWmGrWarehousingLis_tab2");
	},
	goCart:function(){
		closePopText1();
		location.href = "<%=p060000036%>";
	},
	buyerChange:function(){
		$("#st_req_dept_code_2").val("");
		$("#st_req_dept_name_2").val("");
	}
};
//조회 후처리
function mySheet2_OnSearchEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}
	
	//입고버튼 전체 숨김
<%-- 	var p070000024 = "<%=p070000024%>"; //입고 버튼 숨김 --%>
// 	if(p070000024 == "true"){
// 		mySheet2.SetColHidden("GR_BUTTON",true);
// 	}
	
	var group_mng_flag = "<%=group_mng_flag%>";
	if(group_mng_flag == "Y"){ //통합고객사 -> 고객사명 컬럼 노출
		mySheet2.SetColHidden("COM_NAME_LOC",false);
	}
	var budget_flag = "<%=sessionBudget_flag%>";
	if(budget_flag == "Y"){ //예산부서,계정 컬럼 노출
		mySheet2.SetColHidden("BUDGET_DEPT",false);
		mySheet2.SetColHidden("ACCOUNT_NAME",false);
	}
	var p060000080 = "<%=p060000080%>"; //택배사정보,배송증빙 컬럼 노출
	if(p060000080 == "TYPE3"){
		mySheet2.SetColHidden("PARCEL_INFO",false);
		mySheet2.SetColHidden("IMAGE_KEY_BUTTON",false);
	}
	
	var bgr00002 = "<%=bgr00002%>"; //실제요청자 컬럼 노출(pohd.remark)
	if(bgr00002 == "true"){
		mySheet2.SetColHidden("PH_REMARK",false);
	}
	
	var p060000029_type = "<%=p060000029_type%>";
	var cur_date = kepGetNowTimeStr("YYYYMMDD","");
	
	for(var i = 1; i<=mySheet2.RowCount(); i++){
		//입고일 기본 오늘 날짜로 셋팅
		mySheet2.SetCellValue(i,"GR_DATE",cur_date);
		mySheet2.SetCellValue(i,"CART_BUTTON","/resources/imgs/UserCart.png");
		mySheet2.SetCellValue(i,"GR_BUTTON","<%=CommonLang.get("HTITLE270")%>"); //입고취소
		if(mySheet2.GetCellValue(i,"IMAGE_KEY_INV") != "" || mySheet2.GetCellValue(i,"IMAGE_KEY_SIGN") != ""){
			mySheet2.SetCellValue(i,"IMAGE_KEY_BUTTON","<%=CommonLang.get("HTITLE119")%>"); //첨부파일
		}
		
		if(p060000029_type == "TYPE16" || p060000029_type == "TYPE26"){
			mySheet2.SetCellFontColor(i,"REF_PR_NO","#3a72c7");
			mySheet2.SetCellCursor(i,"REF_PR_NO","Pointer");
		}
	}
	
	tabs.buyerWmGrWarehousingLis_tab2.tot_gr_amt = 0;
	$("#tot_amt_2").html("<%=CommonLang.get("HTITLE1469")%>"+ " : "+"0"+"<%=CommonLang.get("HTITLE660")%>");// 합계금액 : 0원

	makePageIndex_v3( mySheet2 , tabs.buyerWmGrWarehousingLis_tab2.current_page , document.searchCondition2.onepagerow.value,"buyerWmGrWarehousingLis_tab","2");	
	
}
//그리드 셀클릭 이벤트
function mySheet2_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = mySheet2.ColSaveName(mySheet2.GetSelectCol());
	tabs.buyerWmGrWarehousingLis_tab2.grbRow = Row;
	
	var user_id = $("#st_user_id_2").val();
	var buyer = mySheet2.GetCellValue(Row,"BUYER");
	var pr_no = mySheet2.GetCellValue(Row,"PR_NO");
	var pr_seq = mySheet2.GetCellValue(Row,"PR_SEQ");
	var po_no = mySheet2.GetCellValue(Row,"PO_NO");
	var po_seq = mySheet2.GetCellValue(Row,"PO_SEQ");
	var recv_flag = mySheet2.GetCellValue(Row,"RECV_FLAG");
	
	var gw_no = mySheet2.GetCellValue(Row,"GW_NO");
	
	var seller = mySheet2.GetCellValue(Row,"SELLER");
	var inv_no = mySheet2.GetCellValue(Row,"INV_NO");
	var purchaser_id = mySheet2.GetCellValue(Row,"PURCHASER_ID");
	var agent_code = mySheet2.GetCellValue(Row,"AGENT_CODE");
	var warehouse_code = mySheet2.GetCellValue(Row,"WAREHOUSE_CODE");
	var ref_pr_no = mySheet2.GetCellValue(Row,"REF_PR_NO");
	
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
	}else if(column == "CART_BUTTON"){ //장바구니 담기 클릭 시
		var text = "<%=CommonLang.msg("MSG104")%>";	//장바구니에 담으시겠습니까?
		var but1textC = "<%=CommonLang.get("HTITLE516")%>"; //확인
		var but2textC = "<%=CommonLang.get("HTITLE229")%>"; //취소
		var but1funcC = "javascript:tabs.buyerWmGrWarehousingLis_tab2.cartInsert(); return false;";
		var but2funcC = "javascript:closePopText1(); return false;";
		var but1widthC = "120px";
		var but2widthC = "120px";
		openLayerPopText(text,but1textC,but2textC,but1funcC,but2funcC,but1widthC,but2widthC);
	}else if(column == "GR_BUTTON"){ //입고 클릭 시
		var grRole = '<%=grRole%>';
		
		if(grRole == '-'){
			// 마감 기간으로 입고가 불가합니다. KEP담당자에게 문의 부탁드립니다.
			var text = "<%=CommonLang.msg("MSG600") %>";
			openLayerPopText2(text,tabs.buyerWmGrWarehousingLis_tab2.but1text,tabs.buyerWmGrWarehousingLis_tab2.but1func,tabs.buyerWmGrWarehousingLis_tab2.but1width);
			return;		
		}
		
		var user_id = $("#st_user_id_2").val();
		
		var query = "";
		
		var gr_date		= mySheet2.GetCellValue(Row,"GR_DATE");
		if(gr_date == ""){
			//입고일을 입력해주세요
			var text = "<%=CommonLang.msg("MSG816")%> ";
			mySheet2.SelectCell(Row,"GR_DATE");
			openLayerPopText2(text,tabs.buyerWmGrWarehousingLis_tab2.but1text,tabs.buyerWmGrWarehousingLis_tab2.but1func,tabs.buyerWmGrWarehousingLis_tab2.but1width);
			return
		}
		var buyer = mySheet2.GetCellValue(Row,"BUYER");
		var seller = mySheet2.GetCellValue(Row,"SELLER");
		var po_no = mySheet2.GetCellValue(Row,"PO_NO");
		var po_seq = mySheet2.GetCellValue(Row,"PO_SEQ");
		var inv_no = mySheet2.GetCellValue(Row,"INV_NO");
		var inv_seq = mySheet2.GetCellValue(Row,"INV_SEQ");
		var agent = mySheet2.GetCellValue(Row,"AGENT");
		var agent_price = mySheet2.GetCellValue(Row,"AGENT_PRICE");
		var gr_qty = mySheet2.GetCellValue(Row,"AVAIL_GR_QTY");
		var gr_ref_pr_no = mySheet2.GetCellValue(Row,"REF_PR_NO");
		var db_auto_gr = mySheet2.GetCellValue(Row,"AUTO_GR_FLAG");
		var buyer_item_no = mySheet2.GetCellValue(Row,"BUYER_ITEM_NO");
		var legacy_po_no = mySheet2.GetCellValue(Row,"PCO_LEGACY_PO_NO");
		var gr_lock_month = mySheet2.GetCellValue(Row,"GR_LOCK_MONTH");
		
		// 통제년월 vs 입력년월
		if(gr_lock_month >= gr_date.substr(0,6)){
			// 월마감이 종료되어 해당 월로 입고 불가합니다.
			var text = "<%=CommonLang.msg("MSG585") %>";
			openLayerPopText2(text,tabs.buyerWmGrWarehousingLis_tab2.but1text,tabs.buyerWmGrWarehousingLis_tab2.but1func,tabs.buyerWmGrWarehousingLis_tab2.but1width);
			return;
		}
		
		if(<%=st_solb_buyer%>) { // 솔브레인 SRM 인터페이스 발주 입고 등록 못하도록 변경( PODT.LEGACY_PO_NO 4로 시작할 때)
			if(legacy_po_no != '' || legacy_po_no != null) {
				if(legacy_po_no.substr(0, 1) == "4" ) {
					var text = "<%=CommonLang.msg("MSG581") %>";
					openLayerPopText2(text,tabs.buyerWmGrWarehousingLis_tab2.but1text,tabs.buyerWmGrWarehousingLis_tab2.but1func,tabs.buyerWmGrWarehousingLis_tab2.but1width);
					return;
				}
			}
		}
		document.forms.searchCondition2.st_com_code.value = buyer;
		
		if(db_auto_gr == "Y"){
			//번째 입고 자료는 자동입고 처리 건이므로 입고취소가 불가능 합니다.
			var text = "<%=CommonLang.msg("MSG241") %>";
			openLayerPopText2(text,tabs.buyerWmGrWarehousingLis_tab2.but1text,tabs.buyerWmGrWarehousingLis_tab2.but1func,tabs.buyerWmGrWarehousingLis_tab2.but1width);
			return;
		}
		
		query +=  buyer			+ "@@";
		query +=  seller		+ "@@";
		query +=  po_no			+ "@@";
		query +=  po_seq		+ "@@";
		query +=  inv_no		+ "@@";
		query +=  inv_seq		+ "@@";
		query +=  user_id		+ "@@";
		query +=  agent			+ "@@";
		query +=  agent_price	+ "@@";
		query +=  gr_date		+ "@@";
		query +=  gr_qty		+ "@@";
		query +=  gr_ref_pr_no	+ "@@";
		query +=  buyer_item_no + "@@";
		query +=  "&&" ;
		
		//선택하신 품목을 입고 처리 하시겠습니까?
		var text = "<%=CommonLang.msg("MSG245")%>"; 
		var but1textC = "<%=CommonLang.get("HTITLE516")%>"; //확인
		var but2textC = "<%=CommonLang.get("HTITLE229")%>"; //취소
     	var but1funcC = "javascript:tabs.buyerWmGrWarehousingLis_tab2.grSaveConfirm('"+query+"'); return false;";
     	var but2funcC = "javascript:closePopText1(); return false;";
     	var but1widthC = "120px";
     	var but2widthC = "120px";
     	openLayerPopText(text,but1textC,but2textC,but1funcC,but2funcC,but1widthC,but2widthC);
     	return;
	}else if(column == "AGENT_NAME"){
		//getAgentDisplayPop_v2(agent_code);
		openSearchPopup("/common/agentInfoDisplayPop.do", '?st_com_code='+agent_code+"&st_popup_check=N", "800,650,no");
	}else if(column == "IMAGE_KEY_BUTTON"){
		if(mySheet2.GetCellValue(Row,"IMAGE_KEY_INV") != ""){
			var src = '/common/fileUploadPop_v2.do?DOC_NO='+mySheet2.GetCellValue(Row,"IMAGE_KEY_INV")+'&viewType=R&TYPE=IV';
			openLayerPop(src,"600px","490px");
		}else if(mySheet2.GetCellValue(Row,"IMAGE_KEY_SIGN") != ""){
			var src = '/common/fileUploadPop_v2.do?DOC_NO='+mySheet2.GetCellValue(Row,"IMAGE_KEY_SIGN")+'&viewType=R&TYPE=IV';
			openLayerPop(src,"600px","490px");
		}
	}else if(column == "REF_PR_NO"){
		var p060000029_type = "<%=p060000029_type%>";
		if(p060000029_type == "TYPE16" || p060000029_type == "TYPE26"){
			tabs.buyerWmGrWarehousingLis_tab2.popupSel = "refPrNoSave";
			
			var buyer  = $("#st_com_code_2").val();
			var st_gbn = "";
			var st_title = "<%=CommonLang.get("HTITLE1267")%>"; //MRO 구매품목 관리항목 등록
			
			//넘기고 formXX 팝업 만들고
			$("#st_buyer_2").val(buyer);
			$("#st_type_2").val("");
			$("#st_gbn_2").val(st_gbn);
			$("#st_title_2").val(st_title);
			$("#st_ref_no_2").val(ref_pr_no);
			
			if(p060000029_type == "TYPE16"){
				openSearchPopupPost("/common/showBuyerRefPrNoPop_v2.do","refPrNoForm_2","showBuyerRefPrNoPop_v2","width=550,height=430,resizable=no,scrollbars=no");
			}else if(p060000029_type == "TYPE26"){
				$("#no_remark_2").val("N");
				openSearchPopupPost("/common/showBuyerRefPrNoPop_v2.do","refPrNoForm_2","showBuyerRefPrNoPop_v2","width=550,height=300,resizable=no,scrollbars=no");
			}
			
		}
		
	}
	return;
}
function mySheet2_OnChange(Row, Col, Value, OldValue, RaiseFlag){
	if ( Row  < 1) return;
	var column = mySheet2.ColSaveName(mySheet2.GetSelectCol());
	tabs.buyerWmGrWarehousingLis_tab2.grbRow = Row;		//현재 Row를 전역변수에 셋팅
	if(column == "GR_DATE"){ 
		var gr_date = mySheet2.GetCellValue(Row, "GR_DATE");
		var cur_date = kepGetNowTimeStr("YYYYMMDD","");
		// 입고일 validation (오늘월-1개월 초일 ~ 무한)
		var valid_chk_date = kepToMonthAdd("1","M","noslash").substr(0,6)+"01";
		if(gr_date < valid_chk_date && gr_date !=""){
			//입고일은 이후로 입력 가능합니다. \n입고일을 다시 입력해 주시기 바랍니다.
			var text = "<%=CommonLang.msg("MSG244")%> " + kepDateSlashAdd(valid_chk_date)+" <%=CommonLang.msg("MSG386")%>";
			openLayerPopText2(text,tabs.buyerWmGrWarehousingLis_tab2.but1text,tabs.buyerWmGrWarehousingLis_tab2.but1func,tabs.buyerWmGrWarehousingLis_tab2.but1width);
			mySheet2.SetCellValue(Row,"GR_DATE","");
	        mySheet2.SelectCell(Row,"GR_DATE");
	        return;
		}
		
		tabs.buyerWmGrWarehousingLis_tab2.grbGrDate = mySheet2.GetCellValue(Row, "GR_DATE");;
	}
	return;
}
function mySheet2_OnDblClick(row, col, value, cellX, cellY, cellW, cellH) {
	var colName = mySheet2.ColSaveName(col);
	if(colName == 'GR_DATE'){// 입고일자 더블클릭시
		//헤더 더블 클릭 시 복사
		if(row == 0){
			var sRow = mySheet2.FindCheckedRow("SELECTED");
			var arrRow = sRow.split("|");
			
			for(var i = 0; i<arrRow.length; i++){
				mySheet2.SetCellValue(arrRow[i],"GR_DATE",tabs.buyerWmGrWarehousingLis_tab2.grbGrDate);
			}
		}
	}
}

function mySheet2_OnBeforeCheck(row, col) {
	var tot_gr_amt = Number(tabs.buyerWmGrWarehousingLis_tab2.tot_gr_amt) || 0;
	var po_amt     = Number(mySheet2.GetCellValue(row,"PO_AMT")) || 0;

	if(mySheet2.GetCellValue(row,"SELECTED") == 0){ //체크전에 확인하는거라 0이면 -> 이후 체크 된다는 뜻임
		tot_gr_amt += po_amt;
	}else if(mySheet2.GetCellValue(row,"SELECTED") == 1){ //체크전에 확인하는거라 1이면 -> 이후 체크 해제된다는 뜻임
		tot_gr_amt -= po_amt;
	}
	tabs.buyerWmGrWarehousingLis_tab2.tot_gr_amt = tot_gr_amt;

	$("#tot_amt_2").html("<%=CommonLang.get("HTITLE1469")%>"+ " : "+kepCommaNum(tabs.buyerWmGrWarehousingLis_tab2.tot_gr_amt)+"<%=CommonLang.get("HTITLE660")%>");// 합계금액 : x원
}
function mySheet2_OnCheckAllEnd(col, value) {
	tabs.buyerWmGrWarehousingLis_tab2.tot_gr_amt = 0;
	if(value == 1){ // 체크하는 경우
		var checkRows = mySheet2.FindCheckedRow("SELECTED");

		if(checkRows != ""){
			var arrRow = checkRows.split("|");
			for(var i = 0; i<arrRow.length; i++){
				if(mySheet2.GetRowHidden(arrRow[i])){
					mySheet2.SetCellValue(arrRow[i],"SELECTED",0,0);
				}else{
					tabs.buyerWmGrWarehousingLis_tab2.tot_gr_amt += Number(mySheet2.GetCellValue(arrRow[i],"PO_AMT")) || 0;
				}
			}
		}
	}

	$("#tot_amt_2").html("<%=CommonLang.get("HTITLE1469")%>"+ " : "+kepCommaNum(tabs.buyerWmGrWarehousingLis_tab2.tot_gr_amt)+"<%=CommonLang.get("HTITLE660")%>");// 합계금액 : x원
}
</script>
<form id="searchCondition2" name="searchCondition2" method="post">
		<input type="hidden" name="s_SAVENAME" />
		<!-- 화면 내 정의 -->
		<input type="hidden" name="st_dept_name" id="st_dept_name_2" value="${sessionInfo.departmentName}">
		<input type="hidden" name="st_user_id" id="st_user_id_2" value="${sessionInfo.userId}">
		<input type="hidden" name="st_user_name" id="st_user_name_2" value="${sessionInfo.userNameLoc}">
		<input type="hidden" name="st_com_name" id="st_com_name_2" value="${sessionInfo.comNameLoc}">
			
		<input type="hidden" name="st_query" id="st_query_2" value ="">
		<input type="hidden" name="st_close_date" id="st_close_date_2" value ="">
		<input type="hidden" name="st_doc_type" id="st_doc_type_2" value="GR">
		<input type="hidden" name="st_car_check" id="st_car_check_2" value="N">
		
		<input type="hidden" name="st_row_cnt_yn" 	id="st_row_cnt_yn_2" 	value="<%=rowCntYn%>" />
		<input type="hidden" name="st_card_yn" 		id="st_card_yn_2" 	value="<%=cardYn%>" />
		<input type="hidden" name="st_dept_fix" 	id="st_dept_fix_2" 	value="<%=deptFix%>" />
		<input type="hidden" name="st_pr_user_fix" 	id="st_pr_user_fix_2"	value="<%=prUserFix%>" />
		<input type="hidden" name="st_po_user_fix" 	id="st_po_user_fix_2"	value="<%=poUserFix%>" />
		
		<input type="hidden" name="st_extr_report_btn" 	id="st_extr_report_btn_2"	value="<%=extrReportBtn%>" />
		<input type="hidden" name="st_extr_report_id" 	id="st_extr_report_id_2"	value="<%=extrReportId%>" />
		<input type="hidden" name="st_clsd_dnld_yn" 	id="st_clsd_dnld_yn_2"	value="<%=clsdDnldYn%>" />
		
		<input type="hidden" id="st_search_buyer_item_no_2" name="st_search_buyer_item_no" value="">
		<input type="hidden" id="st_search_desc_spec_2" name="st_search_desc_spec"     value="">
		<input type="hidden" id="st_search_agent_2" name="st_search_agent"         value="">
		
		<input type="hidden" name="st_search_type" 	id="st_search_type_2"	value="" />
		<input type="hidden" id="st_excel_type_2" name="st_excel_type"	value="" />
		<input type="hidden" id="st_close_excel_type_2" name="st_close_excel_type"	value="" />
		<input type="hidden" name="st_group_mng_flag" id="st_group_mng_flag_2" value="<%=group_mng_flag%>">
		<input type="hidden" name="st_group_info" id="st_group_info_2" value="">
		
        <input type="hidden" name="onepagerow" id="onepagerow_2" value="<%=request.getParameter("rowCnt")%>">
        <input type="hidden" id="pageflag_2" name="pageflag" value="1" />
        <input type="hidden" id="st_all_page_2" name="st_all_page" value="N" />
	<div id="Search2" class="SearchContent">
      <div class="Importance"><img src="/resources/imgs/Icon_Importance.png" /> <%=CommonLang.msg("MSG813")%><!--입고 처리 대상 목록을 확인하고, 항목을 선택해 입고를 진행할 수 있습니다.--></div>
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
          <th><%=CommonLang.get("HTITLE423")%><!-- 기간 --></th>
          <td colspan="3">
            <select name="st_date_type" id="st_date_type_2" class="Select40" style=" float:left; width:132px; margin-right:7px">
              <option value="PO_DATE"><%=CommonLang.get("HTITLE185") %><!-- 주문일 --></option>
              <option value="PR_DATE"><%=CommonLang.get("HTITLE1235") %><!-- 주문요청일 --></option>
            </select>               
            <div class="Buyer-datepicker-wrap" style=" width:231px; margin-right:8px">
              <div class="Buyer-date-input"  data-datepicker><input style=" " type="text" placeholder="" readonly id="st_from_date_2" name="st_from_date"/><span> </span></div>
              <span class="Buyer-dash">~</span>
              <div class="Buyer-date-input" data-datepicker><input type="text" placeholder="" readonly id="st_to_date_2" name="st_to_date"/><span></span></div>
            </div>
            <!--div class="Buyer-datepicker-wrap" style=" width:120px">
              <div class="Buyer-date-input" data-monthpicker><input type="text" placeholder="" readonly /><span>1</span></div>
            </div-->               
            <button class="But_Month" style="width:73px" onclick="javascript:kepMonth_v2('st_from_date_2','st_to_date_2','1'); return false;">1<%=CommonLang.get("HTITLE602") %><!-- 개월 --></button> 
            <button class="But_Month" style="width:73px" onclick="javascript:kepMonth_v2('st_from_date_2','st_to_date_2','2'); return false;">2<%=CommonLang.get("HTITLE602") %><!-- 개월 --></button>
            <button class="But_Month" style="width:73px" onclick="javascript:kepMonth_v2('st_from_date_2','st_to_date_2','3'); return false;">3<%=CommonLang.get("HTITLE602") %><!-- 개월 --></button>
            <button class="But_Month" style="width:73px" onclick="javascript:kepMonth_v2('st_from_date_2','st_to_date_2','12'); return false;">1<%=CommonLang.get("HTITLE424") %><!-- 년 --></button>
          </td>
          <th><%=CommonLang.get("HTITLE18")%><!-- 관리번호 --></th>
		  <td>
          	<input type="text"  class="input40" name="st_ref_pr_no" id="st_ref_pr_no_2" value=""  style=" width:278px;" onKeyDown="kepEnter_v3('buyerWmGrWarehousingLis_tab2')">
          	<input type="hidden" id="st_ref_pr_no_text_2" name="st_ref_pr_no_text" value="">
            <input type="hidden" id="st_legacy_po_no_2" name="st_legacy_po_no" value="">
            <input type="hidden" id="st_buyer_item_no_2" name="st_buyer_item_no" value="">
            <input type="hidden" id="st_change_user_id_2" name="st_change_user_id" value="">
            <input type="hidden" name="st_acnt_cd" id="st_acnt_cd_2" value="">
<%--           <th><%=CommonLang.get("HTITLE136") %><!-- 진행상태 --></th> --%>
<!--           <td> -->
<!--             <select name="st_gr_status"  id="st_gr_status_2" class="Select40" style="width:300px;"> -->
<%--             	<option value=""><%=CommonLang.get("HTITLE29") %><!-- 전체 --></option> --%>
<%--             	<option value="GC"><%=CommonLang.get("HTITLE201") %><!-- 입고완료 --></option> --%>
<%--             	<option value="GP"><%=CommonLang.get("HTITLE200") %><!-- 부분입고 --></option> --%>
<!--             </select>   -->
<!--           </td> -->
        </tr>
		<tr>
		  <th>
		  	<select name="st_user_type" id="st_user_type_2" class="Select40" style=" float:left;width:120px; margin-right:5px" <%if(poUserFix.equals("Y")||prUserFix.equals("Y")) {%> disabled <%} %>>
              <option value="PO" <%if(poUserFix.equals("Y")){%> selected <%} %>><%=CommonLang.get("HTITLE187") %><!-- 발주자 --></option>
              <option value="PR" <%if(prUserFix.equals("Y")){%> selected <%} %>><%=CommonLang.get("HTITLE133") %><!-- 요청자 --></option>
            </select> 
		  </th>					
          <td>
            <input type="text"  class="input40" name="st_po_user_name" id="st_po_user_name_2" value="<%=po_user_name %>"  style=" width:240px;" onKeyDown="kepEnter_v3('buyerWmGrWarehousingLis_tab2')" <%if(poUserFix.equals("Y")||prUserFix.equals("Y")) {%> readonly <%} %>>
          	<input type="hidden" name="st_po_user_id" 	id="st_po_user_id_2" 	value="<%=po_user_id%>" />
          </td>
          <th>
          	<select name="st_dept_type" id="st_dept_type_2" class="Select40" style=" float:left;width:120px; margin-right:5px">
              <option value="PR"><%=CommonLang.get("HTITLE135") %><!-- 요청부서 --></option>
              <option value="PO"><%=CommonLang.get("HTITLE188") %><!-- 발주부서 --></option>
              <%if(sessionBudget_flag.equals("Y")){ %>
			   <option value="BD"><%=CommonLang.get("HTITLE268")%><!-- 예산부서 --></option>
			  <%}%>
            </select>
          </th>
          <td><div class="TabShIconTwo" style="width:270px ">
            <input type="text"  name="st_req_dept_name" id="st_req_dept_name_2" value="<%=req_dept_name %>"  style=" width:202px;" readonly>
            <input type="hidden" name="st_req_dept_code" id="st_req_dept_code_2" value="<%=req_dept_code%>">
            <%if(deptFix.equals("N")) {%>
            <button class="Search" type="button" onclick="javascript:tabs.buyerWmGrWarehousingLis_tab2.doPop('department'); return false;"></button><button class="Delete" type="button" onclick="javascript:tabs.buyerWmGrWarehousingLis_tab2.doAction('departmentErase'); return false;"></button></div></td>
		  	<%} %>
	          <th><%=CommonLang.get("HTITLE1338") %><!-- 배송완료여부  --></th>
		      <td>
			      <select name="st_di_yn" id="st_di_yn_2" class="Select40" style=" float:left; width:300px; margin-right:7px" <%if(p070000030) {%> disabled <%} %>>
			        <option value=""><%=CommonLang.get("HTITLE29") %><!-- 전체 --></option>
			        <option value="Y" <%if(p070000030){ %> selected <%} %>><%=CommonLang.get("HTITLE1291") %><!-- 완료 --></option>
			        <option value="N"><%=CommonLang.get("HTITLE1292") %><!-- 미완료 --></option>
			       </select>
		      </td>
		</tr>
		<tr>
			<th>
		  	<select name="st_no_type" id="st_no_type_2" class="Select40" style=" float:left;width:120px; margin-right:5px">
              	<option value = "PO" ><%=CommonLang.get("HTITLE203")%><!-- 발주번호 --></option>
				<option value = "IV"><%=CommonLang.get("HTITLE271")%><!-- 송장번호 --> </option>
				<option value = "PR"><%=CommonLang.get("HTITLE216")%><!-- 요청번호 --> </option>
            </select> 
		  </th>
		  <td>
            <input type="text"  class="input40" name="st_search_no" id="st_search_no_2" value=""  style=" width:240px;" onKeyDown="kepEnter_v3('buyerWmGrWarehousingLis_tab2')">
          </td>
          <th><select name="st_no_type2" id="st_no_type2_2" class="Select40" style=" float:left;width:120px; margin-right:5px">
              <option value="ITEMNAME"><%=CommonLang.get("HTITLE13") %><!-- 품목명 --></option>
              <option value="ITEMNO"><%=CommonLang.get("HTITLE12") %><!-- 품목코드 --></option>
              <option value="SPECIFICATION"><%=CommonLang.get("HTITLE14") %><!-- 규격 --></option>
            </select> </th>
          <td>
            <input class="input40" style="width:250px" name="st_search_no2" type="text" onKeyDown="kepEnter_v3('buyerWmGrWarehousingLis_tab2')"/>
          </td>
          <%if(group_mng_flag.equals("Y")) {%>
	          <th><%=CommonLang.get("HTITLE604") %><!-- 고객사 --></th>
		      <td>
			      <select name="st_com_code" id="st_com_code_2" class="Select40" style=" float:left; width:300px; margin-right:7px" onchange="javascript:tabs.buyerWmGrWarehousingLis_tab2.buyerChange();">
			        <%= CommonUtil.getCode3ComboList(request.getParameter("buyer"), "ALL", "TGCM",request.getParameter("userId"), "ICOMCOD3", request.getParameter("buyer"), "") %>
			       </select>
		      </td>
			<%}else{ %>
			  <input type="hidden" name="st_com_code" id="st_com_code_2" value="${sessionInfo.comCode}">
			<%} %>
		</tr>
      </table>
      <div class="SearchBtnBox">
        <button class="ButOutline_Medium" onclick="javascript:tabs.buyerWmGrWarehousingLis_tab2.reload(); return false;"><%=CommonLang.get("HTITLE8") %><!-- 초기화 --></button> 
        <button class="ButDarkGray_Medium" onclick="javascript:tabs.buyerWmGrWarehousingLis_tab2.search(); return false;" ><%=CommonLang.get("HTITLE7") %><!-- 조회 --></button> 
      </div>
      <div class="ArraySub mt30 mb10">
      	<div class="buttonLeft">
      	<%if(p170000001 == false){%>
       			<button class="But_ExcelDown40" onclick="tabs.buyerWmGrWarehousingLis_tab2.doAction('excelDown'); return false;"><%=CommonLang.get("HTITLE150") %><!-- 엑셀다운로드 --></button>
        <%} %>
        <button class="ButOutline_Medium" onclick="javascript:tabs.buyerWmGrWarehousingLis_tab2.grDateAll(); return false;"><%=CommonLang.get("HTITLE1501") %><!-- 입고일 일괄등록 --></button>
        </div>
        <div class="buttonRight">
        
        <%if(p110000005 == true){%>
    	    <button class="ButPrimary_Medium" onclick="tabs.buyerWmGrWarehousingLis_tab2.doAction('GrAppSend');return false;"><%=CommonLang.get("HTITLE702") %><!-- 결재상신 --></button>
        <%} %>
        <%if(p070000024 == false){%>
	        <button class="ButPrimary_Medium" onclick="tabs.buyerWmGrWarehousingLis_tab2.doAction('grSave');return false;"><%=CommonLang.get("HTITLE270") %><!-- 입고 --></button>
        <%} %>
        </div>
	  </div>
      <div class="IBSheetBuyer">
      	<script type="text/javascript">
          	createIBSheet("mySheet2", "", "100%");
        </script>
      </div><!--IBSheetBuyer 끝 -->
      <div class="ArraySub mt10">
        <div class="buttonRight"><span class="allprice" id="tot_amt_2"></span></div>
	   </div>
      <div class="PagingCenter mt10" id="pageindex2"></div> 
      <div class="h50"></div>         
    </div><!--Tab2끝 -->
    
    <div class="DIVpopup-overlay popupOverlay" id="grDateSelOverlay" style="display: none;"></div>
	<div class="DIVpopup" id="grDateSel" style="display: none;">
	  <div class="wrapPopupAlert small-calendar">
	    <div class="AlertTxtSmall" style="display: flex; flex-direction:column; align-items:center;">
	    <div class="OptionTit_Date"><%=CommonLang.get("HTITLE283") %><!-- 입고일 --></div>
	        <div class="datepicker-wrap" style=" width:150px; margin-right:8px"><div class="date-input" data-datepicker style=" width:140px;"><input type="text" id="imsi_gr_date_2" name="imsi_gr_date_2" placeholder="" readonly /><span> </span></div></div>
	    </div>
	    <div class="h20"></div>
	    <div class="PopupListBtnBox_Center">
	      <button class="ButQuaternary_large" style=" width:100px" onclick="javascript:tabs.buyerWmGrWarehousingLis_tab2.grDateCancel(); return false;"><%=CommonLang.get("HTITLE229") %><!-- 취소 --></button>
	         <button class="ButPrimary_large" style=" width:100px" onclick="javascript:tabs.buyerWmGrWarehousingLis_tab2.grDateSel(); return false;"><%=CommonLang.get("HTITLE516") %><!-- 확인 --></button>
	    </div>
	  </div>
	</div>
</form>
<form name="processForm_2" id="processForm_2" method="post">	
	<input type="hidden" name="st_buyer" id="st_buyer" value="">
	<input type="hidden" name="st_pr_no" id="st_pr_no" value="">
	<input type="hidden" name="st_pr_seq" id="st_pr_seq" value="">
	<input type="hidden" name="st_pf_my_group" id="st_pf_my_group" value="">
	<input type="hidden" name="st_use_flag" id="st_use_flag" value="">
	<input type="hidden" name="st_query2" id="st_query2" value="">
	<input type="hidden" name="st_dup_add_flag" id="st_dup_add_flag" value="">
</form> 
<form name="refPrNoForm_2" id="refPrNoForm_2" method="post">	
	<input type="hidden" name="st_buyer" id="st_buyer_2" value="">
	<input type="hidden" name="st_ref_no" id="st_ref_no_2" value="">
	<input type="hidden" name="st_type" id="st_type_2" value="">
	<input type="hidden" name="st_form" id="st_form_2" value="<%=p060000029_form%>">
	<input type="hidden" name="st_pop_type" id="st_pop_type_2" value="<%=p060000029_type%>">
	<input type="hidden" name="st_gbn" id="st_gbn_2" value="">
	<input type="hidden" name="st_title" id="st_title_2" value="">
	<input type="hidden" name="open" id="open_2" value="Y">
	<input type="hidden" name="no_remark" id="no_remark_2" value="Y">
	<input type="hidden" name="st_tab_id" id="st_tab_id_2" value="buyerWmGrWarehousingLis_tab2">
</form>
