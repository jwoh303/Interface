<%--
**********************************************
* 메뉴 : 
* 화면 : 부서 선택 (다건) 팝업
* 기능 : 부서를 여러건 선택 할 수 있는 팝업
* 프로그램 ID :
* 담당자 :  HSJ ( 설계 : 공통 )
* 착수일 : 2023-09-18
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
String st_buyer = CommonUtil.nvl((String) request.getParameter("st_buyer"),"");  	//  (조회조건)

String st_dept_name =  CommonUtil.nvl((String) request.getParameter("st_dept_name"), ""); 	//  (조회조건)
String st_select_data_list = CommonUtil.nvl((String) request.getParameter("st_select_data_list"),"");  	//  (조회조건)

%>

<script type="text/javascript">
//
var st_buyer = "<%=st_buyer%>";

function checkAll(){
	var chechboxCnt = $('input:checkbox[name="inCheckBox"]').length;
	var chk_stat = document.forms.CommonNoNeDeptChoiceMultiPop.check_status.checked;

	if(chechboxCnt == 0){
		alert("조회된 데이터가 없습니다.");
		return;
	}
	for(var i=0; i<chechboxCnt; i++){
		$("input:checkbox[name=inCheckBox]")[i].checked = chk_stat;
	}
}

function addDept(){
	var schCompObj = $("#tblSchComp input:checkbox[name=inCheckBox]:checked");
	
	if(schCompObj.length <= 0){
		alert("추가할 부서를 선택하세요.");
		return;
	}
	
	var selCompObj = $("#tblSelComp tbody tr");
	var strAddRow = "";
	
	var dept_code = "";
	var dept_name = "";
	
	for(var inx = 0 ; inx < schCompObj.length ; inx++){
		
		dept_code = $(schCompObj[inx]).val();
		dept_name = $(schCompObj[inx]).parent().parent().find("input:hidden[name=dept_name]").val();
		
		if($(selCompObj).find("input:hidden[name=dept_code]:input[value=" + dept_code + "]").length > 0){
			alert(dept_code+"@"+dept_name+"코드가 중복되었습니다.");
			$(schCompObj[inx]).attr("checked", false);
			return;
		}else{
			strAddRow   = "";
			strAddRow += "<tr>";
			strAddRow += "    <td>";
			strAddRow += "        <input type=\"checkbox\" name=\"inCheckBox\" value=\""+dept_code+"\" checked=\"checked\" />";
			strAddRow += "        <input type=\"hidden\" name=\"dept_code\" value=\""+dept_code+"\" />";
			strAddRow += "        <input type=\"hidden\" name=\"dept_name\" value=\""+dept_name+"\" />";
			strAddRow += "    </td>";
			strAddRow += "    <td class=\"left\">"+dept_name+"</td>";
			strAddRow += "    <td class=\"left\">"+dept_code+"</rd>";
			strAddRow += "</tr>";
			
			$("#tblSelComp tbody").append(strAddRow);
			$(schCompObj[inx]).attr("checked", false);
		}
	}
}

function delDept(){
	var schCompObj = $("#tblSelComp input:checkbox[name=inCheckBox]:checked");
	
	if(schCompObj.length <= 0){
		alert("삭제할 부서를 선택하세요.");
		return;
	}
	
	for(var inx = 0 ; inx < schCompObj.length ; inx++){
		$(schCompObj[inx]).parent().parent().remove();
	}
}

function kepSearch(){
	var dept_code = "";
	var dept_name = "";
	
	var selCompObj = $("#tblSelComp tbody tr");
	var st_select_data_list = "";
	if(selCompObj != null && selCompObj.length > 0){
		for(var inx = 0 ; inx < selCompObj.length; inx++){
			if(selCompObj.length == 1){
				dept_code = $(selCompObj[inx]).find("input:hidden[name=dept_code]").val() + "@";
				dept_name = $(selCompObj[inx]).find("input:hidden[name=dept_name]").val() + "@";
				
				st_select_data_list = st_select_data_list + dept_code + dept_name+"|";
			}else{
				dept_code =   $(selCompObj[inx]).find("input:hidden[name=dept_code]").val() + "@";
				dept_name =   $(selCompObj[inx]).find("input:hidden[name=dept_name]").val() + "@";
				
				st_select_data_list = st_select_data_list + dept_code + dept_name+"|";
			}
		}
	}
	
	$('#st_select_data_list').val(st_select_data_list);
	$('#CommonNoNeDeptChoiceMultiPop').attr("action", "/none/getCommonNoNeDeptChoiceMultiPop.do").submit();    
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
					strAddRow += "        <input type=\"hidden\" name=\"dept_code\" value=\""+tmpArrayReal[0]+"\" />";
					strAddRow += "        <input type=\"hidden\" name=\"dept_name\" value=\""+tmpArrayReal[1]+"\" />";
					strAddRow += "    </td>";
					strAddRow += "    <td class=\"left\">"+tmpArrayReal[1]+"</td>";
					strAddRow += "    <td class=\"left\">"+tmpArrayReal[0]+"</rd>";
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
	document.location.href = "/none/showCommonNoNeDeptChoiceMultiPop.do";
}

function setReturn(){
	
	var dept_code = "";
	var dept_name = "";
	
	var selCompObj = $("#tblSelComp tbody tr");
	
	if(selCompObj != null && selCompObj.length > 0){
		for(var inx = 0 ; inx < selCompObj.length; inx++){
			if(selCompObj.length == 1){
				dept_code = $(selCompObj[inx]).find("input:hidden[name=dept_code]").val();
				dept_name = $(selCompObj[inx]).find("input:hidden[name=dept_name]").val();
			}else{
				dept_code = dept_code +  $(selCompObj[inx]).find("input:hidden[name=dept_code]").val() + "@";
				dept_name = dept_name +  $(selCompObj[inx]).find("input:hidden[name=dept_name]").val() + "@";
			}
		}
	}
	
	opener.setPopupReturn(dept_code,dept_name);
	this.close();
}
 //-->
</script> 
<body onload="kep_onload()">
	 <form name=CommonNoNeDeptChoiceMultiPop id=CommonNoNeDeptChoiceMultiPop method=post >
	 <input type="hidden"  name="st_select_data_list"  id="st_select_data_list" value="<%=st_select_data_list%>"/>
	 <input type="hidden"  name="st_buyer"  id="st_buyer" value="<%=st_buyer%>"/>
	 
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다-->
	<div id="popWrapper" style="height:494px; min-height: 100px;">
    	<div id="popHeader">
        	<h1 class="title">부서 검색</h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/<%=_closeImgSrc %>" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer">
        	<div style="height:360px;">
        		<div id="cont_searchA">
					<table class="cont_t_list01" style="width:100%">
						<caption>부서 리스트</caption>
						<colgroup>
							<col width="7%" />
							<col width="38%" />
							<col width="7%" />
							<col width="*" />
						</colgroup>
						<tbody>
							<tr>
								<td>부서명</td>
								<td>  
									<input type="text" class="input_type_text" name="st_dept_name" id="st_dept_name" value="<%=st_dept_name%>" onkeydown="kepEnter()" style="ime-mode:active; width : 80%; ">
								</td>
								<td></td>
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
		                    <caption>부서 선택 리스트</caption>
		                    <colgroup>
		                        <col width="15%" /> 
		                        <col width="*" />  
		                        <col width="20%" /> 
		                    </colgroup>
		                    <thead>
		                        <tr>
									<th scope="col">
<%
	if (_dataList == null || _dataList.size() == 0){
%>
									선택
<%
	}else{
%>
									<input type="checkbox" name="check_status" id="check_status" value="선택"  style="cursor:pointer;" onclick="checkAll();">
<%
	}
%>
		                            </th> 
		                            <th scope="col">부서명</th>  
		                            <th scope="col">부서코드</th>  
		                        </tr>
		                    </thead>
		                    <tbody>
<%
if (_dataList == null || _dataList.size() == 0){
%>
			               		<tr bgcolor="#FFFFFF">
			                        <td colspan="3" align="center" height = "250">
			                        <span class="font1">조회된 데이타가 없습니다.</span>
			                        </td>
			                    </tr>
<%}else{
	for (int j=0; j<_dataList.size(); j++) {
		Map<String,String> rowData = _dataList.get(j);
%> 
								<tr>
									<td >
										<input type="checkbox" name="inCheckBox" value="<%=CommonUtil.nvl(rowData.get("DEPT_CODE"))%>" />
										<input type="hidden" name="dept_code" value="<%=CommonUtil.nvl(rowData.get("DEPT_CODE"))%>" />
										<input type="hidden" name="dept_name" value="<%=CommonUtil.nvl(rowData.get("DEPT_NAME"))%>" />
									</td>
									<td class="left" ><%=CommonUtil.nvl(rowData.get("DEPT_NAME"))%></td>
									<td ><%=CommonUtil.nvl(rowData.get("DEPT_CODE"))%></td>
								</tr>
<% } 
}%>
		                    </tbody>
		                </table> 
		                </div> 	
                </div>
                <!--//왼쪽영역끝-->
                <div style="width:80px; height:210px; float:left; padding:80px 7px 0 7px;">
                    <span class="btn_02 mr04"><a href="javascript:addDept()" >&gt;</a></span>
					<span class="btn_02 mr04"><a href="javascript:delDept()" >&lt;</a></span>
                </div>
                
                <!--오른쪽영역-->
                <div style="width:44%; height:320px; float:left;">
 				        <!-- 선택 고객사 -->
						<div class="scrollArea" style="height:308px">
						<table id="tblSelComp" class="cont_t_list02"  style="width:100%" >
			                    <caption>선택된 고객사</caption>
			                    <colgroup>
			                        <col width="10%" /> 
			                        <col width="*" />  
			                        <col width="20%" /> 
			                    </colgroup>
			                    <thead>
			                        <tr>
			                            <th scope="col">선택</th> 
			                            <th scope="col">부서명</th>  
			                            <th scope="col">부서코드</th>  
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
