<%--
**********************************************
* 메뉴 : 유니폼 신청 > 유니폼 선택 팝업
* 화면 : 유니폼 선택
* 기능 : 
* 프로그램 ID :
* 담당자 : HSJ
* 착수일 : 2020-04-08
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
<%@ include file="../../../common/include/head_pop.jspf"  %>
</head>
<%
@SuppressWarnings (value="unchecked")
List<Map<String,String>> _dataList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된결과 
String com_code=  CommonUtil.nvl((String) request.getParameter("com_code"), "");
String st_buyer_item_no = CommonUtil.nvl((String) request.getParameter("st_buyer_item_no"),"");  //  (조회조건)
String st_description = CommonUtil.nvl((String) request.getParameter("st_description"),"");  //  (조회조건)
String st_specification = CommonUtil.nvl((String) request.getParameter("st_specification"),"");  //  (조회조건)
String st_init_flag = CommonUtil.nvl((String) request.getParameter("st_init_flag"),"N");
%>

<script type="text/javascript">
function kep_onload()
{  
	<% if (!"Y".equals(st_init_flag)){%>
	<%}%>
}

function setQuery(){
  $('#uniformSearchPop').attr("action", "/mpso/getBuyerMpSoUniformChoicePop.do").submit();
}

/**
 * FORM 을 초기화
 */
function reload(){
	kepReload("uniformSearchPop");
	jspTableClean("table_list");
	document.forms.uniformSearchPop.check_status.checked = false;
}

function kepEnter() {	
	if (event.keyCode == 13) { 
		setQuery();
	}
}

function setReturn(value1,value2,value3)
{ 
  opener.setPopupReturn(value1,value2,value3,"dept");
  this.close();
}

function SelectCompany(){  
	var tot_cnt = document.forms.uniformSearchPop.count.value;
	var item_list = "";
	var check_count = 0;
	
	if (tot_cnt == 1){
		var box = eval("document.forms.uniformSearchPop.checkbox0");
		if(box.checked == true){
			check_count = check_count + 1;
			
			var item = $("input[name=uniformList]").eq(0).val() ; 
			item_list = item_list + item + "&&";
		}
	} else {
		for(var i = 0; i < tot_cnt; i++){
			var box = eval("document.forms.uniformSearchPop.checkbox" + i);
			if(box.checked == true){
				check_count = check_count + 1;
				
				var item = $("input[name=uniformList]").eq(i).val() ; 
				item_list = item_list + item + "&&";
			}
		}
	}
	
	document.forms.uniformSearchPop.st_item_list.value = item_list;
	
	if(check_count == 0){
		alert("선택된 항목이 없습니다.");
		return;
	}
	
	if(!confirm('선택한 항목을 등록하시겠습니까?'))
		return;
	
	kepAjaxFormCall("/mpso/saveBuyerMpSoUniformChoicePop.do","uniformSearchPop","save");
}

/**
 * ajax 공통 호출후 성공시 처리 함수
 */ 
function kepAjaxSuccess(pMethod , response){
	
	var sMsg = response.msg.MSG;
	
    if(sMsg == "UPDATE_OK"){
		if(pMethod == "save"){
			alert("정상적으로 등록되었습니다.");

			// 처리후 재조회
			opener.doAction('search');
			this.close();
       }
    }
}

/**
 * ajax 공통 호출후 에러시 처리 함수
 */
function kepAjaxError(pMethod , response){
	if(pMethod == "save"){
		alert("등록 실패하였습니다. \n\n확인 후 다시 시도해 주시기 바랍니다.");
	}
}
</script>

<body onload="kep_onload();">
	 <form name="uniformSearchPop" id="uniformSearchPop" method=post >
	 <input type="hidden" name="codeGubun" id="codeGubun"  value="uniformSearchPop">
	 <input type="hidden" name="com_code" id="com_code"  value="<%=com_code%>">
	 <input type=hidden name="st_init_flag" id="st_init_flag"  value="Y">
	 <input type=hidden name="st_item_list" id="st_item_list"  value="">
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다-->
	<div id="popWrapper" style="height:494px;">
    	<div id="popHeader">
        	<h1 class="title"><%=CommonLang.get("HTITLE927") %><!-- 유니폼 선택 --></h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/<%=_closeImgSrc %>" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer">
             <div id="searchBtnA02">
            	<span class="btn_search"><a href="javascript:setQuery();"><%=CommonLang.get("HTITLE7") %><!-- 조회 --></a></span>
            	<span class="btn_reset"><a href="javascript:reload();"><%=CommonLang.get("HTITLE8")%><!-- 초기화 --></a></span>
            </div>   
            <!--조회영역-->
            <div id="cont_searchA">
            	<table  class="cont_t_list01"  style="width:100%">
						<caption>유니폼 검색 리스트</caption>
						<colgroup>
							<col width="10%" />
							<col width="23%" />
							<col width="10%" />
							<col width="23%" />
							<col width="10%" />
                            <col width="*" />
						</colgroup>						
						<tbody>
						<tr>
							<td><%=CommonLang.get("HTITLE12") %><!-- 품목코드 --></td>
							<td> 
								<input type=text name=st_buyer_item_no id="st_buyer_item_no" width="90%" value="<%=st_buyer_item_no%>" onkeydown="kepEnter()" class="input_type_text"> 
                            </td>
						    <td><%=CommonLang.get("HTITLE565") %><!-- 품명 --></td>	
							<td> 
								<input type=text name=st_description id="st_description" width="90%" value="<%=st_description%>" onkeydown="kepEnter()" class="input_type_text"> 
                            </td>
                            <td><%=CommonLang.get("HTITLE14") %><!-- 규격 --></td>	
							<td> 
								<input type=text name=st_specification id="st_specification" width="90%" value="<%=st_specification%>" onkeydown="kepEnter()" class="input_type_text"> 
                            </td>
						</tr>					 
					</tbody>
				</table>
            </div>            
           	<!--grid-->
            <div class="scrollArea" style="height:348px">
                <table id="table_list" class="cont_t_list02" style="width:100%">
                    <caption>유니폼 검색 리스트</caption>
                    <colgroup>
                        <col width="5%" />
                        <col width="15%" />
                        <col width="30%" />
                        <col width="*" />
                        <col width="8%" />
                    </colgroup>
                    <thead>
                        <tr>
                            <th scope="col">
                            	<input type="checkbox" name="check_status" id="check_status" value="선택"  style="cursor:pointer;" onclick="kepCheckAll(document.forms.uniformSearchPop.count.value,document.forms.uniformSearchPop.check_status,'document.forms.uniformSearchPop.checkbox');">
                            </th> 
                            <th scope="col">품목코드</th> 
                            <th scope="col">품명</th>
                            <th scope="col">규격</th>
                            <th scope="col">단위</th> 
                        </tr>
                    </thead>
                    <tbody>
<%
if (_dataList == null || _dataList.size() == 0){
%>
					<input type="hidden" name="count" id="count"  value="0">
               		<tr bgcolor="#FFFFFF">
                        <td colspan="5" align="center" height = "280">
                        <span class="font1"><%=CommonLang.msg("MSG347") %><!-- 조회된 데이타가 없습니다. --></span>
                        </td> 
                    </tr>
<%}else{
for (int j=0; j<_dataList.size(); j++) {
	Map<String,String> rowData = _dataList.get(j);
%> 
					<tr>
						<td>
						 	<input type="checkbox" id = "checkbox<%=j %>" name="checkbox<%=j %>">
						 	<input type="hidden" name="uniformList" id="uniformList" value="<%=CommonUtil.nvl(rowData.get("BUYER_ITEM_NO"))+"@"+CommonUtil.nvl(rowData.get("CONTRACT_NO"))+"@"+CommonUtil.nvl(rowData.get("CONTRACT_SEQ"))%>">
						</td>
						<td class="center">
							<%=rowData.get("BUYER_ITEM_NO")%>
					   </td>
						<td class="left">
							<%=rowData.get("DESCRIPTION_LOC")%>
						</td>
						<td class="left">
							<%=rowData.get("SPECIFICATION")%>
						</td>
						<td class="center">
							<%=rowData.get("UNIT_MEASURE")%>
						</td>
					</tr> 
	<%}%>
	<input type="hidden" name="count" id="count"  value="<%=_dataList.size()%>">
<%}%>                               
                    </tbody>
                </table>                  
        </div>
        <div class="btnArea">
<%
if(_dataList == null || _dataList.size() == 0){ 
}else{
%> 
			<span class="fr">
				<span class="btn_02 mr04 mb20"><a href="javascript:SelectCompany()" >등록</a></span>
			</span>                	
<%}%> 
		</div>
    </div>        
</div>
</form> 
</body>
</html>
