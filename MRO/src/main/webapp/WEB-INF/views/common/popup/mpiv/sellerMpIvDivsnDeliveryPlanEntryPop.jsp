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
	
	String user_id			= CommonUtil.nvl((String) request.getParameter("user_id"));
	String kep_id			= CommonUtil.nvl((String) request.getParameter("kep_id"));
	
	if(user_id.equals("")){
		user_id = _sessionInfo.getUserId();
	}
			
	String buyer			= CommonUtil.nvl((String) request.getParameter("buyer"));
	String po_no			= CommonUtil.nvl((String) request.getParameter("po_no"));
	String po_seq			= CommonUtil.nvl((String) request.getParameter("po_seq"));
	String po_qty			= CommonUtil.nvl((String) request.getParameter("po_qty"));
	String seller			= CommonUtil.nvl((String) request.getParameter("seller"));
	String ds_flag			= CommonUtil.nvl((String) request.getParameter("ds_flag"));
	String st_date			= CommonUtil.nvl((String) request.getParameter("st_date"));
	String ds_delay_reason	= CommonUtil.nvl((String) request.getParameter("ds_delay_reason"));
			
	// 분할납품정보 있는지 확인하는 부분
	Vector vt           = new Vector();
	String query_str	= CommonUtil.nvl((String)request.getParameter("query_text"));
	String check_flag	= CommonUtil.nvl((String)request.getParameter("check_flag"));
	
	String check_str[]  = CommonUtil.StrToArray(query_str , "^||^");
	
//	KRCOWA0001@@PO14003786@@000001@@1@@20140619@@1@@Y@@KRKORE0001@@KEPSE02@@@@20140619@@20140301^||^
	
	for(int i=0 ; i < check_str.length; i++){	
		
		String str[] = check_str[i].split("@@",-1);
		
		vt.addElement(str);
	}
%>

<script language="javascript">
var x;

// 분할납품변경계획 저장
function setDeliverySchedule(){
	getLastDate(); 

    var buyer           = "<%=buyer%>";
    var po_no           = "<%=po_no%>";
    var po_seq          = "<%=po_seq%>";
    var po_qty          = "<%=po_qty%>";
    var seller          = "<%=seller%>";
    var user_id         = "<%=user_id%>";
    var max_cd_date     = $("#st_max_cd_date").val();
    var st_date         = "<%=st_date%>";
    var buyer_need_deli = "N";
    
    var kep_id = "<%=kep_id%>";
    
	var trCnt = $("#tblData").children("tr").length;
	
	var check_flag = eval("document.sellerMpIvDivsnDeliveryPlanEntryPop.st_buyer_need_deli.checked");
	
	if(check_flag == true){
		buyer_need_deli = "Y";
		if(trCnt > 1){
			alert("고객사 요청시 분할 납품 건은 1줄로만 입력 가능합니다.");
			return;
		}
	}else{
		// 지연사유 입력체크
	    if(!getReason(max_cd_date)){
	    	return;
	    }
	}
    
    var delay_reason    = $("#st_delay_reason").val();
    
    var query       = "";
    var sumcd_qty       = 0;
	
    for(i = 0 ; i < trCnt ; i++){
    	var cd_date = $("input[name='st_cd_date']").eq(i).val();
    	var cd_qty  = $("input[name='cd_qty']").eq(i).val();
    	
		if(isEmpty(cd_date)){
		    alert( i+1 + "번째 줄에 납품예정일을 입력하여 주십시요");
		    $("#input[name='st_cd_date_text']").eq(i).focus();
		    return;
		}
		
		if(isEmpty(cd_qty)){
		    alert( i+1 + "번째 줄에 납품수량을 입력하여 주십시요");
		    $("input[name='cd_qty']").eq(i).focus();
		    return;
		}
		
		if(st_date > cd_date){
			delay_reason = "";
		}else{
			delay_reason    = $("#st_delay_reason").val();
		}
		
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
		query +=  st_date		+ "@@";
		query +=  ""			+ "@@"; // reject_reason 자리
		query +=  buyer_need_deli + "@@"; // 고객사 요청분할
		query +=  st_date;
		
		if(!isEmpty(kep_id)){
			query +=  "@@" + kep_id;	
		}
		query +=  "^||^";
		
		sumcd_qty = eval(sumcd_qty) + eval(cd_qty);
    }
    
    // 납품예정일 중복체크
	if(!checkSamedate(trCnt)) return;
	
    if(po_qty == sumcd_qty){

		if(!confirm("분할납품계획을 입력하시겠습니까?")) return; 

		if(delay_reason != ""){
			top.opener.setReason(delay_reason,'one');
		}

		if(check_flag == true){
			check_flag = "Y";
		}else{
			check_flag = "N";
		}
		
		opener.setDSQuery(query,max_cd_date,check_flag);		
	  
		parent.window.close();

    }else{
        alert("납품예정수량("+sumcd_qty+")과 발주수량("+po_qty+")이 일치하지 않습니다.\n\n확인 후 다시 입력하여 주십시요.");
    }            
}

//지연사유 값 얻기
function getReason(max_cd_date){

	var reason_cd = $("#reason_cd").val();
	var reason_etc = $.trim($("#st_reason_etc").val());

	var reason_txt = "";
	
	// 지연사유 값 세팅
	if(reason_cd == "기타"){
		$("#st_delay_reason").val(reason_etc);	
	} else {
		$("#st_delay_reason").val(reason_cd);
	}	
	
	reason_txt = $("#st_delay_reason").val();
	
	var st_date		= "<%=st_date%>";
	
	// 납기요청일과 납품예정일 마지막날짜를 비교하여 지연사유 입력여부 체크
	if(max_cd_date > st_date && reason_txt==""){
		alert("납품지연 사유를 입력하여 주시길 바랍니다.");
        $("#reason_cd").focus();
        return false;
    }
	
	return true;
}

// 중복되는 납품예정일이 있는지 확인 
function checkSamedate(insert_cnt) {
    var i;    
    for(i=0;i<insert_cnt;i++){
        for(j=0;j<i;j++){
            if((document.forms[0].st_cd_date[i].value != "") && (document.forms[0].st_cd_date[i].value == document.forms[0].st_cd_date[j].value)){
                alert("납품예정일이 중복 되었습니다.\n\n확인 후 다시 입력하여 주십시요.");
                document.forms[0].st_cd_date_text[i].focus();
                document.forms[0].st_cd_date_text[i].select();
                return;
            }
            
            if((document.forms[0].st_cd_date[i].value != "") && (document.forms[0].st_cd_date[i].value < document.forms[0].st_cd_date[j].value)){
            	alert("납품예정일 순서를 확인해주시기 바랍니다.");
            	document.forms[0].st_cd_date_text[j].focus();
                document.forms[0].st_cd_date_text[j].select();
                return;
            }
        }
    }//end for
    return true;
}

// 마지막 날짜 검색...
function getLastDate() {
    var cd_date     = "";
    var max_cd_date = "";
	var st_date     = "<%=st_date%>";
	var trCnt = $("#tblData").children("tr").length;
	var form = document.sellerMpIvDivsnDeliveryPlanEntryPop;
	
    for(var i = 0 ; i < trCnt ; i++){
    	
    	$("#input[name='st_cd_date_text']").eq(i).focus();

       	if($("input[name='st_cd_date']").eq(i).val().length > 0 && $("input[name='cd_qty']").eq(i).val().length > 0){

            cd_date = $("input[name='st_cd_date']").eq(i).val();
            
            // 납품예정일 마지막날짜
            if(max_cd_date=="") max_cd_date = cd_date;
            if( eval(cd_date) > eval(max_cd_date)){
                max_cd_date = cd_date;
            }
        }
    }

	if(st_date >= max_cd_date){// 납품예정일이 변경되어 납기요청일 >= 납품예정일 경우 지연사유 입력값을 변경한다.
		form.st_delay_reason.value = "";		
	}
	
    $("#st_max_cd_date").val(max_cd_date);
}

// 납품수량 체크
function checkCdQty(num){
    var cd_qty = $("#cd_qty"+num).val();
    
    if( !isEmpty(cd_qty) && (!kepIsNumber("cd_qty"+num) || cd_qty == "0")){
    	alert("납품수량에 1 이상의 숫자를 입력해 주십시요");
    	
    	$("#cd_qty"+num).val("");
    	$("#cd_qty"+num).focus();
    	
    	return;
    }
}

// OPENER창의 지연사유 값 얻기
function init(){
	var reason = opener.getDelayReason();
    
    if(reason != "" && reason != "재고부족" && reason != "수입지연" && reason != "제작지연" &&  reason != "발주확인지연"){
		$("#reason_cd").val("기타");
		$("#st_reason_etc").val(reason);
	} else {
		$("#reason_cd").val(reason);
	}
    
    // 최초 분할 시 발주수량 표기
    var ds_flag = "<%=ds_flag%>";
    
    if(ds_flag == "N"){
    	$("#cd_qty0").val("<%=po_qty%>");
    	$("#cd_qty0").val("<%=po_qty%>");
    }
    
    if("<%=check_flag%>" == "Y"){
    	document.sellerMpIvDivsnDeliveryPlanEntryPop.st_buyer_need_deli.checked = true;	
    }
}    

var selObj;

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
	var x = eval($("#x").val()) + 1;
	
	var rowData	 = "<tr name='rowData' onClick='javascript:rowSelect($(this));' seq='"+x+"'> ";
	rowData		+= "	<td><span name='st_seq'>"+seq+"</span></td>";
	rowData		+= "	<td>";
	rowData		+= "		<input type='text'   name='cd_qty' id='cd_qty"+x+"' class='input_type_text' onChange = 'javascript:checkCdQty("+x+")' class='input_type_text'  style='text-align:right;'>";
	rowData 	+= "	</td>";
	rowData		+= "	<td>";
	rowData		+= "		<input type='text'   name='st_cd_date_text' id='st_cd_date_text"+x+"' class='input_type_text'  size='10'  value='' readonly>";
	rowData 	+= "		<input type='hidden' name='st_cd_date'      id='st_cd_date"+x+"' value='' >";
	rowData 	+= "	</td>";
	rowData 	+= "</tr>";
	
	$("#tblData").append(rowData);
	
	$("#x").val(x);
	
	setTimeout(function(){
		// Action after append
		kepSetCalender('st_cd_date_text'+x, '1', 'Y', x);
	},100);
}

// 행삭제
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
		$(this).find("td>span").html(index+1);
	});
}

// 납품예정일 calender callback event
function calenderChange(dateText,num){
	if(isEmpty(dateText)){
		var cur_date = kepGetNowTimeStr("YYYYMMDD","");
        $("#st_cd_date"+num).val(cur_date);
	} else {
		var input_date = dateText.replace(/[/]/gi,"");
		var st_date		= "<%=st_date%>";
		var reason_txt = $("#reason_cd").val();
		
		if(reason_txt == "기타"){
			reason_txt = $.trim($("#st_reason_etc").val());
		}
	    
		if(input_date > st_date && reason_txt==""){
	        alert("표준납기일 보다 이후날짜입니다. 지연사유을 입력하시기 바랍니다. ");
	        $("#reason_cd").focus();
	    }
		
		$("#st_cd_date"+num).val(input_date);
	}
}

function needClickEvent(){
	var trCnt = $("#tblData").children("tr").length;
	var form = document.sellerMpIvDivsnDeliveryPlanEntryPop;
	
	var checked = eval("document.sellerMpIvDivsnDeliveryPlanEntryPop.st_buyer_need_deli.checked");
	
	if(checked == true){
		// 납품수량 = 전량, 납품예정일 = 내년 마지막 일자, 지연사유/상세사유 = null
		var cur_date = kepGetNowTimeStr("YYYYMMDD","/"); // 오늘 날짜
		var nextYear_date = kepToMonthAdd("12","P"); // 내년 날짜
		var nextYear_last_date = nextYear_date.substring(0,4) + "/12/31"; // 내년 마지막 날짜
		var replace_nextYear_last_date = nextYear_last_date.replace(/[/]/gi,"");
		
		for(var i=0; i<trCnt; i++){
			$("input[name='cd_qty']").eq(i).val("<%=po_qty%>");
			$("input[name='st_cd_date']").eq(i).val(replace_nextYear_last_date);
			$("input[name='st_cd_date_text']").eq(i).val(nextYear_last_date);
	    }
		
		$("#reason_cd").val("");
		$("#st_reason_etc").val("");
	}else{
		for(var i=0; i<trCnt; i++){
			$("input[name='cd_qty']").eq(i).val("");
			$("input[name='st_cd_date']").eq(i).val("");
			$("input[name='st_cd_date_text']").eq(i).val("");
	    }
		
		$("#reason_cd").val("");
		$("#st_reason_etc").val("");
	}
}
</script>
</head>

<body onload="javascript:init();">
<form name="sellerMpIvDivsnDeliveryPlanEntryPop" id="sellerMpIvDivsnDeliveryPlanEntryPop" method="post" >
<!-- HIDDEN -->
<input type="hidden" name="st_query"         value="">
<input type="hidden" id="st_max_cd_date" name="st_max_cd_date"   value="">
<input type="hidden" id="st_delay_reason" name="st_delay_reason"  value="">

<input type="hidden" id="x"  value="">

<!-- HIDDEN -->

	<!--최소 가로길이 400px, 최소 세로길이 400px입니다 / 500*500-->
	<div id="popWrapper" style="height:496px;">
    	<div id="popHeader">
        	<h1 class="title">분할 납품 계획</h1>
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
		                        <th><font color="#993300">발주번호</font></td>
		                        <td><%=po_no%></td>
		                        <th><font color="#993300">항 번</font></th>
		                        <td><%=po_seq%> </td>
		                    </tr>
		                    <tr> 
		                        <th><font color="#993300">발주수량</font></th>
		                        <td><%=CommonUtil.formatNumber(po_qty,true,0,3)%> </td>
		                        <th><font color="#993300">표준납기일</font></th>
		                        <td><%=CommonUtil.formatDate(st_date)%></td>
		                    </tr>
		                </table>
						
						<div>
							<table width="100%"  class="mb05">
								<tr height="10px">
				            		<td colspan="3"></td>
				            	</tr>
								<tr>
									<td style="text-align:left;" colspan="3">
						            	<span>
						            		<input type="checkbox" name="st_buyer_need_deli" id="st_buyer_need_deli" onChange ="javascript:needClickEvent();"><b> 고객사 요청시 분할 납품 건</b>
						            	</span>
				            		</td>
									<td style="text-align:right;">
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
			            <div class="scrollArea" style="height:270px">
			                <table  class=cont_t_list02  style="width:100%">
			                    <caption>분할 납품 계획 리스트</caption>
			                    <colgroup>
			                        <col width="20%" /> 
			                        <col width="40%" />
			                        <col width="40%" /> 
			                    </colgroup>
                    			<thead>
                  					<th>순 번</th>
									<th>납품수량</th>
									<th>납품예정일</th>
                    			</thead>
                    			<tbody id="tblData">
                    			<%
											/*									
		
											str[0]==>KRKEPB0004			==> 구매사코드
											str[1]==>PO04000206			==> 발주번호
											str[2]==>000001				==> 발주항번
											str[3]==>2					==> 발주수량
											str[4]==>20041118			==> 납품예정일
											str[5]==>1					==> 납품수량
											str[6]==>Y					==> DS_FLAG
											str[7]==>KRKORE0001			==> SELLER
											str[8]==>KEPSE03			==> 수주접수자
											str[9]==>					==> 지연사유
											str[10]==>20041118			==> 납기요청일
											str[11]==>20041118			==> 납품예정일 중 가장 마지막날짜
		
											*/
											
											int size = vt.size();
											String [] rtobj_d = null;
											
											if(size <= 0){
												size = 1;
											}
											
											for( int i=0; i<size; i++){
												
												rtobj_d = new String[12];
		
												if( i < vt.size()){
													rtobj_d = (String[])vt.get(i);
												}
		
										%>
											<tr name="rowData" onClick="javascript:rowSelect($(this));"  seq="<%=i%>">
												<td>
													<span name="st_seq"><%=i+1%></span>
												</td>
												<td>
													<input type="text" name="cd_qty" id="cd_qty<%=i%>" onChange ="javascript:checkCdQty(<%=i%>);" class="input_type_text" value="<%=CommonUtil.nvl(rtobj_d[5])%>" style="text-align:right;"/>
												</td>
												<td> 
													<!-- onChange="javascript:calenderChange(<%--=i--%>);" -->
													<input type="text" name="st_cd_date_text" id="st_cd_date_text<%=i%>" class="input_type_text"  size="10"  readonly>
													<input type="hidden" name="st_cd_date"      id="st_cd_date<%=i%>" value='<%=CommonUtil.nvl(rtobj_d[4])%>' >
												</td>
					                        </tr>
										<%
											}
										%>
                    			</tbody>
                    		</table>
                    	</div>
                    	
                    	<div>
							<table width="100%"  class="mb05">
								<tr>
									<td width="70px"><font style="font-family:'돋음'; font-size:12px; font-weight:normal; color:#666666; padding:2px;">지연사유</font> : </td>
									<td width="105px" style="text-align:left;"  class="am mt02">
										<select id="reason_cd" name="reason_cd" style="width:100px;">
											<option value=""></option>
											<option value="재고부족">재고부족</option>
											<option value="수입지연">수입지연</option>
											<option value="제작지연">제작지연</option>
											<option value="발주확인지연">발주확인지연</option>
											<option value="기타">기타</option>
										</select>
									</td>
									<td>
										<input type="text" id="st_reason_etc" name="st_reason_etc"  class="input_type_text" style="width:93%;">
									</td>
								</tr>
				            	<tr height="5px">
				            		<td colspan="3"></td>
				            	</tr>
				            </table>
			            </div>
			            
		                <table width="100%" border="0" cellspacing="1" cellpadding="2" align="center">
		                    <tr>
		                    	<td align="left" height="40">
		                        	<span><font color="red">※ 분할납품건은 납품예정일 일괄 복사가 불가합니다.</font></span>
		                        </td> 
		                        <td align="right" height="40">
		                        	<span class="btn_02"><a href="javascript:setDeliverySchedule();">저장</a></span>
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
	$(document).ready(function() {
<% 
		for (int i=0; i<size; i++) {
			rtobj_d = new String[12];
			
			if( i < vt.size()){
				rtobj_d = (String[])vt.get(i);
			}
%>
			       
			kepSetCalender("st_cd_date_text<%=i%>","1","Y","<%=i%>");
			$("#st_cd_date_text<%=i%>").datepicker("setDate", "<%=CommonUtil.formatDate(rtobj_d[4],1)%>");
			
			$("#x").val(<%=i%>);
<%  
		}
%>
	});
</script> 
