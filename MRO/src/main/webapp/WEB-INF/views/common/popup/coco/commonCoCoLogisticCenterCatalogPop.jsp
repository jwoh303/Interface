<%--
**********************************************
* 메뉴 : 
* 화면 : 물류센터 카탈로그 조회 팝업
* 기능 : 
* 프로그램 ID : 
* 담당자 : 고영일 ( 설계 : 공통 )
* 착수일 : 2014-06-24
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
<%@ include file="../../../common/include/head_pop.jspf"  %>

</head>
<%
@SuppressWarnings (value="unchecked")
List<Map<String,String>> _dataList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된 결과 

String st_warehouse_code = CommonUtil.nvl((String) request.getParameter("st_warehouse_code"),"");  //  (조회조건)
String st_agent_name = CommonUtil.nvl((String) request.getParameter("st_agent_name"),"");  //  (조회조건)
String st_agent_code = CommonUtil.nvl((String) request.getParameter("st_agent_code"),"");  //  (조회조건)
String st_stdcatlg_id = CommonUtil.nvl((String) request.getParameter("st_stdcatlg_id"),"");  //  (조회조건)
String st_description = CommonUtil.nvl((String) request.getParameter("st_description"),"");  //  (조회조건)
String st_specification = CommonUtil.nvl((String) request.getParameter("st_specification"),"");  //  (조회조건)
String st_type = CommonUtil.nvl((String) request.getParameter("st_type"),"");  //  (조회조건)

%>

<script type="text/javascript">
<!--
var popupSel = "";

$(document).ready(function(){
	kepAjaxCommonQueryIdCombo('st_warehouse_code','common.getWareHouseList','ALL','<%=st_warehouse_code%>');
});

function kepSearch(){
	if(isEmpty($("#st_warehouse_code").val())){
		alert("물류센터를 선택 하세요.");
		$("#st_warehouse_code").focus();
		return;
	}
	$('#commonCoCoLogisticCenterCatalogPop').attr("action", "/coco/getCommonCoCoLogisticCenterCatalogPop.do").submit();    
}

function kepEnter() {	
	if (event.keyCode == 13) { 
		kepSearch();
	}
}

//팝업함수호출
function doPop(str) {
	switch (str) {
	case "agent_single":
		openSearchPopup("/common/icomcmpyPop.do", "?BUSINESS_COND=S&MULTI=N", "500,466,no");
		popupSel = "agent_single";
		break;
	}
}

//콜백함수(파일명은 모두 동일)
function setPopupReturn(code, text, value3, value4){
	if (popupSel == "agent_single"){ // 협력사
		$("#st_agent_code").val(code);
		$("#st_agent_name").val(text);
	}
}

function reload(){
    location.href="/coco/showCommonCoCoLogisticCenterCatalogPop.do";
}

function setReturn(value1,value2,value3,value4,value5,value6,value7,value8,value9,value10,value11,value12,value13,value14,value15,value16)
{ 
	this.close();
	opener.setPopupReturn(value1,value2,value3,value4,value5,value6,value7,value8,value9,value10,value11,value12,value13,value14,value15,value16);
	
}
 //-->
</script> 
<body onload="">
<form name="commonCoCoLogisticCenterCatalogPop" id="commonCoCoLogisticCenterCatalogPop" method=post >
	
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다 / 500*500-->
	<div id="popWrapper" style="height:594px; min-height: 100px;">
    	<div id="popHeader">
        	<h1 class="title">물류센터 카탈로그 조회</h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/<%=_closeImgSrc %>" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer">
<!--              <div id="searchBtnA02"> -->
<!--             	<span class="btn_search"><a href="javascript:kepSearch();">조회</a></span>   -->
<!--             </div> -->
			<div class="fl">
        		<span class="btn_05"><a href="javascript:alert('준비 중입니다.');">표준 카탈로그</a></span>&nbsp;&nbsp;* 표준코드가 있으면 표준코드 클릭. 없으면 표준 카탈로그 버튼 클릭
        	</div>
        	<div class="fr">
            	<span class="btn_search"><a href="javascript:kepSearch();">조회</a></span>  
				<span class="btn_reset"><a href="javaScript:reload();">초기화</a></span>
            </div>
            <br>
            <!--조회영역-->
            <div id="cont_searchA" class="mt10">
            	<table class="cont_t_list01" style="width:100%">
						<caption>회원사상세정보 리스트</caption>
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
							<td>물류센터</td>
							<td><select id="st_warehouse_code" name="st_warehouse_code"></select></td>
                            <td>공급회원사</td>
                            <td>
                            	<input type=text name="st_agent_name" id="st_agent_name" size=20 value="<%=st_agent_name%>" onkeydown="kepEnter()" class="input_type_text" readonly="readonly">
                            	<input type="hidden" name="st_agent_code" id="st_agent_code" value="<%=st_agent_code%>">
								<a href="javascript:doPop('agent_single');"><img src="/resources/images/btn_search03.gif"></a>
								<a href="javascript:kepEraser('st_agent_name','st_agent_code');"><img src="/resources/images/btn_eraser2.gif"></a>
                            </td>
						    <td>표준코드</td>						 
							<td><input type=text name=st_stdcatlg_id id="st_stdcatlg_id" size=20 value="<%=st_stdcatlg_id%>" onkeydown="kepEnter()" class="input_type_text"></td>
						</tr>
						<tr>
							<td>품목명</td>
							<td><input type=text name=st_description id="st_description" size=20 value="<%=st_description%>" onkeydown="kepEnter()" class="input_type_text"></td>
                            <td>규격</td>
                            <td><input type=text name=st_specification id="st_specification" size=20 value="<%=st_specification%>" onkeydown="kepEnter()" class="input_type_text"></td>
						    <td>공급경로</td>						 
							<td>
								<input class="Noborder" type="radio" name="st_type" value=""  <%if("".equals(st_type)){ %>checked="checked"<%} %>>전체
		                        <input class="Noborder" type="radio" name="st_type" value="1" <%if("1".equals(st_type)){ %>checked="checked"<%} %>>재고
		                        <input class="Noborder" type="radio" name="st_type" value="3" <%if("3".equals(st_type)){ %>checked="checked"<%} %>>VMI</td>
                        	</td>
						</tr>
					</tbody>
				</table>
            </div>            
           	<!--grid-->
            <div class="scrollArea" style="height:388px">
                <table  class="cont_t_list02"  style="width:100%">
                    <caption>물류센터 카테고리 리스트</caption>
                    <colgroup>
                        <col width="9%" /> 
                        <col width="7%" /> 
                        <col width="" /> 
                        <col width="13%" /> 
                        <col width="9%" /> 
                        <col width="7%" /> 
                        <col width="7%" /> 
                        <col width="9%" /> 
                        <col width="7%" /> 
                        <col width="10%" /> 
                    </colgroup>
                    <thead>
                        <tr>
                            <th scope="col">표준코드</th> 
                            <th scope="col">거래유형</th> 
                            <th scope="col">품목명</th> 
                            <th scope="col">규격</th> 
                            <th scope="col">제조사</th> 
                            <th scope="col">단위</th> 
                            <th scope="col">원산지명</th> 
                            <th scope="col">가용재고</th> 
                            <th scope="col">로케이션</th> 
                            <th scope="col">물류관련 협력사</th> 
                        </tr>
                    </thead>
                    <tbody>
<%
if (_dataList == null || _dataList.size() == 0){
%>
               		<tr bgcolor="#FFFFFF">
                        <td colspan="11" align="center" height = "330">
                        <span class="font1">조회된 데이타가 없습니다.</span>
                        </td> 
                    </tr>
<%}else{
for (int j=0; j<_dataList.size(); j++) {
	Map<String,String> _tmp = _dataList.get(j);
%> 
                        <tr>
							<td>
							 	<a href="javascript:setReturn('<%=_tmp.get("PROCESS_TYPE")%>','<%=_tmp.get("PROCESS_NAME")%>','<%=_tmp.get("WAREHOUSE_CODE_AGENT")%>','<%=_tmp.get("WAREHOUSE_NAME")%>','<%=_tmp.get("AGENT")%>','<%=_tmp.get("AGENT_NAME")%>','<%=CommonUtil.bnvl(_tmp.get("LIST_PRICE"))%>','<%=_tmp.get("UNIT_MEASURE")%>','<%=_tmp.get("BUYER_ITEM_NO")%>','<%=_tmp.get("MAKER_NAME")%>','<%=_tmp.get("MAKER_PART_NO")%>','<%=_tmp.get("ORIGIN_TEXT")%>','<%=_tmp.get("ORIGIN_CODE")%>','<%=_tmp.get("STD_CATEG_ID")%>','<%=_tmp.get("CATEG_PATH")%>','<%=_tmp.get("CATEG_NAME")%>')">
								<%=_tmp.get("BUYER_ITEM_NO")%></a>
							</td>
							<td><%=_tmp.get("PROCESS_TEXT")%></td>
							<td class="left"><%=_tmp.get("DESCRIPTION")%></td>
							<td class="left"><%=_tmp.get("SPECIFICATION")%></td>
							<td><%=_tmp.get("MAKER_NAME")%></td>
							<td><%=_tmp.get("UNIT_MEASURE")%></td>
							<td><%=_tmp.get("ORIGIN_TEXT")%></td>
							<td><%=CommonUtil.bnvl(_tmp.get("AVAIL_QTY"))%></td>
							<td><%=_tmp.get("LOCATION_ID")%></td>
							<td>
<%-- 									<a href="javascript:getCompanyDisplayPop('<%=_tmp.get("AGENT")%>','<%=_tmp.get("AGENT_NAME")%>','')"> --%>
									<a href="javascript:alert('준비 중 입니다.');">
								<%=CommonUtil.nvl(_tmp.get("AGENT_NAME"))%></a><br/>(<%=CommonUtil.nvl(_tmp.get("AGENT"))%>)
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
