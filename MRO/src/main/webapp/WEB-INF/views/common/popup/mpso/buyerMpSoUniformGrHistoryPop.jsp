<%--
**********************************************
* 메뉴 : 유니폼 재고현황 > 생산입고 이력관리 팝업
* 화면 : 유니폼 생산입고 이력관리 팝업
* 기능 : 
* 프로그램 ID :
* 담당자 : HSJ
* 착수일 : 2020-05-11
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
List<Map<String,String>> _dataList_hd = (List<Map<String,String>>) request.getAttribute("data_hd"); // 조회된결과
List<Map<String,String>> _dataList_dt = (List<Map<String,String>>) request.getAttribute("data_dt"); // 조회된결과
String buyer = CommonUtil.nvl((String) request.getParameter("buyer"), "");
String st_buyer_item_no = CommonUtil.nvl((String) request.getParameter("st_buyer_item_no"), "");
Map<String,String> rowData_hd = null;

if (_dataList_hd == null || _dataList_hd.size() == 0){	 
}else{	
	rowData_hd = _dataList_hd.get(0); 
}
%>

<script type="text/javascript">
function kep_onload(){
}

function setReturn(value1,value2,value3){ 
}

</script>

<body onload="kep_onload();">
	 <form name="uniformGrPop" id="uniformGrPop" method=post >
	 <input type="hidden" name="codeGubun" id="codeGubun"  value="uniformGrPop">
	 <input type="hidden" name="buyer" id="buyer"  value="<%=buyer%>">
	 <input type="hidden" name="st_buyer_item_no" id="st_buyer_item_no"  value="<%=st_buyer_item_no%>">
	 
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다-->
	<div id="popWrapper" style="height:494px;">
    	<div id="popHeader">
        	<h1 class="title">유니폼 생산입고 이력관리</h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/<%=_closeImgSrc %>" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer">
            <!--조회영역-->
            <div id="cont_searchA">
            	<table  class="cont_t_list01"  style="width:100%">
						<caption>유니폼 생산입고 이력관리</caption>
						<colgroup>
							<col width="10%" />
							<col width="20%" />
							<col width="12%" />
							<col width="58%" />
						</colgroup>						
						<tbody>
						<tr>
							<td><%=CommonLang.get("HTITLE12") %> : <!-- 품목코드 --></td>
							<td><%=CommonUtil.nvl(rowData_hd.get("BUYER_ITEM_NO"))%></td>
							
							<td>품명 / 규격 : </td>
							<td><%=CommonUtil.nvl(rowData_hd.get("DESCRIPTION"))%> / <%=CommonUtil.nvl(rowData_hd.get("SPECIFICATION"))%></td>
						</tr>
					</tbody>
				</table>
            </div>            
           	<!--grid-->
            <div class="scrollArea" style="height:380px">
                <table id="table_list" class="cont_t_list02" style="width:100%">
                    <caption>유니폼 생산입고 이력관리</caption>
                    <colgroup>
                        <col width="20%" />
                        <col width="25%" />
                        <col width="15%" />
                        <col width="25%" />
                        <col width="15%" />
                    </colgroup>
                    <thead>
                        <tr>
                            <th scope="col">요청번호</th> 
                            <th scope="col">요청일시</th> 
                            <th scope="col">요청수량</th>
                            <th scope="col">입고일시</th>
                            <th scope="col">입고수량</th>
                        </tr>
                    </thead>
                    <tbody id="tblData">
<%
if (_dataList_dt == null || _dataList_dt.size() == 0){
%>
               		<tr bgcolor="#FFFFFF">
                        <td colspan="5" align="center" height="150px">
                        	<span class="font1"><%=CommonLang.msg("MSG347") %><!-- 조회된 데이타가 없습니다. --></span>
                        </td>
                    </tr>
<%}else{
for (int j=0; j<_dataList_dt.size(); j++) {
	Map<String,String> rowData = _dataList_dt.get(j);
%> 
					<tr>
						<td>
						 	<%=rowData.get("ST_NO")%>
						</td>
						<td class="center">
							<%=rowData.get("ADD_DATE")%>
						</td>
						<td class="right">
							<%=rowData.get("ITEM_QTY")%>
						</td>
						<td class="center">
							<%=rowData.get("GR_DATE")%>
						</td>
						<td class="right">
							<%=rowData.get("GR_QTY")%>
						</td>
					</tr>
	<%}%>
<%}%>
                    </tbody>
                </table>                  
        </div>
    </div>        
</div>
</form> 
</body>
</html>
