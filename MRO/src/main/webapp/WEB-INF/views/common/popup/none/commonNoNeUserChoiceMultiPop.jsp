<%--
**********************************************
* 메뉴 : 
* 화면 : 사용자 선택 (다건) 팝업
* 기능 : 사용자 여러명 선택 할 수 있는 팝업
* 프로그램 ID : 
* 담당자 :  현명환
* 착수일 :
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
<%@ include file="../../../common/include/head_pop.jspf"  %>
</head>
<%
@SuppressWarnings (value="unchecked")
List<Map<String,String>> _dataList = (List<Map<String,String>>) request.getAttribute("data"); 		// 조회된 결과 

String st_comorg_value = "";


String st_comorg_type = CommonUtil.nvl((String) request.getParameter("st_comorg_type"),st_comorg_value);  		//  (조회조건)
String st_com_name_loc =  CommonUtil.nvl((String) request.getParameter("st_com_name_loc"), ""); 	//  (조회조건)
String st_user_name = CommonUtil.nvl((String) request.getParameter("st_user_name"),"");  	//  (조회조건)
String st_select_data_list = CommonUtil.nvl((String) request.getParameter("st_select_data_list"),"");  	//  (조회조건)

%>

<script type="text/javascript">
// <!--

function checkAll(){
	var chechboxCnt = $('input:checkbox[name="inCheckBox"]').length;
	var chk_stat = document.forms.CommonNoNeBuyerChoiceMultiPop.check_status.checked;

	if(chechboxCnt == 0){
		alert("조회된 데이터가 없습니다.");
		return;
	}
	for(var i=0; i<chechboxCnt; i++){
		$("input:checkbox[name=inCheckBox]")[i].checked = chk_stat;
	}
}

function addCompany(){
	var schCompObj = $("#tblSchComp input:checkbox[name=inCheckBox]:checked");
	
	if(schCompObj.length <= 0){
		alert("선택된 고객사가 존재 하지 않습니다.");
		return;
	}
	
	var selCompObj = $("#tblSelComp tbody tr");
	var strAddRow = "";
	
	var com_code = "";
	var com_name_loc = "";
	var user_name_loc = "";
	var mobile_phone = "";
	
	for(var inx = 0 ; inx < schCompObj.length ; inx++){
		
		com_code = $(schCompObj[inx]).val();
		com_name_loc = $(schCompObj[inx]).parent().parent().find("input:hidden[name=com_name_loc]").val();
		user_name_loc = $(schCompObj[inx]).parent().parent().find("input:hidden[name=user_name_loc]").val();
		mobile_phone = $(schCompObj[inx]).parent().parent().find("input:hidden[name=mobile_phone]").val();
		/*
		if($(selCompObj).find("input:hidden[name=com_code]:input[value=" + com_code + "]").length > 0){
			alert(com_code+"@"+com_name_loc+"코드가 중복되었습니다.");
			$(schCompObj[inx]).attr("checked", false);
			return;
		}else{
			strAddRow   = "";
			strAddRow += "<tr>";
			strAddRow += "    <td>";
			strAddRow += "        <input type=\"checkbox\" name=\"inCheckBox\" value=\""+com_code+"\" checked=\"checked\" />";
			strAddRow += "        <input type=\"hidden\" name=\"user_name_loc\" value=\""+user_name_loc+"\" />";
			strAddRow += "        <input type=\"hidden\" name=\"mobile_phone\" value=\""+mobile_phone+"\" />";
			strAddRow += "        <input type=\"hidden\" name=\"com_code\" value=\""+com_code+"\" />";
			strAddRow += "        <input type=\"hidden\" name=\"com_name_loc\" value=\""+com_name_loc+"\" />";
			strAddRow += "    </td>";
			strAddRow += "    <td class=\"left\">"+com_name_loc+"</td>";
			strAddRow += "    <td class=\"left\">"+user_name_loc+"</rd>";
			strAddRow += "    <td class=\"left\">"+mobile_phone+"</rd>";
			strAddRow += "</tr>";
			
			$("#tblSelComp tbody").append(strAddRow);
			$(schCompObj[inx]).attr("checked", false);
		}
		*/
		strAddRow   = "";
		strAddRow += "<tr>";
		strAddRow += "    <td>";
		strAddRow += "        <input type=\"checkbox\" name=\"inCheckBox\" value=\""+com_code+"\" checked=\"checked\" />";
		strAddRow += "        <input type=\"hidden\" name=\"user_name_loc\" value=\""+user_name_loc+"\" />";
		strAddRow += "        <input type=\"hidden\" name=\"mobile_phone\" value=\""+mobile_phone+"\" />";
		strAddRow += "        <input type=\"hidden\" name=\"com_code\" value=\""+com_code+"\" />";
		strAddRow += "        <input type=\"hidden\" name=\"com_name_loc\" value=\""+com_name_loc+"\" />";
		strAddRow += "    </td>";
		strAddRow += "    <td class=\"left\">"+com_name_loc+"</td>";
		strAddRow += "    <td class=\"left\">"+user_name_loc+"</rd>";
		strAddRow += "    <td class=\"left\">"+mobile_phone+"</rd>";
		strAddRow += "</tr>";
		
		$("#tblSelComp tbody").append(strAddRow);
		$(schCompObj[inx]).attr("checked", false);
	}
}

function delCompany(){
	var schCompObj = $("#tblSelComp input:checkbox[name=inCheckBox]:checked");
	
	if(schCompObj.length <= 0){
		alert("삭제 할 고객사가 존재 하지 않습니다.");
		return;
	}
	
	for(var inx = 0 ; inx < schCompObj.length ; inx++){
		$(schCompObj[inx]).parent().parent().remove();
	}
}

function addGrpComp(){
	var schCompObj = $("#tblSchComp tbody input:checkbox[name=inCheckBox]:checked");
	
	if(schCompObj.length <= 0){
		alert("선택된 고객사가 존재 하지 않습니다.");
		return;
	}
	
	var arryComorg_code = new Array();
	var schComorg_code = "";
	
	for(var inx = 0 ; inx < schCompObj.length; inx++){
		schComorg_code = $(schCompObj[inx]).parent().find("input:hidden[name=user_name_loc]").val();
		arryComorg_code.push(schComorg_code);
		$(schCompObj[inx]).attr("checked", false);
	}
	
	arryComorg_code = $.unique(arryComorg_code);
	
	var com_code = "";
	var com_name_loc = "";
	var user_name_loc = "";
	var mobile_phone = "";
	
	var selCompObj = $("#tblSelComp tbody tr");
	var selComorg_code_cnt = 0;
	var strAddRow = "";
	
	for(var inx = 0 ; inx < arryComorg_code.length ; inx++){
		schCompObj = $("#tblSchComp tbody").find("input:hidden[name=user_name_loc]:input[value=" + arryComorg_code[inx] + "]");
		selComorg_code_cnt = $("#tblSelComp tbody").find("input:hidden[name=user_name_loc]:input[value=" + arryComorg_code[inx] + "]").length;
		for(var i = 0 ; i < schCompObj.length; i++){
			com_code = $(schCompObj[i]).parent().find("input:hidden[name=com_code]").val();
			com_name_loc = $(schCompObj[i]).parent().find("input:hidden[name=com_name_loc]").val();
			user_name_loc = $(schCompObj[i]).parent().find("input:hidden[name=user_name_loc]").val();
			mobile_phone = $(schCompObj[i]).parent().find("input:hidden[name=mobile_phone]").val();
			
			if($(selCompObj).find("input:hidden[name=com_code]:input[value=" + com_code + "]").length > 0){
				continue;
			}
			
			strAddRow   = "";
			strAddRow += "<tr>";
			strAddRow += "    <td>";
			strAddRow += "        <input type=\"checkbox\" name=\"inCheckBox\" value=\""+com_code+"\" checked=\"checked\" />";
			strAddRow += "        <input type=\"hidden\" name=\"user_name_loc\" value=\""+user_name_loc+"\" />";
			strAddRow += "        <input type=\"hidden\" name=\"mobile_phone\" value=\""+mobile_phone+"\" />";
			strAddRow += "        <input type=\"hidden\" name=\"com_code\" value=\""+com_code+"\" />";
			strAddRow += "        <input type=\"hidden\" name=\"com_name_loc\" value=\""+com_name_loc+"\" />";
			strAddRow += "    </td>";
			strAddRow += "    <td class=\"left\">"+com_name_loc+"</td>";
			strAddRow += "    <td class=\"left\">"+user_name_loc+"</rd>";
			strAddRow += "    <td class=\"left\">"+mobile_phone+"</rd>";
			strAddRow += "</tr>";
			
			if(selComorg_code_cnt > 0){
				$("#tblSelComp tbody").find("input:hidden[name=user_name_loc]:input[value=" + arryComorg_code[inx] + "]").last().parent().parent().after(strAddRow);
			}else{
				$("#tblSelComp tbody").append(strAddRow);
			}
		}
	}
}

function delGrpComp(){
	var schCompObj = $("#tblSelComp input:checkbox[name=inCheckBox]:checked");
	
	if(schCompObj.length <= 0){
		alert("삭제 할 고객사가 존재 하지 않습니다.");
		return;
	}
	
	var selOrgCompObj = null;
	var selOrgComCode = null;
	for(var inx = 0 ; inx < schCompObj.length ; inx++){
		selOrgComCode = $(schCompObj[inx]).parent().find("input:hidden[name=user_name_loc]").val();
		selOrgCompObj = $("#tblSelComp tbody").find("input:hidden[name=user_name_loc]:input[value=" + selOrgComCode + "]");
		if(selOrgCompObj != null && selOrgCompObj.length > 0){
			for(var i = 0 ; i < selOrgCompObj.length ; i++){
				$(selOrgCompObj).parent().parent().remove();
			}
		}
	}
}

function kepSearch(){
	if($("input:radio[name=st_comorg_type]:checked").val() == "ALL"){
		if(isEmpty($("#st_com_name_loc").val()) && isEmpty($("#st_user_name").val())){
			alert("검색 조건을 입력 하세요.");
			return;			
		}
	}
	
	var com_code = "";
	var com_name_loc = "";
	var user_name_loc = "";
	var mobile_phone = "";
	
	var selCompObj = $("#tblSelComp tbody tr");
	var st_select_data_list = "";
	if(selCompObj != null && selCompObj.length > 0){
		for(var inx = 0 ; inx < selCompObj.length; inx++){
			if(selCompObj.length == 1){
				com_code = $(selCompObj[inx]).find("input:hidden[name=com_code]").val() + "@";
				com_name_loc = $(selCompObj[inx]).find("input:hidden[name=com_name_loc]").val() + "@";
				user_name_loc = $(selCompObj[inx]).find("input:hidden[name=user_name_loc]").val() + "@";
				mobile_phone = $(selCompObj[inx]).find("input:hidden[name=mobile_phone]").val() + "@";
				
				st_select_data_list = st_select_data_list + com_code+com_name_loc+user_name_loc+mobile_phone+"|";
			}else{
				com_code =   $(selCompObj[inx]).find("input:hidden[name=com_code]").val() + "@";
				com_name_loc =   $(selCompObj[inx]).find("input:hidden[name=com_name_loc]").val() + "@";
				user_name_loc =  $(selCompObj[inx]).find("input:hidden[name=user_name_loc]").val() + "@";
				mobile_phone =  $(selCompObj[inx]).find("input:hidden[name=mobile_phone]").val() + "@";
				
				st_select_data_list = st_select_data_list + com_code+com_name_loc+user_name_loc+mobile_phone+"|";
			}
		}
	}
	
	$('#st_select_data_list').val(st_select_data_list); 	
	$('#CommonNoNeBuyerChoiceMultiPop').attr("action", "/none/getCommonNoNeUserChoiceMultiPop.do").submit();    
}

function kep_onload(){ 	
	
	var strAddRow = "";
	var tmp = $('#st_select_data_list').val(); 
	 
	var tmpArray = tmp.split("|"); 
	if (tmpArray != ""){ 
		for (var i = 0 in  tmpArray){  
			var tmpArrayReal = tmpArray[i].split("@");  
 
				if (tmpArrayReal != ""){
					strAddRow += "<tr>";
					strAddRow += "    <td>";
					strAddRow += "        <input type=\"checkbox\" name=\"inCheckBox\" value=\""+tmpArrayReal[0]+"\" checked=\"checked\" />";
					strAddRow += "        <input type=\"hidden\" name=\"user_name_loc\" value=\""+tmpArrayReal[2]+"\" />";
					strAddRow += "        <input type=\"hidden\" name=\"mobile_phone\" value=\""+tmpArrayReal[3]+"\" />";
					strAddRow += "        <input type=\"hidden\" name=\"com_code\" value=\""+tmpArrayReal[0]+"\" />";
					strAddRow += "        <input type=\"hidden\" name=\"com_name_loc\" value=\""+tmpArrayReal[1]+"\" />";
					strAddRow += "    </td>";
					strAddRow += "    <td class=\"left\">"+tmpArrayReal[1]+"</td>";
					strAddRow += "    <td class=\"left\">"+tmpArrayReal[2]+"</rd>";
					strAddRow += "    <td class=\"left\">"+tmpArrayReal[3]+"</rd>";
					strAddRow += "</tr>"; 
				}
			}
	 
	}
	
	$("#tblSelComp tbody").append(strAddRow);
}

function kepEnter() {	
	if (event.keyCode == 13) { 
		kepSearch();
	}
}

function setReset(){
	document.location.href = "/none/showCommonNoNeUserChoiceMultiPop.do";
}

function setReturn(){
	
	var com_code = "";
	var com_name_loc = "";
	var user_name_loc = "";
	var mobile_phone = "";
	
	var selCompObj = $("#tblSelComp tbody tr");
	
	if(selCompObj != null && selCompObj.length > 0){
		for(var inx = 0 ; inx < selCompObj.length; inx++){
			if(selCompObj.length == 1){
				com_code = $(selCompObj[inx]).find("input:hidden[name=com_code]").val();
				com_name_loc = $(selCompObj[inx]).find("input:hidden[name=com_name_loc]").val();
				user_name_loc = $(selCompObj[inx]).find("input:hidden[name=user_name_loc]").val();
				mobile_phone = $(selCompObj[inx]).find("input:hidden[name=mobile_phone]").val();
			}else{
				com_code = com_code +  $(selCompObj[inx]).find("input:hidden[name=com_code]").val() + "@";
				com_name_loc = com_name_loc +  $(selCompObj[inx]).find("input:hidden[name=com_name_loc]").val() + "@";
				user_name_loc = user_name_loc + $(selCompObj[inx]).find("input:hidden[name=user_name_loc]").val() + "@";
				mobile_phone = mobile_phone + $(selCompObj[inx]).find("input:hidden[name=mobile_phone]").val() + "@";
			}
		}
	}
	opener.setPopupReturn(com_code,com_name_loc,user_name_loc,mobile_phone);
	this.close();
}
 //-->
</script> 
<body onload="kep_onload()">
	 <form name=CommonNoNeBuyerChoiceMultiPop id=CommonNoNeBuyerChoiceMultiPop method=post >
	 <input type="hidden"  name="st_select_data_list"  id="st_select_data_list" value="<%=st_select_data_list %>"/>
	 
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다-->
	<div id="popWrapper" style="height:494px; min-height: 100px;">
    	<div id="popHeader">
        	<h1 class="title">사용자 검색</h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/<%=_closeImgSrc %>" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer">
        	<div style="height:360px;">
        		<div id="cont_searchA">
					<table class="cont_t_list01" style="width:100%">
						<caption>구매사(고객사) 리스트</caption>
						<colgroup>
							<col width="7%" />
							<col width="38%" />
							<col width="7%" />
							<col width="38%" />
							<col width="10%" />
						</colgroup>
						<tbody>
							<tr>
								<td>회원사</td>
								<td>  
									<input type="text" class="input_type_text" name="st_com_name_loc" id="st_com_name_loc" value="<%=st_com_name_loc %>" onkeydown="kepEnter()" style="ime-mode:active; width : 80%; ">
								</td>
								<td>사용자</td>
								<td>  
									<input type="text" class="input_type_text" name="st_user_name" id="st_user_name" value="<%=st_user_name %>" onkeydown="kepEnter()" style="ime-mode:active; width : 80%;">
								</td>
							</tr>
							<tr>
								<td>검색옵션</td>
								<td colspan="2">
									<input type="radio" class="Noborder"  id="st_comorg_type" name="st_comorg_type" value="B2B" <%if(st_comorg_type.equals("") ||st_comorg_type.equals("B2B")){ out.print("checked=\"checked\""); } %> />Koreab2b&nbsp;
									<input type="radio" class="Noborder"  id="st_comorg_type" name="st_comorg_type" value="SAFETY" <%if(st_comorg_type.equals("SAFETY")){ out.print("checked=\"checked\""); } %>/>건설MRO &nbsp;
									<input type="radio" class="Noborder"  id="st_comorg_type" name="st_comorg_type" value="KWAY" <%if(st_comorg_type.equals("KWAY")){ out.print("checked=\"checked\""); } %>/>유통 &nbsp;
								</td>
								<td class="right" colspan="2">
									<span class="btn_search"><a href="javascript:kepSearch();">조회</a></span>
									<span class="btn_reset"><a href="javascript:setReset();">초기화</a></span>
								</td>
							</tr>
						</tbody>
					</table>
				</div>
            	<!--왼쪽영역-->
           	    <div style="width:45%; height:320px; float:left;">
					<div class="scrollArea" style="height:308px">
					<!-- 선택할 고객사 -->
					<table id="tblSchComp"  class="cont_t_list02"  style="width:100% ">
		                    <caption>사용자 선택 리스트</caption>
		                    <colgroup>
		                        <col width="15%" /> 
		                        <col width="35%" />  
		                        <col width="20%" /> 
		                        <col width="*" />  
		                    </colgroup>
		                    <thead>
		                        <tr>
									<th scope="col">
<%
if (_dataList == null || _dataList.size() == 0){
}else{ 
%>                            
                            <input type="checkbox" name="check_status" id="check_status" value="선택"  style="cursor:pointer;" onclick="checkAll();">
<%
	}
%>      
		                            선택</th> 
		                            <th scope="col">회원사</th>  
		                            <th scope="col">사용자명</th>  
		                            <th scope="col">휴대폰</th>
		                        </tr>
		                    </thead>
		                    <tbody>
<%
if (_dataList == null || _dataList.size() == 0){
%>
			               		<tr bgcolor="#FFFFFF">
			                        <td colspan="4" align="center" height = "250">
			                        <span class="font1">조회된 데이타가 없습니다.</span>
			                        </td>
			                    </tr>
<%}else{
	for (int j=0; j<_dataList.size(); j++) {
		Map<String,String> rowData = _dataList.get(j);
%> 
								<tr>
									<td >
										<input type="checkbox" name="inCheckBox" value="<%=CommonUtil.nvl(rowData.get("COM_CODE"))%>" />
										<input type="hidden" name="user_name_loc" value="<%=CommonUtil.nvl(rowData.get("USER_NAME_LOC"))%>" />
										<input type="hidden" name="mobile_phone" value="<%=CommonUtil.nvl(rowData.get("MOBILE_PHONE"))%>" />
										<input type="hidden" name="com_code" value="<%=CommonUtil.nvl(rowData.get("COM_CODE"))%>" />
										<input type="hidden" name="com_name_loc" value="<%=CommonUtil.nvl(rowData.get("COM_NAME_LOC"))%>" />
									</td>
									<td class="left" ><%=CommonUtil.nvl(rowData.get("COM_NAME_LOC"))%></td>
									<td ><%=CommonUtil.nvl(rowData.get("USER_NAME_LOC"))%></td>
									<td class="left" ><%=CommonUtil.nvl(rowData.get("MOBILE_PHONE"))%></td>
								</tr>
<% } 
}%>
		                    </tbody>
		                </table> 
		                </div> 	
                </div>
                <!--//왼쪽영역끝-->
                <div style="width:80px; height:210px; float:left; padding:80px 7px 0 7px;">
                    <span class="btn_02 mr04"><a href="javascript:addCompany()" >&gt;</a></span>
					<span class="btn_02 mr04"><a href="javascript:delCompany()" >&lt;</a></span>
                    <span class="btn_02 mr04" style="margin-top: 20px;"><a href="javascript:addGrpComp()" >&gt;&gt;</a></span>
					<span class="btn_02 mr04"><a href="javascript:delGrpComp()" >&lt;&lt;</a></span>
                </div>
                
                <!--오른쪽영역-->
                <div style="width:44%; height:320px; float:left;">
 				        <!-- 선택 고객사 -->
						<div class="scrollArea" style="height:308px">
						<table id="tblSelComp" class="cont_t_list02"  style="width:100%" >
			                    <caption>선택된 고객사</caption>
			                    <colgroup>
			                        <col width="10%" /> 
			                        <col width="35%" />  
			                        <col width="20%" /> 
			                        <col width="*" />  
			                    </colgroup>
			                    <thead>
			                        <tr>
			                            <th scope="col">선택</th> 
			                            <th scope="col">회원사</th>  
			                            <th scope="col">사용자명</th>  
			                            <th scope="col">휴대폰</th>
			                        </tr>
			                    </thead>
			                    <tbody id="content">
			                    </tbody>
						</table>                    
			         	</div>

                </div>
                <!--//오른쪽영역-->
            </div>
       		<!--버튼영역-->
			<div class="btnArea ac" style="margin-bottom:0px; margin-top: 0px;"> 
			     <span class="fr btn_02"><a href="javascript:self.close()">닫기</a></span>
			     <span class="fr btn_02" style="margin-right: 10px;"><a href="javascript:setReturn();">확인</a></span>
			</div>
        </div>
    </div>
</form>
</body>
</html>
