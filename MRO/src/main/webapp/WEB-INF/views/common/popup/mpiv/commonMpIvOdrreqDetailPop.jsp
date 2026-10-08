<%--
**********************************************
* 메뉴 : 
* 화면 : 구매요청 상세조회 -구매요청 상세조회
* 기능 : 구매요청 제품, 규격, 수량, 금액 등 상세정보를 확인하기 위한 팝업
* 프로그램 ID : PG_06_M_900_01
* 담당자 :   CEJ ( 설계 : 김지현 )
* 착수일 : 2014-07-02
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
<link rel="stylesheet" href="/resources/styles/base.css" type="text/css" />
<link rel="stylesheet" href="/resources/styles/buyer_layout.css" type="text/css" />
<script src="/resources/libs/jquery/js/jquery.min.js" type="text/javascript"></script>
<script src="/resources/libs/jquery/js/jquery-ui.min.js" type="text/javascript"></script>
<script src="/resources/js/kep_common.js"></script> 
<script src="/resources/js/kep_buyer.js"></script> 
</head>
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

String DOC_TYPE = CommonUtil.nvl((String) request.getParameter("DOC_TYPE"),"PO");  //  (조회조건)
String RECV_FLAG = CommonUtil.nvl((String) request.getParameter("RECV_FLAG"),"");  //  (조회조건)

String curDate			  = CommonUtil.formatDateNoDateGubun(new Date(),1);

Map<String,String> rowData = null;
Map<String,String> rowData2 = null;
if (_dataList==null || _dataList.size()==0){	 
}else{	
	rowData = _dataList.get(0); 
} 

String STATUS_CODE = "";
String REF_IF_NO = "";  //  (인터페이스용 데이터)
if (_list==null || _list.size()==0){		 
}else{	
	rowData2 = _list.get(0); 
	STATUS_CODE= rowData2.get("STATUS_CODE");
	REF_IF_NO= rowData2.get("REF_IF_NO");
} 

boolean edit = false;
// SELECT * FROM ICOMCOD1 WHERE TYPE = 'C016'
if ("PR20".equals(STATUS_CODE) || "PR30".equals(STATUS_CODE) || "PR40".equals(STATUS_CODE)){
	edit = true;
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
boolean p060000062		= false;

Map<String, String> p060000062_map	= CommonUtil.getSpecialCheckReturnMap(buyer,"P06-0000062");

if (p060000062_map != null) {
	p060000062_url	= CommonUtil.nvl(p060000062_map.get("COL01_DATA"));
	p060000062_type	= CommonUtil.nvl(p060000062_map.get("COL03_DATA"));
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


    String p060000029 = CommonUtil.getSpecialCheckReturn(buyer,"P06-0000029","COL01_DATA"); 
	String p060000036 = CommonUtil.getSpecialCheckReturn(buyer,"P06-0000036","COL02_DATA", request); // 권한별URL
	String defaultUrl = "/mpso/getBuyerMpSoCartList.do?upperId=b00000000000&leftMenu=N";
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
<!--
function kep_onload_view(){
	<%
		if ("Y".equals(openYn)){
	%>
			setQuery();
	<%	
		}
	%>
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
 

function  attach_popup(img_key){		
	var type = "<%=DOC_TYPE%>";
	var viewType = "R";	 
	kepFileUploadOpenPopup(img_key,type,viewType); 
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
        alert("<%=CommonLang.msg("MSG16")%>");
        return;
    }

    reportOpen("<%=reportid_add1%>","["+buyer+"]["+pr_no+"]");     
}

/**
 * 체크 된 수
 */
function getCheckedRowCount(tot_cnt) {
	
	var chk_cnt = 0;
	if(eval(tot_cnt) < 2){
	    var box = eval("document.forms.processForm.lnCheck0");
	    if(box.checked == true) chk_cnt++;
	}else{
	    for(var j = 0; j < tot_cnt; j++){
	         var box = eval("document.forms.processForm.lnCheck" + j);
	         if(box.checked == true){
	              chk_cnt++;
	         }
	    }
	}
	return chk_cnt;
}

function update_qty( row )   
{

    var tot_cnt  =  $("#st_tot_cnt").val();

    if(eval(tot_cnt) < 2){          

        var imsi_qty         = TrimCommon(filterNum(document.forms.processForm.target_qty.value));       // 발주수량
        var imsi_buy_price   = TrimCommon(filterNum(document.forms.processForm.buy_price.value));        // 단가
        var imsi_req_qty     = TrimCommon(filterNum(document.forms.processForm.req_qty.value));          // 요청수량


        if( isEmpty(imsi_qty)  || (imsi_qty == 0) ){
            alert("<%=CommonLang.msg("MSG192") %>");	//수량에 1 이상의 숫자를 입력해 주십시요
            document.forms.processForm.target_qty.value = imsi_req_qty;
            return;
        }

        if(imsi_qty!="")
        {
            document.forms.processForm.db_qty.value      = eval(imsi_qty);
            document.forms.processForm.target_qty.value  = kepCommaNum(eval(imsi_qty));
            document.forms.processForm.item_amt.value    = kepCommaNum(imsi_buy_price * imsi_qty);    // 금액 변경
        }

        var temp_tot_price = 0;

        var temp_qty        = document.forms.processForm.db_qty.value;
        var temp_price      = document.forms.processForm.db_price.value;
        var temp_item_amt   = eval(temp_qty) * eval(temp_price);
            temp_tot_price += temp_item_amt;

        document.forms.processForm.st_tot_price_text.value   = kepCommaNum(temp_tot_price);

    }else{

        var imsi_qty         = TrimCommon(filterNum(document.forms.processForm.target_qty[row].value));      // 발주수량
        var imsi_buy_price   = TrimCommon(filterNum(document.forms.processForm.buy_price[row].value));       // 단가
        var imsi_req_qty     = TrimCommon(filterNum(document.forms.processForm.req_qty[row].value));         // 요청수량


        if( isEmpty(imsi_qty)   || (imsi_qty == 0) ){
            alert("<%=CommonLang.msg("MSG192") %>");	//수량에 1 이상의 숫자를 입력해 주십시요
            document.forms.processForm.target_qty.value = imsi_req_qty;
            return;
        }

        if(imsi_qty!="")
        {
            document.forms.processForm.db_qty[row].value     = eval(imsi_qty);
            document.forms.processForm.target_qty[row].value = kepCommaNum(eval(imsi_qty));
            document.forms.processForm.item_amt[row].value   = kepCommaNum(imsi_buy_price * imsi_qty);    // 금액 변경
        }

        var temp_tot_price = 0;

        for(var k = 0; k < tot_cnt; k++){
            var temp_qty        = document.forms.processForm.db_qty[k].value;
            var temp_price      = document.forms.processForm.db_price[k].value;
            var temp_item_amt   = eval(temp_qty) * eval(temp_price);
                temp_tot_price += temp_item_amt;
        }

        document.forms.processForm.st_tot_price_text.value   = kepCommaNum(temp_tot_price);

    }// end else
}
function reOrder_QURA(recvFlag){
	 document.forms.ExternForm.Extern_TOT_PRICE.value = document.forms.processForm.st_tot_price_text.value;
	
	 document.forms.ExternForm.action = "/mpso/QuratisGetContents.do";
	 document.forms.ExternForm.target = "_blank";
	 document.forms.ExternForm.method = "post";
	 document.forms.ExternForm.submit();
	 
	 self.close();
}

function reOrder_QURA_BizBox(recvFlag){
	 document.forms.ExternForm.Extern_TOT_PRICE.value = document.forms.processForm.st_tot_price_text.value;
	
	 document.forms.ExternForm.action = "/mpso/QuratisGetContents_bizbox.do";
	 document.forms.ExternForm.target = "_blank";
	 document.forms.ExternForm.method = "post";
	 document.forms.ExternForm.submit();
	 
	 self.close();
}

function reOrder_HONGIK(recvFlag){
	 document.forms.ExternForm.Extern_TOT_PRICE.value = document.forms.processForm.st_tot_price_text.value;
	
	 document.forms.ExternForm.action = "/mpso/HongikGetContents.do";
	 document.forms.ExternForm.target = "_blank";
	 document.forms.ExternForm.method = "post";
	 document.forms.ExternForm.submit();
	 
	 self.close();
}
/// 다시 주문하기  구매발주(recvFlag=1) , 발주보류(recvFlag=3) 
function reOrder(recvFlag){
    
    var query = ""; 

    var person_author   = $("#st_person_author").val();
    var tot_cnt  = $("#st_tot_cnt").val();
    var cnt             =  getCheckedRowCount(tot_cnt);
    var row_num         = 0; // 선택한 체크박스 rownum

    if(cnt == 0){
        if(person_author == "PO"){
            alert("<%=CommonLang.msg("MSG396") %>");	//재발주 할 품목을 선택해 주십시요
            return;
        }else {     
            alert("<%=CommonLang.msg("MSG397") %>");	//다시 주문 할 품목을 선택해 주십시요
            return;
        }
    }
    
 

    if(eval(tot_cnt) < 2){
                          
        // 수량 체크(db_qty)
        var qty_check = TrimCommon(document.forms.processForm.db_qty.value);

        if(qty_check == "0" || ( qty_check == null || qty_check == "" )){
            alert( row_num + "<%=CommonLang.msg("MSG203") %>");	//번째 줄에 수량이 입력되지 않았습니다.  
            return;
        }               

        if(qty_check < 0) {
            alert( row_num + "<%=CommonLang.msg("MSG398") %>");	//번째 줄에 수량은 양수이어야 합니다.  
            return false;
        }

        var pr_no           = document.forms.processForm.db_pr_no.value;
        var pr_seq          = document.forms.processForm.db_pr_seq.value;
        var recv_qty        = document.forms.processForm.db_qty.value;
        var rd_date         = document.forms.processForm.st_rd_date.value;
        var ref_no          = document.forms.processForm.st_ref_pr_no.value;
        if(TrimCommon(ref_no) == ''){
            ref_no = '<>';
        }
        

        var total   = pr_no+"~~~"+pr_seq+"~~~"+recv_qty+"~~~"+rd_date+"~~~"+ref_no+"~~~";              
        query += total ;
        query += "@@";

    }else{

        for(var k = 0; k < tot_cnt; k++){
            var box = eval("document.forms.processForm.lnCheck" + k);
            if(box.checked == true){

                // 수량 체크(db_qty)
                var qty_check = TrimCommon(document.forms.processForm.db_qty[k].value);

                if(qty_check == "0" || ( qty_check == null || qty_check == "" )){
                    alert( row_num + "<%=CommonLang.msg("MSG203") %>");	//번째 줄에 수량이 입력되지 않았습니다.  
                    return;
                }               

                if(qty_check < 0) {
                    alert( row_num + "<%=CommonLang.msg("MSG398") %>  ");	//번째 줄에 수량은 양수이어야 합니다.
                    return false;
                }

                var pr_no           = document.forms.processForm.db_pr_no[k].value;
                var pr_seq          = document.forms.processForm.db_pr_seq[k].value;
                var recv_qty        = document.forms.processForm.db_qty[k].value;
                var rd_date         = document.forms.processForm.st_rd_date.value;       // 납기요청일 HD 사용
                var ref_no          = document.forms.processForm.st_ref_pr_no[k].value;
                if(TrimCommon(ref_no) == ''){
                    ref_no = '<>';
                }
                var total   = pr_no+"~~~"+pr_seq+"~~~"+recv_qty+"~~~"+rd_date+"~~~"+ref_no+"~~~";                          
                query += total ;
                query += "@@";
            }
        }
    }   
     
    document.forms.processForm.st_query_save.value = query;
    //alert( query ); 

    //setAMTCheck(recvFlag);

    var budget_flag = "<%=budget_flag%>"; 
    if(budget_flag =="Y"){
        doCheckAMT(recvFlag);
    }else{
        setData(recvFlag);
    }

}

//예산 체크 모듈 (ICOMCMPY.BUDGET_FLAG="Y" 구매사만 예산 체크)
function doCheckAMT(recvFlag){
	
	var buyer	 = document.forms.processForm.st_buyer.value;
    var tot_cnt  = $("#st_tot_cnt").val(); 
    var cnt      = getCheckedRowCount(tot_cnt);
     
    var pr_no       = ""; 
    var query = "";
    if(eval(tot_cnt) < 2){
        var box =  eval("document.forms.processForm.lnCheck0" );
        if(box.checked == true){
				pr_no       = document.forms.processForm.db_pr_no.value;
            var pr_seq      = document.forms.processForm.db_pr_seq.value;
            var recv_qty    = document.forms.processForm.db_qty.value;
            var account_type    = document.forms.processForm.st_account_type.value;
            var budget_dept     = document.forms.processForm.st_budget_dept.value;
            var total   = pr_seq+"@@"+recv_qty+"@@"+account_type+"@@"+budget_dept+"@@"+pr_no;
            query += total;
            query += "|";
        }
    }else{
        for(var k = 0; k < tot_cnt; k++){
            var box =  eval("document.forms.processForm.lnCheck" + k);
            if(box.checked == true){
					pr_no			= document.forms.processForm.db_pr_no[k].value;
                var pr_seq          = document.forms.processForm.db_pr_seq[k].value;
                var recv_qty        = document.forms.processForm.db_qty[k].value;
                var account_type    = document.forms.processForm.st_account_type[k].value;
                var budget_dept     = document.forms.processForm.st_budget_dept[k].value;
                var total   = pr_seq+"@@"+recv_qty+"@@"+account_type+"@@"+budget_dept+"@@"+pr_no;
                query += total;
                query += "|";
            }
        }
    }
     
    //alert(query);
    document.forms.processForm.st_query.value  = query;            
    document.forms.processForm.st_buyer.value  = buyer;           
    document.forms.processForm.st_bdgt_pr_no.value  = pr_no;           
    document.forms.processForm.recvFlag.value  = recvFlag;           
    kepAjaxFormCall("/mppo/buyerAdminBdgtTempOrderCheck.do","processForm","BUYERADMINBDGTTEMPORDERCHECK"); 	      
}


function setCheckEnd(FLAG,recvFlag,end_price){
    if(FLAG == "OK"){
           document.forms.processForm.nu_end_price.value = end_price;
           setData(recvFlag);
    }
}

function setData(recvFlag){

    var account_type_code    = $("#st_account_type_code").val();       // ACCOUNT_TYPE (계정분류)
    if(account_type_code==""){
    	$("#st_account_type_code").val(" ");;
    }

    var end_price            = $("#nu_end_price").val();  //예산차액
    if(end_price==""){
    	 $("#nu_end_price").val("0");
    }
    
    
    var person_author   =  $("#st_person_author").val();

    if(person_author == "PO"){
    	//재발주 하시겠습니까?
        if(!confirm("<%=CommonLang.msg("MSG399") %>  ")) return;      
        document.forms.processForm.TYPE.value = "PX";	 
    }else {     
    	//다시 주문 하시겠습니까?
        if(!confirm("<%=CommonLang.msg("MSG400") %>  ")) return;       
        document.forms.processForm.TYPE.value = "PR";	 
    } 

	document.forms.processForm.COM_CODE.value = "<%=buyer%>"; 	 
    kepAjaxFormCall("/mpso/newBuyerCommonPassbiz.do","processForm","NEWBUYERCOMMONPASSBIZ");  

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
	 
 
	
	   if(pMethod == "BUYERADMINBDGTTEMPORDERCHECK"){ 
	    	
	    	if (response.data.length > 0){
				flag = $.trim(eval("response.data[0].BUYER_CHECK"));
				budget_dept_name = $.trim(eval("response.data[0].BUDGET_DEPT_NAME"));
				account_text = $.trim(eval("response.data[0].ACCOUNT_TYPE_TEXT"));
				plan_amt = $.trim(eval("response.data[0].PLAN_AMT"));
				result_amt = $.trim(eval("response.data[0].RESULT_AMT"));
				temp_amt = $.trim(eval("response.data[0].TEMP_AMT"));
				tot_price = $.trim(eval("response.data[0].TOT_AMT"));
			}
			var recvFlag =  document.forms.processForm.recvFlag.value;
			var end_price =  document.forms.processForm.nu_end_price.value; 		
			
			//alert("flag " +flag);
		    if(flag == "예산초과"){
	
		        alert(budget_dept_name +
		              "\n\n"+account_text+" <%=CommonLang.msg("MSG381") %>   "+kepCommaNum(plan_amt)+" <%=CommonLang.get("HTITLE660") %>"+
		              "\n\n"+account_text+" <%=CommonLang.msg("MSG382") %>   "+kepCommaNum(plan_amt-(eval(result_amt)+eval(temp_amt)))+" <%=CommonLang.get("HTITLE660") %>"+
		              "\n\n"+account_text+" <%=CommonLang.msg("MSG383") %>   "+kepCommaNum(tot_price)+" <%=CommonLang.get("HTITLE660") %>"+	
		              "\n\n<%=CommonLang.msg("MSG384") %>");	//예산 원 구매가능 예산 원 구매금액 원 예산이 초과되어 구매할 수 없습니다.
		        //  parent.main.setCheckEnd('NO',recvFlag);
		        return ;
		    } else if(flag == "예산미편성"){
		        alert(budget_dept_name + " "+account_text+ " <%=CommonLang.msg("MSG219") %>");	//예산이 편성되어 있지 않습니다.\n\n 확인 후 다시 주문해 주시기 바랍니다.
		        return;
		    } else if(flag == "100"){
		    	alert("<%=CommonLang.msg("MSG219") %>");	//예산이 편성되어 있지 않습니다. 확인 후 다시 주문해 주시기 바랍니다.
		        return;
		    }  else {
		    	  setCheckEnd('OK',recvFlag,end_price);
		    }	 
    }  else if (pMethod == "NEWBUYERCOMMONPASSBIZ"){ 		
		var checkpass = response.msg.CHECKPASS;   
		var pass_flag = response.msg.PASS_FLAG;   		
		GoPass(checkpass,pass_flag,"");
	} else if (pMethod == "ADMIN_BUYER_MASTER_PR_CREATE_MAIL_REG"){ 		
		setResult(response);
	} else  if(pMethod == "CsaveProcess"){
	    if(sMsg == "CREATE_OK"){
	        alert("<%=CommonLang.msg("MSG22") %>");	//장바구니에 저장되었습니다.
	   		opener.$('#locationForm').attr("action", "<%=p060000036%>").submit();
       	 	self.close();
	    }else{
            alert("<%=CommonLang.msg("MSG352") %>" + sMsg + "<%=CommonLang.msg("MSG353") %>");	//품목코드 () 은 이미 장바구니에 저장된 항목입니다.
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
          alert("<%=CommonLang.msg("MSG402") %>");	//메일 발송이 정상적으로 되었습니다.
    }else{
          alert("<%=CommonLang.msg("MSG403") %>");	//메일 발송이 실패하였습니다.
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
    	alert("<%=CommonLang.msg("MSG228") %>");	//시스템 오류입니다. 관리자에게 문의하시기 바랍니다.
    }else {
    	alert("<%=CommonLang.msg("MSG228") %>");	//시스템 오류입니다. 관리자에게 문의하시기 바랍니다.
    }
	
} 

//장바구니로이동
function goCartList(){
    var query = ""; 
    var tot_cnt  = $("#st_tot_cnt").val();
    var cnt             =  getCheckedRowCount(tot_cnt);
    if(cnt == 0){
		alert("<%=CommonLang.msg("MSG404") %>");	//장바구니로 이동 할 품목을 선택해 주십시요.
		return;
    }

    if(eval(tot_cnt) < 2){
        var box = eval("document.forms.processForm.lnCheck0" ); 
        if(box.checked == true){
           	var order_qty     = document.forms.processForm.db_qty.value; 
	        var st_item_no   = document.forms.processForm.st_buyer_item_no.value;
			var st_order_qty = document.forms.processForm.db_qty.value;
			var st_agent     = document.forms.processForm.st_agent_code.value;
			var contract_no  = document.forms.processForm.st_contract_no.value;
			var contract_seq = document.forms.processForm.st_contract_seq.value;
			var byit_comorg_code = document.forms.processForm.st_byit_comorg_code.value;
	
		   query += st_item_no + "@@" + st_order_qty + "@@" + st_agent + "@@" + contract_no + "@@" + contract_seq + "@@" + byit_comorg_code;
		   query += "&&";
       }
    }else{
        for(var k = 0; k < tot_cnt; k++){
            var box = eval("document.forms.processForm.lnCheck" + k);
            if(box.checked == true){
               	var order_qty     = document.forms.processForm.db_qty[k].value; 
    	        var st_item_no   = document.forms.processForm.st_buyer_item_no[k].value;
    			var st_order_qty = document.forms.processForm.db_qty[k].value;
    			var st_agent     = document.forms.processForm.st_agent_code[k].value;
    			var contract_no  = document.forms.processForm.st_contract_no[k].value;
    			var contract_seq = document.forms.processForm.st_contract_seq[k].value;
    			var byit_comorg_code = document.forms.processForm.st_byit_comorg_code[k].value;

    			query += st_item_no + "@@" + st_order_qty + "@@" + st_agent + "@@" + contract_no + "@@" + contract_seq + "@@" + byit_comorg_code;
				query += "&&";
            }
        }
    }
	//선택한 품목 장바구니로 이동 하시겠습니까?
    if(!confirm("<%=CommonLang.msg("MSG405") %>")) return;
	document.forms.processForm.st_use_flag.value = "C"; 	//장바구니
    document.forms.processForm.st_query2.value = query;
    document.forms.processForm.st_dup_add_flag.value = "<%=dup_add_posb_yn%>";
    
	kepAjaxFormCall("/mdcm/saveBuyerMdCmGoodsLisList.do","processForm","CsaveProcess"); 
}


function setApproval() {
	var empNo	= "<%=empNo%>";
	var result	= "<%=PR_NO%>";
	var url = "<%=p060000062_url%>";
	var type	= "<%=p060000062_type%>";
	if ( true == <%=p060000062%> && "GA" == "<%=RECV_FLAG%>") {
		
		if ( type == "MODAL" ) {
			window.showModalDialog(url, "AppPop");
			window.close();	
		} else if ( type == "NORMAL" ) {
			window.open(url, "AppPop");
		}
	} else if ( true == <%=p110000004%> && "GA" == "<%=RECV_FLAG%>" && "<%=p110000004_type%>" == "TYPE09") {
		url = "<%=p110000004_url%>";
		url = url + "<%=REF_IF_NO%>";
		alert(url);
		window.open(url, "AppPop");	
	} else {
		alert("<%=CommonLang.msg("MSG406") %>");	//갤재상신할 수 없습니다.
	}
}










 //-->
</script> 
<body onload="kep_onload_view(); ">
<form name="processForm" id="processForm" method=post >
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

<%
if ("".equals(openYn)){
%>
<%
if (_dataList==null || _dataList.size()==0){
%>
<%}else{ %>
<input type="hidden" name="st_gr_flag"              value="<%=rowData.get("DOC_TYPE")%>">
<input type="hidden" name="st_hong_dept"	id="st_hong_dept"	value="<%=rowData.get("HONG_DEPT")%>">
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다 / 500*500-->
	<div id="popWrapper" style="height:590px;">
    	<div id="popHeader">
        	<h1 class="title"><%=CommonLang.get("HTITLE698") %><!-- 구매요청 상세조회 --></h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/b_btn_popclose.gif" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer">
            	<table  class="board_write" summary="구매요청 상세조회">
		<caption>구매요청 상세조회 정보</caption>
			<colgroup>
				<col width="20%" />
				<col width="30%" />
				<col width="20%" />
				<col width="30%" />
			</colgroup>
		<tbody>  
		  <tr>
		  	<th scope="row"><%=CommonLang.get("HTITLE586") %><!-- 구매요청번호 --></th>
			<td scope="row" ><font color="#1c89de"><b><%=rowData.get("PR_NO")%></b></font>&nbsp;<font color="red"><b><%=rowData.get("DOC_TEXT")%></b></font></td>
			<th scope="row"><%=CommonLang.get("HTITLE135") %><!-- 요청부서 --></th>
			<td scope="row"><a class="hyperLink" href="javascript:getNewDepartmentDisplayPop('<%=com_code%>','<%=rowData.get("CHANGE_USER_DEPT")%>');"><%=rowData.get("REQ_DEPT")%></a></td>
		  </tr>
		  <tr>
		  	<th scope="row"><%=CommonLang.get("HTITLE587") %><!-- 구매요청일 --></th>
			<td scope="row"><%=CommonUtil.formatStrinigDate(rowData.get("CHANGE_DATE"))%></td>
			<th scope="row"><%=CommonLang.get("HTITLE133") %><!-- 요청자 --></th>
			<td scope="row"><%=rowData.get("CHANGE_USER_NAME")%></td>
		  </tr> 
		  <tr>
		  	<th scope="row"><%=CommonLang.get("HTITLE243") %><!-- 납기요청일 --></th>
			<td scope="row">
			<%=CommonUtil.formatStrinigDate(rowData.get("RD_DATE"))%>
			</td>
			<%
			String changeUserMobilePhone = "";
			if(p060000136){
				changeUserMobilePhone = " (" + rowData.get("CHANGE_USER_MOBILE_PHONE") + ")";
			}
			%>
			<th scope="row"><%=CommonLang.get("HTITLE588") %><!-- 요청자전화번호 --></th>
			<td scope="row"><%=rowData.get("CHANGE_USER_TEL")+changeUserMobilePhone%></td>
		  </tr> 		  
		  <tr>
		  	<th scope="row"><%=CommonLang.get("HTITLE122") %><!-- 비고 --></th> 
			<td scope="row" colspan="3"> 
			<%=rowData.get("REMARK")%>
			</td>
		  </tr> 		  			   		  
    	</tbody>
    </table> 
<%} %>
<br>
           	<!--grid-->
            <div class="scrollArea" style="height:250px">
                <table  class="cont_t_list02"  style="width:100%">
                    <caption>구매요청 상세조회 검색 리스트</caption>
                    <colgroup>
                    <% if (edit == true) { %>
                    	<col width="5%" /> 
                    <%} %>
                        <col width="8%" /> 
                        <col width="12%" /> 
                        <col width="14%" /> 
                        <col width="10%" /> 
                        <col width="8%" /> 
                        <col width="8%" /> 
                        <col width="10%" /> 
                        <col width="8%" /> 
							                <%  
                    if("Y".equals(budget_flag)){    
                %>
                        <col width="8%" /> 	
                        <col width="8%" /> 
                <%  
                    }   
                %>    	                        
                        <col width="8%" />                         
                    </colgroup>
                    <thead>
                        <tr>
                    <% if (edit == true) { %>
                    	<th scope="col"><input type="checkbox" name="check_status" id="check_status" value="선택"  style="cursor:pointer;" onclick="kepCheckAll(document.forms.processForm.st_tot_cnt.value,document.forms.processForm.check_status,'document.forms.processForm.lnCheck');"></th> 
                    <%} %>                        
                            <th scope="col"><%=CommonLang.get("HTITLE12") %><!-- 품목코드 --></th> 
                            <th scope="col"><%=CommonLang.get("HTITLE13") %><!-- 품목명 --></th> 
                            <th scope="col"><%=CommonLang.get("HTITLE14") %><!-- 규격 --></th> 
        					<% if(buyer.equals("KRISER0001")) { %>
					        <th scope="col"><%=CommonLang.get("HTITLE699") %><!-- 수량(재고) --></th>					
					        <% }else { %>					
					        <th scope="col"><%=CommonLang.get("HTITLE589") %><!-- 수량(단위) --></th>					
					        <% } %>					
					        <th scope="col"><%=CommonLang.get("HTITLE174") %><!-- 단가 --></th>					
					        <th scope="col"><%=CommonLang.get("HTITLE204") %><!-- 금액 --></th>					
					        <th scope="col"><%=CommonLang.get("HTITLE144") %><!-- 협력사 --></th>					
							<th scope="col"><%=CommonLang.get("HTITLE18") %><!-- 관리번호 --></th>		
							                <%  
                    if("Y".equals(budget_flag)){    
                %>
                        <th scope="col"><%=CommonLang.get("HTITLE267") %><!-- 계정명 --></th>		
                        <th scope="col"><%=CommonLang.get("HTITLE268") %><!-- 예산부서 --></th>		
                <%  
                    }   
                %>    			
					        <th scope="col"><%=CommonLang.get("HTITLE166") %><!-- 첨부 --></th>                            
                        </tr>
                    </thead>
                    <tbody>
<%
double tot_price = 0;
if (_list == null || _list.size() == 0){
%>
               		<tr bgcolor="#FFFFFF">
                        <td colspan="3" align="center" height = "280">
                        <span class="font1"><%=CommonLang.msg("MSG347") %><!-- 조회된 데이타가 없습니다. --></span>
                        </td> 
                    </tr>
<%}else{
	Map<String,String> _data = null;
for (int j=0; j<_list.size(); j++) {
	_data = _list.get(j);
	tot_price += Double.parseDouble(_data.get("TARGET_AMT"));
%>
	<tr class="center">
						      <input type="hidden" name="db_buyer"	value="<%=_data.get("BUYER")%>">
						      <input type="hidden" name="db_pr_no"	value="<%=_data.get("PR_NO")%>">						
						      <input type="hidden" name="db_pr_seq"	value="<%=_data.get("PR_SEQ")%>">						
						      <input type="hidden" name="db_qty"	value="<%=_data.get("QTY")%>">						
						      <input type="hidden"   name="db_price"              value="<%=_data.get("TARGET_PRICE")%>">
						      <input type="hidden"   name="st_account_type"              value="<%=_data.get("ACCOUNT_TYPE")%>">
						      <input type="hidden"   name="st_budget_dept"              value="<%=_data.get("BUDGET_DEPT")%>">
						      <input type="hidden"   name="st_byit_comorg_code"              value="<%=_data.get("BYIT_COMORG_CODE")%>">
						      <input type="hidden"   name="st_contract_no"              value="<%=_data.get("CONTRACT_NO")%>">
						      <input type="hidden"   name="st_contract_seq"              value="<%=_data.get("CONTRACT_SEQ")%>">
						      <input type="hidden"   name="st_buyer_item_no"              value="<%=_data.get("BUYER_ITEM_NO")%>">
						      <input type="hidden"   name="st_agent_code"              value="<%=_data.get("AGENT")%>">
						      
                    <% if (edit == true) { %>
                    	<td rowspan="2" title="선택"><input type="checkbox" name="lnCheck<%=j%>"></td>
                    <%} %>
						        <td rowspan="2" title="품목코드"><a class="hyperLink"  href="javascript:getBuyerCatalogDisplayPop('<%=_data.get("BYIT_COMORG_CODE")%>','<%=_data.get("BUYER_ITEM_NO")%>','<%=_data.get("CONTRACT_NO")%>','<%=_data.get("CONTRACT_SEQ")%>');"><%=_data.get("BUYER_ITEM_NO")%></a></td>
							    <td title="품목명" class="left"><%=_data.get("DESCRIPTION")%></td>						
						        <td title="규격" class="left"><%=_data.get("SPECIFICATION")%></td>						
						        <% if(buyer.equals("KRISER0001")) { %>						
						        <td class="right" title="수량/단위"><%=CommonUtil.formatNumber(_data.get("QTY"),true,0,3)%>/<%=_data.get("UNIT_MEASURE")%></td>				 
						        <% }else { 			
						%>						
						        <td width="10%" class="right" title="수랑/단위"><%=CommonUtil.formatNumber(_data.get("QTY"),true,0,3)%><br><%=_data.get("UNIT_MEASURE")%></td>						
						        <%						
									} 						
						%>						
						        <td class="right" title="단가"><input type="text" name="buy_price" size="11" class = "input_type_text"   value="<%=CommonUtil.formatNumber(_data.get("TARGET_PRICE"),true,0,3)%>" style="width:90%;text-align:right;border-width:0px;" READONLY > </td>						
						        <td class="right" title="금액"> <input type="text" name="item_amt" size="11" class = "input_type_text"   value="<%=CommonUtil.formatNumber(_data.get("TARGET_AMT"),true,0,3)%>" style="width:90%;text-align:right;border-width:0px;"READONLY ></td>						
						        <td title="협력사"><%=_data.get("AGENT_NAME")%></td>						
								<td title="관리번호"><input type="hidden" name="st_ref_pr_no" id="st_ref_pr_no" value="<%=_data.get("REF_PR_NO")%>">
								  <%=_data.get("REF_PR_NO")%>
								</td>					
								 
								 								                <%  
                    if("Y".equals(budget_flag)){    
                %>
                        <td class="center" title="계정명"><%=_data.get("ACCOUNT_NAME")%></td>		
                        <td class="center" title="예산부서"><%=_data.get("BUDGET_DEPT_NAME")%></td>		
                <%  
                    }   
                %>    	
                
						        <td class="center" title="첨부"> 
										<%
					String IMAGE_KEY = CommonUtil.nvl(_data.get("IMAGE_KEY"));
			%>
                	 
                					<input type="hidden" name="st_image_key"            value="<%=IMAGE_KEY%>">
			<%
					 if(!"".equals(IMAGE_KEY)) {
			%>
				
						<a href="javascript:attach_popup('<%=IMAGE_KEY%>');"> <img src="/resources/images/disk_on.gif" name="MasterImage" width="14" height="14" border="0"> </a>
			<%
								}else {
			%>
					 <img src="/resources/images/ico_file.gif" name="MasterImage" width="14" height="14" border="0"> 
			<%
								}
			%>
                	<br><%=_data.get("DELY_BUNDLE_GBN")%>
                	
                	</td> 			
	</tr>
	<tr>
		<td colspan="10" class="left">
		<%=CommonLang.get("HTITLE583") %><!-- 배송지 --> : <%=_data.get("DELY_TO_LOCATION_TEXT")%>
		</td>
	</tr>
<% } 
%>
<input type="hidden" name="st_tot_cnt"  id="st_tot_cnt" value="<%=_list.size()%>">
<%}%>                               
                    </tbody>
                </table>   
      
				</div>   
		<table style="width:100%">
	      <tr>
	        <td align="right" height = "30" style="padding-bottom:2px"><b><font color="#990000"><%=CommonLang.get("HTITLE584") %><!-- 금액합계 --></font> : <font color="#006699">   <input type="text"   style="width:10%;text-align:right;border-width:0px;" READONLY class="input_type_text" name="st_tot_price_text" value=" <%=CommonUtil.formatNumber(tot_price,true,0,3)%>">&nbsp;<%=CommonLang.get("HTITLE660") %><!-- 원 --></font>&nbsp;</b></td>
	      </tr> 
	    </table>     
		<!--버튼영역-->   
		 <div class="btnArea" >  
		 <span class="fl">
		  		<% if (!"NONE".equals(reportText)) { %>
		  		<span class="btn_04 mr04"  title="<%=reportText%>"><a href="javascript:prnSheet();"><%=reportText%></a></span>  
		  		<%} %>
			  <%
					if( enter_flag.equals("PR_LIST_IN")){
						if( st_flag.equals("Y")){
			  %>
		  		<span class="btn_04 mr04"  title="결재현황"><a class="hyperLink"  href="javascript:openSearchPopup('/common/approval/getBuyerCommonMyPagePop.do','?COMPANY=<%=CommonUtil.nvl( rowData.get("BUYER"))%>&DOCU_NO=<%=CommonUtil.nvl( rowData.get("GW_NO")) %>&PASS_TP=2&FLAG=RECV','1200,700,no')"><%=CommonLang.get("HTITLE700") %><!-- 결재현황 --></a></span>
			  <%
						}
					}
			  %>
			  <%if(p060000097 == true){%>
			  	<span class="btn_04 mr04"  title="<%=reportText_add1%>"><a href="javascript:prnSheet1();"><%=reportText_add1%></a></span>
			  <%}%>
			  </span>
			  
			  <span class="fr">
			  <% if (( p110000004 == true && "GA".equals(RECV_FLAG) && "TYPE10".equals(p110000004_type) ) ) { %> 
				  <!-- 기능오류, 장바구니로이동 으로 대체 -->
                 <span class="btn_04 mr04"  title="다시주문하기"> <a href="javascript:reOrder_QURA(1);">재상신</a></span>				
              <%
				}
		      %>
			  <% if (( p110000004 == true && "GA".equals(RECV_FLAG) &&  "TYPE14".equals(p110000004_type) ) ) { %> 
				  <!-- 기능오류, 장바구니로이동 으로 대체 -->
                 <span class="btn_04 mr04"  title="다시주문하기"> <a href="javascript:reOrder_QURA_BizBox(1);">재상신</a></span>				
              <%
				}
		      %>
			  <% if (( p110000004 == true && "GA".equals(RECV_FLAG) && "TYPE11".equals(p110000004_type) ) ) { %> 
				  <!-- 기능오류, 장바구니로이동 으로 대체 -->
                 <span class="btn_04 mr04"  title="다시주문하기"> <a href="javascript:reOrder_HONGIK(1);">재상신</a></span>				
              <%
				}
		      %>
			  <% if (edit == true || (p060000062 == true && "GA".equals(RECV_FLAG) )) { %> 
				  <!-- 기능오류, 장바구니로이동 으로 대체 -->
                  <!--span class="btn_04 mr04"  title="다시주문하기"> <a href="javascript:reOrder(1);">재발주</a></span-->				
                  <span class="btn_04 mr04"  title="장바구니로이동"> <a href="javascript:goCartList();"><%=CommonLang.get("HTITLE701") %><!-- 장바구니로이동 --></a></span>				
			<%
				}
			%>		
			<% if ( ( p060000062 == true && "GA".equals(RECV_FLAG) ) || ( p110000004 == true && "GA".equals(RECV_FLAG) && "TYPE09".equals(p110000004_type) ) ) { %>
				<span class="btn_04 mr04"  title="결재상신"> <a href="javascript:setApproval();"><%=CommonLang.get("HTITLE702") %><!-- 결재상신 --></a></span>
			<% } %>
			  </span>
		</div>    
   </div>
</div>
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
