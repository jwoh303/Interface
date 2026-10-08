<%--
**********************************************
* 메뉴 : 
* 화면 : 관리구매사 지정
* 기능 : 관리구매사 지정 팝업.
* 프로그램 ID : PG_90_C_900_64
* 담당자 : CEJ( 설계 : 김지현 )
* 착수일 : 2014-08-14
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
<%@ include file="../../common/include/head_pop.jspf"  %>
</head>
<%
@SuppressWarnings (value="unchecked")
List<Map<String,String>> _dataLeft = (List<Map<String,String>>) request.getAttribute("dataLeft"); // 조회된결과   
@SuppressWarnings (value="unchecked")
List<Map<String,String>> _dataRight = (List<Map<String,String>>) request.getAttribute("dataRight"); // 조회된결과   
String COM_NAME_LOC = CommonUtil.nvl((String) request.getParameter("COM_NAME_LOC"),"");  //  (조회조건)  
String toContent = CommonUtil.nvl((String) request.getParameter("toContent"),"");  //  to 선택내용

int leftSize = 0;
int rightSize = 0;
if(_dataLeft != null){
	leftSize = _dataLeft.size();
}
if(_dataRight != null){
	rightSize = _dataRight.size();
}
%>
<script type="text/javascript"> 
function setQuery()
{  	
	if (  kepIsEmpty("COM_NAME_LOC")==true  ){
	    alert("검색조건을 입력하세요.");
		return;
	}  
	 
  $('#adminSafetyCompanyCodePop').attr("action", "/common/getAdminSafetyCompanyCodePop.do").submit();    
} 


function setQuery2()
{  	  
  $('#adminSafetyCompanyCodePop').attr("action", "/common/showAdminSafetyCompanyCodePop.do").submit();    
} 



function kepEntersetQuery() {	
	if (event.keyCode == 13) { 
		setQuery();
	}
}


function kepOnload(){
     
}


function addRow(){
    var tot_cnt  = $("#leftCount").val(); 
    var query = "";
    
    if(tot_cnt == 0 || tot_cnt == "" || tot_cnt == "null" || tot_cnt == null){
        alert(" 등록 대상이 없습니다.     ");
        return;
    }
    
    var chk_cnt = 0;
    if(eval(tot_cnt) < 2){
        var box = eval("document.forms.adminSafetyCompanyCodePop.leftCheckbox0");
        if(box.checked == true) chk_cnt++;
    }else{
        for(var j = 0; j < tot_cnt; j++){
             var box = eval("document.forms.adminSafetyCompanyCodePop.leftCheckbox" + j);
             if(box.checked == true){
                  chk_cnt++;
             }
        }
    }
    if(chk_cnt == "0"){
        alert(" 하나 이상의 대상이 선택되어야 합니다.   ");
        return;
    }
    
    if(eval(tot_cnt) < 2){

    	 var box = eval("document.forms.adminSafetyCompanyCodePop.leftCheckbox0");
    	 if (box.checked == true){
    		 query = query + box.value + "@@";
    	 }
    	 
    }else{

        for(var k =0; k < tot_cnt; k++){
            var box = eval("document.forms.adminSafetyCompanyCodePop.leftCheckbox" + k);             
	       	 if (box.checked == true){
	    		 query = query + box.value + "@@";
	    	 }
        }
    }
     
    $("#crud").val("C");
    $("#query").val(query);
    
    kepAjaxPopFormCall("/common/saveAdminSafetyCompanyCode.do","adminSafetyCompanyCodePop","CREATE"); 
    
}

function removeRow(){
    var tot_cnt  = $("#rightCount").val(); 
    
    if(tot_cnt == 0 || tot_cnt == "" || tot_cnt == "null" || tot_cnt == null){
        alert(" 삭제 대상이 없습니다.     ");
        return;
    }
    
    
    var chk_cnt = 0;
    if(eval(tot_cnt) < 2){
        var box = eval("document.forms.adminSafetyCompanyCodePop.rightCheckbox0");
        if(box.checked == true) chk_cnt++;
    }else{
        for(var j = 0; j < tot_cnt; j++){
             var box = eval("document.forms.adminSafetyCompanyCodePop.rightCheckbox" + j);
             if(box.checked == true){
                  chk_cnt++;
             }
        }
    }
    if(chk_cnt == "0"){
        alert(" 하나 이상의 대상이 선택되어야 합니다.   ");
        return;
    }
    
    
    var query = "";
    if(eval(tot_cnt) < 2){

    	 var box = eval("document.forms.adminSafetyCompanyCodePop.rightCheckbox0");
    	 if (box.checked == true){
    		 query = query + box.value + "@@";
    	 }
    	 
    }else{

        for(var k =0; k < tot_cnt; k++){
            var box = eval("document.forms.adminSafetyCompanyCodePop.rightCheckbox" + k);             
	       	 if (box.checked == true){
	    		 query = query + box.value + "@@";
	    	 }
        }
    }
     
    $("#crud").val("D");
    $("#query").val(query);
    
    kepAjaxPopFormCall("/common/saveAdminSafetyCompanyCode.do","adminSafetyCompanyCodePop","REMOVE"); 
}

/**
 * ajax 공통 호출후 성공시 처리 함수
 */
function kepAjaxPopSuccess(pMethod , response){  

	<%
	if (_dataLeft == null || _dataLeft.size() == 0){
	%>
	setQuery2();
	<%}else{%>	
	setQuery();
	<%}%>
}

/**
 * ajax 공통 호출후 에러시 처리 함수
 */
function  kepAjaxPopError(pMethod , response) {  
		 alert("오류 하였습니다.\n\n다시 한 번 시도해 주시기 바랍니다.  "); 
			<%
			if (_dataLeft == null || _dataLeft.size() == 0){
			%>
			setQuery2();
			<%}else{%>	
			setQuery();
			<%}%>
} 

function checkAll(flag){
	if(flag == "left"){ //선택할 고객사
		var status = $("#leftCheckedAll").is(":checked");
		for(var i=0; i<<%=leftSize%>; i++){
			$("#leftCheckbox"+i).prop("checked",status);
		}
	}else{ //선탟된 고객사
		var status = $("#rightCheckedAll").is(":checked");
		for(var i=0; i<<%=rightSize%>; i++){
			$("#rightCheckbox"+i).prop("checked",status);
		}
	}
}

</script> 
<body onload="kepOnload();"> 
<%--  window.onblur=function(){if(!opener.closed) window.focus();}">  --%>
	 <form name=adminSafetyCompanyCodePop id=adminSafetyCompanyCodePop method=post > 
	 <input type="hidden" name="crud" id="crud"  value="">  
	 <input type="hidden" name="query" id="query"  value="">  
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다-->
	<div id="popWrapper" style="height:444px; min-height: 100px;">
    	<div id="popHeader">
        	<h1 class="title">관리 고객사 지정</h1>
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
									<td>회사명</td>						
									<td>  
										<input type="text" class="input_type_text" name="COM_NAME_LOC" id="COM_NAME_LOC" width="96px" value="<%=COM_NAME_LOC%>" onkeydown="kepEntersetQuery()" style="ime-mode:active">
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
	                        <col width="15%" /> 
	                        <col width="50%" /> 
	                        <col width="*" />  
	                    </colgroup>
	                    <thead>
	                        <tr>
	                            <th scope="col"><input type="checkbox" style="vertical-align: text-bottom;" value="상품전체체크"  id="leftCheckedAll" name="leftCheckedAll" onclick="javascript:checkAll('left');"/>선택</th> 
	                            <th scope="col">회사명</th>  
	                            <th scope="col">코드</th>  
	                        </tr>
	                    </thead>
	                    <tbody>
		<%
		if (_dataLeft == null || _dataLeft.size() == 0){
		%>
		<input type="hidden" name="leftCount" id="leftCount"  value="0"> 
	               		<tr bgcolor="#FFFFFF">
	                        <td colspan="3" align="center" height = "195">
	                        <span class="font1">조회된 데이타가 없습니다.</span>
	                        </td> 
	                    </tr>
		<%}else{
		for (int j=0; j<_dataLeft.size(); j++) {
			Map<String,String> rowData = _dataLeft.get(j);
		%> 
                        <tr>
							<td> <input type="checkbox" id = "leftCheckbox<%=j %>" name="leftCheckbox<%=j %>"  value="<%=CommonUtil.nvl(rowData.get("COM_CODE"))%>">
							</td> 
							<td class="left"><%=CommonUtil.nvl(rowData.get("COM_NAME"))%></td> 
							<td><%=CommonUtil.nvl(rowData.get("COM_CODE"))%></td> 
                        </tr> 
		<% } %>
			<input type="hidden" name="leftCount" id="leftCount"  value="<%=_dataLeft.size()%>"> 
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
                	<h2 class="popTit" style="margin-bottom:34px;">지정 고객회원사</h2>
 				        <!-- 선택 고객사 -->
						<div class="scrollArea" style="height:280px">
						<table id="tblSelCompany" class="cont_t_list02"  style="width:100%" >
			                    <caption>선택된 고객사</caption>
			                    <colgroup>
			                        <col width="15%" /> 
			                        <col width="50%" /> 
	                        		<col width="*" />  
			                    </colgroup>
			                    <thead>
			                        <tr>
			                            <th scope="col"><input type="checkbox" style="vertical-align: text-bottom;" value="상품전체체크"  id="rightCheckedAll" name="rightCheckedAll" onclick="javascript:checkAll('right');"/>선택</th> 
	                            		<th scope="col">회사명</th>  
	                            		<th scope="col">코드</th>  
			                        </tr>
			                    </thead>
			                    <tbody id="content">
		<%
		if (_dataRight == null || _dataRight.size() == 0){
		%>
		<input type="hidden" name="rightCount" id="rightCount"  value="0"> 
	               		<tr bgcolor="#FFFFFF">
	                        <td colspan="3" align="center" height = "195">
	                        <span class="font1">조회된 데이타가 없습니다.</span>
	                        </td> 
	                    </tr>
		<%}else{
		for (int j=0; j<_dataRight.size(); j++) {
			Map<String,String> rowData = _dataRight.get(j);
		%> 
                        <tr>
							<td>  <input type="checkbox" id = "rightCheckbox<%=j %>" name="rightCheckbox<%=j %>"  value="<%=CommonUtil.nvl(rowData.get("BUYER"))%>">
							</td> 
							<td class="left"><%=CommonUtil.nvl(rowData.get("COM_NAME"))%></td> 
							<td><%=CommonUtil.nvl(rowData.get("BUYER"))%></td> 
                        </tr> 
		<% } %>
			<input type="hidden" name="rightCount" id="rightCount"  value="<%=_dataRight.size()%>"> 
		<%}%>            			                    
			                    </tbody>
						</table>                    
			         	</div>

                </div>
                <!--//오른쪽영역-->
            </div> 
        </div>
    </div>
</form>
</body>
</html>
