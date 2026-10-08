<%--
**********************************************
* 메뉴 : 재고일일수불_일일결산List
* 화면 : 재고일일수불_일일결산List
* 기능 : 일자별 일일 결산리스트를 조회함.
* 프로그램 ID : PG_08_M_014_01
* 담당자 : 김지혜 ( 설계 : 김상근 )
* 착수일 : 2014-8-29
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8"	pageEncoding="utf-8" isELIgnored="false"%>
<%@ include file="../../common/include/head.jspf"  %>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="java.util.HashMap"%> 
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>

<!DOCTYPE html>
<html>
<head>


<%
String buyer = "";
String userid = "";
if (_sessionInfo != null){
	buyer =  CommonUtil.nvl((String)_sessionInfo.getComCode()); 	
	userid =  CommonUtil.nvl((String)_sessionInfo.getUserId());  		
} 


String st_warehouse_code = CommonUtil.nvl((String) request.getParameter("st_warehouse_code"),""); 
String whAdmin = _sessionInfo.getWhAdmin();


%> 
<script>
var mySheet = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
var popupSel = "";
var remarkOn="/resources/images/but_icon01.gif";
var remarkOff="/resources/images/but_icon02.gif";
var diskOn = "/resources/images/disk_on.gif";
var diskOff = "/resources/images/disk_off.gif";
// 시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view(){

	// 조회조건 초기화
	kepSetCalender("st_cur_date");
	
	$("#st_cur_date").val(kepGetNowTimeStr('YYYYMMDD','/'));

	if("<%=whAdmin%>" != "Y"){

		document.searchCondition.st_warehouse_code.disabled = true;
	}
	
}
	
// 기능함수
function doAction(str) {

	switch (str) {
	case "search":	 // 조회
	document.searchCondition.st_warehouse_code.disabled = false;
	$('#searchCondition').attr("action", "/wmst/getMasterWmStDailyBlncingaccntListPop.do").submit();   
	document.searchCondition.st_warehouse_code.disabled = true;
		break;
	
	case "reload":	// 초기화
		kepReload('searchCondition');
		$("#st_cur_date").val(kepGetNowTimeStr('YYYYMMDD','/'));
		break;
		
	}
	
}


//ajax 공통 호출후 성공시 처리 함수
function kepAjaxSuccess(pMethod , response) {
	var MSG = response.msg;
	if(pMethod == 'search'){
		//alert(response);
	}
}
	
//ajax 공통 호출후 에러시 처리 함수
function kepAjaxError(pMethod , response) {
	
	if(pMethod == 'search'){
		//alert(response);
	}
	
}

</script>


</head>
<body onload="kep_onload_view()">
<!--내용 시작-->
		<!--버튼영역-->
       	<div id="searchBtnA"  >
			<h3>일일결산List</h3>
        	<span class="btn_search"><a href="javascript:doAction('search')">조회</a></span> 
   		</div>        	
        <!--조회영역-->
       	<form id="searchCondition" name="searchCondition" method="post" >
			<div id="cont_searchA">
			<!--HIDDEN-->
			<!-- 공통 -->
			<input type="hidden" name="s_SAVENAME">
			<input type="hidden" id="pageflag" name="pageflag" value="1">
			<!-- 화면 내 정의 -->
			<input type="hidden" id="st_user_id" name="st_user_id"  value="${sessionInfo.userId}">
			<input type="hidden" id="st_com_code" name="st_com_code"  value="${sessionInfo.comCode}">
			
            	<table  class="cont_t_list01"  width="940px" >
					<caption>일일결산List</caption>
					<colgroup>
							<col width="12%" />
							<col width="38%" />
							<col width="12%" />
							<col width="38%" />
					</colgroup>
						
					<tbody>
						<tr>
							<th>조회일자</th>
							<td>
								<input type="text" class="input_type_text" name="st_cur_date"  id="st_cur_date" readOnly style="width:20%; text-align:center;" >					
							</td>
						   <th>물류센터</th>
							<td>
								<select id="st_warehouse_code" name="st_warehouse_code" style="width:80%;height:20px" >
								<%
						 			Map<String, String> _map = new HashMap<String, String>();
						 			_map.put("BUYER",buyer);
						 			_map.put("USERID",userid);
						 			_map.put("whAdmin",whAdmin);
								%>
								<%= CommonUtil.getCodeComboQueryIdList("common.getWareHouseIdSchList","",_map,st_warehouse_code) %>
								</select>
							</td>
						</tr>
					</tbody>
				</table>
            </div>
			<br>
		</form>
					
      	<!--grid-->

        <table  class="cont_t_list08" style="width:60%;" >
        	      <caption>일일결산List</caption>
                    <colgroup>
                        <col width="12%" />
                        <col width="12%" />
                        <col width="*" />
                        <col width="12%" />
                        <col width="12%" />
                        <col width="17%" />
                    </colgroup>
                    <thead style="width:60%">
                         <tr>
                            <th rowspan="2"   colspan="2"  scope="col">구분</th>
                            <th rowspan="2" scope="col">입고</th>
                            <th colspan="2"  scope="col">출고</th>
                            <th rowspan="2" scope="col">재고</th>
                        </tr>
                        <tr>
                          <th scope="col">매출금액</th>
                          <th scope="col">매출원가금액</th>
                        </tr>                   
                    </thead>
                    <tbody style="width:60%">
                    <%
                    @SuppressWarnings (value="unchecked")
                    List<Map<String,String>> _dataList = (List<Map<String,String>>) request.getAttribute("_data"); // 조회된 결과
                    if ( _dataList != null && _dataList.size()>=1 ){
                    for(int i=0; i< _dataList.size();i++){
                    	Map<String,String> rowData = _dataList.get(i);
                    
                    %>
                    
			<tr>
				<%if( i==1 || i==0 ){ %>
				<td <%=i==1?"rowspan=\"3\"":""%> width="13%" height="25" class="text_center_grey1"><%=i==0?"전일":"당일"%><br>
					(<%=CommonUtil.formatStrinigDate(rowData.get("DAY"))%>)</td>
				<%}else if(i== 4){%>
				<td height="5" class="text_center_blue1">&nbsp;</td>
				<%}%>
				<td width="20%" height="25" class="text_center_blue"><b><%=rowData.get("GUBUN")%></b></td>
				<td height="25" style="text-align:right; padding-right:5px"><%=CommonUtil.formatNumber(rowData.get("GR_AMT"),true,0,3)%></td>
				<td height="25" style="text-align:right; padding-right:5px"><%=CommonUtil.formatNumber(rowData.get("UNIT_AMT"),true,0,3)%></td>
				<td height="25" style="text-align:right; padding-right:5px"><%=CommonUtil.formatNumber(rowData.get("LIST_AMT"),true,0,3)%></td>
				<td height="25" style="text-align:right; padding-right:5px"><%=CommonUtil.formatNumber(rowData.get("CUR_AMT"),true,0,3)%></td>
			</tr>                    
                    <% } 
                    } %>
                    </tbody>
  		</table>	
  	
  			<!--버튼영역-->
               <div class="btnArea">
  	          	<span class="fl">
					
  				</span>
  			 </div>

<!--내용 종료-->	                 

</body>
</html>
