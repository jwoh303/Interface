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
String BIZNPLC_CLSS_NM = CommonUtil.nvl((String) request.getParameter("BIZNPLC_CLSS_NM"),"");  //  (조회조건) 

String toContent = CommonUtil.nvl((String) request.getParameter("toContent"),"");  //  to 선택내용
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
		var tmp = $("input[name=codeResult]").eq(i).val() ; 
		tmptmp = tmptmp + tmp+"$";
	} 
	
  $("#toContent").val(tmptmp);	 
  $('#companyCodePop').attr("action", "/common/commonList.do").submit();    
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
	for(var i = 0; i < tot_cnt; i++){   
		var tmp = $("input[name=codeResult]").eq(i).val() ; 
		var arrKey = tmp.split("@");
		tmptmp1 = tmptmp1 + arrKey[0]+"@";
		tmptmp2 = tmptmp2 + arrKey[1]+"@";
	}
	setReturn(tmptmp1,tmptmp2);
}

function addRow(){
	var form =  document.forms[0]; 
	var tot_cnt = form.count.value;   
	var result = ""; 
	
	if (tot_cnt==0) { alert("대상이 없습니다."); return; }
	 
	if (tot_cnt == 1){
		var box = eval("document.forms.companyCodePop.checkbox0");
		if(box.checked == true){   
			var arrKey = box.value.split("@");
			if (dupCheck(arrKey[0])==true) return;
			result = result + "<tr><input type='hidden' name='codeResult' id='codeResult' value='"+arrKey[0] +"@"+arrKey[1] +"'><td>"+arrKey[1] + " ("+ arrKey[0] +")</td><td><a id='row_delete'  onclick='removeRow(this)' href='#'>행삭제</a></td></tr>";
		}
	} else{  
		for(var i = 0; i < tot_cnt; i++){   
			var box = eval("document.forms.companyCodePop.checkbox" + (i));
			if(box.checked == true){  
				var arrKey = box.value.split("@");
				if (dupCheck(arrKey[0])==true) return;
				result = result + "<tr><input type='hidden' name='codeResult' id='codeResult' value='"+arrKey[0] +"@"+arrKey[1] +"'><td>"+arrKey[1] + " ("+ arrKey[0] +")</td><td><a id='row_delete'  onclick='removeRow(this)' href='#'>행삭제</a></td></tr>";
			}
		}
	} 
	$("#content").append(result);
}
 
function removeRow(obj) {
    if($('#content tr').size() > 0){
        alert('삭제');
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
	    if (arrKey[0] == value){
	    	alert(tmp + " 코드 중복입니다.");
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
			result = result + "<tr><input type='hidden' name='codeResult' id='codeResult' value='"+tmp3[0] +"@"+tmp3[1] +"'><td>"+tmp3[1] + " ("+ tmp3[0] +")</td><td><a id='row_delete'  onclick='removeRow(this)' href='#'>행삭제</a></td></tr>";
	
		}
		$("#content").html(result);
	}
	
	$("#COM_TYPE").focus();
}


</script> 
<body onload="kepOnload(); window.onblur=function(){if(!opener.closed) window.focus();}">
	 <form name=companyCodePop id=companyCodePop method=post >
	 <input type="hidden" name="codeGubun" id="codeGubun"  value="companyCodePop"> 
	 <input type="hidden" name="toContent" id="toContent"  value="<%=toContent%>">  
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다-->
	<div id="popWrapper" style="height:444px; min-height: 100px;">
    	<div id="popHeader">
        	<h1 class="title">협력사</h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/<%=_closeImgSrc %>" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer">
             <div id="searchBtnA02">
            	<span class="btn_search"><a href="javascript:setQuery();">조회</a></span>  
            </div>   
            <!--조회영역-->
            <div id="cont_searchA">
            	<table  class="cont_t_list01"  style="width:100%">
						<caption>협력사 검색 리스트</caption>
						<colgroup>
							<col width="50px" />
							<col width="20%" />
							<col width="80px" /> 
                            <col width="*" />
						</colgroup>						
						<tbody>
						<tr>
							<td>코드</td>
							<td> 
								<input type=text name=COM_TYPE  id="COM_TYPE" size=20 value="<%=COM_TYPE%>" onkeydown="kepEnter()" class="input_type_text"> 
                            </td>
							<td>회원사한글명</td>						
							<td> 
								<input type=text name=COM_NAME_LOC id="COM_NAME_LOC" size=20 value="<%=COM_NAME_LOC%>" onkeydown="kepEnter()" class="input_type_text"> 
                            </td>
                         </tr> 
					</tbody>
				</table>
            </div>
            <table style="width:100%">
            <tr>
            <td style="width:45%"  valign="top">
<div class="scrollArea" style="height:258px">
<table  class="cont_t_list02"  style="width:100%">
                    <caption>협력사  리스트</caption>
                    <colgroup>
                        <col width="10%" /> 
                        <col width="*" />  
                    </colgroup>
                    <thead>
                        <tr>
                            <th scope="col">선택</th> 
                            <th scope="col">한글명</th>  
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
						<td> <input type="checkbox" id = "checkbox<%=j %>" name="checkbox<%=j %>"  value="<%=CommonUtil.nvl(rowData.get("COM_CODE"))+"@"+CommonUtil.nvl(rowData.get("COM_NAME"))+"@"+CommonUtil.nvl(rowData.get("CLEVEL"))+"@"+CommonUtil.nvl(rowData.get("COM_CODE"))%>">
						</td> 
						<td><%=CommonUtil.nvl(rowData.get("COM_NAME"))%>&nbsp;(<%=CommonUtil.nvl(rowData.get("COMG_CODE"))%>)</td> 
                        </tr> 
<% } %>
<input type="hidden" name="count" id="count"  value="<%=_dataList.size()%>"> 
<%}%>                                   
                    </tbody>
                </table>
                </div>
	        </td>
	        <td style="width:5%">
	        <span class="btn_02"><a href="javascript:addRow()">추가</a></span>
	        </td>
	         <td style="width:45%" valign="top">
<div class="scrollArea" style="height:258px">
<table  class="cont_t_list02"  style="width:100%">
                    <caption>협력사  리스트</caption>
                    <colgroup>
                        <col width="80%" /> 
                        <col width="*" />  
                    </colgroup>
                    <thead>
                        <tr>
                            <th scope="col">한글명</th>  
                            <th scope="col">삭제</th>  
                        </tr>
                    </thead>
                    <tbody id="content">
                    </tbody>
</table>                    
</div>
	        </td></tr>
	        </table>
        
				<div class="btnArea" style="margin-top: 10px;">
					<%
					if (_dataList == null || _dataList.size() == 0){
					}else{ %>
                	<!--버튼이 2글자일때 class="btn_02",버튼이 3글자일때 class="btn_03",버튼이 4글자일때 class="btn_04" 글자수와 class숫자가 동일 최대 10글자까지 가능-->
<!--                 	<p class="btn_02 mr04"><a href="javascript:SelectCompany()">확인</a></p> -->
						<span class="fr">
							<span class="btn_02"><a href="javascript:SelectCompany()" >확인</a></span>
						</span>                	
                	<%} %>
                </div>
     </div>        
 </div>
                 
</form> 
</body>
</html>
