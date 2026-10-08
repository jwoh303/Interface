<%--
**********************************************
* 메뉴 : 벌크소싱 견적요청 > 프로젝트 선택
* 화면 : 프로젝트 조회 팝업
* 기능 : 400px
*****************
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
List<Map<String,String>> _dataList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된결과  
String st_from_date = CommonUtil.nvl((String) request.getParameter("st_from_date"),"");
String st_to_date = CommonUtil.nvl((String) request.getParameter("st_to_date"),""); 
String st_type = CommonUtil.nvl((String) request.getParameter("st_type"),"A"); // A : 중단, 마감 건 안보임, B: 전체조회(견젹현황용)
%>
<script type="text/javascript">
function kep_onload_view(){ 
	kepSetCalender("st_from_date");
	kepSetCalender("st_to_date");

	<%if("".equals(st_from_date)){%>
	$("#st_from_date").val(kepToDateAdd("7","M"));
	$("#st_to_date").val(kepGetNowTimeStr('YYYYMMDD','/')); 
	<%}%>
	
	<%if(_dataList == null){%>
	 setQuery();
	<%}%>
}

function setQuery()
{  
	if (kep_dateSearchCheck($("#st_from_date").val(),$("#st_to_date").val()) == false) return;
	
	if (kepGetDateDiff('st_from_date','st_to_date','D') > 372 ){
		alert("조회기간은 12개월까지 조회가 가능합니다.");
		return;
	}
  	
	$('#masterMpRqBulkQuotationSelProjectPop').attr("action", "/mprq/getMasterMpRqBulkQuotationSelProjectPop.do").submit();        
}

function kepEnter() {	
	if (event.keyCode == 13) { 
		setQuery();
	}
}

function setReturn(value1,value2,value3,value4,value5,value6,value7,value8,value9)
{ 
  opener.setPopupReturn(value1,value2,value3,value4,value5,value6,value7,value8,value9);
  this.close();
}
</script> 
<body onload="kep_onload_view();">
	 <form name="masterMpRqBulkQuotationSelProjectPop" id="masterMpRqBulkQuotationSelProjectPop" method="post" >
	 <input type ="hidden" id="st_type" name="st_type" value="<%=st_type%>">
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다-->
	<div id="popWrapper" style="height:300px; min-height: 100px;">
    	<div id="popHeader">
        	<h1 class="title">프로젝트 선택</h1>
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
						<caption>프로젝트 리스트</caption>
						<colgroup>
							<col width="20%" />
							<col width="*" />
						</colgroup>						
						<tbody>
						<tr>
							<td>프로젝트 등록일</td>						
							<td> 
								<input type=text name="st_from_date" id="st_from_date" value="<%=st_from_date%>" onkeydown="kepEnter()" style="text-align:center; width: 25%;" class="input_type_text"> 
								~ 	<input type=text name="st_to_date" id="st_to_date" value="<%=st_to_date%>" onkeydown="kepEnter()" style="text-align:center; width: 25%;" class="input_type_text">
								<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','1')">1개월</a></span>
								<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','6')">6개월</a></span>
								<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','12')">12개월</a></span>
                            </td>
						</tr>											
						<tr>
							<td>프로젝트 명</td>						
							<td>  
								<input type=text name="st_project_name" id="st_project_name" value="" onkeydown="kepEnter()" style="ime-mode:active; width: 95%;" class="input_type_text">
                            </td>
						</tr>					 
					</tbody>
				</table>
            </div>            
           	 <!--grid-->
           	 <div class="scrollArea" style="height:300px">
                <table  class="cont_t_list02"  style="width:100%">
                    <caption>프로젝트 검색 리스트</caption>
                    <colgroup>
                        <col width="17%" /> 
                        <col width="20%" />
                        <col width="*" />
                        <col width="12%" />  
                        <col width="15%" />  
                    </colgroup>
                    <thead>
                        <tr>
                            <th scope="col">프로젝트 등록일</th> 
                            <th scope="col">프로젝트 코드</th> 
                            <th scope="col">프로젝트명</th>  
                            <th scope="col">프로젝트 상태</th>
                            <th scope="col">PM</th>  
                        </tr>
                    </thead>
                    <tbody>
<%
if (_dataList == null || _dataList.size() == 0){
%>
               		<tr bgcolor="#FFFFFF">
                        <td colspan="4" align="center" height = "250">
                        <span class="font1">조회된 데이터가 없습니다.</span>
                        </td> 
                    </tr>
<%}else{
	for (int j=0; j<_dataList.size(); j++) {
		Map<String,String> rowData = _dataList.get(j);
%> 
					<tr>
						<td><a class="hyperLink" href="javascript:setReturn('<%=rowData.get("BURQ_NO")%>','<%=rowData.get("PROJECT_NAME")%>','<%=rowData.get("PROJECT_UNIT") %>','<%=rowData.get("PROJECT_MNG_USER")%>')"'><%=rowData.get("ADD_DATE")%></a></td>
						<td><a class="hyperLink" href="javascript:setReturn('<%=rowData.get("BURQ_NO")%>','<%=rowData.get("PROJECT_NAME")%>','<%=rowData.get("PROJECT_UNIT") %>','<%=rowData.get("PROJECT_MNG_USER")%>')"'><%=rowData.get("BURQ_NO")%></a></td>
						<td><a class="hyperLink" href="javascript:setReturn('<%=rowData.get("BURQ_NO")%>','<%=rowData.get("PROJECT_NAME")%>','<%=rowData.get("PROJECT_UNIT") %>','<%=rowData.get("PROJECT_MNG_USER")%>')"'><%=rowData.get("PROJECT_NAME")%></a></td>
						<td><a class="hyperLink" href="javascript:setReturn('<%=rowData.get("BURQ_NO")%>','<%=rowData.get("PROJECT_NAME")%>','<%=rowData.get("PROJECT_UNIT") %>','<%=rowData.get("PROJECT_MNG_USER")%>')"'><%=rowData.get("PROJECT_STAUTS_TEXT")%></a></td>
						<td><a class="hyperLink" href="javascript:setReturn('<%=rowData.get("BURQ_NO")%>','<%=rowData.get("PROJECT_NAME")%>','<%=rowData.get("PROJECT_UNIT") %>','<%=rowData.get("PROJECT_MNG_USER")%>')"'><%=rowData.get("PM_NAME")%></a></td>
					</tr> 
<%	} 
}%>                               
                    </tbody>
                </table> 
             </div>    
	    </div>        
	</div>
</form> 
</body>
</html>