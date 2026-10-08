<%--
**********************************************
* 메뉴 : 입고관리
* 화면 : 입고현황 탭
* 기능 : 입고현황 탭
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
	
	extrReportBtn	= CommonUtil.nvl(_sLogicMap.get("EXTR_REPORT_BTN"));
	extrReportId 	= CommonUtil.nvl(_sLogicMap.get("EXTR_REPORT_ID"));
	clsdDnldYn 		= CommonUtil.nvl(_sLogicMap.get("CLSD_DNLD_YN"));
	
	
} else {
	
	rowCntYn 	= CommonUtil.nvl((String)request.getParameter("st_row_cnt_yn"));
	cardYn 		= CommonUtil.nvl((String)request.getParameter("st_card_yn"));
	deptFix 	= CommonUtil.nvl((String)request.getParameter("st_dept_fix"));
	prUserFix 	= CommonUtil.nvl((String)request.getParameter("st_pr_user_fix")); 
	poUserFix 	= CommonUtil.nvl((String)request.getParameter("st_po_user_fix"));
	
	extrReportBtn	= CommonUtil.nvl((String)request.getParameter("st_extr_report_btn"));
	extrReportId 	= CommonUtil.nvl((String)request.getParameter("st_extr_report_id"));
	clsdDnldYn 		= CommonUtil.nvl((String)request.getParameter("st_clsd_dnld_yn"));
	
}

@SuppressWarnings (value="unchecked")
List<Map<String,String>> _gridList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된 결과

String total_cnt = CommonUtil.nvlObj((List<Map<String,String>>) _gridList ,"0"); // 총 조회수 (필수)

String st_legacy_po_no = CommonUtil.nvl((String)request.getParameter("st_legacy_po_no"),"");  
String st_ref_pr_no = CommonUtil.nvl((String)request.getParameter("st_ref_pr_no"),"");  
String st_buyer_item_no = CommonUtil.nvl((String)request.getParameter("st_buyer_item_no"),"");
String st_check_date = CommonUtil.nvl((String)request.getParameter("st_check_date"),"");

String pg_row = CommonUtil.nvl((String)request.getParameter("st_pg_row"), "10");
String pg_no = CommonUtil.nvl((String)request.getParameter("st_page"), "1");
String tot_cnt_string = "";

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
String p070000011 = CommonUtil.getSpecialCheckReturn(request.getParameter("buyer"),"P07-0000011","COL01_DATA"); // 엑셀다운로드 유형
String p070000017 = CommonUtil.getSpecialCheckReturn(request.getParameter("buyer"),"P07-0000017","COL01_DATA");
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
	
	//마감거래명세서 출력
	String bgr00001 =  CommonUtil.getSpecialCheckReturn(request.getParameter("buyer"),"BGR00001","COL01_DATA");
	
	boolean bgr00002 = CommonUtil.getSpecialCheckReturn(request.getParameter("buyer"),"BGR00002");
%>
<script type="text/javascript">
var mySheet1 = new ibsheetObject();
window.tabs = window.tabs || {};
tabs.buyerWmGrWarehousingLis_tab1 = {
	//alert layer용
	but1text : "<%=CommonLang.get("HTITLE516")%>",/* 확인 */
	but1func : "javascript:closePopText2(); return false;",
	but1funcSearch : "javascript:tabs.buyerWmGrWarehousingLis_tab1.thisPopClose(); return false;",
	but1width : "120px",
	pagingMode : "N",
	current_page : "1",
	popupSel : "",
	grbRow : "",
	grbStatus: "",
	init:function(){
		if($("#st_from_date_1").val() ==  ""){
			var now = new Date();
			this.setMonthRange(now.getFullYear(), now.getMonth());
// 			$("#st_from_date_1").val(kepToMonthAdd("1","M"));
// 			$("#st_to_date_1").val(kepGetNowTimeStr('YYYYMMDD','/'));
		}
		
		var initsheet1 = {};
		initsheet1.Cfg = {MergeSheet:msHeaderOnly,     HeaderRowHeight: 50, DataRowHeight: 30,    Alternate : 0,UseNoDataRow:1, FrozenCol:2};
		initsheet1.Cols = [
				 { Align:"Center",	SaveName:"sStatus",				Header:"<%=CommonLang.get("HTITLE255")%>",				Type:"Status",		Width:60,	Edit:false,	EditLen:0,		Hidden:true} /*상태*/
				,{ Align:"Center",	SaveName:"SELECTED",			Header:"",					Type:"DummyCheck",	Width:40,	Edit:true,	EditLen:100,	Hidden:false}
				,{ Align:"Center",	SaveName:"GR_STATUS",				Header:"<%=CommonLang.get("HTITLE136")%>",				Type:"Text",		Width:100,	Edit:false,	EditLen:100,	Hidden:false} /*진행상태*/
				,{ Align:"Center",	SaveName:"AR_BILL_YN",				Header:"<%=CommonLang.get("HTITLE1455")%>",				Type:"Text",		Width:100,	Edit:false,	EditLen:100,	Hidden:false} /*계산서발행여부*/
				,{ Align:"Left",	SaveName:"COM_NAME_LOC",		Header:"<%=CommonLang.get("HTITLE291")%>",				Type:"Text",		Width:120,	Edit:false,	EditLen:100,	Hidden:true} /*고객사명*/
				,{ Align:"Center",	SaveName:"PR_NO",		Header:"<%=CommonLang.get("HTITLE1179")%>",				Type:"Text",		Width:100,	Edit:false,	EditLen:100,	Hidden:false, FontColor:"#3a72c7", Cursor:"Pointer"} /*주문요청번호*/
				,{ Align:"Center",	SaveName:"PO_NO",			Header:"<%=CommonLang.get("HTITLE203")%>",				Type:"Text",		Width:100,	Edit:false,	EditLen:100,	Hidden:false , FontColor:"#3a72c7", Cursor:"Pointer"} /*발주번호*/
				,{ Align:"Center",	SaveName:"INV_NO",				Header:"<%=CommonLang.get("HTITLE784")%>",				Type:"Text",		Width:100,	Edit:false,	EditLen:100,	Hidden:false , FontColor:"#3a72c7", Cursor:"Pointer"} /*거래명세서번호*/
				,{ Align:"Left",	SaveName:"REF_PR_NO",				Header:"<%=CommonLang.get("HTITLE18")%>",				Type:"Text",		Width:100,	Edit:false,	EditLen:100,	Hidden:false} /*관리번호*/
				,{ Align:"Left",	SaveName:"BUYER_ITEM_NO",				Header:"<%=CommonLang.get("HTITLE12")%>",				Type:"Text",		Width:100,	Edit:false,	EditLen:100,	Hidden:false} /*품목코드*/
				,{ Align:"Left",	SaveName:"DESCRIPTION",				Header:"<%=CommonLang.get("HTITLE13")%>",				Type:"Text",		Width:120,	Edit:false,	EditLen:100,	Hidden:false} /*품목명*/
				,{ Align:"Left",	SaveName:"SPECIFICATION",				Header:"<%=CommonLang.get("HTITLE14")%>",				Type:"Text",		Width:150,	Edit:false,	EditLen:100,	Hidden:false} /*규격*/
				,{ Align:"Right",	SaveName:"UNIT_PRICE",				Header:"<%=CommonLang.get("HTITLE174")%>",				Type:"Float",		Width:90,	Edit:false,	EditLen:100,	Hidden:false, Format:"${priceFormat}"}/*단가*/
				,{ Align:"Center",	SaveName:"UNIT_MEASURE",				Header:"<%=CommonLang.get("HTITLE52")%>",				Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:false}/*단위*/
				,{ Align:"Right",	SaveName:"PO_ITEM_QTY",				Header:"<%=CommonLang.get("HTITLE217")%>",				Type:"Float",		Width:90,	Edit:false,	EditLen:100,	Hidden:false}/*발주수량*/
				,{ Align:"Right",	SaveName:"ITEM_AMT",				Header:"<%=CommonLang.get("HTITLE1059")%>",				Type:"Float",		Width:90,	Edit:false,	EditLen:100,	Hidden:false, Format:"${priceFormat}"}/*주문금액*/
				,{ Align:"Right",	SaveName:"GR_QTY",				Header:"<%=CommonLang.get("HTITLE280")%>",				Type:"Float",		Width:90,	Edit:false,	EditLen:100,	Hidden:false}/*총입고수량*/
				,{ Align:"Right",	SaveName:"GR_ITEM_QTY",				Header:"<%=CommonLang.get("HTITLE211")%>",				Type:"Float",		Width:90,	Edit:false,	EditLen:100,	Hidden:false}/*입고수량*/
				,{ Align:"Center",	SaveName:"GR_DATE",			Header:"<%=CommonLang.get("HTITLE283")%>",				Type:"Date",		Width:100,	Edit:false,	EditLen:100,	Hidden:false,Format:"yyyy-MM-dd"} /*입고일*/
				,{ Align:"Center",	SaveName:"PR_CHANGE_DATE",			Header:"<%=CommonLang.get("HTITLE1235")%>",				Type:"Date",		Width:100,	Edit:false,	EditLen:100,	Hidden:false,Format:"yyyy-MM-dd"} /*주문요청일*/
				,{ Align:"Center",	SaveName:"PO_CREATE_DATE",			Header:"<%=CommonLang.get("HTITLE185")%>",				Type:"Date",		Width:100,	Edit:false,	EditLen:100,	Hidden:false,Format:"yyyy-MM-dd"} /*주문일*/
				,{ Align:"Left",	SaveName:"PR_USER_NAME",				Header:"<%=CommonLang.get("HTITLE133")%>",				Type:"Text",		Width:100,	Edit:false,	EditLen:100,	Hidden:false} /*요청자*/
				,{ Align:"Left",	SaveName:"REQ_DEPT_NAME",				Header:"<%=CommonLang.get("HTITLE135")%>",				Type:"Text",		Width:100,	Edit:false,	EditLen:100,	Hidden:false} /*요청부서*/
				,{ Align:"Left",	SaveName:"PO_CREATOR",				Header:"<%=CommonLang.get("HTITLE187")%>",				Type:"Text",		Width:100,	Edit:false,	EditLen:100,	Hidden:false} /*발주자*/
				,{ Align:"Left",	SaveName:"PO_CREATE_DEPT_NAME",				Header:"<%=CommonLang.get("HTITLE188")%>",				Type:"Text",		Width:100,	Edit:false,	EditLen:100,	Hidden:false} /*발주부서*/
				,{ Align:"Left",	SaveName:"GR_ADD_USER_NAME",				Header:"<%=CommonLang.get("HTITLE674")%>",				Type:"Text",		Width:100,	Edit:false,	EditLen:100,	Hidden:false} /*입고자*/
				,{ Align:"Left",	SaveName:"BUDGET_DEPT",			Header:"<%=CommonLang.get("HTITLE268")%>",				Type:"Text",		Width:100,	Edit:false,	EditLen:100,	Hidden:true} /*예산부서*/
				,{ Align:"Left",	SaveName:"ACCOUNT_NAME",				Header:"<%=CommonLang.get("HTITLE966")%>",				Type:"Text",		Width:100,	Edit:false,	EditLen:100,	Hidden:true} /*예산계정*/
				,{ Align:"Left",	SaveName:"PARCEL_INFO",				Header:"<%=CommonLang.get("HTITLE673")%>",				Type:"Text",		Width:120,	Edit:false,	EditLen:100,	Hidden:true} /*택배사정보*/
				,{ Align:"Center",	SaveName:"IMAGE_KEY_BUTTON",			Header:"<%=CommonLang.get("HTITLE675")%>",				Type:"Button",		Width:100,	Edit:false,	EditLen:100,	Hidden:true,ClassName:'Type03'}/*배송증빙*/
				,{ Align:"Center",	SaveName:"AGENT_NAME",			Header:"<%=CommonLang.get("HTITLE567")%>",				Type:"Text",		Width:120,	Edit:false,	EditLen:100,	Hidden:false, FontColor:"#3a72c7", Cursor:"Pointer"}/*협력사명*/
				,{ Align:"Center",	SaveName:"CART_BUTTON",			Header:"<%=CommonLang.get("HTITLE11")%>",				Type:"Image",		Width:80,	Edit:false,	EditLen:100,	Hidden:false,Cursor:"Pointer", ImgHeight:20}/*장바구니*/
				,{ Align:"Center",	SaveName:"CANCEL_BUTTON",			Header:"<%=CommonLang.get("HTITLE279")%>",				Type:"Button",		Width:100,	Edit:false,	EditLen:100,	Hidden:false,ClassName:'Type03'}/*입고취소*/
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
				,{ Align:"Center",	SaveName:"GR_SEQ",			Header:"GR_SEQ",				Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
				,{ Align:"Center",	SaveName:"GR_NO",			Header:"GR_NO",				Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
				,{ Align:"Center",	SaveName:"INV_SEQ",			Header:"INV_SEQ",				Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
				
				,{ Align:"Center",	SaveName:"AUTO_GR_FLAG",			Header:"AUTO_GR_FLAG",				Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
				,{ Align:"Center",	SaveName:"BUDGET_DEPT_CODE",			Header:"BUDGET_DEPT_CODE",				Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
				,{ Align:"Center",	SaveName:"ACCOUNT_TYPE",			Header:"ACCOUNT_TYPE",				Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
				,{ Align:"Center",	SaveName:"PX_NO",			Header:"PX_NO",				Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
				,{ Align:"Center",	SaveName:"GW_NO",			Header:"GW_NO",				Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
				,{ Align:"Center",	SaveName:"IMAGE_KEY_INV",			Header:"IMAGE_KEY_INV",				Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
				,{ Align:"Center",	SaveName:"IMAGE_KEY_SIGN",			Header:"IMAGE_KEY_SIGN",				Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
				,{ Align:"Center",	SaveName:"WAREHOUSE_CODE",			Header:"WAREHOUSE_CODE",				Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
				,{ Align:"Center",	SaveName:"AR_BILL_FLAG",			Header:"AR_BILL_FLAG",				Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
				,{ Align:"Center",	SaveName:"GR_LOCK_FLAG",			Header:"GR_LOCK_FLAG",				Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
				,{ Align:"Center",	SaveName:"CLSD_FLAG",			Header:"CLSD_FLAG",				Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
				,{ Align:"Center",	SaveName:"IV_EXIST",			Header:"IV_EXIST",				Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
				
				
				
		];
		
		IBS_InitSheet(mySheet1, initsheet1, this.pagingMode);
		mySheet1.SetHighlightAfterSort(2);
		
		mySheet1.SetHeaderBackColor("#f2f7ff");
		mySheet1.SetTheme("DB", "DeepBlue");
		
		this.setUserList("load");
		
		
	},
	search:function(value){
		if (kep_dateSearchCheck($("#st_from_date_1").val(),$("#st_to_date_1").val()) == false) return;
		var diff = kepGetDateDiff('st_from_date_1','st_to_date_1','D');
		if (eval(diff)>372){
			var text = "<%=CommonLang.msg("MSG617")%>";//1년 이내 조회만 가능합니다.
			openLayerPopText2(text,this.but1text,this.but1func,this.but1width);
			return;
		}
		$("#st_all_page_1").val("N");
		$("#st_excel_type_1").val("");
		
		var com_code = $("#st_com_code_1").val();
		if(com_code.indexOf("GROUP") >=0){
			$("#st_group_info_1").val(com_code);
		}else{
			$("#st_group_info_1").val("");
		}
		this.current_page = 1;
		kepSearch_v2(document.searchCondition1, mySheet1, "/wmgr/getBuyerWmGrWarehousingLisList_v3.do?page="+this.current_page, this.pagingMode);
	},
	reload:function(){
		kepReload_v2('searchCondition1');
		kepMonth_v2('st_from_date_1','st_to_date_1','1');
		$("#st_pur_dept_code_1").val("");
		$("#st_req_dept_code_1").val("");
		$("#st_dept_code_1").val("");
		$("#st_ref_pr_no_1").val("");
		$("#st_ref_pr_no_text_1").val("");
		$("#st_acnt_cd_1").val("");
		mySheet1.RemoveAll();
		
		var now = new Date();
		this.setMonthRange(now.getFullYear(), now.getMonth());
		
		$("#tot_amt").html("<%=CommonLang.get("HTITLE1469")%>"+ " : "+"0"+"<%=CommonLang.get("HTITLE660")%>");// 합계금액 : 0원
	},
	addMonth:function(flag){
		var dateFrom = $("#st_from_date_1").val().replace(/\//gi,'');
		var yyyy = parseInt(dateFrom.substring(0,4), 10);
		if(flag=="plus"){//+1
			var mm = parseInt(dateFrom.substring(4,6), 10) + 1;
		}else if(flag == "minus"){ //-1
			var mm = parseInt(dateFrom.substring(4,6), 10) - 1;
		}else{ //당월
			var now = new Date();
			var mm = now.getMonth()+1;
		}

		this.setMonthRange(yyyy, mm - 1);
	},
	setMonthRange:function(year, month) {
		var now = new Date();
		var curMonth = now.getMonth();
		var firstDay = new Date(year, month, 1);
		var lastDay = new Date(year, month + 1, 0);
		$("#st_from_date_1").val(this.fmtDate(firstDay));
		if(curMonth == month){
			$("#st_to_date_1").val(kepGetNowTimeStr('YYYYMMDD','/')); //현재 월이면 현재 날짜
		}else{
			$("#st_to_date_1").val(this.fmtDate(lastDay)); //현재 월 아니면 말일
		}
	},
	fmtDate:function(d) {
		var m = ("0" + (d.getMonth() + 1)).slice(-2);
		var day = ("0" + d.getDate()).slice(-2);
		return d.getFullYear() + "/" + m + "/" + day;
	},
	doAction:function(str,value1){
		switch (str) {
		case "reqDepartmentErase":
			$("#st_req_dept_code_1").val("");
			$("#st_req_dept_name_1").val("");
			break;
		case "purDepartmentErase":
			$("#st_pur_dept_code_1").val("");
			$("#st_pur_dept_name_1").val("");
			break;
		case "refPrNoErase":
			$("#st_ref_pr_no_1").val("");
			$("#st_ref_pr_no_text_1").val("");
			break;
		case "grCancel":
			this.grCancel();
			break;
		case "departmentErase":
			$("#st_req_dept_code_1").val("");
			$("#st_req_dept_name_1").val("");
			break;
		case "acntCdErase":
			$("#st_acnt_cd_1").val("");
			$("#st_acnt_nm_1").val("");
			break;
		case "excelDown":
			if (kep_dateSearchCheck($("#st_from_date_1").val(),$("#st_to_date_1").val()) == false) return;
			var diff = kepGetDateDiff('st_from_date_1','st_to_date_1','D');
			if (eval(diff)>372){
				var text = "<%=CommonLang.msg("MSG617")%>";//1년 이내 조회만 가능합니다.
				openLayerPopText2(text,this.but1text,this.but1func,this.but1width);
				return;
			}
			
			if(value1 == "DEFAULT"){
				$("#st_excel_type_1").val("");
			}else{
				$("#st_excel_type_1").val(value1);
			}
			$("#st_all_page_1").val("Y");
			
			document.forms.searchCondition1.action = "/wmgr/excelBuyerWmGrWarehousingLisList_v2.do";
			document.forms.searchCondition1.submit();
			break;
		case "excelDownClose":
			if (kep_dateSearchCheck($("#st_from_date_1").val(),$("#st_to_date_1").val()) == false) return;
			var diff = kepGetDateDiff('st_from_date_1','st_to_date_1','D');
			if (eval(diff)>372){
				var text = "<%=CommonLang.msg("MSG617")%>";//1년 이내 조회만 가능합니다.
				openLayerPopText2(text,this.but1text,this.but1func,this.but1width);
				return;
			}
			
			$("#st_close_excel_type_1").val("");
			document.forms.searchCondition1.action = "/wmgr/excelBuyerWmGrWarehousingLisCloseList.do";
			document.forms.searchCondition1.submit();
			
			break;
		case "excelDownClose1":
			if (kep_dateSearchCheck($("#st_from_date_1").val(),$("#st_to_date_1").val()) == false) return;
			var diff = kepGetDateDiff('st_from_date_1','st_to_date_1','D');
			if (eval(diff)>372){
				var text = "<%=CommonLang.msg("MSG617")%>";//1년 이내 조회만 가능합니다.
				openLayerPopText2(text,this.but1text,this.but1func,this.but1width);
				return;
			}
			
			$("#st_close_excel_type_1").val("TYPE2");
			document.forms.searchCondition1.action = "/wmgr/excelBuyerWmGrWarehousingLisCloseList.do";
			document.forms.searchCondition1.submit();
			
			break;
		default:
			break;
		}
	},
	doPop:function(str,value1,value2,value3,value4){
		this.popupSel = str;
		var com_code = $("#st_com_code_1").val();
		if(com_code == ""){
			var text = "<%=CommonLang.msg("MSG239")%>";//고객사를 전체 아닌 값으로 선택해야 합니다.
			openLayerPopText2(text,this.but1text,this.but1func,this.but1width);
			return;
		}
		switch (str) {
		case "purDepartment":
			openSearchPopup('/common/deptCodeAdminPop.do', "?open=Y&com_code="+com_code+"&tab_id=buyerWmGrWarehousingLis_tab1", "720,580,no"); 
			break;
		case "reqDepartment":
			openSearchPopup('/common/deptCodeAdminPop.do', "?open=Y&com_code="+com_code+"&tab_id=buyerWmGrWarehousingLis_tab1", "720,580,no"); 
			break;
		case "purUser":
			openSearchPopup('/common/misUserSelectDeptPop.do', '?open=Y&com_code='+com_code+'&dept_code='+"&tab_id=buyerWmGrWarehousingLis_tab1", "780,550,no");
			break;
		case "reqUser":
			openSearchPopup('/common/misUserSelectDeptPop.do', '?open=Y&com_code='+com_code+'&dept_code='+"&tab_id=buyerWmGrWarehousingLis_tab1", "780,550,no");
			break;
		case "department":
			openSearchPopup('/common/deptCodeAdminPop.do', "?open=Y&com_code="+com_code+"&tab_id=buyerWmGrWarehousingLis_tab1", "720,580,no"); 
			break;
		case "refPrNo":
			var buyer  = $("#st_com_code_1").val();
			var ref_no = $("#st_ref_pr_no_1").val();
			//TYPE4,7 은 해당 타이틀과 컬럼명
			var st_gbn = "<%=CommonLang.get("HTITLE1260")%>"; //Cost Center 명
			var st_title = "<%=CommonLang.get("HTITLE1259")%>"; //CostCenter
			
			$("#st_buyer_1").val(buyer);
			$("#st_ref_no_1").val(ref_no);
			$("#st_type_1").val("M014");

			if($("#st_pop_type_1").val() == "TYPE5"){
				st_title = "<%=CommonLang.get("HTITLE1436")%>";//하이트진로㈜ 이천공장 현장소모품 팀
				st_gbn = "<%=CommonLang.get("HTITLE1437")%>";//현장소모품팀
			}
			
			$("#st_gbn_1").val(st_gbn);
			$("#st_title_1").val(st_title);
			openSearchPopupPost("/common/showBuyerRefPrNoPop_v2.do","refPrNoForm_1","showBuyerRefPrNoPop_v2","width=695,height=500,resizable=no,scrollbars=no");
			break;
		case "acntCd":
			var st_gbn = "<%=CommonLang.get("HTITLE1497")%>"; //비용계정
			var st_type = "Z014";
			var st_code =  "";
			var st_text =   "";
			openSearchPopup("/common/getCode2PopSearchPop.do","?st_buyer="+com_code+"&st_gbn="+st_gbn+"&st_type="+st_type+"&st_code="+st_code+"&st_text="+st_text+"&st_tab_id=buyerWmGrWarehousingLis_tab1", "700,510,no");
			break;
		default:
			break;
		}
	},
	saveBuyerPrCancel:function(){
		closePopText1();
		document.forms.processForm_1.st_buyer.value = mySheet1.GetCellValue(this.grbRow,"BUYER");
		document.forms.processForm_1.st_pr_no.value = mySheet1.GetCellValue(this.grbRow,"PR_NO");
		document.forms.processForm_1.st_pr_seq.value = mySheet1.GetCellValue(this.grbRow,"PR_SEQ");
		kepAjaxFormCallTab("/mpso/saveBuyerPrCancel.do","processForm_1","SAVE","buyerWmGrWarehousingLis_tab1");
	},
	pageSearch:function(param){
		$("#st_all_page_1").val("N");
		this.current_page = param.page;
		kepSearch_v2(document.searchCondition1, mySheet1, "/wmgr/getBuyerWmGrWarehousingLisList_v3.do?page="+this.current_page, this.pagingMode);
	},
	setPopupReturn:function(value1,value2,value3){
		if (this.popupSel == "purDepartment") {
			$("#st_pur_dept_code_1").val(value1);
			$("#st_pur_dept_name_1").val(value2);
		}else if(this.popupSel == "reqDepartment") {
			$("#st_req_dept_code_1").val(value1);
			$("#st_req_dept_name_1").val(value2);
		}else if(this.popupSel == "purUser") {
			$("#st_pur_user_id_1").val(value1);
			$("#st_pur_user_name_1").val(value2);
		}else if(this.popupSel == "reqUser") {
			$("#st_req_user_id_1").val(value1);
			$("#st_req_user_name_1").val(value2);
		}else if(this.popupSel == "department") {
			$("#st_req_dept_code_1").val(value1);
			$("#st_req_dept_name_1").val(value2);
		}else if(this.popupSel == "refPrNo"){ // value1 은 st_row , value2 가 code/text
			$("#st_ref_pr_no_1").val(value2);
		}else if(this.popupSel == "acntCd"){
			$("#st_acnt_cd_1").val(value2);
			$("#st_acnt_nm_1").val(value3);
		}
	},
	grCancel:function(){
		var checkRows = mySheet1.FindCheckedRow("SELECTED");
		var arrRow = checkRows.split("|");
		
		if(checkRows == ""){
			//하나 이상의 대상이 선택되어야 합니다.
			var text = "<%=CommonLang.msg("MSG259") %>";
			openLayerPopText2(text,this.but1text,this.but1func,this.but1width);
			return;
		}

		var grRole = '<%=grRole%>';
		
		if(grRole == '-'){
			// 마감 기간으로 입고취소가 불가합니다. KEP담당자에게 문의 부탁드립니다.
			var text = "<%=CommonLang.msg("MSG601") %>";
			openLayerPopText2(text,this.but1text,this.but1func,this.but1width);
			return;		
		}
		
		var user_id = $("#st_user_id_1").val();
		var close_date = document.searchCondition1.st_close_date.value;
		
		var query = "";
		for(var idx = 0; idx<arrRow.length; idx++){
			var gr_date = mySheet1.GetCellValue(arrRow[idx],"GR_DATE");
			var close_flag = mySheet1.GetCellValue(arrRow[idx],"CLOSE_FLAG");
			var ar_bill_flag = mySheet1.GetCellValue(arrRow[idx],"AR_BILL_FLAG");
			var gr_lock_flag = mySheet1.GetCellValue(arrRow[idx],"GR_LOCK_FLAG");
			
			var clsd_flag = mySheet1.GetCellValue(arrRow[idx],"CLSD_FLAG");
			
			var db_auto_gr = mySheet1.GetCellValue(arrRow[idx],"AUTO_GR_FLAG");
			
			if(db_auto_gr == "Y"){
				//번째 입고 자료는 자동입고 처리 건이므로 입고취소가 불가능 합니다.
				var text = (idx+1)+ "<%=CommonLang.msg("MSG248") %>";
				openLayerPopText2(text,this.but1text,this.but1func,this.but1width);
				return;
			}
			if(ar_bill_flag == "Y"){
				//번째 입고 자료는 세금계산서 발행 완료 건으로 입고 취소 하실 수 없습니다.  \n\n운영자에게 문의하시기 바랍니다.
				var text = (idx+1)+ "<%=CommonLang.msg("MSG249") %>";
				openLayerPopText2(text,this.but1text,this.but1func,this.but1width);
				return;
			}
			if(close_date >= gr_date){
				//번째 입고자료는 마감일 이전이어서 입고취소 하실 수 없습니다.  \n\n운영자에게 문의하시기 바랍니다.  
				var text = (idx+1)+ "<%=CommonLang.msg("MSG250") %>";
				openLayerPopText2(text,this.but1text,this.but1func,this.but1width);
				return;
			}
			if(close_flag == "Y"){
				//번째 입고자료는 이미 마감완료 되어 입고취소 하실 수 없습니다.\n\n자세한 사항은 운영자에게 문의하시기 바랍니다. 
				var text = (idx+1)+ "<%=CommonLang.msg("MSG251") %>";
				openLayerPopText2(text,this.but1text,this.but1func,this.but1width);
				return;
			}
			if(clsd_flag == "Y"){
				//번째 입고자료는 상태가 종결되어 입고취소 하실 수 없습니다.
				var text = (idx+1)+ "<%=CommonLang.msg("MSG252") %>";
				openLayerPopText2(text,this.but1text,this.but1func,this.but1width);
				return;
			}
			if(gr_lock_flag == "Y"){
				// 월마감이 종료되어 입고취소 불가합니다.
				var text = (idx+1)+ "<%=CommonLang.msg("MSG586") %>";
				openLayerPopText2(text,this.but1text,this.but1func,this.but1width);
				return;
			}
			
			var com_code = mySheet1.GetCellValue(arrRow[idx],"BUYER");
			var gr_no = mySheet1.GetCellValue(arrRow[idx],"GR_NO");
			var gr_seq = mySheet1.GetCellValue(arrRow[idx],"GR_SEQ");
			var po_no = mySheet1.GetCellValue(arrRow[idx],"PO_NO");
			var po_seq = mySheet1.GetCellValue(arrRow[idx],"PO_SEQ");
			var iv_exist = mySheet1.GetCellValue(arrRow[idx],"IV_EXIST");
			var inv_no = mySheet1.GetCellValue(arrRow[idx],"INV_NO");
			var inv_seq = mySheet1.GetCellValue(arrRow[idx],"INV_SEQ");
			var gr_item_qty = mySheet1.GetCellValue(arrRow[idx],"GR_ITEM_QTY");
			var buyer_item_no = mySheet1.GetCellValue(arrRow[idx],"BUYER_ITEM_NO");
			
			query +=  com_code		+ "@@";
			query +=  user_id		+ "@@";
			query +=  gr_no			+ "@@";
			query +=  gr_seq		+ "@@";
			query +=  po_no			+ "@@";
			query +=  po_seq		+ "@@";
			query +=  iv_exist		+ "@@";
			query +=  inv_no		+ "@@";
			query +=  inv_seq		+ "@@";
			query +=  gr_item_qty	+ "@@";
			query +=  buyer_item_no	+ "@@";
			query +=  "^||^" ;
		}
		
		//선택하신 품목을 입고 취소처리 하시겠습니까?
		var text = "<%=CommonLang.msg("MSG246")%>"; 
		var but1textC = "<%=CommonLang.get("HTITLE516")%>"; //확인
		var but2textC = "<%=CommonLang.get("HTITLE229")%>"; //취소
     	var but1funcC = "javascript:tabs.buyerWmGrWarehousingLis_tab1.grCancelConfirm('"+query+"'); return false;";
     	var but2funcC = "javascript:closePopText1(); return false;";
     	var but1widthC = "120px";
     	var but2widthC = "120px";
     	openLayerPopText(text,but1textC,but2textC,but1funcC,but2funcC,but1widthC,but2widthC);
     	return;
		
		
	},
	grCancelConfirm:function(query){
		closePopText1();
		document.searchCondition1.st_query.value  = query;
        kepAjaxFormCallTab("/wmgr/saveBuyerWmGrWarehousingLisList_v3.do","searchCondition1","btnSave","buyerWmGrWarehousingLis_tab1");
	},
	WoosPracticeView:function(){
		var buyer 					= $("#st_com_code_1").val();
		var search_desc_spec 		= $("#st_search_desc_spec_1").val();
		var search_buyer_item_no	= $("#st_search_buyer_item_no_1").val();
		var fromDate = $("#st_from_date_1").val().replace(/[/]/gi,"");
		var toDate = $("#st_to_date_1").val().replace(/[/]/gi,"");
		var search_agent 			= $("#st_search_agent_1").val();
		var ref_pr_no 				= $("#st_ref_pr_no_1").val();
		var req_dept_code 			= $("#st_req_dept_code_1").val();
		var no_type 				= $("#st_no_type_1").val();
		var search_no 				= $("#st_search_no_1").val();
		var user_type 				= $("#st_user_type_1").val();
		var po_user_id 				= $("#st_po_user_id_1").val();
		var dept_type				= $("#st_dept_type_1").val();
		
		var param = "["+buyer+"]["+fromDate+"]["+toDate+"]["+search_no+"]["+no_type+"]["+ref_pr_no+"]["+po_user_id+"]["+user_type+"]["+req_dept_code+"]["+dept_type+"]["+search_buyer_item_no+"]["+search_desc_spec+"]["+search_agent+"]";
		reportPostOpen("RD_06_S_003_42", param);
	},
	CloseGrSheetFAGSel:function(){
		var bgr00001 = "<%=bgr00001%>";
		var query		= "";

		var buyer		= $("#st_com_code_1").val();
		//var buyer_name	= $("#st_com_name").val();
		var user_id		= $("#st_user_id_1").val();
		var user_name	= $("#st_user_name_1").val();

		var req_dept_code	= $("#st_req_dept_code_1").val();
		var fromDate = $("#st_from_date_1").val().replace(/[/]/gi,"");
		var toDate = $("#st_to_date_1").val().replace(/[/]/gi,"");
		
		var checkRows = mySheet1.FindCheckedRow("SELECTED");
		var arrRow = checkRows.split("|");
		
		if(checkRows == ""){
			//거래명세서를 생성할 목록을 선택 하세요.
			var text = "<%=CommonLang.msg("MSG254") %>";
			openLayerPopText2(text,this.but1text,this.but1func,this.but1width);
			return;
		}
		
		for(var idx=0; idx<arrRow.length; idx++){
			query += mySheet1.GetCellValue(arrRow[idx],"GR_NO");
			query += "@@";
			query += mySheet1.GetCellValue(arrRow[idx],"GR_SEQ");
			query += "@@";
			query += "||";
		}
		
		var param = "["+req_dept_code+"]["+user_id+"]["+user_name+"]["+buyer+"]["+fromDate+"]["+toDate+"]["+query+"]";
		
		if(bgr00001=="TYPE5"){ // 롯데푸드 파스퇴르
			reportPostOpen("RD_06_S_003_47", param);
		}else if(bgr00001 == "TYPE6" || "<%=p070000011%>" == "TYPE5"){ // 기본 마감거래명세서 양식과 동일(RD_06_S_003_39)
			reportPostOpen("RD_06_S_003_48", param);
		}else{
			reportPostOpen("RD_06_S_003_32", param);
		}
	},
	CloseGrSheetFAG:function(){
		var bgr00001 = "<%=bgr00001%>";
		var fromDate = $("#st_from_date_1").val().replace(/[/]/gi,"");
		var toDate = $("#st_to_date_1").val().replace(/[/]/gi,"");
		var req_dept_code 	= $("#st_req_dept_code_1").val();
		var buyer 			= $("#st_com_code_1").val();
		var ref_pr_no 		= $("#st_ref_pr_no_1").val();
		var po_no 			= $("#st_search_no_1").val();
		var po_user_id 		= $("#st_po_user_id_1").val();
		var user_id			= $("#st_user_id_1").val();
		var user_name		= $("#st_user_name_1").val();
		
		var param = "";
			
		if(bgr00001 == "TYPE3"){
			param = "["+fromDate+"]["+toDate+"]["+req_dept_code+"]["+buyer+"]["+ref_pr_no+"]["+po_no+"]["+po_user_id+"]["+user_id+"]["+user_name+"]";
			reportPostOpen("RD_06_S_003_34", param);
		} else {
			param = "["+fromDate+"]["+toDate+"]["+req_dept_code+"]["+buyer+"]["+ref_pr_no+"]["+po_no+"]["+po_user_id+"]";
			reportPostOpen("RD_06_S_003_33", param);
		}
	},
	CloseGrSheetJinRo:function(){
		var bgr00001 = "<%=bgr00001%>";
		var query		= "";

		var fromDate = $("#st_from_date_1").val().replace(/[/]/gi,"");
		var toDate = $("#st_to_date_1").val().replace(/[/]/gi,"");
		var req_dept_code 	= $("#st_req_dept_code_1").val();
		var buyer 			= $("#st_com_code_1").val();
		var ref_pr_no 		= $("#st_ref_pr_no_1").val();
		var po_no 			= $("#st_search_no_1").val();
		var po_user_id 		= $("#st_po_user_id_1").val();
		
		var checkRows = mySheet1.FindCheckedRow("SELECTED");
		var arrRow = checkRows.split("|");
		
		if(checkRows == ""){
			//거래명세서를 생성할 목록을 선택 하세요.
			var text = "<%=CommonLang.msg("MSG254") %>";
			openLayerPopText2(text,this.but1text,this.but1func,this.but1width);
			return;
		}
		
		for(var idx=0; idx<arrRow.length; idx++){
			query += mySheet1.GetCellValue(arrRow[idx],"GR_NO");
			query += "@@";
			query += mySheet1.GetCellValue(arrRow[idx],"GR_SEQ");
			query += "@@";
			query += "||";
		}
		
		var rd_id = "";
		var param = "["+fromDate+"]["+toDate+"]["+req_dept_code+"]["+buyer+"]["+ref_pr_no+"]["+po_no+"]["+po_user_id+"]["+query+"]";
		
		if(bgr00001=="TYPE4_1"){
			rd_id = "RD_06_S_003_36";
		}else{
			rd_id = "RD_06_S_003_35";
		}
		
		reportPostOpen(rd_id, param);
	},
	CloseGrSheet:function(){
		var bgr00001 = "<%=bgr00001%>";
		var fromDate = $("#st_from_date_1").val().replace(/[/]/gi,"");
		var toDate = $("#st_to_date_1").val().replace(/[/]/gi,"");
		var req_dept_code 	= $("#st_req_dept_code_1").val();
		var buyer 			= $("#st_com_code_1").val();
		var ref_pr_no 		= $("#st_ref_pr_no_1").val();
		var po_no 			= $("#st_search_no_1").val();
		var po_user_id 		= $("#st_po_user_id_1").val();
		var po_user_name 	= $("#st_user_name_1").val();
		var session_user_id	= $("#st_user_id_1").val();
		var dept_type		= $("#st_dept_type_1").val();
		var user_type		= $("#st_user_type_1").val();
		var st_acnt_cd		= $("#st_acnt_cd_1").val();
		
		var rd_id = "";
		var param = "["+fromDate+"]["+toDate+"]["+req_dept_code+"]["+buyer+"]["+ref_pr_no+"]["+po_no+"]["+po_user_id+"]["+po_user_name+"]["+session_user_id+"]["+dept_type+"]["+user_type+"]["+st_acnt_cd+"]";
		if(buyer == ""){
			//고객사 정보를 선택 바랍니다.
			var text = "<%=CommonLang.msg("MSG255") %>";
			openLayerPopText2(text,this.but1text,this.but1func,this.but1width);
			return;		
		}
		if(bgr00001 == "TYPE8"){  // HITE
			rd_id = "RD_06_S_003_37";
		}else if(bgr00001=="TYPE9"){	// 롯데푸드_영업용 소모품
			rd_id = "RD_06_S_001_137";
		}else if(bgr00001=="TYPE10"){	// (주)삼양패키징 광혜원공장
			rd_id = "RD_06_S_003_51";	// 39번 기본에서 품목코드, I/F발주번호 추가 
		}else if(bgr00001=="TYPE11"){	// 씨에스케이 전용
			rd_id = "RD_06_S_003_52";	// 공급받는자,공급자 보관용 연속 출력 
		}else if (bgr00001=="TYPE12"){ // 한컴라이프케어
			rd_id = "RD_06_S_003_53";
		}else{
			rd_id = "RD_06_S_003_39";
		}
		reportPostOpen(rd_id, param);
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
	         	var but1funcC = "javascript:tabs.buyerWmGrWarehousingLis_tab1.goCart(); return false;";
	         	var but2funcC = "javascript:closePopText1(); return false;";
	         	var but1widthC = "120px";
	         	var but2widthC = "120px";
	         	openLayerPopText(text,but1textC,but2textC,but1funcC,but2funcC,but1widthC,but2widthC);
			} else{
				//이미 장바구니에 담긴 품목입니다.\n선택하신 수량이 추가되었습니다. 장바구니로 이동하시겠습니까?
				var text = sMsg +"<br/>"+ "<%=CommonLang.msg("MSG364")%>";
				var but1textC = "<%=CommonLang.get("HTITLE516")%>"; //확인
				var but2textC = "<%=CommonLang.get("HTITLE229")%>"; //취소
	         	var but1funcC = "javascript:tabs.buyerWmGrWarehousingLis_tab1.goCart(); return false;";
	         	var but2funcC = "javascript:closePopText1(); return false;";
	         	var but1widthC = "120px";
	         	var but2widthC = "120px";
	         	openLayerPopText(text,but1textC,but2textC,but1funcC,but2funcC,but1widthC,but2widthC);
			}
		}else if(pMethod == "btnSave"){
			//입고 취소가 정상적으로 이루어 졌습니다.
			var text = "<%=CommonLang.msg("MSG253") %> "; 
			openLayerPopText2(text,this.but1text,this.but1funcSearch,this.but1width);
		}else if(pMethod == "setUserList"){
			var userList = response.userList;
			var searchType = response.searchType;
			var poUserId = response.poUserId;
			
			var listbox = document.searchCondition1.st_po_user_id;
			
		    listbox.options.length = 0;
		    var option = new Array();

		    option[0] = new Option('전체','');
		    listbox.options[0] = option[0];

		    var userId = "";
		    var userName = "";
		    var seq = 0;
			for(var i = 0; i < userList.length; i++){
				
				seq = i+1;
				
				userId = userList[i].USER_ID;
				userName = userList[i].USER_NAME_LOC;
				
				option[seq] = new Option(userName, userId);
				
				if(userId == "${st_po_user_id}" && searchType == "load"){
					option[seq].selected = true;	
				}
				
				listbox.options[seq] = option[seq];
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
		query += mySheet1.GetCellValue(this.grbRow,"BUYER_ITEM_NO") + "@@" + "1" + "@@" + mySheet1.GetCellValue(this.grbRow,"AGENT_CODE") + "@@" + mySheet1.GetCellValue(this.grbRow,"CONTRACT_NO") + "@@" + mySheet1.GetCellValue(this.grbRow,"CONTRACT_SEQ") + "@@" + mySheet1.GetCellValue(this.grbRow,"BYIT_COMORG_CODE");
		query += "&&";
		
		document.forms.processForm_1.st_pf_my_group.value = "";
		document.forms.processForm_1.st_use_flag.value = "C"; 
		document.forms.processForm_1.st_query2.value = query;
		document.forms.processForm_1.st_dup_add_flag.value = "<%=dup_add_posb_yn%>";
		kepAjaxFormCallTab("/mdcm/saveBuyerMdCmGoodsLisList.do","processForm_1","CsaveProcess","buyerWmGrWarehousingLis_tab1");
	},
	goCart:function(){
		closePopText1();
		location.href = "<%=p060000036%>";
	},
	buyerChange:function(){
		$("#st_req_dept_code_1").val("");
		$("#st_req_dept_name_1").val("");
		$("#st_acnt_cd_1").val("");
		$("#st_acnt_nm_1").val("");
		this.setUserList("load");
	},
	setUserList:function(type){
		var pr_user_fix = $("#st_pr_user_fix_1").val();
		var po_user_fix = $("#st_po_user_fix_1").val();
		$("#st_search_type_1").val(type);
		
		if("Y" != pr_user_fix && "Y" != po_user_fix){
			
		kepAjaxFormCallTab("/wmgr/getBuyerWmGrWarehousingRegUserList.do","searchCondition1","setUserList","buyerWmGrWarehousingLis_tab1"); // 사용자 목록 콤보박스 위해서
	    }
	}
};
//조회 후처리
function mySheet1_OnSearchEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}	
	
	var p070000024 = "<%=p070000024%>"; //입고취소 버튼 숨김
	if(p070000024 == "true"){
		mySheet1.SetColHidden("CANCEL_BUTTON",true);
	}
	var group_mng_flag = "<%=group_mng_flag%>";
	if(group_mng_flag == "Y"){ //통합고객사 -> 고객사명 컬럼 노출
		mySheet1.SetColHidden("COM_NAME_LOC",false);
	}
	var budget_flag = "<%=sessionBudget_flag%>";
	if(budget_flag == "Y"){ //예산부서,계정 컬럼 노출
		mySheet1.SetColHidden("BUDGET_DEPT",false);
		mySheet1.SetColHidden("ACCOUNT_NAME",false);
	}
	var p060000080 = "<%=p060000080%>"; //택배사정보,배송증빙 컬럼 노출
	if(p060000080 == "TYPE3"){
		mySheet1.SetColHidden("PARCEL_INFO",false);
		mySheet1.SetColHidden("IMAGE_KEY_BUTTON",false);
	}
	
	var bgr00002 = "<%=bgr00002%>"; //실제요청자 컬럼 노출(pohd.remark)
	if(bgr00002 == "true"){
		mySheet1.SetColHidden("PH_REMARK",false);
	}
	
	var tot_amt = 0;
	var startRow = mySheet1.HeaderRows();
	var endRow = mySheet1.LastRow();
	
	for(var i = startRow; i<=endRow; i++){
		//조회된 데이터 행(status:R)이 아닌 경우 제외(필터행,합계행 등)
		if(mySheet1.GetCellValue(i,"sStatus") != "R") continue;
		
		//필터링 등으로 화면에서 숨겨진 행 제외
		if(mySheet1.GetRowHidden(i)) continue;
		
		//정상데이터 금액 합산(Number 로 NaN방지)
		tot_amt += Number(mySheet1.GetCellValue(i,"ITEM_AMT")) || 0;
		
		mySheet1.SetCellValue(i,"CART_BUTTON","/resources/imgs/UserCart.png");
		mySheet1.SetCellValue(i,"CANCEL_BUTTON","<%=CommonLang.get("HTITLE279")%>"); //입고취소
		if(mySheet1.GetCellValue(i,"IMAGE_KEY_INV") != "" || mySheet1.GetCellValue(i,"IMAGE_KEY_SIGN") != ""){
			mySheet1.SetCellValue(i,"IMAGE_KEY_BUTTON","<%=CommonLang.get("HTITLE119")%>"); //첨부파일
		}
		if(mySheet1.GetCellValue(i,"AR_BILL_FLAG") == "Y"){
			mySheet1.SetCellValue(i,"AR_BILL_YN","<%=CommonLang.get("HTITLE1456")%>"); //발행
		}else{
			mySheet1.SetCellValue(i,"AR_BILL_YN","<%=CommonLang.get("HTITLE1457")%>");//미발행
		}
	}
	
	$("#tot_amt").html("<%=CommonLang.get("HTITLE1469")%>"+ " : "+kepCommaNum(tot_amt)+"<%=CommonLang.get("HTITLE660")%>");// 합계금액 : x원

	makePageIndex_v3( mySheet1 , tabs.buyerWmGrWarehousingLis_tab1.current_page , document.searchCondition1.onepagerow.value,"buyerWmGrWarehousingLis_tab","1");	
	
}
//그리드 셀클릭 이벤트
function mySheet1_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = mySheet1.ColSaveName(mySheet1.GetSelectCol());
	tabs.buyerWmGrWarehousingLis_tab1.grbRow = Row;
	
	var user_id = $("#st_user_id_1").val();
	var buyer = mySheet1.GetCellValue(Row,"BUYER");
	var pr_no = mySheet1.GetCellValue(Row,"PR_NO");
	var pr_seq = mySheet1.GetCellValue(Row,"PR_SEQ");
	var po_no = mySheet1.GetCellValue(Row,"PO_NO");
	var po_seq = mySheet1.GetCellValue(Row,"PO_SEQ");
	var recv_flag = mySheet1.GetCellValue(Row,"RECV_FLAG");
	
	var gw_no = mySheet1.GetCellValue(Row,"GW_NO");
	
	var seller = mySheet1.GetCellValue(Row,"SELLER");
	var inv_no = mySheet1.GetCellValue(Row,"INV_NO");
	var purchaser_id = mySheet1.GetCellValue(Row,"PURCHASER_ID");
	var agent_code = mySheet1.GetCellValue(Row,"AGENT_CODE");
	var warehouse_code = mySheet1.GetCellValue(Row,"WAREHOUSE_CODE");
	
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
		var but1funcC = "javascript:tabs.buyerWmGrWarehousingLis_tab1.cartInsert(); return false;";
		var but2funcC = "javascript:closePopText1(); return false;";
		var but1widthC = "120px";
		var but2widthC = "120px";
		openLayerPopText(text,but1textC,but2textC,but1funcC,but2funcC,but1widthC,but2widthC);
	}else if(column == "CANCEL_BUTTON"){ //입고취소 클릭 시
		var grRole = '<%=grRole%>';
		
		if(grRole == '-'){
			// 마감 기간으로 입고취소가 불가합니다. KEP담당자에게 문의 부탁드립니다.
			var text = "<%=CommonLang.msg("MSG601") %>";
			openLayerPopText2(text,tabs.buyerWmGrWarehousingLis_tab1.but1text,tabs.buyerWmGrWarehousingLis_tab1.but1func,tabs.buyerWmGrWarehousingLis_tab1.but1width);
			return;		
		}
		
		var user_id = $("#st_user_id_1").val();
		var close_date = document.searchCondition1.st_close_date.value;
		
		var query = "";
		var gr_date = mySheet1.GetCellValue(Row,"GR_DATE");
		var close_flag = mySheet1.GetCellValue(Row,"CLOSE_FLAG");
		var ar_bill_flag = mySheet1.GetCellValue(Row,"AR_BILL_FLAG");
		var gr_lock_flag = mySheet1.GetCellValue(Row,"GR_LOCK_FLAG");
		
		var clsd_flag = mySheet1.GetCellValue(Row,"CLSD_FLAG");
		
		var db_auto_gr = mySheet1.GetCellValue(Row,"AUTO_GR_FLAG");
		
		if(db_auto_gr == "Y"){
			//자동입고 처리 건이므로 입고취소가 불가능 합니다.
			var text = (idx+1)+ "<%=CommonLang.msg("MSG806") %>";
			openLayerPopText2(text,tabs.buyerWmGrWarehousingLis_tab1.but1text,tabs.buyerWmGrWarehousingLis_tab1.but1func,tabs.buyerWmGrWarehousingLis_tab1.but1width);
			return;
		}
		if(ar_bill_flag == "Y"){
			//세금계산서 발행 완료 건으로 입고 취소 하실 수 없습니다.  \n\n운영자에게 문의하시기 바랍니다.
			var text = "<%=CommonLang.msg("MSG807") %>";
			openLayerPopText2(text,tabs.buyerWmGrWarehousingLis_tab1.but1text,tabs.buyerWmGrWarehousingLis_tab1.but1func,tabs.buyerWmGrWarehousingLis_tab1.but1width);
			return;
		}
		if(close_date >= gr_date){
			//마감일 이전이어서 입고취소 하실 수 없습니다.  \n\n운영자에게 문의하시기 바랍니다.  
			var text = "<%=CommonLang.msg("MSG808") %>";
			openLayerPopText2(text,tabs.buyerWmGrWarehousingLis_tab1.but1text,tabs.buyerWmGrWarehousingLis_tab1.but1func,tabs.buyerWmGrWarehousingLis_tab1.but1width);
			return;
		}
		if(close_flag == "Y"){
			//이미 마감완료 되어 입고취소 하실 수 없습니다.\n\n자세한 사항은 운영자에게 문의하시기 바랍니다. 
			var text = "<%=CommonLang.msg("MSG809") %>";
			openLayerPopText2(text,tabs.buyerWmGrWarehousingLis_tab1.but1text,tabs.buyerWmGrWarehousingLis_tab1.but1func,tabs.buyerWmGrWarehousingLis_tab1.but1width);
			return;
		}
		if(clsd_flag == "Y"){
			//상태가 종결되어 입고취소 하실 수 없습니다.
			var text = "<%=CommonLang.msg("MSG810") %>";
			openLayerPopText2(text,tabs.buyerWmGrWarehousingLis_tab1.but1text,tabs.buyerWmGrWarehousingLis_tab1.but1func,tabs.buyerWmGrWarehousingLis_tab1.but1width);
			return;
		}
		if(gr_lock_flag == "Y"){
			// 월마감이 종료되어 입고취소 불가합니다.
			var text = "<%=CommonLang.msg("MSG586") %>";
			openLayerPopText2(text,tabs.buyerWmGrWarehousingLis_tab1.but1text,tabs.buyerWmGrWarehousingLis_tab1.but1func,tabs.buyerWmGrWarehousingLis_tab1.but1width);
			return;
		}
		
		var com_code = mySheet1.GetCellValue(Row,"BUYER");
		var gr_no = mySheet1.GetCellValue(Row,"GR_NO");
		var gr_seq = mySheet1.GetCellValue(Row,"GR_SEQ");
		var po_no = mySheet1.GetCellValue(Row,"PO_NO");
		var po_seq = mySheet1.GetCellValue(Row,"PO_SEQ");
		var iv_exist = mySheet1.GetCellValue(Row,"IV_EXIST");
		var inv_no = mySheet1.GetCellValue(Row,"INV_NO");
		var inv_seq = mySheet1.GetCellValue(Row,"INV_SEQ");
		var gr_item_qty = mySheet1.GetCellValue(Row,"GR_ITEM_QTY");
		var buyer_item_no = mySheet1.GetCellValue(Row,"BUYER_ITEM_NO");
		
		query +=  com_code		+ "@@";
		query +=  user_id		+ "@@";
		query +=  gr_no			+ "@@";
		query +=  gr_seq		+ "@@";
		query +=  po_no			+ "@@";
		query +=  po_seq		+ "@@";
		query +=  iv_exist		+ "@@";
		query +=  inv_no		+ "@@";
		query +=  inv_seq		+ "@@";
		query +=  gr_item_qty	+ "@@";
		query +=  buyer_item_no	+ "@@";
		query +=  "^||^" ;
		
		//선택하신 품목을 입고 취소처리 하시겠습니까?
		var text = "<%=CommonLang.msg("MSG246")%>"; 
		var but1textC = "<%=CommonLang.get("HTITLE516")%>"; //확인
		var but2textC = "<%=CommonLang.get("HTITLE229")%>"; //취소
     	var but1funcC = "javascript:tabs.buyerWmGrWarehousingLis_tab1.grCancelConfirm('"+query+"'); return false;";
     	var but2funcC = "javascript:closePopText1(); return false;";
     	var but1widthC = "120px";
     	var but2widthC = "120px";
     	openLayerPopText(text,but1textC,but2textC,but1funcC,but2funcC,but1widthC,but2widthC);
     	return;
	}else if(column == "AGENT_NAME"){
		//getAgentDisplayPop_v2(agent_code);
		openSearchPopup("/common/agentInfoDisplayPop.do", '?st_com_code='+agent_code+"&st_popup_check=N", "800,650,no");
	}else if(column == "IMAGE_KEY_BUTTON"){
		if(mySheet1.GetCellValue(Row,"IMAGE_KEY_INV") != ""){
			var src = '/common/fileUploadPop_v2.do?DOC_NO='+mySheet1.GetCellValue(Row,"IMAGE_KEY_INV")+'&viewType=R&TYPE=IV';
			openLayerPop(src,"600px","490px");
		}else if(mySheet1.GetCellValue(Row,"IMAGE_KEY_SIGN") != ""){
			var src = '/common/fileUploadPop_v2.do?DOC_NO='+mySheet1.GetCellValue(Row,"IMAGE_KEY_SIGN")+'&viewType=R&TYPE=IV';
			openLayerPop(src,"600px","490px");
		}
	}
	return;
}
</script>
<form id="searchCondition1" name="searchCondition1" method="post">
		<input type="hidden" name="s_SAVENAME" />
		<!-- 화면 내 정의 -->
		<input type="hidden" name="st_dept_name" id="st_dept_name_1" value="${sessionInfo.departmentName}">
		<input type="hidden" name="st_user_id" id="st_user_id_1" value="${sessionInfo.userId}">
		<input type="hidden" name="st_user_name" id="st_user_name_1" value="${sessionInfo.userNameLoc}">
			
		<input type="hidden" name="st_query" id="st_query_1" value ="">
		<input type="hidden" name="st_close_date" id="st_close_date_1" value ="">
		<input type="hidden" name="st_car_check" id="st_car_check_1" value="">
		
		<input type="hidden" name="st_row_cnt_yn" 	id="st_row_cnt_yn_1" 	value="<%=rowCntYn%>" />
		<input type="hidden" name="st_card_yn" 		id="st_card_yn_1" 	value="<%=cardYn%>" />
		<input type="hidden" name="st_dept_fix" 	id="st_dept_fix_1" 	value="<%=deptFix%>" />
		<input type="hidden" name="st_pr_user_fix" 	id="st_pr_user_fix_1"	value="<%=prUserFix%>" />
		<input type="hidden" name="st_po_user_fix" 	id="st_po_user_fix_1"	value="<%=poUserFix%>" />
		
		<input type="hidden" name="st_extr_report_btn" 	id="st_extr_report_btn_1"	value="<%=extrReportBtn%>" />
		<input type="hidden" name="st_extr_report_id" 	id="st_extr_report_id_1"	value="<%=extrReportId%>" />
		<input type="hidden" name="st_clsd_dnld_yn" 	id="st_clsd_dnld_yn_1"	value="<%=clsdDnldYn%>" />
		
		<input type="hidden" id="st_search_buyer_item_no_1" name="st_search_buyer_item_no" value="">
		<input type="hidden" id="st_search_desc_spec_1" name="st_search_desc_spec"     value="">
		<input type="hidden" id="st_search_agent_1" name="st_search_agent"         value="">
		
		<input type="hidden" name="st_search_type" 	id="st_search_type_1"	value="" />
		<input type="hidden" id="st_excel_type_1" name="st_excel_type"	value="" />
		<input type="hidden" id="st_close_excel_type_1" name="st_close_excel_type"	value="" />
		<input type="hidden" name="st_group_mng_flag" id="st_group_mng_flag_1" value="<%=group_mng_flag%>">
		<input type="hidden" name="st_group_info" id="st_group_info_1" value="">
		
        <input type="hidden" name="onepagerow" id="onepagerow_1" value="<%=request.getParameter("rowCnt")%>">
        <input type="hidden" id="pageflag_1" name="pageflag" value="1" />
        <input type="hidden" id="st_all_page_1" name="st_all_page" value="N" />
	<div id="Search1" class="SearchContent">
      <div class="Importance"><img src="/resources/imgs/Icon_Importance.png" /> <%=CommonLang.msg("MSG812")%><!--입고 처리된 내역을 조회하고, 필요 시 입고를 취소할 수 있습니다.--></div>
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
          <th><%=CommonLang.get("HTITLE283") %><!-- 입고일 --><input type="hidden" id="st_check_date_1" name="st_check_date" value="GR"></th>
          <td >
            <div class="Buyer-datepicker-wrap" style=" width:261px; margin-right:8px">
              <div class="Buyer-date-input"  data-datepicker style="width: 120px;"><input style=" " type="text" placeholder="" readonly id="st_from_date_1" name="st_from_date"/><span> </span></div>
              <span class="Buyer-dash">~</span>
              <div class="Buyer-date-input" data-datepicker style="width: 120px;"><input type="text" placeholder="" readonly id="st_to_date_1" name="st_to_date"/><span></span></div>
            </div>
            <!--div class="Buyer-datepicker-wrap" style=" width:120px">
              <div class="Buyer-date-input" data-monthpicker><input type="text" placeholder="" readonly /><span>1</span></div>
            </div-->
          </td>
          <td colspan="2">               
            <button class="But_Month" style="width:73px" onclick="javascript:tabs.buyerWmGrWarehousingLis_tab1.addMonth('minus'); return false;">-1<%=CommonLang.get("HTITLE602") %><!-- 개월 --></button>
            <button class="But_Month" style="width:73px" onclick="javascript:tabs.buyerWmGrWarehousingLis_tab1.addMonth('plus'); return false;">+1<%=CommonLang.get("HTITLE602") %><!-- 개월 --></button>
            <button class="But_Month" style="width:73px" onclick="javascript:tabs.buyerWmGrWarehousingLis_tab1.addMonth(''); return false;"><%=CommonLang.get("HTITLE1334") %><!-- 당월 --></button>  
<%--             <button class="But_Month" style="width:73px" onclick="javascript:kepMonth_v2('st_from_date_1','st_to_date_1','2'); return false;">2<%=CommonLang.get("HTITLE602") %><!-- 개월 --></button> --%>
<%--             <button class="But_Month" style="width:73px" onclick="javascript:kepMonth_v2('st_from_date_1','st_to_date_1','3'); return false;">3<%=CommonLang.get("HTITLE602") %><!-- 개월 --></button> --%>
<%--             <button class="But_Month" style="width:73px" onclick="javascript:kepMonth_v2('st_from_date_1','st_to_date_1','12'); return false;">1<%=CommonLang.get("HTITLE424") %><!-- 년 --></button> --%>
          </td>
          <th><%=CommonLang.get("HTITLE136") %><!-- 진행상태 --></th>
          <td>
            <select name="st_gr_status"  id="st_gr_status_1" class="Select40" style="width:300px;">
            	<option value=""><%=CommonLang.get("HTITLE29") %><!-- 전체 --></option>
            	<option value="GC"><%=CommonLang.get("HTITLE201") %><!-- 입고완료 --></option>
            	<option value="GP"><%=CommonLang.get("HTITLE200") %><!-- 부분입고 --></option>
            </select>  
          </td>
        </tr>
		<tr>
		  <th>
		  	<select name="st_user_type" id="st_user_type_1" class="Select40" style=" float:left;width:120px; margin-right:5px" <%if(poUserFix.equals("Y")||prUserFix.equals("Y")) {%> disabled <%}else{ %>onChange="tabs.buyerWmGrWarehousingLis_tab1.setUserList('change')"  <%} %>>
              <option value="PO" <%if(poUserFix.equals("Y")){%> selected <%} %>><%=CommonLang.get("HTITLE187") %><!-- 발주자 --></option>
              <option value="PR" <%if(prUserFix.equals("Y")){%> selected <%} %>><%=CommonLang.get("HTITLE133") %><!-- 요청자 --></option>
            </select> 
		  </th>					
          <td>
          	<%if(poUserFix.equals("Y")||prUserFix.equals("Y")) {%>
          		<select id="st_po_user_id_1" name="st_po_user_id" class="Select40" style=" float:left; width:263px; margin-right:7px">
	                <option value="${sessionInfo.userId}" selected>${sessionInfo.userNameLoc}</option>
	            </select>
			<%}else{ %>
        		<select id="st_po_user_id_1" name="st_po_user_id" class="Select40" style=" float:left; width:263px; margin-right:7px">
					<option value="" >---<%=CommonLang.get("HTITLE29")%><!-- 전체 -->----</option>
				</select>
			<%} %>
<%--             <input type="text"  class="input40" name="st_po_user_name" id="st_po_user_name_1" value="<%=po_user_name %>"  style=" width:240px;" onKeyDown="kepEnter_v3('buyerWmGrWarehousingLis_tab1')" <%if(poUserFix.equals("Y")||prUserFix.equals("Y")) {%> readonly <%} %>> --%>
<%--           	<input type="hidden" name="st_po_user_id" 	id="st_po_user_id_1" 	value="<%=po_user_id%>" /> --%>
          </td>
          <th>
          	<select name="st_dept_type" id="st_dept_type_1" class="Select40" style=" float:left;width:120px; margin-right:5px">
              <option value="PR"><%=CommonLang.get("HTITLE135") %><!-- 요청부서 --></option>
              <option value="PO"><%=CommonLang.get("HTITLE188") %><!-- 발주부서 --></option>
              <%if(sessionBudget_flag.equals("Y")){ %>
			   <option value="BD"><%=CommonLang.get("HTITLE268")%><!-- 예산부서 --></option>
			  <%}%>
            </select>
          </th>
          <td><div class="TabShIconTwo" style="width:270px ">
            <input type="text"  name="st_req_dept_name" id="st_req_dept_name_1" value="<%=req_dept_name %>"  style=" width:202px;" readonly>
            <input type="hidden" name="st_req_dept_code" id="st_req_dept_code_1" value="<%=req_dept_code%>">
            <%if(deptFix.equals("N")) {%>
            <button class="Search" type="button" onclick="javascript:tabs.buyerWmGrWarehousingLis_tab1.doPop('department'); return false;"></button><button class="Delete" type="button" onclick="javascript:tabs.buyerWmGrWarehousingLis_tab1.doAction('departmentErase'); return false;"></button></div></td>
		  	<%} %>
		  <th><%=CommonLang.get("HTITLE18")%><!-- 관리번호 --></th>
		  <td>
		  <%if( p060000029_type.equals("TYPE4") || p060000029_type.equals("TYPE5") || p060000029_type.equals("TYPE7")){ %>
		  	<div class="TabShIconTwo" style="width:298px ">
            <input type="text"  name="st_ref_pr_no" id="st_ref_pr_no_1" value=""  style=" width:230px;" readonly>
            <input type="hidden" id="st_ref_pr_no_text_1" name="st_ref_pr_no_text" value="">
            <button class="Search" type="button" onclick="javascript:tabs.buyerWmGrWarehousingLis_tab1.doPop('refPrNo'); return false;"></button>
            
            <button class="Delete" type="button" onclick="javascript:tabs.buyerWmGrWarehousingLis_tab1.doAction('refPrNoErase'); return false;"></button></div></td>
          <%}else{ %>
          	<input type="text"  class="input40" name="st_ref_pr_no" id="st_ref_pr_no_1" value=""  style=" width:278px;" onKeyDown="kepEnter_v3('buyerWmGrWarehousingLis_tab1')">
          	<input type="hidden" id="st_ref_pr_no_text_1" name="st_ref_pr_no_text" value="">
          <%} %>
            <input type="hidden" id="st_legacy_po_no_1" name="st_legacy_po_no" value="">
            <input type="hidden" id="st_buyer_item_no_1" name="st_buyer_item_no" value="">
            <input type="hidden" id="st_change_user_id_1" name="st_change_user_id" value="">
		</tr>
		<tr>
			<th>
		  	<select name="st_no_type" id="st_no_type_1" class="Select40" style=" float:left;width:120px; margin-right:5px">
              	<option value = "PO" ><%=CommonLang.get("HTITLE203")%><!-- 발주번호 --></option>
				<option value = "IV"><%=CommonLang.get("HTITLE271")%><!-- 송장번호 --> </option>
				<option value = "PR"><%=CommonLang.get("HTITLE216")%><!-- 요청번호 --> </option>
            </select> 
		  </th>
		  <td>
            <input type="text"  class="input40" name="st_search_no" id="st_search_no_1" value=""  style=" width:240px;" onKeyDown="kepEnter_v3('buyerWmGrWarehousingLis_tab1')">
          </td>
          <th><select name="st_no_type2" id="st_no_type2_1" class="Select40" style=" float:left;width:120px; margin-right:5px">
              <option value="ITEMNAME"><%=CommonLang.get("HTITLE13") %><!-- 품목명 --></option>
              <option value="ITEMNO"><%=CommonLang.get("HTITLE12") %><!-- 품목코드 --></option>
              <option value="SPECIFICATION"><%=CommonLang.get("HTITLE14") %><!-- 규격 --></option>
            </select> </th>
          <td>
            <input class="input40" style="width:250px" name="st_search_no2" type="text" onKeyDown="kepEnter_v3('buyerWmGrWarehousingLis_tab1')"/>
          </td>
          <%if(sessionBudget_flag.equals("Y")){ %>
          <th><%=CommonLang.get("HTITLE966")%><!-- 예산계정 --></th>
		  <td>
		  	<div class="TabShIconTwo" style="width:298px ">
            <input type="text"  name="st_acnt_nm" id="st_acnt_nm_1" value=""  style=" width:230px;" readonly>
            <input type="hidden" name="st_acnt_cd" id="st_acnt_cd_1" value="">
            <button class="Search" type="button" onclick="javascript:tabs.buyerWmGrWarehousingLis_tab1.doPop('acntCd'); return false;"></button>
            <button class="Delete" type="button" onclick="javascript:tabs.buyerWmGrWarehousingLis_tab1.doAction('acntCdErase'); return false;"></button></div></td>
		  <%}else{ %>
		  	<input type="hidden"  name="st_acnt_nm" id="st_acnt_nm_1" value=""  >
            <input type="hidden" name="st_acnt_cd" id="st_acnt_cd_1" value="">
		  <%} %>
		</tr>
		<tr>
		<%if(group_mng_flag.equals("Y")) {%>
          <th><%=CommonLang.get("HTITLE604") %><!-- 고객사 --></th>
	      <td>
		      <select name="st_com_code" id="st_com_code_1" class="Select40" style=" float:left; width:263px; margin-right:7px" onchange="javascript:tabs.buyerWmGrWarehousingLis_tab1.buyerChange();">
		        <%= CommonUtil.getCode3ComboList(request.getParameter("buyer"), "ALL", "TGCM",request.getParameter("userId"), "ICOMCOD3", request.getParameter("buyer"), "") %>
		       </select>
	      </td>
		<%}else{ %>
		  <input type="hidden" name="st_com_code" id="st_com_code_1" value="${sessionInfo.comCode}">
		<%} %>
		</tr>
      </table>
      <div class="SearchBtnBox">
        <button class="ButOutline_Medium" onclick="javascript:tabs.buyerWmGrWarehousingLis_tab1.reload(); return false;"><%=CommonLang.get("HTITLE8") %><!-- 초기화 --></button> 
        <button class="ButDarkGray_Medium" onclick="javascript:tabs.buyerWmGrWarehousingLis_tab1.search(); return false;" ><%=CommonLang.get("HTITLE7") %><!-- 조회 --></button> 
      </div>
      <div class="ArraySub mt30 mb10">
      	<div class="buttonLeft">
      	<%if(p170000001 == false){%>
			<% if("TYPE1".equals(p070000011)) {%>
				<button class="But_ExcelDown40" onclick="tabs.buyerWmGrWarehousingLis_tab1.doAction('excelDown','TYPE1'); return false;"><%=CommonLang.get("HTITLE150") %><!-- 엑셀다운로드 --></button>
			<% } else if("TYPE2".equals(p070000011)) {	// KRWOOS0062 (/kr/customer/warehousing/gr_delete_exwdKRWOOS0062.jsp) %>
				<button class="But_ExcelDown40" onclick="tabs.buyerWmGrWarehousingLis_tab1.doAction('excelDown','TYPE2'); return false;"><%=CommonLang.get("HTITLE150") %><!-- 엑셀다운로드 --></button>
			<% } else if("TYPE4".equals(p070000011)) {	// 롯데푸드 11개 고객사 %>
				<button class="But_ExcelDown40" onclick="tabs.buyerWmGrWarehousingLis_tab1.doAction('excelDown','TYPE4'); return false;"><%=CommonLang.get("HTITLE150") %><!-- 엑셀다운로드 --></button>
			<% } else if("TYPE7".equals(p070000011)) {	// 한화에어로스페이스 외 3개(KRHANH0008, KRHANW0063, KRHANH0009, KRHANW0062) %>
				<button class="But_ExcelDown40" onclick="tabs.buyerWmGrWarehousingLis_tab1.doAction('excelDown','TYPE7'); return false;"><%=CommonLang.get("HTITLE150") %><!-- 엑셀다운로드 --></button>
			<% } else if("TYPE11".equals(p070000011)) {	// 한컴라이프케어 %>
				<button class="But_ExcelDown40" onclick="tabs.buyerWmGrWarehousingLis_tab1.doAction('excelDown','TYPE11'); return false;"><%=CommonLang.get("HTITLE150") %><!-- 엑셀다운로드 --></button>
			<% } else if("TYPE14".equals(p070000011)) {	// 종근당 계열 - 예산코드/계정코드 추가 %>
				<button class="But_ExcelDown40" onclick="tabs.buyerWmGrWarehousingLis_tab1.doAction('excelDown','TYPE14'); return false;"><%=CommonLang.get("HTITLE150") %><!-- 엑셀다운로드 --></button>
			<% } else {%>
       			<button class="But_ExcelDown40" onclick="tabs.buyerWmGrWarehousingLis_tab1.doAction('excelDown','DEFAULT'); return false;"><%=CommonLang.get("HTITLE150") %><!-- 엑셀다운로드 --></button>
			<% } %>
        	<% if(clsdDnldYn.equals("Y")) {%>
        		<%if("TYPE2".equals(p070000017)){%>
        			<button class="But_ExcelDown40" onclick="tabs.buyerWmGrWarehousingLis_tab1.doAction('excelDownClose1'); return false;"><%=CommonLang.get("HTITLE681") %><!-- 마감 다운로드 --></button>
        		<%}else{ %>
        			<button class="But_ExcelDown40" onclick="tabs.buyerWmGrWarehousingLis_tab1.doAction('excelDownClose'); return false;"><%=CommonLang.get("HTITLE681") %><!-- 마감 다운로드 --></button>
        		<%} %>
        	<%} %>
        
        <%} %>
        <% if("TYPE6".equals(p070000011)) {	// 대한제분 그룹사 ERP업로드 양식  (KRWOOR0059, KRDH-V0001, KRBONA0001, KRVITI0001, KRDNB-0001) %>
			<button class="But_ExcelDown40" onclick="tabs.buyerWmGrWarehousingLis_tab1.doAction('excelDown','TYPE6'); return false;"><%=CommonLang.get("HTITLE883") %><!-- ERP다운로드 --></button>
		<% }%>
        <%if("TYPE11".equals(p070000011)) {	// 한컴라이프케어 erp 양식 다운로드 %>
          	<button class="But_ExcelDown40" onclick="tabs.buyerWmGrWarehousingLis_tab1.doAction('excelDown','TYPE11_2'); return false;"><%=CommonLang.get("HTITLE962") %><!-- ERP다운로드 --></button>
        <%} %>
        <%if("TYPE12".equals(p070000011)) { %>
        	<button class="But_ExcelDown40" onclick="tabs.buyerWmGrWarehousingLis_tab1.doAction('excelDown','TYPE12'); return false;"><%=CommonLang.get("HTITLE1261") %><!-- 마감데이터 다운로드 --></button>
        <%} %>
        <%if("TYPE13".equals(p070000011)) {	// 깨끗한나라 ERP 양식 다운로드 %>
        	<button class="But_ExcelDown40" onclick="tabs.buyerWmGrWarehousingLis_tab1.doAction('excelDown','TYPE13'); return false;"><%=CommonLang.get("HTITLE962") %><!-- ERP다운로드 --></button>
        <%} %>
        
        <%if(bgr00001.equals("TYPE1")) {%>
        	<button class="ButOutline_Medium" onclick="tabs.buyerWmGrWarehousingLis_tab1.WoosPracticeView();return false;"><%=CommonLang.get("HTITLE677") %><!-- 실습재료인계인수대장출력 --></button>
        <%}%>
        
        <%if(bgr00001.equals("TYPE2") || bgr00001.equals("TYPE3")){ %>
        	<button class="ButOutline_Medium" onclick="tabs.buyerWmGrWarehousingLis_tab1.CloseGrSheetFAGSel();return false;"><%=CommonLang.get("HTITLE680") %><!-- 마감거래명세서출력(선택) --></button>
        	<button class="ButOutline_Medium" onclick="tabs.buyerWmGrWarehousingLis_tab1.CloseGrSheetFAG();return false;"><%=CommonLang.get("HTITLE277") %><!-- 마감거래명세서출력 --></button>
        <%}else if(bgr00001.equals("TYPE4") || bgr00001.equals("TYPE4_1")){%>
        	<button class="ButOutline_Medium" onclick="tabs.buyerWmGrWarehousingLis_tab1.CloseGrSheetJinRo();return false;"><%=CommonLang.get("HTITLE277") %><!-- 마감거래명세서출력 --></button>
        <%}else if(bgr00001.equals("TYPE5") || bgr00001.equals("TYPE6") || "TYPE8".equals(p070000011) ){%>
        	<button class="ButOutline_Medium" onclick="tabs.buyerWmGrWarehousingLis_tab1.CloseGrSheetFAGSel();return false;"><%=CommonLang.get("HTITLE277") %><!-- 마감거래명세서출력 --></button>
        <%}else if(bgr00001.equals("TYPE7")){%>
        	<button class="ButOutline_Medium" onclick="tabs.buyerWmGrWarehousingLis_tab1.CloseGrSheetFAGSel();return false;"><%=CommonLang.get("HTITLE278") %><!-- 마감거래명세서출력(선택) --></button>
        	<button class="ButOutline_Medium" onclick="tabs.buyerWmGrWarehousingLis_tab1.CloseGrSheet();return false;"><%=CommonLang.get("HTITLE277") %><!-- 마감거래명세서출력 --></button>
        <%}else{ %>
        	<button class="ButOutline_Medium" onclick="tabs.buyerWmGrWarehousingLis_tab1.CloseGrSheet();return false;"><%=CommonLang.get("HTITLE277") %><!-- 마감거래명세서출력 --></button>
        <%} %>
         
        </div>
        <div class="buttonRight">
        
        <%if(p170000001 == false){%>
        	<%if(p070000024 == false){%>
    	    	<button class="ButPrimary_Medium" onclick="tabs.buyerWmGrWarehousingLis_tab1.doAction('grCancel');return false;"><%=CommonLang.get("HTITLE279") %><!-- 입고취소 --></button>
        	<%} %>
        <%} %>
        </div>
	  </div>
      <div class="IBSheetBuyer">
      	<script type="text/javascript">
          	createIBSheet("mySheet1", "", "100%");
        </script>
      </div><!--IBSheetBuyer 끝 -->
      <div class="ArraySub mt10">
        <div class="buttonRight"><span class="allprice" id="tot_amt"></span></div>
	   </div>
      <div class="PagingCenter mt10" id="pageindex1"></div> 
      <div class="h50"></div>         
    </div><!--Tab1끝 -->
</form>
<form name="processForm_1" id="processForm_1" method="post">	
	<input type="hidden" name="st_buyer" id="st_buyer" value="">
	<input type="hidden" name="st_pr_no" id="st_pr_no" value="">
	<input type="hidden" name="st_pr_seq" id="st_pr_seq" value="">
	<input type="hidden" name="st_pf_my_group" id="st_pf_my_group" value="">
	<input type="hidden" name="st_use_flag" id="st_use_flag" value="">
	<input type="hidden" name="st_query2" id="st_query2" value="">
	<input type="hidden" name="st_dup_add_flag" id="st_dup_add_flag" value="">
</form> 
<form name="refPrNoForm_1" id="refPrNoForm_1" method="post">	
	<input type="hidden" name="st_buyer" id="st_buyer_1" value="">
	<input type="hidden" name="st_ref_no" id="st_ref_no_1" value="">
	<input type="hidden" name="st_type" id="st_type_1" value="">
	<input type="hidden" name="st_form" id="st_form_1" value="<%=p060000029_form%>">
	<input type="hidden" name="st_pop_type" id="st_pop_type_1" value="<%=p060000029_type%>">
	<input type="hidden" name="st_gbn" id="st_gbn_1" value="">
	<input type="hidden" name="st_title" id="st_title_1" value="">
	<input type="hidden" name="open" id="open_1" value="Y">
	<input type="hidden" name="st_tab_id" id="st_tab_id_1" value="buyerWmGrWarehousingLis_tab1">
</form>
<form name="reportPostForm" id="reportPostForm" method="post">	 
	<input type="hidden" name="fileName" id="fileName" value=""> 
	<input type="hidden" name="param" id="param" value=""> 
</form>
