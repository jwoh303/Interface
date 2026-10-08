<%--
**********************************************
* 메뉴 : 
* 화면 : 하위조직코드 
* 기능 : 하위조직코드 다중선택 팝업
* 프로그램 ID : 
* 담당자 :  홍석규 ( 설계 : 공통 )
* 착수일 : 2014-07-28
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

int grid_cnt = (_dataList != null )? _dataList.size() : 0;

String buyer          		= CommonUtil.nvl((String) request.getParameter("st_buyer"),"");
String st_org_code          		= CommonUtil.nvl((String) request.getParameter("st_org_code"),"");
String buyer_item_no  	= CommonUtil.nvl((String) request.getParameter("st_buyer_item_no"),"");
String agent  	= CommonUtil.nvl((String) request.getParameter("st_agent"),"");
String process_type  	= CommonUtil.nvl((String) request.getParameter("st_process_type"),"");
String nu_i           		= CommonUtil.nvl((String) request.getParameter("st_nu_i"),"");
%>

<script type="text/javascript">

function setReturn(value1,value2)
{ 
	opener.setPopupReturn(value1,value2);
	this.close();
}

function SelectOrgCode(){  
	var tot_cnt = <%=_dataList.size() %>;
	var chk_cnt = 0;
	var j = 0; 
	
	var tmptmp1 = "";
	var tmptmp2 = "";
	for(var i = 0; i < tot_cnt; i++){   
		if ($("input[name=chkCodeResult]").eq(i).is(":checked")) { 
			chk_cnt++;
			j = i;
		}
	}

	if (chk_cnt == 1){
		var tmp = $("input[name=chkCodeResult]").eq(j).val() ; 
		var arrKey = tmp.split("@");
		tmptmp1 = tmptmp1 + arrKey[0];
		tmptmp2 = tmptmp2 + arrKey[1];
	} else {
		for(var i = 0; i < tot_cnt; i++){ 
			if ($("input[name=chkCodeResult]").eq(i).is(":checked")) { 
				var tmp = $("input[name=chkCodeResult]").eq(i).val() ; 
				var arrKey = tmp.split("@");
				tmptmp1 = tmptmp1 + arrKey[0]+"@";
				tmptmp2 = tmptmp2 + arrKey[1]+"@";
			}
		}
	}
	
	setReturn(tmptmp1,tmptmp2);
}
 
</script> 
<body onload="">
<form name="commonCoCoBottomOrgCodeMultiPop" id="commonCoCoBottomOrgCodeMultiPop" method=post >
	
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다 / 500*500-->
	<div id="popWrapper" style="height:300px; min-height: 100px;">
    	<div id="popHeader">
        	<h1 class="title">하위조직코드 </h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/<%=_closeImgSrc %>" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer">
           	<!--grid-->
            <div class="scrollArea" style="height:168px">
                <table  class="cont_t_list02"  style="width:100%">
                    <caption>하위조직코드  리스트</caption>
                    <colgroup>
                        <col width="7%" />
                        <col width="16%" /> 
                        <col width="16%" />
                        <col width="16%" />
                        <col width="16%" />
                        <col width="16%" />
                        <col width="*" /> 
                    </colgroup>
                    <thead>
                        <tr>
                        	<th scope="col">선택</th>
                            <th scope="col">조직코드</th> 
                            <th scope="col">조직명</th> 
                            <th scope="col">협력사</th>
                            <th scope="col">거래유형</th>
                            <th scope="col">매입단가</th>
                            <th scope="col">매출단가</th>
                        </tr>
                    </thead>
                    <tbody>
<%
if (_dataList == null || _dataList.size() == 0){
%>
               		<input type="hidden" name="count" id="count"  value="0">
               		<tr bgcolor="#FFFFFF">
                        <td colspan="7" align="center" height = "110">
                        <span class="font1">조회된 데이타가 없습니다.</span>
                        </td> 
                    </tr>
<%}else{
for (int j=0; j<_dataList.size(); j++) {
	Map<String,String> _tmp = _dataList.get(j);
%> 
                        <tr>
                        <td class="font1_black1"  align="center">
                        	<%
                        		if(st_org_code.equals(_tmp.get("CODE"))){
							%> 
							<input type="checkbox"  name='chkCodeResult' id='chkCodeResult'  value="<%=_tmp.get("CODE")%>@<%=_tmp.get("TEXT")%>" checked disabled>
							<% }else{ %>
							<input type='checkbox' name='chkCodeResult' id='chkCodeResult' value="<%=_tmp.get("CODE")%>@<%=_tmp.get("TEXT")%>">
							<% } %>
							
							<input type="hidden" name="display_item_cnt" id="display_item_cnt" value="<%=_dataList.size() %>" >
							<input type="hidden" id="st_code"	 name="st_code"	        value="<%=_tmp.get("CODE")%>">
							<input type="hidden" id="st_text"  name="st_text" value="<%=_tmp.get("TEXT")%>">
						</td>
						<td>
							<%=_tmp.get("CODE")%>
						</td>
						<td>
							<%=_tmp.get("TEXT")%>
					   </td>
					   <td>
							<%=_tmp.get("AGENT_NAME")%>
					   </td>
					   <td>
							<%=_tmp.get("PROCESS_TYPE_NAME")%>
					   </td>
					   <td class="right">
							<%=CommonUtil.formatNumber(String.valueOf(_tmp.get("LIST_PRICE")),true,0,3)%>
					   </td>
					   <td class="right">
							<%=CommonUtil.formatNumber(String.valueOf(_tmp.get("UNIT_PRICE")),true,0,3)%>
					   </td>
                        </tr> 
<% } %>
						<input type="hidden" name="count" id="count"  value="<%=_dataList.size()%>">
<% } %>                               
                    </tbody>
                </table>                  
        </div>
        <!--버튼영역-->
		<div class="btnArea">
			<%
				if (_dataList == null || _dataList.size() == 0){ 
				}else{ %> 
					<span class="fr">
						<span class="btn_02 mr04 mb20"><a href="javascript:SelectOrgCode()" >확인</a></span>
					</span>                	
	          	<%} %> 
           </div>
    </div>        
</div>
</form> 
</body>
</html>
