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
String flag = CommonUtil.nvl((String) request.getParameter("flag"),"");  //  (조회조건)
String h_com_code = CommonUtil.nvl((String) request.getParameter("h_com_code"),"");  //  (조회조건) 
String h_country = CommonUtil.nvl((String) request.getParameter("h_country"),"");  //  (조회조건) 
String h_com_name = CommonUtil.nvl((String) request.getParameter("h_com_name"),"");  //  (조회조건) 
String h_language = CommonUtil.nvl((String) request.getParameter("h_language"),"");  //  (조회조건)
String st_colse_flag = CommonUtil.nvl((String) request.getParameter("st_colse_flag"),"");  // 거래종려 조회 여부 
%>
<script type="text/javascript">
function setQuery()
{
	if( isEmpty($("input[name=h_country]").val()) && isEmpty($("input[name=h_com_code]").val()) && isEmpty($("input[name=h_com_name]").val()) ) {
		alert("하나 이상의 조회 조건을 입력하세요.");
		return;
	}

	$('#comCodePop').attr("action", "/common/commonList.do").submit();     
}

function kepEnter() {	
	if (event.keyCode == 13) { 
		setQuery();
	}
}
function setReturn(value1,value2,value3,value4,row)
{ 
  var tot_cnt  = $("#display_item_cnt").val();
  var st_irs_no = "";
  var st_business_items ="";
  var st_industry_type ="";
  var st_ceo_name ="";
  var st_zip_code ="";
  var st_adress_loc ="";
  if(eval(tot_cnt) < 2){
	  st_irs_no = document.forms.comCodePop.st_irs_no.value;
	  st_business_items = document.forms.comCodePop.st_business_items.value;
	  st_industry_type = document.forms.comCodePop.st_industry_type.value;
	  st_ceo_name = document.forms.comCodePop.st_ceo_name.value;
	  st_zip_code = document.forms.comCodePop.st_zip_code.value;
	  st_adress_loc = document.forms.comCodePop.st_adress_loc.value;
  }else{
	  st_irs_no = document.forms.comCodePop.st_irs_no[row].value;
	  st_business_items = document.forms.comCodePop.st_business_items[row].value;
	  st_industry_type = document.forms.comCodePop.st_industry_type[row].value;
	  st_ceo_name = document.forms.comCodePop.st_ceo_name[row].value;
	  st_zip_code = document.forms.comCodePop.st_zip_code[row].value;
	  st_adress_loc = document.forms.comCodePop.st_adress_loc[row].value;
  }
  opener.setPopupReturn(value1,value2,value3,value4,st_irs_no,st_business_items,st_industry_type,st_ceo_name,st_zip_code,st_adress_loc);
  this.close();
}

function popupOnload(){
	//kepAjaxCommonQueryIdCombo('getWareHouseList','sampleCombo','SEL');
}
 

</script> 
<body  onload="">
	 <form name=comCodePop id=comCodePop method=post >
	 <input type="hidden" name="codeGubun" id="codeGubun"  value="comCodePop">
	 <input type="hidden" name="st_colse_flag" id="st_colse_flag"  value="<%=st_colse_flag%>"> 
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다-->
	<div id="popWrapper" style="height:494px; min-height: 100px;">
    	<div id="popHeader">
        	<h1 class="title">업체코드</h1>
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
						<caption>업체 검색 리스트</caption>
						<colgroup>
							<col width="15%" />
							<col width="35%" />
							<col width="15%" /> 
                            <col width="*" />
						</colgroup>						
						<tbody>
						<tr>
							<td>국가</td>
							<td> 
								<input type=text name="h_country"  id="h_country" size=20 value="<%=h_country%>" onkeydown="kepEnter()" class="input_type_text"> 
                            </td>
							<td>업체코드</td>						
							<td> 
								<input type=text name="h_com_code" id="h_com_code" size=20 value="<%=h_com_code%>" onkeydown="kepEnter()" class="input_type_text"> 
                            </td>
                         </tr> 
						 <tr>
							<td>업체명</td>
							<td> 
								<input type=text name="h_com_name"  id="h_com_name" size=20 value="<%=h_com_name%>" onkeydown="kepEnter()" class="input_type_text"> 
                            </td>
							<td colspan="2">
								<input type="radio" name="h_language" value="kr"<%if(h_language == null || h_language == "" || "kr".equals(h_language)){ %> checked="checked"<%} %> id="check" />국문
              					<input type="radio" name="h_language" value="eng"<%if("eng".equals(h_language)){ %> checked="checked"<%} %> id="check" />영문
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
                        <col width="15%" />  
                        <col width="30%" />  
                        <col width="30%" />  
                        <col width="*" />   
                    </colgroup>		   
                    <thead> 
                        <tr>   
                            <th scope="col">업체코드</th> 
                            <th scope="col">업체명(영문)</th>   
                            <th scope="col">업체명(한글)</th>   
                            <th scope="col">주소</th>   
                        </tr>
                    </thead>
                    <tbody>
<%
if (_dataList == null || _dataList.size() == 0){
%>
               		<tr bgcolor="#FFFFFF">
                        <td colspan="4" align="center" height = "250">
                        <span class="font1">조회된 데이타가 없습니다.</span>
                        </td> 
                    </tr>
<%}else{
for (int j=0; j<_dataList.size(); j++) {
	Map<String,String> rowData = _dataList.get(j);
%> 
                        <tr>
						    <td>
						    	<input type="hidden" name="display_item_cnt" id="display_item_cnt" value="<%=_dataList.size() %>" >
						    	<input type="hidden" id="st_irs_no" name="st_irs_no"	value="<%=rowData.get("IRS_NO")%>">
						    	<input type="hidden" id="st_business_items" name="st_business_items"	value="<%=rowData.get("BUSINESS_ITEMS")%>">
						    	<input type="hidden" id="st_industry_type" name="st_industry_type"	value="<%=rowData.get("INDUSTRY_TYPE")%>">
						    	<input type="hidden" id="st_ceo_name" name="st_ceo_name"	value="<%=rowData.get("CEO_NAME_LOC")%>">
						    	<input type="hidden" id="st_zip_code" name="st_zip_code"	value="<%=rowData.get("ZIP_CODE")%>">
						    	<input type="hidden" id="st_adress_loc" name="st_adress_loc"	value="<%=rowData.get("ADDRESS_LOC")%>">
						    	<a href="javascript:setReturn('<%=rowData.get("COM_CODE")%>','<%=rowData.get("COM_NAME_LOC")%>','<%=rowData.get("COM_NAME_ENG")%>','<%=rowData.get("ADDRESS_ENG")%>','<%=j%>')"><%=CommonUtil.nvl(rowData.get("COM_CODE"))%></a>
						    </td>
							<td class="left"><a href="javascript:setReturn('<%=rowData.get("COM_CODE")%>','<%=rowData.get("COM_NAME_LOC")%>','<%=rowData.get("COM_NAME_ENG")%>','<%=rowData.get("ADDRESS_ENG")%>','<%=j%>')"><%=CommonUtil.nvl(rowData.get("COM_NAME_ENG"))%></a></td>
							<td class="left"><a href="javascript:setReturn('<%=rowData.get("COM_CODE")%>','<%=rowData.get("COM_NAME_LOC")%>','<%=rowData.get("COM_NAME_ENG")%>','<%=rowData.get("ADDRESS_ENG")%>','<%=j%>')"><%=CommonUtil.nvl(rowData.get("COM_NAME_LOC"))%></a></td>
							<td class="left"><a href="javascript:setReturn('<%=rowData.get("COM_CODE")%>','<%=rowData.get("COM_NAME_LOC")%>','<%=rowData.get("COM_NAME_ENG")%>','<%=rowData.get("ADDRESS_ENG")%>','<%=j%>')"><%=CommonUtil.nvl(rowData.get("ADDRESS_ENG"))%></a></td>
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
