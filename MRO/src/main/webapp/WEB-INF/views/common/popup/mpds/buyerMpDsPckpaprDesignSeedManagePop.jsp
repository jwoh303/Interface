<%--
**********************************************
* 메뉴 : 
* 화면 : 포장지 도안 관리(종자)
* 기능 : 
* 프로그램 ID : PG_06_B_022_01
* 담당자 : 손상민 ( 설계 : 김지현 )
* 착수일 : 2014-06-10
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
<head>
<link rel="stylesheet" href="/resources/styles/base.css" type="text/css" />
<link rel="stylesheet" href="/resources/styles/buyer_layout.css" type="text/css" />
<script src="/resources/libs/jquery/js/jquery.min.js" type="text/javascript"></script>
<script src="/resources/libs/jquery/js/jquery-ui.min.js" type="text/javascript"></script>
<script src="/resources/js/kep_common.js"></script> 
 
</head>
<%
@SuppressWarnings (value="unchecked")
List<Map<String,String>> _dataList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된 결과
@SuppressWarnings (value="unchecked")
Map<String,String> userRole = (Map<String,String>) request.getAttribute("userRole"); // 권한
Map<String,String> formData = null;
if (_dataList==null || _dataList.size()==0){	
}else{
	formData = _dataList.get(0);
}

SessionInfo _sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
String com_code=  CommonUtil.nvl((String) request.getParameter("com_code"), _sessionInfo.getComCode());
String Session_user_id        = (String) _sessionInfo.getUserId();

String plant             = CommonUtil.nvl((String) request.getParameter("st_plant"),"");
String byca_comorg_code  = CommonUtil.nvl((String) request.getParameter("st_byca_comorg_code"),"");
String buyer             = CommonUtil.nvl((String) request.getParameter("st_buyer"),"");
String opkg_seq          = CommonUtil.nvl((String) request.getParameter("st_opkg_seq"),"");
String rd_date           = CommonUtil.nvl((String) request.getParameter("st_rd_date"),"");
String buyer_item_no     = CommonUtil.nvl((String) request.getParameter("st_buyer_item_no"),"");
String open_type          = CommonUtil.nvl((String) request.getParameter("st_open_type"),""); 
long productkey = System.currentTimeMillis();
// String CheckDate = WisehubDate.addWiseDateDay(curDate,+1);
	String CheckDate = CommonUtil.formatDateNoDateGubun(new Date(),1);
%>

<script type="text/javascript">
var btnEvent = "";

function kep_onload_view(){
	<%
		if (_dataList==null || _dataList.size()==0){
	%>
	kepSearch();
	<%	
		}
	%>
}

function kepSearch()
{ 
	  $('#contentForm').attr("action", "/mpds/getBuyerMpDsPckpaprDesignSeedManagePop.do").submit();    
}


//기능함수
function doAction(str, value1, value2) {
// alert(str +"::"+value1);	
	btnEvent = str;
	st = new Date();
	switch (str) {
	case "search":
		kepSearch($("#curPage").val());
		break;
	case "setBuyerDongBuOrderPackingSaveMM":
		setBuyerDongBuOrderPackingSaveMM(str, value1);
		break;
	case "setBuyerDongBuOrderPackingSaveDD":
		setBuyerDongBuOrderPackingSaveDD(str, value1);
		break;
	case "setBuyerDongBuOrderPackingSaveEE":
		setBuyerDongBuOrderPackingSaveEE(str, value1);
		break;
	case "setBuyerDongBuOrderPackingSaveEsMk":
		setBuyerDongBuOrderPackingSaveEsMk(str, value1);
		break;
	case "setBuyerDongBuOrderPackingSaveEsMk1":
		setBuyerDongBuOrderPackingSaveEsMk1(str, value1);
		break;
	case "setBuyerDongBuOrderPackingSaveEsPd":
		setBuyerDongBuOrderPackingSaveEsPd(str, value1);
		break;
	case "setBuyerDongBuOrderPackingSaveEsPd1":
		setBuyerDongBuOrderPackingSaveEsPd1(str, value1);
		break;
	case "setBuyerDongBuOrderPackingSaveEsQa1":
		setBuyerDongBuOrderPackingSaveEsQa1(str, value1);
		break;
	case "setBuyerDongBuOrderPackingSaveEsFi":
		setBuyerDongBuOrderPackingSaveEsFi(str, value1);
		break;
	case "attach"://파일 첨부
		var type="DONGBU";
		var imageKey =  value1;
		var viewType=value2;
		openSearchPopup('/common/fileUploadPop.do','?DATE_DIR=Y&DOC_NO='+imageKey+'&TYPE='+type+'&viewType='+viewType,'500,430,no');// 파일첨부
		break;
	case "close":
		break;
	}
	                  
}

//팝업 함수호출
function doPop(str,value1, value2) {
	btnEvent = str;
	
	switch (str) {
		case "masterMpDsSeedKindPop": //종자구분
			var item_code = document.contentForm.st_item_code.value;
			openSearchPopup('/mpds/showMasterMpDsSeedKindPop.do','?st_item_code='+item_code,'500,330,no');
			break;
		case "masterMpDsPckpaprDesignRejectStatePop": // 반려현황
			var plant			  = document.forms.contentForm.st_plant.value;
			var byca_comorg_code  = document.forms.contentForm.st_byca_comorg_code.value;
			var buyer			  = document.forms.contentForm.st_buyer.value;
			var opkg_seq		  = document.forms.contentForm.st_opkg_seq.value;
			var rd_date			  = document.forms.contentForm.st_rd_date.value;
			var buyer_item_no	  = document.forms.contentForm.st_buyer_item_no.value;
			openSearchPopup('/mpds/showMasterMpDsPckpaprDesignRejectStatePop.do','?st_dept='+value1+'&st_plant='+plant+'&st_byca_comorg_code='+byca_comorg_code+'&st_buyer='+buyer+'&st_opkg_seq='+opkg_seq+'&st_rd_date='+rd_date+'&st_buyer_item_no='+buyer_item_no,'500,350,no');
			break;
	}
}

/*
 * 저장처리
 */
 
 function setBuyerDongBuOrderPackingSaveMM(str, recv_flag)
{
	btnEvent = str;
   var mm_status = document.contentForm.st_mm_status.checked;

       if(mm_status == true)
       {
          document.contentForm.db_mm_status.value = "ED";
       }else {
          document.contentForm.db_mm_status.value = "N";
       }

      if(document.contentForm.db_mm_status.value == "ED")
      {
         document.contentForm.db_recv_flag.value = recv_flag;
      }else {
         document.contentForm.db_recv_flag.value = "NW";
      }

     if(!confirm("입력한 내용을 수정 하시겠습니까?")) return;

     kepAjaxFormCall("/mpds/buyer_dongbu_jongja_order_packing_update_reg.do","contentForm",str);

 }

 function setBuyerDongBuOrderPackingSaveDD(str, recv_flag)
{
	btnEvent = str;
     

   var dd_status = document.contentForm.st_dd_status.checked;

       if(dd_status == true)
       {
          document.contentForm.db_dd_status.value = "ED";
       }else {
          document.contentForm.db_dd_status.value = "RC";
       }


     document.contentForm.db_recv_flag.value = recv_flag;


     if(!confirm("입력한 내용을 수정 하시겠습니까?")) return;

     kepAjaxFormCall("/mpds/buyer_dongbu_order_packing_update_dd_reg.do","contentForm",str);

 }

 function setBuyerDongBuOrderPackingSaveEE(str, recv_flag)
{
	btnEvent = str;
     

   var ee_status = document.contentForm.st_ee_status.checked;

       if(ee_status == true)
       {
          document.contentForm.db_ee_status.value = "ED";
       }else {
          document.contentForm.db_ee_status.value = "RC";
       }


     document.contentForm.db_recv_flag.value = recv_flag;


     if(!confirm("입력한 내용을 수정 하시겠습니까?")) return;

     kepAjaxFormCall("/mpds/buyer_dongbu_order_packing_update_ee_reg.do","contentForm",str);

 }

 function setBuyerDongBuOrderPackingSaveEsMk1(str, recv_flag)
{
	btnEvent = str;  
     
     if(document.contentForm.st_es_mk1_status0.checked == true)
     {
        checkOne('st_es_mk1_status',0);
     }
     if(document.contentForm.st_es_mk1_status1.checked == true)
     {
        checkOne('st_es_mk1_status',1);
     }

     var es_mk1_status = document.contentForm.st_es_mk1_status.value;
     if(es_mk1_status == "B")
     {
         document.contentForm.db_recv_flag.value = "GB";
     }else {
         document.contentForm.db_recv_flag.value = "IG";
     }

  
 if(document.contentForm.db_recv_flag.value == "GB")
 {
     if(!confirm("현재 도안을 반려 하시겠습니까?")) return;
 }else {
     if(!confirm("입력한 내용을 수정 하시겠습니까?")) return;
 }

     kepAjaxFormCall("/mpds/buyer_dongbu_jongja_order_packing_update_es_mk1_reg.do","contentForm",str);

 }

 function setBuyerDongBuOrderPackingSaveEsPd1(str, recv_flag)
{
	btnEvent = str;
     
     if(document.contentForm.st_es_pd1_status0.checked == true)
     {
        checkOne('st_es_pd1_status',0);
     }
     if(document.contentForm.st_es_pd1_status1.checked == true)
     {
        checkOne('st_es_pd1_status',1);
     }

     var es_pd_status1 = document.contentForm.st_es_pd1_status.value;
     if(es_pd_status1 == "B")
     {
         document.contentForm.db_recv_flag.value = "GB";
     }else {
         document.contentForm.db_recv_flag.value = "IG";
     }


 if(document.contentForm.db_recv_flag.value == "GB")
 {
     if(!confirm("현재 도안을 반려 하시겠습니까?")) return;
 }else {
     if(!confirm("입력한 내용을 수정 하시겠습니까?")) return;
 }

     kepAjaxFormCall("/mpds/buyer_dongbu_jongja_order_packing_update_es_pd1_reg.do","contentForm",str);

 }

 function setBuyerDongBuOrderPackingSaveEsQa1(str, recv_flag)
{
	btnEvent = str;
     
     if(document.contentForm.st_es_qa1_status0.checked == true)
     {
        checkOne('st_es_qa1_status',0);
     }
     if(document.contentForm.st_es_qa1_status1.checked == true)
     {
        checkOne('st_es_qa1_status',1);
     }

     var es_qa1_status = document.contentForm.st_es_qa1_status.value;
     if(es_qa1_status == "B")
     {
         document.contentForm.db_recv_flag.value = "GB";
     }else {
         document.contentForm.db_recv_flag.value = "IG";
     }


 if(document.contentForm.db_recv_flag.value == "GB")
 {
     if(!confirm("현재 도안을 반려 하시겠습니까?")) return;
 }else {
     if(!confirm("입력한 내용을 수정 하시겠습니까?")) return;
 }

     kepAjaxFormCall("/mpds/buyer_dongbu_jongja_order_packing_update_es_qa1_reg.do","contentForm",str);

 }



 function setBuyerDongBuOrderPackingSaveEsFi(str, recv_flag){
      
     if(document.contentForm.st_es_fi_status0.checked == true){
        checkOne('st_es_fi_status',0);
     }
     if(document.contentForm.st_es_fi_status1.checked == true){
        checkOne('st_es_fi_status',1);
     } 
     var es_fi_status = document.contentForm.st_es_fi_status.value; 
     if(es_fi_status == "B"){
         document.contentForm.db_recv_flag.value = "GB";
     }else {
         document.contentForm.db_recv_flag.value = "IG";
     }
   
 	if(document.contentForm.db_recv_flag.value == "GB"){
 		if(!confirm("현재 도안을 반려 하시겠습니까?")) return;
 	}else{
 		if(!confirm("입력한 내용을 수정 하시겠습니까?")) return;
 	}
     kepAjaxFormCall("/mpds/buyer_dongbu_order_packing_update_es_fi_reg.do","contentForm",str);

 }


 function setBuyerDongBuOrderPackingSaveEsMk(str, recv_flag)
{
	btnEvent = str;  
     

     if(document.contentForm.st_es_mk_status0.checked == true)
     {
        checkOne('st_es_mk1_status',0);
     }
     if(document.contentForm.st_es_mk_status1.checked == true)
     {
        checkOne('st_es_mk1_status',1);
     }

     var es_mk_status = document.contentForm.st_es_mk_status.value;
     if(es_mk_status == "B")
     {
         document.contentForm.db_recv_flag.value = "GB";
     }else {
         document.contentForm.db_recv_flag.value = "IG";
     }

 if(document.contentForm.db_recv_flag.value == "GB")
 {
     if(!confirm("현재 도안을 반려 하시겠습니까?")) return;
 }else {
     if(!confirm("입력한 내용을 수정 하시겠습니까?")) return;
 }

     kepAjaxFormCall("/mpds/buyer_dongbu_jongja_order_packing_update_es_mk_reg.do","contentForm",str);

 }

 function setBuyerDongBuOrderPackingSaveEsPd(str, recv_flag)
{
	btnEvent = str;
     
     if(document.contentForm.st_es_pd_status0.checked == true)
     {
        checkOne('st_es_pd_status',0);
     }
     if(document.contentForm.st_es_pd_status1.checked == true)
     {
        checkOne('st_es_pd_status',1);
     }

     var es_pd_status = document.contentForm.st_es_pd_status.value;
     if(es_pd_status == "B")
     {
         document.contentForm.db_recv_flag.value = "GB";
     }else {
         document.contentForm.db_recv_flag.value = "IG";
     }


 if(document.contentForm.db_recv_flag.value == "GB")
 {
     if(!confirm("현재 도안을 반려 하시겠습니까?")) return;
 }else {
     if(!confirm("입력한 내용을 수정 하시겠습니까?")) return;
 }

     kepAjaxFormCall("/mpds/buyer_dongbu_jongja_order_packing_update_es_pd_reg.do","contentForm",str);

 }
 
function setResult(result){

    if(result == "UPDATE_OK"){
        alert("정상적으로 수정이 이루어 졌습니다.");
        opener.setQuery();
        window.close();
    }else if(result == "UPDATE_FAIL"){
        alert("수정이 실패하였습니다. 다시 확인하여 주십시요. ");
        return;
    }
}

// 체크 박스 하나만 선택
function checkOne( checkbox_name , i){

    var box = eval("document.forms.contentForm."+ checkbox_name + i);

    if(box.checked == true){

        // 체크 박스 하나만 선택
        for(var k = 0; k < 2; k++){
            var box = eval("document.forms.contentForm."+ checkbox_name + k);

            if(box.checked == true && eval(k) != eval(i)){
                box.checked = false;
            }
        }

        // 값 설정
        box = eval("document.forms.contentForm."+ checkbox_name);

        if(i==0){
            box.value = "Y";
        }else if(i==1){
            box.value = "B";
        }

    }else{

        box = eval("document.forms.contentForm."+ checkbox_name);
        box.value = "N";
    }

}


function getDongOpkgAttachView(productkey,tmp_image_key) {

	var image_key = document.forms.contentForm.st_image_key.value;

	if(tmp_image_key == "N") {

		if(image_key != productkey) {

			document.forms.contentForm.st_image_key.value = productkey;

			var url="/kr/sysop/proxbuy/common/popup/popup_download.jsp?productkey="+productkey+"&exfuc=Y&type=DONGBU";

			var width = 610;
			var height = 285;
			var left = 0;
			var top = 0;
			var toolbar = 'no';
			var menubar = 'no';
			var status = 'no';
			var scrollbars = '1';
			var resizable = 'no';
			var getDongPackAttachCh = window.open( url, 'getDongOpkgAttachView2', 'left='+left+', top='+top+', width='+width+', height='+height+', toolbar='+toolbar+', menubar='+menubar+', status='+status+', scrollbars='+scrollbars+', resizable='+resizable);

		}else {

		var url="/kr/sysop/proxbuy/common/popup/popup_download.jsp?productkey="+productkey+"&exfuc=Y&type=DONGBU";

		var width = 610;
		var height = 285;
		var left = 0;
		var top = 0;
		var toolbar = 'no';
		var menubar = 'no';
		var status = 'no';
		var scrollbars = '1';
		var resizable = 'no';
		var getDongPackAttachCh = window.open( url, 'getDongOpkgAttachView2', 'left='+left+', top='+top+', width='+width+', height='+height+', toolbar='+toolbar+', menubar='+menubar+', status='+status+', scrollbars='+scrollbars+', resizable='+resizable);
		}
		

	}else {

		var url="/kr/sysop/proxbuy/common/popup/popup_download.jsp?productkey="+tmp_image_key+"&exfuc=Y&type=DONGBU";

		var width = 610;
		var height = 285;
		var left = 0;
		var top = 0;
		var toolbar = 'no';
		var menubar = 'no';
		var status = 'no';
		var scrollbars = '1';
		var resizable = 'no';
		var getDongPackAttachCh = window.open( url, 'getDongOpkgAttachView2', 'left='+left+', top='+top+', width='+width+', height='+height+', toolbar='+toolbar+', menubar='+menubar+', status='+status+', scrollbars='+scrollbars+', resizable='+resizable);

	}
}

function getDongOpkgAttachView2(productkey,tmp_image_key) {

	var url="/kr/sysop/proxbuy/common/popup/popup_download.jsp?productkey="+tmp_image_key+"&exfuc=N&type=DONGBU";

	var width = 610;
	var height = 285;
	var left = 0;
	var top = 0;
	var toolbar = 'no';
	var menubar = 'no';
	var status = 'no';
	var scrollbars = '1';
	var resizable = 'no';
	var getDongPackAttachCh = window.open( url, 'getDongOpkgAttachView2', 'left='+left+', top='+top+', width='+width+', height='+height+', toolbar='+toolbar+', menubar='+menubar+', status='+status+', scrollbars='+scrollbars+', resizable='+resizable);

}

// ROW에 파일 설정
function setAttach_two(attach_key, arrAttrach, SeqCnt){

    if(SeqCnt >= '1'){
		document.forms.contentForm.st_image_key.value = attach_key;
    }else{
		document.forms.contentForm.st_image_key.value = "";
    }
}

function viewGbHistory(dept){  
	var plant			  = document.forms.contentForm.st_plant.value;
	var byca_comorg_code  = document.forms.contentForm.st_byca_comorg_code.value;
	var buyer			  = document.forms.contentForm.st_buyer.value;
	var opkg_seq		  = document.forms.contentForm.st_opkg_seq.value;
	var rd_date			  = document.forms.contentForm.st_rd_date.value;
	var buyer_item_no	  = document.forms.contentForm.st_buyer_item_no.value;
    viewGbHistoryList(dept,plant,byca_comorg_code,buyer,opkg_seq,rd_date,buyer_item_no); 
}



/**
 * ajax 공통 호출후 성공시 처리 함수
 */
function kepAjaxSuccess(pMethod , response){
	var msg = response.msg;
	if (msg != ""){
		alert(msg);
	}

	//처리후 화면 닫기
	if(btnEvent == "setBuyerDongBuOrderPackingSaveMM" 
			|| btnEvent == "setBuyerDongBuOrderPackingSaveDD" 
			|| btnEvent == "setBuyerDongBuOrderPackingSaveEE" 
			|| btnEvent == "setBuyerDongBuOrderPackingSaveEsMk" 
			|| btnEvent == "setBuyerDongBuOrderPackingSaveEsMk1" 
			|| btnEvent == "setBuyerDongBuOrderPackingSaveEsPd" 
			|| btnEvent == "setBuyerDongBuOrderPackingSaveEsPd1"
			|| btnEvent == "setBuyerDongBuOrderPackingSaveEsQa1"
			|| btnEvent == "setBuyerDongBuOrderPackingSaveEsFi"
			){
		setReturn();
	}else{ 
		// 처리후 재조회
	 	kepSearch($("#curPage").val());
	}
}

/**
 * ajax 공통 호출후 에러시 처리 함수
 */
function  kepAjaxError(pMethod , response) {
	
} 


function setReturn(value1,value2)
{ 
  opener.setPopupReturn(value1,value2);
  this.close();
}

//콜백함수
function setPopupReturn(value1, value2){
	
	//팝업 조회후 해당 항목에 값을 셋팅
	if (btnEvent == "masterMpDsSeedKindPop") {	// 종자구분
		document.contentForm.st_item_code.value = value1;
		document.contentForm.st_item_name.value = value2;
		
	}else if (btnEvent == "attach") {	// 종자구분
		$("#st_image_key").val(value1);
	}

}

</script> 
<body onload="kep_onload_view()">
<form name="contentForm" id="contentForm" method=post >
<input type="hidden" name="com_code" id="com_code"  value="<%=com_code%>">
<input type="hidden" name="st_user_id" id="st_user_id" value="${sessionInfo.userId}">

<!-- HIDDEN -->
<input type="hidden" name="st_plant"             value="<%=plant%>">
<input type="hidden" name="st_byca_comorg_code"  value="<%=byca_comorg_code%>">
<input type="hidden" name="st_buyer"             value="<%=buyer%>">
<input type="hidden" name="st_opkg_seq"          value="<%=opkg_seq%>">
<input type="hidden" name="st_rd_date"           value="<%=rd_date%>">
<input type="hidden" name="st_buyer_item_no"     value="<%=buyer_item_no%>">
<input type="hidden" name="st_open_type"     value="<%=open_type%>">

<input type="hidden" name="st_buyer_code"        value="">
<input type="hidden" name="st_pkg_code"   id="st_pkg_code"  value="PKG2">

<input type="hidden" name="db_mm_status"        value="">
<input type="hidden" name="db_dd_status"        value="">
<input type="hidden" name="db_ee_status"        value="">
<input type="hidden" name="st_es_mk_status"     value="">
<input type="hidden" name="st_es_mk1_status"     value="">
<!-- <input type="hidden" name="st_es_mk_remark"     value=""> -->
<input type="hidden" name="st_es_pd_status"     value="">
<input type="hidden" name="st_es_pd1_status"     value="">
<!-- <input type="hidden" name="st_es_pd_remark"     value=""> -->
<input type="hidden" name="st_es_qa_status"     value="">
<input type="hidden" name="st_es_qa1_status"     value="">
<input type="hidden" name="st_es_qa_remark"     value="">
<input type="hidden" name="st_es_fi_status"     value="">
<input type="hidden" name="db_recv_flag"        value="">

<%
if (formData==null || formData.size()==0){
%>
<%}else{ %>	 	

<input type="hidden" id="st_image_key"   name="st_image_key"      value="<%=formData.get("IMAGE_KEY")%>">
	
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다 / 500*500-->
	<div id="popWrapper" style="height:814px;">
    	<div id="popHeader">
        	<h1 class="title">포장지 도안 관리(종자)</h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/b_btn_popclose.gif" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
		<span class="fl">
			<img src="/resources/images/rd_pin.gif" style="padding-left:20px;"> <font  style="color:#444444; font-weight:bold;">도안상세정보</font>
		</span>		                
        
        <div id="popContainer">
		        	<table class="cont_t_list06">
		            	<caption>리스트</caption>
		                <colgroup>
		                    <col width="20%" />
		                    <col width="30%" />
		                    <col width="15%" />
		                    <col width="35%" />
		                </colgroup>
		                <tbody>
					        <tr>
					          <th >품목코드</th>
					          <td ><span style="color:blue"><b><%=formData.get("BUYER_ITEM_NO")%></b></span></td>
					          <th >진행상태</th>
					          <td >
							  <%if(open_type.equals("dongbu")){%>
								<span style="color:blue"><a class="hyperLink"  href="javascript:doPop('masterMpDsPckpaprDesignRejectStatePop','ALL');"><b><%=formData.get("RECV_TEXT")%></b></a></span>
							  <%}else{%>
								<span style="color:blue"><b><%=formData.get("RECV_TEXT")%></b></span>
							  <%}%>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
								<%
									String product_flag ="";
									if(!formData.get("MM_BARCODE_NO").equals("")) { 
										product_flag ="disabled";
									}
								%>
							  </td>
					        </tr>
					        <tr>
					          <th height="32">품목명</th>
					          <td ><%=formData.get("DESCRIPTION")%></td>
					          <th >제품구분</th>
					          <td>
								<% if(formData.get("PRODUCT_FLAG").equals("H1")){ %>
								<B>흥농</B>
								<% }else if(formData.get("PRODUCT_FLAG").equals("H2")){ %>
								<B>한농</B>
								<% }else { %>
								<B>대농</B>
								<% } %>
					        </td>
					        </tr>
					        <tr>
					          <th height="32">규격</th>
					          <td ><%=formData.get("SPECIFICATION")%></td>
					          <th height="32">구분</th>
					          <td ><%=formData.get("USE_TEXT")%>&nbsp;//&nbsp;<%=formData.get("GUBUN")%></td>
					        </tr>
					        <tr>
					          <th height="32">제조사</th>
					          <td ><%=formData.get("MAKER_NAME")%></td>
					          <th >지정협력사</th>
					          <td ><%=formData.get("AGENT_TEXT")%></td>
					        </tr>
					        <tr>
					          <th >종자구분</th>
					          <td >
					          <%if(open_type.equals("dongbu")){%>
					          		<%=formData.get("ITEM_NM")%>
								<%}else{ %> 
									<input type="text" name="st_item_name" id="st_item_name" style="width:60%" value="<%=formData.get("ITEM_NM")%>" readonly onclick="javascript:doPop('masterMpDsSeedKindPop');">
									<input type="hidden" name="st_item_code" id="st_item_code" style="width:80%" value="<%=formData.get("ITEM_NO")%>">
									<a href="javascript:doPop('masterMpDsSeedKindPop');"><img src="/resources/images/btn_search03.gif"></a>
									<a href="javascript:kepEraser('st_item_code','st_item_name');"><img src="/resources/images/btn_eraser2.gif"></a>
								<%}%>
					          </td>
					          <th >첨부파일</th>
					          <td >
<%-- 								<% if(formData.get("IMAGE_KEY").equals("N") && (formData.get("RECV_FLAG").equals("NW")||formData.get("RECV_FLAG").equals("IG")) &&  --%>
<%-- 										"1".equals(userRole.get("P001")) || "1".equals(userRole.get("P002")) || "1".equals(userRole.get("P003")) ) { %> --%>
<%-- 										<span class="btn_imghide"><a href="javascript:doAction('attach', '<%=formData.get("IMAGE_KEY")%>', 'W');">첨부 등록</a></span> --%>
<%-- 								<% } else { %> --%>
<%-- 									<% if("1".equals(userRole.get("P001")) && (formData.get("RECV_FLAG").equals("NW") || formData.get("RECV_FLAG").equals("IG")) && !formData.get("MM_STATUS").equals("ED")) { %> --%>
									<% if("1".equals(userRole.get("P001")) && !formData.get("MM_STATUS").equals("ED")) { %>
												<span class="btn_imghide"><a href="javascript:doAction('attach','<%=formData.get("IMAGE_KEY")%>', 'W');">첨부 등록</a></span>
<%-- 									<% } else if("1".equals(userRole.get("P002")) && formData.get("RECV_FLAG").equals("IG") && !formData.get("DD_STATUS").equals("ED")) { %> --%>
<%-- 												<span class="btn_imghide"><a href="javascript:doAction('attach','<%=formData.get("IMAGE_KEY")%>', 'W');">첨부 등록</a></span> --%>
<%-- 									<% } else if( ("1".equals(userRole.get("P003")) && formData.get("PRODUCT_FLAG").equals("AG"))   --%>
<%-- 													 && formData.get("RECV_FLAG").equals("IG") && !formData.get("EE_STATUS").equals("ED"))  { %> --%>
<%-- 												<span class="btn_imghide"><a href="javascript:doAction('attach', '<%=formData.get("IMAGE_KEY")%>', 'W');">첨부 등록</a></span> --%>
									<% } else { %>
												<span class="btn_imghide"><a href="javascript:doAction('attach','<%=formData.get("IMAGE_KEY")%>', 'R');">첨부 보기</a></span>
									<% } %>
<%-- 								<% } %> --%>
					          </td>
					        </tr>
					        <tr>
					          <th >시작일</th>
					          <td ><%=CommonUtil.formatStrinigDate(formData.get("RD_DATE"))%></td>
					          <th >디자인 완료일</th>
					          <td ><%=(formData.get("EE_DATE").equals(CheckDate) ? "<span style=color:red><b>"+CommonUtil.formatStrinigDate(formData.get("EE_DATE"))+"</b><span>" : CommonUtil.formatStrinigDate(formData.get("EE_DATE")))%></td>
					        </tr>
					        <tr>
					          <th height="32">1차컴펌 완료일</th>
					          <td ><%=(formData.get("DD_DATE").equals(CheckDate) ? "<span style=color:red><b>"+CommonUtil.formatStrinigDate(formData.get("DD_DATE"))+"</b><span>" : CommonUtil.formatStrinigDate(formData.get("DD_DATE")))%></td>
					          <th >최종 확정일</th>
					          <td ><%=(formData.get("ES_DATE").equals(CheckDate) ? "<span style=color:red><b>"+CommonUtil.formatStrinigDate(formData.get("ES_DATE"))+"</b><span>" : CommonUtil.formatStrinigDate(formData.get("ES_DATE")))%></td>
					        </tr>
		                </tbody>
		            </table>
            			    
		<span class="fl">
			<img src="/resources/images/rd_pin.gif"> <font  style="color:#444444; font-weight:bold;">도안확인정보</font>
		</span>		                
			      
        	<table class="cont_t_list06">
            	<caption>리스트</caption>
                <colgroup>
                    <col width="15%" />
                    <col width="6%" />
                    <col width="*" />
                </colgroup>
                <tbody>
					<tr>
						<th>디자인</th>
				          <td>완료<br>
				<% if("1".equals(userRole.get("P001")) && formData.get("RECV_FLAG").equals("NW")){ %>
				            <input id="check" type="checkbox" name="st_mm_status" value="ED" <%=(formData.get("MM_STATUS").equals("ED") ? "checked" : "")%>	<%=(formData.get("MM_STATUS").equals("ED") ? "disabled" : "")%>>
				<% }else{ %> 
				            <input id="check" type="checkbox" name="st_mm_status" value="ED" <%=(formData.get("MM_STATUS").equals("ED") ? "checked" : "")%> disabled>
				<% } %>
				          </td>
				          <td colspan="2" >
				<% if("1".equals(userRole.get("P001")) && formData.get("RECV_FLAG").equals("NW")){ %>
				            <textarea rows="3" id="st_mm_remark" name="st_mm_remark"   style="padding:3px;width:100%;ime-mode:active" <%=(formData.get("MM_STATUS").equals("ED") ? "READONLY" : "")%> maxlength="200"><%=formData.get("MM_REMARK")%></textarea>
				<% }else { %>
				            <textarea rows="3" name="st_mm_remark" style="padding:3px;width:100%;ime-mode:active" <%=(formData.get("MM_STATUS").equals("ED") ? "READONLY" : "")%> READONLY><%=formData.get("MM_REMARK")%></textarea>
				<% } %>
				          </td>
					</tr>
                </tbody>
            </table>
			      
        	<table class="cont_t_list06">
            	<caption>리스트</caption>
                <colgroup>
                    <col width="3%" />
                    <col width="18%" />
                    <col width="15%" />
                    <col width="*" />
                </colgroup>
                <tbody>
			        <tr>
			          <th rowspan="5" width="5%" style="text-align:center">
						1<br>
						차<br>
						확<br>
						인
						</th>
			          <th width="16%" align="right">작물담당(PM)</th>
			                <td width="23%" style="padding-left:4px">
			<%
// 			System.out.println("P002::"+userRole.get("P002"));
// 			System.out.println(userRole.get("JONGJA_GUBUN"));
// 			System.out.println(formData.get("ITEM_NO"));
// 			System.out.println(userRole.get("JONGJA_GUBUN").indexOf(formData.get("ITEM_NO")));
// 			System.out.println("1".equals(userRole.get("P002")) && formData.get("RECV_FLAG").equals("IG") && formData.get("MM_STATUS").equals("ED") && formData.get("ES_MK1_STATUS").equals("N") && ( userRole.get("JONGJA_GUBUN").indexOf(formData.get("ITEM_NO")) > -1 ) );
// 			System.out.println(formData.get("RECV_FLAG"));
// 			System.out.println(formData.get("MM_STATUS"));
// 			System.out.println(formData.get("ES_MK1_STATUS"));
 			if("1".equals(userRole.get("P002")) && formData.get("RECV_FLAG").equals("IG") && formData.get("MM_STATUS").equals("ED") && formData.get("ES_MK1_STATUS").equals("N") && ( userRole.get("JONGJA_GUBUN").indexOf(formData.get("ITEM_NO")) > -1 ) ) { %>
			                  <input id="check" type="checkbox" name="st_es_mk1_status0" value="Y" <%=(formData.get("ES_MK1_STATUS").equals("Y") ? "checked" : "")%> onclick="javascript:checkOne('st_es_mk1_status',0)">확인
			                  &nbsp;&nbsp;
			                  <input id="check" type="checkbox" name="st_es_mk1_status1" value="B" <%=(formData.get("ES_MK1_STATUS").equals("B") ? "checked" : "")%> onclick="javascript:checkOne('st_es_mk1_status',1)">반려
			<% }else { %>
			                  <input id="check" type="checkbox" name="st_es_mk1_status0" value="Y" <%=(formData.get("ES_MK1_STATUS").equals("Y") ? "checked" : "")%> disabled>확인
			                  &nbsp;&nbsp;
			                  <input id="check" type="checkbox" name="st_es_mk1_status1" value="B" <%=(formData.get("ES_MK1_STATUS").equals("B") ? "checked" : "")%> disabled>반려
			<% } %>
			                </td>
			                <td>&nbsp;
			<% if("1".equals(userRole.get("P002")) && formData.get("RECV_FLAG").equals("IG") && formData.get("MM_STATUS").equals("ED") && formData.get("ES_MK1_STATUS").equals("N")&& ( userRole.get("JONGJA_GUBUN").indexOf(formData.get("ITEM_NO")) > -1 )) { %>
			                  <textarea rows="3" name="st_es_mk1_remark" style="padding:3px;width:97%;ime-mode:active" maxlength="200"><%=formData.get("ES_MK1_REMARK")%></textarea>
			<% }else { %>
			                  <textarea rows="3" name="st_es_mk1_remark" style="padding:3px;width:97%;ime-mode:active" READONLY><%=formData.get("ES_MK1_REMARK")%></textarea>
			<% } %>
			
			                </td>
			        </tr>
			        <tr >
			          <th align="right">등록문안<br>확인 담당</th>
			                <td width="23%" style="padding-left:4px">
			<% if( 
					"1".equals(userRole.get("P003"))
					&& formData.get("RECV_FLAG").equals("IG") && formData.get("MM_STATUS").equals("ED") && formData.get("ES_PD1_STATUS").equals("N")){ %>
			                  <input id="check" type="checkbox" name="st_es_pd1_status0" value="Y" <%=(formData.get("ES_PD1_STATUS").equals("Y") ? "checked" : "")%> onclick="javascript:checkOne('st_es_pd1_status',0)">확인
			                  &nbsp;&nbsp;
			                  <input id="check" type="checkbox" name="st_es_pd1_status1" value="B" <%=(formData.get("ES_PD1_STATUS").equals("B") ? "checked" : "")%> onclick="javascript:checkOne('st_es_pd1_status',1)">반려
			<% }else { %>
			                  <input id="check" type="checkbox" name="st_es_pd1_status0" value="Y" <%=(formData.get("ES_PD1_STATUS").equals("Y") ? "checked" : "")%> disabled>확인
			                  &nbsp;&nbsp;
			                  <input id="check" type="checkbox" name="st_es_pd1_status1" value="B" <%=(formData.get("ES_PD1_STATUS").equals("B") ? "checked" : "")%> disabled>반려
			<% } %>
			                </td>
			                <td>&nbsp;
			<% if( 
					"1".equals(userRole.get("P003"))
					&& formData.get("RECV_FLAG").equals("IG") && formData.get("MM_STATUS").equals("ED") && formData.get("ES_PD1_STATUS").equals("N")){ %>
							  <textarea rows="3" name="st_es_pd1_remark" style="padding:3px;width:97%;ime-mode:active" maxlength="200"><%=formData.get("ES_PD1_REMARK")%></textarea>
			<% }else { %>
			                  <textarea rows="3" name="st_es_pd1_remark" style="padding:3px;width:97%;ime-mode:active" READONLY><%=formData.get("ES_PD1_REMARK")%></textarea>
			<% } %>
			                </td>
			        </tr>
			        <tr >
			          <th align="right">사진기획 담당</th>
			                <td width="23%" style="padding-left:4px">
			<% if("1".equals(userRole.get("P004")) && formData.get("RECV_FLAG").equals("IG") && formData.get("MM_STATUS").equals("ED")&& formData.get("ES_QA1_STATUS").equals("N")) { %>
			                  <input id="check" type="checkbox" name="st_es_qa1_status0" value="Y" <%=(formData.get("ES_QA1_STATUS").equals("Y") ? "checked" : "")%> onclick="javascript:checkOne('st_es_qa1_status',0)">확인
			                  &nbsp;&nbsp;
			                  <input id="check" type="checkbox" name="st_es_qa1_status1" value="B" <%=(formData.get("ES_QA1_STATUS").equals("B") ? "checked" : "")%> onclick="javascript:checkOne('st_es_qa1_status',1)">반려
			<% }else { %>
			                  <input id="check" type="checkbox" name="st_es_qa1_status0" value="Y" <%=(formData.get("ES_QA1_STATUS").equals("Y") ? "checked" : "")%> disabled>확인
			                  &nbsp;&nbsp;
			                  <input id="check" type="checkbox" name="st_es_qa1_status1" value="B" <%=(formData.get("ES_QA1_STATUS").equals("B") ? "checked" : "")%> disabled>반려
			<% } %>
			                </td>
			                <td>&nbsp;
			<% if("1".equals(userRole.get("P004")) && formData.get("RECV_FLAG").equals("IG") && formData.get("MM_STATUS").equals("ED")&& formData.get("ES_QA1_STATUS").equals("N")) { %>
			
			                  <textarea rows="3" name="st_es_qa1_remark" style="padding:3px;width:97%;ime-mode:active" maxlength="200"><%=formData.get("ES_QA1_REMARK")%></textarea>
			<% }else { %>
			
			                  <textarea rows="3" name="st_es_qa1_remark" style="padding:3px;width:97%;ime-mode:active" READONLY><%=formData.get("ES_QA1_REMARK")%></textarea>
			<% } %>
			
			                </td>
			        </tr>
					
			<tr >
			          <th align="right">가공팀</th>
			                <td width="23%" style="padding-left:4px">
			<% if("1".equals(userRole.get("P006")) && formData.get("RECV_FLAG").equals("IG") && formData.get("MM_STATUS").equals("ED")&& formData.get("ES_PD_STATUS").equals("N")) { %>
			                  <input id="check" type="checkbox" name="st_es_pd_status0" value="Y" <%=(formData.get("ES_PD_STATUS").equals("Y") ? "checked" : "")%> onclick="javascript:checkOne('st_es_pd_status',0)">확인
			                  &nbsp;&nbsp;
			                  <input id="check" type="checkbox" name="st_es_pd_status1" value="B" <%=(formData.get("ES_PD_STATUS").equals("B") ? "checked" : "")%> onclick="javascript:checkOne('st_es_pd_status',1)">반려
			<% }else { %>
			                  <input id="check" type="checkbox" name="st_es_pd_status0" value="Y" <%=(formData.get("ES_PD_STATUS").equals("Y") ? "checked" : "")%> disabled>확인
			                  &nbsp;&nbsp;
			                  <input id="check" type="checkbox" name="st_es_pd_status1" value="B" <%=(formData.get("ES_PD_STATUS").equals("B") ? "checked" : "")%> disabled>반려
			<% } %>
			                </td>
			                <td>&nbsp;
			<% if("1".equals(userRole.get("P006")) && formData.get("RECV_FLAG").equals("IG") && formData.get("MM_STATUS").equals("ED") && formData.get("ES_PD_STATUS").equals("N")) { %>
			
			                  <textarea rows="3" name="st_es_pd_remark" style="padding:3px;width:97%;ime-mode:active" maxlength="200"><%=formData.get("ES_PD_REMARK")%></textarea>
			<% }else { %>
			
			                  <textarea rows="3" name="st_es_pd_remark" style="padding:3px;width:97%;ime-mode:active" READONLY><%=formData.get("ES_PD_REMARK")%></textarea>
			<% } %>
			
			                </td>
			        </tr>
			
			
			<tr >
			          <th align="right">영업관리팀</th>
			                <td width="23%" style="padding-left:4px">
			<% if("1".equals(userRole.get("P005")) && formData.get("RECV_FLAG").equals("IG") && formData.get("MM_STATUS").equals("ED")&& formData.get("ES_MK_STATUS").equals("N")&& formData.get("PRODUCT_FLAG").equals(userRole.get("JONGJA_GUBUN"))) { %>
			                  <input id="check" type="checkbox" name="st_es_mk_status0" value="Y" <%=(formData.get("ES_MK_STATUS").equals("Y") ? "checked" : "")%> onclick="javascript:checkOne('st_es_mk_status',0)">확인
			                  &nbsp;&nbsp;
			                  <input id="check" type="checkbox" name="st_es_mk_status1" value="B" <%=(formData.get("ES_MK_STATUS").equals("B") ? "checked" : "")%> onclick="javascript:checkOne('st_es_mk_status',1)">반려
			<% }else { %>
			                  <input id="check" type="checkbox" name="st_es_mk_status0" value="Y" <%=(formData.get("ES_MK_STATUS").equals("Y") ? "checked" : "")%> disabled>확인
			                  &nbsp;&nbsp;
			                  <input id="check" type="checkbox" name="st_es_mk_status1" value="B" <%=(formData.get("ES_MK_STATUS").equals("B") ? "checked" : "")%> disabled>반려
			<% } %>
			                </td>
			                <td>&nbsp;
			<% if("1".equals(userRole.get("P005")) && formData.get("RECV_FLAG").equals("IG") && formData.get("MM_STATUS").equals("ED")&& formData.get("ES_MK_STATUS").equals("N")&& formData.get("PRODUCT_FLAG").equals("H1")) { %>
			                  <textarea rows="3" name="st_es_mk_remark" style="padding:3px;width:97%;ime-mode:active" maxlength="200"><%=formData.get("ES_MK_REMARK")%></textarea>
			<% }else if("1".equals(userRole.get("P005")) && formData.get("RECV_FLAG").equals("IG") && formData.get("MM_STATUS").equals("ED")&& formData.get("ES_MK_STATUS").equals("N")&& formData.get("PRODUCT_FLAG").equals("H2")) { %>
			                  <textarea rows="3" name="st_es_mk_remark" style="padding:3px;width:97%;ime-mode:active" maxlength="200"><%=formData.get("ES_MK_REMARK")%></textarea>
			<% }else if("1".equals(userRole.get("P005")) && formData.get("RECV_FLAG").equals("IG") && formData.get("MM_STATUS").equals("ED")&& formData.get("ES_MK_STATUS").equals("N")&& formData.get("PRODUCT_FLAG").equals("D1")) { %>
			                  <textarea rows="3" name="st_es_mk_remark" style="padding:3px;width:97%;ime-mode:active" maxlength="200"><%=formData.get("ES_MK_REMARK")%></textarea>
			<% }else { %>
			
			                  <textarea rows="3" name="st_es_mk_remark" style="padding:3px;width:97%;ime-mode:active" READONLY><%=formData.get("ES_MK_REMARK")%></textarea>
			<% } %>
			
			                </td>
			        </tr>
			        			
			
			        <tr >
			          <th colspan="2" align="right">최종확인(가공팀)&nbsp;</th>
			                <td width="23%" style="padding-left:4px">
			<% 
				//승인된 사용자.
				if("1".equals(userRole.get("P007"))	&& formData.get("ES_MK1_STATUS").equals("Y") && formData.get("ES_PD1_STATUS").equals("Y") && formData.get("ES_QA1_STATUS").equals("Y") && formData.get("ES_MK_STATUS").equals("Y") && formData.get("ES_PD_STATUS").equals("Y") && formData.get("ES_FI_STATUS").equals("N")&& formData.get("RECV_FLAG").equals("IG")) { 
			%>
			                  <input id="check" type="checkbox" name="st_es_fi_status0" value="Y" <%=(formData.get("ES_FI_STATUS").equals("Y") ? "checked" : "")%> onclick="javascript:checkOne('st_es_fi_status',0)">확인
			                  &nbsp;&nbsp;
			                  <input id="check" type="checkbox" name="st_es_fi_status1" value="B" <%=(formData.get("ES_FI_STATUS").equals("B") ? "checked" : "")%> onclick="javascript:checkOne('st_es_fi_status',1)">반려
			<% }else { %>
			                  <input id="check" type="checkbox" name="st_es_fi_status0" value="Y" <%=(formData.get("ES_FI_STATUS").equals("Y") ? "checked" : "")%> disabled>확인
			                  &nbsp;&nbsp;
			                  <input id="check" type="checkbox" name="st_es_fi_status1" value="B" <%=(formData.get("ES_FI_STATUS").equals("B") ? "checked" : "")%> disabled>반려
			<% } %>
			                </td>
			                <td>&nbsp;
			<% 
				//승인된 사용자.
				if("1".equals(userRole.get("P007"))	&& formData.get("ES_MK1_STATUS").equals("Y") && formData.get("ES_PD1_STATUS").equals("Y") && formData.get("ES_QA1_STATUS").equals("Y") && formData.get("ES_MK_STATUS").equals("Y") && formData.get("ES_PD_STATUS").equals("Y") && formData.get("ES_FI_STATUS").equals("N")&& formData.get("RECV_FLAG").equals("IG")) { 
			%>
			
			                  <textarea rows="3" name="st_es_fi_remark" style="padding:3px;width:97%;ime-mode:active" maxlength="200"><%=formData.get("ES_FI_REMARK")%></textarea>
			<% }else { %>
			
			                  <textarea rows="3" name="st_es_fi_remark" style="padding:3px;width:97%;ime-mode:active" READONLY><%=formData.get("ES_FI_REMARK")%></textarea>
			<% } %>
			
			                </td>
			        </tr>
                </tbody>
            </table>


 			<!--버튼영역-->
               <div class="btnArea">
  				<span class="fr">
				<% 
					//승인된 사용자.
					if("1".equals(userRole.get("P007"))	&& formData.get("ES_MK1_STATUS").equals("Y") && formData.get("ES_PD1_STATUS").equals("Y") && formData.get("ES_QA1_STATUS").equals("Y") && formData.get("ES_MK_STATUS").equals("Y") && formData.get("ES_PD_STATUS").equals("Y") && formData.get("RECV_FLAG").equals("IG")) { 
				%>
				                 <span class="btn_02 mr04"><a href="javaScript:doAction('setBuyerDongBuOrderPackingSaveEsFi','GB');">저장</a></span>
				<!--최종확인END-->
				<!--디자인START-->
				<% }else if("1".equals(userRole.get("P001")) && formData.get("RECV_FLAG").equals("NW")){ %>
				                  <span class="btn_02 mr04"><a href="javaScript:doAction('setBuyerDongBuOrderPackingSaveMM','IG');">저장</a></span>
				<!--디자인END-->
				
				<!--START작물담당-->
				<% }else if("1".equals(userRole.get("P002")) && formData.get("RECV_FLAG").equals("IG") && formData.get("MM_STATUS").equals("ED")&& (formData.get("ITEM_NO").equals("A01") ||formData.get("ITEM_NO").equals("A02") ||formData.get("ITEM_NO").equals("A03") ||formData.get("ITEM_NO").equals("A04") ||formData.get("ITEM_NO").equals("A05"))){ %>
				                  <span class="btn_02 mr04"><a href="javaScript:doAction('setBuyerDongBuOrderPackingSaveEsMk1','GB');">저장</a></span>
				<% }else if("1".equals(userRole.get("P002")) && formData.get("RECV_FLAG").equals("IG") && formData.get("MM_STATUS").equals("ED") && (formData.get("ITEM_NO").equals("B01") ||formData.get("ITEM_NO").equals("B02") ||formData.get("ITEM_NO").equals("B03") ||formData.get("ITEM_NO").equals("B04") ||formData.get("ITEM_NO").equals("B05")||formData.get("ITEM_NO").equals("B06"))){ %>
				                  <span class="btn_02 mr04"><a href="javaScript:doAction('setBuyerDongBuOrderPackingSaveEsMk1','GB');">저장</a></span>
				<% }else if("1".equals(userRole.get("P002")) && formData.get("RECV_FLAG").equals("IG") && formData.get("MM_STATUS").equals("ED") && (formData.get("ITEM_NO").equals("C01") ||formData.get("ITEM_NO").equals("C02") ||formData.get("ITEM_NO").equals("C03") ||formData.get("ITEM_NO").equals("C04") ||formData.get("ITEM_NO").equals("C05")||formData.get("ITEM_NO").equals("C06")||formData.get("ITEM_NO").equals("C07"))){ %>
				                  <span class="btn_02 mr04"><a href="javaScript:doAction('setBuyerDongBuOrderPackingSaveEsMk1','GB');">저장</a></span>
				<% }else if("1".equals(userRole.get("P002")) && formData.get("RECV_FLAG").equals("IG") && formData.get("MM_STATUS").equals("ED") && (formData.get("ITEM_NO").equals("D01") ||formData.get("ITEM_NO").equals("D02") ||formData.get("ITEM_NO").equals("D03") ||formData.get("ITEM_NO").equals("D04"))){ %>
				                  <span class="btn_02 mr04"><a href="javaScript:doAction('setBuyerDongBuOrderPackingSaveEsMk1','GB');">저장</a></span>
				<!--작물담당END-->
				<!--START영업담당-->
				<% }else if("1".equals(userRole.get("P005")) && formData.get("RECV_FLAG").equals("IG") && formData.get("MM_STATUS").equals("ED")&& formData.get("PRODUCT_FLAG").equals("H1")) { %>
				                  <span class="btn_02 mr04"><a href="javaScript:doAction('setBuyerDongBuOrderPackingSaveEsMk','GB');">저장</a></span>
				<% }else if("1".equals(userRole.get("P005")) && formData.get("RECV_FLAG").equals("IG") && formData.get("MM_STATUS").equals("ED")&& formData.get("PRODUCT_FLAG").equals("H2")) { %>
				                  <span class="btn_02 mr04"><a href="javaScript:doAction('setBuyerDongBuOrderPackingSaveEsMk','GB');">저장</a></span>
				<% }else if("1".equals(userRole.get("P005")) && formData.get("RECV_FLAG").equals("IG") && formData.get("MM_STATUS").equals("ED")&& formData.get("PRODUCT_FLAG").equals("D1")) { %>
				                  <span class="btn_02 mr04"><a href="javaScript:doAction('setBuyerDongBuOrderPackingSaveEsMk','GB');">저장</a></span>
				<!--영업담당END-->
				<!--START등록문안담당-->
				<% }else if(
				"1".equals(userRole.get("P003"))
								&& formData.get("RECV_FLAG").equals("IG") && formData.get("MM_STATUS").equals("ED")) { %>
				                  <span class="btn_02 mr04"><a href="javaScript:doAction('setBuyerDongBuOrderPackingSaveEsPd1','GB');">저장</a></span>
				<!--등록문안담당END-->
				<!--START가공담당-->
				<% }else if("1".equals(userRole.get("P006")) && formData.get("RECV_FLAG").equals("IG") && formData.get("MM_STATUS").equals("ED")) { %>
				                  <span class="btn_02 mr04"><a href="javaScript:doAction('setBuyerDongBuOrderPackingSaveEsPd','GB');">저장</a></span>
				<!--가공담당END-->
				<!--START사진기획담당-->
				<% }else if("1".equals(userRole.get("P004")) && formData.get("RECV_FLAG").equals("IG") && formData.get("MM_STATUS").equals("ED")) { %>
				                  <span class="btn_02 mr04"><a href="javaScript:doAction('setBuyerDongBuOrderPackingSaveEsQa1','GB');">저장</a></span>
				<!--사진기획담당END-->
				<% } %>
  				</span>
  			 </div>
			      
    </div>        
</div>
<%}%>   
</form>

	<form name="processForm" id="processForm"  method="post">	
		<input type="hidden" name="s_SAVENAME" id="s_SAVENAME" value="" />
		<input type="hidden" name="buyer" id="buyer" value="${sessionInfo.comCode}">
		<input type="hidden" name="gubun" id="gubun" value="" />
		<div id="process">
		</div>
	</form>
 
</body>
</html>
