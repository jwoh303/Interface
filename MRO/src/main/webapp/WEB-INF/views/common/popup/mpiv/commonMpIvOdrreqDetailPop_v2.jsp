<%--
**********************************************
* 메뉴 : 주문요청 상세 팝업
* 화면 : 
* 기능 : 
* 프로그램 ID : BU0402009
* 담당자 : 최찬규
* 착수일 : 2026-04-17
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.*"%> 
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.util.CommonLang"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<!doctype html>
<html>
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>코리아 e 플랫폼</title>
<head>
<%@ include file="../../include/head_v2.jspf"  %> 
</head>
<style>
	.IBSheetBuyerTable td,p{
		text-overflow:ellipsis;
		overflow:hidden;
		white-space:nowrap;
		height:30px;
		font-size:14px;
		font-family: Pretendard;
		cursor: default;
	}
	.IBSheetBuyerTable th{
		height:50px;
		vertical-align: middle;
		font-size:14px;
		font-family: Pretendard;
	}
</style>
<%
@SuppressWarnings (value="unchecked")
List<Map<String,String>> _dataList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된 결과 
@SuppressWarnings (value="unchecked")
List<Map<String,String>> _list = (List<Map<String,String>>) request.getAttribute("list"); // 조회된 결과 

SessionInfo sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");

String com_code=  CommonUtil.nvl((String) request.getParameter("com_code"), sessionInfo.getComCode());
String st_user_id = sessionInfo.getUserId();
String PR_NO = CommonUtil.nvl((String) request.getParameter("PR_NO"),"");  //  (조회조건)
String openYn = CommonUtil.nvl((String) request.getParameter("openYn"),"");  //  (조회조건)
String enter_flag = CommonUtil.nvl((String) request.getParameter("enter_flag"),"");  //  (조회조건)
String st_flag = CommonUtil.nvl((String) request.getParameter("st_flag"),"");  //  (조회조건)
String gw_no = CommonUtil.nvl((String) request.getParameter("gw_no"),"");  //  (조회조건)

String DOC_TYPE = CommonUtil.nvl((String) request.getParameter("DOC_TYPE"),"PO");  //  (조회조건)
String RECV_FLAG = CommonUtil.nvl((String) request.getParameter("RECV_FLAG"),"");  //  (조회조건)

String curDate			  = CommonUtil.formatDateNoDateGubun(new Date(),1);

Map<String,String> rowData = null;
Map<String,String> rowData2 = null;
if (_dataList==null || _dataList.size()==0){	 
}else{	
	rowData = _dataList.get(0); 
} 

int dely_cnt = Integer.parseInt(rowData.get("PR_DELY_CNT")); //배송지 별로 배송정보 그려야함

String dely_name[] = new String[dely_cnt];
String dely_text[] = new String[dely_cnt];
double table_total_price[] = new double[dely_cnt];
int table_total_cnt[] = new int[dely_cnt];

String STATUS_CODE = "";
String REF_IF_NO = "";  //  (인터페이스용 데이터)
double tot_price = 0;
if (_list==null || _list.size()==0){		 
}else{	
	rowData2 = _list.get(0); 
	STATUS_CODE= rowData2.get("STATUS_CODE");
	REF_IF_NO= rowData2.get("REF_IF_NO");
	
	String dely_code_temp = "";
	String dely_text_temp = "";
	int arrIndex = 0;
	for(int i = 0 ; i<_list.size(); i++){
		tot_price += Double.parseDouble(_list.get(i).get("TARGET_AMT"));
		
		if(!dely_text_temp.equals(CommonUtil.nvl(_list.get(i).get("DELY_TO_LOCATION_TEXT"),"")) || !dely_code_temp.equals(CommonUtil.nvl(_list.get(i).get("DELY_TO_LOCATION"),""))){
			dely_text_temp = CommonUtil.nvl(_list.get(i).get("DELY_TO_LOCATION_TEXT"),"");
			dely_code_temp = CommonUtil.nvl(_list.get(i).get("DELY_TO_LOCATION"),"");
			dely_name[arrIndex] = CommonUtil.nvl(_list.get(i).get("DELY_TO_LOCATION_NAME"),"");
			dely_text[arrIndex] = CommonUtil.nvl(_list.get(i).get("DELY_TO_LOCATION_TEXT"),"");
			table_total_price[arrIndex] = Double.parseDouble(_list.get(i).get("TARGET_AMT"));
			table_total_cnt[arrIndex] = 1;
			arrIndex++;
		}else{
			table_total_price[arrIndex-1] += Double.parseDouble(_list.get(i).get("TARGET_AMT"));
			table_total_cnt[arrIndex-1] += 1;
		}
	}
} 


String SessionComCode = "";
String byca_comorg_code = ""; 
String buyer = ""; 
String user_dept              = ""; 
String userId = "";
String byca_comorg_level = "";
String dept_name = "";
String budget_flag = "";
String person_author = "";
String empNo	= "";

if (sessionInfo != null){ 
	SessionComCode =  CommonUtil.nvl((String)sessionInfo.getComCode()); 
	byca_comorg_code =  CommonUtil.nvl((String)sessionInfo.getBycaComorgCode());  
	user_dept =  CommonUtil.nvl((String)sessionInfo.getDepartment());  
	dept_name =  CommonUtil.nvl((String)sessionInfo.getDepartmentName());  
	userId = CommonUtil.nvl((String)sessionInfo.getUserId()); 
	byca_comorg_level = CommonUtil.nvl((String)sessionInfo.getBycaComorgLevel()); 
    budget_flag           = CommonUtil.nvl((String)sessionInfo.getBudgetFlag());  // 구매사 예산 사용여부 
    person_author =  CommonUtil.nvl((String)sessionInfo.getPersonAuthor());  
    empNo	= CommonUtil.nvl((String)sessionInfo.getEmpNo());
}   
 
buyer = CommonUtil.nvl((String) request.getParameter("COMPANY"), SessionComCode);  //  (조회조건);

//SLOGIC-BEGIN(P06-0000016)
String reportText= CommonLang.get("HTITLE704");	//"품의서출력"; // default 버튼명
String reportid = "RD_06_B_002_12";  // default report id /kr/customer/sheet/pr_print_kep.jsp

String reportText_add1 = CommonLang.get("HTITLE704");	//"품의서출력"; // default 버튼명
String reportid_add1 = "";

Map<String, String> p060000016 = CommonUtil.getSpecialCheckReturnMap(buyer,"P06-0000016");   // com_code , 특수로직아이디
// boolean p060000062 = CommonUtil.getSpecialCheckReturn(buyer,"P06-0000062"); // 주문시 고객사 결재시스템 호출 : 광동제약 (KRKWAB0001), 일진전기 예정

String p060000062_url	= "";
String p060000062_type	= "";
String p060000062_option = "";
boolean p060000062		= false;

Map<String, String> p060000062_map	= CommonUtil.getSpecialCheckReturnMap(buyer,"P06-0000062");

if (p060000062_map != null) {
	p060000062_url	= CommonUtil.nvl(p060000062_map.get("COL01_DATA"));
	p060000062_type	= CommonUtil.nvl(p060000062_map.get("COL03_DATA"));
	p060000062_option = CommonUtil.nvl(p060000062_map.get("COL04_DATA"));
	p060000062	= true;
}

if (p060000016 != null){
	reportText= CommonUtil.nvl(p060000016.get("COL01_DATA"),reportText); // 레포트 버튼명
	reportid = CommonUtil.nvl(p060000016.get("COL02_DATA"),reportid); // 레포트아이디
}

Map<String, String> p060000097_map = CommonUtil.getSpecialCheckReturnMap(buyer,"P06-0000097");   // 품의서 추가 사용

boolean p060000097 = false;

if (p060000097_map != null){
	reportText_add1= CommonUtil.nvl(p060000097_map.get("COL01_DATA"),reportText); // 레포트 버튼명
	reportid_add1 = CommonUtil.nvl(p060000097_map.get("COL02_DATA"),reportid); // 레포트아이디
	p060000097	= true;
}

// P11-0000004
String p110000004_url	= "";
String p110000004_type	= "";
boolean p110000004		= false;
Map<String, String> p110000004_map	= CommonUtil.getSpecialCheckReturnMap(buyer,"P11-0000004");
if (p110000004_map != null) {
	p110000004_url	= CommonUtil.nvl(p110000004_map.get("COL02_DATA"));
	p110000004_type	= CommonUtil.nvl(p110000004_map.get("COL01_DATA"));
	p110000004	= true;
}
//SLOGIC-END


	String p060000036 = CommonUtil.getSpecialCheckReturn(buyer,"P06-0000036","COL02_DATA", request); // 권한별URL
	String defaultUrl = "/mpso/getBuyerMpSoCartList.do";
	if (p060000036 == null){
		p060000036 = defaultUrl;
	}else if ("".equals(p060000036)){
		p060000036 = defaultUrl;
	}

	//SLOGIC-BEGIN(P06-0000072) - 장바구니 중복 등록 허용 고객사
	boolean p060000072 = CommonUtil.getSpecialCheckReturn(buyer,"P06-0000072");
	
	String dup_add_posb_yn = "N";
	
	if(p060000072 == true){
		dup_add_posb_yn = "Y";
    }
	//SLOGIC-END
	
	// P06-0000136 - 요청자전화번호 옆에 휴대폰번효 표기 고객사 전화번호(휴대폰번호) 형식으로 노출
	boolean p060000136 = CommonUtil.getSpecialCheckReturn(buyer,"P06-0000136");

%>

<script type="text/javascript">
//alert layer용
var but1text = "<%=CommonLang.get("HTITLE516")%>"; //확인
var but1func = "javascript:closePopText2(); return false;";
var but1funcSearch = "javascript:thisPopClose(); return false;";
var but1width = "120px";

var mySheet = new ibsheetObject();
var pagingMode = "N";

function kep_onload_view(){ 
		
		var gw_no = "<%=gw_no%>"; //결재 하는지
		if(gw_no != ""){
			var initsheet = {};
			initsheet.Cfg = {MergeSheet:msHeaderOnly,     HeaderRowHeight: 50, DataRowHeight: 30,    Alternate : 0,UseNoDataRow:1};
			initsheet.Cols = [
					 { Align:"Center",	SaveName:"sStatus",				Header:"<%=CommonLang.get("HTITLE255")%>",				Type:"Status",		Width:60,	Edit:false,	EditLen:0,		Hidden:true}/*상태*/
					,{ Align:"Center",	SaveName:"ORDER_NO",			Header:"<%=CommonLang.get("HTITLE140")%>",				Type:"Text",		Width:60,	Edit:false,	EditLen:100,	Hidden:true} /*순번*/
					,{ Align:"Center",	SaveName:"PASS_TP_TEXT",		Header:"<%=CommonLang.get("HTITLE306")%>",				Type:"Text",		Width:90,	Edit:false,	EditLen:100,	Hidden:false} /*유형*/
					,{ Align:"Center",	SaveName:"PASS_TP",				Header:"<%=CommonLang.get("HTITLE306")%>",				Type:"Text",		Width:90,	Edit:false,	EditLen:100,	Hidden:true} /*유형*/
					,{ Align:"Center",	SaveName:"USER_NM",				Header:"<%=CommonLang.get("HTITLE325")%>",				Type:"Text",		Width:110,	Edit:false,	EditLen:100,	Hidden:false}/*이름*/
					,{ Align:"Center",	SaveName:"USER_POS",			Header:"<%=CommonLang.get("HTITLE476")%>",				Type:"Text",		Width:90,	Edit:false,	EditLen:100,	Hidden:false}/*직급*/
					,{ Align:"Center",	SaveName:"USER_DEPT",			Header:"<%=CommonLang.get("HTITLE329")%>",				Type:"Text",		Width:120,	Edit:false,	EditLen:100,	Hidden:false} /*부서*/
					,{ Align:"Center",	SaveName:"PASS_KN",				Header:"<%=CommonLang.get("HTITLE255")%>",				Type:"Text",		Width:100,	Edit:false,	EditLen:100,	Hidden:false}/*상태*/
					,{ Align:"Center",	SaveName:"REFER_DATE",			Header:"<%=CommonLang.get("HTITLE1048")%>",				Type:"Text",		Width:160,	Edit:false,	EditLen:100,	Hidden:false}/*열람일시*/
					,{ Align:"Center",	SaveName:"PASS_DATE",			Header:"<%=CommonLang.get("HTITLE1049")%>",				Type:"Text",		Width:160,	Edit:false,	EditLen:100,	Hidden:false}/*결재일시*/
					,{ Align:"Left",	SaveName:"PASS_ADD",			Header:"<%=CommonLang.get("HTITLE1050")%>",				Type:"Text",		Width:420,	Edit:false,	EditLen:100,	Hidden:false}/*결재자의견*/
					,{ Align:"Center",	SaveName:"CUR_ORDER_NO",			Header:"CUR_ORDER_NO",				Type:"Text",		Width:60,	Edit:false,	EditLen:100,	Hidden:true}
					,{ Align:"Center",	SaveName:"DOCU_USER_ID",			Header:"DOCU_USER_ID",				Type:"Text",		Width:60,	Edit:false,	EditLen:100,	Hidden:true}
			];
			
			IBS_InitSheet(mySheet, initsheet, pagingMode);
			mySheet.SetHighlightAfterSort(2);
			
			mySheet.SetHeaderBackColor("#f2f7ff");
			mySheet.SetTheme("DB", "DeepBlue");
			kepSearch(document.processForm, mySheet, "/common/approval/getCommonApprovalListPop_v2.do" , pagingMode);
		}
		
}
function mySheet_OnSearchEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}	

	if (msg != "") {
// 		alert(msg);
		var text = msg;
		openLayerPopText2(text,but1text,but1func,but1width);
	}
	
}

function setQuery()
{   
  $('#processForm').attr("action", "/mpiv/getCommonMpIvOdrreqDetailPop.do").submit();        
}

function getNewDepartmentDisplayPop(com_code,dept)
{ 
	openSearchPopup("/common/deptCodeAdminPop.do","?com_code="+com_code+"&po_dept="+dept  , "500,500,no"); 
}

function setPopupReturn(value1,value2) {	
}
 

function  fileDown(img_key){		
	
	location.href="/common/download_v2.do?DOC_NO="+img_key;
}



function getNewDepartmentDisplayPop(st_com_code,st_dept){ 
	openSearchPopup('/coco/getCommonCoCoDepartmentDetailViewPop.do','?openYn=Y&st_com_code='+st_com_code+'&st_dept='+st_dept , "400,143,no"); 
}  



function prnSheet() {
	var buyer         = "<%=buyer%>"; //필수항목
	var chgUserDept   = "<%=user_dept%>"; //필수항목
	var addUserID     = "<%=userId%>"; //필수항목
	var prNo          = "<%=PR_NO%>";
	var ref_no        = "";
	var add_date      = "<%=CommonUtil.formatDateNoDateGubun(new Date(),1)%>";
	var dept_name     = "<%=dept_name%>";
	var dept_code     = "<%=user_dept%>";
	var byca_comorg_level  = "<%=byca_comorg_level%>";
	var recv_flag     = "<%=RECV_FLAG%>";
	var fileName = "<%=reportid%>";
	var param =  "["+prNo+"]["+buyer+"]["+byca_comorg_level+"]["+recv_flag+"]["+add_date+"]["+dept_code+"]["+dept_name+"]["+ref_no+"][]";  // 통합된 파라미터
	
	// 홍익대학교 품의서 양식 분리 - 20160418
	if(buyer == "KRHONG0020"){
		var HONG_DEPT = $("#st_hong_dept").val();
		var user_comp = "";
		var user_dept = "";
		
		if(HONG_DEPT == "" || HONG_DEPT == null){
			HONG_DEPT = "SEDEPT";
		}
			
		if (HONG_DEPT.length > 5){
			user_comp = HONG_DEPT.substring(0,2);
			user_dept = HONG_DEPT.substring(2,6);
		 }

		if(user_comp == "SE"){
			if(user_dept == "GRAD"){
				fileName = "RD_06_B_001_01";
			}else if(user_dept == "COMP"){
				fileName = "RD_06_B_001_02";
			}else if(user_dept == "DEPT"){
				fileName = "RD_06_B_001_03";
			}else if(user_dept == "INST"){
				fileName = "RD_06_B_001_07"; // 추가 HSJ 2018.03.28
			}else if(user_dept == "INDU"){
				fileName = "RD_06_B_001_22"; // 추가 KYH 2019.12.20
			}else if(user_dept == "CAMP"){
				fileName = "RD_06_B_001_24"; // 추가 CCK 2020.09.28
			}else if(user_dept == "GRAS"){
				fileName = "RD_06_B_001_25"; // 추가 CCK 2020.10.22
			}else if(user_dept == "DEPS"){
				fileName = "RD_06_B_001_26"; // 추가 CCK 2020.10.22
			}else if(user_dept == "COMS"){
				fileName = "RD_06_B_001_27"; // 추가 CCK 2020.10.22
			}else if(user_dept == "INSS"){
				fileName = "RD_06_B_001_28"; // 추가 CCK 2020.10.22
			}else if(user_dept == "TP01"){
				fileName = "RD_06_B_001_29"; // 추가 HSJ 2020.12.29
			}
		} else if(user_comp == "SJ"){
			if(user_dept == "GRAD"){
				fileName = "RD_06_B_001_04";
			}else if(user_dept == "COMP"){
				fileName = "RD_06_B_001_05";
			}else if(user_dept == "DEPT"){
				fileName = "RD_06_B_001_06";
			}else if(user_dept == "INST"){
				fileName = "RD_06_B_001_08"; // 추가 KYH 2019.12.06
			}else if(user_dept == "INDU"){
				fileName = "RD_06_B_001_23"; // 추가 KYH 2019.12.20
			}
		}
		param =  "[]["+buyer+"]["+addUserID+"]["+dept_code+"]["+prNo+"]";  // 통합된 파라미터
		
		reportOpen(fileName, param);
		
	}
	// 기존 로직 - 20160418
	else{
		reportOpen(fileName,param);	
	}
} 

function prnSheet1(){

    var buyer = "<%=buyer%>";
    var pr_no = "<%=PR_NO%>";
    var user_id = "<%=userId%>";
    var tot_cnt = $("#st_tot_cnt").val();

    if(tot_cnt == "" || tot_cnt == "null" || tot_cnt == null){
    	//  목록에 표시된 상품이 없습니다.     
        var text = "<%=CommonLang.msg("MSG16") %>  ";
  		openLayerPopText2(text,but1text,but1func,but1width);
        return;
    }

    reportOpen("<%=reportid_add1%>","["+buyer+"]["+pr_no+"]");     
}

function reOrder_QURA(recvFlag){
	 document.forms.ExternForm.Extern_TOT_PRICE.value = document.forms.processForm.st_tot_price_text.value;
	
	 document.forms.ExternForm.action = "/mpso/QuratisGetContents.do";
	 document.forms.ExternForm.target = "_blank";
	 document.forms.ExternForm.method = "post";
	 document.forms.ExternForm.submit();
	 
// 	 self.close();
}

function reOrder_QURA_BizBox(recvFlag){
	 document.forms.ExternForm.Extern_TOT_PRICE.value = document.forms.processForm.st_tot_price_text.value;

	 document.forms.ExternForm.action = "/mpso/QuratisGetContents_bizbox.do";
	 document.forms.ExternForm.target = "_blank";
	 document.forms.ExternForm.method = "post";
	 document.forms.ExternForm.submit();
	 
// 	 self.close();
}

function reOrder_HONGIK(recvFlag){
	 document.forms.ExternForm.Extern_TOT_PRICE.value = document.forms.processForm.st_tot_price_text.value;
	
	 document.forms.ExternForm.action = "/mpso/HongikGetContents.do";
	 document.forms.ExternForm.target = "_blank";
	 document.forms.ExternForm.method = "post";
	 document.forms.ExternForm.submit();
	 
// 	 self.close();
}


/**
 * ajax 공통 호출후 성공시 처리 함수
 */ 
function kepAjaxSuccess(pMethod , response){
	 
	var sMsg = response.msg.MSG;    
	var query = "";
	
	//alert("kepAjaxSuccess pMethod "+pMethod);
	
	var flag = "";
	var budget_dept_name = "";
	var account_text = "";
	var plan_amt = "";
	var result_amt = "";
	var temp_amt = "";
	var tot_price = "";	
	 
 
	
	if (pMethod == "ADMIN_BUYER_MASTER_PR_CREATE_MAIL_REG"){ 		
		setResult(response);
	} else  if(pMethod == "CsaveProcess"){
		if (sMsg == "CREATE_OK"){
			//장바구니에 추가되었습니다. 장바구니로 이동하시겠습니까?
			var text = "<%=CommonLang.msg("MSG695")%>" +" "+ "<%=CommonLang.msg("MSG364")%>"; 
			var but1textC = "<%=CommonLang.get("HTITLE516")%>"; //확인
			var but2textC = "<%=CommonLang.get("HTITLE229")%>"; //취소
         	var but1funcC = "javascript:goCart(); return false;";
         	var but2funcC = "javascript:closePopText1(); return false;";
         	var but1widthC = "120px";
         	var but2widthC = "120px";
         	openLayerPopText(text,but1textC,but2textC,but1funcC,but2funcC,but1widthC,but2widthC);
		} else{
			//이미 장바구니에 담긴 품목입니다.\n선택하신 수량이 추가되었습니다. 장바구니로 이동하시겠습니까?
			var text = sMsg +"<br/>"+ "<%=CommonLang.msg("MSG364")%>";
			var but1textC = "<%=CommonLang.get("HTITLE516")%>"; //확인
			var but2textC = "<%=CommonLang.get("HTITLE229")%>"; //취소
         	var but1funcC = "javascript:goCart(); return false;";
         	var but2funcC = "javascript:closePopText1(); return false;";
         	var but1widthC = "120px";
         	var but2widthC = "120px";
         	openLayerPopText(text,but1textC,but2textC,but1funcC,but2funcC,but1widthC,but2widthC);
		}
	}else{
		result = response.msg.MSG;   		
		  alert("<%=CommonLang.msg("MSG401") %> "+result+" <%=CommonLang.msg("MSG385") %>");	//정상적으로 주문되었습니다. 주문번호는	입니다.
		  opener.kepSearch(1);
		  var pr_type = result.substring(0,2); 
		  var byca_comorg_code =  $("#st_byca_comorg_code").val();   
		  if(byca_comorg_code == "KRDONGG004"){
		        if(pr_type == "PX"){
		            setDongMail(result); //동부한농의 경우 메일링 관련.....
		        }else{
		        	 self.close();
		        }
		    }else {
		    	 self.close();
		    }
		 
    }
}

function setResult(response){	
	var outflag = response.msg.MSG;   		
    if(outflag == "true"){
<%--           alert("<%=CommonLang.msg("MSG402") %>");	//메일 발송이 정상적으로 되었습니다. --%>
          var text = "<%=CommonLang.msg("MSG402") %>  ";
    	  openLayerPopText2(text,but1text,but1func,but1width);
    }else{
<%--           alert("<%=CommonLang.msg("MSG403") %>");	//메일 발송이 실패하였습니다. --%>
          var text = "<%=CommonLang.msg("MSG403") %>  ";
    	  openLayerPopText2(text,but1text,but1func,but1width);
    } 
}
function setDongMail(pr_no){
    var buyer = document.forms.processForm.st_buyer.value;
    document.forms.processForm.st_pr_no.value = pr_no;
   // document.forms.processForm.target = "work";
   // document.forms.processForm.action = "/kr/customer/shopping_cart/admin_buyer_master_pr_create_mail_reg.jsp?st_buyer="+buyer+"&st_pr_no="+pr_no;
   // document.method="POST";
   // document.forms.processForm.submit();
    
    kepAjaxFormCall("/mpso/adminBuyerMasterPrCreateMailReg.do","processForm","ADMIN_BUYER_MASTER_PR_CREATE_MAIL_REG");   
}


function kepApprovalReturn(ERR,GW_NO){ 
	EndPassProcess(ERR,GW_NO); 
}

//상신결과
function EndPassProcess(ERR,GW_NO){
	 var person_author   =  $("#st_person_author").val();

	//alert("GW_NO "+GW_NO);
	if(ERR=="true"){
		if(person_author == "PO"){
	        ServerCall(GW_NO,"PS");
	    }else{
	        ServerCall(GW_NO,"GS");
	    } 
	}
}


function ServerCall(GW_NO,recvFlag){ 
    $("#st_gw_no").val(GW_NO);
    $("#recvFlag").val(recvFlag);

    kepAjaxFormCall("/mpso/buyerNewReCreateOrder.do","processForm","SAVEINSERTMERGEPXPO");         	
}

/**
 * ajax 공통 호출후 에러시 처리 함수
 */
function  kepAjaxError(pMethod , response) {
	 
	
	if(pMethod == "BUYERADMINBDGTTEMPORDERCHECK"){
<%--     	alert("<%=CommonLang.msg("MSG228") %>");	//시스템 오류입니다. 관리자에게 문의하시기 바랍니다. --%>
    	var text = "<%=CommonLang.msg("MSG228") %>  ";
  	  openLayerPopText2(text,but1text,but1func,but1width);
    }else {
<%--     	alert("<%=CommonLang.msg("MSG228") %>");	//시스템 오류입니다. 관리자에게 문의하시기 바랍니다. --%>
    	var text = "<%=CommonLang.msg("MSG228") %>  ";
  	  openLayerPopText2(text,but1text,but1func,but1width);
    }
	
} 

function cartInsertText(){
	var text = "<%=CommonLang.msg("MSG104")%>";	//장바구니에 담으시겠습니까?
	var but1textC = "<%=CommonLang.get("HTITLE516")%>"; //확인
	var but2textC = "<%=CommonLang.get("HTITLE229")%>"; //취소
	var but1funcC = "javascript:cartInsert(); return false;";
	var but2funcC = "javascript:closePopText1(); return false;";
	var but1widthC = "120px";
	var but2widthC = "120px";
	openLayerPopText(text,but1textC,but2textC,but1funcC,but2funcC,but1widthC,but2widthC);
}
function cartInsert(){
	closePopText1();
	
    var query = ""; 
    var tot_cnt  = $("#st_tot_cnt").val();

    if(eval(tot_cnt) < 2){
//         var box = eval("document.forms.processForm.lnCheck0" ); 
//         if(box.checked == true){
           	var order_qty     = document.forms.processForm.db_qty.value; 
	        var st_item_no   = document.forms.processForm.st_buyer_item_no.value;
			var st_order_qty = document.forms.processForm.db_qty.value;
			var st_agent     = document.forms.processForm.st_agent_code.value;
			var contract_no  = document.forms.processForm.st_contract_no.value;
			var contract_seq = document.forms.processForm.st_contract_seq.value;
			var byit_comorg_code = document.forms.processForm.st_byit_comorg_code.value;
	
		   query += st_item_no + "@@" + st_order_qty + "@@" + st_agent + "@@" + contract_no + "@@" + contract_seq + "@@" + byit_comorg_code;
		   query += "&&";
//        }
    }else{
        for(var k = 0; k < tot_cnt; k++){
//             var box = eval("document.forms.processForm.lnCheck" + k);
//             if(box.checked == true){
               	var order_qty     = document.forms.processForm.db_qty[k].value; 
    	        var st_item_no   = document.forms.processForm.st_buyer_item_no[k].value;
    			var st_order_qty = document.forms.processForm.db_qty[k].value;
    			var st_agent     = document.forms.processForm.st_agent_code[k].value;
    			var contract_no  = document.forms.processForm.st_contract_no[k].value;
    			var contract_seq = document.forms.processForm.st_contract_seq[k].value;
    			var byit_comorg_code = document.forms.processForm.st_byit_comorg_code[k].value;

    			query += st_item_no + "@@" + st_order_qty + "@@" + st_agent + "@@" + contract_no + "@@" + contract_seq + "@@" + byit_comorg_code;
				query += "&&";
//             }
        }
    }
	document.forms.processForm.st_use_flag.value = "C"; 	//장바구니
    document.forms.processForm.st_query2.value = query;
    document.forms.processForm.st_dup_add_flag.value = "<%=dup_add_posb_yn%>";
    
	kepAjaxFormCall("/mdcm/saveBuyerMdCmGoodsLisList.do","processForm","CsaveProcess"); 
}
function goCart(){
	closePopText1();
	
	opener.location.href = "<%=p060000036%>";
	self.close();
}

function setApproval() {
	var empNo	= "<%=empNo%>";
	var result	= "<%=PR_NO%>";
	var url = "<%=p060000062_url%>";
	var type	= "<%=p060000062_type%>";
	var option = "<%=p060000062_option%>";
	if ( true == <%=p060000062%> && "GA" == "<%=RECV_FLAG%>") {
		
		if ( type == "MODAL" ) {
			window.showModalDialog(url, "AppPop");
			window.close();	
		} else if ( type == "NORMAL" ) {
			if(option != ""){
				window.open(url, "AppPop", option);
			}else{
				window.open(url, "AppPop");
			}
		}
	} else if ( true == <%=p110000004%> && "GA" == "<%=RECV_FLAG%>" && "<%=p110000004_type%>" == "TYPE09") {
		url = "<%=p110000004_url%>";
		url = url + "<%=REF_IF_NO%>";
		window.open(url, "AppPop");	
	} else {
<%-- 		alert("<%=CommonLang.msg("MSG406") %>");	//갤재상신할 수 없습니다. --%>
		var text = "<%=CommonLang.msg("MSG406") %>  ";
  	  openLayerPopText2(text,but1text,but1func,but1width);
	}
}

</script> 
<body onload="kep_onload_view(); ">
<form name="processForm" id="processForm" method=post >
<input type="hidden" name="s_SAVENAME" />
<input type="hidden" name="VIEW" id="VIEW"  value="buyerCommonPassStatusPop_v2">
<input type="hidden" name="buyer" value="<%=buyer%>"/>
<input type="hidden" name="DOCU_NO" value="<%=gw_no %>" />

<input type="hidden" name="BUYER" id="BUYER"  value="<%=buyer%>">
<input type="hidden" name="st_user_id" id="st_user_id"  value="<%=st_user_id%>">
<input type=hidden name="PR_NO" id="PR_NO"  value="<%=PR_NO%>">
<input type=hidden name="DOC_TYPE" id="DOC_TYPE"  value="<%=DOC_TYPE%>">
<input type=hidden name="RECV_FLAG" id="RECV_FLAG"  value="<%=RECV_FLAG%>">
<input type=hidden name="enter_flag" id="enter_flag"  value="<%=enter_flag%>">
<input type=hidden name="st_flag" id="st_flag"  value="<%=st_flag%>">
<input type=hidden name="st_person_author" id="st_person_author"  value="<%=person_author%>">
<input type=hidden name="st_query" id="st_query">
<input type=hidden name="st_query_save" id="st_query_save">
<input type=hidden name="recvFlag" id="recvFlag">
<input type=hidden name="st_bdgt_pr_no" id="st_bdgt_pr_no">
<input type=hidden name="nu_end_price" id="nu_end_price">
<input type=hidden name="st_account_type_code" id="st_account_type_code">
<input type=hidden name="st_gw_no" id="st_gw_no">
<input type=hidden name="TYPE" id="TYPE">
<input type=hidden name="COM_CODE" id="COM_CODE">
<input type=hidden name="st_pr_no" id="st_pr_no">
<input type=hidden name="st_buyer" id="st_buyer" value="<%=buyer%>">
<input type="hidden" name="st_po_create_date"       value="<%=curDate%>">
<input type="hidden" name="st_byca_comorg_code"   id="st_byca_comorg_code"    value="<%=byca_comorg_code%>">
<input type="hidden" name="COMPANY" id="COMPANY"  value="<%=buyer%>">

<!-- 장바구니로이동 시 필요 -->
<input type="hidden" name="st_use_flag" id="st_use_flag" value="" />
<input type="hidden" name="st_move_flag" id="st_move_flag"  value=""/>
<input type="hidden" name="st_query2" id="st_query2"  value=""/> 
<input type="hidden" name="st_dup_add_flag" id="st_dup_add_flag" value="" />

<%if (_dataList==null || _dataList.size()==0){%>
<%}else{ %>
<input type="hidden" name="st_gr_flag"              value="<%=rowData.get("DOC_TYPE")%>">
<input type="hidden" name="st_hong_dept"	id="st_hong_dept"	value="<%=rowData.get("HONG_DEPT")%>">
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다 / 500*500-->
	<div class="wrapPopup">
  <div class="PopupTit"><%=CommonLang.get("HTITLE1234")%><!--주문요청상세--><span><a href="javascript:self.close();"><img src="/resources/imgs/Icon_close.png" /></a></span></div>
  <div class="PopupTitSubState"><%=CommonLang.get("HTITLE1234")%><!-- 주문요청상세 -->
  <%if(rowData.get("DOC_TYPE").equals("S")) {%>
  	<p class="ChipsType02_Blue" style="display:inline-block; margin-left:10px;line-height:13px; height:13px; vertical-align:middle;" ><%=CommonLang.get("HTITLE842")%><!-- 선입고 --></p>
  <%}else if(rowData.get("DOC_TYPE").equals("F")) {%>
  	<p class="ChipsType02_Blue" style="display:inline-block; margin-left:10px;line-height:13px; height:13px; vertical-align:middle;" ><%=CommonLang.get("HTITLE840")%><!-- 긴급발주 --></p>
  <%} %>
  </div>  
  <table class="PopTableThLTdL" width="100%">
    <colgroup>
      <col width="20%" />
      <col width="30%" />
      <col width="20%" />
      <col width="30%" />
<!--       <col width="17%" /> -->
<!--       <col width="17%" /> -->
  	</colgroup>
    <tr>
      <th><%=CommonLang.get("HTITLE1179")%><!-- 주문요청번호 --></th>
      <td><%=CommonUtil.nvl(rowData.get("PR_NO")) %></td>
      <th><%=CommonLang.get("HTITLE1235")%><!-- 주문요청일 --></th>
      <td><%=CommonUtil.nvl(rowData.get("CHANGE_DATE")) %></td>
<%--       <th><%=CommonLang.get("HTITLE136")%><!-- 진행상태 --></th> --%>
<%--       <td><p class="ChipsLarge_Blue" style="display:inline-block; margin-left:10px;line-height:13px;" ><%=CommonUtil.nvl(rowData.get("STATUS_TEXT")) %></p></td> --%>
    </tr>
    <tr>
      <th><%=CommonLang.get("HTITLE1236")%><!-- 주문요청부서 --></th>
      <td><%=CommonUtil.nvl(rowData.get("REQ_DEPT")) %></td>
      <th><%=CommonLang.get("HTITLE1237")%><!-- 주문요청자 --></th>
      <td><%=CommonUtil.nvl(rowData.get("CHANGE_USER_NAME")) %>&nbsp;&nbsp;<%=CommonUtil.nvl(rowData.get("CHANGE_USER_TEL")) %> <%if(p060000136) {%>(<%=CommonUtil.nvl(rowData.get("CHANGE_USER_MOBILE_PHONE")) %>)<%} %></td>
<%--       <th><%=CommonLang.get("HTITLE1238")%><!-- 요청자 연락처 --></th> --%>
<%--       <td><%=CommonUtil.nvl(rowData.get("CHANGE_USER_TEL")) %> <%if(p060000136) {%>(<%=CommonUtil.nvl(rowData.get("CHANGE_USER_MOBILE_PHONE")) %>)<%} %></td> --%>
    </tr>
    <%if(rowData.get("DOC_TYPE").equals("S")) {%>
    <tr>
    <th><%=CommonLang.get("HTITLE1459")%><!-- 선입고 비고 --></th>
    <td colspan="3"><%=CommonUtil.nvl(rowData.get("DOC_TYPE_REMARK").replaceAll("&lt;br&gt;"," ")) %></td>
    </tr>
    <%}else if(rowData.get("DOC_TYPE").equals("F")) {%>
    <tr>
    <th><%=CommonLang.get("HTITLE1458")%><!-- 긴급발주 비고 --></th>
    <td colspan="3"><%=CommonUtil.nvl(rowData.get("DOC_TYPE_REMARK").replaceAll("&lt;br&gt;"," ")) %></td>
    </tr>
    <%} %>
    <tr>
      <th><%=CommonLang.get("HTITLE122")%><!-- 비고 --></th>
      <td colspan="3"><%=CommonUtil.nvl(rowData.get("REMARK")) %></td>
    </tr>    
  </table>
  <%if(!gw_no.equals("")) {%>
  
  <div class="PopupTitSub" style="display: inline-block;"><%=CommonLang.get("HTITLE1067")%><!-- 결재경로 -->  </div>
  <button class="RoundButton_LeftIcon24_00" id="detailBtn" style="display: inline-block; vertical-align: middle;" onclick="return false;"><img id="iconArrow" src="/resources/imgs/arrow_top_Btn40_02.png" /> <span id="btnText"><%=CommonLang.get("HTITLE1057") %><!-- 상세닫기 --></span></button>
  <div class="searchWrap" id="searchWrap"  style="clear:both">
          	<div class="h1" style="height: 10px;"></div>
  <div class="ScrollBox " style="height:150px">
	<script type="text/javascript">
		createIBSheet("mySheet", "", "100%");
	</script>
  </div>
  		<script>
              const detailBtn = document.getElementById('detailBtn');
              const searchWrap = document.getElementById('searchWrap');
              const btnText = document.getElementById('btnText');
              const iconArrow = document.getElementById('iconArrow');
            
              let isCollapsed = false; // 처음 열린 상태
            
              detailBtn.addEventListener('click', function(){
                isCollapsed = !isCollapsed;
                searchWrap.classList.toggle('collapsed', isCollapsed);
            
                if (isCollapsed) {
                  btnText.textContent = "<%=CommonLang.get("HTITLE1030")%>"; //상세보기
                  iconArrow.classList.add('rotate');
                } else {
                  btnText.textContent ="<%=CommonLang.get("HTITLE1057")%>"; //상세닫기
                  iconArrow.classList.remove('rotate');
                }
              });
		  </script>
	</div>
  <%} %>
    
  <div class="PopupTitSub"><%=CommonLang.get("HTITLE824")%><!-- 배송정보 --></div>
  <% 
    int index = 0;
    boolean startFlag = true; //첫 시작 flag
    
  	for(int i = 0; i<dely_cnt; i++){
  %>
  		<div class="Popup_GrayBox mt20">
		    <div class="txtbold"><span style="color:#2172EC;margin-right:5px;"><%=CommonLang.get("HTITLE583")%><!-- 배송지 --> <%=i+1 %></span> <%=dely_name[i] %></div> 
		    <div class="txt"> <%=dely_text[i] %></div> 
		    <div class="PopupTitSubSmallBold" style="position:relative;"><%=CommonLang.get("HTITLE1222")%><!-- 주문품목 --><p style="display:inline-block; margin-left:5px">(<%=CommonUtil.formatNumber(table_total_cnt[i],true,0,3)%> <%=CommonLang.get("HTITLE1233")%><!--품목--> / <%=CommonUtil.formatNumber(table_total_price[i],true,0,3)%><%=CommonLang.get("HTITLE660")%><!-- 원 -->)</p> </div>  
		    <div class="IBSheetBuyer" style="height:auto; padding-bottom:10px; width:1220px; background-color:#F6F8F9;">
		    <table class="IBSheetBuyerTable"  style="width:1500px; table-layout: fixed;">
		      <colgroup>
		      	<col width="100px;" />
		        <col width="80px;" />
		        <col width="100px;" />
		        <col width="100px;" />
		        <col width="150px;" />
		        <col width="70px;" />
		        <col width="70px;" />
		        <col width="80px;" />
		        <col width="90px;" />
		        <col width="100px;" />
		        <col width="100px;" />
		        <col width="100px;" />
		        <col width="100px;" />
		        <col width="100px;" />
		        <col width="80px;" />
		        <col width="150px;" />
		        <%if(RECV_FLAG.equals("GR")) {%>
		        <col width="150px;" />
		        <%} %>
		      </colgroup>
		      <tr>
		      	<th><%=CommonLang.get("HTITLE136")%><!-- 진행상태 --></th>
		        <th><%=CommonLang.get("HTITLE18")%><!-- 관리번호 --></th>
		        <th><%=CommonLang.get("HTITLE12")%><!-- 품목코드 --></th>
		        <th><%=CommonLang.get("HTITLE13")%><!-- 품목명 --></th>
		        <th><%=CommonLang.get("HTITLE14")%><!-- 규격 --></th>
		        <th><%=CommonLang.get("HTITLE174")%><!-- 단가 --></th>
		        <th><%=CommonLang.get("HTITLE45")%><!-- 수량 --></th>
		        <th><%=CommonLang.get("HTITLE52")%><!-- 단위 --></th>
		        <th><%=CommonLang.get("HTITLE922")%><!-- 합계 --></th>
		        <th><%=CommonLang.get("HTITLE827")%><!-- 인수자명 --></th>
		        <th><%=CommonLang.get("HTITLE42")%><!-- 연락처 --></th>
		        <th><%=CommonLang.get("HTITLE831")%><!-- 수령희망일 --></th>
		        <th><%=CommonLang.get("HTITLE268")%><!-- 예산부서 --></th>
		        <th><%=CommonLang.get("HTITLE966")%><!-- 예산계정 --></th>
		        <th><%=CommonLang.get("HTITLE119")%><!-- 첨부파일 --></th>
		        <th><%=CommonLang.get("HTITLE783")%><!-- 품목비고 --></th>
		        <%if(RECV_FLAG.equals("GR")) {%>
		        <th><%=CommonLang.get("HTITLE957")%><!-- 반려사유 --></th>
		        <%} %>
		      </tr>
  <%
  		if (_list == null || _list.size() == 0){
  		}else{
  			Map<String,String> _data = null;
  			for (int j=index; j<_list.size(); j++) {
  				_data = _list.get(j);
  				if(!startFlag && !_list.get(j).get("DELY_TO_LOCATION").equals(_list.get(j-1).get("DELY_TO_LOCATION"))){
  					index = j;
  					startFlag = true;
  					break;
  				}
  %>
  				  <input type="hidden" name="db_buyer"	value="<%=CommonUtil.nvl(_data.get("BUYER"))%>">
			      <input type="hidden" name="db_pr_no"	value="<%=CommonUtil.nvl(_data.get("PR_NO"))%>">						
			      <input type="hidden" name="db_pr_seq"	value="<%=CommonUtil.nvl(_data.get("PR_SEQ"))%>">						
			      <input type="hidden" name="db_qty"	value="<%=CommonUtil.nvl(_data.get("QTY"))%>">						
			      <input type="hidden"   name="db_price"              value="<%=CommonUtil.nvl(_data.get("TARGET_PRICE"))%>">
			      <input type="hidden"   name="st_account_type"              value="<%=CommonUtil.nvl(_data.get("ACCOUNT_TYPE"))%>">
			      <input type="hidden"   name="st_budget_dept"              value="<%=CommonUtil.nvl(_data.get("BUDGET_DEPT"))%>">
			      <input type="hidden"   name="st_byit_comorg_code"              value="<%=CommonUtil.nvl(_data.get("BYIT_COMORG_CODE"))%>">
			      <input type="hidden"   name="st_contract_no"              value="<%=CommonUtil.nvl(_data.get("CONTRACT_NO"))%>">
			      <input type="hidden"   name="st_contract_seq"              value="<%=CommonUtil.nvl(_data.get("CONTRACT_SEQ"))%>">
			      <input type="hidden"   name="st_buyer_item_no"              value="<%=CommonUtil.nvl(_data.get("BUYER_ITEM_NO"))%>">
			      <input type="hidden"   name="st_agent_code"              value="<%=CommonUtil.nvl(_data.get("AGENT"))%>">
		      <tr>
		      <input type="hidden" name="st_ref_pr_no" id="st_ref_pr_no" value="<%=CommonUtil.nvl(_data.get("REF_PR_NO"))%>">
		        <td align="center" title="<%=CommonUtil.nvl(_data.get("PR_STATUS_TEXT"))%>"><%=CommonUtil.nvl(_data.get("PR_STATUS_TEXT"))%></td>
		        <td align="left" title="<%=CommonUtil.nvl(_data.get("REF_PR_NO"))%>"><%=CommonUtil.nvl(_data.get("REF_PR_NO"))%></td>
		        <td align="left" title="<%=CommonUtil.nvl(_data.get("BUYER_ITEM_NO"))%>"><%=CommonUtil.nvl(_data.get("BUYER_ITEM_NO"))%></td>
		        <td align="left"><p class="PDname100" align="left" title="<%=CommonUtil.nvl(_data.get("DESCRIPTION"))%>"><%=CommonUtil.nvl(_data.get("DESCRIPTION"))%></p></td>
		        <td align="left"><p class="PDname100" align="left" title="<%=CommonUtil.nvl(_data.get("SPECIFICATION"))%>"><%=CommonUtil.nvl(_data.get("SPECIFICATION"))%></p></td>
		        <td align="right" title="<%=CommonUtil.formatNumber(_data.get("TARGET_PRICE"),true,0,3)%>"><%=CommonUtil.formatNumber(_data.get("TARGET_PRICE"),true,0,3)%></td>
		        <td align="right" title="<%=CommonUtil.formatNumber(_data.get("QTY"),true,0,3)%>"><%=CommonUtil.formatNumber(_data.get("QTY"),true,0,3)%></td>
		        <td align="center" title="<%=CommonUtil.nvl(_data.get("UNIT_MEASURE"))%>"><%=CommonUtil.nvl(_data.get("UNIT_MEASURE"))%></td>
		        <td align="right" title="<%=CommonUtil.formatNumber(_data.get("TARGET_AMT"),true,0,3)%>"><%=CommonUtil.formatNumber(_data.get("TARGET_AMT"),true,0,3)%></td>
		        <td align="left" title="<%=CommonUtil.nvl(_data.get("RECIPIENT_NAME"))%>"><%=CommonUtil.nvl(_data.get("RECIPIENT_NAME"))%></td>
		        <td align="left" title="<%=CommonUtil.nvl(_data.get("RECIPIENT_PHONE"))%>"><%=CommonUtil.nvl(_data.get("RECIPIENT_PHONE"))%></td>
		        <td align="center" title="<%=CommonUtil.nvl(_data.get("RD_DATE"))%>"><%=CommonUtil.nvl(_data.get("RD_DATE"))%></td>
		        <td align="left" title="<%=CommonUtil.nvl(_data.get("BUDGET_DEPT_NAME"))%>"><%=CommonUtil.nvl(_data.get("BUDGET_DEPT_NAME"))%></td>
		        <td align="left" title="<%=CommonUtil.nvl(_data.get("ACCOUNT_NAME"))%>"><%=CommonUtil.nvl(_data.get("ACCOUNT_NAME"))%></td>
		        <td align="center"><input type="hidden" name="st_image_key" value="<%=CommonUtil.nvl(_data.get("IMAGE_KEY"))%>">
		        <%if(!CommonUtil.nvl(_data.get("IMAGE_KEY")).equals("")) {%>
		        	<button class="But_File24" onclick="javascript:fileDown('<%=CommonUtil.nvl(_data.get("IMAGE_KEY"))%>'); return false;" style="cursor: pointer;">
		        <%} %>
		        </td>
		        <td align="left" title="<%=CommonUtil.nvl(_data.get("REMARK"))%>"><%=CommonUtil.nvl(_data.get("REMARK"))%></td>
		        <%if(RECV_FLAG.equals("GR")) {%>
		        <td align="left" title="<%=CommonUtil.nvl(_data.get("RETURN_REASON"))%>"><%=CommonUtil.nvl(_data.get("RETURN_REASON"))%></td>
		        <%} %>
		      </tr>
  			<%
  				startFlag = false;
  			} %> 
  			
			</table>
			</div>
		 </div>
		 <%} %> 
 	<%} %>
 	<input type="hidden" name="st_tot_cnt"  id="st_tot_cnt" value="<%=_list.size()%>">
 	<input type="hidden" name="st_tot_price_text"	value="<%=CommonUtil.formatNumber(tot_price,true,0,3)%>">
 	
  <div class="PopupListBtnBox_Center mt20" >
    <button class="ButQuaternary_large" onclick="javascript:prnSheet(); return false;"><%=reportText %></button>
    <%if(p060000097 == true){%>
    <button class="ButQuaternary_large" onclick="javascript:prnSheet1(); return false;"><%=reportText_add1 %></button>
	<%}%>
    <button class="ButQuaternary_large" onclick="javscript:cartInsertText(); return false;"><%=CommonLang.get("HTITLE1183")%><!-- 장바구니담기 --></button>

    <% if ( ( p060000062 == true && "GA".equals(RECV_FLAG) ) || ( p110000004 == true && "GA".equals(RECV_FLAG) && "TYPE09".equals(p110000004_type) ) ) { %>
    <button class="ButQuaternary_large" onclick="javscript:setApproval(); return false;"><%=CommonLang.get("HTITLE702")%><!-- 결재상신 --></button>
	<% } %>
  </div>  
</div><!-- warp 끝-->
<%}%>
</form>
<form name="whaninForm" action="">
	<input type="hidden"  name = "EMP_NO" id = "EMP_NO" value=""/>
	<input type="hidden"  name = "FORM_KEY" id = "FORM_KEY" value=""/>
	<input type="hidden" 	name = "EXTRA" id = "EXTRA" value="">
</form>  

<form name="ExternForm" action="">
	<input type="hidden"  name = "Extern_BUYER" id = "Extern_BUYER" value="<%=buyer%>"/>
	<input type="hidden"  name = "Extern_PR_NO" id = "Extern_PR_NO" value="<%=PR_NO%>"/>
	<input type="hidden"  name="Extern_TOT_PRICE" value= "" />
</form>

</body>
</html>
