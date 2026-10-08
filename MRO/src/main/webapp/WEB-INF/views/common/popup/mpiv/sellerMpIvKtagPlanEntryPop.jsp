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
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.StringTokenizer"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="java.util.HashMap"%>
<%@ page import="java.util.Vector"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<!DOCTYPE html>
<html> 
<head>
<style> 
.aback{ background-color:#fff5bf }
</style>
<%@ include file="../../../common/include/head.jspf"  %>
 

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
    	alert("납품수량에 1 이상의 숫자를 입력해 주십시요");
    	
    	$("#cd_qty"+num).val("");
    	$("#cd_qty"+num).focus();
    	
    	return;
    }
}
//행추가
function addRow(){
	
	var trCnt = $("#tblData").children("tr").length;
	var seq = trCnt+1;
	
	var x = $("#x").val() + 1;
	
	var rowData	 = "<tr name='rowData' onClick='javascript:rowSelect($(this));' seq='"+x+"'> ";
	rowData		+= "	<td>"+seq+"</td>";
	rowData		+= "	<input type='hidden' id='st_seq' name='st_seq' value='"+seq+"'>";
	rowData		+= "	<td>";
	rowData		+= "	<%=description%>	";
	rowData 	+= "	</td>";

	rowData		+= "	<td>";
	rowData		+= "		<input type='text'   name='cd_qty' id='cd_qty"+x+"' class='input_type_text' onChange = 'javascript:checkCdQty("+x+")' class='input_type_text'  style='text-align:right;'>";
	rowData 	+= "	</td>";

	rowData 	+= "</tr>";
	
	$("#tblData").append(rowData);
	
	$("#x").val(x);

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
		    alert( i+1 + "번째 줄에 Ktag분할출력수량을 입력하여 주십시요");
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

    if(!confirm("분할납품계획을 입력하시겠습니까?")) return; 
    document.processForm.st_query.value  = query;    
    kepAjaxFormCall("/mpiv/saveSellerMpIvKtagPlanEntryPop.do","processForm",btnEvent); 

    }else{
        alert("납품예정수량("+item_qty+")과 Ktag분할출력수량("+sumcd_qty+")이 일치하지 않습니다.\n\n확인 후 다시 입력하여 주십시요.");
    }            
	
}

//행삭제
function delRow(){
	
	if($("#tblData tr.aback").length <= 0){
		alert("삭제할 행을 선택해 주십시요.");
		return;
	}
	
	$("#tblData tr").each(function (index){
		if ( $( this ).is(".aback") ) {
			 $( this ).remove();
		}
	});
	
	$("#tblData tr").each(function (index){
		$(this).find("td>span").html(index+1);;
	});
}

function kepAjaxSuccess(pMethod , response){
	var msg = response.msg;
	if(msg=="성공"){
		alert("Ktag출력 수량분할이 정상적으로 완료 되었습니다.");		
		window.close();
	}else{
		alert("에러");				
	}
	
	
	return;
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
	<div id="popWrapper" style="height:496px;">
    	<div id="popHeader">
        	<h1 class="title">Ktag 분할출력</h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/s_btn_popclose.gif" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
		<div id="popContainer">
		    <table width="100%" border="0" cellspacing="0" cellpadding="0">
		        <tr> 
		            <td align="center" valign="bottom">
		                <table width="100%"  class="cont_t_list06">
			                <colgroup>
					            <col width="18%" />
					            <col width="30%" />
					            <col width="20%" />
					            <col width="*" />
					        </colgroup>
					        
					        <tr> 
		                        <th><font color="#993300">납품서번호</font></td>
		                        <td><%=inv_no%></td>
		                        <th><font color="#993300">납품서항번</font></th>
		                        <td><%=po_seq%> </td>
		                    </tr>
		                    <tr> 
		                        <th><font color="#993300">납품수량</font></th>
		                        <td><%=CommonUtil.formatNumber(item_qty,true,0,3)%> </td>
		                        <th><font color="#993300">품명</font></th>
		                        <td><%=description%></td>
		                    </tr>
		                </table>
						
						<div>
							<table width="100%"  class="mb05">
								<tr height="10px">
				            		<td colspan="3"></td>
				            	</tr>
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
			            <div class="scrollArea" style="height:250px">
			                <table  class=cont_t_list02  style="width:100%">
			                    <caption>분할납품 계획 리스트</caption>
			                    <colgroup>
			                        <col width="20%" /> 
			                        <col width="40%" />
			                        <col width="40%" /> 
			                    </colgroup>
                    			<thead>
                  					<th>순 번</th>
									<th>품명</th>
									<th>분할출력수량</th>
                    			</thead>

                     			<tbody id="tblData">
<%
						if (_data == null || _data.size() == 0){
							
							int i=0;
%>	
				<tr name="rowData" onClick="javascript:rowSelect($(this));"  seq="<%=i%>">
					<td>
						<%=i+1%>
						<input type="hidden"   name="st_seq" id = "st_seq"  value = "<%=i+1%>"  >
					</td>
					<td>
						<%=description%>
					</td>
					<td> 
						<input type="text" name="cd_qty" id="cd_qty<%=i%>" onChange ="javascript:checkCdQty(<%=i%>);" class="input_type_text"  style="text-align:right;"/>
					</td>
                      </tr>  

<%							
						}else{
						int recCnt = _data.size();
 
						if(recCnt <= 0){
							recCnt = 1;
						}
							
							for (int i=0; i<recCnt; i++){
								
								Map<String,String> rowData = _data.get(i);
								
// 								ktag_qty 	= CommonUtil.nvl(rowData.get("KTAG_QTY"));
// 								num 			= CommonUtil.nvl(rowData.get("NUM"));						

%> 
											<tr name="rowData" onClick="javascript:rowSelect($(this));"  seq="<%=i%>">
												<td>
													<%=i+1%>
													<input type="hidden"   name="st_seq" id = "st_seq"  value = "<%=i+1%>"  >
												</td>
												<td>
													<%=description%>
												</td>
												<td> 
													<input type="text" name="cd_qty" id="cd_qty<%=i%>" onChange ="javascript:checkCdQty(<%=i%>);" class="input_type_text"  style="text-align:right;" value = "<%=CommonUtil.nvl(rowData.get("KTAG_QTY"))%>"/>
												</td>
					                        </tr>   
<%
 							}
						}
 %> 
					         </tbody>                             			
                    		</table>
                    	</div>
                    	
		                <table width="100%" border="0" cellspacing="1" cellpadding="2" align="center">
		                    <tr> 
		                        <td align="right" height="40">
		                       <span class="btn_02"><a href="javascript:setKtagPlanEntry();">저장</a></span>
		                       <!--  <span class="btn_02""><a href="javascript:self.close()">닫기</a></span>-->
		                       	</td>
		                    </tr>
		                </table>
		            </td>
		        </tr>
		    </table>
		</div>        
	</div>
</form> 
</body>
</html>
<script>
</script> 
