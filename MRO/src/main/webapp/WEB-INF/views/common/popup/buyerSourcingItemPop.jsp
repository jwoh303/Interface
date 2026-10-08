<%--
**********************************************
* 메뉴 : 
* 화면 : 신규의뢰 품목입력
* 기능 : 신규의뢰 품목입력 팝업
* 프로그램 ID : PG_02_B_000834_011
* 담당자 :  현명환
* 착수일 : 2015-03-16
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
List<Map<String,String>> _dataList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된결과 
String com_code=   CommonUtil.nvl((String) request.getParameter("com_code"), _sessionInfo.getComCode());
String inventory_gubun_flag = CommonUtil.nvl((String) request.getParameter("inventory_gubun_flag"),""); 
String select_count    = CommonUtil.nvl((String) request.getParameter("select_count"),"");
String categroy_sh_flag    = CommonUtil.nvl((String) request.getParameter("categroy_sh_flag"),"");
String st_search_text    = CommonUtil.nvl((String) request.getParameter("st_search_text"),"");  
String st_categ_id    = CommonUtil.nvl((String) request.getParameter("st_categ_id"),"");

%>

<script type="text/javascript">


function setQuery()
{
	var buyer       =  $("#st_com_code").val();
    var searchText = $("#st_search_text").val();
    if(isEmpty(searchText)){
        alert(" 검색어가 입력되지 않았습니다.    ");
        return;
    }
  var search_gubun = $("#st_search_type").val();
  var text_gubun = searchText.toUpperCase();  
	if(search_gubun == "STD_CATEG_NM"){
		getBuyerSourcingStdDescPop(buyer,text_gubun);
	}else if(search_gubun == "SYS_CATEG_NM"){
		getBuyerSourcingCtgNmPop(buyer,text_gubun);
	}else{
		$("#st_categ_id").val(searchText);
		$('#sourcingItemPop').attr("action", "/common/commonList.do").submit();
	}
}
function categoryDisplayPop(){
	var buyer       =  $("#st_com_code").val();
	var text_gubun = "<%=inventory_gubun_flag%>";
	  
	getBuyerSourcingCtgIdPop(buyer,text_gubun);
}
function kepEnter() {	
	if (event.keyCode == 13) { 
		setQuery();
	}
}
function setCategoryInput(categ_name, categ_id, flag, flag2)
{ 
	document.sourcingItemPop.categroy_sh_flag.value =flag2;
	$("#st_categ_id").val(categ_id);
	$("#st_categ_nm").val(categ_name);
	if(flag == "NM"){
		$("#st_search_text").val(categ_name);
  	}else{
  		$("#st_search_text").val(categ_id);
   }
	
	$('#sourcingItemPop').attr("action", "/common/commonList.do").submit();
	
}
function checkboxCheck(st_value, cnt){
	
    if(st_value == "null" || st_value == "" || st_value == null || st_value == "undefined" || st_value == undefined || st_value.length == 0){
        return st_value;
    }else{
	    var box = eval("document.sourcingItemPop.lnCheck" + cnt);
	    if(box.checked == false) box.checked = true;
       return st_value;
	 }
}
function categoryDisplay(){
	var gubun_flag = $("#st_search_type").val();
    if(gubun_flag == "STD_CATEG_ID"){
    	document.sourcingItemPop.categroy_sh_flag.value ="STD_ID";
    	$('#sourcingItemPop').attr("action", "/common/commonList.do").submit();
    }else if(gubun_flag == "SYS_CATEG_NM"){
    	document.sourcingItemPop.categroy_sh_flag.value ="SYS_NM";
    	$('#sourcingItemPop').attr("action", "/common/commonList.do").submit();
    }else{
    	document.sourcingItemPop.categroy_sh_flag.value ="STD_NM";
    	$('#sourcingItemPop').attr("action", "/common/commonList.do").submit();
    }
	
}
function confirmCatg(){

	var tot_cnt  = $("#display_item_cnt").val();
	var attr_description = "";
	var check_value = "";
	var check_value2 = "";
    var category_id    = $("#st_categ_id").val();;
    var inventory_gubun_flag = $("#inventory_gubun_flag").val();
    var select_count   = "<%=select_count%>";
    
	if(eval(tot_cnt) < 2){
		var box = eval("document.sourcingItemPop.lnCheck0");
		if(box.checked == true){
			var attr_nm      = $("#st_attr_nm").val();
			var description  = filterline6(filterline5(filterline4(filterline3(filterline2( $("#st_description").val())))));
			attr_description = attr_nm+":"+description;
            check_value  += description +  "/";
            check_value2 += attr_description +  "/";
		}

	}else{
		for(var i = 0; i <tot_cnt; i++){
			var box = eval("document.sourcingItemPop.lnCheck" + 1);
			if(box.checked == true){
				var attr_nm      = document.sourcingItemPop.st_attr_nm[i].value;
				var description  = filterline6(filterline5(filterline4(filterline3(filterline2(document.sourcingItemPop.st_description[i].value)))));
				attr_description = attr_nm+":"+description;
	            check_value  += description +  "/";
	            check_value2 += attr_description +  "/";
			}
		}
	}
	var remark       = filterline6(filterline5(filterline4(filterline3(filterline2(document.sourcingItemPop.st_remark.value)))));
	var std_categ_nm       = document.sourcingItemPop.st_std_categ_nm.value;
    var final_value  = check_value  + remark;
    var final_value2 = check_value2  + remark;
    if(final_value.length < 1){
        alert(" 표준품명에 해당하는 물성치 정보가 입력되지 않았습니다.    ");
        return;
   }
   if(final_value.length > 250){
   	alert(" 물성정보 및 비고사항 내용이 현재 "+final_value.length+" 자로 250자를 초과했습니다. \n\n  내용을 수정해 주시기 바랍니다.  ");
   	return;
   }

   if(select_count=="SECONDS"){
   		var description    = std_categ_nm;
	    var specification  = final_value2;
   		parent.opener.setReturnValue2(description, specification, category_id, inventory_gubun_flag);
   }else{
     	parent.opener.setReturnValueInfo(std_categ_nm, final_value2, category_id, inventory_gubun_flag);
   }

   top.window.close();
}

function filterline2(str) {
    re = '#';

    strtemp = str.replace(re, '＃');
    return strtemp.replace(re, '＃');
}

function filterline3(str) {
    re = '"';

    strtemp = str.replace(re, '＂');
    return strtemp.replace(re, '＂');
}

function filterline4(str) {
    re = '@';

    strtemp = str.replace(re, '＠');
    return strtemp.replace(re, '＠');
}

function filterline5(str) {
    re = '&';

    strtemp = str.replace(re, '＆');
    return strtemp.replace(re, '＆');
}

function filterline6(str) {
    re = /'/g;

    strtemp = str.replace(re, '‘');
    return strtemp.replace(re, '‘');
}

</script> 
<body>
	 <form name=sourcingItemPop id=sourcingItemPop method=post >
	 <input type="hidden" name="codeGubun" id="codeGubun"  value="buyerSourcingItemPop">
	 <input type="hidden" name="st_com_code" id="st_com_code"  value="<%=com_code%>">
	 <%	if (_dataList != null && _dataList.size() > 0){	%>
			 <input type="hidden" name="display_item_cnt" id="display_item_cnt" value="<%=_dataList.size() %>" >
<%	}else{	%>
	 	<input type="hidden" name="display_item_cnt" id="display_item_cnt" value="0" >
<%	}%>
	 <input type=hidden name="search_flag" id="search_flag"  value="">
	 <input type=hidden name="searchType" id="searchType"  value="">
	 <input type=hidden name="searchText" id="searchText"  value="">
	 <input type=hidden name="st_categ_id" id="st_categ_id"  value="<%=st_categ_id%>">
	 <input type=hidden name="st_categ_nm" id="st_categ_nm"  value="">
	 <input type=hidden name="inventory_gubun_flag" id="inventory_gubun_flag"  value="<%=inventory_gubun_flag%>">
	 <input type=hidden name="std_categ_nm" id="std_categ_nm"  value="">
    <input type="hidden" name="select_count"     value="<%=select_count%>">
    <input type="hidden" name="categroy_sh_flag" value="<%=categroy_sh_flag%>">
    <input type="hidden" name="st_toDate"   value="">
	 
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다-->
	<div id="popWrapper" style="height:494px;">
    	<div id="popHeader">
        	<h1 class="title">신규의뢰 품목입력</h1>
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
						<caption>부서검색 리스트</caption>
						<colgroup>
							<col width="30%" />
							<col width="40%" />
							<col width="*" />
						</colgroup>						
						<tbody>
						<tr>
							<td>
								<select name=st_search_type  id=st_search_type onchange="categoryDisplay()">
						            <option value="STD_CATEG_NM" <%="STD_NM".equals(request.getParameter("categroy_sh_flag"))?"selected":""%>>표준품명</option>
						            <option value="SYS_CATEG_NM" <%="SYS_NM".equals(request.getParameter("categroy_sh_flag"))?"selected":""%>>카테고리명</option>
						            <option value="STD_CATEG_ID" <%="STD_ID".equals(request.getParameter("categroy_sh_flag"))?"selected":""%>>카테고리 ID</option>
								</select>
							</td>
							<td> 
								<input type=text  name=st_search_text  id=st_search_text  size=20  onkeydown="kepEnter()" class="input_type_text" value="<%=st_search_text%>"> 
                            </td>
<%    if(categroy_sh_flag.equals("STD_ID")){   %>
						    <td><span class="btn_06" title="카테고리ID검색" ><a href="javascript:categoryDisplayPop();">카테고리ID검색</a></span>	</td>
<%    }                                    %>
						</tr>					 
					</tbody>
				</table>
            </div>    
           	<!--grid-->
            <div class="scrollArea" style="height:348px">
                <table  class="cont_t_list02"  style="width:100%">
                    <caption>부서검색 리스트</caption>
                    <colgroup>
                        <col width="5%" /> 
                        <col width="30%" /> 
                        <col width="*" /> 
                    </colgroup>
                    <tbody>
<%
if (_dataList == null || _dataList.size() == 0){
%>
               		<tr bgcolor="#FFFFFF">
                        <td colspan="7" align="center" height = "280">
                        <span class="font1">해당 분류별 검색어를 입력해 주십시오.</span>
                        </td> 
                    </tr>
<%}else{

for (int j=0; j<_dataList.size(); j++) {
	Map<String,String> rowData = _dataList.get(j);
		if(j == 0){
%> 
						<tr>
							<td colspan="7"  class="left"> 
								표준품명&nbsp;:&nbsp<%=rowData.get("STD_CATEG_NAME")%>
								<input type=hidden name=st_std_categ_nm value="<%=rowData.get("STD_CATEG_NAME")%>">
							</td>
						</tr>
<%	} %>
                        <tr>					
<%
	if(rowData.get("ATTR_NAME").equals("품명")){ %>
						<td >
						 	<input type="checkbox" name="lnCheck<%=j%>" id="lnCheck<%=j%>" value="<%=rowData.get("CATEG_SEQ")+"@"+rowData.get("ATTR_NAME")%>" style="cursor:hand;" checked>
						</td>
<%	}else{ %>
						<td>
						 	<input type="checkbox" name="lnCheck"<%=j%>" id="lnCheck<%=j%>" value="<%=rowData.get("CATEG_SEQ")+"@"+rowData.get("ATTR_NAME")%>" style="cursor:hand;">
						</td>	
<%	} %>		
						<td class="left">
							<%=rowData.get("ATTR_NAME")%><input type=hidden name=st_attr_nm value="<%=rowData.get("ATTR_NAME")%>">
						</td>
<%
	if(rowData.get("ATTR_NAME").equals("품명")){ %>
						<td>
						 	<input type=text  name=st_description  id=st_description  style="width:90%"   class="input_type_text"  value="<%=rowData.get("STD_CATEG_NAME")%>" onchange="checkboxCheck(this.value, '<%=j%>')"> 
						</td>
<%	}else{ %>
						<td>
						 	<input type=text  name=st_description  id=st_description  style="width:90%"   class="input_type_text"   onchange="checkboxCheck(this.value, '<%=j%>')"> 
						</td>	
<%	} %>		
                        </tr>
                        
<% 		if(j+1 == _dataList.size()){%>
						<tr>
							<td colspan="2" class="left"> 비고</td>
							<td><input type=text  name=st_remark  id=st_remark  style="width:90%"   class="input_type_text" ></td>
						</tr>

<% 		} 
	}
}%>
                    </tbody>
                </table>    
                		
			<!-- 버튼영역 -->
			<div class="btnArea">
			<div class="fr">			
				<span class="btn_02" title="다운로드" >
					<a href="javascript:confirmCatg();">저장</a> 
				</span>	
				</div>
        </div>
    </div>        
</div>
</form> 
</body>
</html>
