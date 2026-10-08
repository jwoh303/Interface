<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%> 
<!doctype html>
<html>
<head>
<%@include file="../../common/include/head.jspf" %>
</head>
<%
@SuppressWarnings (value="unchecked")
List<Map<String,String>> _dataList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된결과
String result =  CommonUtil.nvl((String) request.getAttribute("result")); // 조회된결과
String TYPE = CommonUtil.nvl((String) request.getParameter("TYPE"),"");  //  (조회조건)   
%>
<body onload="kep_onload_view()"> 
<div id="wrapper"> 
<!-----------------------------------------------------------------------------------------------header------------------------------------------------------------------------------------------------------->
<%@ include file="/WEB-INF/views/common/include/buyerHeader.jsp" %>   

<div id="container2">
<c:import charEncoding="utf-8" url="/menu/menu.do">
<c:param name="page" value="buyerLeft"/>
<c:param name="part" value="${param.upperId}"/>
</c:import>

<!--내용 시작-->		
<!--내용 시작-->	
<!--내용 시작-->	
<div id="ContArea">
        	<h3>codeMaster 샘플</h3>
        	<!--버튼영역-->
            <div id="searchBtnA">
            	<span class="btn_search"><a href="javascript:KepSearch()">조회</a></span> 
				<span class="btn_search"><a href="javascript:KepExcelSearch()">Excel</a></span>  
			</div>
            <!--조회영역-->
            <form name = "searchForm"  id="searchForm" method = "post">
            <input type="hidden" id="upperId"  name="upperId" value="<c:out value="${param.upperId}"/>">    	
             <div id="cont_searchA">        	
        		<table  class="cont_t_list01"  style="width:100%">
						<caption>codeMaster</caption>
						<colgroup>
							<col width="10%" />
							<col width="10%" />
							<col width="9%" />
							<col width="15%" />
							<col width="10%" />
                            <col width="10%" />
                            <col width="*" />
						</colgroup>						
						<tbody>
						<tr>
							<td>TYPE</td>
							<td colspan="3">			 
	                              <select name="TYPE" id="TYPE" style="width:100px">           
						         	 <%=CommonUtil.getCodeComboQueryIdList("common.getICOMCOD1","SEL",TYPE)%>
						         </select>
                            </td>
						    <td></td>
							<td></td>
							<td rowspan="2" class="right"></td>
						</tr> 
					</tbody>
				</table>
            </div>  
            </form> 
            <div> 			
            <div> 
			<form name = "contentForm"  id="contentForm" method = "post"> 
				<input type="hidden" name="FORM_TYPE" id="FORM_TYPE" value="">
				<input type="hidden" name="s_SAVENAME" id="s_SAVENAME" value="TYPE|CODE|TEXT1|TEXT2|TEXT3|TEXT4|TEXT5|TEXT6|FLAG|VALUE1|ADD_DATE">
 				<input type="hidden" id="upperId"  name="upperId" value="<c:out value="${param.upperId}"/>">    	
            	<!--grid-->
                <table  class="cont_t_list02"  style="width:100%">
                    <caption>공지사항 리스트</caption>
                          <colgroup>
                        <col width="7%" />
                        <col width="7%" />
                        <col width="7%" />
                        <col width="7%" />
                        <col width="7%" />
                        <col width="7%" /> 
                        <col width="7%" />
                        <col width="7%" />
                        <col width="7%" />
                        <col width="7%" />
                        <col width="7%" />
                        <col width="7%" />
                    </colgroup>
                    <thead>
                        <tr>
                            <th scope="col">TYPE</th>
                            <th scope="col">CODE</th>
                            <th scope="col">TEXT1</th>
                            <th scope="col">TEXT2</th>
                            <th scope="col">TEXT3</th>
                            <th scope="col">TEXT4</th>
                            <th scope="col">TEXT5</th> 
                            <th scope="col">TEXT6</th> 
                            <th scope="col">FLAG</th> 
                            <th scope="col">VALUE1</th> 
                            <th scope="col">ADD_DATE</th> 
                             <th scope="col">행삭제</th> 
                        </tr>    
                    </thead>
     <tbody  id="d_tbody">   
<%
if (_dataList == null || _dataList.size() == 0){
%>
                            <tr bgcolor="#FFFFFF">
                        <td colspan="12" align="center" height = "50"> 
                        <span>조회된 데이타가 없습니다.</span>
                        </td> 
                    </tr>
<%
     }else{
for (int j=0; j<_dataList.size(); j++) {
	Map<String,String> rowData = _dataList.get(j);
%> 				        
				            <tr>
				                <td><input type="text" class="input_type_text" name="TYPE" id="TYPE" size="10" value="<%=CommonUtil.nvl( rowData.get("TYPE"))%>"  class="input_type_text" ></td>
				                <td><input type="text" class="input_type_text" name="CODE" id="CODE" size="10"  value="<%=CommonUtil.nvl( rowData.get("CODE"))%>"  class="input_type_text" ></td>
				                <td><input type="text" class="input_type_text" name="TEXT1" id="TEXT1" size="10"  value="<%=CommonUtil.nvl( rowData.get("TEXT1"))%>"  class="input_type_text" ></td>
				                <td><input type="text" class="input_type_text" name="TEXT2" id="TEXT2" size="10"  value="<%=CommonUtil.nvl( rowData.get("TEXT2"))%>"  class="input_type_text" ></td>
				                <td><input type="text" class="input_type_text" name="TEXT3" id="TEXT3" size="10"  value="<%=CommonUtil.nvl( rowData.get("TEXT3"))%>"  class="input_type_text" ></td>
				                <td><input type="text" class="input_type_text" name="TEXT4" id="TEXT4" size="10"  value="<%=CommonUtil.nvl( rowData.get("TEXT4"))%>"  class="input_type_text" ></td>
				                <td><input type="text" class="input_type_text" name="TEXT5" id="TEXT5" size="10"  value="<%=CommonUtil.nvl( rowData.get("TEXT5"))%>"  class="input_type_text" ></td>
				                <td><input type="text" class="input_type_text" name="TEXT6" id="TEXT6" size="10"  value="<%=CommonUtil.nvl( rowData.get("TEXT6"))%>"  class="input_type_text" ></td>
				                <td><input type="text" class="input_type_text" name="FLAG" id="FLAG" size="10"  value="<%=CommonUtil.nvl( rowData.get("FLAG"))%>"  class="input_type_text" ></td>
				                <td><input type="text" class="input_type_text" name="VALUE1" id="VALUE1" size="10"  value="<%=CommonUtil.bnvl( rowData.get("VALUE1"))%>"  class="input_type_text" ></td>
				                <td><input type="text" class="input_type_text" name="ADD_DATE" id="ADD_DATE" size="10"  value="<%=CommonUtil.nvl(rowData.get("ADD_DATE"))%>"  class="input_type_text" ><a href="#" onClick="gridPopOpen(this,1)">달력</a></td>
				                <td><a href="#" id="row_delete"  onclick="kepRowRemove(this)">행삭제</a></td>
				            </tr>
<%
}
%>
<%
}
%>								            
				      </tbody>				    
                </table>
            </form>
                <!--버튼영역-->
                                <!--버튼영역-->
<%
if (_dataList == null || _dataList.size() == 0){
}else{
%>
           <div class="btnArea" align="right"> 
           	<span class="btn_04 mr04"><a href="javaScript:kepRowAdd();">행추가</a></span>
           	<span class="btn_04 mr04"><a href="javaScript:kepSave();">저장</a></span>
</div>				 
           <div align="right"> 
           	행 삭제후 저장필요
</div>				 
<%} %> 
            </div>                     
        </div>
    </div>    
</div>     
<!--내용 종료-->	                  
<!--내용 종료-->	                 
<!--내용 종료-->	 

<%@ include file="/WEB-INF/views/common/include/buyerFooter.jsp" %>   
</div>
</body>
<script type="text/javascript">
 
 	var gridIndex = 0;
 	var popupSel = "";
 	
	function kepRowAdd(){
       $add_html = $('#d_tbody tr:last').clone();
       $('#d_tbody').append($add_html);  
	}
	
	function kepRowRemove(obj){ 
       row_delete(obj);
	}
	
   //삭제함수
   function row_delete(obj) {
       if($('#d_tbody tr').size() > 1){
           alert('삭제');
           $(obj).parent().parent().remove();
       }
       else {
           alert('처음 행 삭제불가');
           return false;
       }
   }
   
   function KepSearch() {	   
	   
	   if (document.searchForm.TYPE.value == ""){
		   alert("TYPE 선택하세요."); 
		   return;
	   }
	   
	   $('#searchForm').attr("action", "/board/codeMasterList.do").submit();  
   }
   
   function KepExcelSearch() {
	   $('#searchForm').attr("action", "/board/codeMasterExcelList.do").submit();    
  } 
    
   function kepSave() {
	   $('#FORM_TYPE').val( $('#TYPE').val());   
	   kepAjaxFormCall("/board/codeMasterProcess.do","contentForm","kepSave"); 
  }
  
   function kep_onload_view(){   
	} 
   
   /**
	 * ajax 공통 호출후 성공시 처리 함수
	 */
	function kepAjaxSuccess(pMethod , response){ 
		if (pMethod == "kepSave"){
			alert("저장이 성공적으로 이루어 졌습니다. ");
		} 
		// 처리후 재조회
		KepSearch();
	}

	/**
	 * ajax 공통 호출후 에러시 처리 함수
	 */
	function  kepAjaxError(pMethod , response) { 
		if (pMethod == "kepSave"){
			 alert("저장이 실패하였습니다.\n\n다시 한 번 시도해 주시기 바랍니다.  "); 
		}  
		// 처리후 재조회
		KepSearch();		
	} 
   
   var gridIndex = 0;
   function gridPopOpen(obj1,obj2){
		 gridIndex = $(obj1).parent().parent().index();   
	   	 if (obj2==1){
	   		 kepCalendarOpenPopup();
	   	 } 
	   }
	   
	   function setPopupCalendar(value1){ 
		   $("input[name=ADD_DATE]").eq(gridIndex).val(value1); 
	   }   
 
    </script>
    </html>
