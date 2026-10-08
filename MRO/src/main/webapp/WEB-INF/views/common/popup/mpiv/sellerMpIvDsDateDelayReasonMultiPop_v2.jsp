<%--
**********************************************
* 메뉴 : 
* 화면 : 납품구분,예정일 일괄등록 팝업
* 기능 : 납품구분,납품예정일 일괄등록하기 위한 팝업
* 프로그램 ID : SU0502007
* 담당자 : 최찬규
* 착수일 : 2025-09-30
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8"	pageEncoding="utf-8" isELIgnored="false"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../include/head_v2.jspf"  %>
<script src="/resources/js/common.js"></script>
<link rel="stylesheet" href="/resources/css/month_popup.css" type="text/css" />

<%
	@SuppressWarnings (value="unchecked")
	String layerPopInfo = CommonUtil.nvl((String)request.getParameter("layerPopInfo"), ""); //이전 페이지에서 넘겨온 대상 품목 데이터들
	if(layerPopInfo == null) layerPopInfo = "[]"; //null 방지
	String info = CommonUtil.nvl((String)request.getParameter("info"), ""); //이전 페이지에서 넘겨온 대상 품목 데이터들
	if(info == null) info = "[]"; //null 방지
	
	String st_pop_type           = CommonUtil.nvl((String)request.getParameter("st_pop_type"), "");
	String st_year           = CommonUtil.nvl((String)request.getParameter("st_year"), "");
	String st_month        = CommonUtil.nvl((String)request.getParameter("st_month"), "");
	String st_day     = CommonUtil.nvl((String)request.getParameter("st_day"), "");
%>
<script type="text/javascript"> 
var mySheet = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
var popupSel = "";
var grbRow = "";

var but1text = "확인";
var but1func = "javascript:closePopText2(); return false;";
var but1funcSearch = "javascript:thisPopClose(); return false;";
var but1width = "120px";

var delayFlag = false;

</script>
<script language="javascript">

function init(){
	var initsheet = {};
	initsheet.Cfg = {MergeSheet:msHeaderOnly,CountPosition: 3,     HeaderRowHeight: 50, DataRowHeight: 30,    Alternate : 0,UseNoDataRow:1};
	initsheet.Cols = [
			 { Align:"Center",	SaveName:"sStatus",				Header:"상태",				Type:"Status",		Width:60,	Edit:false,	EditLen:0,		Hidden:true}
			,{ Align:"Left",	SaveName:"BUYER_NAME",			Header:"고객사명",				Type:"Text",		Width:120,	Edit:false,	EditLen:100,	Hidden:false}
			,{ Align:"Center",	SaveName:"PO_NO",				Header:"발주코드",				Type:"Text",		Width:120,	Edit:false,	EditLen:100,	Hidden:false}
			,{ Align:"Center",	SaveName:"BUYER_ITEM_NO",		Header:"품목코드",				Type:"Text",		Width:150,	Edit:false,	EditLen:100,	Hidden:false}
			,{ Align:"Left",	SaveName:"DESCRIPTION",			Header:"품목명",				Type:"Text",		Width:230,	Edit:false,	EditLen:100,	Hidden:false}
			,{ Align:"Center",	SaveName:"ST_DATE",				Header:"표준납품일",			Type:"Date",		Width:100,	Edit:false,	EditLen:100,	Hidden:false,Format:"yyyy-MM-dd"}
			,{ Align:"Right",	SaveName:"UNIT_PRICE",			Header:"단가",				Type:"Float",		Width:90,	Edit:false,	EditLen:100,	Hidden:false,	Format:"${priceFormat}"}
			,{ Align:"Right",	SaveName:"ITEM_QTY",			Header:"수량",				Type:"Int",			Width:60,	Edit:false,	EditLen:100,	Hidden:false}
			,{ Align:"Center",	SaveName:"UNIT_MEASURE",		Header:"단위",				Type:"Text",		Width:60,	Edit:false,	EditLen:100,	Hidden:false}
			,{ Align:"Right",	SaveName:"ITEM_AMT",			Header:"주문금액",				Type:"Float",		Width:100,	Edit:false,	EditLen:100,	Hidden:false, Format:"${priceFormat}"}
	];
	
	IBS_InitSheet(mySheet, initsheet, pagingMode);
	
	mySheet.SetHeaderBackColor("#f2f7ff");
	mySheet.SetCountFormat(" 총  ROWCOUNT 건 ");

	
	mySheet.SetTheme("DB", "DeepBlue");
	
<%-- 	var infoList = <%=info%>; --%>
	var infoList = <%=layerPopInfo%>;
	
	mySheet.RenderSheet(0);
	for(var i = 0; i<infoList.length; i++){
		
		// 대상품목 그려주기
		var newIndex = 0;
		newIndex = mySheet.DataInsert(-1);
		mySheet.SetCellValue(newIndex, "BUYER_NAME", infoList[i].BUYER_NAME);
		mySheet.SetCellValue(newIndex, "PO_NO", infoList[i].PO_NO);
		mySheet.SetCellValue(newIndex, "BUYER_ITEM_NO", infoList[i].BUYER_ITEM_NO);
		mySheet.SetCellValue(newIndex, "DESCRIPTION", infoList[i].DESCRIPTION);
		mySheet.SetCellValue(newIndex, "ST_DATE", infoList[i].ST_DATE);
		mySheet.SetCellValue(newIndex, "UNIT_PRICE", infoList[i].UNIT_PRICE);
		mySheet.SetCellValue(newIndex, "ITEM_QTY", infoList[i].ITEM_QTY);
		mySheet.SetCellValue(newIndex, "UNIT_MEASURE", infoList[i].UNIT_MEASURE);
		mySheet.SetCellValue(newIndex, "ITEM_AMT", infoList[i].ITEM_AMT);
	}
	mySheet.RenderSheet(1);
	
	
	$("#itemCnt").html("("+mySheet.RowCount()+")");
	
}
//지연사유 저장
function setSave(){
	
	var flag = "one"; //one은 납품구분만, all 은 납품예정일(지연사유) 까지 변경
	var ds_gubun = "전량:1|분할:0"; //전량 체크는 고정
	var delay_reason = "";
	var ds_date = $("#st_ds_date").val().replace(/[/]/gi,"");
	var delay_reason_check = $("input[name='delay_reason']:checked").val();
	var delay_reason_text = $("#delay_reason_text").val();
	if(ds_date == ""){
// 		alert("납품예정일을 입력해주세요.");
		var text = "납품예정일을 입력해주세요.";
		openLayerPopText2(text,but1text,but1func,but1width);
		return;
	}
	if($("#st_ds_date_check").is(":checked")){ //납품예정일
		flag = "all";
		if(ds_date == ""){
// 			alert("납품예정일을 입력해주시기 바랍니다.");
			var text = "납품예정일을 입력해주시기 바랍니다.";
			openLayerPopText2(text,but1text,but1func,but1width);
			return;
		}else{
			if(delayFlag){ //지연건수가 있을 때
				if(delay_reason_check == undefined){
// 					alert("지연사유를 선택해주시기 바랍니다.");
					var text = "지연사유를 선택해주시기 바랍니다.";
					openLayerPopText2(text,but1text,but1func,but1width);
					return;
				}else{
					if(delay_reason_check == "기타"){
						if(delay_reason_text == ""){
// 							alert("지연사유를 입력해주시기 바랍니다.");
							var text = "지연사유를 입력해주시기 바랍니다.";
							openLayerPopText2(text,but1text,but1func,but1width);
							return;
						}else{
							delay_reason = delay_reason_text;
						}
					}else{
						delay_reason = delay_reason_check;
					}
				}
			}
		}
	}else{
// 		alert("납품예정일에 체크해주시기 바랍니다.");
		var text = "납품예정일에 체크해주시기 바랍니다.";
		openLayerPopText2(text,but1text,but1func,but1width);
		return;
	}
	
	parent.setDsDateReason(flag,ds_gubun,ds_date,delay_reason);	
	parent.closePop3();
}

function checkedAllBox(){  
	var check = $("#checkedAll").is(":checked");
	$("#st_ds_date_check").prop("checked",check);
}

//지연사유 클릭에 따른 이벤트
function delayReasonClick(){
	var reason = $("input[name='delay_reason']:checked").val();
	if(reason == "기타"){
		$("#delay_reason_text").prop('readonly',false);
	}else{
		$("#delay_reason_text").val("");
		$("#delay_reason_text").prop('readonly',true);
	}
}

//납품예정일 변경에 따른 이벤트
function delayCheck(){
	delayFlag = false;
	$("#st_ds_date_check").prop("checked",true);
	var st_ds_date = $("#st_ds_date").val().replace(/[/]/gi,"");
	var cur_date = kepGetNowTimeStr("YYYYMMDD","");
	
	if(cur_date > st_ds_date){
// 		alert("납품예정일을 금일 이후 날짜로 선택해주시기 바랍니다.");
		var text = "납품예정일을 금일 이후 날짜로 선택해주시기 바랍니다.";
		openLayerPopText2(text,but1text,but1func,but1width);
		$("#st_ds_date").val("");
		return;
	}
	
	var delayCnt = 0;
	for(var i = 1 ; i<=mySheet.RowCount(); i++){
		if(mySheet.GetCellValue(i,"ST_DATE") < st_ds_date){
			mySheet.SetRowBackColor(i, "#ffcccc"); //해당 row 노란색으로 변경
			delayFlag = true;
			delayCnt ++;
		}else{
			mySheet.SetRowBackColor(i, "");
		}
	}
	
	if(delayFlag){
		$("#delayReason").show();
		$("#delayCnt").html("표준납품일이 지난 등록이 "+delayCnt+"건이 있습니다. 지연사유를 입력해주세요.");
	}else{
		$("#delayReason").hide();
		$("input[name='delay_reason']:checked").prop("checked",false);
		$("#delay_reason_text").val("");
	}
	
}
</script> 
</head>
<!-- <body onLoad="javascript:init();"> -->
<body>
<form name="sellerMpIvDeliveryDelayReasonPop" id="sellerMpIvDeliveryDelayReasonPop" method=post >

<div class="wrapPopup">
  <div class="PopupTit">납품예정일 일괄등록<span><a href="javascript:parent.closePop3();"><img src="/resources/imgs/Icon_close.png" /></a></span></div>
  <div class="h15"></div>
  <div class="Importance_Popup" style="width:780px"><img src="/resources/imgs/Icon_Importance01.png" /> 일괄등록 할 컬럼 값을 입력하시면 선택한 항목에 일괄등록 됩니다.  표준납품일 초과시 지연사유를 입력해주세요. </div>
  <div class="h15"></div>
   <table class="PopTableThTd"  width="800px">
    <colgroup>
      <col width="30px" />
      <col width="180px" />
      <col width="600px" /> 
   	</colgroup>
    <tr>
      <th><label class="CheckMediumLabel" style="margin:5px 0px;"><input type="checkbox" id="checkedAll" name="checkedAll" onclick="javascript:checkedAllBox();"><span class="CheckMediumCustom"  style="margin-right:0px;"></span></label></th>
      <th>일괄등록 컬럼</th>
      <th  align="center">일괄등록 입력값</th>
    </tr>
    <tr>     
      <th><label class="CheckMediumLabel" style="margin:5px 0px;"><input type="checkbox" disabled><span class="CheckMediumCustom"  style="margin-right:0px;"></span></label></th>
      <th>납품구분</th>
      <td><label class="CheckMediumLabel" style="margin:5px 0px;"><input type="checkbox" disabled><span class="CheckMediumCustom"  ></span> 전량</label> 
<!--       <th><label class="CheckMediumLabel" style="margin:5px 0px;"><input type="checkbox" id="st_ds_gubun" onclick="return false;"><span class="CheckMediumCustom"  style="margin-right:0px;"></span></label></th> -->
<!--       <th>납품구분</th> -->
<!--       <td><label class="CheckMediumLabel" style="margin:5px 0px;"><input type="checkbox" id="st_ds_gubun_Y" onclick="return false;"><span class="CheckMediumCustom"  ></span> 전량</label> -->
      <span class="F6495F" style=" float:right;font-size:13px; line-height:32px" >※ 분할납품의 경우 목록에서 선택 후 분할 납품계획을 설정해 주세요.</span></td>
    </tr>
    <tr>      
      <th><label class="CheckMediumLabel" style="margin:5px 0px;"><input type="checkbox" id="st_ds_date_check" name="st_ds_date_check"><span class="CheckMediumCustom"  style="margin-right:0px;"></span></label></th>
      <th>납품예정일</th>
      <td>
      			<div class="datepicker-wrap" style=" width:120px">
                  <div class="date-input" data-datepicker><input type="text" placeholder="" id="st_ds_date" name="st_ds_date" readonly onchange="javascript:delayCheck();"/><span> </span></div>
                </div>
        </td>
    </tr>       
  </table>
  <div id="delayReason" style="display: none;"> 
  <div class="PopupTitSub"><p id="delayCnt">표준납품일이 지난 등록이 0건이 있습니다. 지연사유를 입력해주세요.</p></div>
   <table class="PopTableThLTdL"  width="800px">
    <colgroup>
      <col width="220px" />
      <col width="600px" /> 
   	</colgroup>
    <tr>
      <th>지연사유</th>
      <td style="border-left:1px solid #dedede;" >
        <label class="RadioLargeLabel"><input type="radio" name="delay_reason" value="재고부족" onchange="javascript:delayReasonClick();"><span class="RadioLargeTxt"></span>재고부족</label> 
        <label class="RadioLargeLabel"><input type="radio" name="delay_reason" value="수입지연" onchange="javascript:delayReasonClick();" ><span class="RadioLargeTxt"></span>수입지연</label>
        <label class="RadioLargeLabel"><input type="radio" name="delay_reason" value="제작지연" onchange="javascript:delayReasonClick();" ><span class="RadioLargeTxt"></span>제작지연</label>
        <label class="RadioLargeLabel"><input type="radio" name="delay_reason" value="발주확인지연" onchange="javascript:delayReasonClick();" ><span class="RadioLargeTxt"></span>발주확인지연</label>
        <label class="RadioLargeLabel"><input type="radio" name="delay_reason" value="기타" onchange="javascript:delayReasonClick();" ><span class="RadioLargeTxt"></span>기타</label><br/>
        <input class="input30" style="width:90%; margin-left:10px; margin-top:5px" name="delay_reason_text" id="delay_reason_text" type="text" placeholder="지연사유를 입력해주세요." readonly="readonly"/>      
      </td>
    </tr>       
  </table>
  </div>   
  <div class="PopupTitSub" style="position:relative;width:800px;">대상품목
    <p style="display:inline-block; margin-left:5px" id="itemCnt"></p> 
      <span style=" position:absolute; right:0px; font-size:13px">지연품목은 컬러로 표기됩니다.</span>
  </div>
  <div class="IBSheetTablePopup" style="width:800px" id="testCheck">
    <script type="text/javascript" defer>
		createIBSheet("mySheet", "", "100%");
    </script>
  </div>  
  
  <div class="h30"></div>
  <div class="PopupListBtnBox_Center" style="width:800px">
    <button class="ButQuaternary_large" onclick="javascript:parent.closePop3();">취소</button>
    <button class="ButPrimary_large" onclick="javascript:setSave(); return false;" >저장</button>
  </div>  
</div><!-- warp 끝-->
</form>
</body>
</html>
