<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%> 
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.util.CommonLang"%>
<!doctype html>
<html>
<head>
<%@ include file="../../common/include/head_pop.jspf"  %>
</head>
<%
String cancel_remark = CommonUtil.nvl((String) request.getParameter("cancel_remark"),"");  //  (조회조건)
String cancel_remark_type = CommonUtil.nvl((String) request.getParameter("cancel_remark_code"),"");  //  (조회조건)
cancel_remark = cancel_remark.replaceAll("&lt;br&gt;","\n");

String viewType = CommonUtil.nvl((String) request.getParameter("viewType"),"");  //  (조회조건)
String popTitle = "";
String subTitle = "";
String textSize = "0";

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
	var view_type = "<%=viewType%>";
	
	if(view_type != "catalogRegReqCancel" && view_type != "catalogRegReSourcing"){ // 카탈로그 등록 진행에서는 <br> 사용 안함
		value1 = value1.replace(/\r?\n/g, '<br>');
	}
	
	// 견적취소사유 일 때만
	if(view_type == "kepRfqCancel"){
		if(!$("#r_cancel_type1").is(":checked") && !$("#r_cancel_type2").is(":checked") && !$("#r_cancel_type3").is(":checked") && !$("#r_cancel_type4").is(":checked") && !$("#r_cancel_type5").is(":checked")
				&& !$("#r_cancel_type6").is(":checked") && !$("#r_cancel_type7").is(":checked") && !$("#r_cancel_type8").is(":checked") && !$("#r_cancel_type9").is(":checked") && !$("#r_cancel_type10").is(":checked")) {
			alert("취소사유를 선택하여 주십시오");
			return;
		}
	
		// 기타 선택
		if($("#r_cancel_type10").is(":checked")){
			if(value1 == ""){
				alert("기타 선택 시 상세사유를 입력하시기 바랍니다.");
				$("#cancel_remark").focus();
				return;
			}
		}
		
		$("#st_cancel_type").val($("input[name=r_cancel_type]:checked").val());
		value2 = $("#st_cancel_type").val();
	}
	
	opener.setPopupReturn(value1,value2);
	this.close();
}

</script>  
<body onload="kep_onload_view()">
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다-->
	<div id="popWrapper" style="height:232px; min-height: 100px;">
    	<div id="popHeader">
        	<h1 class="title"><%=popTitle%></h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/<%=_closeImgSrc %>" alt="닫기버튼" /></a></p>
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
</body>
</html>
