<%--
**********************************************
* 메뉴 : 
* 화면 : 분할납품 계획입력
* 기능 : 분할납품 계획을 입력하는 화면
* 프로그램 ID : PG_07_A_001_02
* 담당자 : 개발3 ( 설계 : 김지현 )
* 착수일 : 2014-
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8"	pageEncoding="utf-8" isELIgnored="false"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="java.util.Vector"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../include/head_v2.jspf"  %>
 

<%
	//String cur_date = CommonUtil.getCurrentDay_Time("yyMMdd"); // 현재날짜       
	
	//List<Map<String,String>> _dataList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된 결과
	
	String user_id			= CommonUtil.nvl((String) request.getParameter("user_id"));
	String kep_id			= CommonUtil.nvl((String) request.getParameter("kep_id"));
	
	if(user_id.equals("")){
		user_id = _sessionInfo.getUserId();
	}
			
	String buyer			= CommonUtil.nvl((String) request.getParameter("st_buyer"));
	String inv_no 			= CommonUtil.nvl((String) request.getParameter("st_inv_no"));
	String inv_seq			= CommonUtil.nvl((String) request.getParameter("st_inv_seq"));
	String seller			    = CommonUtil.nvl((String) request.getParameter("st_seller"));
	String item_qty	    = CommonUtil.nvl((String) request.getParameter("st_item_qty"));
	String buyer_item_no			= CommonUtil.nvl((String) request.getParameter("st_buyer_item_no"));
	String description			= CommonUtil.nvl((String) request.getParameter("st_description"));
	String po_no			= CommonUtil.nvl((String) request.getParameter("st_po_no"));
	String po_seq			= CommonUtil.nvl((String) request.getParameter("st_po_seq"));
	
	
	//조회결과 - 상세 리스트
	@SuppressWarnings (value="unchecked")
	List<Map<String, String>> _data = (List<Map<String, String>>) request.getAttribute("data"); 
	Map<String,String> _rowData = null;

	
	int rec_cnt = 0;
	int page_display_cnt = 0;

	
	
//	KRCOWA0001@@PO14003786@@000001@@1@@20140619@@1@@Y@@KRKORE0001@@KEPSE02@@@@20140619@@20140301^||^
%>

<script language="javascript">
//<!--

var btnEvent = "";
var but1text = "확인";
var but1func = "javascript:closePopText2(); return false;";
var but1funcSearch = "javascript:thisPopClose(); return false;";
var but1width = "120px";

function kep_onload_view(){
			setQuery();
}

function setQuery()
{   
	  $('#sellerMpIvKtagPlanEntryPop').attr("action", "/mpiv/getsellerMpIvKtagPlanEntryPop.do").submit();        
}
var selObj;

function rowSelect(obj){
	
	var idx = obj.index();
	
	$("#tblData tr").each(function (index){
		$(this).removeClass("aback");
	});
	
	$("tr[name=rowData]").eq(idx).addClass("aback");
}

//납품수량 체크
function checkCdQty(num){
    
    var cd_qty = $("#cd_qty"+num).val();
    
    if( !isEmpty(cd_qty) && (!kepIsNumber("cd_qty"+num) || cd_qty == "0")){
//     	alert("납품수량에 1 이상의 숫자를 입력해 주십시요");
    	var text = "납품수량에 1 이상의 숫자를 입력해주세요.";
		openLayerPopText2(text,but1text,but1func,but1width);
    	
    	$("#cd_qty"+num).val("");
    	$("#cd_qty"+num).focus();
    	
    	return;
    }
}
//행추가
function addRow(){
	
	var trCnt = $("#tblData tr").length;
	var seq = trCnt+1;
	var x = seq-1;
	
	var rowData	 = "<tr> ";
	rowData		+= "	<td>"+seq+"</td>";
	rowData		+= "	<td>";
	rowData		+= "	<%=description%>	";
	rowData 	+= "	</td>";
	rowData		+= "	<td>";
	rowData		+= "		<input type='text'   name='cd_qty' id='cd_qty"+x+"' onChange = 'javascript:checkCdQty("+x+")' value='' class='input30'  style='width:90%;  text-align:right'/>";
	rowData 	+= "	</td>";
	rowData		+= "	<td align='center'><button class='WasteBasket_Outline' onclick='javascript:delRow(this);return false;'>  </button></td>"
	rowData 	+= "</tr>";
	
	$("#tblData").append(rowData);
}

function setKtagPlanEntry(){
    var buyer           = "<%=buyer%>";
    var inv_no           = "<%=inv_no%>";
    var inv_seq          = "<%=inv_seq%>";
    var buyer_item_no          = "<%=buyer_item_no%>";
    var item_qty          = "<%=item_qty%>";
    var user_id         = "<%=user_id%>";
    
    var kep_id = "<%=kep_id%>";
    
    var query = "";
    

    var sumcd_qty       = 0;
	
	var trCnt = $("#tblData").children("tr").length;
	
    for(i = 0 ; i < trCnt ; i++){
    	
    	var cd_qty  = $("input[name='cd_qty']").eq(i).val();
  
		
		if(isEmpty(cd_qty)){
// 		    alert( i+1 + "번째 줄에 Ktag분할출력수량을 입력하여 주십시요");
		    var text = (i+1) + "번째 줄에 Ktag분할출력수량을 입력해주세요.";
			openLayerPopText2(text,but1text,but1func,but1width);
		    $("input[name='cd_qty']").eq(i).focus();
		    return;
		}
             

		
		sumcd_qty = eval(sumcd_qty) + eval(cd_qty);
    }
    
    // 납품예정일 중복체크
	
    if(item_qty == sumcd_qty){
    	
    	for(var i =0; i < trCnt; i++) {
    		
			var buyer		= $("input[name='BUYER']").val();
			var inv_no		= $("input[name='INV_NO']").val();
			var inv_seq		= $("input[name='INV_SEQ']").val();
			var buyer_item_no  = $("input[name='BUYER_ITEM_NO']").val();
			var st_seq		= $("input[name='st_seq']").eq(i).val();
			var inv_qty		= $("input[name='INV_QTY']").val();
			var cd_qty		= $("input[name='cd_qty']").eq(i).val();
			var po_no	= $("input[name='PO_NO']").val();
			var po_seq		= $("input[name='PO_SEQ']").val();
			
			query +=  buyer			+ "@@";
			query +=  inv_no	+ "@@";
			query +=  inv_seq		+ "@@";
			query +=  buyer_item_no		+ "@@";
			query +=  st_seq	+ "@@";
			query +=  inv_qty			+ "@@";
			query +=  cd_qty	+ "@@";
			query +=  po_no		+ "@@";
			query +=  po_seq		+ "@@";
			query +=  "^||^" ;

    	}

    document.processForm.st_query.value  = query;    

//     if(!confirm("분할납품계획을 입력하시겠습니까?")) return; 
    var text = "분할납품계획을 입력하시겠습니까?";
	var but1textC = "확인";
	var but2textC = "취소";
	var but1funcC = "javascript:saveSellerMpIvKtagPlanEntryPop(); return false;";
	var but2funcC = "javascript:closePopText1(); return false;";
	var but1widthC = "100px";
	var but2widthC = "100px";
	openLayerPopText(text,but1textC,but2textC,but1funcC,but2funcC,but1widthC,but2widthC);
	
//     kepAjaxFormCall("/mpiv/saveSellerMpIvKtagPlanEntryPop.do","processForm",btnEvent); 

    }else{
//         alert("납품예정수량("+item_qty+")과 Ktag분할출력수량("+sumcd_qty+")이 일치하지 않습니다.\n\n확인 후 다시 입력하여 주십시요.");
        var text = "납품예정수량("+item_qty+")과 Ktag분할출력수량("+sumcd_qty+")이 일치하지 않습니다.</br>확인 후 다시 입력해주세요.";
		openLayerPopText2(text,but1text,but1func,but1width);
    }            
	
}
function saveSellerMpIvKtagPlanEntryPop(){
	closePopText1();
	kepAjaxFormCall("/mpiv/saveSellerMpIvKtagPlanEntryPop.do","processForm",btnEvent); 
}

//행삭제
function delRow(btn){
	
	$(btn).closest("tr").remove();
	
	$("#tblData tr").each(function(i){
		$(this).find("td:eq(0)").text(i+1);
	});
}

function kepAjaxSuccess(pMethod , response){
	var msg = response.msg;
	if(msg=="성공"){
// 		alert("Ktag출력 수량분할이 정상적으로 완료 되었습니다.");
		var text = "Ktag출력 수량분할이 정상적으로 완료 되었습니다.";
		openLayerPopText2(text,but1text,but1funcSearch,but1width);
// 		parent.closePop2();
	}else{
// 		alert("에러");	
		var text = "에러";
		openLayerPopText2(text,but1text,but1func,but1width);
	}
	
	
	return;
}
function thisPopClose(){
	closePopText2();
	parent.closePop2();
}
//-->
</script>
</head>

<body>
<form name="processForm" id="processForm" method="post" >
<input type="hidden" name="BUYER" id="BUYER"  value="<%=buyer%>">
<input type=hidden name="INV_NO" id="INV_NO"  value="<%=inv_no%>">
<input type=hidden name="INV_SEQ" id="INV_SEQ"  value="<%=inv_seq%>">
<input type=hidden name="PO_NO" id="PO_NO"  value="<%=po_no%>">
<input type=hidden name="PO_SEQ" id="PO_SEQ"  value="<%=po_seq%>">
<input type=hidden name="BUYER_ITEM_NO" id="BUYER_ITEM_nO"  value="<%=buyer_item_no%>">
<input type=hidden name="INV_QTY" id="INV_QTY"  value="<%=item_qty%>">
<input type=hidden name="st_query" id="st_query" value ="" >
<!-- HIDDEN -->

<input type="hidden" id="x"  value="">

<!-- HIDDEN -->

	<!--최소 가로길이 400px, 최소 세로길이 400px입니다 / 500*500-->
	<div class="wrapPopup">
  <div class="PopupTit">Ktag분할출력 <span><a href="javascript:parent.closePop2();"><img src="/resources/imgs/Icon_close.png" /></a></span></div>
  <div class="h15"></div>
   <table class="PopupTableTxt" width="600px">
    <colgroup>
      <col width="120px" />
      <col width="180px" />
      <col width="120px" />
      <col width="180px" />
   	</colgroup>
    <tr>
      <th>납품서번호</th>
      <td><%=inv_no%></td>
      <th>납품서항번</th>
      <td><%=po_seq%></td>
    </tr>
    <tr>      
      <th>납품수량</th>
      <td align="right"><%=CommonUtil.formatNumber(item_qty,true,0,3)%></td>
      <th>품명</th>
      <td><%=description%></td>
    </tr>
  </table>  
  <div class="PopupTitSubState" style=" position:relative; width:600px;  ">분할계획
    <button class="ButOutline_Small"  style=" position:absolute; right:0px; top:15px;margin-left:7px" onclick="javascript:addRow(); return false;">행추가</button>
  </div>
  <table class="PopupTableTH"  width="600px">
    <colgroup>
      <col width="50px" />
      <col width="230px" />
      <col width="230px" />
      <col width="90px" />
  	</colgroup>
	<thead>
    <tr>
      <th>번호</th>
      <th>품명</th>
      <th>분할출력수량</th>
      <th>삭제</th>
    </tr>
    </thead>
    <tbody id="tblData">
    <%
						if (_data == null || _data.size() == 0){
							
							int i=0;
%>	
    <tr>
      <td><%=i+1%></td>
      <td><%=description%></td>
      <td><input type="text" name="cd_qty" id="cd_qty<%=i%>" onChange ="javascript:checkCdQty(<%=i%>);" value="" class="input30" style="width:90%;  text-align:right"/></td>
      <td align="center"><button class="WasteBasket_Outline" onclick="javascript:delRow(this); return false;">  </button></td>
    </tr>
    <%							
						}else{
						int recCnt = _data.size();
 
						if(recCnt <= 0){
							recCnt = 1;
						}
							
							for (int i=0; i<recCnt; i++){
								
								Map<String,String> rowData = _data.get(i);
%>
	<tr>
	  <td><%=i+1%></td>
      <td><%=description%></td>
      <td><input type="text" name="cd_qty" id="cd_qty<%=i%>" onChange ="javascript:checkCdQty(<%=i%>);" value = "<%=CommonUtil.nvl(rowData.get("KTAG_QTY"))%>" class="input30" style="width:90%;  text-align:right"/></td>
      <td align="center"><button class="WasteBasket_Outline" onclick="javascript:delRow(this); return false;">  </button></td>
	</tr>
	<%} %>
<%} %>
    </tbody>
  </table>  
  <div class="h30"></div>
  <div class="PopupListBtnBox_Center" style="width:580px">
    <button class="ButPrimary_large" onclick="javascript:setKtagPlanEntry(); return false;">저장</button>
  </div>  
</div><!-- warp 끝-->
</form> 
</body>
</html>
<script>
</script> 
