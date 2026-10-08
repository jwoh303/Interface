<%--
**********************************************
* 메뉴 : 
* 화면 : 기존카탈로그 조회
* 기능 : 
* 프로그램 ID : PG_90_C_900_13
* 담당자 : 고영일 ( 설계 : 공통 )
* 착수일 : 2014-07-30
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
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>코리아 e 플랫폼</title>
<head>
<%@ include file="../../../common/include/head_pop.jspf"  %>

</head>
<%
@SuppressWarnings (value="unchecked")
List<Map<String,String>> _dataList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된 결과

String st_buyer = CommonUtil.nvl((String) request.getParameter("st_buyer"),"");
String st_buyer_name = CommonUtil.nvl((String) request.getParameter("st_buyer_name"),"");

String st_buyer_item_no = CommonUtil.nvl((String) request.getParameter("st_buyer_item_no"),""); 	//  (조회조건)
String st_description_loc = CommonUtil.nvl((String) request.getParameter("st_description_loc"),""); 	//  (조회조건)
String st_specification = CommonUtil.nvl((String) request.getParameter("st_specification"),""); 	//  (조회조건)
String st_order_by = CommonUtil.nvl((String) request.getParameter("st_order_by"),"1"); 	//  (조회조건)

%>

<script type="text/javascript">
// <!--
function kepSearch(){
	var st_buyer_item_no = $("#st_buyer_item_no").val();
	var st_description_loc = $("#st_description_loc").val();
	var st_specification = $("#st_specification").val();
	
	if(st_buyer_item_no == "" && st_description_loc == "" && st_specification == ""){
		alert("적어도 한 개 이상의 항목을 입력하여 주십시오.");
		return;
	}
	
	$('#commonCoCoExistingCatalogPop').attr("action", "/coco/getCommonCoCoExistingCatalogPop.do").submit();    
}

function kepEnter() {	
	if (event.keyCode == 13) { 
		kepSearch();
	}
}

function setReturn(value1,value2,value3,value4,value5,value6,value7,value8,value9,value10,value11,value12,value13,value14,value15,value16)
{ 
  opener.setPopupReturn(value1,value2,value3,value4,value5,value6,value7,value8,value9,value10,value11,value12,value13,value14,value15,value16);
  this.close();
}

//팝업함수호출
function doPop(str, param1) {
	popupSel = str;
	
	switch (str) {
		case "agent": // 고객사 M
			openSearchPopup("/common/agentInfoDisplayPop.do", "?st_com_code="+param1, "800,550,no");
			break;
	}
}
 //-->
</script> 
<body onload="">
<form name="commonCoCoExistingCatalogPop" id="commonCoCoExistingCatalogPop" method=post >
	<input type="hidden" name="st_buyer" id="st_buyer"  value="<%=st_buyer%>">
	<input type=hidden name="st_buyer_name" id="st_buyer_name"  value="<%=st_buyer_name%>">
	
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다 / 500*500-->
	<div id="popWrapper" style="height:605px; min-height: 100px;">
    	<div id="popHeader">
        	<h1 class="title">기존카탈로그 조회</h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/<%=_closeImgSrc %>" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer">
             <div id="searchBtnA02">
            	<span class="btn_search"><a href="javascript:kepSearch();">조회</a></span>  
            </div>
            <!--조회영역-->
            <div id="cont_searchA">
            	<table class="cont_t_list01" style="width:100%">
						<caption>기존카탈로그 조회 리스트</caption>
						<colgroup>
							<col width="10%" />
							<col width="40%" />
							<col width="10%" />
                            <col width="*" />
						</colgroup>						
						<tbody>
						<tr>
							<td>고객사</td>
							<td><%=st_buyer_name %></td>
							<td>품목코드</td>
							<td> 
								<input type=text name="st_buyer_item_no" id="st_buyer_item_no" size="40" value="<%=st_buyer_item_no%>" onkeydown="kepEnter()" class="input_type_text"> 
							</td>
						</tr>
						<tr>
							<td>품명</td>
							<td>
								<input type=text name="st_description_loc" id="st_description_loc" size="40" value="<%=st_description_loc%>" onkeydown="kepEnter()" class="input_type_text">
							</td>
							<td>규격</td>
							<td> 
								<input type=text name="st_specification" id="st_specification" size="40" value="<%=st_specification%>" onkeydown="kepEnter()" class="input_type_text"> 
							</td>
						</tr>
					</tbody>
				</table>
            </div>
            
            <div id="searchBtnA02">
				<select id="st_order_by" name="st_order_by"  onchange="javascript:set_order_by(this.value)">
					<option <%=(st_order_by.equals("1") ? "selected" : "")%> value = "1">품목코드</option>
					<option <%=(st_order_by.equals("2") ? "selected" : "")%> value = "2">품명순</option>
					<option <%=(st_order_by.equals("3") ? "selected" : "")%> value = "3">규격순</option>
					<option <%=(st_order_by.equals("4") ? "selected" : "")%> value = "4">제조사순</option>
					<option <%=(st_order_by.equals("5") ? "selected" : "")%> value = "5">공급회원사순</option>
					<option <%=(st_order_by.equals("6") ? "selected" : "")%> value = "6">등록순</option>
				</select>
            </div>
           	<!--grid-->
            <div class="scrollArea" style="height:388px">
                <table  class="cont_t_list02"  style="width:100%">
                    <caption>기존카탈로그 조회 리스트</caption>
                    <colgroup>
                        <col width="20%" /> 
                        <col width="15%" /> 
                        <col width="15%" /> 
                        <col width="15%" /> 
                        <col width="*" /> 
                        <col width="15%" /> 
                    </colgroup>
                    <thead>
                        <tr>
                            <th scope="col">품목코드</th>
                            <th scope="col">매출단가</th>
                            <th scope="col">매입단가</th>
                            <th scope="col">매익률(%)</th>
                            <th scope="col">제조사</th>
                            <th scope="col">원산지</th>
                        </tr>
                        <tr>
                            <th scope="col">협력사</th>
                            <th scope="col" colspan="2">품명</th>
                            <th scope="col" colspan="3">규격</th>
                        </tr>
                    </thead>
                    <tbody>
<%
if (_dataList == null || _dataList.size() == 0){
%>
               		<tr bgcolor="#FFFFFF">
                        <td colspan="7" align="center" height = "280">
                        <span class="font1">조회된 데이타가 없습니다.</span>
                        </td> 
                    </tr>
<%}else{
for (int j=0; j<_dataList.size(); j++) {
	Map<String,String> _tmp = _dataList.get(j);
%> 
					<tr <%if(j%2 == 1){ %>style="background-color: #F0F8FF;"<%} %>>
						<td>
							<a class="hyperLink" href="javascript:setReturn('<%=_tmp.get("BUYER_ITEM_NO")%>','<%=_tmp.get("DESCRIPTION")%>','<%=_tmp.get("SPECIFICATION")%>','<%=_tmp.get("MAKER_NAME")%>','<%=_tmp.get("MAKER_CODE")%>','<%=_tmp.get("ORIGIN_TEXT")%>','<%=_tmp.get("ORIGIN_CODE")%>','<%=_tmp.get("UNIT_MEASURE")%>','<%=CommonUtil.bnvl(_tmp.get("UNIT_PRICE"))%>','<%=CommonUtil.bnvl(_tmp.get("LIST_PRICE"))%>','<%=_tmp.get("AGENT_TEXT")%>','<%=_tmp.get("AGENT")%>','<%=_tmp.get("CONTRACT_NO")%>','<%=_tmp.get("CONTRACT_SEQ")%>','<%=_tmp.get("PROCESS_TYPE")%>','<%=_tmp.get("ORIGIN_AGENT")%>')">
							<%=CommonUtil.nvl(_tmp.get("BUYER_ITEM_NO"))%></a>
						</td>
						<td class="right">&nbsp;
							<%=CommonUtil.formatNumber(_tmp.get("UNIT_PRICE"), true, 0, 3)%>
						</td>
						<td class="right">&nbsp;
							<%=CommonUtil.formatNumber(_tmp.get("LIST_PRICE"), true, 0, 3)%>
						</td>
						<td class="right">&nbsp;
							<%=CommonUtil.bnvl(_tmp.get("RATE"))%>
						</td>
						<td>
							<%=CommonUtil.nvl(_tmp.get("MAKER_NAME"))%>&nbsp;
						</td>
						<td>
							<%=CommonUtil.nvl(_tmp.get("ORIGIN_TEXT"))%>&nbsp;
						</td>
					</tr>
					<tr <%if(j%2 == 1){ %>style="background-color: #F0F8FF;"<%} %>>
						<td class="left">
							<a href="javascript:doPop('agent', '<%=_tmp.get("AGENT")%>')">
							<%=CommonUtil.nvl(_tmp.get("AGENT_TEXT"))%></a>
						</td>
						<td colspan="2" class="left">
							<%=CommonUtil.nvl(_tmp.get("DESCRIPTION"))%>&nbsp;
						</td>
						<td colspan="3" class="left">
							<%=CommonUtil.nvl(_tmp.get("SPECIFICATION"))%>&nbsp;
						</td>
					</tr>
<% } 
}%>                               
                    </tbody>
                </table>                  
        </div>
    </div>        
</div>
</form> 
</body>
</html>
