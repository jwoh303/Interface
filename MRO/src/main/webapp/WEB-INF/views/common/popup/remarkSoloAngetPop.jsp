<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%> 
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<!doctype html>
<html>
<head>
<%@ include file="../../common/include/head_pop.jspf"  %>
</head>
<%
%>
<script type="text/javascript">
function init(){
	$("#st_sol_agent_remark").focus();
}
function kepConfirm()
{ 
	var value1 ="BS09";
	var value2 ="단독입찰";
	var value3 =$("#st_sol_agent_remark").val();
	value3 = value3.replace(/\r?\n/g, '<br>');
 	var remark_len	= kepGetByteLength('st_sol_agent_remark');
 	if(remark_len > 200) {
 		alert("비고는 200Bytes까지 입력가능합니다.");
 	}
 	
 	var reason_code = $("input[name=st_reason_type]:checked").val();
 	var reason_text = $("label[for='"+reason_code+"']").text();
 	
 	// 선택값 없는 경우로 판단
 	if(reason_code == undefined){
 		alert("단독입찰사유를 선택하세요.");
 		return;
 	}
 	
 	// 기타사유 입력인데 내용이 불충분한 상황
 	if(reason_code == "7" && remark_len < 5){
 		$("#st_sol_agent_remark").focus();
 		alert("기타 상세사유를 더 입력하세요.");
 		return;
 	}

 	// 기타사유 입력 시에는 상세사유란만 입력. 이 외는 사유 유형과 함께 저장
 	var reason_add_text = "";
 	var original_remark = $("#st_sol_agent_remark").val();
 	
 	if(reason_code != undefined && reason_code != "7"){
 		reason_add_text = "["+reason_text+"]";
 	}
 	
 	if(reason_code != undefined && reason_code != "7" && remark_len > 0){
 		value3 = reason_add_text + " // " + value3;
 	}else{
 		value3 = reason_add_text + value3;
 	}
 	
 	opener.setBidSuccessCode(value1,value2,value3);
 	this.close();
}

</script>  
<body onload="init(); " >
	<form id ="searchCondition" name="searchCondition" method = "post" onsubmit="return false" >
        <input type="hidden" name="s_SAVENAME">		
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다-->
	<div id="popWrapper" style="height:214px; min-height: 100px;">
    	<div id="popHeader">
        	<h1 class="title">단독입찰사유</h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/<%=_closeImgSrc %>" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer">
             <table class="cont_t_list05">
				<tr>
                	<td>단독입찰사유</td>
                	<td style="border-right-width: 0px">
						<input type="radio" id="agentType1" name="st_reason_type" style="vertical-align: text-bottom;" value="1">&nbsp;<label for="1">고객사 지정 협력사</label><br>
						<input type="radio" id="agentType2" name="st_reason_type" style="vertical-align: text-bottom;" value="2">&nbsp;<label for="2">GPL</label><br>
						<input type="radio" id="agentType3" name="st_reason_type" style="vertical-align: text-bottom;" value="3">&nbsp;<label for="3">거래조건 충족 협력사(거래조건:배송유형, 재고운영 등)</label><br>
						<input type="radio" id="agentType4" name="st_reason_type" style="vertical-align: text-bottom;" value="4">&nbsp;<label for="4">선입고/선진행</label><br>
						<input type="radio" id="agentType5" name="st_reason_type" style="vertical-align: text-bottom;" value="5">&nbsp;<label for="5">최상위 유통레벨</label><br>
						<input type="radio" id="agentType6" name="st_reason_type" style="vertical-align: text-bottom;" value="6">&nbsp;<label for="6">선정 협력사 견적 재진행(재진행 사유:추가Nego 등)</label><br>
						<input type="radio" id="agentType7" name="st_reason_type" style="vertical-align: text-bottom;" value="7">&nbsp;<label for="7">기타 상세사유 입력</label><br>
                    </td>
				</tr>
            </table>
            
            <tr>
                    <td colspan="2">
                        <textarea name="st_sol_agent_remark" id="st_sol_agent_remark"  style="width:100%;ime-mode:active; overflow:auto;" rows="4" cols="35"></textarea>
                    </td>
                </tr>
	       	<div class="btnArea ac" style="margin-bottom:0px;">
			     <span class="fr btn_02"><a href="javascript:kepConfirm()">확인</a></span>
			</div>
        </div>
    </div>
    </form>
</body>
</html>
