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
String USER_NAME_LOC = CommonUtil.nvl((String) request.getParameter("USER_NAME_LOC"),"");  //  (조회조건
String USER_FLAG = CommonUtil.nvl((String) request.getParameter("USER_FLAG"),"");  //  (조회조건  
String DOCU_NO = CommonUtil.nvl((String) request.getParameter("DOCU_NO"),"");  //  (조회조건 
String toContent = CommonUtil.nvl((String) request.getParameter("toContent"),"");  //  to 선택내용
 
String COMPANY = "";
String SessionUserId = "";
if (_sessionInfo != null){  
	COMPANY =  CommonUtil.nvl((String)_sessionInfo.getComCode()); 
	SessionUserId =  CommonUtil.nvl((String)_sessionInfo.getUserId()); 
} 

//본인결재가 가능한 고객사 특수로직 : 코웨이, 일진다이아몬드
%>
<script type="text/javascript"> 
function setQuery()
{  	
	if (kepIsEmpty("USER_NAME_LOC")==true){
	   // alert("검색조건을 입력하세요.");
	  //  $("#USER_NAME_LOC").focus();
	//	return;
	} 

	var tot_cnt = 0;
	if ($('#content tr').size()>0){
		tot_cnt = $('#content tr').size();
	}
	
	var tmptmp = "";
	for(var i = 0; i < tot_cnt; i++){   
		var tmp = $("input[name=codeResult]").eq(i).val() ; 
		tmptmp = tmptmp + tmp+"$";
	} 
	
  $("#toContent").val(tmptmp);	 
  $('#userSelChoicePop').attr("action", "/common/commonList.do").submit();    
}

function kepEnter() {	
	if (event.keyCode == 13) { 
		setQuery();
	}
}
function setReturn(value1,value2,value3,value4)
{ 
  opener.setPopupApprovalReturn(value1,value2,value3,value4);
  this.close();
}

function SelectCompany(){  
	var tot_cnt = 0;
	if ($('#content tr').size()>0){
		tot_cnt = $('#content tr').size();
	}
	
	var tmptmp1 = "";
	var tmptmp2 = "";
	var tmptmp3 = "<table class='cont_t_list02'  style='width:100%'>";
	var tmptmp4 = "";
	
	var gubunTxt = "";
	if (tot_cnt == 1){
		var tmp = $("input[name=codeResult]").eq(0).val() ; 
		var arrKey = tmp.split("@");
		if (arrKey[0] == "to"){
			tmptmp1 = tmptmp1 + arrKey[2]+",";
			tmptmp2 = tmptmp2 + arrKey[1]+",";
			gubunTxt = "지정";
		}
		tmptmp3 = tmptmp3 + "<tr><td>" + gubunTxt +"</td><td>"+ arrKey[2] + "</td><td>"+arrKey[3]+ "</td><td>"+arrKey[4]+"</tr>";
		tmptmp4 = tmptmp4 + ""+ arrKey[0] + "@"+arrKey[1]+ "@"+arrKey[2] + "@"+arrKey[3] + "@"+arrKey[4] + "@$" ;
	} else {
	
		for(var i = 0; i < tot_cnt; i++){   
			var tmp = $("input[name=codeResult]").eq(i).val() ; 
			var arrKey = tmp.split("@");
			if (arrKey[0] == "to"){
				tmptmp1 = tmptmp1 + arrKey[2]+",";
				tmptmp2 = tmptmp2 + arrKey[1]+",";
				gubunTxt = "지정";
			}
			tmptmp3 = tmptmp3 +"<tr><td>"+ gubunTxt +"</td><td>" +arrKey[2]+ "</td><td>"+arrKey[3]+ "</td><td>"+arrKey[4]+"</tr>";
			tmptmp4 = tmptmp4 +""+ arrKey[0] + "@"+arrKey[1]+ "@"+arrKey[2] + "@"+arrKey[3] + "@"+arrKey[4] + "@$" ;
		}
	}
	tmptmp3 = tmptmp3 +"</table>";
	if(tmptmp1==""){
		alert("사용자가 지정되지 않았습니다. 결재자를 지정 바랍니다.");
		return;
	}
	setReturn(tmptmp1,tmptmp2,tmptmp3,tmptmp4);
} 

function addRow(gubun){
	var form =  document.forms[0]; 
	var tot_cnt = form.count.value;   
	var result = ""; 
	var gubunTxt = "";
	if (gubun == "to"){
		gubunTxt = "지정";
	}
	
	if (tot_cnt==0) { alert("대상이 없습니다."); return; }
	
	 
	if (tot_cnt == 1){
		var box = eval("document.forms.userSelChoicePop.checkbox0");
		if(box.checked == true){   
			var arrKey = box.value.split("@");
			if (dupCheck(arrKey[0])==true) return;
			result = result + "<tr><input type='hidden' name='codeResult' id='codeResult' value='"+gubun+"@"+arrKey[0] +"@"+arrKey[1] +"@"+arrKey[2]+"@"+arrKey[3]+"'><td>"+gubunTxt+"</td><td>"+arrKey[1] +"</td><td>"+arrKey[2] +"</td><td>"+arrKey[3] +"</td><td><a id='row_delete'  onclick='removeRow(this)' href='#'>행삭제</a></td></tr>";
		}
	} else{  
		for(var i = 0; i < tot_cnt; i++){   
			var box = eval("document.forms.userSelChoicePop.checkbox" + (i));
			if(box.checked == true){  
				var arrKey = box.value.split("@");
				if (dupCheck(arrKey[0])==true) return;
				result = result + "<tr><input type='hidden' name='codeResult' id='codeResult' value='"+gubun+"@"+arrKey[0] +"@"+arrKey[1]+"@"+arrKey[2]+"@"+arrKey[3] +"'><td>"+gubunTxt+"</td><td>"+arrKey[1] +"</td><td>"+arrKey[2] +"</td><td>"+arrKey[3] +"</td><td><a id='row_delete'  onclick='removeRow(this)' href='#'>행삭제</a></td></tr>";
			}
		}
	} 
	
	removeCheckbox();
	$("#content").append(result);
}
 
function removeRow(obj) {
    if($('#content tr').size() > 0){
       //alert('삭제');
        $(obj).parent().parent().remove();
    }
    else {
        //alert('처음 행 삭제불가');
        return false;
    }
}

function dupCheck(value){ 
	
	var tot_cnt = 0;
	if ($('#content tr').size()>0){
		tot_cnt = $('#content tr').size();
	}
	
	for(var i = 0; i < tot_cnt; i++){   
		var tmp = $("input[name=codeResult]").eq(i).val() ;
		var arrKey = tmp.split("@");
	    if (arrKey[1] == value){
	    	alert(arrKey[2] +"("+arrKey[1]+")"  + " 코드 중복입니다."); 
	    	return true;
	    }
	} 
	return false;
	
}

function kepOnload(){
    
	var tmp = $("#toContent").val();
	var result = ""; 
	var gubunTxt = "";

	
	if (tmp != ""){
		var tmp2 = tmp.split("$"); 
		for (var i=0; i<eval(tmp2.length)-1; i++){
			var tmp3 = tmp2[i].split("@");
			if (tmp3[0] == "to"){
				gubunTxt = "지정";
			}
			result = result + "<tr><input type='hidden' name='codeResult' id='codeResult' value='"+tmp3[0] +"@"+tmp3[1] +"@"+tmp3[2]  +"@"+tmp3[3] +"@"+tmp3[4]  +"'><td>"+gubunTxt+"</td><td>"+tmp3[2] +"</td><td>"+tmp3[3] +"</td><td>"+tmp3[4] +"</td><td><a id='row_delete'  onclick='removeRow(this)' href='#'>행삭제</a></td></tr>";
	
		}
		$("#content").html(result);
	}
	
	$("#USER_NAME_LOC").focus();
}



function removeCheckbox(){
	var form =  document.forms[0]; 
	var tot_cnt = form.count.value;    
	
	if (tot_cnt == 1){
		var box = eval("document.forms.userSelChoicePop.checkbox0");
		box.checked = false;
	} else{  
		for(var i = 0; i < tot_cnt; i++){   
			var box = eval("document.forms.userSelChoicePop.checkbox" + (i));
			box.checked = false;
		}
	}  
}


</script> 
<body onload="kepOnload();">
	 <form name=userSelChoicePop id=userSelChoicePop method=post >
	 <input type="hidden" name="codeGubun" id="codeGubun"  value="userSelChoicePop"> 
	 <input type="hidden" name="toContent" id="toContent"  value="<%=toContent%>">  
	  <input type="hidden" name="COMPANY" id="COMPANY"  value="<%=COMPANY%>">  
	   <input type="hidden" name="DOCU_NO" id="DOCU_NO"  value="<%=DOCU_NO%>">    
	   <input type="hidden" name="USER_ID" id="USER_ID"  value="<%=SessionUserId%>">  
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다-->
	<div id="popWrapper" style="height:464px;">
    	<div id="popHeader">
        	<h1 class="title">사용자 지정/변경</h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/<%=_closeImgSrc %>" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer">
        	<div style="height:360px;">
            	<!--왼쪽영역-->
           	    <div style="width:45%; height:360px; float:left;">
               		<div id="cont_searchA">
                        <table class="cont_t_list01" style="width:100%">
                            <caption>사용자 지정/변경 리스트</caption>
                            <colgroup>
                                <col width="50px" />
                                <col width="*" />
                                <col width="50px" />
                            </colgroup>
                            <tbody>
                                <tr>
							<td>
							<select name=USER_FLAG > 								
								<option value = "NAME" <%if ("NAME".equals(USER_FLAG)) {%>selected<%} %>>이름</option>
								<option value = "DEPT" <%if ("DEPT".equals(USER_FLAG)) {%>selected<%} %>>부서</option>
								<option value = "ID" <%if ("ID".equals(USER_FLAG)) {%>selected<%} %>>ID</option>
								<option value = "ALL" <%if ("ALL".equals(USER_FLAG)) {%>selected<%} %>>전체</option>
							</select>  
							</td>						
							<td>  
								<input type="text" class="input_type_text" name="USER_NAME_LOC" id="USER_NAME_LOC" width="96px" value="<%=USER_NAME_LOC%>" onkeydown="kepEnter()" style="ime-mode:active">
								<td><span class="btn_search"><a href="javascript:setQuery();">조회</a></span>
                            </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
					<div class="scrollArea" style="height:300px">
					<!-- 선택할 고객사 -->
					<table  class="cont_t_list02"  style="width:100% ">
		                    <caption>사용자 지정/변경 리스트</caption>
		                    <colgroup>
		                        <col width="10%" /> 
		                        <col width="30%" />  
		                        <col width="30%" /> 
		                        <col width="*" />  
		                    </colgroup>
		                    <thead>
		                        <tr>
		                            <th scope="col">선택</th> 
		                            <th scope="col">이름</th>  
		                            <th scope="col">직급</th>  
		                            <th scope="col">부서</th>  
		                        </tr>
		                    </thead>
		                    <tbody>
		<%
		if (_dataList == null || _dataList.size() == 0){
		%>
		<input type="hidden" name="count" id="count"  value="0"> 
		               		<tr bgcolor="#FFFFFF">
		                        <td colspan="4" align="center" height = "195">
		                        <span class="font1">조회된 데이타가 없습니다.</span>
		                        </td> 
		                    </tr>
		<%}else{
		for (int j=0; j<_dataList.size(); j++) {
			Map<String,String> rowData = _dataList.get(j);
		%> 
		                        <tr>
								<td> <input type="checkbox" id = "checkbox<%=j %>" name="checkbox<%=j %>"  value="<%=CommonUtil.nvl(rowData.get("USER_ID"))+"@"+CommonUtil.nvl(rowData.get("USER_NAME_LOC"))+"@"+CommonUtil.nvl(rowData.get("POSITION"))+"@"+CommonUtil.nvl(rowData.get("DEPARTMENT"))%>">
								</td>  
								<td><%=CommonUtil.nvl(rowData.get("USER_NAME_LOC"))%></td> 
								<td><%=CommonUtil.nvl(rowData.get("POSITION"))%></td> 
								<td><%=CommonUtil.nvl(rowData.get("DEPARTMENT"))%></td> 
		                        </tr> 
		<% } %>
		<input type="hidden" name="count" id="count"  value="<%=_dataList.size()%>"> 
		<%}%>                                   
		                    </tbody>
		                </table> 
		                </div> 	
                </div>
                <!--//왼쪽영역끝-->
                <div style="width:80px; height:210px; float:left; padding:150px 0px 0 14px;">
                    <span class="btn_02 mr04"><a href="javascript:addRow('to')" >지정</a></span>
                </div>
                 
                
                <!--오른쪽영역-->
                <div style="width:45%; height:350px; float:left;">
                	<h2 class="popTit" style="margin-bottom:20px;">사용자지정</h2>
 				        <!-- 선택 고객사 -->
						<div class="scrollArea" style="height:300px">
						<table  class="cont_t_list02"  style="width:100%" >
			                    <caption>선택된 고객사</caption>
			                    <colgroup>
			                        <col width="15%" /> 
			                        <col width="20%" />  
			                        <col width="20%" />  
			                        <col width="30%" /> 
			                        <col width="*" />  
			                    </colgroup>
			                    <thead>
			                        <tr>
			                            <th scope="col">구분</th>  
			                            <th scope="col">이름</th>  
			                            <th scope="col">직급</th>  
			                            <th scope="col">부서</th>  
			                            <th scope="col">삭제</th>  
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
		<div class="btnArea" style="margin-bottom:0">
		<span class="fr">
			<span class="btn_02 mr04"><a href="javascript:SelectCompany()" >확인</a></span>
		</span>                	
      
          </div>            
        </div>
    </div>
</form>
</body>
</html>
