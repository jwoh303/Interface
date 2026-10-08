<%--
**********************************************
* 메뉴 : 
* 화면 : 주문정보 수정-수주접수전(협력사외)
* 기능 : 협력사의 수주접수전 발주정보를 변경하기 위한 팝업. 거래유형,협력사등을 변경할수 있다
* 프로그램 ID : PG_06_M_006_01
* 담당자 : CEJ ( 설계 : 김지현 )
* 착수일 : 2014-07-29
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.*"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<!doctype html>
<html>
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>코리아 e 플랫폼</title>
<link rel="stylesheet" href="/resources/styles/base.css" type="text/css" />
<link rel="stylesheet" href="/resources/styles/master_layout.css" type="text/css" /> 
<script src="/resources/libs/jquery/js/jquery.min.js" type="text/javascript"></script>
<script src="/resources/libs/jquery/js/jquery-ui.min.js" type="text/javascript"></script>
<script src="/resources/js/kep_common.js"></script>
<script src="/resources/libs/ibsheet7/js/ibsheet.js" type="text/javascript"></script>
<script src="/resources/libs/ibsheet7/js/ibsheetinfo.js" type="text/javascript"></script>
<script src="/resources/libs/ibsheet7/js/ibleaders.js" type="text/javascript"></script> 
</head>
<%
	// 공통
	@SuppressWarnings (value="unchecked")
	List<Map<String,String>> _gridList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된 결과 
	Map<String,String> rowData = null;
	String APPROVAL = "";
	String DOCU_NO = "";
	String PASS_STATUS = "";
	String PASS_STATUS_NAME = "";
	String PASS_STATUS_TEXT[] = new String[2];
	String DOC_TYPE = "";
	if (_gridList == null || _gridList.size() == 0){
		%>
		<script>alert("주문정보 수정 대상이 없습니다.");self.close();</script>
		<%
	}else{ 
		rowData = _gridList.get(0);
		APPROVAL = CommonUtil.nvl(rowData.get("PASS_STATUS"),"");    // 결재 번호와 상태
		DOC_TYPE = CommonUtil.nvl(rowData.get("DOC_TYPE"),"");    // 결재 번호와 상태
		if (!"".equals(APPROVAL)){
			PASS_STATUS_TEXT = APPROVAL.split(",");
			if (PASS_STATUS_TEXT !=null && PASS_STATUS_TEXT.length == 2){
				DOCU_NO = PASS_STATUS_TEXT[0];
				PASS_STATUS = PASS_STATUS_TEXT[1];
				if ("0".equals(PASS_STATUS)){
					PASS_STATUS_NAME = "(결재진행중)";
				}else if ("1".equals(PASS_STATUS)){
					PASS_STATUS_NAME = "(반려)";
				}else if ("2".equals(PASS_STATUS)){
					PASS_STATUS_NAME = "(참조진행중)";
				}else if ("3".equals(PASS_STATUS)){
					PASS_STATUS_NAME = "(결재완료)";
				}else if ("4".equals(PASS_STATUS)){
					PASS_STATUS_NAME = "(상신취소)";
				} 
			}
		}
	}
	/*
	PASS_STATUS,'0','결재진행중',  
                                                     '1','반려',  
                                                     '2','참조진행중', 
                                                     '3','결재완료',  
                                                     '4','상신취소', 
                                                     */
	 
	String cardUseCheck = (String) request.getAttribute("cardUseCheck"); // 조회된 결과  getPrCardUseCheck 
 
	String SessionComCode = "";
	String SessionUserName = "";
	String SessionUserId = "";
	SessionInfo sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
	if (sessionInfo != null){ 
		SessionComCode =  CommonUtil.nvl((String)sessionInfo.getComCode());  
		SessionUserName = CommonUtil.nvl((String)sessionInfo.getUserNameLoc()); 
		SessionUserId = CommonUtil.nvl((String)sessionInfo.getUserId()); 
	}  
	
	String st_buyer = CommonUtil.nvl((String) request.getParameter("st_buyer"),"");   
	String st_po_no = CommonUtil.nvl((String) request.getParameter("st_po_no"),"");    
	String st_orderFlag = CommonUtil.nvl((String) request.getParameter("st_orderFlag"),"");    
	
	String beforeAfterTitle = "전";
	if ("after".equals(st_orderFlag)){
		beforeAfterTitle ="후";
	}
%>
<script>
var mySheet = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
var popupSel = "";
var grbRow;
var grbCol;
var remarkOn="/resources/images/but_icon01.gif";
var remarkOff="/resources/images/but_icon02.gif";
var gridHeaderCount = 4;		


var db_buyer_adapt_flag		= "";		
var db_buyer_rate			= "";	
var db_buyer_standard_rate	= ""; 
var db_supply_direct_rate	= ""; 
var db_stock_rate			= ""; 
var db_tr_rate				= ""; 
var db_vmi_rate				= ""; 
var db_import_rate			= "";   

var org_process_type = "";
var saveFlag = "";
var processOK = 'Y';

var header_C001_code = "";
var header_C002_code = "";
var header_C003_code = "";
var header_C004_code = "";
var header_C005_code = "";
var header_C006_code = "";
var header_C007_code = "";
var header_C008_code = "";
var header_C009_code = "";
var header_C0010_code = "";


//시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	
	var unit = KepSheetComboQueryIdData("common.getUnitMeasureInfo", "");
	
	 
	var initsheet = {};
	
	initsheet.Headers = [
	             		{Text:"구분|선택|거래명세서|협력사|협력사|최종발주수정자|발주일|납기요청일|입고일|발주수량|납품예정수량|입고수량|매출단가|매출금액|I/F발주번호", Align:"Center"}
	             		,{Text:"구분|선택|관리번호|거래유형|수입여부|협력사품목코드|납품일|납품예정일|확정일|납품수량| |확정수량|매입단가|매입금액|I/F발주항번", Align:"Center"}
	            		,{Text:"구분|선택|상태|표준카탈로그|품목코드|품목명|품목명|품목명|규격|규격|담당팀|단위|매출원가|제조사|제조사모델번호", Align:"Center"}	
	            		,{Text:"구분|선택|항번|비고|||||표준카테고리코드|분할여부|종결상태|선입고여부|카탈로그 변경|변경해제사유|삭제", Align:"Center"}	
	             		 
	             	];
	initsheet.HeaderMode = {Sort : 0,ColMove : 1,ColResize : 1};
	initsheet.Cols = [
	      			[
					{ Align:"Center",	Width:60,	Edit : false,	EditLen:0,	Hidden : true,	Type:"Status",	Header:"구분",	SaveName:"sStatus" ,RowSpan:4 } 
					,{ Align:"Center",	Width:60,	Edit : true,	EditLen:100,	Hidden : false,	Type:"DummyCheck",	Header:"",	SaveName:"SELECTED" ,RowSpan:4 } 
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"거래명세서",	SaveName:"STATUS_TEXT"}    // STATUS_TEXT
					,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"협력사",	SaveName:"AGENT_NAME"  , ColSpan:2  , BackColor:"#EEEEEE" }    //[0]  
					,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"협력사",	SaveName:"AGENT_NAME1"  }    //[0] 
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"최종발주수정자",	SaveName:"USER_NAME_LOC"}   //[33]
					,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Date",	Header:"발주일",	SaveName:"PO_CREATE_DATE"}    //[2]
					,{ Align:"Center",	Width:90,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Date",	Header:"납기요청일",	SaveName:"RD_DATE" , Sort:0}   //[10] 
					,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Date",	Header:"입고일",	SaveName:"GR_DATE"}   //[28]
					,{ Align:"Right",	Width:80,	Edit:true,	EditLen:100,	Hidden:false,	Type:"Float",	 Format:"${priceFormat}",	Header:"발주수량",	SaveName:"ITEM_QTY" , BackColor:"#EEEEEE" }   //[4]	수량변경 C005
					,{ Align:"Right",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Float",	 Format:"${priceFormat}",	Header:"납품예정수량",	SaveName:"CD_QTY"}   //[CD_QTY]  
					,{ Align:"Right",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Float",	 Format:"${priceFormat}",	Header:"입고수량",	SaveName:"GR_QTY"}   //[GR_QTY]	
					,{ Align:"Right",	Width:80,	Edit:true,	EditLen:100,	Hidden:false,	Type:"Float",	 Format:"${priceFormat}",	Header:"매출단가",	SaveName:"UNIT_PRICE" , BackColor:"#EEEEEE"}    //[3] 단가변경 C004
					,{ Align:"Right",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Float",	 Format:"${priceFormat}",	Header:"매출금액",	SaveName:"ITEM_AMT"}   //[5]
					,{ Align:"Center",	Width:150,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"I/F발주번호",	SaveName:"LEGACY_PO_NO"}   //[7]
					
					,{ Align:"Center",	Width:10,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"AGENT",	SaveName:"AGENT"}   //[23] 협력사변경 C003
					,{ Align:"Center",	Width:10,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"BUYER",	SaveName:"BUYER"}    //[19]
					,{ Align:"Center",	Width:10,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"BYIT_COMORG_CODE",	SaveName:"BYIT_COMORG_CODE"}    //[20]
					,{ Align:"Center",	Width:10,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"CONTRACT_NO",	SaveName:"CONTRACT_NO"}   //[21]
					,{ Align:"Center",	Width:10,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"CONTRACT_SEQ",	SaveName:"CONTRACT_SEQ"}   //[22]
					,{ Align:"Center",	Width:10,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"SELLER",	SaveName:"SELLER"}    //[SELLER]							
					
					,{ Align:"Center",	Width:10,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"ITEM_QTY_OLD",	SaveName:"ITEM_QTY_OLD"}    //[ITEM_QTY_OLD]							
					,{ Align:"Center",	Width:10,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"ITEM_QTY_ORIGIN",	SaveName:"ITEM_QTY_ORIGIN"}    //[ITEM_QTY_ORIGIN]							
					,{ Align:"Center",	Width:10,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"UNIT_PRICE_ORIGIN",	SaveName:"UNIT_PRICE_ORIGIN"}    //[UNIT_PRICE_ORIGIN]
					,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"PROCESS_TYPE",	SaveName:"PROCESS_TYPE_ORGIN"}    //[PROCESS_TYPE_ORGIN]
	         		],
	         		[
					{ Align:"Center",	Width:60,	Edit : false,	EditLen:0,	Hidden : true,	Type:"Status",	Header:"구분",	SaveName:"sStatus"   } 
					,{ Align:"Center",	Width:60,	Edit : true,	EditLen:100,	Hidden : false,	Type:"DummyCheck",	Header:"",	SaveName:"SELECTED1"  } 
					,{ Align:"Center",	Width:100,	Edit:true,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"관리번호",	SaveName:"REF_PR_NO" , BackColor:"#EEEEEE"}   //[9] 단순항목변경 C001
					,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"거래유형",	SaveName:"PROCESS_NAME" , BackColor:"#EEEEEE" }   //[35]	
					,{Align : "Center",SaveName : "IMPORT_FLAG",		Header : "수입여부",	Type : "Combo", ComboText:"Y|N", ComboCode:"Y|N",	Width : 70,	EditLen : 110,	Edit : true, KeyField:true , BackColor:"#EEEEEE" }		
					,{ Align:"Center",	Width:80,	Edit:true,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"협력사품목코드",	SaveName:"SELLER_ITEM_NO" , BackColor:"#EEEEEE"   }   //[32]		 단순항목변경 C001
					,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Date",	Header:"납품일",	SaveName:"INVOICE_DATE"}   //[INVOICE_DATE]
					,{ Align:"Center",	Width:90,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Date",	Header:"납품예정일",	SaveName:"DS_DATE"}   //[DS_DATE]
					,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Date",	Header:"확정일",	SaveName:"DELIVERY_DATE"}   //[DELIVERY_DATE]
					,{ Align:"Right",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Float",	 Format:"${priceFormat}",	Header:"납품수량",	SaveName:"IV_QTY"}   //[IV_QTY]
					,{ Align:"Right",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Float",	 Format:"${priceFormat}",	Header:"납품수량",	SaveName:"IV_QTY1"}   //[IV_QTY]
					,{ Align:"Right",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Float",	 Format:"${priceFormat}",	Header:"확정수량",	SaveName:"DI_QTY"}   //[DI_QTY]
					,{ Align:"Right",	Width:80,	Edit:true,	EditLen:100,	Hidden:false,	Type:"Float",	 Format:"${priceFormat}",	Header:"매입단가",	SaveName:"AGENT_PRICE" , BackColor:"#EEEEEE" }    //[11] 단가변경 C004
					,{ Align:"Right",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Float",	 Format:"${priceFormat}",	Header:"매입금액",	SaveName:"AGENT_ITEM_AMT"}    //[13]
					,{ Align:"Center",	Width:150,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"I/F발주항번",	SaveName:"LEGACY_PO_SEQ"}    //[15]					 
					,{ Align:"Center",	Width:10,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"UPDATE_YN",	SaveName:"UPDATE_YN"}
					,{ Align:"Center",	Width:10,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Date",	Header:"LAST_CLOSE_DATE",	SaveName:"LAST_CLOSE_DATE"}   //[24]
					,{ Align:"Center",	Width:10,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"PO_NO",	SaveName:"PO_NO"}   //[25]
					,{ Align:"Center",	Width:10,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"PR_NO",	SaveName:"PR_NO"}   //[26]
					,{ Align:"Center",	Width:10,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"PR_SEQ",	SaveName:"PR_SEQ"}   //[27] 
					,{ Align:"Center",	Width:10,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"비고",	SaveName:"PO_REMARK"}    //[18]							
					,{ Align:"Center",	Width:10,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"거래유형",	SaveName:"PROCESS_TYPE"}   //[36] 거래유형변경		C002				
					
					,{ Align:"Center",	Width:10,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"AGENT_PRICE_ORIGIN",	SaveName:"AGENT_PRICE_ORIGIN"}    //[AGENT_PRICE_ORIGIN]							
					,{ Align:"Center",	Width:10,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"ITEM_AMT_ORIGIN",	SaveName:"ITEM_AMT_ORIGIN"}    //[ITEM_AMT_ORIGIN]							
					,{ Align:"Center",	Width:10,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"AGENT_ITEM_AMT_ORIGIN",	SaveName:"AGENT_ITEM_AMT_ORIGIN"}    //[AGENT_ITEM_AMT_ORIGIN]							
					,{ Align:"Center",	Width:10,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"NULL_2",	SaveName:"NULL_2"}    //[NULL 사용안함 칸 유지용]
	     	    	],
	         		[ 
	            		
					{ Align:"Center",	Width:60,	Edit : false,	EditLen:0,	Hidden : true,	Type:"Status",	Header:"구분",	SaveName:"sStatus"   } 
					,{ Align:"Center",	Width:60,	Edit : true,	EditLen:100,	Hidden : false,	Type:"DummyCheck",	Header:"",	SaveName:"SELECTED2"  } 
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"상태",	SaveName:"STATUS"}   //[29]   
					,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"표준카탈로그",	SaveName:"CMS_CATLG_ID"}   //[39]		  단순항목변경 C001
					,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"품목코드",	SaveName:"BUYER_ITEM_NO"}    //[1]  
					,{ Align:"left",	Width:80,	Edit:true,	EditLen:600,	Hidden:false,	Type:"Text",	Header:"품목명",	SaveName:"DESCRIPTION" ,  ColSpan:3 , BackColor:"#EEEEEE" }    //[16] 단순항목변경 C001
					,{ Align:"Center",	Width:80,	Edit:false,	EditLen:600,	Hidden:false,	Type:"Text",	Header:"품목명",	SaveName:"DESCRIPTION1"}    //[16]
					,{ Align:"Center",	Width:90,	Edit:false,	EditLen:600,	Hidden:false,	Type:"Text",	Header:"품목명",	SaveName:"DESCRIPTION2"}    //[16]
					,{ Align:"Center",	Width:80,	Edit:true,	EditLen:2000,	Hidden:false,	Type:"Text",	Header:"규격",	SaveName:"SPECIFICATION"  , ColSpan:2 , BackColor:"#EEEEEE" }    //[17] 단순항목변경 C001
					,{ Align:"Center",	Width:80,	Edit:false,	EditLen:2000,	Hidden:false,	Type:"Text",	Header:"규격",	SaveName:"SPECIFICATION1"}    //[17] 

					,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"담당팀",	SaveName:"ITEM_GROUP_TEXT"}     //[48]
					,{Align : "Center",SaveName : "UNIT_MEASURE",		Header : "단위",	Type : "Combo", ComboText:unit.ComboText, ComboCode:unit.ComboCode,	Width : 70,	EditLen : 110,	Edit : true,  BackColor:"#EEEEEE" } // 단순항목변경 C001
					,{ Align:"Right",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Float",	 Format:"${priceFormat}",	Header:"매출원가",	SaveName:"KEP_PRICE"}    //[44]
					,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"제조사",	SaveName:"MAKER_NAME"}   //[6]   단순항목변경 C001
					,{ Align:"Center",	Width:150,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"제조사모델번호",	SaveName:"MAKER_PART_NO"}    //[14]		
					
					,{ Align:"Center",	Width:10,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"EDITYN",	SaveName:"EDITYN"}   //[31]
					,{ Align:"Center",	Width:10,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"PLAN_AMT_FLAG",	SaveName:"PLAN_AMT_FLAG"}   //[34]
				
					,{ Align:"Center",	Width:10,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"WAREHOUSE_CODE",	SaveName:"WAREHOUSE_CODE"}   //[37]
					,{ Align:"Center",	Width:10,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"MAKER_CODE",	SaveName:"MAKER_CODE"}   //[38]
					,{ Align:"Center",	Width:10,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"ITEM_GROUP",	SaveName:"ITEM_GROUP"}    //[47]					
					,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"사유",	SaveName:"REASON4"  }    //[REASON]	
					,{ Align:"Center",	Width:10,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"UNIT_PRICE_ORGIN",	SaveName:"UNIT_PRICE_ORGIN"}    //[UNIT_PRICE_ORGIN]							
					,{ Align:"Center",	Width:10,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"AGENT_PRICE_ORGIN",	SaveName:"AGENT_PRICE_ORGIN"}    //[AGENT_PRICE_ORGIN]							
					,{ Align:"Center",	Width:10,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"KEP_PRICE_ORIGIN",	SaveName:"KEP_PRICE_ORIGIN"}    //[KEP_PRICE_ORIGIN]			
					,{ Align:"Center",	Width:10,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"NULL_3",	SaveName:"NULL_3"}    //[NULL 사용안함 칸 유지용]
	     	    	],         		[
					{ Align:"Center",	Width:60,	Edit : false,	EditLen:0,	Hidden : true,	Type:"Status",	Header:"구분",	SaveName:"sStatus"   }  
					,{ Align:"Center",	Width:60,	Edit : true,	EditLen:100,	Hidden : false,	Type:"DummyCheck",	Header:"",	SaveName:"SELECTED3"  } 
					,{ Align:"Center",	Width:10,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"발주항번",	SaveName:"PO_SEQ"}   //[8]
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Image",	Header:"비고",	SaveName:"REMARKIMG"}    //[18]		
					,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"사유",	SaveName:"REASON0"   }    //[REASON]		
					,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"사유",	SaveName:"REASON1"}    //[REASON]				
					,{ Align:"Center",	Width:90,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"사유",	SaveName:"REASON2"}    //[REASON]		
					,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"WMS_FLAG",	SaveName:"WMS_FLAG"}    //[REASON]	x	
					,{ Align:"Center",	Width:10,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"CMS_CATEG_ID",	SaveName:"CMS_CATEG_ID"}   //[40]
					,{Align : "Center",SaveName : "DS_FLAG",		Header : "분할여부",	Type : "Combo", ComboText:"Y|N|N/A", ComboCode:"Y|N|",	Width : 70,	EditLen : 110,	Edit : true  , BackColor:"#EEEEEE"}		//  거래명세서를 분할하여 생성할수 있는지에 대한 값

					
					,{Align : "Center",SaveName : "CLSD_FLAG",		Header : "종결상태",	Type : "Combo", ComboText:"종결|복원|N/A", ComboCode:"Y|N|",	Width : 70,	EditLen : 110,	Edit : true , BackColor:"#EEEEEE" }							
					,{Align : "Center",SaveName : "DOC_TYPE",		Header : "선입고여부",	Type : "Combo", ComboText:"선입고|긴급발주|N/A", ComboCode:"S|F|N",	Width : 70,	EditLen : 110,	Edit : true , BackColor:"#EEEEEE" }		
					
					
					,{ Align:"Center",	Width:80,	Edit:true,	EditLen:100,	Hidden:false,	Type:"CheckBox",	Header:"카탈로그 변경",	SaveName:"REASON6"   , BackColor:"#EEEEEE" }    //[CA_FLAG]
					,{ Align:"left",	Width:80,	Edit:true,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"체크해제사유",	SaveName:"CA_EXCEPT_REASON"  , BackColor:"#EEEEEE" }   
					,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Image",	Header:"삭제",	SaveName:"DELIMG"}    //[?]		삭제시 사유 
					
					,{ Align:"Center",	Width:150,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"구분",	SaveName:"REASON10"}    //[REASON]						
					,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"종결가능여부",	SaveName:"CLSD_FLAG_YN"}    //[CLSD_FLAG_YN]		
					,{ Align:"Center",	Width:10,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"ORIGIN_CODE",	SaveName:"ORIGIN_CODE"}    //[42]
					,{ Align:"Center",	Width:10,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"LOGISTICS_FEE",	SaveName:"LOGISTICS_FEE"}    //[45]
					,{ Align:"Center",	Width:10,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"KWAY_FLAG",	SaveName:"KWAY_FLAG"}    //[46]
					,{ Align:"Center",	Width:10,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"LEGACY_IV_SERIAL",	SaveName:"LEGACY_IV_SERIAL"}   
					,{ Align:"Center",	Width:10,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"QTY_CHANGE_FLAG",	SaveName:"QTY_CHANGE_FLAG"}    //[QTY_CHANGE_FLAG]							
					,{ Align:"Center",	Width:10,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"AGENT_ORIGIN",	SaveName:"AGENT_ORIGIN"}    //[TEMP1]
					,{ Align:"Center",	Width:10,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"RD_DATE_ORIGIN",	SaveName:"RD_DATE_ORIGIN"}    //[RD_DATE_ORIGIN]			 
					,{ Align:"Center",	Width:10,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"SIZE_LEN",	SaveName:"SIZE_LEN"}    //[SIZE_LEN]
							
					
	      	    	]								
	     		];
	
	
	initsheet.Cfg={	
			FrozenCol : 3,
			SearchMode : (pagingMode=="Y")?smClientPaging:smLazyLoad,
			Page : 50,
			MergeSheet:msFixedMerge + msHeaderOnly
			};

	//mySheet.InitColumns(initsheet.Cols ,3);

	IBS_InitSheet(mySheet, initsheet,pagingMode); 
	kepSearch_multi(document.searchCondition ,  mySheet , "/mpso/getMasterMpSoOrderInfoAlterBeforeListPop.do" , pagingMode );
	
	
	
	db_buyer_adapt_flag			= $("#BUYER_ADAPT_FLAG").val(); // 매출원가 적용 여부
	db_buyer_rate						= $("#BUYER_RATE").val();
	db_buyer_standard_rate		= $("#BUYER_STANDARD_RATE").val();
	db_supply_direct_rate			= $("#SUPPLY_DIRECT_RATE").val();
	db_stock_rate						= $("#STOCK_RATE").val();
	db_tr_rate							= $("#TR_RATE").val();
	db_vmi_rate							= $("#VMI_RATE").val();
	db_import_rate					= $("#IMPORT_RATE").val();
	
	mySheet.SetCellFontUnderline(0, "AGENT_NAME", true);
	mySheet.SetCellFontUnderline(0, "PROCESS_NAME", true);
	
	// 납기요청일 변경 가능 고객사 추가 - 윈체, 대신시스템 (2017.02.27)
    if ("<%=st_buyer%>" == "KRKORE0212" || "<%=st_buyer%>" == "KRWINC0001" || "<%=st_buyer%>" == "KRWINC0002" || "<%=st_buyer%>" == "KRWINC0003"){
		mySheet.SetCellFontUnderline(0, "RD_DATE", true);
    }else{
    	mySheet.SetCellFontUnderline(0, "RD_DATE", false);        
    }

	//비고이미지설정
	mySheet.SetImageList(1, remarkOn);
	mySheet.SetImageList(0, remarkOff);

}


var st;
var mt;
//긴급발주변경
function emergencypo(){
	
	if (!confirm('긴급발주로 변경하시겠습니까?'))
		return;
	
	<% if (rowData != null){ %>
	var buyer_name = "<%=rowData.get("BUYER_NAME")%>"; 	
	<%}%>
	
	var limit = mySheet.RowCount()    * gridHeaderCount; 
	for ( var i = gridHeaderCount; i <= limit; i++ ) {
		
		if (i%gridHeaderCount == 0){
			 
			if ( mySheet.GetCellValue(i, "SELECTED") == '0' ) {
				 mySheet.SetCellValue(i, "SELECTED", '1');
				 
			}
			if ( mySheet.GetCellValue(i, "SELECTED") == '1' ) {
			       close_date  = mySheet.GetCellValue( i + 1 , "LAST_CLOSE_DATE"); // LAST_CLOSE_DATE
			       gr_date     = mySheet.GetCellValue( i , "GR_DATE");  // 입고일 
			        
			        
			       if(gr_date != ""){
			    	   if (close_date!= ""){
				           if(eval(close_date) > eval(gr_date)){
				               output_flag = 'Y';
				               alert( (i/gridHeaderCount) +" 행 선택하신 목록은 "+buyer_name+" 의 입고 및 마감정산이 완료된 항목입니다.  \n\n  발주삭제는 관리자에게 문의하시기 바랍니다.   ");
				               return ;
				           }
			    	   }
			           alert( (i/gridHeaderCount)  +" 행 선택하신 목록은 입고처리된 항목입니다.\n\n입고내역을 삭제하신 후 발주정보 수정이 가능합니다.");
			           return ;
			       }
			       
			}	
		}
	}
	kepSave_multi(document.searchCondition ,  mySheet , "/mpso/saveOrderUpdateEmegancyPo.do" , "SELECTED" );
	//kepAjaxFormCall("/mpso/saveOrderUpdateEmegancyPo.do", "searchCondition", "SAVE");
	
}
function kepAjaxSuccess(pMethod , response){
	var sMsg = response.msg.MSG;   
	var query = "";
	 
	
    if(sMsg == "CREATE_OK"){ // asis = setCartResult_Refresh
    	
       if(pMethod == "RsaveProcess")  // 나의상품 등록
       { 
    	   alert("나의상품으로 등록 되었습니다.   ");            
        	// 처리후 재조회
        	kepSearch($("#curPage").val());       
 
       }
 	   }
}
/**
 * ajax 공통 호출후 에러시 처리 함수
 */
function  kepAjaxError(pMethod , response) {
	if (pMethod == "RsaveProcess"){ 
		 alert("나의상품등록 실패하였습니다.\n\n다시 한 번 시도해 주시기 바랍니다.  "); 
	} else if (pMethod == "DELETE"){ 
		 alert("삭제 실패하였습니다.\n\n다시 한 번 시도해 주시기 바랍니다.  "); 
	} else{
		 alert("오류발생하였습니다.\n\n다시 한 번 시도해 주시기 바랍니다.  "); 
	}
	 
	
} 

var saveGbn = "N";
//기능함수
function doAction(str) {
	st = new Date();
	
// 	switch(str){
// 	case "emergencypo":	// 긴급발주  -------- 
// 		if (!confirm('긴급발주로 변경하시겠습니까?'))
// 			return;
// 		//kepSave(document.searchCondition ,  mySheet , "/mdam/regMasterMdAmMakerManageRegPop.do" , "SELECTED" );
// 		kepAjaxFormCall("/mpso/saveOrderUpdateEmegancyPo.do", "searchCondition", "saveOrderUpdateEmegancyPo");
	
// 		break;		
// 	}
	
	var selectedGrid = mySheet.FindCheckedRow("SELECTED");
	// 선택된 항목 유무 체크
	if (str !="search1" && str !="search" && str !="clear"  && str !="excelDown" && str !="excelUpload"  && str !="reload" && selectedGrid.length == 0) {
		alert("선택된 항목이 없습니다.");
		return;
	}
	
    var saveTitle = ""; 
    var saveTitleContent = ""; 
	saveFlag = str;
	
	switch (str) {
		case "search": //조회
			current_page = -1;
			st_saveFlag_clear();
			kepSearch_multi(document.searchCondition ,  mySheet , "/mpso/getMasterMpSoOrderInfoAlterBeforeListPop.do" , pagingMode );
			break;
		case "reload":
			document.searchCondition.reset();
			st_saveFlag_clear();
			mySheet.RemoveAll();
			break;
			
		case "save":	// 저장			 
		 	if(processOK == 'N'){
		 		alert("처리중입니다. 잠시만 기다려주십시오.");return;
		 	}
			if(saveGbn == "Y"){
				alert("중복 저장입니다. 해당 창을 닫고 재실행 바랍니다.");return;
			}
			st_saveFlag_clear(); 
			var HC002 = "N"; 
			var HC003 = "N"; 
			var HC004 = "N"; 
			var HC005 = "N"; 
			var checkCnt = 0;
			var processTypeMap = {};
		    // 마감일/입고일 체크
		    if(!check_gr_date(str)) return; 
		
			var limit = mySheet.RowCount()    * gridHeaderCount; 
			for ( var i = gridHeaderCount; i <= limit; i++ ) {
				
				if (i%gridHeaderCount == 0){
					 
					if ( mySheet.GetCellValue(i, "SELECTED") == '1' ) {
						
						checkCnt++;
						
						var buyer  = mySheet.GetCellValue( i  , "BUYER"); 				
		                var agent_code  = mySheet.GetCellValue( i  , "AGENT"); // 협력사		                
		                var kep_price  = mySheet.GetCellValue( i + 2 , "KEP_PRICE"); // 매출원가
		                var imsi_unit_price  = mySheet.GetCellValue( i  , "UNIT_PRICE"); // 매출단가
		                var imsi_st_unit_price_orgin  = mySheet.GetCellValue( i + 2 , "UNIT_PRICE_ORGIN");
		                var kep_price_origin  = mySheet.GetCellValue( i + 2  , "KEP_PRICE_ORIGIN");
		                var unit_price  = mySheet.GetCellValue( i  , "UNIT_PRICE"); // 매출단가
		                var agent_price  = mySheet.GetCellValue( i  + 1  , "AGENT_PRICE");  // 매입단가		
		                var REASON10  = mySheet.GetCellValue( i  + 3  , "REASON10");  // 저장구분
						var iv_qty     = mySheet.GetCellValue( i + 1, "IV_QTY"); 	// 납품수량					
						var bdgt_update_yn  = mySheet.GetCellValue( i+1  , "UPDATE_YN"); // 예산사용여부체크
						var item_qty  = mySheet.GetCellValue( i  , "ITEM_QTY"); // 발주수량
						var item_qty_origin  = mySheet.GetCellValue( i  , "ITEM_QTY_ORIGIN"); // 발주수량변경전
						var st_status_nm  = mySheet.GetCellValue( i+2  , "STATUS"); // 발주수량변경전
						var process_type_tmp = mySheet.GetCellValue(i,"PROCESS_TYPE"); // 거래유형
						var warehouse_code_tmp = mySheet.GetCellValue(i,"WAREHOUSE_CODE"); // 물류센터코드
						
						if(!setMapValue(processTypeMap, process_type_tmp, warehouse_code_tmp)) {							
							alert("동일한 발주 내에서 다른 물류센터를 선택할 수 없습니다.");
							return;	
						}
						
						
						if(st_status_nm != "수주미접수"){
							if(item_qty <  item_qty_origin){
								alert("발주수량 감소는 반품등록 화면 통해서 진행 하시길 바랍니다..");
								return;							
							}
						}
		                if (REASON10 == "" || REASON10 == "N/N/N/N/N/N/N/N/N/N"){
		                	alert((i/gridHeaderCount) + " 번째 저장할 내용이 없습니다.");
		                	return;
		                }  
		                 
					      <% if ("after".equals(st_orderFlag)) { %>
							if(buyer == "KRSSAN0025" && iv_qty != "0" ) {
								alert("쌍용자동차(주)(KRSSAN0025)의 경우 납품서가 생성되어 있으면\n발주변경이 불가합니다.\n납품서 삭제 후 다시 진행하시기 바랍니다.");
								return;
							} 
							<%}%>
							
		                // 저장상태 최종 저장
		                saveFlag_biz(REASON10);
		                
		            	var C000 = REASON10.split("/");
		            	C001 = C000[0]; // 단순항목변경
		            	C002 = C000[1]; // 거래유형변경
		            	C003 = C000[2]; // 협력사변경
		            	C004 = C000[3]; // 단가변경
		            	C005 = C000[4]; // 수량변경		            	
		            	C006 = C000[5]; // 발주삭제
		            	C007 = C000[6]; // 발주초기화
		            	C008 = C000[7]; // 발주종결
		            	C009 = C000[8]; // 종결복원
		            	C0010 = C000[9]; // 수량분할
		            	
		            	//납기요청일 변경은 없어진다. - 20140730
		            	
		            	// 종결 복원 은 혼자 해야한다.
		            	if(C008== "Y" || C009== "Y"){
		            		if (C001 == "Y"
		            			|| C002 == "Y"
		            			|| C003 == "Y"
		            			|| C004 == "Y"
		            			|| C005 == "Y"		            			
		            			|| C006 == "Y"		            			
		            			|| C007 == "Y"		            			
		            			){
		            				alert("해당PO 종결,복원은 다른 변경과 동시에 하실수 없습니다.");
		            				return;
		            			}
		            	}
		            	 
 /* 		            	//당월예산아닌 경우  단가 변경시
		            	if(C004=="Y"&&bdgt_update_yn == "N"){
							alert("당월 예산건이 아니기때문에 단가변경이  불가능 합니다.");
							return;
		            	}
		            	//당월예산아닌 경우  수량 변경시
		            	if(C005=="Y"&&bdgt_update_yn == "N"){
							alert("당월 예산건이 아니기때문에 단가변경이  불가능 합니다.");
							return;
		            	} */ 
		            	if (C001 == "Y"){
		            		saveTitle = saveTitle + "단순항목변경 ";
		            	}
		            	if (C002 == "Y"){
		            		HC002 = "Y";
		            		saveTitle = saveTitle + "거래유형변경 새PO번호생성 ";
		            		saveGbn = "Y";
		            	}
		            	if (C003 == "Y"){
		            		HC003 = "Y";
		            		saveTitle = saveTitle + "협력사변경 결재후 새PO번호생성 ";
		            	}		 
		            	if (C004 == "Y"){
		            		HC004 = "Y";
		            		saveTitle = saveTitle + "단가변경 ";
		            	}
		            	//카탈로그 변경 체크 해제관련 로직
		            	var st_reason6  = mySheet.GetCellValue( i  + 3  , "REASON6");
		            	var st_ca_reason  = mySheet.GetCellValue( i  + 3  , "CA_EXCEPT_REASON");
		            	if(C003 == "Y"||C004 == "Y"){
		            		if(st_reason6 != "1" && st_ca_reason.length < 5){
		            			alert("매출단가, 매입단가, 협력사 변경 시 \n카탈로그 체크 해제 사유를 5자 이상 입력 바랍니다.");
		            			mySheet.SelectCell(i  + 3, "CA_EXCEPT_REASON");
		            			return;
		            		}
		            	}
		            	if (C005 == "Y"){
		            		HC005 = "Y";
		            		saveTitle = saveTitle +  "수량변경";
		            	}		  
		            	if (C008== "Y"){
		            		saveTitle = saveTitle +  "해당PO발주종결";
		            	}	
		            	if (C009 == "Y"){
		            		saveTitle = saveTitle +  "해당PO종결복원";
		            	}	
		            	
		            	if (saveTitle != ""){
		            		saveTitleContent = saveTitleContent +   (i/gridHeaderCount)  + " 번째 " +saveTitle + "\n";
		            	}
		            	/*
		            		길이정보가 들어 갈 경우 분할(윈체 수량 길이 정보가 필요함)
		            	*/
						var st_size_len  = mySheet.GetCellValue( i  + 3  , "SIZE_LEN");
						var chk_item_qty = (parseFloat(item_qty) / parseFloat(st_size_len)).toFixed(2);
		            	chk_item_qty = (chk_item_qty % 1).toFixed(2);
						
		            	if(st_size_len != ""){
		            		if(HC005 == "Y"){
		            			if(chk_item_qty != 0){
		            				alert((i/gridHeaderCount) + " 번째 수량, 길이가 입력된 주문건은 길이 배수로만 변경가능합니다.");
			            			return;	
		            			}
		            		}
		            	}
		            	
		            	saveTitle = "";
		            		
		                var DESCRIPTION  = mySheet.GetCellValue( i  + 2  , "DESCRIPTION");  // 품목명
		                var RD_DATE  = mySheet.GetCellValue( i  , "RD_DATE");  // 납기요청일. 2014.12.23 추가
		                var SPECIFICATION  = mySheet.GetCellValue( i  + 2  , "SPECIFICATION");  // 규격	
		                var ITEM_QTY  = mySheet.GetCellValue( i     , "ITEM_QTY");  // 발주수량 
		                var UNIT_PRICE  = mySheet.GetCellValue( i     , "UNIT_PRICE");  // 매출단가
		                var SELLER_ITEM_NO  = mySheet.GetCellValue( i + 1    , "SELLER_ITEM_NO");  // 협력사품목코드
		                var AGENT_PRICE  = mySheet.GetCellValue( i + 1    , "AGENT_PRICE");  // 매입단가 
		                

		        		//alert(mySheet.GetCellValue(i + 1 ,    "PROCESS_TYPE") + " "+ mySheet.GetCellValue(i + 1 ,    "PROCESS_NAME")); 
		                if ("<%=st_buyer%>" == "KRKORE0212"){ // 2014.12.24 추가
		                	if(DESCRIPTION == "" || SPECIFICATION == "" || ITEM_QTY=="" 
			            		|| UNIT_PRICE==""
			            		|| SELLER_ITEM_NO==""
			            		|| AGENT_PRICE==""
			            		|| RD_DATE==""
			           		) {
			            		alert((i/gridHeaderCount) + " 번째 "+saveTitle +"저장할 내용을 입력하세요.");
								return;
							}  
		                }else if ("<%=st_buyer%>" == "KRWINC0001" || "<%=st_buyer%>" == "KRWINC0002" || "<%=st_buyer%>" == "KRWINC0003"){ // 윈체, 대신시스템 추가(2017.02.27)
		                	if(DESCRIPTION == "" || SPECIFICATION == "" || ITEM_QTY=="" 
			            		|| UNIT_PRICE==""
			            		|| RD_DATE==""
			           		) {
			            		alert((i/gridHeaderCount) + " 번째 "+saveTitle +"저장할 내용을 입력하세요.");
								return;
							}  
		                }else {
			            	if(DESCRIPTION == "" && SPECIFICATION == "" && ITEM_QTY=="" 
			            		&& UNIT_PRICE==""
			           		) {
			            		alert((i/gridHeaderCount) + " 번째 "+saveTitle +"저장할 내용을 입력하세요.");
								return;
							}  
		                }
 
						if(agent_code == "KRKORE0080" || agent_code == "KRKEPW0001" || agent_code=="KRSESI0003") {
							break;
						}  
						
						  <% if ("after".equals(st_orderFlag)) { %> 
							var process_type     = mySheet.GetCellValue( i + 3, "PROCESS_TYPE_ORGIN"); // 거래유형 코드
							var wmsFlag     = mySheet.GetCellValue( i + 3, "WMS_FLAG");  // WMS_FLAG 
 							
								if(process_type != '0'){
									if(wmsFlag == 'N' && ("<%=st_buyer%>" == "KRKORE0212" || "<%=st_buyer%>" == "KRWINC0001" || "<%=st_buyer%>" == "KRWINC0002" || "<%=st_buyer%>" == "KRWINC0003")){ // 2017.02.27 추가
										// 종결 복원 은 혼자 해야한다.
						            	if(C001== "Y"){
						            		if (C002 == "Y"
						            			|| C003 == "Y"
						            			|| C004 == "Y"
						            			|| C005 == "Y"		            			
						            			|| C006 == "Y"		            			
						            			|| C007 == "Y"		            			
						            			|| C008 == "Y"		            			
						            			|| C009 == "Y"		            			
						            			){
						            				alert("납기 요청일 변경은 다른 변경과 동시에 하실수 없습니다.");
						            				return;
						            			}
						            		
						            		if (rdFlag == "Y"){ // 납기요청일 이외에 단순변경건은 기존처럼 송장 삭제후 처리 가능함
						            			alert('재고/VMI/TR 건은 물류센터 송장 삭제후 처리 할 수 있습니다\n\n물류센터와 협의하세요 ==== ');
												return;
						            		}
						            	}
									} else if (wmsFlag == 'N' && "<%=st_buyer%>" != "KRKORE0212"){
										alert('재고/VMI/TR 건은 물류센터 송장 삭제후 처리 할 수 있습니다\n\n물류센터와 협의하세요');
										return;
									}
								}
						<%}%>
	 
					}
				}
			}
			// for문 종료
			// TR변경 시 동일 물류센터인지 확인
			
			
			
			
		    
		    if (		$("#st_masterFlag").val()  == "Y" ) {
				//alert("제조사가 변경 될 경우 표준카탈로그를 수정 바랍니다.");
				//return;
		    }
		     
		    // 한건만 수정일 경우에는 거래유형변경,협력사변경 가능
		    // 여러건일경우에는 불가
		    if (checkCnt == 1){ 
		    }else{		    	
				/**
				 * 거래유형변경 결재품의 없애기로 하였다.
				 * 협력사변경 , 수량 , 단가 변경 결재품의 한다.
				 * 2014.11.13
				 */
	            if ( HC003 == "Y"){
	            	//alert("여러건은 PO 생성으로 인하여 협력사변경\n동시에 할수 없습니다.");
				 	
	            	var AGENT_OLD = "";
					var AGENT_NEW = "";
	            	var agentCnt = 0;
					var limit = mySheet.RowCount()    * gridHeaderCount; 
					for ( var i = gridHeaderCount; i <= limit; i++ ) {				
						if (i%gridHeaderCount == 0){
							
							 if ((mySheet.GetCellValue(i, "SELECTED") == "1") && (mySheet.GetCellValue(i, "AGENT") != mySheet.GetCellValue(i, "AGENT_ORIGIN"))){
								 if (agentCnt == 0){
									AGENT_OLD = mySheet.GetCellValue(i, "AGENT");
								 }else{
									 AGENT_NEW = mySheet.GetCellValue(i, "AGENT");
								 }
								 
								 //alert(agentCnt + " " +AGENT_OLD+ " " +AGENT_NEW);
								 if (agentCnt == 0){									 
								 }else{
									 if (AGENT_OLD != AGENT_NEW){
										 alert("여러건은 PO 생성으로 인하여 같은 협력사로만 변경 가능합니다.");
										 return;
									 }
								 }
								 
								 agentCnt++;
							 }
						}
					} 
	            }
		    }
			/**
			 * 거래유형변경 결재품의 없애기로 하였다.
			 * 협력사변경 , 수량 , 단가 변경 결재품의 한다.
			 * 2014.11.13
			 */  
            if ( HC002 == "Y" && HC003 == "Y"){
            	alert("PO 생성으로 인하여 거래유형변경,협력사변경\n동시에 할수 없습니다.");
            	return;
            }			 
            if ( HC002 == "Y" && HC004 == "Y"){
            	alert("PO 생성으로 인하여 거래유형변경,수량변경,단가변경\n동시에 할수 없습니다.");
            	return;
            }
            if ( HC002 == "Y" && HC005 == "Y"){
            	alert("PO 생성으로 인하여 거래유형변경,수량변경,단가변경\n동시에 할수 없습니다.");
            	return;
            }
            
            
			//alert($("#st_saveFlag").val());
			//alert($("#st_saveFlag_code").val());
			
		    if (confirm(saveTitleContent + "선택된 내역을 저장하시겠습니까?")==false) return;

			// 결재진행(협력사변경 , 수량 , 단가 변경) 경우가 아니면 사유를 입력하도록 한다. 
			// 결재진행 경우라면 사유에 "결재참조" 라 넣고 진행한다.
			if ( HC003 == 'N' && HC004 == 'N' && HC005 == 'N') {
				// 사유입력
				openSearchPopup('/mppo/showBuyerMpPoRejectReasonPop.do','?openYn=O',"500,280,no");
			} else {
				saveGbn = "N";
				setReason("결재참조");
			}
			
			break;
			
		case "realSave":
			processOK = 'N';
			kepSave_multi(document.searchCondition ,  mySheet , "/mpso/saveOrderChangeCombineLogic.do" , "SELECTED" );
			break;
			
		case "clear":	// 발주초기화 setSysopOrderChangeAfterPoInit
		// 사내매출 체크 사용안함
		// 접수후에만 사용
		//
		 	if(processOK == 'N'){
		 		alert("처리중입니다. 잠시만 기다려주십시오.");return;
		 	}
		
			st_saveFlag_clear();
		
			var limit = mySheet.RowCount()    * gridHeaderCount; 
			for ( var i = gridHeaderCount; i <= limit; i++ ) {				
				if (i%gridHeaderCount == 0){
					 mySheet.SetCellValue(i, "SELECTED", '1');
				}
			}
		    // 마감일/입고일 체크
		    if(!check_gr_date(str)) return; 		
		    
			for ( var i = gridHeaderCount; i <= limit; i++ ) {
				
				if (i%gridHeaderCount == 0){ 
					 
					if ( mySheet.GetCellValue(i, "SELECTED") == '1' ) {
						var buyer  = mySheet.GetCellValue( i  , "BUYER");
						var po_no  = mySheet.GetCellValue( i + 1 , "PO_NO");
						var iv_qty     = mySheet.GetCellValue( i + 1, "IV_QTY"); 	// 납품수량					
		                var agent_code  = mySheet.GetCellValue( i  , "AGENT"); // 협력사

						if(agent_code == "KRKORE0080" || agent_code == "KRKEPW0001" || agent_code=="KRSESI0003") {
							break;
						} 
		                <% if ("after".equals(st_orderFlag)) { %>
						if(buyer == "KRSSAN0025" && iv_qty != "0" ) {
							alert("쌍용자동차(주)(KRSSAN0025)의 경우 납품서가 생성되어 있으면\n발주변경이 불가합니다.\n납품서 삭제 후 다시 진행하시기 바랍니다.");
							return;
						}
						<%}%>
						var process_type     = mySheet.GetCellValue( i + 3, "PROCESS_TYPE_ORGIN"); // 거래유형 코드
						var wmsFlag     = mySheet.GetCellValue( i + 3, "WMS_FLAG");  // WMS_FLAG
						  
						if(process_type == '1' || process_type == '3'){
							alert('재고/VMI 건은 발주초기화가 불가능 합니다.\n\n시스템 운영팀에 문의 바랍니다.');
							return;
						}	
						if(process_type != '0'){
							if(wmsFlag == 'N'){
								alert('재고/VMI/TR 건은 물류센터 송장 삭제후 처리 할 수 있습니다\n\n물류센터와 협의하세요');
								return;
							}
						}
						
						var C001 = "N";
						var C002 = "N";
						var C003 = "N";
						var C004 = "N";
						var C005 = "N"; 
						
						var C006 = "N"; 
						var C007 = "Y";  // 발주초기화
						var C008 = "N";  // 발주종결
						
						var C009 = "N";  // 종결복원
						var C010 = "N";  // 수량분할
						
		                // 저장상태 최종 저장 
						saveFlag_biz(C001+"/"+C002+"/"+C003+"/"+C004+"/"+C005+"/"+C006+"/"+C007+"/"+C008+"/"+C009+"/"+C010);
						mySheet.SetCellValue(i + 3, 'REASON10', C001+"/"+C002+"/"+C003+"/"+C004+"/"+C005+"/"+C006+"/"+C007+"/"+C008+"/"+C009+"/"+C010);
						
					}
				}
			}   
			
			//alert($("#st_saveFlag").val());
			//alert($("#st_saveFlag_code").val());
			
		    if(!confirm(po_no + " 전체 발주의 진행상태를 수주접수전 상태로 변경 하시겠습니까?\n\n※ 주의 : 협력사의 수주접수/거래명세서/납품실적 내역이 삭제됩니다.")) return;
			// 사유입력
	        openSearchPopup('/mppo/showBuyerMpPoRejectReasonPop.do','?openYn=O',"500,280,no");		 
			break;			
			
			
		case "realClear":
			processOK = 'N';
			kepSave_multi(document.searchCondition ,  mySheet , "/mpso/saveOrderChangeCombineLogic.do" , "SELECTED" );
			break;
			 
		case "del":	// 발주삭제 setSysopOrderChangeAfterDelete
			// 사내매출 체크 사용안함
			// 접수후에만 사용
			//
		 	if(processOK == 'N'){
		 		alert("처리중입니다. 잠시만 기다려주십시오.");return;
		 	}
			
			st_saveFlag_clear();
		
		    // 마감일/입고일 체크
		    if(!check_gr_date(str)) return;		
		
		   // 접수전
		   <% if (!"after".equals(st_orderFlag)) { %>
			    var cardUseCheck = "<%=cardUseCheck%>";
			    if(cardUseCheck == "Y"){
			        alert(" 신용카드로 결제한 주문은 수정 및 삭제할 수 없습니다.");
			        return;
			    }
		    <%}%>
		
			var limit = mySheet.RowCount()    * gridHeaderCount; 
			for ( var i = gridHeaderCount; i <= limit; i++ ) {
				
				if (i%gridHeaderCount == 0){
					 
					if ( mySheet.GetCellValue(i, "SELECTED") == '1' ) {
						var buyer  = mySheet.GetCellValue( i  , "BUYER");
						var iv_qty     = mySheet.GetCellValue( i + 1, "IV_QTY"); 	// 납품수량					
		                var agent_code  = mySheet.GetCellValue( i  , "AGENT"); // 협력사
						var process_type = mySheet.GetCellValue( i + 3, "PROCESS_TYPE_ORGIN"); // 거래유형 코드
						var wmsFlag      = mySheet.GetCellValue( i + 3, "WMS_FLAG");  // WMS_FLAG 
						var bdgt_update_yn  = mySheet.GetCellValue( i+1  , "UPDATE_YN"); // 예산사용여부체크
						var po_no     = mySheet.GetCellValue( i + 1, "PO_NO"); 	// 발주번호
						var po_seq     = mySheet.GetCellValue( i + 3, "PO_SEQ"); 	// 발주항번
/* 						if(bdgt_update_yn == "N"){
							alert("당월 예산건이 아니기때문에 발주삭제가 불가능 합니다.");
							return;
						} */
						if(agent_code == "KRKORE0080" || agent_code == "KRKEPW0001" || agent_code=="KRSESI0003") {
							break;
						} 		
					      <% if ("after".equals(st_orderFlag)) { %>
						if(buyer == "KRSSAN0025" && iv_qty != "0" ) {
							alert("쌍용자동차(주)(KRSSAN0025)의 경우 납품서가 생성되어 있으면\n발주변경이 불가합니다.\n납품서 삭제 후 다시 진행하시기 바랍니다.");
							return;
						} 
						<%}%>
                        
						// 20150113 물류 송장생성건 발주삭제 불가
						if(process_type != '0'){
							if(wmsFlag == 'N'){
								alert('재고/VMI/TR 건은 물류센터 송장 삭제후 처리 할 수 있습니다\n\n물류센터와 협의하세요');
								return;
							}
						}
		                //수주접수 이력체크
						var porsYn = getPorsYn(buyer,po_no,po_seq);
						if(porsYn =="Y"){
							alert(" 수주접수 또는 수주접수 이력이 존재하기 때문에\n반품등록 화면에서 진행 하시길 바랍니다.");
							return;				
						}
					}
				}
			}  

			if (confirm("선택된 내역을 삭제하시겠습니까?")==false) return;
			
			var limit = mySheet.RowCount()    * gridHeaderCount; 
			for ( var i = gridHeaderCount; i <= limit; i++ ) {
				if (i%gridHeaderCount == 0){
					if ( mySheet.GetCellValue(i, "SELECTED") == '1' ) {
						var C001 = "N";
						var C002 = "N";
						var C003 = "N";
						var C004 = "N";
						var C005 = "N"; 
						
						var C006 = "Y";  // 발주삭제
						var C007 = "N";  // 발주초기화
						var C008 = "N";  // 발주종결
						
						var C009 = "N";  // 종결복원
						var C010 = "N";  // 수량분할
						
		                // 저장상태 최종 저장 
						saveFlag_biz(C001+"/"+C002+"/"+C003+"/"+C004+"/"+C005+"/"+C006+"/"+C007+"/"+C008+"/"+C009+"/"+C010);
						mySheet.SetCellValue(i + 3, 'REASON10', C001+"/"+C002+"/"+C003+"/"+C004+"/"+C005+"/"+C006+"/"+C007+"/"+C008+"/"+C009+"/"+C010);
						
					}
				}
			}
			
			//alert($("#st_saveFlag").val());
			//alert($("#st_saveFlag_code").val());
		    
			// 사유입력
	        openSearchPopup('/mppo/showBuyerMpPoRejectReasonPop.do','?openYn=O',"500,280,no");		  
			break;		
			
		case "delsave":	// 발주삭제 setSysopOrderChangeAfterDelete  
			processOK = 'N';
			kepSave_multi(document.searchCondition ,  mySheet , "/mpso/saveOrderChangeCombineLogic.do" , "SELECTED" );
			break;						
			 
		case "regRPop":	// 반품등록 팝업호출  
			var buyer = "";
			var po_no = "";
			var po_seq = "";
			var cnt = 0;
			var limit = mySheet.RowCount()    * gridHeaderCount;
			for ( var i = gridHeaderCount; i <= limit; i++ ) {
					if (i%gridHeaderCount == 0){
						if ( mySheet.GetCellValue(i, "SELECTED") == '1' ) {
							buyer  = mySheet.GetCellValue( i  , "BUYER");
							po_no     = mySheet.GetCellValue( i + 1, "PO_NO"); //발주번호
							po_seq = mySheet.GetCellValue( i + 3, "PO_SEQ"); // 발주항번
							cnt++;
							
						}
					}
				}  
			if(cnt != 1){
				alert("복수 반품등록은 불가능 합니다.");
				return;
			}
			regReturnPop(buyer,po_no,po_seq);
			break;		
		case "end":	// 발주종결  -------- 저장으로 통합 
			break;					
			
		case "realend": 
			
		case "endback":	// 종결복원  -------- 저장으로 통합		 	    
			break;							
			
		case "realendback": 
			break;
			 
	}

}
function getPorsYn(buyer,po_no,po_seq) {  
	var rtnData = "";
	$.ajax({
	      type: "POST",
	      dataType:"json",
	      url: "/wmre/getPorsYn.do",
	      headers: { 'X-Requested-With': 'XMLHttpRequest' },
	      data: { param1: buyer,param2: po_no,param3:po_seq},
	     async : false,
	     success:function( response ) {  		    	  
    	 	if (response.data.length > 0){
 		    	  for (var i=0; i<response.data.length; i++){ 
 		    		rtnData = $.trim(eval("response.data["+i+"].DATA_YN")); 
	 		      }	 		    
    		  }
		      },
		 error:function( response ) {  		    	   
	    	 alert("오류발생하였습니다.");
		      }
    });  
	return rtnData;
}
function st_saveFlag_clear(){
	$("#st_saveFlag").val("N/N/N/N/N/N/N/N/N/N"); // 초기원복
	$("#st_saveFlag_code").val(""); // 초기원복
	
	header_C001_code = "";
	header_C002_code = "";
	header_C003_code = "";
	header_C004_code = "";
	header_C005_code = "";
	header_C006_code = "";
	header_C007_code = "";
	header_C008_code = "";
	header_C009_code = "";
	header_C010_code = "";
}
 

function setReason(value){
	saveGbn = "N";
	var limit = mySheet.RowCount()    * gridHeaderCount; 
	for ( var i = gridHeaderCount; i <= limit; i++ ) {
		
		if (i%gridHeaderCount == 0){
			 
			if ( mySheet.GetCellValue(i, "SELECTED") == '1' ) {
				mySheet.SetCellValue( i+ 3, 'REASON0', value); //  사유
			}
		}
	} 
	
    $("#st_reason").val(value); //  사유
    
	if (saveFlag == "save"){ // 저장
		doAction('realSave');
	}else if (saveFlag == "clear"){ // 발주초기화
		doAction('realClear');
	}else if (saveFlag == "del"){ // 삭제
		doAction('delsave');
	}else if (saveFlag == "end"){ // 종결
		doAction('realend');
	}else if (saveFlag == "endback"){ // 종결복원
		doAction('realendback');
	}
	
}


function saveFlag_biz(saveflag){
	
	
	var st_saveFlag = $("#st_saveFlag").val(); //  st_saveFlag
	

	var saveflagHeaderArray = st_saveFlag.split("/");
	var saveflagDetailArray = saveflag.split("/");
	var header_C001 = saveflagHeaderArray[0]; // 단순항목변경 
	var header_C002 = saveflagHeaderArray[1]; // 거래유형변경
	var header_C003 = saveflagHeaderArray[2]; // 협력사변경
	var header_C004 = saveflagHeaderArray[3]; // 단가변경
	var header_C005 = saveflagHeaderArray[4]; // 수량변경	
	var header_C006 = saveflagHeaderArray[5]; // 발주삭제
	var header_C007 = saveflagHeaderArray[6]; // 발주초기화
	var header_C008 = saveflagHeaderArray[7]; // 발주종결
	var header_C009 = saveflagHeaderArray[8]; // 종결복원
	var header_C010 = saveflagHeaderArray[9]; // 수량분할
	
	var detail_C001 = saveflagDetailArray[0]; // 단순항목변경
	var detail_C002 = saveflagDetailArray[1]; // 거래유형변경
	var detail_C003 = saveflagDetailArray[2]; // 협력사변경
	var detail_C004 = saveflagDetailArray[3]; // 단가변경
	var detail_C005 = saveflagDetailArray[4]; // 수량변경	
	var detail_C006 = saveflagDetailArray[5]; // 발주삭제
	var detail_C007 = saveflagDetailArray[6]; // 발주초기화
	var detail_C008 = saveflagDetailArray[7]; // 발주종결
	var detail_C009 = saveflagDetailArray[8]; // 종결복원
	var detail_C010 = saveflagDetailArray[9]; // 수량분할
	
  
	
	if (header_C001== "N"){
		header_C001 = detail_C001; 
		if (header_C001 == "Y") {
			header_C001_code = "C001^"; 
		}
	} 
	if (header_C002== "N"){
		header_C002 = detail_C002;
		if (header_C002 == "Y") {
			header_C002_code = "C002^";
		}
	} 
	if (header_C003== "N"){
		header_C003 = detail_C003;
		if (header_C003 == "Y") {
			header_C003_code = "C003^";
		}
	} 
	if (header_C004== "N"){
		header_C004 = detail_C004;
		if (header_C004 == "Y") {
			header_C004_code = "C004^";
		}
	} 
	if (header_C005== "N"){
		header_C005 = detail_C005;
		if (header_C005 == "Y") {
			header_C005_code = "C005^";
		}
	} 
	if (header_C006== "N"){
		header_C006 = detail_C006;
		if (header_C006 == "Y") {
			header_C006_code = "C006^";
		}
	} 	
	if (header_C007== "N"){
		header_C007 = detail_C007;
		if (header_C007 == "Y") {
			header_C007_code = "C007^";
		}
	} 	
	if (header_C008== "N"){
		header_C008 = detail_C008;
		if (header_C008 == "Y") {
			header_C008_code = "C008^";
		}
	}  
	if (header_C009== "N"){
		header_C009 = detail_C009;
		if (header_C009 == "Y") {
			header_C009_code = "C009^";
		}
	} 	 
	if (header_C010== "N"){
		header_C010 = detail_C010;
		if (header_C010 == "Y") {
			header_C010_code = "C010^";
		}
	} 		
	
	$("#st_saveFlag").val(header_C001+"/"+header_C002+"/"+header_C003+"/"+header_C004+"/"+header_C005+"/"+header_C006+"/"+header_C007+"/"+header_C008+"/"+header_C009+"/"+header_C010);
	$("#st_saveFlag_code").val(header_C001_code+header_C002_code+header_C003_code+header_C004_code+header_C005_code+header_C006_code+header_C007_code+header_C008_code+header_C009_code+header_C010_code);
}

function mySheet_OnLoadData(DATA) {
	mt = new Date();
	return DATA;
}

function mySheet_OnSearchEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}	

	if(mySheet.RowCount() <= 0) return;
	
	if (msg != "") {
		alert(msg);
	}
	// 한국항공우주산업(주) 납기요청일 수정 가능 (2014.12.23) - 윈체, 대신시스템 추가(2017.02.27)
	if ("<%=st_buyer%>" == "KRKORE0212" || "<%=st_buyer%>" == "KRWINC0001" || "<%=st_buyer%>" == "KRWINC0002" || "<%=st_buyer%>" == "KRWINC0003"){
		mySheet.SetColEditable("RD_DATE", 1);
		mySheet.SetColBackColor("RD_DATE", "#EEEEEE");
	}
	/*
	if(current_page==-1){
		makePageIndex2( mySheet , 1 , document.searchCondition.onepagerow.value);
	}else{
		makePageIndex2( mySheet , current_page , document.searchCondition.onepagerow.value);	
	}
	*/
	
}


//트랜젝션(저장,삽입등) 후처리
function mySheet_OnSaveEnd(code, msg, stCode) {
	processOK = 'Y';
	if(!checkedSession(stCode)){return;} 
	if (msg != "") {
		var msgType = msg.substring(0,2);
		if (msgType == "TM"){
			openSearchPopup('/common/approval/buyerCommonApprovalPop.do','?DOC_TYPE=OE&requesTemptYn=N&DOCU_NO=&BIZ_DOCU_NO='+msg , "1000,500,no");
		}else{
			loader_obj("N");
			alert(msg);		 
			//저장 성공시 재조회
			location.reload();	 
		}	    
	} 	
}

function kepApprovalReturn(ERR,GW_NO){
	location.reload();
}
 

//페이지 인덱스 눌렀을 경우 조회
function pageSearch(param){
	//조회
	current_page = param.page;
	kepSearch_multi(document.searchCondition ,  mySheet , "/mpso/getMasterMpSoOrderInfoAlterBeforeListPop.do?page="+current_page , pagingMode );
}

//그리드 셀클릭 이벤트
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	
	if (Value == "") return;

	if ( Row  < gridHeaderCount) {
		  
			var column = mySheet.ColSaveName(Row ,Col );		
			if (column == "AGENT_NAME" ){ // 협력사선택		 
				
				var cnt = 0;
				var agent = "";
				var agent_name = "";
				var limit = mySheet.RowCount()    * gridHeaderCount; 
				for ( var i = gridHeaderCount; i <= limit; i++ ) {					
					if (i%gridHeaderCount == 0){						 
						if ( mySheet.GetCellValue(i, "SELECTED") == '1' ) {
							
							if (cnt == 0){
								agent = mySheet.GetCellValue(i,  "AGENT");
								agent_name = mySheet.GetCellValue(i,  "AGENT_NAME");
							}else{
								mySheet.SetCellValue(i,  "AGENT" , agent);
								mySheet.SetCellValue(i,  "AGENT_NAME" , agent_name);
							}
							
							cnt ++;
						}
					}
				}
				
				
			}else  if (column == "PROCESS_NAME" ){ // 거래유형
				
				var cnt = 0;
				var process_type = "";
				var process_name = "";
				var warehouse_code = "";
				var limit = mySheet.RowCount()    * gridHeaderCount; 
				for ( var i = gridHeaderCount; i <= limit; i++ ) {					
					if (i%gridHeaderCount == 0){						 
						if ( mySheet.GetCellValue(i, "SELECTED") == '1' ) {
							
							if (cnt == 0){
								process_type = mySheet.GetCellValue(i,  "PROCESS_TYPE");
								process_name = mySheet.GetCellValue(i,  "PROCESS_NAME");
								warehouse_code = mySheet.GetCellValue(i,  "WAREHOUSE_CODE");
							}else{
								mySheet.SetCellValue(i,  "PROCESS_TYPE" , process_type);
								mySheet.SetCellValue(i,  "PROCESS_NAME" , process_name);
								mySheet.SetCellValue(i,  "WAREHOUSE_CODE" , warehouse_code);
							}
							cnt ++;
						}
					}
				}
				
			}else  if (column == "RD_DATE" ){ // 거래유형
				
				var cnt = 0;
				var rd_date = "";
				var limit = mySheet.RowCount()    * gridHeaderCount; 
				for ( var i = gridHeaderCount; i <= limit; i++ ) {					
					if (i%gridHeaderCount == 0){						 
						if ( mySheet.GetCellValue(i, "SELECTED") == '1' ) {
							
							if (cnt == 0){
								rd_date = mySheet.GetCellValue(i,  "RD_DATE");
							}else{
								mySheet.SetCellValue(i,  "RD_DATE" , rd_date);
							}
							cnt ++;
						}
					}
				}
				
			}
			
		} else {
				
			var DataRow = (Row%gridHeaderCount); 
			var column = mySheet.ColSaveName(DataRow ,Col );
			
			
			grbRow = Row;
			grbCol = Col;	
			popupSel = column;	  
			
			if (column == "STATUS_TEXT" ){ // 거래명세서
				
				var buyer 				= mySheet.GetCellValue(Row, "BUYER");
				var po_no 				= mySheet.GetCellValue(Row, "PO_NO");
				var inv_no 				= mySheet.GetCellValue(Row, "STATUS_TEXT");
				var legacy_iv_serial	= mySheet.GetCellValue(Row, "LEGACY_IV_SERIAL");
				var agent 				= mySheet.GetCellValue(Row, "AGENT");
				
				var param = "?st_buyer="+buyer+"&st_po_no="+po_no+"&st_inv_no="+inv_no+"&st_legacy_iv_serial="+legacy_iv_serial+"&st_agent="+agent;
				
				if(inv_no.substring(0,2) == "IK"){
					openSearchPopup("/common/mpiv/invoiceDisplayPop.do", '?INV_NO='+inv_no+'&BUYER='+buyer, "800,550,no");
				} else {
					openSearchPopup("/mpso/getMasterMpSoTranStatementDetailPop.do", param, "930,630,no");
				}

				return;
			}else if (column == "AGENT_NAME" ){ // 협력사선택		 
				
		        var process_type = mySheet.GetCellValue(Row + 1,    "PROCESS_TYPE");  // 거래유형 코드
		        if(process_type == "1" || process_type == "3")
		        {
		           alert("재고 또는 VMI 상품은 협력사 변경이 불가합니다.\n\n물류센타 카탈로그 변경 후 가능합니다.");
		           return;
		        }
				
		        openSearchPopup("/common/icomcmpyPop.do", '?BUSINESS_COND=S&MULTI=N&st_buyer='+"<%=st_buyer%>", "500,466,no");
				
			}else if (column == "MAKER_NAME" ){ // 제조사정보
				
				openSearchPopup('/common/agentRegMakerCodePop.do', '?1=1' , "500,500,no"); 
			
			}else if (column == "CMS_CATLG_ID" ){ // 표준카탈로그 검색?
				
					
				// 사용안함으로 결정 20140922
				/*
				AS-IS상에 주문정보수정(발주정보수정)팝업에서
				호출되는 표준카탈로그 수정팝업은 사내매출의 기능이므로
				TO-BE에서는 사용하지 않음을 김승우팀장님께서 확인해주셨습니다.
				*/
				return 
				//kepOpenSearchPopup('masterMpRqStndrdCatalogPop','' , "500,500,no"); 
				
			}else if (column == "PROCESS_NAME" ){ // 거래유형
				
				org_process_type = mySheet.GetCellValue(Row,    "PROCESS_TYPE_ORGIN");  // 거래유형 코드   
				openSearchPopup("/coco/getCommonCoCoGoodsDlvyClssifyPop.do",'' , "500,250,no"); 
				//kepOpenSearchPopup('processType', '?1=1');	
			
			}else if (column == "ITEM_GROUP_TEXT" ){ // 담당팀구분
				return;
				openSearchPopup('/coco/getCommonCoCoTeamClassifyPop.do', '?st_nu_i=0' , "500,200,no"); 
			}else if (column == "REMARKIMG" ){ // 비고
				
				if (mySheet.GetCellValue(Row, "PO_REMARK") == ""){
					alert("비고 내용이 없습니다.");
					return;
				}
				
				openSearchPopup('/common/remarkBtoAPop.do', '?st_btoa_remark='+mySheet.GetCellValue(Row,  "PO_REMARK") , "500,220,no"); 
			}else if (column == "DELIMG" ){ // 삭제
				
				return;
				openSearchPopup('/common/remarkBtoAPop.do', '?st_btoa_remark='+mySheet.GetCellValue(Row,  "PO_REMARK") , "500,220,no"); 
			}
	}
	return;
}

var rdFlag = "N";
function mySheet_OnChange(Row, Col, Value, OldValue, RaiseFlag) {

	var C001 = "N";
	var C002 = "N";
	var C003 = "N";
	var C004 = "N";
	var C005 = "N"; 
	
	var C006 = "N"; 
	var C007 = "N"; 
	var C008 = "N"; 
	
	var C009 = "N"; 
	var C010 = "N"; 
	
	var CLSD_FLAG_YN = ""; // 종결가능여부
	 

	if ( Row  < gridHeaderCount) return;  
	var DataRow = (Row%gridHeaderCount);  
	var column = mySheet.ColSaveName(DataRow ,Col ); 
	
	if (column == "REASON10" ){  
		return;
	}
	
	var num = 0;
	if (DataRow == 0){
		num = Row + gridHeaderCount;
	}else{
		num = Math.ceil(Row/gridHeaderCount) * gridHeaderCount;
	}
	num = num - gridHeaderCount;
	
	var REASON10 = mySheet.GetCellValue(num,  "REASON10");
	if (REASON10 == ""){
		REASON10 =  C001+"/"+C002+"/"+C003+"/"+C004+"/"+C005+"/"+C006+"/"+C007+"/"+C008+"/"+C009+"/"+C010;
	}
	 
	
	var C000 = REASON10.split("/");
	C001 = C000[0]; // 단순항목변경
	C002 = C000[1]; // 거래유형변경
	C003 = C000[2]; // 협력사변경
	C004 = C000[3]; // 단가변경
	C005 = C000[4]; // 수량변경
	
	C006 = C000[5]; // 발주삭제
	C007 = C000[6]; // 발주초기화
	C008 = C000[7]; // 발주종결
	C009 = C000[8]; // 종결복원
	C010 = C000[9]; // 수량분할
	
	if (C006 == "Y") { C006 = "N"; }
	if (C007 == "Y") { C007 = "N"; }
	  
	if (column == "PROCESS_TYPE" ){  
		if (Value != mySheet.GetCellValue(num , "PROCESS_TYPE_ORGIN")){ // 거래유형 거래유형변경		C002 
			C002 = "Y";
			RaiseFlag = 0;
		}else{
			C002 = "N";
			RaiseFlag = 0;	
		}
	}
	else if (column == "AGENT" ){  
		if (Value != mySheet.GetCellValue(num , "AGENT_ORIGIN")){ // 협력사협력사변경 C003
			C003 = "Y";
			RaiseFlag = 0;
			mySheet.SetCellValue(num, 'REASON6', '1');
		}else{
			C003 = "N";
			RaiseFlag = 0;	
		}
	}else if (column == "MAKER_NAME" ){  
		if (Value != OldValue){ // 제조사 단순항목변경 C001
			C001 = "Y";
			rdFlag = "Y";
			RaiseFlag = 0;
			
			// 제조사를 변경하면 표준카탈로그 매핑을 삭제하고 (PODT.CMS_CATLG_ID = '') 변경 가능토록 해야함
			mySheet.SetCellValue(num, 'CMS_CATLG_ID', "");
		}
	} else if (column == "RD_DATE" ){  
		if (Value != mySheet.GetCellValue(num , "RD_DATE_ORIGIN")){ // 납기요청일 단순항목변경		C001 
			C001 = "Y";
			RaiseFlag = 0;
		}else{
			C001 = "N";
			RaiseFlag = 0;	
		}
	}
	
	if (RaiseFlag != "0") return; // 직접수정이 아니면 모두 return
	
	
	
	
	if (column == "ITEM_QTY" ){  
		if (Value != OldValue){ // 발주수량 수량변경 C005
			C005 = "Y";
		}
	} else if (column == "UNIT_PRICE" ){  
		if (Value != OldValue){ // 납품예정수량 단가변경 C004
			C004 = "Y";
			mySheet.SetCellValue(num, 'REASON6', '1'); 
		}
	}else if (column == "REF_PR_NO" ){  
		if (Value != OldValue){ // 관리번호 단순항목변경 C001
			C001 = "Y";
			rdFlag = "Y";
		}
	}else if (column == "AGENT_PRICE" ){  
		if (Value != OldValue){ // 매입단가 단가변경 C004
			C004 = "Y";
			mySheet.SetCellValue(num, 'REASON6', '1');
		}
	}else if (column == "CMS_CATLG_ID" ){  
		if (Value != OldValue){ // 표준카탈로그 단순항목변경 C001
			C001 = "Y";
			rdFlag = "Y";
		}
	}else if (column == "SELLER_ITEM_NO" ){  
		if (Value != OldValue){ // 협력사품목코드 단순항목변경 C001
			C001 = "Y";
			rdFlag = "Y";
		}
	}else if (column == "DESCRIPTION" ){  
		if (Value != OldValue){ // 품목명 단순항목변경 C001
			C001 = "Y";
			rdFlag = "Y";
		}
	}else if (column == "RD_DATE" ){  
		if (Value != OldValue){ // 납기요청일 단순항목변경 C001 - 추가.2014-12-23 
			C001 = "Y";
		}
	}else if (column == "SPECIFICATION" ){  
		if (Value != OldValue){ // 규격 단순항목변경 C001
			C001 = "Y";
			rdFlag = "Y";
		}
	}else if (column == "UNIT_MEASURE" ){  
		if (Value != OldValue){ // 단위 단순항목변경 C001
			C001 = "Y";
			rdFlag = "Y";
		}
	}
/*
	else if (column == "KEP_PRICE" ){  
		if (Value != OldValue){ // 매출원가 단가변경 C004
			C004 = "Y";
		}
	}else if (column == "IMPORT_FLAG" ){  
		if (Value != OldValue){ // 수입여부 단순항목변경 C001 
			C004 = "Y";  // KEP_PRICE  매출원가 단가변경 C004
		}
	}
*/
	else if (column == "CLSD_FLAG" ){  
		
		CLSD_FLAG_YN = mySheet.GetCellValue(num,  "CLSD_FLAG_YN"); 		 
		if (Value != OldValue){   
			if (CLSD_FLAG_YN == "CLSD_FLAG_Y"){ // 종결가능			
			}else if (CLSD_FLAG_YN == "CLSD_FLAG_N"){ // 종결불가
				if (Value == "Y"){
					alert("입고되지 않은 수량이 존재하므로 발주종결 불가합니다. 확인부탁드립니다.");
					mySheet.SetCellValue(num,  "CLSD_FLAG" , OldValue );
					C001 = "N";
					C006 = "N";
					C007 = "N";
					C008 = "N";
					C009 = "N";
					C010 = "N";
					mySheet.SetCellValue(num, 'REASON10', C001+"/"+C002+"/"+C003+"/"+C004+"/"+C005+"/"+C006+"/"+C007+"/"+C008+"/"+C009+"/"+C010);
					return;
				}
			} 
			C006 = "N";
			C007 = "N";
			C008 = "N";
			C009 = "N"; 
			C010 = "N";
			 if (Value == "Y"){
				 C008 = "Y"; // 발주종결
			 }else if (Value == "N"){
				 C009 = "Y"; // 종결복원
			 }else if (Value == ""){ 
				  
				alert("종결상태 N/A는 복원으로 처리됩니다.");
				mySheet.SetCellValue(num,  "CLSD_FLAG" , "N" );
				C009 = "Y";
				 
			 }else{
					C006 = "N";
					C007 = "N";
					C008 = "N";
					C009 = "N";
					C010 = "N";
			 }
		}
	}  else if (column == "DOC_TYPE" ){  
		if (Value != OldValue){ // 긴급여부  단순항목변경 C001
			C001 = "Y";
			rdFlag = "Y";
			var limit = mySheet.RowCount()    * gridHeaderCount; 
			for ( var i = gridHeaderCount; i <= limit; i++ ) {				
				if (i%gridHeaderCount == 0){					  
						mySheet.SetCellValue(i + 3, 'DOC_TYPE', Value);
						mySheet.SetCellValue(i, 'SELECTED', '1'); 
						mySheet.SetCellValue(i, 'REASON10', C001+"/N/N/N/N/N/N/N/N/N");
				}
			}					
		}
	}else if (column == "DS_FLAG" ){  
		if (Value != OldValue){ // 거래명세서를 분할하여 생성할수 있는지에 대한 값 단순항목변경 C001
			C001 = "Y";
			rdFlag = "Y";
			var limit = mySheet.RowCount()    * gridHeaderCount; 
			for ( var i = gridHeaderCount; i <= limit; i++ ) {				
				if (i%gridHeaderCount == 0){					  
						mySheet.SetCellValue(i + 3, 'DS_FLAG', Value);
						mySheet.SetCellValue(i, 'SELECTED', '1'); 
						mySheet.SetCellValue(i, 'REASON10', C001+"/N/N/N/N/N/N/N/N/N");
				}
			}		
		}
	}
	
	if (column == "REASON6") { // 카탈로그변경
		if (Value != OldValue){ 
			if (C004 == "Y" || C003 == "Y"){ // 단가변경 또는 협력사변경 일 경우에만 카탈로그 변경 가능
				
			} else {
				alert("단가변경 또는 협력사변경일 경우에만 가능합니다.");
				mySheet.SetCellValue(num, 'REASON6', '0'); 
			}
		}
	} 
 
	mySheet.SetCellValue(num, 'SELECTED', '1'); 
	mySheet.SetCellValue(num, 'REASON10', C001+"/"+C002+"/"+C003+"/"+C004+"/"+C005+"/"+C006+"/"+C007+"/"+C008+"/"+C009+"/"+C010);
	//alert(mySheet.GetCellValue(num, "REASON10"));
	 
	var row = num; 
	
	// 제조사변경
	if (column == "MAKER_NAME"  && Value != OldValue) {
		//alert("제조사가 변경 될 경우 표준카탈로그를 수정 바랍니다.");
		//$("#st_masterFlag").val("Y");
		//return;
	}   
	
	//수입여부
	if (column == "IMPORT_FLAG"  && Value != OldValue) {
		getBuyerPrimeCostRate(row , Value , OldValue);  //매출원가 Calc
		//return;
	}    
	
	// 수량/단가 수정
	//발주수량 매출단가 매입단가
	if ((column == "ITEM_QTY" || column == "UNIT_PRICE"  || column == "AGENT_PRICE" ) && Value != OldValue) {
		update_qty(row );
	}  
	
	 // 수량 단가 협력사 거래유형
	if (C005 == "Y" || C004 == "Y"  ||   C003 == "Y"  	|| C002 == "Y"   ){
		if (Value != OldValue){
			setKepPricSubValue(row); // 수량 단가 협력사 거래유형 - 매출원가 사용안함 20140911
		}
	} 
	
	// 매출금액 , 매입금액
	sum_price(row); // 품목 총 합계금액
}

//콜백함수(파일명은 모두 동일)
function setPopupReturn(value1,value2,value3,value4,value5,value6,value7,value8,value9,value10,value11,value12,value13,value14,value15,value16){
	 
	//팝업 조회후 해당 항목에 값을 셋팅
	if (popupSel == "AGENT_NAME") {	// 협력사 선택 
		var process_type			= mySheet.GetCellValue(grbRow,  "PROCESS_TYPE");   // 거래유형코드

		if( (process_type == '0' || process_type=='2') && value8 > 0 ) {  			
			alert("거래유형이 직납,TR인 경우\n\n물류센타를 공급사로 지정할 수 없습니다.\n\n확인 바랍니다.");
			return;			
		} 
		
		if(value6 == 'N'){
			alert("제재협력사로 변경 불가능합니다.\n\n확인 바랍니다.");
			return;			
		}
		mySheet.SetCellValue(grbRow, 'AGENT', value1);
		mySheet.SetCellValue(grbRow, 'AGENT_NAME', value2);
		mySheet.SetCellValue(grbRow, 'SELECTED', '1'); 
		
		
	} else if (popupSel == "MAKER_NAME") {	// 제조사 선택  
	
		mySheet.SetCellValue(grbRow, 'MAKER_NAME', value2);
		mySheet.SetCellValue(grbRow, 'SELECTED', '1'); 
	} else if (popupSel == "PROCESS_NAME") {	// 거래유형선택 
		  
       if((org_process_type == "2" || org_process_type == "0") && ( value1 == "1" ||  value1 == "3"))
       {
          alert("직납 또는 TR 발주건은 재고 또는 VMI로 변경 불가입니다.\n\n기술연구소로 연락 바랍니다.(02-3016-8966)");
          return;
       }
       if(org_process_type == "1" && value1 == "3")
       {
          alert("재고 상품을 VMI 상품으로 변경 불가입니다.\n\n기술연구소로 연락 바랍니다.(02-3016-8966)");
          return;
       }
       if(org_process_type == "3" && value1 == "1")
       {
          alert("VMI 상품을 재고 상품으로 변경 불가입니다.\n\n기술연구소로 연락 바랍니다.(02-3016-8966)");
          return;
       }
       if(org_process_type == "1" && value1 == "1")
       {
          alert("재고 상품을 재고 상품으로 변경 불가입니다.\n\n기술연구소로 연락 바랍니다.(02-3016-8966)");
          return;
       }
	       
	       
		mySheet.SetCellValue(grbRow, 'PROCESS_TYPE', value1);
		mySheet.SetCellValue(grbRow, 'PROCESS_NAME', value2); 
		
		if (value1 != "0"){  
			mySheet.SetCellValue(grbRow, 'WAREHOUSE_CODE', value3);   
		} else {
			mySheet.SetCellValue(grbRow, 'WAREHOUSE_CODE', '');
		}
		
		
		mySheet.SetCellValue(grbRow, 'SELECTED', '1'); 
	} else if (popupSel == "ITEM_GROUP_TEXT") {	// 담당팀구분
		
		return;
		mySheet.SetCellValue(grbRow, 'ITEM_GROUP', value1);
		mySheet.SetCellValue(grbRow, 'ITEM_GROUP_TEXT', value2);
		mySheet.SetCellValue(grbRow, 'SELECTED', '1'); 
	} else if (popupSel == "USER") {	// 사용자
 		$("#st_po_change_user_id").val(value1);
 		$("#st_po_change_user_name").val(value2);
	} 
	
	grbRow="";	//초기화
}

//확인
function kepConfirm()
{ 
 var value1 = mySheet.GetCellValue(grbRow, "BUYER")+"@";
 var value2 = mySheet.GetCellValue(grbRow, "BUYER_NAME");
 
 opener.setPopupReturn(value1,value2);
 
 this.close();
}




//해당 발주의 입고일/마감일 체크   ==> 입고된 품목은 발주변경 불가.
function check_gr_date(str){  
	
	<% if (rowData != null){ %>
	var buyer_name = "<%=rowData.get("BUYER_NAME")%>"; 	
	<%}%>

	var limit = mySheet.RowCount()    * gridHeaderCount; 
 
	for ( var i = gridHeaderCount; i <= limit; i++ ) {
		
		if (i%gridHeaderCount == 0){ 
			if ( mySheet.GetCellValue(i, "SELECTED") == '1' ) {
			       close_date  = mySheet.GetCellValue( i + 1 , "LAST_CLOSE_DATE"); // LAST_CLOSE_DATE
			       gr_date     = mySheet.GetCellValue( i , "GR_DATE");  // 입고일 
			        
			        
			       if(gr_date != ""){
			    	   if (close_date!= ""){
				           if(eval(close_date) > eval(gr_date)){
				               output_flag = 'Y';
				               alert( (i/gridHeaderCount) +" 행 선택하신 목록은 "+buyer_name+" 의 입고 및 마감정산이 완료된 항목입니다.  \n\n  발주삭제는 관리자에게 문의하시기 바랍니다.   ");
				               return false;
				           }
			    	   }
			    	   
			    	   	if (str == "save" && "<%=st_buyer%>" == "KRKORE0212") {
							// 단순 저장내역중에서 품명/규격/단위/관리번호/협력사품목코드 등이 변경안되었을 경우 입고수량과 발주수량을 비교해서 입고완료가 아니면 true 처리한다.
							var PO_QTY	= mySheet.GetCellValue( i , "ITEM_QTY");
							var GR_QTY	= mySheet.GetCellValue( i , "GR_QTY");
			    		   
			    		   	if (rdFlag != "Y" && PO_QTY > GR_QTY) {
			    			   	continue;
			    		   	} else {
					           	alert( (i/gridHeaderCount)  +" 행 선택하신 목록은 입고처리된 항목입니다.\n\n입고내역을 삭제하신 후 발주정보 수정이 가능합니다.");
					           	return false;
			    		   	}
			    	   	} else {
				           	alert( (i/gridHeaderCount)  +" 행 선택하신 목록은 입고처리된 항목입니다.\n\n입고내역을 삭제하신 후 발주정보 수정이 가능합니다.");
				           	return false;
			    	   	}
			       }
			       
			}
		}
	}  
 	return true;
}

// 사용자선택
function getUserSelect(buyer){
	popupSel = "USER";
	openSearchPopup('/common/misUserSelectAllPop.do', "?open=Y&com_code="+buyer , "500,500,no"); 
}

 
// 매출원가
function setKepPricSubValue(row) {  
 
	var process_type				= "";
	var import_flag					= "";
	var agent_code				= ""; 
	var list_price					= 0;
	var logistics_fee				= 0; 

 
	catlg_code				= mySheet.GetCellValue(row,  "BYIT_COMORG_CODE");  // BYIT_COMORG_CODE
	process_type			= mySheet.GetCellValue(row+1,  "PROCESS_TYPE");   // 거래유형코드
 	agent_code				= mySheet.GetCellValue(row,  "AGENT");  // 협력사
	origin_agent_code	= mySheet.GetCellValue(row+2,  "WAREHOUSE_CODE");   // WAREHOUSE_CODE
	import_flag				= mySheet.GetCellValue(row+1,  "IMPORT_FLAG");   // 수입여부
	list_price					= mySheet.GetCellValue(row+1,  "AGENT_PRICE");    // 매입단가
	logistics_fee				= mySheet.GetCellValue(row+3,  "LOGISTICS_FEE");    // LOGISTICS_FEE
 

	var process_rate	= 0;
	var import_rate	= 0;
	var tot_rate = 0;

	if(process_type == 0){
		process_rate = db_supply_direct_rate;
	}else if(process_type == 1){
		process_rate = db_stock_rate;		
	}else if(process_type == 2){
		process_rate = db_tr_rate;
	}else if(process_type == 3){
		process_rate = db_vmi_rate;
	}

	if(import_flag =="Y"){
		import_rate = db_import_rate;
	} 

	tot_rate = eval(process_rate) + eval(import_rate) ;


	if(db_buyer_adapt_flag == "Y" ) { 
		if(agent_code == "KRSESI0003" ) {
			item_rate	= eval(db_buyer_rate);
		}else {
			item_rate	= eval(db_buyer_rate) + eval(tot_rate);
		}
	}else {
		item_rate=0;
	} 

	var logistics_amt	= kepGetRound((eval(list_price)*(eval(logistics_fee)/100)),3);
	var kep_price	= kepGetRound(eval(list_price)+kepGetRound(eval(list_price)*eval(item_rate/100),3),3)-eval(logistics_amt);	// 매출원가   
	mySheet.SetCellValue(row+2, 'KEP_PRICE', kep_price); // 매출원가
	
	 
}

//품목 총 합계금액
function sum_price(row){
 
    var sum_item_amt        = 0;
    var sum_agent_item_amt  = 0;
	var limit = mySheet.RowCount()    * gridHeaderCount; 
	for ( var i = gridHeaderCount; i <= limit; i++ ) {		
		if (i%gridHeaderCount == 0){			 
// 			if ( mySheet.GetCellValue(i, "SELECTED") == '1' ) { // 2014.12.29 주석처리(header 금액은 변함 없어야 함)
// 			    var box =  mySheet.GetCellValue(row,  "SELECTED");     
// 			    if (box == "1"){
			    	sum_item_amt        = eval(sum_item_amt) + eval(mySheet.GetCellValue(i,  "ITEM_AMT")); // 매출금액
				    sum_agent_item_amt  = eval(sum_agent_item_amt) + eval(mySheet.GetCellValue(i+1,  "AGENT_ITEM_AMT")); // 매입금액
// 				}  
// 			}
		}
	}
    
    sum_item_amt = kepCommaNum(sum_item_amt);
    sum_agent_item_amt = kepCommaNum(sum_agent_item_amt);
    
    $("#po_ttl_amt_text").val(sum_item_amt);
    $("#agent_po_ttl_amt_text").val(sum_agent_item_amt); 
    $("#po_ttl_amt").val(sum_item_amt);
    $("#agent_po_ttl_amt").val(sum_agent_item_amt);
}

//수량/단가 수정
function update_qty(row){  
 
      var user_id = "<%=SessionUserId%>";
      var imsi_item_qty           =   mySheet.GetCellValue(row,  "ITEM_QTY");       // 수정 발주수량
      var imsi_unit_price         =  mySheet.GetCellValue(row,  "UNIT_PRICE");         // 수정 매출단가
      var imsi_agent_price        =  mySheet.GetCellValue(row+1,  "AGENT_PRICE");          // 수정 매입단가
      var imsi_item_amt           =  mySheet.GetCellValue(row,  "ITEM_AMT");             // 수정 매출금액
      var imsi_agent_item_amt     = mySheet.GetCellValue(row+1,  "AGENT_ITEM_AMT");      // 수정 매입금액
	  var imsi_st_item_qty_old    =  mySheet.GetCellValue(row,  "ITEM_QTY_OLD");        // 수정전 기존 발주 수량
      var imsi_st_item_qty        = mySheet.GetCellValue(row,  "ITEM_QTY_ORIGIN");     // 수정전 발주수량
      var imsi_st_unit_price      = mySheet.GetCellValue(row,  "UNIT_PRICE_ORIGIN");        // 수정전 매출단가
      var imsi_st_agent_price     = mySheet.GetCellValue(row+1,  "AGENT_PRICE_ORIGIN");         // 수정전 매입단가
      var imsi_st_item_amt        = mySheet.GetCellValue(row+1,  "ITEM_AMT_ORIGIN");          // 수정전 매출금액
      var imsi_st_agent_item_amt  = mySheet.GetCellValue(row+1,  "AGENT_ITEM_AMT_ORIGIN");    // 수정전 매입금액
      var imsi_st_unit_price_orgin    =  mySheet.GetCellValue(row+2,  "UNIT_PRICE_ORGIN");     // 발주 매출단가
      var imsi_st_agent_price_orgin   = mySheet.GetCellValue(row+2,  "AGENT_PRICE_ORGIN");      // 발주 매입단가
      var imsi_st_po_change_flag  = mySheet.GetCellValue(row+2,  "EDITYN");                     // 고객사별 발주 정보수정여부( ICOMCOD2.TYPE= 'PO01' 존재여부 )
      var plan_amt_flag   =  mySheet.GetCellValue(row+2,  "PLAN_AMT_FLAG");     
	  var agent_code           = mySheet.GetCellValue(row,  "AGENT");                 // 수정 발주수량		
	  var kep_price				= mySheet.GetCellValue(row+2,  "KEP_PRICE");                 // 수정매출원가
	   	  /*
      alert("imsi_item_qty " +imsi_item_qty);
      alert("imsi_unit_price " +imsi_unit_price);
      alert("imsi_agent_price " +imsi_agent_price);
      alert("imsi_item_amt " +imsi_item_amt);
      alert("imsi_agent_item_amt " +imsi_agent_item_amt);
      alert("imsi_st_item_qty_old " +imsi_st_item_qty_old);
      alert("imsi_st_item_qty " +imsi_st_item_qty);
      alert("imsi_st_unit_price " +imsi_st_unit_price);
      alert("imsi_st_agent_price " +imsi_st_agent_price);
      alert("imsi_st_item_amt " +imsi_st_item_amt);
      alert("imsi_st_agent_item_amt " +imsi_st_agent_item_amt);
      alert("imsi_st_unit_price_orgin " +imsi_st_unit_price_orgin);
      alert("imsi_st_agent_price_orgin " +imsi_st_agent_price_orgin);
      alert("imsi_st_po_change_flag " +imsi_st_po_change_flag);
      alert("plan_amt_flag " +plan_amt_flag);
      alert("agent_code " +agent_code);
      alert("kep_price " +kep_price);
*/
      //swf card
        var REASON10 =  mySheet.GetCellValue(row+3, 'REASON10');  
	  	var C000 = REASON10.split("/");
       	var C001 = C000[0]; // 단순항목변경
        var C002 = C000[1]; // 거래유형변경
       	var C003 = C000[2]; // 협력사변경
       	var C004 = C000[3]; // 단가변경
       	var C005 = C000[4]; // 수량변경		            	
       	var C006 = C000[5]; // 발주삭제
       	var C007 = C000[6]; // 발주초기화
       	var C008 = C000[7]; // 발주종결
       	var C009 = C000[8]; // 종결복원
       	var C010 = C000[9]; // 수량분할 
      var cardUseCheck = "<%=cardUseCheck%>";
        if(cardUseCheck == "Y" && ((imsi_item_qty != imsi_st_item_qty_old) || (imsi_unit_price != imsi_st_unit_price))) {
            alert(" 신용카드로 결제한 주문은 수정 및 삭제할 수 없습니다.");     
            mySheet.SetCellValue(row, 'ITEM_QTY', imsi_st_item_qty);       
            mySheet.SetCellValue(row, 'SELECTED', '0');       
            mySheet.SetCellValue(row, 'UNIT_PRICE', imsi_st_unit_price);       
            mySheet.SetCellValue(row+1, 'AGENT_PRICE', imsi_st_agent_price);                
            C004 = "N";
            C005 = "N";
            mySheet.SetCellValue(row+3, 'REASON10', C001+"/"+C002+"/"+C003+"/"+C004+"/"+C005+"/"+C006+"/"+C007+"/"+C008+"/"+C009+"/"+C010);
            return; 
        }
		if(imsi_item_qty != imsi_st_item_qty_old) {
			mySheet.SetCellValue(row+3, 'QTY_CHANGE_FLAG', 'Y');   
		}else {
			mySheet.SetCellValue(row+3, 'QTY_CHANGE_FLAG', 'N');   
		}


        // 발주수량 변경시
        if( isEmpty(imsi_item_qty) || (imsi_item_qty == 0) ){
            alert("발주수량에 1 이상 숫자를 입력해 주십시요");
            mySheet.SetCellValue(row, 'ITEM_QTY', imsi_st_item_qty);     
            mySheet.SetCellValue(row, 'SELECTED', '0');       
            C005 = "N";
            mySheet.SetCellValue(row+3, 'REASON10', C001+"/"+C002+"/"+C003+"/"+C004+"/"+C005+"/"+C006+"/"+C007+"/"+C008+"/"+C009+"/"+C010);
            return;
        }

        if(plan_amt_flag=="Y"){
            if(eval(imsi_item_qty) > eval(imsi_st_item_qty)){
                alert("예산이 적용된 경우, 수량을 증가시킬 수 없습니다."); 
                mySheet.SetCellValue(row, 'ITEM_QTY', imsi_st_item_qty);     
                mySheet.SetCellValue(row, 'SELECTED', '0');       
                C005 = "N";
                mySheet.SetCellValue(row+3, 'REASON10', C001+"/"+C002+"/"+C003+"/"+C004+"/"+C005+"/"+C006+"/"+C007+"/"+C008+"/"+C009+"/"+C010);
                return;
            }
        }

		// 매출단가 변경시 품의 시스템 이용
		if(imsi_unit_price != imsi_st_unit_price) {
			//alert("매출단가 변경시 품의 시스템 이용 바랍니다.");
			// mySheet.SetCellValue(row, 'UNIT_PRICE', imsi_st_unit_price);      
			// return; -- 임시
		}

        // 매출단가 변경시
        if( isEmpty(imsi_unit_price) || !chkDecimal(imsi_unit_price,3) || (imsi_unit_price <= 0) ){
            alert("매출단가를 확인 후 다시 입력해 주십시요");
            mySheet.SetCellValue(row, 'UNIT_PRICE', imsi_st_unit_price);       
            mySheet.SetCellValue(row, 'SELECTED', '0');       
            C004 = "N";
            mySheet.SetCellValue(row+3, 'REASON10', C001+"/"+C002+"/"+C003+"/"+C004+"/"+C005+"/"+C006+"/"+C007+"/"+C008+"/"+C009+"/"+C010);
            return;
        }

		if(agent_code=="KRSESI0003") {
			alert("협력사가 KEP유통 경우 매입단가 수정 불가입니다."); 
			mySheet.SetCellValue(row, 'ITEM_QTY', imsi_st_item_qty);        
			mySheet.SetCellValue(row, 'UNIT_PRICE', imsi_st_unit_price);        
			mySheet.SetCellValue(row+1, 'AGENT_PRICE', imsi_st_agent_price);        
			mySheet.SetCellValue(row, 'SELECTED', '0');       
            C004 = "N";
            C005 = "N";
            mySheet.SetCellValue(row+3, 'REASON10', C001+"/"+C002+"/"+C003+"/"+C004+"/"+C005+"/"+C006+"/"+C007+"/"+C008+"/"+C009+"/"+C010);
			return ;
			
			
		}else {
			
			// 매입단가 변경시
			if( isEmpty(imsi_agent_price) || !chkDecimal(imsi_agent_price,3) || (imsi_agent_price <= 0) ){
				alert("매입단가를 확인 후 다시 입력해 주십시요");
				mySheet.SetCellValue(row+1, 'AGENT_PRICE', imsi_st_agent_price);       
				mySheet.SetCellValue(row, 'SELECTED', '0');       
	            C004 = "N";
	            mySheet.SetCellValue(row+3, 'REASON10', C001+"/"+C002+"/"+C003+"/"+C004+"/"+C005+"/"+C006+"/"+C007+"/"+C008+"/"+C009+"/"+C010);
				return;
			}
		}

        // 윤현경 대리  또는 해당 고객사가 ICOMCOD2.TYPE = 'PO01' 에 데이타가 존재시 (역마진,마진율감소) 체크없이 수정 가능
//        if(user_id != "KEP200023" && imsi_st_po_change_flag =='N' ){
		var kep_price_origin		= mySheet.GetCellValue(row+2,  "KEP_PRICE_ORIGIN");    // 원본매출원가
        if(user_id != "KOREAB2B" && imsi_st_po_change_flag =='N' ){
            // 역마진 체크
            if(eval(imsi_unit_price) <= eval(kep_price)){
                //alert(  (row/gridHeaderCount)  +" 번째 행 단가는 노/역마진 입니다.\n\n확인 후 다시 입력해 주십시요");
                //document.forms[0].unit_price.value  = CommaNum(imsi_st_unit_price);
                //document.forms[0].agent_price.value = CommaNum(imsi_st_agent_price);
                //return;
            } 
            /*
            alert("kep_price_origin " +kep_price_origin);
            alert("imsi_st_unit_price_orgin " +imsi_st_unit_price_orgin);
            alert("kep_price_origin " +kep_price_origin);
            alert("imsi_st_unit_price_orgin " +imsi_st_unit_price_orgin);
*/
            var old_rate    = ((imsi_st_unit_price_orgin - kep_price_origin)/imsi_st_unit_price_orgin)*100;
            var change_rate = ((imsi_unit_price - kep_price)/imsi_unit_price)*100;
            /*
            alert("old_rate " +old_rate);
            alert("change_rate " +change_rate);
            */
            old_rate    = kepGetRound(old_rate,2);
            change_rate = kepGetRound(change_rate,2);

            // ( 수정단가 마진율 체크 >  발주 당시 마진율) ==> 발주당시 마진율 보다 같거나 크도록만 수정 가능
            if(eval(change_rate) < eval(old_rate)){
                //alert(  (row/gridHeaderCount) +" 번째 행은 마진율이 줄어드는 경우로 단가 수정이 불가 합니다.\n\n수정 전 : 매출단가("+imsi_st_unit_price_orgin+") - 매출원가("+kep_price+") / 매출단가("+imsi_st_unit_price_orgin+") * 100  = " + old_rate +"\n\n수정 후 : 매출단가("+imsi_unit_price+") - 매출원가("+kep_price+") / 매출단가("+imsi_unit_price+") * 100  = " + change_rate + "  " );
                //document.forms[0].unit_price.value      = CommaNum(imsi_st_unit_price);
                //document.forms[0].agent_price.value = CommaNum(imsi_st_agent_price);
                //return;
            }
        }

        if(imsi_item_qty!=""){        	
        	mySheet.SetCellValue(row, 'ITEM_QTY',  imsi_item_qty);         // 발주수량
        	mySheet.SetCellValue(row, 'ITEM_AMT', imsi_unit_price  * imsi_item_qty);        
        	mySheet.SetCellValue(row+1, 'AGENT_ITEM_AMT', imsi_agent_price  * imsi_item_qty);       
        }

        if(imsi_unit_price!=""){
        	
        	mySheet.SetCellValue(row, 'UNIT_PRICE',  imsi_unit_price);        
        	mySheet.SetCellValue(row, 'ITEM_AMT', imsi_unit_price  * imsi_item_qty);             
        	
        } 

        if(imsi_agent_price!=""){        	
        	
        	mySheet.SetCellValue(row, 'AGENT_PRICE',  imsi_agent_price);        
        	mySheet.SetCellValue(row+1, 'AGENT_ITEM_AMT', imsi_agent_price  * imsi_item_qty);             
        	
        } 
}


//매출원가 Calc 
//var params = "st_buyer_code="+buyer+"&st_processtype="+processtype+"&st_import_flag="+import_flag+"&st_agent_code="+agent_code;
//sendRequest("/kr/sysop/proxbuy/primecost/sysop_proxybuy_primecost_common.jsp", params, displayResult, 'POST');
function getBuyerPrimeCostRate(row  , Value , OldValue)  {  
	
	 
	var buyer				= "<%=st_buyer%>"; 
	var processtype			= "";
	var import_flag			= "";
	var agent_code			= "";
	var origin_agent_code	= ""; 

	catlg_code			=   mySheet.GetCellValue(row,  "BYIT_COMORG_CODE");  
	processtype			=  mySheet.GetCellValue(row + 1,  "PROCESS_TYPE");    
	agent_code			=   mySheet.GetCellValue(row,  "AGENT");     
	origin_agent_code	=  mySheet.GetCellValue(row + 2,  "WAREHOUSE_CODE");     
	import_flag			=    mySheet.GetCellValue(row+1,  "IMPORT_FLAG");   // 수입여부
 
	if(origin_agent_code=="KRSESI0003") {
		agent_code=origin_agent_code;
	}
	
	$.ajax({
      type: "POST",
      dataType:"json",
      url: "/mpso/getPrimecostCommon.do",
      headers: { 'X-Requested-With': 'XMLHttpRequest' },
      data: { st_buyer_code : buyer, st_processtype : processtype, st_import_flag : import_flag, st_agent_code : agent_code },
     async : false,
     success:function( response ) {  		     		  
			 		
				var resultText = response.msg.MSG;   
				
				var list_price	= 0;
				var logistics_fee	= 0;
				list_price	= mySheet.GetCellValue(row + 1,  "AGENT_PRICE");     // 매입단가		                
				logistics_fee	= mySheet.GetCellValue(row + 3,  "LOGISTICS_FEE");     //LOGISTICS_FEE

				var logistics_amt	= kepGetRound((eval(list_price)*(eval(logistics_fee)/100)),3);
				var kep_price	= kepGetRound(eval(list_price)+kepGetRound(eval(list_price)*(eval(resultText)/100),3),3)-eval(logistics_amt);
				 

				mySheet.SetCellValue(row+2, 'KEP_PRICE', kep_price); // 매출원가
				  
	      },
	 error:function( response ) {  		    	   
    	 alert("오류발생하였습니다.");
	      }
});  
 
}



function kepUnload(){
	 opener.doAction('search1');
}



function go_link(){
	  $('#searchCondition1').attr("action", "/mpso/getMasterMpSoOrderInfoAlterBeforeMainDivisionPop.do").submit();     
}

//반품등록 팝업
function regReturnPop(buyer,po_no,po_seq){
	openSearchPopup('/wmre/showMasterWmReReturnPoInfo.do', '?st_buyer_code='+buyer+'&st_po_no='+po_no+'&st_po_seq='+po_seq+'&st_insert_yn=Y' ,'1000,610,no');
}

function setMapValue(obj, key, value) {		
	// 객체에 key 존재하는지 확인
	if(Object.hasOwn(obj, key)) {
		var oldValue = obj[key];
		// 물류센터 코드(value)가 다른경우		
		if(oldValue != value) {
			return false;
		}
		
	}
	// key 존재안하면
	obj[key] = value;
	return true;
}

 
</script> 
<body onload="kep_onload_view();" onunload="kepUnload()">
<% if (rowData != null) { %>
<form name = "searchCondition1" id="searchCondition1" method = "post">
	<input type="hidden" id="pageflag"  name="pageflag" value="1">
	<input type="hidden" id="onepagerow"  name="onepagerow" value="10">
	<input type="hidden" id="USER_ID"  name="USER_ID" value="${sessionInfo.userId}">
	<input type="hidden" id="st_buyer"  name="st_buyer" value="<%=st_buyer%>"> 
	<input type="hidden" id="st_po_no"  name="st_po_no" value="<%=st_po_no%>"> 
	<input type="hidden" id="st_orderFlag"  name="st_orderFlag" value="<%=st_orderFlag%>"> 
</form>
<form name = "searchCondition" id="searchCondition" method = "post" onsubmit="return false" >
	<input type="hidden" name="s_SAVENAME" value="SELECTED|SELECTED1|SELECTED2|SELECTED3|STATUS_TEXT|AGENT_NAME|AGENT_NAME1|USER_NAME_LOC|PO_CREATE_DATE|RD_DATE|GR_DATE|ITEM_QTY|CD_QTY|GR_QTY|UNIT_PRICE|ITEM_AMT|LEGACY_PO_NO|AGENT|BUYER|BYIT_COMORG_CODE|CONTRACT_NO|CONTRACT_SEQ|SELLER|REF_PR_NO|PROCESS_TYPE|PROCESS_NAME|IMPORT_FLAG|SELLER_ITEM_NO|INVOICE_DATE|DS_DATE|DELIVERY_DATE|IV_QTY|IV_QTY1|DI_QTY|AGENT_PRICE|AGENT_ITEM_AMT|LEGACY_PO_SEQ|LAST_CLOSE_DATE|PO_NO|PR_NO|PR_SEQ|PO_REMARK|STATUS|CMS_CATLG_ID|BUYER_ITEM_NO|DESCRIPTION|DESCRIPTION1|DESCRIPTION2|ITEM_GROUP_TEXT|SPECIFICATION|SPECIFICATION1|UNIT_MEASURE|KEP_PRICE|MAKER_NAME|MAKER_PART_NO|EDITYN|PLAN_AMT_FLAG|PO_SEQ|WAREHOUSE_CODE|MAKER_CODE|ITEM_GROUP|REMARKIMG|DELIMG|REASON0|REASON1|WMS_FLAG|REASON4|PROCESS_TYPE_ORGIN|REASON6|DS_FLAG|CLSD_FLAG_YN|CLSD_FLAG|REASON10|CMS_CATEG_ID|DOC_TYPE|ORIGIN_CODE|LOGISTICS_FEE|KWAY_FLAG|LEGACY_IV_SERIAL|ITEM_QTY_OLD|ITEM_QTY_ORIGIN|UNIT_PRICE_ORIGIN|AGENT_PRICE_ORIGIN|ITEM_AMT_ORIGIN|AGENT_ITEM_AMT_ORIGIN|UNIT_PRICE_ORGIN|AGENT_PRICE_ORGIN|KEP_PRICE_ORIGIN|QTY_CHANGE_FLAG|AGENT_ORIGIN|RD_DATE_ORIGIN|SIZE_QTY|SIZE_LEN">
	<input type="hidden" id="pageflag"  name="pageflag" value="1">
	<input type="hidden" id="onepagerow"  name="onepagerow" value="10">
	<input type="hidden" id="USER_ID"  name="USER_ID" value="${sessionInfo.userId}">
	<input type="hidden" id="st_buyer"  name="st_buyer" value="<%=st_buyer%>"> 
	<input type="hidden" id="st_po_no"  name="st_po_no" value="<%=st_po_no%>"> 
	<input type="hidden" id="st_orderFlag"  name="st_orderFlag" value="<%=st_orderFlag%>"> 
	<input type="hidden" id="st_masterFlag"  name="st_masterFlag" value=""> 
	<input type="hidden" id="st_reason"  name="st_reason" value=""> 
	<input type="hidden" id="st_saveFlag"  name="st_saveFlag" value="N/N/N/N/N/N/N/N/N/N"> 
	<input type="hidden" id="st_saveFlag_code"  name="st_saveFlag_code" value=""> 
	
	<input type="hidden" id="st_save_multi"  name="st_save_multi" value="N"> <!-- 일괄아님 -->
	
	<input type="hidden" id="BUYER_RATE"  name="BUYER_RATE" value="<%=rowData.get("BUYER_RATE")%>"> 
	<input type="hidden" id="PROCESS_IMPORT_RATE"  name="PROCESS_IMPORT_RATE" value="<%=rowData.get("PROCESS_IMPORT_RATE")%>"> 
	<input type="hidden" id="BUYER_STANDARD_RATE"  name="BUYER_STANDARD_RATE" value="<%=rowData.get("BUYER_STANDARD_RATE")%>"> 
	<input type="hidden" id="BUYER_ADAPT_FLAG"  name="BUYER_ADAPT_FLAG" value="<%=rowData.get("BUYER_ADAPT_FLAG")%>"> 
	<input type="hidden" id="SUPPLY_DIRECT_RATE"  name="SUPPLY_DIRECT_RATE" value="<%=rowData.get("SUPPLY_DIRECT_RATE")%>"> 
	<input type="hidden" id="STOCK_RATE"  name="STOCK_RATE" value="<%=rowData.get("STOCK_RATE")%>"> 
	<input type="hidden" id="TR_RATE"  name="TR_RATE" value="<%=rowData.get("TR_RATE")%>"> 
	<input type="hidden" id="VMI_RATE"  name="VMI_RATE" value="<%=rowData.get("VMI_RATE")%>"> 
	<input type="hidden" id="IMPORT_RATE"  name="IMPORT_RATE" value="<%=rowData.get("IMPORT_RATE")%>"> 
	
	<div id="popWrapper" style="height:620px;">
    	<div id="popHeader">
        	<h1 class="title">주문정보 수정-수주접수<%=beforeAfterTitle %> 정보수정</h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/m_btn_popclose.gif" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer"> 
        
    <table  class="board_write"  style="width:100%">
      <colgroup>
      <col width="10%" />
      <col width="15%" />
      <col width="8%" />
      <col width="15%" />
      <col width="8%" />
      <col width="15%" />      
      <col width="11%" />
      <col width="*" />      
      </colgroup>
      <tr>
        <th scope="row">구매회원사</th> 
		<td><%=rowData.get("BUYER_NAME")%></td>
        <th scope="row">발주부서</th>
        <td><%=rowData.get("PO_DEPT_NAME")%></td>
        <th scope="row">요청부서</th>
        <td><%=rowData.get("REQ_DEPT_NAME")%></td>        
        <th scope="row">발주번호</th> 
		<td><font color="#5B5B5B"><%=rowData.get("PO_NO")%></font><font color="red">&nbsp;<%=rowData.get("DOC_TEXT")%></font><%=rowData.get("PROCESS_TEXT")%></td>        
      </tr>
      <tr>
        <th scope="row">발주자</th>
        <td><%=rowData.get("PO_USER_NAME")%></td>
        <th scope="row">요청자</th>
        <td><%=rowData.get("REQ_USER_NAME")%></td>     
        <th scope="row">발주일</th> 
		<td><%=CommonUtil.formatStrinigDate(rowData.get("PO_CREATE_DATE"))%></td>
        <th scope="row">매입금액</th>
        <td><input type="text"   name="agent_po_ttl_amt_text" id="agent_po_ttl_amt_text" size="14" class = "input_type_text" style="background-color:#FFFFFF;height=16;font-size:9pt;border:#FFFFFF 1px solid;" value="<%=CommonUtil.formatNumber(rowData.get("AGENT_AMT"),true,0,3)%>"    READONLY > 
          <input type="hidden" name="agent_po_ttl_amt" id="agent_po_ttl_amt" value ="<%=rowData.get("AGENT_AMT")%>">
       	</td>           
      </tr>      
      <tr>
        <th scope="row">매출금액</th>
        <td><input type="text"   name="po_ttl_amt_text" id="po_ttl_amt_text" size="14" class = "input_type_text" style="background-color:#FFFFFF;height=16;font-size:9pt;border:#FFFFFF 1px solid;" value="<%=CommonUtil.formatNumber(rowData.get("PO_AMT"),true,0,3)%>"    READONLY >
        <input type="hidden" name="po_ttl_amt"  id="po_ttl_amt" value ="<%=rowData.get("PO_AMT")%>"></td>     
        <th scope="row">도착지</th> 
		<td colspan="3"><%=rowData.get("DELY")%></td>
        <th scope="row">발주수정자</th>
        <td><input type="text"   name="st_po_change_user_name" id="st_po_change_user_name" size="12" id="line" class="input_type_text" value="<%=SessionUserName%>" READONLY >
<%
        if(SessionUserId.equals("KEP01")|| SessionUserId.equals("KEP2179004") ){
%>
                  <span class="btn_gray_03" title="변경"> <a href="javascript:getUserSelect('KRKORE0001');">변경</a></span> 
<%
        }
%>  

                  <input type="hidden" name="st_po_change_user_id"  id="st_po_change_user_id" value="<%=SessionUserId%>"></td>        
      </tr>  
       <tr>
        <th scope="row">비고</th>  
        <td colspan="5"><%=rowData.get("REMARK")%></td>        
        <th scope="row">결재번호/상태</th>  
        <td><a class="hyperLink"  href="javascript:openSearchPopup('/common/approval/getBuyerCommonMyPagePop.do','?COMPANY=<%= rowData.get("APPROVAL_COMPANY")%>&DOCU_NO=<%=DOCU_NO %>&PASS_TP=2&FLAG=RECV' , '1200,700,no')"><font color="red"><%=DOCU_NO%> <%=PASS_STATUS_NAME%></font></a></td>                   
      </tr>                       
      </table>
         <!-- 
          <div style=" top:10px; text-align:right;">  
         	<span class="btn_search" title="수량분할"><a href="javascript:go_link();">수량분할</a></span> 
         </div> -->
            <!--grid-->
 			<div style="border-top:2px solid #3c639c">
				<script type="text/javascript">
					createIBSheet("mySheet", "", "330px");
				</script>
			</div>
			<div id="pageindex"></div>
		<br>
        <!--버튼영역-->
        <div class="btnArea mr25"> 
        	<span class="fl">
        	<font color="red" class="fl"><b>※ 저장 버튼 클릭시 관리번호/협력사/거래유형/단가/수량/품목/규격/종결/선입고여부/분할여부 정보가 변경됩니다.</b></font><br>
        	<font color="red" class="fl"><b>※ PO 종결,복원은 다른 변경과 동시에 하실수 없습니다.</b></font>
        	<font color="red" class="fl"><b>※ 여러건은 PO 생성으로 인하여 협력사변경 동시에 할수 없습니다.</b></font><br>
        	<font color="red" class="fl"><b>※ PO 생성으로 인하여 거래유형변경,협력사변경,수량변경,단가변경 동시에 할수 없습니다.</b></font>
        	</span>
			<span class="fr">
			<% if("N".equals(DOC_TYPE)){ %>
				<span class="btn_03 mr04"><a href="javascript:emergencypo()">긴급발주변경</a></span>			
			<% } %>
			<% if (!"0".equals(PASS_STATUS)) { %> <!-- 결재진행중일경우 불가 -->
				<span class="btn_02 mr04"><a href="javascript:doAction('save')">저장</a></span>
				<% if ("after".equals(st_orderFlag)) { %>
				<span class="btn_02 mr04"><a href="javascript:doAction('clear')">발주초기화</a></span>
				<%} %>
				<!-- <span class="btn_02 mr04"><a href="javascript:doAction('end')">발주종결</a></span>
				<span class="btn_02 mr04"><a href="javascript:doAction('endback')">종결복원</a></span> -->
				<span class="btn_02 mr04"><a href="javascript:doAction('del')">발주삭제</a></span>
				<span class="btn_02 mr04"><a href="javascript:doAction('regRPop')">반품등록</a></span>
				<%} %>
			</span>
       </div>
        		</div>	
    </div>
</form> 
<%} %>
</body>
</html>
