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
String st_del_name = CommonUtil.nvl((String) request.getParameter("st_del_name"),"");  //  (조회조건)
String st_buyer_code = CommonUtil.nvl((String) request.getParameter("st_buyer_code"),"");  //  (조회조건)
String st_ent_confirm = CommonUtil.nvl((String) request.getParameter("st_ent_confirm"),"");  //  Entity Maker 진행확인 사용여부
String st_alias_yn = CommonUtil.nvl((String) request.getParameter("st_alias_yn"),"");  //  Y = 유사명 컬럼 표시 (호출 화면이 지정)
boolean _aliasCol = "Y".equals(st_alias_yn);
%>
<script type="text/javascript">
<!--
function setQuery()
{    
	
	if (kepIsEmpty("st_del_name")){
	    alert("검색조건을 입력하세요.");
	    $("st_del_name").focus();
		return;
	} 
	
// 	$('#agentRegMakerCodePop').attr("action", "/common/getAgentRegMakerCodePop.do").submit();
	$('#agentRegMakerCodePop').attr("action", "/common/commonList.do").submit();
}

function kepEnter() {	
	if (event.keyCode == 13) { 
		setQuery();
	}
}
function setReturn(value1,value2,value3,value4, flag)
{ 
  if(flag == "N") {
	  if($("#st_ent_confirm").val() != "Y") {
		  alert("선택하신 제조사는 Entity Maker로 견적이 불가합니다.");
		  return;
	  }
	  if (!confirm("선택하신 제조사는 Entity Maker입니다.\n해당 제조사로 진행하시겠습니까?"))
		  return;

	  var reason = prompt("Entity Maker 선택 사유를 입력하세요.", "");
	  if (reason == null) return;

	  reason = reason.replace(/^\s+|\s+$/g, "");
	  if (reason == "") {
		  alert("사유를 입력해야 진행할 수 있습니다.");
		  return;
	  }
	  if (reason.length > 300) {
		  alert("사유는 300자 이내로 입력하세요.");
		  return;
	  }

	  opener.setPopupReturn(value1,value2,value3,value4,reason);
	  this.close();
	  return;
  }	
  opener.setPopupReturn(value1,value2,value3,value4);
  this.close();
}
 //-->
</script> 
<body>
	 <form name=agentRegMakerCodePop id=agentRegMakerCodePop method=post >
	 <input type="hidden" name="codeGubun" id="codeGubun"  value="agentRegMakerCodePop">
	 <input type="hidden" name="st_buyer_code" id="st_buyer_code"  value="<%=st_buyer_code%>"> 
	 <input type="hidden" name="st_ent_confirm" id="st_ent_confirm"  value="<%=st_ent_confirm%>">
	 <input type="hidden" name="st_alias_yn" id="st_alias_yn"  value="<%=st_alias_yn%>">
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다-->
	<div id="popWrapper" style="height:494px; min-height: 100px;">
    	<div id="popHeader">
        	<h1 class="title">제조사 정보</h1>
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
						<caption>Maker검색 리스트</caption>
						<colgroup>
							<col width="<%=_aliasCol ? "16%" : "10%"%>" />
							<col width="18%" />
							<col width="9%" />
							<col width="15%" />
							<col width="10%" />
                            <col width="10%" />
                            <col width="*" />
						</colgroup>
						<tbody>
						<tr>
							<td><%if(_aliasCol){%>제조사명/유사명<%}else{%>제조사명<%}%></td>
							<td>
								<input type=text name="st_del_name"  id="st_del_name" size=20 value="<%=st_del_name%>" onkeydown="kepEnter()" style="ime-mode:active">
								<input type=text name="tem_input_h" id="tem_input_h" style="display: none;" />
                            </td>
						    <td></td>						 
							<td  class="right"> 
							</td>
						</tr>					 
					</tbody>
				</table>
            </div>            
            	<!--grid-->
	            <div class="scrollArea" style="height:338px">                
                <table  class="cont_t_list02"  style="width:100%">
                    <caption>Maker검색 리스트</caption>
                    <colgroup>
<%if(_aliasCol){%>
                        <col width="15%" />
                        <col width="23%" />
                        <col width="15%" />
                        <col width="27%" />
                        <col width="20%" />
<%}else{%>
                        <col width="20%" />
                        <col width="30%" />
                        <col width="20%" />
                        <col width="30%" />
<%}%>
                    </colgroup>
                    <thead>
                        <tr>
                            <th scope="col">제조사코드</th>
                            <th scope="col">제조사명</th>
                            <th scope="col">원산지</th>
                            <th scope="col">주요생산품목</th>
<%if(_aliasCol){%>
                            <th scope="col">비고(유사명)</th>
<%}%>
                        </tr>
                    </thead>
                    <tbody>
<%
if (_dataList == null || _dataList.size() == 0){
%>
               		<tr bgcolor="#FFFFFF">
                        <td colspan="<%=_aliasCol ? 5 : 4%>" align="center" height = "270">
                        <span class="font1">조회된 데이타가 없습니다.</span>
                        </td> 
                    </tr>
<%}else{
for (int j=0; j<_dataList.size(); j++) {
	Map<String,String> rowData = _dataList.get(j);
%> 
                        <tr>
							<td>
							 	<a href="javascript:setReturn('<%=rowData.get("CODE")%>','<%=rowData.get("TEXT1")%>','<%=rowData.get("TEXT3")%>','<%=rowData.get("TEXT4")%>','<%=rowData.get("FLAG")%>')">
								<%=rowData.get("CODE")%></a>
							</td>
							<td class="left">
							  	<a href="javascript:setReturn('<%=rowData.get("CODE")%>','<%=rowData.get("TEXT1")%>','<%=rowData.get("TEXT3")%>','<%=rowData.get("TEXT4")%>','<%=rowData.get("FLAG")%>')">
								<%=rowData.get("TEXT1")%></a>
						   </td>
							<td>
							 	<a href="javascript:setReturn('<%=rowData.get("CODE")%>','<%=rowData.get("TEXT1")%>','<%=rowData.get("TEXT3")%>','<%=rowData.get("TEXT4")%>','<%=rowData.get("FLAG")%>')">
								<%=rowData.get("TEXT4")%></a>
							</td>
							<td class="left">
							  	<a href="javascript:setReturn('<%=rowData.get("CODE")%>','<%=rowData.get("TEXT1")%>','<%=rowData.get("TEXT3")%>','<%=rowData.get("TEXT4")%>','<%=rowData.get("FLAG")%>')">
								<%=CommonUtil.nvl(rowData.get("TEXT5"))%></a>
						   </td>
<%if(_aliasCol){%>
							<td class="left">
							  	<a href="javascript:setReturn('<%=rowData.get("CODE")%>','<%=rowData.get("TEXT1")%>','<%=rowData.get("TEXT3")%>','<%=rowData.get("TEXT4")%>','<%=rowData.get("FLAG")%>')">
								<%=CommonUtil.nvl(rowData.get("TEXT8"))%></a>
						   </td>
<%}%>
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
