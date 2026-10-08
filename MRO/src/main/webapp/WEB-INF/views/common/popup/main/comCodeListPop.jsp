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
String h_irs_no1 = CommonUtil.nvl((String) request.getParameter("h_irs_no1"),"");  //  (조회조건) 
String h_irs_no2 = CommonUtil.nvl((String) request.getParameter("h_irs_no2"),"");  //  (조회조건) 
String h_irs_no3 = CommonUtil.nvl((String) request.getParameter("h_irs_no3"),"");  //  (조회조건) 
%>
<script type="text/javascript">
function setQuery()
{
	if( isEmpty($("input[name=h_irs_no1]").val()) || isEmpty($("input[name=h_irs_no2]").val()) || isEmpty($("input[name=h_irs_no3]").val()) ) {
		alert("사업자번호를 입력해주시기 바랍니다.");
		return;
	}else{
		if($("#h_irs_no1").val().length != 3 || $("#h_irs_no2").val().length != 2 || $("#h_irs_no3").val().length != 5){ //3,2,5 자리가 아닌 경우
			alert("사업자번호를 정확하게 입력해주시기 바랍니다.");
			return;
		}
	}
	
	$('#comCodePop').attr("action", "/common/getComCodeList.do").submit();     
}

function kepEnter() {	
	if (event.keyCode == 13) { 
		setQuery();
	}
}
function setReturn(value1,value2,value3,value4)
{ 

  if(value3 == "Y"){ //특수로직 P01-1012-01 있는 경우 사용자 가입 불가능
	  alert("사용자 가입이 불가능한 회원사입니다.");
	  return;
  }else{
	  opener.setPopupReturn(value1,value2,value4);
	  this.close();
  }
}

function popupOnload(){
	//kepAjaxCommonQueryIdCombo('getWareHouseList','sampleCombo','SEL');
}

</script> 
<body  onload="">
	 <form name=comCodePop id=comCodePop method=post >
<!-- 	 <input type="hidden" name="codeGubun" id="codeGubun"  value="comCodePop"> -->
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다-->
	<div id="popWrapper" style="height:494px; min-height: 100px;">
    	<div id="popHeader">
        	<h1 class="title">업체코드</h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/b_btn_popclose.gif" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer">
             <div id="searchBtnA02">
            	<span class="btn_search"><a href="javascript:setQuery();">조회</a></span>  
            </div>   
            <!--조회영역-->
            <div id="cont_searchA">
            	<table  class="cont_t_list01"  style="width:100%">
						<caption>업체 검색 리스트</caption>
						<colgroup>
							<col width="20%" />
							<col width="15%" />
                            <col width="*" />
						</colgroup>						
						<tbody>
						<tr>
							<td></td>
							<td>사업자번호</td>
							<td> 
								<input type=text name="h_irs_no1"  id="h_irs_no1" size=10 maxlength="3" value="<%=h_irs_no1%>" onkeydown="kepEnter()" class="input_type_text" onkeyup="kepNumcheck(this);" onchange="kepNumcheck(this);"> 
								-
								<input type=text name="h_irs_no2"  id="h_irs_no2" size=10 maxlength="2" value="<%=h_irs_no2%>" onkeydown="kepEnter()" class="input_type_text" onkeyup="kepNumcheck(this);" onchange="kepNumcheck(this);"> 
								-
								<input type=text name="h_irs_no3"  id="h_irs_no3" size=10 maxlength="5" value="<%=h_irs_no3%>" onkeydown="kepEnter()" class="input_type_text" onkeyup="kepNumcheck(this);" onchange="kepNumcheck(this);">
                            </td>
                         </tr> 
					</tbody>
				</table>
            </div>            
            <div class="scrollArea" style="height:308px">
            	<!--grid-->
                <table  class="cont_t_list02"  style="width:100%">
                    <caption>업체 리스트</caption>
                    <colgroup>
                        <col width="10%" />  
                        <col width="20%" />  
                        <col width="12%" />  
                        <col width="20%" /> 
                        <col width="*" />   
                    </colgroup>		   
                    <thead> 
                        <tr>   
                            <th scope="col">회원사구분</th> 
                            <th scope="col">사업자번호</th>   
                            <th scope="col">대표자명</th>   
                            <th scope="col">업체코드</th> 
                            <th scope="col">업체명</th>  
                        </tr>
                    </thead>
                    <tbody>
<%
if (_dataList == null || _dataList.size() == 0){
%>
               		<tr bgcolor="#FFFFFF">
                        <td colspan="5" align="center" height = "250">
                        <span class="font1">조회된 데이타가 없습니다.</span>
                        </td> 
                    </tr>
<%}else{
for (int j=0; j<_dataList.size(); j++) {
	Map<String,String> rowData = _dataList.get(j);
%> 
                        <tr>
						    <td class="center"><a href="javascript:setReturn('<%=rowData.get("COM_CODE")%>','<%=rowData.get("COM_NAME_LOC")%>','<%=rowData.get("P01_1012_01_YN")%>','<%=rowData.get("BUSINESS_COND")%>')"><%=CommonUtil.nvl(rowData.get("BUSINESS_COND"))%></a></td>
							<td class="center"><a href="javascript:setReturn('<%=rowData.get("COM_CODE")%>','<%=rowData.get("COM_NAME_LOC")%>','<%=rowData.get("P01_1012_01_YN")%>','<%=rowData.get("BUSINESS_COND")%>')"><%=CommonUtil.nvl(rowData.get("IRS_NO"))%></a></td>
							<td class="center"><a href="javascript:setReturn('<%=rowData.get("COM_CODE")%>','<%=rowData.get("COM_NAME_LOC")%>','<%=rowData.get("P01_1012_01_YN")%>','<%=rowData.get("BUSINESS_COND")%>')"><%=CommonUtil.nvl(rowData.get("CEO_NAME_LOC"))%></a></td>
							<td class="center"><a href="javascript:setReturn('<%=rowData.get("COM_CODE")%>','<%=rowData.get("COM_NAME_LOC")%>','<%=rowData.get("P01_1012_01_YN")%>','<%=rowData.get("BUSINESS_COND")%>')"><%=CommonUtil.nvl(rowData.get("COM_CODE"))%></a></td>
							<td class="left"><a href="javascript:setReturn('<%=rowData.get("COM_CODE")%>','<%=rowData.get("COM_NAME_LOC")%>','<%=rowData.get("P01_1012_01_YN")%>','<%=rowData.get("BUSINESS_COND")%>')"><%=CommonUtil.nvl(rowData.get("COM_NAME_LOC"))%></a></td>
						</tr> 
<% } %>
<%}%>                                   
                    </tbody>
                </table>  		 
        </div>
    </div>        
</div>
</form> 
</body>
</html>
