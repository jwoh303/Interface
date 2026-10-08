<%--
**********************************************
* 메뉴 : 
* 화면 : 수주접수 상세
* 기능 : 수주상세내역을 확인하고, 납품예정일을 입력하여 수주접수처리 한다.
* 프로그램 ID : PG_07_M_001_01
* 담당자 : 개발3 ( 설계 : 김지현 )
* 착수일 : 2014-
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../../common/include/head.jspf"  %>

<%
	@SuppressWarnings (value="unchecked")

	//SessionInfo _sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
	String user_id	= _sessionInfo.getUserId();
	
	String com_code = CommonUtil.nvl((String) request.getParameter("com_code"), _sessionInfo.getComCode());
	String p_buyer	= CommonUtil.nvl((String) request.getParameter("st_buyer"),"");  //  (조회조건)
	String p_po_no	= CommonUtil.nvl((String) request.getParameter("st_po_no"),"");  //  (조회조건)
	String p_agent_user_id = CommonUtil.nvl((String) request.getParameter("st_agent_user_id"),"");  //  (조회조건)
	
	Map<String,String> detailInfo = (Map<String,String>) request.getAttribute("detailInfo"); // 조회결과 - 상세정보
	List<Map<String, String>> detailList = (List<Map<String, String>>) request.getAttribute("detailList"); // 조회결과 - 상세 리스트
	
	Map<String,String> orderRecvHeader = (Map<String,String>) request.getAttribute("orderRecvHeader"); // 조회결과 - 발주서인쇄 정보 조회
	
	Map<String,String> specialLogicInfo = (Map<String,String>) request.getAttribute("specialLogicInfo"); // 조회결과 - 특수로직 정보 조회
	
	int page_display_cnt = 0;
	
	// 발주서인쇄, 납부지시서 이벤트 시 사용
	String buyer_tr = "";
	String seller = "";
	String ref_if_no = "";
	String add_user_id = "";
	String agent_code = "";
	
	if(orderRecvHeader != null){
		buyer_tr = CommonUtil.nvl(orderRecvHeader.get("BUYER2"));
		seller = CommonUtil.nvl(orderRecvHeader.get("SELLER"));
		ref_if_no = CommonUtil.nvl(orderRecvHeader.get("REF_IF_NO"));
		add_user_id = CommonUtil.nvl(orderRecvHeader.get("ADD_USER_ID"));
		agent_code = CommonUtil.nvl(orderRecvHeader.get("AGENT"));
		
		//buyer_tr = "KRDAEW0016";
	}
	
	String com_type = "";
	if (_sessionInfo != null){
		com_type =  CommonUtil.nvl((String)_sessionInfo.getComType()); 	
	}
	
	// MSDS 수주접수 통제 예외 협력사 확인
	boolean p060000079 = CommonUtil.getSpecialCheckReturn(com_code,"P06-0000079");
	
	// 보관조건, 보관온도 입력 필수 대상 고객사
	String p070000033 = "";
	Map<String, String> p070000033_map = CommonUtil.getSpecialCheckReturnMap(p_buyer,"P07-0000033");
	if (p070000033_map != null){
    	p070000033= CommonUtil.nvl(p070000033_map.get("COL01_DATA"),""); // 유형별 값
    }
%>
<script>
var popupSel = "";

//팝업호출
var gridIndex = 0;
function doPop(str, value1, value2, value3, value4) {
	popupSel = str ;
	
	switch (str) {
		case "agent": // 고객사
			openSearchPopup("/common/agentInfoDisplayPop.do", "?st_com_code="+value1, "800,550,no");
			break;
			
		case "catalogDetailPop": // 품목상세정보
			getBuyerCatalogDisplayPop(value1, value2, value3, value4);
			break;		
	}
}

//분할납품 팝업
function setDeliveryDivide( buyer, po_no , po_seq , po_qty , seller , st_date , h_ds_flag , x ){

	var disp_cnt        = $("#display_item_cnt").val();	// 리스트 length
	var ds_flag         = "";
	var ds_delay_reason = "";
	var query_text      = "";
	var check_flag		= "";

	if(eval(disp_cnt) < 2){
	    ds_flag         = document.forms[0].st_ds_flag.value;
	    ds_delay_reason = document.forms[0].st_delay_reason.value;
	    query_text      = document.forms[0].st_query_text.value;
	    check_flag      = document.forms[0].st_buyer_need_deli.value;
	}else{
	    ds_flag         = document.forms[0].st_ds_flag[x].value;
	    ds_delay_reason = document.forms[0].st_delay_reason[x].value;
	    query_text      = document.forms[0].st_query_text[x].value;
	    check_flag      = document.forms[0].st_buyer_need_deli[x].value;
	}

	//KEP_건설_두산메카텍 분할납품 제한.
	/*
	if(buyer=='KRKORE0254'){
		alert("KEP_건설_두산메카텍 고객사 발주건은\n\n분할 납품 할 수 없습니다");
		return;
	} 
	*/

	if(h_ds_flag =='Y'){    //  ICOMPOHD.DS_FLAG = 'Y'인 경우는 ==> 두산메카텍(주) 공작/산업기계 발주건 또는 운영자가 ICOMPOHD.DS_FLAG를 Y로 변경한 발주건 뿐입니다.
	    alert("분할 납품 할 수 없습니다");
	    return;
	}

	if(ds_flag=="Y"){
	
	}else{
	    if(!confirm("분할하여 납품하시겠습니까?")) return;
	}
 
	document.forms.sellerMpIvObtnodrReceiptDetailPop.x.value = x;

	var kep_id	= "<%=user_id%>";
	var user_id	= "<%=p_agent_user_id%>";

	var param = "?po_no="+po_no
			  + "&buyer="+buyer 
			  +"&po_seq="+po_seq 
			  +"&po_qty="+po_qty
			  +"&seller="+seller
			  +"&ds_flag="+ds_flag
			  +"&st_date="+st_date
			  +"&ds_delay_reason="+ds_delay_reason
			  +"&query_text="+query_text
			  +"&user_id="+user_id
			  +"&kep_id="+kep_id
			  +"&check_flag="+check_flag
			  ;
	
	openSearchPopup("/mpiv/showSellerMpIvDivsnDeliveryPlanEntryPop.do", param, "520,500,no");
}

//지연사유 팝업창
function setDelayReason(x){
	var disp_cnt = $("#display_item_cnt").val();
	$("#x").val(x);
	
	var buyer_need_deli = $("#st_buyer_need_deli"+x).val();
	
	if( buyer_need_deli == "Y"){
		alert("사유 입력 불필요합니다.");
		return;
	}
	
	var buyer = "<%=p_buyer%>";
	
	openSearchPopup("/mpiv/showSellerMpIvDeliveryDelayReasonPop.do", "?buyer="+buyer, "520,410,no");
}

//지연사유 팝업 내에서 호출
function getDelayReason(){
  var disp_cnt = $("#display_item_cnt").val();
  var x        = $("#x").val();
  var reason_text = "";

  if(eval(disp_cnt) < 2){
      reason_text = document.forms[0].st_delay_reason.value;
  }else{
      reason_text = document.forms[0].st_delay_reason[x].value;
  }
  return reason_text;
}

//지연사유 입력
function setReason(value,flag){ // value(지연사유) , flag ==> 해당품목(one) 또는 모든품목(all)
	var disp_cnt        = $("#display_item_cnt").val();
	var x               = $("#x").val();
	
	// 해당 row 지연
	var ds_date         = $("#st_ds_date"+x).val();
	var ds_date_text	= $("#st_ds_date_text"+x).val();
	
	var image_obj = "";
	var image_url = "";
	
	if(value==""){
		image_url = "/resources/images/btn_basic02.gif";
	}else{
		image_url = "/resources/images/btn_complete02.gif";
	}
	
	if(flag =="one"){ // 해당품목 적용
		if($("#st_buyer_need_deli"+x).val() == "N"){ // 고객사 지정 분할 납품 and 수주거부 
			$("#st_delay_reason"+x).val(value);
			
			image_obj = "ds_delay_reason_img" + x;
			
			MM_swapImage(image_obj,'',image_url,1);	
		}
	} else { // 모든품목에 적용
		for( k=0; k<disp_cnt ; k++) {
			if($("#st_buyer_need_deli"+k).val() == "N"){ // 고객사 지정 분할 납품 and 수주거부
				var delay_reason = $("#st_delay_reason"+k).val();
			
				if(isEmpty(delay_reason)){
					$("#st_ds_date"+k).val(ds_date);
					$("#st_ds_date_text"+k).val(ds_date_text);
					$("#st_org_ds_date_text"+k).val(ds_date_text);
					$("#st_delay_reason"+k).val(value);
					
					image_obj = "ds_delay_reason_img" + k;
					
					MM_swapImage(image_obj,'',image_url,1);
				}
			}
		}
	}
}

//지연사유 값 얻기
function getReason(){
 var disp_cnt = $("#display_item_cnt").val();
 var x        = $("#x").val();
 var reason_text = "";

 if(eval(disp_cnt) < 2){
     reason_text = document.forms[0].st_delay_reason.value;
 }else{
     reason_text = document.forms[0].st_delay_reason[x].value;
 }
 return reason_text;
}

//분할납품정보 입력
function setDSQuery(query,ds_date,buyer_need_check){
	var x = document.forms.sellerMpIvObtnodrReceiptDetailPop.x.value;
	
	var disp_cnt        = document.forms[0].display_item_cnt.value;
	var ds_date_text    = ds_date.substring(0,4)+"/"+ds_date.substring(4,6)+"/"+ds_date.substring(6,8);
	
	if(eval(disp_cnt) < 2){
		document.forms[0].st_query_text.value       = query;
		document.forms[0].st_ds_flag.value          = "Y";
		document.forms[0].st_ds_date.value          = ds_date;
		document.forms[0].st_ds_date_text.value     = ds_date_text;
		document.forms[0].st_org_ds_date_text.value = ds_date_text;
		document.forms[0].st_buyer_need_deli.value	= buyer_need_check;
		
		if(buyer_need_check == "Y"){
			document.forms[0].st_delay_reason.value = "";
			
			MM_swapImage("ds_delay_reason_img",'',"/resources/images/btn_basic02.gif",1);
		}
	}else{
		document.forms[0].st_query_text[x].value    = query;
		document.forms[0].st_ds_flag[x].value       = "Y";
		document.forms[0].st_ds_date[x].value       = ds_date;
		document.forms[0].st_ds_date_text[x].value  = ds_date_text;
		document.forms[0].st_org_ds_date_text[x].value  = ds_date_text;
		document.forms[0].st_buyer_need_deli[x].value = buyer_need_check;
		
		if(buyer_need_check == "Y"){
			document.forms[0].st_delay_reason[x].value = "";
			
			MM_swapImage("ds_delay_reason_img"+x,'',"/resources/images/btn_basic02.gif",1);
		}	
	}

	var image_obj = "";

	image_obj = "divide_img" + x;
	MM_swapImage(image_obj,'','/resources/images/btn_complete01.gif',1);
}

function MM_swapImage() { //v3.0
	var i,j=0,x,a=MM_swapImage.arguments; document.MM_sr=new Array; for(i=0;i<(a.length-2);i+=3)
	if ((x=MM_findObj(a[i]))!=null){document.MM_sr[j++]=x; if(!x.oSrc) x.oSrc=x.src; x.src=a[i+2];}
}

function MM_findObj(n, d) { //v4.0
	var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {
	d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
	if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
	for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document);
	if(!x && document.getElementById) x=document.getElementById(n); return x;
}

function setDeliverySchedule(){
	var disp_cnt = document.forms[0].display_item_cnt.value;
	var query = "";
	var check_cnt = 0;

	var kep_id = "<%=user_id%>";
	var buyer        = "";
	var po_no        = "";
	var po_seq       = "";
	var po_qty       = "";
	var seller       = "";
	var cd_date      = "";
	var cd_qty       = "";
	var ds_flag      = "";
	var user_id      = "<%=p_agent_user_id%>";
	var delay_reason = "";
	var max_cd_date = "";
	var rd_date     = "";
	var query_text  = "";
	var ds_date		= "";
	var st_wmre_no = "";
	var st_wmre_cancel_no = "";
	var st_date		= "";
	var buyer_need_deli = "";
	var po_create_date = "";
	
	var cod_check	= ""; //ICOMCOD1 에 있는지 체크하는 변수
	var msds_check	= ""; //BYIT.MSDS_NO의 null여부
	var req_check   = ""; //KEP_CMC_REQ 의 상태 체크
	var buyer_item_no_arr = []; //등록해야할 품목코드
	var msds_no_reg_buyer_item_no_arr = []; //카탈로그에 MSDS 미등록 품목코드
	var tempMng_no_reg_buyer_item_no_arr = []; //카탈로그에 보관조건 미등록 품목코드
	var p070000033 = ""; // 보관조건이 필수인 고객사 목록
	var temp_cond = ""; // 보관조건 유형(실온/정온/냉장/냉동/극냉동)
	
	var process_type = "";
	var warehouse_code = "";
	var tr_warehouse_yn = "";

	var harmful_check   = ""; //유해화학물질 여부 체크
	var temp_check   = ""; //보관조건 체크
	var sg118_check = ""; // 시약류 체크
	
	// 매입단가유효일 진행 통제
	var buy_close_date_chk = ""; // 매입단가유효일 체크
	
	
	
	document.forms.processForm.st_monitor.value = "MASTER_S_0";
	
	if(eval(disp_cnt) < 2){
    	cod_check = document.forms[0].st_cod_check.value;
    	msds_check = document.forms[0].st_msds_check.value;
    	req_check = document.forms[0].st_req_check.value;
    	
    	temp_check = document.forms[0].st_temp_check.value;
    	p070000033 = document.forms[0].p070000033.value;
    	sg118_check = document.forms[0].st_sg118_check.value;
    	harmful_check = document.forms[0].st_harmful_check.value;
    	temp_cond = document.forms[0].st_temp_cond.value;
    	
    	if(cod_check=="Y" && msds_check=="Y" && req_check=="N"){ //물질정보등록 대상이면서 msds미매핑 건 이면서 입력요청 외에 다른 상태 건 이 없는 경우 수주접수 통제
     		buyer_item_no_arr.push(document.forms[0].st_buyer_item_no.value);
     	}
    	
    	if(cod_check=="Y" && msds_check=="Y"){ // MSDS 대상 표준카테고리에 해당하고 카탈로그 MSDS 미매핑 품목 리스트 - 통제 2024.07.19 HSJ
    		msds_no_reg_buyer_item_no_arr.push(document.forms[0].st_buyer_item_no.value);	
     	}

    	if(p070000033 != "" && sg118_check == "Y" && temp_check == "Y"){ // 보관조건 입력 필수 고객사 & 카탈로그에 보관조건 미등록 품목 통제 - 2025.06.27 HSJ
    		tempMng_no_reg_buyer_item_no_arr.push(document.forms[0].st_buyer_item_no.value);
     	}
    	
		buyer			= document.forms[0].st_buyer.value;
		po_no			= document.forms[0].st_po_no.value;
		po_seq			= document.forms[0].st_po_seq.value;
		po_qty			= document.forms[0].st_cd_qty.value;
		cd_date			= document.forms[0].st_ds_date.value;
		cd_qty			= document.forms[0].st_cd_qty.value;
		ds_flag			= document.forms[0].st_ds_flag.value;
		seller			= document.forms[0].st_seller.value;
		seller			= document.forms[0].st_seller.value;
		delay_reason	= document.forms[0].st_delay_reason.value;
		rd_date			= document.forms[0].st_rd_date.value;
		rd_date     = rd_date.replace(/[/]/gi,"");
		query_text		= document.forms[0].st_query_text.value;    // 분할납품일 경우 이 변수에 값이 존재함
		ds_date			= document.forms[0].st_ds_date.value;
		st_wmre_no		= document.forms[0].st_wmre_no.value;
		st_wmre_cancel_no		= document.forms[0].st_wmre_cancel_no.value;
		st_date     = document.forms[0].st_st_date.value;
    	st_date     = st_date.replace(/[/]/gi,"");
    	po_create_date = document.forms[0].st_hd_po_date.value;
    	buyer_need_deli = document.forms[0].st_buyer_need_deli.value;
    	process_type = document.forms[0].st_process_type.value;
    	warehouse_code = document.forms[0].st_warehouse_code.value;
    	tr_warehouse_yn = document.forms[0].tr_warehouse_yn.value; 
    	
    	// 보관조건에 따른 거래유형 검증(아모레퍼시픽(TYPE1))
    	if(p070000033 == "TYPE1"){ // 아모레퍼시픽(TYPE1)
    		if(sg118_check == "Y"){ // 시약류
    			if(harmful_check != "Y"){ // 유해화학물질 여부
    				if(temp_cond != ""){
	        			if(temp_cond == "A" || temp_cond == "B"){ // 실온(A), 정온(B)
	            		}else{
	            			if(process_type != "0"){
	            				alert("냉장/냉동은 직납으로만 가능합니다.(거래유형오류)\n화면에 표기된 KeP담당자에게 문의하시기 바랍니다.");
	               				return;
	            			}
	            		}
    				}
        		}	
    		}
    	}
    	
    	if(harmful_check == "Y"){ // 유해화학물질 여부
    		if(process_type != "0"){ // 무조건 직납
				alert("유해화학물질이 포함되어 직납만 가능합니다.(거래유형오류)\n화면에 표기된 KeP담당자에게 문의하시기 바랍니다.");
   				return;
			}
    	}
    	
   		if(process_type == '2') {
   			if(tr_warehouse_yn == 'N' || warehouse_code == "" || warehouse_code == null || warehouse_code == 'null') {
   				alert("해당 건 진행할 수 없습니다.(거래유형정보오류)\n DX추진팀에 문의하시기 바랍니다.");
   				return;
   			}
   		}
		
		// 매입단가유효일 진행 통제
    	buy_close_date_chk = document.forms[0].st_buy_close_date_chk.value;
		if(buy_close_date_chk == "Y"){
			alert("해당 건 진행할 수 없습니다.\n매입단가유효일을 확인하시기 바랍니다.");
			return;
		}
		
		if(cd_date==""){
			alert("납품예정일을 입력해 주십시요");
			return;
		}
	
		if(buyer_need_deli == "N"){
        	if((st_date < ds_date) && isEmpty(delay_reason)) {
    			alert("납품지연사유를 입력하여 주십시요.");
    			return;
    		}	
        }

		if(st_wmre_no=="Y" && st_wmre_cancel_no == "Y"){
			alert("주문취소 대상건이므로 수주접수가 불가능 합니다.");
			return;			
		}
		if(ds_flag=="N"){ // Y는 분할납품한 품목임
			max_cd_date = cd_date;

			query +=  buyer         + "@@";
			query +=  po_no         + "@@";
			query +=  po_seq        + "@@";
			query +=  po_qty        + "@@";
			query +=  cd_date.replace(/[/]/gi,"")       + "@@";
			query +=  cd_qty        + "@@";
			query +=  "Y"           + "@@"; // DS_FLAG
			query +=  seller        + "@@";
			query +=  user_id       + "@@";
			query +=  delay_reason  + "@@";
			query +=  max_cd_date.replace(/[/]/gi,"")   + "@@";// ICOMPODT.DS_DATE 에 들어가는 값   , 분할접수일 경우 마지날 납품예정일
			query +=  rd_date       + "@@";
			query +=  ""	        + "@@"; // reject_reason 자리
			query +=  buyer_need_deli + "@@"; // DS_YN
			query +=  st_date		+ "@@";
			query +=  kep_id;
			query +=  "^||^" ;
			
			document.forms.processForm.st_monitor.value = "MASTER_S_S";
		}else{
			query +=  query_text;
			
			document.forms.processForm.st_monitor.value = "MASTER_S_M";
		}

	}else{
		// 물류센터 다른지 체크
		var  warehouse_code_tmp = document.forms[0].st_warehouse_code[0].value; // 첫행 물류센터
		
		for( k=0; k<disp_cnt ; k++){	
        	cod_check = document.forms[0].st_cod_check[k].value;
        	msds_check = document.forms[0].st_msds_check[k].value;
        	req_check = document.forms[0].st_req_check[k].value;
        	
        	temp_check = document.forms[0].st_temp_check[k].value;
        	p070000033 = document.forms[0].p070000033[k].value;
        	sg118_check = document.forms[0].st_sg118_check[k].value;
        	harmful_check = document.forms[0].st_harmful_check[k].value;
        	temp_cond = document.forms[0].st_temp_cond[k].value;
        	
        	if(cod_check=="Y" && msds_check=="Y" && req_check=="N"){ //물질정보등록 대상이면서 msds미매핑 건 이면서 입력요청 외에 다른 상태 건 이 없는 경우 수주접수 통제
        		buyer_item_no_arr.push(document.forms[0].st_buyer_item_no[k].value);
        	}
        	
        	if(cod_check=="Y" && msds_check=="Y"){ // MSDS 대상 표준카테고리에 해당하고 카탈로그 MSDS 미매핑 품목 리스트 - 통제 2024.07.19 HSJ
        		msds_no_reg_buyer_item_no_arr.push(document.forms[0].st_buyer_item_no[k].value);	
         	}

        	if(p070000033 != "" && sg118_check == "Y" && temp_check == "Y"){ // 보관조건 입력 필수 고객사 & 카탈로그에 보관조건 미등록 품목 통제 - 2025.06.27 HSJ
        		tempMng_no_reg_buyer_item_no_arr.push(document.forms[0].st_buyer_item_no[k].value);
         	}
        	
			buyer       = document.forms[0].st_buyer[k].value;
			po_no       = document.forms[0].st_po_no[k].value;
			po_seq      = document.forms[0].st_po_seq[k].value;
			po_qty      = document.forms[0].st_cd_qty[k].value;
			cd_date     = document.forms[0].st_ds_date[k].value;
			cd_qty      = document.forms[0].st_cd_qty[k].value;
			ds_flag     = document.forms[0].st_ds_flag[k].value;
			seller      = document.forms[0].st_seller[k].value;
			delay_reason= document.forms[0].st_delay_reason[k].value;
			rd_date     = document.forms[0].st_rd_date[k].value;
			rd_date     = rd_date.replace(/[/]/gi,"");
			query_text  = document.forms[0].st_query_text[k].value; // 분할납품일 경우 이 변수에 값이 존재함
			ds_date		= document.forms[0].st_ds_date[k].value;
			st_wmre_no		= document.forms[0].st_wmre_no[k].value;
			st_wmre_cancel_no		= document.forms[0].st_wmre_cancel_no[k].value;
			st_date     = document.forms[0].st_st_date[k].value;
        	st_date     = st_date.replace(/[/]/gi,"");
        	buyer_need_deli = document.forms[0].st_buyer_need_deli[k].value;
        	po_create_date = document.forms[0].st_hd_po_date[k].value;
        	process_type = document.forms[0].st_process_type[k].value;
        	warehouse_code = document.forms[0].st_warehouse_code[k].value;
        	tr_warehouse_yn = document.forms[0].tr_warehouse_yn[k].value; 
        	
        	// 보관조건에 따른 거래유형 검증(아모레퍼시픽(TYPE1))
        	if(p070000033 == "TYPE1"){ // 아모레퍼시픽(TYPE1)
        		if(sg118_check == "Y"){ // 시약류
        			if(harmful_check != "Y"){ // 유해화학물질 여부
        				if(temp_cond != ""){
	            			if(temp_cond == "A" || temp_cond == "B"){ // 실온(A), 정온(B)
	                		}else{
	                			if(process_type != "0"){
	                				alert("냉장/냉동은 직납으로만 가능합니다.(거래유형오류)\n화면에 표기된 KeP담당자에게 문의하시기 바랍니다.");
	                   				return;
	                			}
	                		}
        				}
            		}	
        		}
        	}
        	
        	if(harmful_check == "Y"){ // 유해화학물질 여부
        		if(process_type != "0"){ // 무조건 직납
    				alert("유해화학물질이 포함되어 직납만 가능합니다.(거래유형오류)\n화면에 표기된 KeP담당자에게 문의하시기 바랍니다.");
       				return;
    			}
        	}
        	
       		if(process_type == '2') {
       			if(tr_warehouse_yn == 'N' || warehouse_code == "" || warehouse_code == null || warehouse_code == 'null') {
       				alert("해당 건 진행할 수 없습니다.(거래유형정보오류)\n DX추진팀에 문의하시기 바랍니다.");
       				return;
       			}
       			// 같은 발주(TR)인데 물류센터가 다른지 체크
       			if(warehouse_code_tmp != warehouse_code) {
       				alert("해당 건 진행할 수 없습니다.(물류센터정보오류)\n DX추진팀에 문의하시기 바랍니다.");
       				return;   				
       			}
       		}
        	
			// 매입단가유효일 진행 통제
	    	buy_close_date_chk = document.forms[0].st_buy_close_date_chk[k].value;
			if(buy_close_date_chk == "Y"){
				alert( (k+1) + "번째 품목에 매입단가유효일을 확인하시기 바랍니다.");
				return;
			}
			
			if(cd_date==""){
				alert( (k+1) + "번째 품목에 납품예정일을 입력해 주십시요");
				return;
			}
			
			if(buyer_need_deli == "N"){
				if((st_date < ds_date) && isEmpty(delay_reason)) {
					alert( (k+1) + "번째 납품지연사유를 입력하여 주십시요.");
					return;
				}
			}
			
			if(st_wmre_no=="Y" && st_wmre_cancel_no == "Y"){
				alert((k+1) +"번째 주문취소 대상건이므로 수주접수가 불가능 합니다.");
				return;			
			}
			if(ds_flag=="N"){ // Y는 분할납품한 품목임
			
				max_cd_date = cd_date;
				
				query += buyer         + "@@";
				query += po_no         + "@@";
				query += po_seq        + "@@";
				query += po_qty        + "@@";
				query += cd_date.replace(/[/]/gi,"") + "@@";
				query += cd_qty        + "@@";
				query += "Y"           + "@@"; // DS_FLAG
				query += seller        + "@@";
				query += user_id       + "@@";
				query += delay_reason  + "@@";
				query += max_cd_date.replace(/[/]/gi,"") + "@@";// ICOMPODT.DS_DATE 에 들어가는 값   , 분할접수일 경우 마지날 납품예정일
				query +=  rd_date       + "@@";
				query +=  ""	        + "@@"; // reject_reason 자리
				query +=  buyer_need_deli	+ "@@"; // DS_YN
				query +=  st_date		+ "@@";
				query +=  kep_id;
				query += "^||^" ;
				
				document.forms.processForm.st_monitor.value = "MASTER_M_S";
			}else{
				query +=  query_text;
				
				document.forms.processForm.st_monitor.value = "MASTER_M_M";
			}
		}
	}
	if(buyer_item_no_arr.length != 0 && <%=p060000079%> == false){ //물질등록 해야되는 건이 있는 경우(통제 예외 협력사도 아니어야 함)
		if(confirm("해당 품목 ("+buyer_item_no_arr+") 은 산업안전보건법 상 MSDS 제공 대상입니다.\n카탈로그 관리 > 물질정보 제출 화면으로 이동하셔서 MSDS 및 물질정보 제출 후 KEP에서 MSDS매핑이 완료되면 수주접수 하시기 바랍니다\n*문의사항은 수주접수 화면에 있는 KeP담당자 통해서 하시길 바랍니다.")){
			//KEP_CMC_REQ insert 코드
			if(setGridData(query)){
				document.forms.sellerMpIvObtnodrReceiptDetailPop.st_query.value  = query;
				kepAjaxFormCall("/mpiv/saveSellerMpIvChemicalInfo.do","processForm","btnSave");
				opener.doAction("search");
				window.close();
			}
		}
	}
	
	if(tempMng_no_reg_buyer_item_no_arr.length != 0 && <%=p060000079%> == false){
		if(confirm("해당 품목 ("+tempMng_no_reg_buyer_item_no_arr+") 은 보관조건(온도) 확인이 필요한 대상입니다.\n카탈로그 관리 > 물질정보 제출 화면으로 이동하셔서 물질정보 제출 후 KEP에서 승인되면 수주접수 하시기 바랍니다\n*문의사항은 수주접수 화면에 있는 KeP담당자 통해서 하시길 바랍니다.")){
			//KEP_CMC_REQ insert 코드
			if(setGridData(query)){
				document.forms.sellerMpIvObtnodrReceiptDetailPop.st_query.value  = query;
				kepAjaxFormCall("/mpiv/saveSellerMpIvChemicalInfo.do","processForm","btnSave");
				opener.doAction("search");
				window.close();
			}
		}
	}
	
	if(msds_no_reg_buyer_item_no_arr.length != 0 && <%=p060000079%> == false){
		alert("해당 품목 ("+msds_no_reg_buyer_item_no_arr+") 은 산업안전보건법 상 MSDS 제공 대상입니다.\n현재 MSDS가 매핑되어 있지 않아 진행이 불가하니 확인하여 주시기 바랍니다.\n*문의사항은 수주접수 화면에 있는 KeP담당자 통해서 하시길 바랍니다.");
		return;
	}else{//통제 건 없는 경우 수주접수 진행
		document.forms.sellerMpIvObtnodrReceiptDetailPop.st_query.value  = query;
		document.forms.processForm.st_po_create_date.value = po_create_date;
		
//	console.log("query ==>> " + query);
	//$('#sellerMpIvObtnodrReceiptDetailPop').attr("action", "/mpiv/saveSellerMpIvObtnodrReceiptDetailPop.do").submit();
	
		if(setGridData(query)){
			if(!confirm("수주접수 하시겠습니까?")){ 
				return;
			}
		
			// 협력사 로직 사용
			kepAjaxFormCall("/mpiv/saveSellerMpIvObtnodrReceiptDetailPop.do","processForm","btnSave"); 	
		}
 
		//kepAjaxFormCall("/mp/saveSellerMpIvDeliveryDelayReasonPop.do","sellerMpIvObtnodrReceiptDetailPop","save");
	
		/*
 	document.forms[0].target = "work";
 	document.forms[0].method = "post";
 	document.forms[0].action = "/kr/agent/order/agent_order_receive_divide_cre.jsp";
 	document.forms[0].submit();
		*/
	}
}

//선택된 그리드 값을 셋팅
function setGridData(query) {
	var returnValue = true;

	var resultArr = new Array(2);
	resultArr = ['',''];
//	  for (i = 0; i < j; i++) {
	
		/*
		str[0] ==>KRKEPB0004		==> BUYER
		str[1] ==>PO04000131		==> PO_NO
		str[2] ==>000001			==> PO_SEQ
		str[3] ==>5					==> PO_QTY
		str[4] ==>20040916			==> CD_DATE
		str[5] ==>1					==> CD_QTY
		str[6] ==>Y					==> DS_FLAG
		str[7] ==>KRKORE0001		==> SELLER
		str[8] ==>KEPSE03			==> USER_ID 
		str[9] ==>지연사유			==> DS_DELAY_REASON
		str[10]==>20040916			==> MAX_CD_DATE				
		str[11]==>20040915			==> RD_DATE
		str[12]==>					==> REJECT_REASON 거부사유
		str[13]==>N					==> DS_YN		
		str[14]==>20040915			==> ST_DATE
		str[15]==>KEP2159512			==> KEP_USER_ID
		*/
		
	var inputCnt = $("input[name='st_query_text']").length;
		
	//var name = "st_buyer|st_po_no|st_po_seq|st_cd_qty|st_ds_date|st_cd_qty|st_ds_flag|st_user_id|st_delay_reason|st_max_cd_date|st_rd_date";
	
	var name = new Array(15);
	name = ['st_buyer','st_po_no','st_po_seq','st_po_qty','st_ds_date','st_cd_qty','st_ds_flag','st_seller','st_user_id','st_delay_reason','st_max_cd_date','st_rd_date','st_reject_reason','st_ds_yn','st_st_date','st_kep_id'];

	//resultArr[0] = name;
	
	var st_query = query.split("^||^");
	
	for(var j = 0; j < st_query.length-1; j++){
		
		var value = st_query[j].split("@@",-1);
		
		for(var k = 0; k < name.length; k++){
			
			
			resultArr[0] = resultArr[0]+ name[k] + "|";
			resultArr[1] = resultArr[1]+ "<input type='hidden' name='"+name[k]+"' id='"+name[k]+"' value='"+value[k]+"'>";
		}
	}

	//마지막에 | 를 없애기 위함
	if (resultArr[0] != "")  resultArr[0] = resultArr[0].substr(0, resultArr[0].length -1);
		
	if(resultArr != null && resultArr !=""){
		
		document.forms.processForm.s_SAVENAME.value = resultArr[0];
		$("#process").html(resultArr[1]);
		
	} else {
		alert("그리드 데이터 변환에 실패하였습니다.[getFormToArr]");
		returnValue = false;
	}
	
	return returnValue;
}

//ajax 공통 호출후 성공시 처리 함수
function kepAjaxSuccess(pMethod , response){
	var msg = response.msg;
	
	if (isEmpty(msg)){
		alert("수주 접수가 정상적으로 이루어 졌습니다.\n\n입력하신 날짜에 납품이 가능도록 하여 주시기 바랍니다.");
		opener.doAction("search");
		window.close();
		
	}
	return;
}

//ajax 공통 호출후 실패시 처리 함수
function kepAjaxError(pMethod , response){
	var msg = response.Message;
	
	if (!isEmpty(msg)){
		alert(msg);
	}
	return;
}

//고객사 발주서 인쇄
function btnSheet()
{
	var po_no        = "<%=p_po_no%>";
	var buyer       = "<%=p_buyer%>";
	var seller      = "<%=CommonUtil.nvl(specialLogicInfo.get("SELLER"))%>";

	//SLOGIC-BEGIN (P07-0000005)
	<%
		String rptUrl = CommonUtil.nvl(specialLogicInfo.get("RPT_URL"));

		if(rptUrl.equals("")){
			rptUrl = "RD_06_B_003_03";
		}
	%>
	//SLOGIC-END

	var param =  "["+po_no+"]["+seller+"]["+buyer+"]";
	var fileName = "<%=rptUrl%>";
	
	reportOpen(fileName,param);
	return;	
}

//고객사 발주서 인쇄
function btnSheetAgent()
{
	var po_no        = "<%=p_po_no%>";
	var buyer       = "<%=p_buyer%>";
	var seller      = "<%=CommonUtil.nvl(specialLogicInfo.get("SELLER"))%>";

	//SLOGIC-BEGIN (P06-0000025)
	<%
		String Agent_rptUrl = CommonUtil.nvl(specialLogicInfo.get("AGENT_RPT_URL"));

		if(Agent_rptUrl.equals("")){
			Agent_rptUrl = "RD_06_S_002_06";
		}
	%>
	//SLOGIC-END

	var param =  "["+po_no+"]["+seller+"]["+buyer+"]";
	var fileName = "<%=Agent_rptUrl%>";
	
	reportOpen(fileName,param);
	return;	
}

function sheetWin_daewoo_3(){  //신규 납품지시서
	 var agent_code  = "<%--=String.valueOf(vt.elementAt(4)) --%>";
	 window.open("/kr/epro/buy/sheet/daewoo_delivery_order_list.jsp?agent_code="+agent_code,"sheetWin_TEST_3","toolbar=yes,width=700,height=600,resizable=YES,scrollbars=YES,top=0,left=0");
}

//납품예정일 calender callback event
function calenderChange(dateText,num){
	var input_date = dateText.replace(/[/]/gi,"");
	var cur_date = kepGetNowTimeStr("YYYYMMDD","");
	var st_date = $.trim($("#st_st_date"+num).val());
	var st_ds_date_text = $.trim($("#st_ds_date_text"+num).val());
	var st_org_ds_date_text = $.trim($("#st_org_ds_date_text"+num).val());
	st_date = st_date.replace(/[/]/gi,"");
	var reason_txt = $.trim($("#st_delay_reason"+num).val());
	var ds_flag = $.trim($("#st_ds_flag"+num).val());

	if(isEmpty(dateText)){
        $("#st_ds_date"+num).val(cur_date);
	} else {
		if(ds_flag == "Y"){
			alert("분할납품 건은 최종 납품예정일로 고정됩니다.");
			$("#st_ds_date_text"+num).val(st_org_ds_date_text);
		}else{
			if(input_date > st_date && reason_txt==""){
		        alert("표준납기일 보다 이후날짜입니다. 지연사유을 입력하시기 바랍니다. ");
		        setDelayReason(num);
		    }
			$("#st_ds_date"+num).val(input_date);
		}
	}
}

//납품예정일 복사
function setMultiDsdate(){

	var disp_cnt = document.forms[0].display_item_cnt.value;
	
	if(eval(disp_cnt) < 2){
	    // 품목이 하나일 경우
	}else{
	    // 첫번재 행 데이타값으로 나머지 품목의 납품예정일 설정 , 분할납품품목일 경우는 생략함
	    ds_date         = document.forms[0].st_ds_date[0].value;
	    ds_date_text    = document.forms[0].st_ds_date_text[0].value;
	    delay_reason = document.forms[0].st_delay_reason[0].value;
	
	    for( k=0; k<disp_cnt ; k++){
	        var ds_flag = document.forms[0].st_ds_flag[k].value;;
	        if(ds_flag!="Y"){
	            document.forms[0].st_ds_date[k].value       = ds_date;
	            document.forms[0].st_ds_date_text[k].value  = ds_date_text;
	            document.forms[0].st_delay_reason[k].value  = delay_reason;
	        }
	        
	        if(delay_reason !=""){
	        	MM_swapImage("ds_delay_reason_img" + k,'','/resources/images/btn_complete02.gif',1);
	        }else{
	        	MM_swapImage("ds_delay_reason_img" + k,'','/resources/images/btn_basic02.gif',1);
	        }
	    }
	}
}

</script> 
</head>
<body>
<form name = "contentForm" id="contentForm" method = "post">
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다 / 500*500-->
	<div id="popWrapper" style="height:594px;">
    	<div id="popHeader">
        	<h1 class="title">수주접수 상세</h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/s_btn_popclose.gif" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer">
        	<!-- 수주접수 상세내용 -->
        	<%
        		String doc_type = "";
        		String pre_gr_flag = "";
        		String buyer_name = "";
        		String buyer2 = "";
        		String purchaser_name = "";
        		String po_create_date = "";
        		
        		String tel_no = "";
        		String agent_po_ttl_amt = "";
        		
        		String dely_to_location = "";
        		String po_remark = "";
        		        		
				if(detailInfo != null){
					
					doc_type = CommonUtil.nvl(detailInfo.get("DOC_TYPE"));
					pre_gr_flag = CommonUtil.nvl(detailInfo.get("KEPMRO_PRE_GR_FLAG"));
					buyer_name = CommonUtil.nvl(detailInfo.get("BUYER_NAME"));
	        		buyer2 = CommonUtil.nvl(detailInfo.get("BUYER2"));
	        		purchaser_name = CommonUtil.nvl(detailInfo.get("PURCHASER_NAME"));
	        		po_create_date = CommonUtil.formatStrinigDate(CommonUtil.nvl(detailInfo.get("PO_CREATE_DATE")));
	        		
	        		tel_no = CommonUtil.nvl(detailInfo.get("TEL_NO"));
	        		agent_po_ttl_amt = CommonUtil.formatNumber(CommonUtil.nvl(detailInfo.get("AGENT_PO_TTL_AMT")),true,0,3);
	        		
	        		dely_to_location = CommonUtil.nvl(detailInfo.get("DELY_TO_LOCATION"));
	        		
	        		if("KRDAEH0123".equals(p_buyer) || "KRDAEH0133".equals(p_buyer) || "KRDAEH0134".equals(p_buyer)){
						po_remark = "";
					}else{
						po_remark = CommonUtil.nvl(detailInfo.get("PO_REMARK"));
					}
	        		
				}
			%>     
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr valign="top">
			        <td height="23"></td>
			        <%
			            if(doc_type.equals("S") || (doc_type.equals("X") && pre_gr_flag.equals("Y"))){
			        %>
			                <td align="right" valign="absbottom"><font color="red"><b>※ 선입고 발주건입니다.&nbsp;</b></font></td>
			        <%
			            } else if(doc_type.equals("F")){
			        %>
			                <td align="right" valign="absbottom"><font color="red"><b>※ 긴급 발주건입니다.&nbsp;</b></font></td>
			        <%
			            }
			        %>
			    </tr>
			    <tr>
			        <td bgcolor="#898989" height="1" colspan="2"></td>
			    </tr>
			
			    <tr>
			        <td colspan="2">
			            <table width="100%" border="0" cellspacing="0" cellpadding="0">
			                <tr>
			                    <td width="9%" height="25">&nbsp;&nbsp;<font color="#993300">고객사</font></td>
			                    <td width="27%"> : 
			                    	<a class="hyperLink" href="javascript:doPop('agent','<%=buyer2%>');">
			                   			<%=buyer_name%>
			                   		</a>
			                    </td>
			                    
			                    <td width="9%">&nbsp;&nbsp;<font color="#993300">발주자</font></td>
			                    <td width="25%"> : <%=purchaser_name%></td>
			                    <td width="7%">&nbsp;&nbsp;<font color="#993300">발주일</font></td>
			                    <td width="23%"> : <%=po_create_date%></td>
			                </tr>
			
			                <tr>
			                    <td background="/resources/images/line_dot.gif" colspan="6" height="1"></td>
			                </tr>
			
			                <tr>
			                    <td width="9%" height="25">&nbsp;&nbsp;<font color="#993300">발주번호</font></td>
			                    <td width="27%"> : <%=p_po_no%></td>
			                    <td width="9%">&nbsp;&nbsp;<font color="#993300">전화번호</font></td>
			                    <td width="25%"> : <%=tel_no%></td>
			                    <td width="7%">&nbsp;&nbsp;<font color="#993300">금액</font></td>
<%if(!com_type.equals("W")){%>
			                    <td width="23%"> : <%=agent_po_ttl_amt%> 원</td>
<%}else{%>					
                      			<td width="23%"></td>
<%}%>
			                </tr>
			                <tr>
			                    <td background="/resources/images/line_dot.gif" colspan="6" height="1"></td>
			                </tr>
			                <tr>
			                    <td width="9%" height="25">&nbsp;&nbsp;<font color="#993300">배송지</font></td>
			                    <td colspan="5"> : <%=dely_to_location%></td>
			                </tr>
			                <tr>
			                    <td background="/resources/images/line_dot.gif" colspan="6" height="1"></td>
			                </tr>
			                <tr>
			                    <td width="9%" height="25">&nbsp;&nbsp;<font color="#993300">비고</font></td>
			                    <td colspan="5"> :
								<%=po_remark%>
								</td>
			                </tr>
			            </table>
			        </td>
			    </tr>
			    <tr>
			        <td bgcolor="#898989" height="1" colspan="2"></td>
			    </tr>
			    <tr>
			        <td height="10" colspan="2"></td>
			    </tr>
			</table>
			
           	<!--grid-->
            <div class="scrollArea" style="height:338px">
                <table  class="cont_t_list04"  style="width:100%">
                    <caption>수주접수 상세 리스트</caption>
                    <colgroup>
                        <col width="11%" /> 
                        <col width="28%" />
                        <col width="10%" />
                        <col width="10%" />
                        <col width="12%" />
                        <col width="8%" /> 
                        <col width="*" /> 
                    </colgroup>
                    <thead>
                        <tr>
                            <th scope="col">관리번호</th> 
                            <th scope="col">품목명/제조사</th> 
                            <th scope="col">발주수량/단위</th>
                            <th scope="col">단가/금액</th>
                            <th scope="col">표준납기일</th>
                            <th scope="col">분할납품</th>
                            <th scope="col">납기요청일</th>
                        </tr>
                        <tr>
                            <th scope="col">품목코드</th> 
                            <th scope="col">규격</th> 
                            <th scope="col" colspan="2">KeP표준화규격</th>
                            <th scope="col">
                            	<a href="javascript:setMultiDsdate();">납품예정일</a>
                            </th>
                            <th scope="col">사유</th>
                            <th scope="col">비고</th> 
                        </tr>
                    </thead>
                    <tbody>
					<%
					if (detailList == null || detailList.size() == 0){
					%>
	               		<tr bgcolor="#FFFFFF">
	                        <td colspan="8" align="center" height = "280">
	                        <span class="font1">조회된 데이타가 없습니다.</span>
	                        </td> 
	                    </tr>
					<%
					}else{
						for (int j=0; j<detailList.size(); j++) {
							page_display_cnt++;
							
							Map<String,String> rowData = detailList.get(j);
							String  tclass = (j % 2 != 0)? "#FFFFFF" : "#FAFAFA";
					%> 
					
						<input type="hidden"   name="st_buyer"      value="<%=CommonUtil.nvl(rowData.get("BUYER"))%>">
						<input type="hidden"   name="st_po_no"      value="<%=CommonUtil.nvl(rowData.get("PO_NO"))%>">
						<input type="hidden"   name="st_po_seq"     value="<%=CommonUtil.nvl(rowData.get("PO_SEQ"))%>">
						<input type="hidden"   name="st_cd_qty"     value="<%=CommonUtil.nvl(rowData.get("ITEM_QTY"))%>">
						<input type="hidden"   name="st_ds_flag"	id="st_ds_flag<%=j%>"    value="<%=CommonUtil.nvl(rowData.get("DS_FLAG"))%>">
						<input type="hidden"   name="st_seller"     value="<%=CommonUtil.nvl(rowData.get("SELLER"))%>">
						<input type="hidden"   name="st_wmre_no"     value="<%=CommonUtil.nvl(rowData.get("WMRE_NO_YN"))%>">
						<input type="hidden"   name="st_wmre_cancel_no"     value="<%=CommonUtil.nvl(rowData.get("WMRE_CANCEL_NO_YN"))%>">
						<input type="hidden"   name="st_query_flag" value="N">
						<input type="hidden"   name="st_query_text" value="">
						<input type="hidden"   name="st_user_id" value="<%=user_id%>">
						<input type="hidden"   name="st_cod_check"      value="<%=CommonUtil.nvl(rowData.get("COD_CHECK"))%>">
						<input type="hidden"   name="st_msds_check"      value="<%=CommonUtil.nvl(rowData.get("MSDS_CHECK"))%>">
						<input type="hidden"   name="st_req_check"      value="<%=CommonUtil.nvl(rowData.get("REQ_CHECK"))%>">
						<input type="hidden"   name="st_buyer_item_no"      value="<%=CommonUtil.nvl(rowData.get("BUYER_ITEM_NO"))%>">
						<input type="hidden" name="st_buy_close_date_chk" value="<%=CommonUtil.nvl(rowData.get("BUY_CLOSE_DATE_CHK"))%>">
						<input type="hidden"   name="st_hd_po_date" value="<%=CommonUtil.nvl(rowData.get("PH_PO_DATE"))%>">
						<input type="hidden"   name="st_process_type" value="<%=CommonUtil.nvl(rowData.get("PROCESS_TYPE"))%>">
						<input type="hidden"   name="st_warehouse_code" value="<%=CommonUtil.nvl(rowData.get("WAREHOUSE_CODE"))%>">
						<input type="hidden"   name="tr_warehouse_yn" value="<%=CommonUtil.nvl(rowData.get("TR_WAREHOUSE_YN"))%>">						
						<input type="hidden"   name="st_harmful_check"      value="<%=CommonUtil.nvl(rowData.get("HARMFUL_CHECK"))%>">
						<input type="hidden"   name="st_temp_check"      value="<%=CommonUtil.nvl(rowData.get("TEMP_CHECK"))%>">
						<input type="hidden"   name="p070000033" value="<%=p070000033%>">
						<input type="hidden"   name="st_temp_cond" value="<%=CommonUtil.nvl(rowData.get("TEMP_COND"))%>">
						<input type="hidden"   name="st_sg118_check" value="<%=CommonUtil.nvl(rowData.get("SG118_CHECK"))%>">
						
                        <tr bgcolor="<%=tclass%>">
							<td>
								<!-- 관리번호 -->
							 	<%=CommonUtil.nvl(rowData.get("REF_PR_NO"))%>
							</td>
							<td class="left">
								<!-- 품명/제조사 -->
							 	<%=CommonUtil.nvl(rowData.get("DESCRIPTION"))%>
							</td>
							<td>
								<!-- 발주수량 -->
							 	<%=CommonUtil.nvl(rowData.get("ITEM_QTY"))%>
								<!-- 단위 -->
							 	/ <%=CommonUtil.nvl(rowData.get("UNIT_MEASURE"))%>
							</td>
							<td class="right">
								<!-- 단가 -->
<%if(!com_type.equals("W")){%>
							 	<%=CommonUtil.formatNumber(CommonUtil.nvl(rowData.get("UNIT_PRICE")),true,0,3)%>
								<!-- 금액 -->
								/ <%=CommonUtil.formatNumber(CommonUtil.nvl(rowData.get("ITEM_AMT")),true,0,3)%>
<%}%>
							</td>
							<td>
								<!-- 표준납기일 -->
							 	<%=CommonUtil.formatStrinigDate(CommonUtil.nvl(rowData.get("ST_DATE")))%>
							 	<input type="hidden" name="st_st_date" size="10" id="st_st_date<%=j%>" value='<%=CommonUtil.formatStrinigDate(CommonUtil.nvl(rowData.get("ST_DATE")))%>' >
							 	
							</td>
							<td>
							<%
								// 특수로직 - 분할납품 제한 고객사 체크
								if(!specialLogicInfo.get("EXP_DS_FLAG").equals("Y")) {
							%>
								<!-- 분할납품 -->
								<a href="javascript:setDeliveryDivide('<%=CommonUtil.nvl(rowData.get("BUYER"))%>','<%=CommonUtil.nvl(rowData.get("PO_NO"))%>','<%=CommonUtil.nvl(rowData.get("PO_SEQ"))%>','<%=CommonUtil.nvl(rowData.get("ITEM_QTY"))%>','<%=CommonUtil.nvl(rowData.get("SELLER"))%>','<%=CommonUtil.nvl(rowData.get("ST_DATE"))%>','	<%=CommonUtil.nvl(rowData.get("H_DS_FLAG"))%>','<%=j%>');">
							 		<img name = "divide_img<%=j%>" src='/resources/images/<%=CommonUtil.nvl(rowData.get("DS_FLAG_IMG"))%>' border="0" align="absmiddle">
							 	</a>
							<%	}	%>
							</td>
							<td>
								<!-- 납기요청일 -->
							 	<%=CommonUtil.formatStrinigDate(CommonUtil.nvl(rowData.get("RD_DATE")))%>
							 	<input type="hidden" name="st_rd_date" size="10" id="st_rd_date<%=j%>" value='<%=CommonUtil.formatStrinigDate(CommonUtil.nvl(rowData.get("RD_DATE")))%>' >
							 	
							</td>
                        </tr> 
                        <tr bgcolor="<%=tclass%>">
							<td>
								<!-- 품목코드-->
								<a class="hyperLink" href="javascript:doPop('catalogDetailPop','<%=CommonUtil.nvl(rowData.get("BYIT_COMORG_CODE"))%>','<%=CommonUtil.nvl(rowData.get("BUYER_ITEM_NO"))%>','<%=CommonUtil.nvl(rowData.get("CONTRACT_NO"))%>','<%=CommonUtil.nvl(rowData.get("CONTRACT_SEQ"))%>');">
									<%=CommonUtil.nvl(rowData.get("BUYER_ITEM_NO"))%>
								</a>
							</td>
							<td class="left">
								<!-- 규격 -->
						<%if(p070000033.equals("TYPE0") || p070000033.equals("TYPE1")){%>
							<%if(CommonUtil.nvl(rowData.get("SG118_CHECK")).equals("Y")){%>
							 	<%=CommonUtil.nvl(rowData.get("SPECIFICATION"))%>&nbsp;<%=CommonUtil.nvl(rowData.get("TEMP_COND_TEXT"))%>&nbsp;<%=CommonUtil.nvl(rowData.get("TEMP_RANGE"))%>&nbsp;<%=CommonUtil.nvl(rowData.get("HARMFUL_TEXT"))%>
							<%}else{%>
								<%=CommonUtil.nvl(rowData.get("SPECIFICATION"))%>
							<%}%>	
						<%}else{%>
								<%=CommonUtil.nvl(rowData.get("SPECIFICATION"))%>
						<%}%>
							</td>
							<td  class="left" colspan="2">
								<!-- KeP표준화규격 -->
							 	<%=CommonUtil.nvl(rowData.get("REFINE_NOTE"))%>
							</td>
							<td>
								<!-- 납품예정일 -->
							 	<input type="text"   name="st_ds_date_text" style="width:65px" id="st_ds_date_text<%=j%>" class="input_type_text"  value='<%=CommonUtil.formatStrinigDate(CommonUtil.nvl(rowData.get("DS_DATE")))%>' readonly>
							 	<input type="hidden" name="st_org_ds_date_text" size="10" id="st_org_ds_date_text<%=j%>" value='<%=CommonUtil.formatStrinigDate(CommonUtil.nvl(rowData.get("DS_DATE")))%>' >
                                <input type="hidden" name="st_ds_date"      size="10" id="st_ds_date<%=j%>" value='<%=CommonUtil.nvl(rowData.get("DS_DATE"))%>' >
                                <input type="hidden" name="st_buyer_need_deli" size="10" id="st_buyer_need_deli<%=j%>" value='N' >
							</td>
							<td>
								<!-- 사유 -->
								<a href="javascript:setDelayReason('<%=j%>');">
							 		<img id="ds_delay_reason_img<%=j%>" name = "ds_delay_reason_img<%=j%>" src='/resources/images/<%=CommonUtil.nvl(rowData.get("DS_DELAY_REASON_IMG"))%>' border="0" align="absmiddle">
							 	</a>
							 	<input type="hidden"   id="st_delay_reason<%=j%>" name="st_delay_reason"   value="<%=CommonUtil.nvl(rowData.get("DS_DELAY_REASON"))%>">
							</td>
							<td>
								<!-- 비고 -->
							 	<%=CommonUtil.nvl(rowData.get("PO_REMARK"))%>
							</td>
						</tr> 
					<%
						}
					}
					%>
  
                    </tbody>
                </table>                  
                <input type="hidden" id="display_item_cnt" name="display_item_cnt"    value="<%=page_display_cnt%>">
        </div>
        
        <table width="100%" border="0" cellspacing="0" cellpadding="0" style="margin-top:8px;">
			<tr> 
				<td align="left" width="100px">
					<!-- 발주서인쇄 버튼 -->
					<!-- a href="javascript:btnSheet()"><img src="/kr/agent/images/button/btn_po_prt.gif"	width="98" height="27" border="0" align="absmiddle"></a -->
					
					<div class="btnArea">
						<div class="fr">
							<span class="btn_04">
								<a href="javascript:btnSheet();">고객사발주서</a>
							</span>	
			            </div>
			        </div>
				</td>
				
				<td align="left" width="100px">
						<div class="btnArea">
							<div class="fr">
								<span class="btn_04">
									<a href="javascript:btnSheetAgent();">협력사발주서</a>
								</span>	
				            </div>
				        </div>
					<% 
						if(buyer_tr.equals("KRDAEW0016")){ 
					%>
						<!-- 납품지시서 버튼 -->
<!-- 						<div class="btnArea"> -->
<!-- 							<div class="fr"> -->
<!-- 								<span class="btn_04"> -->
<!-- 									<a href="javascript:sheetWin_daewoo_3();">납품지시서</a> -->
<!-- 								</span>	 -->
<!-- 				            </div> -->
<!-- 				        </div> -->
							
					<% 
						}	
					%>
				</td>
				
				<td align="right">
					<!-- 수주접수 버튼 -->
					<div class="btnArea">
						<div class="fr">
							<span class="btn_04">
								<a href="javascript:setDeliverySchedule();">수주접수</a>
							</span>	
			            </div>
			        </div>
					
					<!-- a href="javascript:top.window.close();"><img src="/kr/agent/images/button/btn_close.gif"	width="64" height="27" border="0" align="absmiddle" ></a -->
				</td>
		  </tr>
		</table>
    </div>        
</div>
</form>

<form name="sellerMpIvObtnodrReceiptDetailPop" id="sellerMpIvObtnodrReceiptDetailPop" method=post >
	<!-- HIDDEN -->
	<input type="hidden" name="com_code" id="com_code"  value="<%=com_code%>">
	
	<input type="hidden" id="x" name="x"		value="">
	<input type="hidden" name="st_query"    	value="">
	<input type="hidden" name="file_get_y"		value="">
</form>

<form name="processForm" id="processForm" method="post">	
	<input type="hidden" name="s_SAVENAME" id="s_SAVENAME" value="" />
	<input type="hidden" name="st_com_code" id="st_com_code"  value="<%=agent_code%>">
	<input type="hidden" name="st_po_create_date" id="st_po_create_date"  value=""> <!-- 장납기 이슈등록 판단 기준-->
	<input type="hidden" name="st_monitor" id="st_monitor" value=""> <!-- 모니터링용. 남아있는거 보이면 삭제하세요-->
	<div id="process">
	
	</div>
</form> 
</body>
</html>
<script>
	$(document).ready(function() {
<% 
		if (detailList == null || detailList.size() == 0){ 
		}else{
			for (int j=0; j<detailList.size(); j++) {
%>
				kepSetCalender('st_ds_date_text<%=j%>',"1","Y","<%=j%>");
<%
			}
		}
%>
	});
</script>
