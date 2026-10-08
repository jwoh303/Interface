<%--
**********************************************
* 메뉴 : 
* 화면 : 분할납품 계획 변경
* 기능 : 
* 프로그램 ID : PG_07_M_013_02
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
<style> 
.aback{ background-color:#fff5bf }
</style>
<%@ include file="../../../common/include/head.jspf"  %>

<%
	@SuppressWarnings (value="unchecked")
	List<Map<String,String>> _dataList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된 결과 
	
	String buyer = CommonUtil.nvl((String) request.getParameter("st_buyer"),"");  //  (조회조건)
	String po_no = CommonUtil.nvl((String) request.getParameter("st_po_no"),"");  //  (조회조건)
	String po_seq = CommonUtil.nvl((String) request.getParameter("st_po_seq"),"");  //  (조회조건)
	String rd_date = CommonUtil.nvl((String) request.getParameter("st_rd_date"),"");  //  (조회조건)
	String po_qty = CommonUtil.nvl((String) request.getParameter("st_item_qty"),"");  //  (조회조건)
	
	String seller = CommonUtil.nvl((String) request.getParameter("st_seller"),"");  //  (조회조건)
	String add_user_id = CommonUtil.nvl((String) request.getParameter("st_add_user_id"),"");  //  (조회조건)
	
	String inv_check = "Y";		// 송장이 모두 생성 되었는지 체크하는 변수 , 송장 미생성 목록이 있을시는 저장버튼이 보이도록 한다.
%>

<script type="text/javascript">

function setCdQty(){

	getLastDate(); 

    var buyer           = "<%=buyer%>";
    var po_no           = "<%=po_no%>";
    var po_seq          = "<%=po_seq%>";
    var po_qty          = "<%=po_qty%>";
    var seller          = "<%=seller%>";
    var user_id         = "<%=add_user_id%>";
    var delay_reason    = $("#st_delay_reason").val();
    var max_cd_date     = $("#st_max_cd_date").val();
    var rd_date         = "<%=rd_date%>";

    var query       = "";
    sumcd_qty       = 0;

	var trCnt = $("#tblData").children("tr").length;
	
	for(var i = 0 ; i < trCnt ; i++){

		var cd_date = $("input[name='st_cd_date']").eq(i).val().replace(/[/]/gi,"");
		var cd_qty  = $("input[name='st_cd_qty']").eq(i).val();
		var inv_qty  = $("input[name='st_inv_qty']").eq(i).val();
		
		if(isEmpty(cd_date)){
		    alert( i+1 + "번째 줄에 납품예정일을 입력하여 주십시요");
		    $("#input[name='st_cd_date']").eq(i).focus();
		    return;
		}
		
		if(isEmpty(cd_qty)){
			alert( i+1 + "번째 줄에 납품수량을 입력하여 주십시요");
			$("input[name='st_cd_qty']").eq(i).focus();
			return;
		}

		// 납품예정일 중복체크
		if(!checkSamedate(trCnt)) return;

		query +=  buyer         + "@@";
		query +=  po_no         + "@@";
		query +=  po_seq        + "@@";
		query +=  po_qty        + "@@";
		query +=  cd_date       + "@@";
		query +=  cd_qty        + "@@";
		query +=  "Y"           + "@@"; // DS_FLAG
		query +=  seller        + "@@";
		query +=  user_id       + "@@";
		query +=  delay_reason  + "@@";
		query +=  max_cd_date   + "@@";// ICOMPODT.DS_DATE 에 들어가는 값   , 분할접수일 경우 마지날 납품예정일
		query +=  rd_date       + "@@";             
		query +=  inv_qty             ;
		query +=  "^||^" ;

		sumcd_qty = eval(sumcd_qty) + eval(cd_qty);
	}

    //alert( query );

    if(po_qty == sumcd_qty){

        if(!confirm("납품계획을 변경 하시겠습니까?")) return; 

		$("#st_query").val(query);

        kepAjaxFormCall("/mpiv/saveMasterMpIvDivsnDeliveryPlanAlterPop.do","masterMpIvDivsnDeliveryPlanAlterPop","btnSave");
    	
        /*
        document.forms[0].target = "work";
        document.forms[0].method = "post";
        document.forms[0].action = "/kr/sysop/proxbuy/scm/sysop_proxbuy_agent_sds_change_reg.jsp";
        document.forms[0].submit();     
*/
    }else{
        alert("납품예정수량("+sumcd_qty+")과 발주수량("+po_qty+")이 일치하지 않습니다.\n\n확인 후 다시 입력하여 주십시요.");
    }
}


//ajax 공통 호출후 성공시 처리 함수
function kepAjaxSuccess(pMethod , response){
	var msg = response.msg;
	
	if (isEmpty(msg)){
		alert("납품계획이 정상적으로 저장 되었습니다.");
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
		opener.doAction("search");
		window.close();
	}
	return;
}


//중복되는 납품예정일이 있는지 확인 
function checkSamedate(insert_cnt) {
 var i;    
 for(i=0;i<insert_cnt;i++){
     for(var j=0;j<i;j++){
         
         if((document.forms[0].st_cd_date[i].value != "") && (document.forms[0].st_cd_date[i].value == document.forms[0].st_cd_date[j].value)){
             alert("납품예정일이 중복 되었습니다.\n\n확인 후 다시 입력하여 주십시요.");
             document.forms[0].st_cd_date[i].focus();
             document.forms[0].st_cd_date[i].select();
             return;
         }
     }
 }//end for
 return true;
}


//마지막 날짜 검색...
function getLastDate() {
	
	var cd_date     = "";
	var max_cd_date = "";

	var trCnt = $("#tblData").children("tr").length;
	
	for(var i = 0 ; i < trCnt ; i++){
	
		//$("#input[name='st_cd_date']").eq(i).focus();
		//var cd_date = ($("input[name='st_cd_date']").eq(i).val()).replace(/[/]/gi,"");
		
		if($("input[name='st_cd_date']").eq(i).val().length > 0 && $("input[name='st_cd_qty']").eq(i).val().length > 0){

			cd_date = $("input[name='st_cd_date']").eq(i).val().replace(/[/]/gi,"");

			// 납품예정일 마지막날짜
			if(max_cd_date=="") max_cd_date = cd_date;
			if( eval(cd_date) > eval(max_cd_date)){
				max_cd_date = cd_date;
			}
		}
	}
	$("#st_max_cd_date").val(max_cd_date);
}


function rowSelect(obj){
	var idx = obj.index();
	
	$("#tblData tr").each(function (index){
		$(this).removeClass("aback");
	});
	
	$("tr[name=rowData]").eq(idx).addClass("aback");
}

// 행추가
function addRow(){
	
	var trCnt = $("#tblData").children("tr").length;
	var seq = trCnt+1;
	
	var x = parseInt($("#x").val()) + 1;
	
	var rowData	 = "<tr name='rowData' onClick='javascript:rowSelect($(this));' seq='"+x+"'> ";
	rowData		+= "	<td><span name='st_seq'>"+seq+"</span></td>";
	rowData		+= "	<td>";
	rowData		+= "		<input type='text'   name='st_cd_date' id='st_cd_date"+x+"' class='input_type_text'  size='10'  value='' readonly>";
	rowData 	+= "	</td>";

	rowData		+= "	<td>";
	rowData		+= "		<input type='text'   name='st_cd_qty' id='st_cd_qty"+x+"' class='input_type_text' onChange = 'javascript:checkCdQty("+x+")' class='input_type_text'  style='text-align:right;'>";
	rowData		+= "		<input type='hidden' name='st_inv_qty' id='st_inv_qty"+x+"' value='0' />";
	rowData 	+= "	</td>";

	rowData 	+= "</tr>";
	
	$("#tblData").append(rowData);
	
	$("#x").val(x);
	
	setTimeout(function(){
		// Action after append
		kepSetCalender('st_cd_date'+x, '1', 'Y', x);
	},100);
	
	setSumQty();
}

// 행삭제
function delRow(){
	
	if($("#tblData tr.aback").length <= 0){
		alert("삭제할 행을 선택해 주십시요.");
		return false;
	}
	
	$("#tblData tr").each(function (index){
		if ( $( this ).is(".aback") ) {
			 $( this ).remove();
		}
	});
	
	$("#tblData tr").each(function (index){
		$(this).find("td>span").html(index+1);;
	});
	
	setSumQty();
}

//납품예정일 calender callback event
function calenderChange(dateText,num){
	
	if(isEmpty(dateText)){
		
		var cur_date = kepGetNowTimeStr("YYYYMMDD","");
		$("#st_cd_date"+num).val(kepDateSlashAdd(cur_date));

	} else {
		//var input_date = dateText.replace(/[/]/gi,"");
		
		$("#st_cd_date"+num).val(dateText);
		
		checkInvoice(num);
	}
}

function checkInvoice(seq){
	var inv_qty = $("#st_inv_qty"+seq).val();
	
	if(inv_qty > 0){
		alert("이미 거래명세서를 작성한 목록입니다.\n\n거래명세서 삭제 후 납품계획변경이 가능합니다.");
	}
}

//납품수량 체크
function checkCdQty(num){
    var cd_qty = $("#st_cd_qty"+num).val();
    
	if( !isEmpty(cd_qty) && (!IsNumber1(cd_qty) || (cd_qty == 0)) ){
		alert("납품수량에 1 이상의 숫자를 입력해 주십시요");
		$("#st_cd_qty"+num).val("0");
		setSumQty();
		return;
	}
	
	setSumQty();
	
	
}

function setSumQty(){
	var trCnt = $("#tblData").children("tr").length;
	
	var po_qty = parseInt("<%=po_qty%>");
	var sum_inv_qty = parseInt($("#st_sum_inv_qty").html());
	var sum_sch_qty = 0;
	var sum_res_qty = 0;
	
	//st_sum_sch_qty 예정수량 = 입력수량 합
	//st_sum_res_qty 잔여수량 = 발주수량 - 송장수량 - 예정수량
	
	for(var i = 0 ; i < trCnt ; i++){
		
		var cd_qty = $("input[name='st_cd_qty']").eq(i).val();
		if(isEmpty(cd_qty)){
			cd_qty = 0;
		}
		sum_sch_qty = sum_sch_qty + parseInt(cd_qty);
	}
	
	sum_res_qty = po_qty - sum_inv_qty - parseInt(sum_sch_qty);
	
	$("#st_sum_sch_qty").html(sum_sch_qty);
	$("#st_sum_res_qty").html(sum_res_qty);
	
}

</script>
</head> 
<body onload="">
<form name="masterMpIvDivsnDeliveryPlanAlterPop" id="masterMpIvDivsnDeliveryPlanAlterPop" method=post >
	<input type="hidden" id="st_query" name="st_query" value="">
	<input type="hidden" id="st_delay_reason" name="st_delay_reason"  value="">
	<input type="hidden" id="st_max_cd_date" name="st_max_cd_date" value="">
	
	<input type="hidden" id="x"  value="">
	
	<input type="hidden" id="st_user_id" name="st_user_id"  value="${sessionInfo.userId}">
	
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다 / 500*500-->
	<div id="popWrapper" style="height:544px;">
		<div id="popHeader">
			<h1 class="title">분할납품 계획 변경</h1>
			<p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/b_btn_popclose.gif" alt="닫기버튼" /></a></p>
		</div>
		<!--팝업내용입니다-->
		<div id="popContainer">
			<!--조회영역-->
			<table class="cont_t_list02"  style="width:100%">
				<caption>분할납품계획변경 리스트</caption>
				<colgroup>
					<col width="20%" />
					<col width="30%" /> 
					<col width="20%" /> 
					<col width="*" /> 
				</colgroup>
				<tbody>
					<tr>
						<th style="text-align:left;">&nbsp;&nbsp;발주번호</th>
						<td class="left">&nbsp;<%=po_no%></td>
						<th style="text-align:left;">&nbsp;&nbsp;발주항번</th>
						<td class="left">&nbsp;<%=po_seq%></td>
					</tr>
					<tr>
						<th style="text-align:left;">&nbsp;&nbsp;발주수량</th>
						<td class="left">&nbsp;<%=po_qty%></td>
						<th style="text-align:left;">&nbsp;&nbsp;납기요청일</th>
						<td class="left">&nbsp;<%=CommonUtil.formatStrinigDate(rd_date)%></td>
					</tr>
				</tbody>
			</table>
			
			<div>
				<table width="100%">
					<tr>
						<td style="text-align:right;" colspan="3">
							<span class="btn_02"><a href="javascript:addRow();">행추가</a></span>
							<span class="btn_02"><a href="javascript:delRow();">행취소</a></span>
						</td>
					</tr>
					<tr height="5px">
						<td colspan="3"></td>
					</tr>
				</table>
			</div>

			<!--grid-->
			<div class="scrollArea" style="height:338px">
				<table  class="cont_t_list02"  style="width:100%">
					<caption>분할납품계획변경 리스트</caption>
					<colgroup>
						<col width="20%" /> 
						<col width="30%" /> 
						<col width="*" /> 
					</colgroup>
					<thead>
						<tr>
							<th scope="col">순번</th> 
							<th scope="col">납품에정일</th> 
							<th scope="col">납품수량</th> 
						</tr>
					</thead>
					<tbody id="tblData">
				
				<%
					int sum_inv_qty = 0;
					int inv_qty = 0;
					
					for (int j=0; j<_dataList.size(); j++) {
						Map<String,String> _tmp = _dataList.get(j);
						
						inv_qty = Integer.parseInt(CommonUtil.nvl(String.valueOf(_tmp.get("INV_QTY")),"0"));
						
						if(inv_qty == 0){
							inv_check = "N";
						}
						
						sum_inv_qty = sum_inv_qty + inv_qty;
				%>
						<tr name="rowData" onClick="javascript:rowSelect($(this));"  seq="<%=j%>">
							<td>
								<span name="st_seq"><%=j+1%></span>
							</td>
							<td>
								<input type="text" id="st_cd_date<%=j%>" name="st_cd_date" class="input_type_text"  size="10"  readonly />
							</td>
							<td>
								<input type="text" id="st_cd_qty<%=j%>" name="st_cd_qty" onClick="javascript:checkInvoice(<%=j%>);" onChange ="javascript:checkCdQty(<%=j%>);" class="input_type_text" value="<%=CommonUtil.nvl(String.valueOf(_tmp.get("CD_QTY")))%>" style="text-align:right;" />
								
								<input type="hidden" id="st_inv_qty<%=j%>" name="st_inv_qty" value="<%=CommonUtil.nvl(String.valueOf(_tmp.get("INV_QTY")))%>" />
							</td>
						</tr> 
				<%	}
					
				%>
					</tbody>
					<input type="hidden" id="st_inv_check" name="st_inv_check" value="<%=inv_check%>" />
				</table>
			</div>
			
			<%
				if(inv_check.equals("N")){
			%>
				<table width="100%" border="0" cellspacing="1" cellpadding="2" align="center">
					<tr> 
						<td align="left" height="40">
							송장수량 계: <span id="st_sum_inv_qty"><%=sum_inv_qty%></span>&nbsp;&nbsp;&nbsp;
							예정수량 계: <span id="st_sum_sch_qty">0</span>&nbsp;&nbsp;&nbsp;
							잔여수량 : <span id="st_sum_res_qty"><%=Integer.parseInt(po_qty)-sum_inv_qty%></span>
						</td>
						<td align="right" height="40">
							<span class="btn_02"><a href="javascript:setCdQty();">저장</a></span>
						</td>
					</tr>
				</table>
			<%
			 	}
			%>
		</div>
	</div>
</form> 
</body>
</html>
<script>
	$(document).ready(function() {
<% 
		if (_dataList == null || _dataList.size() == 0){ 
		}else{
			for (int j=0; j<_dataList.size(); j++) {
				Map<String,String> _tmp = _dataList.get(j);
%>
				kepSetCalender("st_cd_date<%=j%>","1","Y","<%=j%>");
				
				$("#st_cd_date<%=j%>").datepicker("setDate", "<%=CommonUtil.formatDate(_tmp.get("DS_DATE"),1)%>");
				
				$("#x").val(<%=j%>);
<%
			}
		}
%>
	});
</script>
