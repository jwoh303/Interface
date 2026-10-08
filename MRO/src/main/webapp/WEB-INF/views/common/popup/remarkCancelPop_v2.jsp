<%--
**********************************************
* 메뉴 : 사유 팝업
* 화면 : 사유 팝업
* 기능 : 사유 팝업
* 프로그램 ID : 
* 담당자 : 최찬규
* 착수일 : 2026-02-23
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.util.CommonLang"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<!doctype html>
<html>
<head>
<%@ include file="../include/head_v2.jspf"  %>
</head>
<%
String cancel_remark = CommonUtil.nvl((String) request.getParameter("cancel_remark"),"");  //  (조회조건)
String cancel_remark_type = CommonUtil.nvl((String) request.getParameter("cancel_remark_code"),"");  //  (조회조건)
cancel_remark = cancel_remark.replaceAll("&lt;br&gt;","\n");

String viewType = CommonUtil.nvl((String) request.getParameter("viewType"),"");  //  (조회조건)
String tab_id = CommonUtil.nvl((String) request.getParameter("tab_id"),"");  //  (조회조건)
String param = CommonUtil.nvl((String) request.getParameter("param"),"");  //  (조회조건)
param = java.net.URLDecoder.decode(param,"UTF-8");
String popTitle = "";
String subTitle = "";
String textSize = "0";
String[] paramArr = param.split("@@");

if (viewType.equals("reject")) {
	popTitle = CommonLang.get("HTITLE854");	//"사용자등록화면"
	subTitle = CommonLang.get("HTITLE855");	//"거절 사유를 입력해주세요."
	textSize = "100";
} else if (viewType.equals("interfaceCancel")) {
	popTitle = CommonLang.get("HTITLE122");	//"비고"
	subTitle = CommonLang.get("HTITLE856");	//"I/F종결 사유 입력바랍니다."
	textSize = "400";
} else if (viewType.equals("ASRemark")) {
	popTitle = CommonLang.get("HTITLE122");	//"비고"
	subTitle = CommonLang.get("HTITLE857");	//"닥터AS비고"
	textSize = "400";
} else if (viewType.equals("ASRemark_READONLY")) {
	popTitle = CommonLang.get("HTITLE122");	//"비고"
	subTitle = CommonLang.get("HTITLE857");	//"닥터AS비고"
	textSize = "400";
} else if (viewType.equals("rejectPr")) {
	popTitle = CommonLang.get("HTITLE238");	//"반려"
	subTitle = CommonLang.get("HTITLE858");	//"반려사유 입력바랍니다."
	textSize = "400";
} else if (viewType.equals("negoRfq")) {
	popTitle = CommonLang.get("HTITLE122");	//"비고"
	subTitle = CommonLang.get("HTITLE859");	//"재견적사유 입력바랍니다."
	textSize = "400";
} else if (viewType.equals("eContReject")) {
	popTitle = CommonLang.get("HTITLE148");	//"취소사유"
	subTitle = CommonLang.get("HTITLE207");	//"사유"
	textSize = "400";
} else if (viewType.equals("catalogRegReqCancel")) {
	popTitle = CommonLang.get("HTITLE148");	//"취소사유"
	subTitle = CommonLang.get("HTITLE207");	//"사유"
	textSize = "400";
} else if (viewType.equals("catalogRegReSourcing")) {
	popTitle = CommonLang.get("HTITLE955");	//"재소싱요청"
	subTitle = CommonLang.get("HTITLE207");	//"사유"
	textSize = "400";
} else if (viewType.indexOf("cancelRemark") > -1) {
	popTitle = CommonLang.get("HTITLE860");	//"견적 취소 사유"
	subTitle = CommonLang.get("HTITLE148");	//"취소사유"
	textSize = "4000";
} else if (viewType.indexOf("kepRfqCancel") > -1) {
	popTitle = CommonLang.get("HTITLE860");	//"견적 취소 사유"
	subTitle = CommonLang.get("HTITLE148");	//"취소사유"
	textSize = "4000";
} else {
	popTitle = CommonLang.get("HTITLE229");	//"취소"
	subTitle = CommonLang.get("HTITLE860");	//"견적 취소 사유"
	textSize = "4000";
}
%>
<script type="text/javascript">
var but1text = "<%=CommonLang.get("HTITLE516")%>"; //확인
var but1func = "javascript:closePopText2(); return false;";
var but1width = "120px";

function kep_onload_view(){
	var view_type = "<%=viewType%>";
//    $("#cancel_remark").val("");
//    $("#st_atob_remark").val("");
   
//   opener.setPopupReturn(value1,"");
//   this.close();
	// 견적취소사유 일 때만
	
	$("#cancel_remark").focus();
}

function kepConfirm(){
	var value1 = $("#cancel_remark").val();
	var value2 = "";
	var value3 ="";
	var value4 ="";
	var value5 = "";
	var view_type = "<%=viewType%>";
	
	if(view_type != "catalogRegReqCancel" && view_type != "catalogRegReSourcing" && view_type != "cancelRemark"){ // 카탈로그 등록 진행에서는 <br> 사용 안함
		value1 = value1.replace(/\r?\n/g, '<br>');
	}
	
	// 견적취소사유 일 때만
	if(view_type == "kepRfqCancel"){
		if(!$("#r_cancel_type1").is(":checked") && !$("#r_cancel_type2").is(":checked") && !$("#r_cancel_type3").is(":checked") && !$("#r_cancel_type4").is(":checked") && !$("#r_cancel_type5").is(":checked")
				&& !$("#r_cancel_type6").is(":checked") && !$("#r_cancel_type7").is(":checked") && !$("#r_cancel_type8").is(":checked") && !$("#r_cancel_type9").is(":checked") && !$("#r_cancel_type10").is(":checked")) {
// 			alert("취소사유를 선택하여 주십시오");
			var text = "취소사유를 선택하여 주십시오";
			openLayerPopText2(text,but1text,but1func,but1width);
			return;
		}
	
		// 기타 선택
		if($("#r_cancel_type10").is(":checked")){
			if(value1 == ""){
// 				alert("기타 선택 시 상세사유를 입력하시기 바랍니다.");
				var text = "기타 선택 시 상세사유를 입력하시기 바랍니다.";
				openLayerPopText2(text,but1text,but1func,but1width);
				$("#cancel_remark").focus();
				return;
			}
		}
		
		$("#st_cancel_type").val($("input[name=r_cancel_type]:checked").val());
		value2 = $("#st_cancel_type").val();
	}else if(view_type == "cancelRemark"){
		for(var i = 0 ; i < <%=paramArr.length%>; i++){
			if(isEmpty($("#cancel_remark"+i).val())){
// 				alert("취소사유를 입력하여 주십시오");
				var text = "취소사유를 입력하여 주십시오";
				openLayerPopText2(text,but1text,but1func,but1width);
				$("#cancel_remark"+i).focus();
				return;
			}else{
				var temp_remark = $("#cancel_remark"+i).val();
				$("#cancel_remark"+i).val(temp_remark.replace(/\r?\n/g, '<br>'));
			}
		}

// 		if(!confirm("상품견적을 취소하시겠습니까?")){return;}
		var text = "상품 견적을 취소하시겠습니까?";	
		var but1textC = "확인";
		var but2textC = "취소";
		var but1funcC = "javascript:buyerMpRqCancel(); return false;";
		var but2funcC = "javascript:closePopText1(); return false;";
		var but1widthC = "120px";
		var but2widthC = "120px";
		openLayerPopText(text,but1textC,but2textC,but1funcC,but2funcC,but1widthC,but2widthC);
		return;
	}
	parent.setPopupReturn(value1,value2,value3,value4,value5);
	parent.closePop();
}
function buyerMpRqCancel(){
	closePopText1();
	
	var value1 = "";
	var value2 = "";
	var value3 = "";
	var value4 = "";
	var value5 = "";
	
	for(var i = 0 ; i < <%=paramArr.length%>; i++){
		value1 += $("#st_idx"+i).val()+":::";
		value2 += $("#st_quotation_no"+i).val()+":::";
		value3 += $("#st_quotation_seq"+i).val()+":::";
		value4 += $("#cancel_remark"+i).val()+":::";
		value5 += $("#st_buyer"+i).val()+":::";
		
	}
	var tab_id = "<%=tab_id%>";
	opener.tabs[tab_id]["setPopupReturn"](value1,value2,value3,value4,value5);
	self.close();
	return;
}
</script>  
<body onload="kep_onload_view()">
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다-->
<%if(viewType.equals("rejectPr")){%> <!-- 결재반려사유 -->
	<div class="wrapPopupAlert">
		    <div class="PopupTit"><%=popTitle%><span><a href="javascript:parent.closePop();"><img src="/resources/imgs/Icon_close.png" /></a></span></div>
		    <div class="AlertTxtM mt15 mb30" style="text-align: left;">
		      <%=CommonLang.msg("MSG646")%><!--반려사유를 기재해주세요.--><br/>
		      <div class="TextField mt10" id="limitedArea">
		       <textarea id="cancel_remark" name="cancel_remark" style=" width:92%; height:50px;" placeholder="<%=CommonLang.msg("MSG646")%>" onkeyup="fnCheckInputByte(this, <%=textSize%>);" onchange="fnCheckInputByte(this, <%=textSize%>);"></textarea><!--반려사유를 기재해주세요.-->
		      </div>
		    </div>
		    <div class="PopupListBtnBox_Center">
		      <button class="ButQuaternary_large closePopup" onclick="javascript:parent.closePop(); return false;"><%=CommonLang.get("HTITLE229")%><!-- 취소 --></button>
		      <%if (viewType.indexOf("READONLY") == -1) {%>
		      <button class="ButPrimary_large" onclick="javascript:kepConfirm(); return false;"><%=CommonLang.get("HTITLE516")%><!-- 확인 --></button>
		      <%} %>
		    </div>
		  </div>
<%} else if (viewType.equals("cancelRemark")) { %>
	<div class="wrapPopupAlert">
		<div class="PopupTit"><%=popTitle%><span><a href="javascript:parent.closePop();"><img src="/resources/imgs/Icon_close.png" /></a></span></div>
	    <div class="AlertTxtM mt15 mb30" style="text-align: left;"> 선택한 상품의 견적취소사유를 입력해주세요.
	    <br><br>
		    <table class="PopupTableTxt">
				<caption><%=popTitle%></caption>
				<colgroup>
					<col width="15%" />
					<col width="10%" />
					<col width="30%" />
					<col width="45%" />
				</colgroup>
			    <tr>
			      <th>견적번호</th>
			      <th>순번</th>
			      <th>품목명</th>
			      <th>취소사유<font color="red">*</font></th>
		    	</tr>
<%
	for(int i = 0 ; i < paramArr.length; i++){
		String[] temp = paramArr[i].split(":::"); // 0 : idx, 1 : 견적번호 , 2 : 견적항번, 3 : 품목코드 , 4 : 품목명, 5: 고객사코드
%>
				<tr>
					<input type="hidden" id="st_idx<%=i%>" value="<%=CommonUtil.nvl(temp[0])%>">
					<input type="hidden" id="st_quotation_no<%=i%>" value="<%=CommonUtil.nvl(temp[1])%>">
					<input type="hidden" id="st_quotation_seq<%=i%>" value="<%=CommonUtil.nvl(temp[2])%>">
					<input type="hidden" id="st_buyer<%=i%>" value="<%=CommonUtil.nvl(temp[5])%>">
					<td><%=CommonUtil.nvl(temp[1])%></td>
					<td><%=CommonUtil.nvl(temp[2])%></td>
					<td><%=CommonUtil.nvl(temp[3])%><br><%=CommonUtil.nvl(temp[4])%></td>
					<td>
						<textarea id="cancel_remark<%=i%>" name="cancel_remark" style=" width:92%; height:50px;border:1px solid #DEDEDE;" placeholder="" 
						onkeyup="fnCheckInputByte(this, <%=textSize%>);" onchange="fnCheckInputByte(this, <%=textSize%>);"></textarea>
					</td>
				</tr>
<%}%>
			</table>
		</div>
		<div class="PopupListBtnBox_Center">
			<button class="ButPrimary_large" onclick="javascript:kepConfirm(); return false;"><%=CommonLang.get("HTITLE516")%><!-- 확인 --></button>
		</div>
	</div>
<%}else{ %>
	<div id="popWrapper" style="height:232px; min-height: 100px;">
    	<div id="popHeader">
        	<h1 class="title"><%=popTitle%></h1>
            <p class="popClose"><a href="javascript:self.close()">
<%--             <img src="/resources/images/<%=_closeImgSrc %>" alt="닫기버튼" /> --%>
            </a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer">
        
			<table class="cont_t_list05" style="background-color: #FAF9CF;">
				<tr > 
					<td style="width:100px;"><b><%=subTitle%></b></td>
				</tr>
            </table>
	<%if(viewType.indexOf("kepRfqCancel") > -1){%>
			<table style="width:100%">
				<caption>견적진행조회</caption>
				<colgroup>
					<col width="50%" />
					<col width="50%" />
				</colgroup>
				
				<input type="hidden" id="st_cancel_type" name="st_cancel_type" value="<%=cancel_remark_type%>">
				
				<tr>
					<td style="text-align: left;"><input type="radio" id="r_cancel_type1" name="r_cancel_type" style="vertical-align: middle;" value="A" <%=cancel_remark_type.equals("A")?"checked":""%> <%=viewType.equals("kepRfqCancel_READONLY")?"disabled":""%>> 고객사 견적취소</td>
					<td style="text-align: left;"><input type="radio" id="r_cancel_type2" name="r_cancel_type" style="vertical-align: middle;" value="B" <%=cancel_remark_type.equals("B")?"checked":""%> <%=viewType.equals("kepRfqCancel_READONLY")?"disabled":""%>> 단종</td>
				</tr>
				<tr>
					<td style="text-align: left;"><input type="radio" id="r_cancel_type3" name="r_cancel_type" style="vertical-align: middle;" value="C" <%=cancel_remark_type.equals("C")?"checked":""%> <%=viewType.equals("kepRfqCancel_READONLY")?"disabled":""%>> 판매불가</td>
					<td style="text-align: left;"><input type="radio" id="r_cancel_type4" name="r_cancel_type" style="vertical-align: middle;" value="D" <%=cancel_remark_type.equals("D")?"checked":""%> <%=viewType.equals("kepRfqCancel_READONLY")?"disabled":""%>> 기등록</td>
				</tr>
				<tr>
					<td style="text-align: left;"><input type="radio" id="r_cancel_type5" name="r_cancel_type" style="vertical-align: middle;" value="E" <%=cancel_remark_type.equals("E")?"checked":""%> <%=viewType.equals("kepRfqCancel_READONLY")?"disabled":""%>> 동일견적진행중</td>
					<td style="text-align: left;"><input type="radio" id="r_cancel_type6" name="r_cancel_type" style="vertical-align: middle;" value="F" <%=cancel_remark_type.equals("F")?"checked":""%> <%=viewType.equals("kepRfqCancel_READONLY")?"disabled":""%>> 고객사직거래</td>
				</tr>
				<tr>
					<td style="text-align: left;"><input type="radio" id="r_cancel_type7" name="r_cancel_type" style="vertical-align: middle;" value="G" <%=cancel_remark_type.equals("G")?"checked":""%> <%=viewType.equals("kepRfqCancel_READONLY")?"disabled":""%>> 해외 현지조달</td>
					<td style="text-align: left;"><input type="radio" id="r_cancel_type8" name="r_cancel_type" style="vertical-align: middle;" value="H" <%=cancel_remark_type.equals("H")?"checked":""%> <%=viewType.equals("kepRfqCancel_READONLY")?"disabled":""%>> 특정 화학물질</td>
				</tr>
				<tr>
					<td style="text-align: left;"><input type="radio" id="r_cancel_type9" name="r_cancel_type" style="vertical-align: middle;" value="I" <%=cancel_remark_type.equals("I")?"checked":""%> <%=viewType.equals("kepRfqCancel_READONLY")?"disabled":""%>> 경쟁사 단독</td>
					<td style="text-align: left;"><input type="radio" id="r_cancel_type10" name="r_cancel_type" style="vertical-align: middle;" value="J" <%=cancel_remark_type.equals("J")?"checked":""%> <%=viewType.equals("kepRfqCancel_READONLY")?"disabled":""%>> 기타</td>
				</tr>
			</table>
		<%}%>
            
            
			<table class="cont_t_list05" >
                <tr>
                    <td style="text-align: center;">
                    	<textarea id="cancel_remark" name="cancel_remark" style="width:98%;" rows="5" onkeyup="fnCheckInputByte(this, <%=textSize%>);" onchange="fnCheckInputByte(this, <%=textSize%>);"><%=cancel_remark%></textarea>
                    </td>
                </tr>
            </table>
            <table >
                <tr> 
                    <td></td>
                </tr>
            </table>
            <%
            if (viewType.indexOf("READONLY") == -1) {
            %>
	       	<div class="ac" style="margin-bottom:0px;height:27px;">   
	           	<span class="fr btn_02"><a href="javascript:kepConfirm()"><%=CommonLang.get("HTITLE516") %><!-- 확인 --></a></span> 
			</div>
            <%
            }
            %>
        </div>
    </div>
<%} %>
</body>
</html>
