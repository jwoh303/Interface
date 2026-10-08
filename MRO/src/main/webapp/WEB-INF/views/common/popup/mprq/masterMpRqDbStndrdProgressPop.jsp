<%--
**********************************************
* 메뉴 : 견적관리 > 견적의뢰접수 > 
* 화면 : DB표준화 진행
* 기능 : 고객으로부터 견적의뢰받은 상품에 대해 DB표준화 작업을 하는 팝업
* 프로그램 ID : PG_04_M_003_02
* 담당자 : 김영미 ( 설계 : 권우재 )
* 착수일 : 2014-05-20
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
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
</head>
<%
SessionInfo sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
String st_buyer_code = CommonUtil.nvl((String) request.getParameter("buyer_code"),"");
String st_quotation_no = CommonUtil.nvl((String) request.getParameter("quotation_no"),"");
String st_quotation_seq = CommonUtil.nvl((String) request.getParameter("quotation_seq"),"");
String st_revision = CommonUtil.nvl((String) request.getParameter("revision"),"");
String st_cms_categ_id = CommonUtil.nvl((String) request.getParameter("cms_categ_id"),"");
String st_description = CommonUtil.nvl((String) request.getParameter("description"),"");
String st_description_eng = CommonUtil.nvl((String) request.getParameter("description_eng"),"");
String st_kep_specification = CommonUtil.nvl((String) request.getParameter("kep_specification"),"");
String st_specification = CommonUtil.nvl((String) request.getParameter("specification"),"");
String st_specification_eng = CommonUtil.nvl((String) request.getParameter("specification_eng"),"");
String st_unit_measure = CommonUtil.nvl((String) request.getParameter("unit_measure"),"");
String st_maker_code = CommonUtil.nvl((String) request.getParameter("maker_code"),"");
String st_maker_name = CommonUtil.nvl((String) request.getParameter("maker_name"),"");
String st_origin_code= CommonUtil.nvl((String) request.getParameter("origin_code"),"");
String st_origin_name = CommonUtil.nvl((String) request.getParameter("origin_name"),"");
String st_imgfile_name = CommonUtil.nvl((String) request.getParameter("imgfile_name"),"");
String st_imgfile_dir = CommonUtil.nvl((String) request.getParameter("imgfile_dir"),"");
String st_item_detail_desc = CommonUtil.nvl((String) request.getParameter("item_detail_desc"),"");
String st_sg_id = CommonUtil.nvl((String) request.getParameter("sg_id"),"");
String st_attb1_nm = CommonUtil.nvl((String) request.getParameter("attb1_nm"),"");
String st_attb2_nm = CommonUtil.nvl((String) request.getParameter("attb2_nm"),"");
String st_attb3_nm = CommonUtil.nvl((String) request.getParameter("attb3_nm"),"");
String st_attb4_nm = CommonUtil.nvl((String) request.getParameter("attb4_nm"),"");
String st_attb5_nm = CommonUtil.nvl((String) request.getParameter("attb5_nm"),"");
String st_attb6_nm = CommonUtil.nvl((String) request.getParameter("attb6_nm"),"");
String st_attb7_nm = CommonUtil.nvl((String) request.getParameter("attb7_nm"),"");
String st_attb8_nm = CommonUtil.nvl((String) request.getParameter("attb8_nm"),"");
String st_attb9_nm = CommonUtil.nvl((String) request.getParameter("attb9_nm"),"");
String st_attb10_nm = CommonUtil.nvl((String) request.getParameter("attb10_nm"),"");
String st_attb11_nm = CommonUtil.nvl((String) request.getParameter("attb11_nm"),"");
String st_attb12_nm = CommonUtil.nvl((String) request.getParameter("attb12_nm"),"");
String st_attb13_nm = CommonUtil.nvl((String) request.getParameter("attb13_nm"),"");
String st_attb14_nm = CommonUtil.nvl((String) request.getParameter("attb14_nm"),"");
String st_attb15_nm = CommonUtil.nvl((String) request.getParameter("attb15_nm"),"");
String st_attb16_nm = CommonUtil.nvl((String) request.getParameter("attb16_nm"),"");
String st_attb17_nm = CommonUtil.nvl((String) request.getParameter("attb17_nm"),"");
String st_attb18_nm = CommonUtil.nvl((String) request.getParameter("attb18_nm"),"");
String st_attb19_nm = CommonUtil.nvl((String) request.getParameter("attb19_nm"),"");
String st_attb20_nm = CommonUtil.nvl((String) request.getParameter("attb20_nm"),"");
String st_spec_yn = CommonUtil.nvl((String) request.getParameter("st_spec_yn"),"");
String st_user_dept = sessionInfo.getDepartment();
String st_authority = "N";
String st_maker_part_no = CommonUtil.nvl((String) request.getParameter("maker_part_no"),"");
if(st_user_dept.equals("093"))
	st_authority = "Y";

//p04404105 품명규격 영문 필수 고객사 SLOGIC 20171016 by HSJ
boolean p04404105 = CommonUtil.getSpecialCheckReturn(st_buyer_code,"P04-4041-05");

//표준화 특이사항, MOQ설정여부 비고 표기
String getCodeCLRMText = CommonUtil.getCode2TextReturn("CLRM",st_buyer_code,"KRKORE0001","TEXT1");
String getCodeMOQTText = CommonUtil.getCode2TextReturn("MOQT",st_buyer_code,"KRKORE0001","TEXT1");

//p04404110 단위 변경 불가 고객사
boolean p04404110 = CommonUtil.getSpecialCheckReturn(st_buyer_code,"P04-4041-10");
%>
<script>
var popupSel = "";
var grbRow;
var flag = "N";
//시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	//콤보데이터 셋팅		
	kepAjaxCommonQueryIdCombo('st_unit_measure','getBuyerUnitMeasureInfo','SEL',"<%=st_unit_measure%>","<%=st_buyer_code%>");
	
	var description = "<%=st_description%>";
	$('#st_description').val(unescape(description));
	var kep_specification = "<%=st_kep_specification%>";
	$('#st_kep_specification').val(unescape(kep_specification));
	var specification = "<%=st_specification%>";
	$('#st_specification').val(unescape(specification));
	$('#st_temp_specification').val(unescape(specification));
	
	var description_eng = "<%=st_description_eng%>";
	$('#st_description_eng').val(unescape(description_eng));
	var specification_eng = "<%=st_specification_eng%>";
	$('#st_specification_eng').val(unescape(specification_eng));
	
	var maker_part_no = "<%=st_maker_part_no%>";
	$('#st_rpa_model_no').val(unescape(maker_part_no));
	
	var attb1_nm = "<%=st_attb1_nm%>";
	var attb2_nm = "<%=st_attb2_nm%>";
	var attb3_nm = "<%=st_attb3_nm%>";
	var attb4_nm = "<%=st_attb4_nm%>";
	var attb5_nm = "<%=st_attb5_nm%>";
	var attb6_nm = "<%=st_attb6_nm%>";
	var attb7_nm = "<%=st_attb7_nm%>";
	var attb8_nm = "<%=st_attb8_nm%>";
	var attb9_nm = "<%=st_attb9_nm%>";
	var attb10_nm = "<%=st_attb10_nm%>";
	var attb11_nm = "<%=st_attb11_nm%>";
	var attb12_nm = "<%=st_attb12_nm%>";
	var attb13_nm = "<%=st_attb13_nm%>";
	var attb14_nm = "<%=st_attb14_nm%>";
	var attb15_nm = "<%=st_attb15_nm%>";
	var attb16_nm = "<%=st_attb16_nm%>";
	var attb17_nm = "<%=st_attb17_nm%>";
	var attb18_nm = "<%=st_attb18_nm%>";
	var attb19_nm = "<%=st_attb19_nm%>";
	var attb20_nm = "<%=st_attb20_nm%>";
	
	$('#st_attb1_nm').val(unescape(attb1_nm));
	$('#st_attb2_nm').val(unescape(attb2_nm));
	$('#st_attb3_nm').val(unescape(attb3_nm));
	$('#st_attb4_nm').val(unescape(attb4_nm));
	$('#st_attb5_nm').val(unescape(attb5_nm));
	$('#st_attb6_nm').val(unescape(attb6_nm));
	$('#st_attb7_nm').val(unescape(attb7_nm));
	$('#st_attb8_nm').val(unescape(attb8_nm));
	$('#st_attb9_nm').val(unescape(attb9_nm));
	$('#st_attb10_nm').val(unescape(attb10_nm));
	$('#st_attb11_nm').val(unescape(attb11_nm));
	$('#st_attb12_nm').val(unescape(attb12_nm));
	$('#st_attb13_nm').val(unescape(attb13_nm));
	$('#st_attb14_nm').val(unescape(attb14_nm));
	$('#st_attb15_nm').val(unescape(attb15_nm));
	$('#st_attb16_nm').val(unescape(attb16_nm));
	$('#st_attb17_nm').val(unescape(attb17_nm));
	$('#st_attb18_nm').val(unescape(attb18_nm));
	$('#st_attb19_nm').val(unescape(attb19_nm));
	$('#st_attb20_nm').val(unescape(attb20_nm));
	
	kepSearch();
}

var st;
var mt;
//기능함수
function doAction(str) {
	st = new Date();
	switch (str) {
		case "search": //조회
			current_page = -1;
			kepSearch();   
			break;
		case "reload":
			kepReload('searchCondition');
			mySheet.RemoveAll();
			break;
	}

}

//팝업함수호출
function doPop(str) {
	popupSel = str;
	
	switch (str) {
		case "maker": // 제조사
			popupSel = "maker";
			var st_del_name = $('#st_maker_name').val();
			var st_buyer_code = $('#st_buyer_code').val();
			openSearchPopup("/common/agentRegMakerCodePop.do", '?st_del_name='+st_del_name+'&st_buyer_code='+st_buyer_code, "500,500,no");
			break;
		case "origin": // 원산지
			popupSel = "country";
			openSearchPopup("/common/countryCodePop.do",'',"500,500,no");// 원산지
			break;

	}
}

//콜백함수(파일명은 모두 동일)
function setPopupReturn(value1,value2,value3,value4){
	//팝업 조회후 해당 항목에 값을 셋팅
	if (popupSel == "maker") {	// 제조사
		$("#st_maker_code").val(value1);
		$("#st_maker_name").val(value2);
// 		if (value3 != "Z1" && value3 != ""){
			$("#st_origin_code").val(value3);
			$("#st_origin_name").val(value4);
// 		}

	} else if (popupSel == "country") {	// 원산지
		$("#st_origin_code").val(value1);
		$("#st_origin_name").val(value3);
		
	}
}

function kepSearch()
{
	var strTmp = "";
	$.ajax({
	      type: "POST",
	      dataType:"json",
	      url: "/mprq/getMasterMpRqDbStndrdProgressPop.do",
	      headers: { 'X-Requested-With': 'XMLHttpRequest' },
	      data: { st_cms_categ_id: $("#st_cms_categ_id").val(), st_buyer_code: $("#st_buyer_code").val(), st_quotation_no: $("#st_quotation_no").val(), st_quotation_seq: $("#st_quotation_seq").val(), st_revision: $("#st_revision").val()},
	     async : false,
	     success:function( response ) {  		    	  
		    		var D_CATEG_NAME = $.trim(eval("response.data[0].CATEG_NAME")); 
		    		$("#st_category_name").val(D_CATEG_NAME);
		    		
		    		var D_MAKER_PART_NO = $.trim(eval("response.data[0].MAKER_PART_NO"));
		    		$("#st_rpa_model_no").val(D_MAKER_PART_NO);
		    		
		    		var D_EXIST_DESC = $.trim(eval("response.data[0].EXIST_DESC"));
		    		$("#st_exist_desc").val(D_EXIST_DESC);
		    		var D_EXIST_SPEC = $.trim(eval("response.data[0].EXIST_SPEC"));
		    		$("#st_exist_spec").val(D_EXIST_SPEC);
		    		
		    		var cmsAttrCnt = $.trim(eval("response.data[0].CMSATTRCNT"));// 속성개수
		    		$("#st_cms_cnt").val(cmsAttrCnt);
		    		var lineCnt = $.trim(eval("response.data[0].LINECNT")); // 라인수
		    		var blankFlag = $.trim(eval("response.data[0].BLANKFLAG")); // 빈칸 처리여부 : 속성개수가 홀수 일 경우 빈칸 처리한다.
		    		var cmcFlag = $.trim(eval("response.data[0].CMC_FLAG")); // 물질정보 대상 구분
					var idx1 = 0;
		    		var idx2 = 0;
		    		for( var idx = 0 ; idx < lineCnt ; idx++ ) {
		    			idx1=idx2+1;
		    			idx2=idx1+1;
		    			
						$("#st_name"+idx1).val($.trim(eval("response.data[0].ATTB"+idx1+"_NM")));
						$("#st_name"+idx2).val($.trim(eval("response.data[0].ATTB"+idx2+"_NM")));
						$("#st_flag"+idx1).val($.trim(eval("response.data[0].ATTB"+idx1+"_FLAG")));
						$("#st_flag"+idx2).val($.trim(eval("response.data[0].ATTB"+idx2+"_FLAG")));
						
	    				strTmp += "<tr>";
		    			if($.trim(eval("response.data[0].ATTB"+idx1+"_FLAG")) == "Y"){ // 필수체크
							strTmp += "<th scope=\"row\">"+$.trim(eval("response.data[0].ATTB"+idx1+"_NM"))+"&nbsp;<font color='#FF6600'>*</font>"+"</th>";
		    			} else {
							strTmp += "<th scope=\"row\">"+$.trim(eval("response.data[0].ATTB"+idx1+"_NM"))+"</th>";
		    			}
		    			
							strTmp += "<td>";
							strTmp += "<input type=\"text\" class=\"input_type_text\" style=\"width:95%;cursor:hand; \" id=\"std_attb"+idx1+"_nm\" name=\"std_attb"+idx1+"_nm\"  onChange=\"setAttB(this.value,"+idx1+");\">";
							strTmp += "</td>";
							  
							
							
						if (idx2 > cmsAttrCnt && blankFlag == "Y"){
							strTmp += "<td></td><td></td>";
						}  else {
							if($.trim(eval("response.data[0].ATTB"+idx2+"_FLAG")) == "Y"){ // 필수체크
								strTmp += "<th scope=\"row\">"+$.trim(eval("response.data[0].ATTB"+idx2+"_NM"))+"&nbsp;<font color='#FF6600'>*</font>"+"</th>";
							} else {
								strTmp += "<th scope=\"row\">"+$.trim(eval("response.data[0].ATTB"+idx2+"_NM"))+"</th>";
							}
							
							strTmp += "<td>";
							strTmp += "<input type=\"text\" class=\"input_type_text\" style=\"width:95%;cursor:hand;\" id=\"std_attb"+idx2+"_nm\" name=\"std_attb"+idx2+"_nm\"  onChange=\"setAttB(this.value,"+idx2+");\">";
							strTmp += "</td>";
						}
							
							strTmp += "</tr>";
		    		}
		    		//물질정보 등록 대상일경우 아래 내용 표기.
		    		if(cmcFlag == "Y"){
		    			strTmp +=  "<tr><th scope=\"row\" colspan=4>※ 물질정보 관리 대상에 포함되는 제품이므로, 발주 시 관련 정보를 입력해야 합니다.<br>유해화학물질 포함 여부 확인 <a href=\"http://ncis.nier.go.kr/main.do\" target=\"_blank\"><바로가기></a></th></tr>";	
		    		}
		    		$("#stnd_table").append(strTmp);
		    		
					var idx3 = 0;
		    		var idx4 = 0;
		    		for( var idx = 0 ; idx < lineCnt ; idx++ ) {
		    			idx3=idx4+1;
		    			idx4=idx3+1; 

						$("#std_attb"+idx3+"_nm").val( $("#st_attb"+idx3+"_nm").val());
						$("#std_attb"+idx4+"_nm").val( $("#st_attb"+idx4+"_nm").val());
			 
		    		}
		    		
		      },
		 error:function( response ) {  		    	   
	    	 alert("오류발생하였습니다.");
		      }	
	 }); 
}

// 속성1~20을 hidden에 set
function setAttB(value,idx)
{
	$("#st_attb"+idx+"_nm").val(value);
	setSpecification();
	
}
// 규격(운) set
function setSpecification(){
	var newValue = "";

	for(var k = 1 ; k <= eval($("#st_cms_cnt").val()) ; k++ ) {
		if($("#st_attb"+k+"_nm").val() != ""){
			newValue = newValue + $("#st_attb"+k+"_nm").val() + "; ";
		}
	}
	$("#st_specification").val(newValue.substring(0, newValue.length-2));
}
//확인
function kepConfirm()
{
	if(kepIsEmpty('st_description') ) {
		alert("품목명을 입력하여 주십시오.");
		$("#st_description").focus();
		return ;
	}

	if(kepIsEmpty('st_specification')) {
		alert("규격을 입력하여 주십시오.");
		return ;
	}

	var desc = $("#st_description").val();
	if(desc.search("'") != -1 || desc.search('"') != -1 ) {
		alert("품목명에 \"와 \'는 입력하실 수 없습니다.");
		$("#st_description").focus();
		return ;
	}

	var spec = $("#st_specification").val();
	if(spec.search("'") != -1 || spec.search('"') != -1 ) {
		alert("규격에 \"와 \'는 입력하실 수 없습니다.");
		$("#st_description").focus();
		return ;
	}
	
	var specLen	= kepGetByteLength('st_specification');
	if ( specLen > 2000 )
	{
		alert("현재 입력된 규격은 "+specLen+"바이트 입니다.\n규격은 2000바이트 이상 입력할 수 없습니다.");
		return ;
	}

	if(kepIsEmpty('st_maker_name')) {
		alert("제조사를 입력하여 주십시오.");
		$("#st_maker_name").focus();
		return ;
	}

	if(kepIsEmpty('st_maker_code')) {
		alert("제조사를 재지정하여 주십시오.");
		return ;
	}

	if(kepIsEmpty('st_origin_name')) {
		alert("원산지를 입력하여 주십시오.");
		return ;
	}

	if(kepIsEmpty('st_unit_measure')) {
		alert("단위를 입력하여 주십시오.");
		$("#st_unit_measure").focus();
		return ;
	}

	if ($("#st_spec_yn").val() == "Y") // 규격변경여부(필수 체크)
	{
		for(var k = 1 ; k <= $("#st_cms_cnt").val() ; k++ ) {
			if($("#st_flag"+k).val() == "Y" && kepIsEmpty("st_attb"+k+"_nm")){
				alert($("#st_name"+k).val()  + "(을)를 입력하여 주십시오.");
				return ;
			}
			
			var objLen	= kepGetByteLength("st_attb"+k+"_nm");
			if ( objLen > 300 )
			{
				alert("현재 입력된 "+$("#st_name"+k).val()+"(은)는 "+objLen+"바이트 입니다.\n"+$("#st_name"+k).val()+"(은)는 300바이트 이상 입력할 수 없습니다.");
				return ;
			}
		}
	}
	
	if(<%=p04404105%> == true){
		if(kepIsEmpty('st_description_eng')){
			alert("품목명(영문)을 입력하여 주십시오.");
			$("#st_description_eng").focus();
			return;
		}
		
		if(kepIsEmpty('st_specification_eng')){
			alert("규격(영문)을 입력하여 주십시오.");
			$("#st_specification_eng").focus();
			return;
		}
	}
	
	if(<%=p04404110%> == true){
		<%--disable 된 unit_measure 값 넘기기 위해서--%>
		$('#st_unit_measure').removeAttr('disabled');	
	}
	
	kepAjaxFormCall("/mprq/saveMasterMpRqCmsRecvDate.do","searchCondition", "saveMasterMpRqCmsRecvDate");

}
//ajax 공통 호출후 성공시 처리 함수
function kepAjaxSuccess(pMethod , response) {
// 	품목명, 규격(운), 단위, 제조사ID, 제조사명, 원산지코드, 원산지명, 속성1-20 값, 상세설명, 이미지정보
	var value1 = $("#st_description").val();
	var value2 = $("#st_specification").val();
	var value3 = $("#st_unit_measure").val();
	var value4 = $("#st_maker_code").val();
	var value5 = $("#st_maker_name").val();
	var value6 = $("#st_origin_code").val();
	var value7 = $("#st_origin_name").val();
	var value8 = escape($("#st_attb1_nm").val());
	var value9 = escape($("#st_attb2_nm").val());
	var value10 = escape($("#st_attb3_nm").val());
	var value11 = escape($("#st_attb4_nm").val());
	var value12 = escape($("#st_attb5_nm").val());
	var value13 = escape($("#st_attb6_nm").val());
	var value14 = escape($("#st_attb7_nm").val());
	var value15 = escape($("#st_attb8_nm").val());
	var value16 = escape($("#st_attb9_nm").val());
	var value17 = escape($("#st_attb10_nm").val());
	var value18 = escape($("#st_attb11_nm").val());
	var value19 = escape($("#st_attb12_nm").val());
	var value20 = escape($("#st_attb13_nm").val());
	var value21 = escape($("#st_attb14_nm").val());
	var value22 = escape($("#st_attb15_nm").val());
	var value23 = escape($("#st_attb16_nm").val());
	var value24 = escape($("#st_attb17_nm").val());
	var value25 = escape($("#st_attb18_nm").val());
	var value26 = escape($("#st_attb19_nm").val());
	var value27 = escape($("#st_attb20_nm").val());
	var value28 = $("#st_item_detail_desc").val();
	var value29 = "";
	var value30 = "";
	if (flag == "Y"){
		value29 = $("#st_imgfile_name").val();
		value30 = $("#st_imgfile_dir").val();
	}
	var value31 = $("#st_description_eng").val();
	var value32 = $("#st_specification_eng").val();
	var value33 = $("#st_userNameLoc").val();
	var value34 = $("#st_rpa_model_no").val();
	
 opener.setPopupReturn(value1,value2,value3,value4,value5,value6,value7,value8,value9,value10
		 						,value11,value12,value13,value14,value15,value16,value17,value18,value19,value20
		 						,value21,value22,value23,value24,value25,value26,value27,value28,value29,value30
		 						,value31,value32,value33,value34)
 this.close();
 
}
function  kepAjaxError(pMethod , response) { 	
	alert("오류발생하였습니다.\n\n다시 한 번 시도해 주시기 바랍니다.  "); 
} 
var btnEvent = "";
// 이미지등록
function kepAddImage(){
	var fileName = $("#files").val();
	if (fileName == ""){
		alert("이미지를 선택하세요.");
		return;
	} 	
	
	var dot = fileName.lastIndexOf(".");
	var ext = fileName.substring(dot).toLowerCase();
	if (ext != ".jpg" && ext != ".jpeg" && ext != ".gif" && ext != ".png"){
		alert("이미지 업로드 할 수 없는 확장자 입니다.");
		return;
	}
	flag = "N";
	document.forms.searchCondition.target = "account_work";
	document.forms.searchCondition.method = "post";
	document.forms.searchCondition.action ="/mprq/addDbStndrdPop.do";
	document.forms.searchCondition.submit();
 	
}
 
// 이미지 미리보기
function preview_new(img,the_img,img_no) {
	if (img != ""){
		flag = "Y";
	}
	$("#st_image_no").val(img);
	$("#image1").attr("src","");
	var dest    = document.getElementById("image1");
     dest.src = img;
}


// 규격변경여부
function comboOnchange(){
	for(var k = 1 ; k <= $("#st_cms_cnt").val() ; k++ ) {
		
		if($("#st_spec_yn").val() =="N"){
			if (k == "1"){
				$('#st_temp_specification').val($('#st_specification').val());
			}
			$('#st_specification').val($('#st_kep_specification').val());
			$("#std_attb"+k+"_nm").attr("class", "input_red_text");
			$("#std_attb"+k+"_nm").attr("disabled", true);
			if (k == "1"){
				$("#std_attb"+k+"_nm").val($('#st_kep_specification').val());
			} else {
				$("#std_attb"+k+"_nm").val("");
			}
			
		} else {
			if (k == "1"){
				$('#st_specification').val($('#st_temp_specification').val());
			}
			$("#std_attb"+k+"_nm").attr("class", "input_type_text");
			$("#std_attb"+k+"_nm").attr("disabled", false);
			$("#std_attb"+k+"_nm").val($("#st_attb"+k+"_nm").val());
		}
	}
}

function upSet(docNo){
	var mg_arr = docNo.split("^");
	$("#st_imgfile_dir").val( mg_arr[0]);
	$("#st_imgfile_name").val( mg_arr[1]);
	alert("이미지가 등록/ 수정되었습니다.");
	flag = "Y";
	return;
}
function setImageView(img_dr,img_name){

	if(img_name == "icon_emptyimg.gif"){
		alert("등록된 이미지가 없습니다.");
		return;		
	}else{
		window.open('<%= CommonUtil.getURL(request) %>'+img_dr+ img_name,'catalogImage','status=no,resizable=yes,menubar=no,scrollbars=no,"","",width=550,height=550');	
	}
	
}

// 규격(운) 내용으로 규격(영문) 채우기
function setSpecEng(){
	$('#st_specification_eng').val($('#st_specification').val());
}

</script> 
<body onload="kep_onload_view();">
<iframe name="account_work" id="account_work" style="display:none;" scrolling="no" frameborder="0" width="100%" height="100%"></iframe>
<form name = "searchCondition" id="searchCondition" method = "post" modelAttribute="uploadForm" enctype="multipart/form-data">
	<input type="hidden" id="st_authority"  name="st_authority" value="<%=st_authority%>">
	<input type="hidden" id="USER_ID"  name="USER_ID" value="${sessionInfo.userId}">
	<input type="hidden" id="st_userNameLoc"  name="st_userNameLoc" value="${sessionInfo.userNameLoc}">
	<input type="hidden" id="st_buyer_code"  name="st_buyer_code" value="<%=st_buyer_code%>">
	<input type="hidden" id="st_quotation_no"  name="st_quotation_no" value="<%=st_quotation_no%>">
	<input type="hidden" id="st_quotation_seq"  name="st_quotation_seq" value="<%=st_quotation_seq%>">
	<input type="hidden" id="st_revision"  name="st_revision" value="<%=st_revision%>">
	<input type="hidden" id="st_cms_categ_id"  name="st_cms_categ_id" value="<%=st_cms_categ_id%>">
	<input type="hidden" id="st_sg_id"  name="st_sg_id" value="<%=st_sg_id%>">
	<input type="hidden" id="st_cms_cnt"  name="st_cms_cnt" value="" disabled="disabled">
	<input type="hidden" id="st_attb1_nm"  name="st_attb1_nm" value="">
	<input type="hidden" id="st_attb2_nm"  name="st_attb2_nm" value="">
	<input type="hidden" id="st_attb3_nm"  name="st_attb3_nm" value="">
	<input type="hidden" id="st_attb4_nm"  name="st_attb4_nm" value="">
	<input type="hidden" id="st_attb5_nm"  name="st_attb5_nm" value="">
	<input type="hidden" id="st_attb6_nm"  name="st_attb6_nm" value="">
	<input type="hidden" id="st_attb7_nm"  name="st_attb7_nm" value="">
	<input type="hidden" id="st_attb8_nm"  name="st_attb8_nm" value="">
	<input type="hidden" id="st_attb9_nm"  name="st_attb9_nm" value="">
	<input type="hidden" id="st_attb10_nm"  name="st_attb10_nm" value="">
	<input type="hidden" id="st_attb11_nm"  name="st_attb11_nm" value="">
	<input type="hidden" id="st_attb12_nm"  name="st_attb12_nm" value="">
	<input type="hidden" id="st_attb13_nm"  name="st_attb13_nm" value="">
	<input type="hidden" id="st_attb14_nm"  name="st_attb14_nm" value="">
	<input type="hidden" id="st_attb15_nm"  name="st_attb15_nm" value="">
	<input type="hidden" id="st_attb16_nm"  name="st_attb16_nm" value="">
	<input type="hidden" id="st_attb17_nm"  name="st_attb17_nm" value="">
	<input type="hidden" id="st_attb18_nm"  name="st_attb18_nm" value="">
	<input type="hidden" id="st_attb19_nm"  name="st_attb19_nm" value="">
	<input type="hidden" id="st_attb20_nm"  name="st_attb20_nm" value="">
	
	<input type="hidden" id="st_flag1"  name="st_flag1" value="">
	<input type="hidden" id="st_flag2"  name="st_flag2" value="">
	<input type="hidden" id="st_flag3"  name="st_flag3" value="">
	<input type="hidden" id="st_flag4"  name="st_flag4" value="">
	<input type="hidden" id="st_flag5"  name="st_flag5" value="">
	<input type="hidden" id="st_flag6"  name="st_flag6" value="">
	<input type="hidden" id="st_flag7"  name="st_flag7" value="">
	<input type="hidden" id="st_flag8"  name="st_flag8" value="">
	<input type="hidden" id="st_flag9"  name="st_flag9" value="">
	<input type="hidden" id="st_flag10"  name="st_flag10" value="">
	<input type="hidden" id="st_flag11"  name="st_flag11" value="">
	<input type="hidden" id="st_flag12"  name="st_flag12" value="">
	<input type="hidden" id="st_flag13"  name="st_flag13" value="">
	<input type="hidden" id="st_flag14"  name="st_flag14" value="">
	<input type="hidden" id="st_flag15"  name="st_flag15" value="">
	<input type="hidden" id="st_flag16"  name="st_flag16" value="">
	<input type="hidden" id="st_flag17"  name="st_flag17" value="">
	<input type="hidden" id="st_flag18"  name="st_flag18" value="">
	<input type="hidden" id="st_flag19"  name="st_flag19" value="">
	<input type="hidden" id="st_flag20"  name="st_flag20" value="">
	
	<input type="hidden" id="st_name1"  name="st_name1" value="">
	<input type="hidden" id="st_name2"  name="st_name2" value="">
	<input type="hidden" id="st_name3"  name="st_name3" value="">
	<input type="hidden" id="st_name4"  name="st_name4" value="">
	<input type="hidden" id="st_name5"  name="st_name5" value="">
	<input type="hidden" id="st_name6"  name="st_name6" value="">
	<input type="hidden" id="st_name7"  name="st_name7" value="">
	<input type="hidden" id="st_name8"  name="st_name8" value="">
	<input type="hidden" id="st_name9"  name="st_name9" value="">
	<input type="hidden" id="st_name10"  name="st_name10" value="">
	<input type="hidden" id="st_name11"  name="st_name11" value="">
	<input type="hidden" id="st_name12"  name="st_name12" value="">
	<input type="hidden" id="st_name13"  name="st_name13" value="">
	<input type="hidden" id="st_name14"  name="st_name14" value="">
	<input type="hidden" id="st_name15"  name="st_name15" value="">
	<input type="hidden" id="st_name16"  name="st_name16" value="">
	<input type="hidden" id="st_name17"  name="st_name17" value="">
	<input type="hidden" id="st_name18"  name="st_name18" value="">
	<input type="hidden" id="st_name19"  name="st_name19" value="">
	<input type="hidden" id="st_name20"  name="st_name20" value="">
	<input type="hidden" id="st_attb1_nm"  name="st_attb1_nm" value="">
	
	<input type="hidden" id="st_maker_part_no"  name="st_maker_part_no" value="<%=st_maker_part_no%>">
	
	<div id="popWrapper">
    	<div id="popHeader">
        	<h1 class="title">DB표준화 진행</h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/m_btn_popclose.gif" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer" style="height:662px;">
        
        	<font style="color:red;">※ 고객사 등록여부 및 시장가 조회를 위해 제조사/모델번호를 입력해주세요.</font>
        	
           	<table class="cont_t_list06" style="width:100%" id="stnd_table">
				<caption>DB표준화 진행</caption>
				<colgroup>
					<col width="18%" />
					<col width="32%" />
					<col width="16%" />
					<col width="34%" />
				</colgroup>						
				<tbody>
					<tr>
		                <th scope="row" rowspan="2">이미지</th>
		                <td rowspan="2">
							<%
                                 if (st_imgfile_name == null || st_imgfile_name.equals("null") || st_imgfile_name.equals("") || st_imgfile_name.equals(" ")){
							%>
		                		<img src = "/resources/images/icon_emptyimg.gif"  id="image1" name="image1" width="200" height="200">
							<%
                                 }else{
							%>
									<a href="javascript:setImageView('<%=CommonUtil.realImgS3UploadPath+"/"+st_imgfile_dir+"/"%>','<%=st_imgfile_name%>')" >
                                    	<img src = "<%=CommonUtil.realImgS3UploadPath+"/"+st_imgfile_dir+"/"+st_imgfile_name%>"   id="image1" name = "image1" width="200" height="200" border="0">
                                    </a>
							<%
                                 }
							%>		 		                	
		                	<input type="hidden" name="st_imgfile_dir" id="st_imgfile_dir" value="<%=st_imgfile_dir%>" />
		                	<input type="hidden" name="st_imgfile_name" id="st_imgfile_name" value="<%=st_imgfile_name%>" />
		                	<br>
							<input name="files" id="files" type="file" size="25" onchange="preview_new(this.value,'up_img1');" value="<%=st_imgfile_name %>" style="width:70%;">
							<span class="btn_gray_02 mr04"><a href="javascript:kepAddImage();">등록/수정</a></span>
	                	</td>
	                	<th scope="row">클렌징비고</th>
		                <td>
		                 	<textarea id="st_cleansing_remark" name="st_cleansing_remark" style="width:95%; border:0;" rows="12" readonly><%=getCodeCLRMText%></textarea>
	                	</td>
		            </tr>
		            <tr>
		                <th scope="row">MOQ<br>설정여부</th>
		                <td>
		                	<input type="text" name="st_moq_type" id="st_moq_type" class="input_type_text" title="" style="width:95%; border:0;" value="<%=getCodeMOQTText%>" readonly/> 
	                	</td>
		            </tr>
		            <tr>
		                <th scope="row">품목명(기)</th>
		                <td colspan="3">
							<input type="text" name="st_exist_desc" id="st_exist_desc" class="input_type_text" readonly="readonly" style="width:95%;border:0;" value="" />
	                	</td>
		            </tr>
					<tr>
		                <th scope="row">품목명(운)</th>
		                <td colspan="3">
		                	<input type="text" name="st_description" id="st_description" class="input_type_text" title="" style="width:95%;" value="" /> 
	                	</td>
		            </tr>
		            <tr>
		                <th scope="row">품목명(영문)
					<%if(p04404105 == true){%>
		                <font color="#FF6600">*</font>
					<%}%>
		                </th>
		                <td colspan="3">
		                	<input type="text" name="st_description_eng" id="st_description_eng" class="input_type_text" title="" style="width:95%;" value="" />
	                	</td>
		            </tr>
		            <tr>
		                <th scope="row">제조사 <font color="#FF6600">*</font></th>
      					<td>
      						<input type="text" name="st_maker_name" id="st_maker_name" class="input_type_text" title="" style="width:80%;" value="<%=st_maker_name%>" readonly/>
      						<input type="hidden" name="st_maker_code" id="st_maker_code" value="<%=st_maker_code%>" />
      						<a href="javascript:doPop('maker');"><img src="/resources/images/btn_search03.gif" alt="검색" /></a>
  						</td>
		                <th scope="row">모델번호</th>
		                <td>
		                	<input type="text" name="st_rpa_model_no" id="st_rpa_model_no" class="input_type_text" title="" style="width:95%;" value="<%=st_maker_part_no%>" /> 
	                	</td>
					</tr>
					<tr>
		                <th scope="row">규격(기)</th>
		                <td colspan="3">
							<input type="text" name="st_exist_spec" id="st_exist_spec" class="input_type_text" readonly="readonly" style="width:95%;border:0;" value="" />
	                	</td>
		            </tr>
					<tr>
		                <th scope="row">규격(고)</th>
		                <td colspan="3">
		                	<input type="text" name="st_kep_specification" id="st_kep_specification" class="input_type_text" readonly="readonly" style="width:90%;border:0;" value="" /> 
	                	</td>
		            </tr>
					<tr>
		                <th scope="row">규격(운) <font color="#FF6600">*</font></th>
		                <td colspan="3">
		                	<input type="text" name="st_specification" id="st_specification" class="input_type_text" readonly="readonly" style="width:90%;border:0;" value="" /> 
		                	<input type="hidden" name="st_temp_specification" id="st_temp_specification" class="input_type_text" readonly="readonly" style="width:90%;border:0;" value="" /> 
	                	</td>
		            </tr>
		            <tr>
		                <th scope="row">규격(영문)
					<%if(p04404105 == true){%>
		                <font color="#FF6600">*</font>
					<%}%>
						</th>
		                <td colspan="3">
		                	<input type="text" name="st_specification_eng" id="st_specification_eng" class="input_type_text" title="" style="width:80%;" value="" />
		                	<span class="btn_gray_06"><a href="javascript:setSpecEng();">규격(운) 반영</a></span>
	                	</td>
		            </tr>
					<tr>
		                <th scope="row">원산지 <font color="#FF6600">*</font></th>
      					<td>
      						<input type="text" name="st_origin_name" id="st_origin_name" class="input_type_text" title="" style="width:80%;" value="<%=st_origin_name%>" readonly/>
      						<input type="hidden" name="st_origin_code" id="st_origin_code" value="<%=st_origin_code%>" />
      						<a href="javascript:doPop('origin');"><img src="/resources/images/btn_search03.gif" alt="검색" /></a>
  						</td>
		                <th scope="row">단위 <font color="#FF6600">*</font></th>
      					<td>
      						<label for="b_code" class="hidden">단위</label>
					  			<select name = "st_unit_measure" id="st_unit_measure" style="height:20px" <%if(p04404110){%>disabled<%}%>>
	                           </select>
  						</td>
					</tr>
					<tr>
		                <th scope="row">규격변경여부</th>
		                <td>
		                	<label for="b_code" class="hidden">규격변경여부</label>
					  			<select name = "st_spec_yn" id="st_spec_yn" style="width:100px;;height:20px;" onchange="comboOnchange();" >
					  				<option value = "Y" selected>변경</option>
					  				<option value = "N">미변경</option>
	                           </select> 
	                	</td>
		                <th scope="row">카테고리명</th>
      					<td>
      						<input type="text" name="st_category_name" id="st_category_name" class="input_type_text" readonly="readonly" style="width:90%;border:0;" value="" />
  						</td>
					</tr>
					<tr>
		                <th scope="row">상세설명</th>
		                <td colspan="3">
		                	<textarea rows="3" cols="1" name="st_item_detail_desc" id="st_item_detail_desc" class="input_type_text" style="width:95%;"><%=st_item_detail_desc%></textarea>
	                	</td>
		            </tr>
				</tbody>
			</table>
			
	        <!--버튼영역-->
	        <div class="mr20" style="height:25px;">
	        	<span class="fl">
					<font style="color:red;">※ 기등록 견적은 입력한 품명/규격 등이 반영되지 않습니다.</font>
				</span>
				<span class="fr">
					<span class="btn_02"><a href="javascript:kepConfirm();">저장</a></span>
				</span>
	       </div>
		</div>	
        
    </div>
</form> 
</body>
</html>
