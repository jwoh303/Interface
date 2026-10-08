<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<!doctype html>
<html>
<head>
<%@ include file="../../common/include/head_pop.jspf"  %>
</head>
<%
@SuppressWarnings (value="unchecked")
List<Map<String,String>> _dataList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된결과  
String COM_TYPE = CommonUtil.nvl((String) request.getParameter("COM_TYPE"),"");  //  (조회조건)
String COM_NAME_LOC = CommonUtil.nvl((String) request.getParameter("COM_NAME_LOC"),"");  //  (조회조건) 
String COMORG_NAME = CommonUtil.nvl((String) request.getParameter("COMORG_NAME"),"");  //  (조회조건)  
String toContent = CommonUtil.nvl((String) request.getParameter("toContent"),"");  //  to 선택내용
String com_code=  _sessionInfo.getComCode();
String st_user_id  = "";
if(com_code.equals("KRKORE0001")){
	st_user_id  = _sessionInfo.getUserId();	
}
%>
<script type="text/javascript"> 
function setQuery()
{  	
	if (kepIsEmpty("COM_TYPE")==true && kepIsEmpty("COM_NAME_LOC")==true && kepIsEmpty("COMORG_NAME")==true){
	    alert("검색조건을 입력하세요.");
		return;
	} 

	var tot_cnt = 0;
	if ($('#content tr').size()>0){
		tot_cnt = $('#content tr').size();
	}
	
	var tmptmp = "";
	for(var i = 0; i < tot_cnt; i++){   
		var tmp = $("input[name=chkCodeResult]").eq(i).val() ; 
		tmptmp = tmptmp + tmp+"$";
	} 
	
  $("#toContent").val(tmptmp);	 
  $('#safetyCompanyCodePop').attr("action", "/common/commonList.do").submit();    
}

function kepEnter() {	
	if (event.keyCode == 13) { 
		setQuery();
	}
}
function setReturn(value1,value2)
{ 
  opener.setPopupReturn(value1,value2);
  this.close();
}

function SelectCompany(){  
	var tot_cnt = 0;
	if ($('#content tr').size()>0){
		tot_cnt = $('#content tr').size();
	}
	
	var tmptmp1 = "";
	var tmptmp2 = "";
	if (tot_cnt == 1){
		var tmp = $("input[name=chkCodeResult]").eq(0).val() ; 
		var arrKey = tmp.split("@");
		tmptmp1 = tmptmp1 + arrKey[0]+"@";
		tmptmp2 = tmptmp2 + arrKey[1]+"@";
		
	} else {
	
		for(var i = 0; i < tot_cnt; i++){   
			var tmp = $("input[name=chkCodeResult]").eq(i).val() ; 
			var arrKey = tmp.split("@");
			tmptmp1 = tmptmp1 + arrKey[0]+"@";
			tmptmp2 = tmptmp2 + arrKey[1]+"@";
		}
	}
	setReturn(tmptmp1,tmptmp2);
}

function addRow(){
	var form =  document.forms[0]; 
	var tot_cnt = form.count.value;   
	var result = ""; 
	var size = $("#content tr").size();
	
	//고객사 선택시에 최대 10개까지만 선택 가능하게 수정
	/*
	for(var i = 0; i < tot_cnt; i++){
		var box = eval("document.forms.safetyCompanyCodePop.checkbox" + (i));
		if(box.checked == true){
			size += 1;
			if(size > 10){
				alert("고객사는 최대 10개까지만 선택 가능합니다.");
				return;
			}
		}
	}
	*/
	if (tot_cnt==0) { alert("선택하신 목록이 없습니다."); return; }
	 
	if (tot_cnt == 1){
		var box = eval("document.forms.safetyCompanyCodePop.checkbox0");
		if(box.checked == true){
			box.checked = false;
			var arrKey = box.value.split("@");
			if (dupCheck(arrKey[0])==true) return;
			result = result + "<tr><td><input type='checkbox' name='chkCodeResult' id='chkCodeResult' checked='checked' value='"+arrKey[0] +"@"+arrKey[1] +"'></td><td class='left'>"+arrKey[1] + " ("+ arrKey[0] +")</td></tr>";
		}
	} else{  
		for(var i = 0; i < tot_cnt; i++){   
			var box = eval("document.forms.safetyCompanyCodePop.checkbox" + (i));
			if(box.checked == true){
				box.checked = false;
				var arrKey = box.value.split("@");
				if (dupCheck(arrKey[0])==true) return;
				result = result + "<tr><td><input type='checkbox' name='chkCodeResult' id='chkCodeResult' checked='checked' value='"+arrKey[0] +"@"+arrKey[1] +"'></td><td class='left'>"+arrKey[1] + " ("+ arrKey[0] +")</td></tr>";
			}
		}
	} 
	$("#content").append(result);
}
 
function removeRow() {
	var chkObj = $("#tblSelCompany input:checkbox[name=chkCodeResult]:checked");
	
	if(chkObj != null && chkObj.length <= 0){
		alert("삭제 할 목록을 선택해주십시오.");
		return;
	}
	
	for(var inx = 0 ; inx < chkObj.length ; inx++){
		$(chkObj[inx]).parent().parent().remove();
	}
	
	chkObj = eval("document.forms.safetyCompanyCodePop.chkCodeResult");
	if(chkObj != null && chkObj.length > 0){
		for(var inx = 0 ; inx < chkObj.length ; inx++){
			chkObj[inx].checked = true;
		}
	}
}

function dupCheck(value){ 
	
	var tot_cnt = 0;
	if ($('#content tr').size()>0){
		tot_cnt = $('#content tr').size();
	}
	
	for(var i = 0; i < tot_cnt; i++){   
		var tmp = $("input[name=chkCodeResult]").eq(i).val() ;
		var arrKey = tmp.split("@");
	    if (arrKey[0] == value){
// 	    	alert(tmp + " 코드 중복입니다.");
	    	alert("해당 회원사가 이미 선택되어 있습니다.");
	    	return true;
	    }
	}
	
	return false;
	
}

function kepOnload(){
    
	var tmp = $("#toContent").val();
	var result = ""; 
	if (tmp != ""){
		var tmp2 = tmp.split("$"); 
		for (var i=0; i<eval(tmp2.length)-1; i++){
			var tmp3 = tmp2[i].split("@");
			result = result + "<tr><td><input type='checkbox' name='chkCodeResult' id='chkCodeResult' checked='checked' value='"+tmp3[0] +"@"+tmp3[1] +"'></td><td class='left'>"+tmp3[1] + " ("+ tmp3[0] +")</td></tr>";
	
		}
		$("#content").html(result);
	}
	
	$("#COM_TYPE").focus();
}


</script> 
<body onload="kepOnload();"> 
<%--  window.onblur=function(){if(!opener.closed) window.focus();}">  --%>
	 <form name=safetyCompanyCodePop id=safetyCompanyCodePop method=post >
	 <input type="hidden" name="codeGubun" id="codeGubun"  value="safetyCompanyCodePop"> 
	 <input type="hidden" name="toContent" id="toContent"  value="<%=toContent%>">  
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다-->
	<div id="popWrapper" style="height:444px; min-height: 100px;">
    	<div id="popHeader">
        	<h1 class="title">고객사</h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/<%=_closeImgSrc %>" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer">
        	<div style="height:348px;">
            	<!--왼쪽영역-->
           	    <div style="width:45%; height:330px; float:left;">
               		<div id="cont_searchA">
                        <table class="cont_t_list01" style="width:100%">
                            <caption>고객사 리스트</caption>
                            <colgroup>
                                <col width="50px" />
                                <col width="*" />
                                <col width="50px" />
                            </colgroup>
                            <tbody>
                                <tr>
									<td>고객사</td>						
									<td> 
										<input type="hidden" name="COM_TYPE"  id="COM_TYPE" size=20 value="<%=COM_TYPE%>" onkeydown="kepEnter()" class="input_type_text">
										<input type="hidden" name="COM_TYPE"  id="COM_TYPE" size=20 value="<%=COM_TYPE%>" onkeydown="kepEnter()" class="input_type_text">
										<input type=hidden id="st_user_id"  name="st_user_id" value="<%=st_user_id%>">
										<input type="text" class="input_type_text" name="TMP_INPUT" id="TMP_INPUT" width="96px" value="" style="display: none;"> 
										<input type="text" class="input_type_text" name="COM_NAME_LOC" id="COM_NAME_LOC" width="96px" value="<%=COM_NAME_LOC%>" onkeydown="kepEnter()" style="ime-mode:active">
										<td><span class="btn_search"><a href="javascript:setQuery();">조회</a></span> 
		                            </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
					<div class="scrollArea" style="height:280px">
					<!-- 선택할 고객사 -->
					<table  class="cont_t_list02"  style="width:100% ">
	                    <caption>고객사  리스트</caption>
	                    <colgroup>
	                        <col width="10%" /> 
	                        <col width="*" />  
	                    </colgroup>
	                    <thead>
	                        <tr>
                            <th scope="col">
<%
if (_dataList == null || _dataList.size() == 0){
}else{ 
%>                            
                            <input type="checkbox" name="check_status" id="check_status" value="선택"  style="cursor:pointer;" onclick="kepCheckAll(document.forms.safetyCompanyCodePop.count.value,document.forms.safetyCompanyCodePop.check_status,'document.forms.safetyCompanyCodePop.checkbox');">
<%
	}
%>      
                            </th>
	                            <th scope="col">고객사</th>  
	                        </tr>
	                    </thead>
	                    <tbody>
		<%
		if (_dataList == null || _dataList.size() == 0){
		%>
		<input type="hidden" name="count" id="count"  value="0"> 
	               		<tr bgcolor="#FFFFFF">
	                        <td colspan="2" align="center" height = "195">
	                        <span class="font1">조회된 데이타가 없습니다.</span>
	                        </td> 
	                    </tr>
		<%}else{
		for (int j=0; j<_dataList.size(); j++) {
			Map<String,String> rowData = _dataList.get(j);
		%> 
                        <tr>
							<td> <input type="checkbox" id = "checkbox<%=j %>" name="checkbox<%=j %>"  value="<%=CommonUtil.nvl(rowData.get("COM_CODE"))+"@"+CommonUtil.nvl(rowData.get("COM_NAME"))+"@"+CommonUtil.nvl(rowData.get("CLEVEL"))+"@"+CommonUtil.nvl(rowData.get("COMG_CODE"))%>">
							</td> 
							<td class="left"><%=CommonUtil.nvl(rowData.get("COM_NAME"))%>&nbsp;(<%=CommonUtil.nvl(rowData.get("COM_CODE"))%>)</td> 
                        </tr> 
		<% } %>
			<input type="hidden" name="count" id="count"  value="<%=_dataList.size()%>"> 
		<%}%>                                   
		                    </tbody>
		                </table> 
	                </div> 	
                </div>
                <!--//왼쪽영역끝-->
                <div style="width:40px; height:210px; float:left; padding:150px 0px 0 14px;">
                	<a href="javascript:addRow()"><img src="/resources/images/btn_rightarrow.gif" alt="이동버튼" /></a>
                	<a href="javascript:removeRow()"><img src="/resources/images/btn_leftarrow.gif" alt="이동버튼" style="margin-top: 10px;"/></a>
                </div>
                <!--오른쪽영역-->
                <div style="width:45%; height:330px; float:left;">
                	<h2 class="popTit" style="margin-bottom:34px;">선택된 고객사</h2>
 				        <!-- 선택 고객사 -->
						<div class="scrollArea" style="height:280px">
						<table id="tblSelCompany" class="cont_t_list02"  style="width:100%" >
			                    <caption>선택된 고객사</caption>
			                    <colgroup>
			                        <col width="10%" /> 
	                        		<col width="*" />  
			                    </colgroup>
			                    <thead>
			                        <tr>
			                            <th scope="col">선택</th> 
	                            		<th scope="col">고객사</th>  
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
			<div class="btnArea">
				<%
 				if (_dataList == null || _dataList.size() == 0){ 
 				}else{ %> 
		             	<!--버튼이 2글자일때 class="btn_02",버튼이 3글자일때 class="btn_03",버튼이 4글자일때 class="btn_04" 글자수와 class숫자가 동일 최대 10글자까지 가능-->
				<span class="fr">
					<span class="btn_02 mr04 mb20"><a href="javascript:SelectCompany()" >확인</a></span>
				</span>                	
 	          	<%} %> 
            </div>
        </div>
    </div>
</form>
</body>
</html>
