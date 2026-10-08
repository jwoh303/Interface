<%--
**********************************************
* 메뉴 : 
* 화면 : 기존카탈로그조회
* 기능 : 기존카탈로그조회
* 프로그램 ID :  
* 담당자 : CEJ ( 설계 : 권우재 )
* 착수일 : 2014-10-28
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
<link rel="stylesheet" href="/resources/styles/base.css" type="text/css" />
<link rel="stylesheet" href="/resources/styles/master_layout.css" type="text/css" />
<script src="/resources/libs/jquery/js/jquery.min.js" type="text/javascript"></script>
<script src="/resources/libs/jquery/js/jquery-ui.min.js" type="text/javascript"></script>
<script src="/resources/js/kep_common.js"></script> 
</head>
<%
@SuppressWarnings (value="unchecked")
List<Map<String,String>> _dataList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된 결과 

String st_buyer_item_no=  CommonUtil.nvl((String) request.getParameter("st_buyer_item_no"),"");  //  (조회조건)
String st_description_loc=  CommonUtil.nvl((String) request.getParameter("st_description_loc"),"");  //  (조회조건)
String st_specification=  CommonUtil.nvl((String) request.getParameter("st_specification"),"");  //  (조회조건)
String order_by=  CommonUtil.nvl((String) request.getParameter("order_by"),"");  //  (조회조건)

String st_buyer=  CommonUtil.nvl((String) request.getParameter("st_buyer"),"");  //  (조회조건)
String st_com_org_code=  CommonUtil.nvl((String) request.getParameter("st_com_org_code"),"");  //  (조회조건)
String st_buyer_name=  CommonUtil.nvl((String) request.getParameter("st_buyer_name"),"");  //  (조회조건)
%>

<script type="text/javascript">
 
///mdcm/getMasterMdCmCatalogExistingAlterPop.do
	
	function doAction(str) {
	
		switch (str) {
			case "search":	 // 조회
				kepSearch();
				break;
			case "reload":	// 초기화
				kepReload("masterMdCmCatalogExistingAlterPop");
				jspTableClean("table_list");
				break;
		}
	}
	
	function kepSearch(){
		var buyer_item_no = TrimCommon($("#st_buyer_item_no").val());
		var description = TrimCommon($("#st_description_loc").val());
		var specification = TrimCommon($("#st_specification").val());
		
		if (buyer_item_no == "" && description == "" && specification == ""){
			alert("고객사 이외에 하나의 조건을 추가해야 합니다.");
			return;
		}
		
		$('#masterMdCmCatalogExistingAlterPop').attr("action", "/mdcm/getMasterMdCmCatalogExistingAlterPop.do").submit();   
	}
	
	
	function addrows(){
		  var tot_cnt  = $("#display_item_cnt").val();   
		    chk_cnt = getCheckedRowCount(tot_cnt);    
		    var query = "";
		    if(chk_cnt == "0"){
		        alert(" 하나 이상의 상품이 선택되어야 합니다.   ");
		        return;
		    }else{
		        if(eval(tot_cnt) < 2){
		        	var box = eval("document.forms.masterMdCmCatalogExistingAlterPop.lnCheck0");
		            if(box.checked == true){
		            	query = query + box.value;
		                query += "^||^";
		            }
		        }else{
		    	    for(var j = 0; j < eval(tot_cnt); j++){
		    	         var box = eval("document.forms.masterMdCmCatalogExistingAlterPop.lnCheck" + j);
		                if(box.checked == true){
		                	query = query + box.value;
		                    query += "^||^";
		                }
		            }
		        }
		    }
		    opener.setIcomTrxlUpload(query);
		    self.close();
	}
	

	/**
	 * 체크 된 수
	 */
	function getCheckedRowCount(tot_cnt) {
		
		var chk_cnt = 0;
		if(eval(tot_cnt) < 2){
		    var box = eval("document.forms.masterMdCmCatalogExistingAlterPop.lnCheck0");
		    if(box.checked == true) chk_cnt++;
		}else{
		    for(var j = 0; j < tot_cnt; j++){
		         var box = eval("document.forms.masterMdCmCatalogExistingAlterPop.lnCheck" + j);
		         if(box.checked == true){
		              chk_cnt++;
		         }
		    }
		}
		return chk_cnt;
	}
	
</script> 
<body>
<form name="masterMdCmCatalogExistingAlterPop" id="masterMdCmCatalogExistingAlterPop" method=post >

	
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다 / 500*500-->
	<div id="popWrapper" style="height:443px;">
    	<div id="popHeader">
        	<h1 class="title">기존카탈로그조회 </h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/m_btn_popclose.gif" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
      <!--팝업내용입니다-->
        <div id="popContainer">
             <div id="searchBtnA02">
            	<span class="btn_search"><a href="javascript:kepSearch();">조회</a></span>
            	<span class="btn_reset"><a href="javascript:doAction('reload')">초기화</a></span>  
            </div>   
            <!--조회영역-->
            <div id="cont_searchA">
            	<table class="cont_t_list01" style="width:100%">
						<caption>기존카탈로그조회</caption>
						<colgroup>
							<col width="10%" />
							<col width="30%" />						
							<col width="10%" />
							<col width="30%" />		 
                            <col width="*" />
						</colgroup>						
						<tbody>
						<tr>
							<td>구매사</td>
							<td>
							<%=st_buyer_name %>
							<input type=hidden name="st_buyer" id="st_buyer" size=20 value="<%=st_buyer%>" >   
							<input type=hidden name="st_com_org_code" id="st_com_org_code" size=20 value="<%=st_com_org_code%>" >   
							<input type=hidden name="st_buyer_name" id="st_buyer_name" size=20 value="<%=st_buyer_name%>" >   
							<input type="hidden" id="st_user_id" name="st_user_id"  value="${sessionInfo.userId}">
							<input type="hidden" id="trxl_gubun" name="trxl_gubun"  value="CAM">							
                            </td>						
							<td>품목코드</td>
							<td colspan="2">
							<input type=text name="st_buyer_item_no" id="st_buyer_item_no" size=40 value="<%=st_buyer_item_no%>" onkeydown="kepEnter()" class="input_type_text">   
                            </td>
						</tr>
						<tr>                            
						    <td>품목명</td>						 
							<td>  
							<input type=text name="st_description_loc" id="st_description_loc" size=40 value="<%=st_description_loc%>" onkeydown="kepEnter()" class="input_type_text">   
                            </td>
						    <td>규격</td>						 
							<td>  
							<input type=text name="st_specification" id="st_specification" size=40 value="<%=st_specification%>" onkeydown="kepEnter()" class="input_type_text">   
                            </td>                					 
							<td>  
							 <select name="order_by"  onchange="">
			                    <option value = "1" <% if ("1".equals(order_by)) {  %> selected <%} %>>품목코드</option>
			                    <option  value = "2" <% if ("2".equals(order_by)) {  %> selected <%} %>>품명순</option>
			                    <option  value = "3" <% if ("3".equals(order_by)) {  %> selected <%} %>>규격순</option>
			                    <option  value = "4" <% if ("4".equals(order_by)) {  %> selected <%} %>>제조사순</option>
			                    <option  value = "5" <% if ("5".equals(order_by)) {  %> selected <%} %>>협력사순</option>
			                    <option  value = "6" <% if ("6".equals(order_by)) {  %> selected <%} %>>등록순</option>
			                  </select>
                            </td>                                                                     
						</tr>					 
					</tbody>
				</table>
            </div>            
            <!--조회영역-->
           	<!--grid-->
            <div class="scrollArea" style="height:320px">
                <table id="table_list"  class="cont_t_list02"  style="width:100%">
                    <caption>기존카탈로그조회  리스트</caption>
                    <colgroup>
                        <col width="52" />
						<col width="95" />
						<col width="94" />
						<col width="82" />
						<col width="150" />
                        <col width="80" />
                        <col width="80" />
                        <col width="82" />
                        <col width="82" />
                        <col width="82" />
                    </colgroup>
                    <thead>
                        <tr>
                        <th scope="col"> 
                        <%
if (_dataList == null || _dataList.size() == 0){
}else{
%>
                             <input type="checkbox" name="check_status" id="check_status" value="선택"  style="cursor:pointer;" onclick="kepCheckAll(document.forms.masterMdCmCatalogExistingAlterPop.display_item_cnt.value,document.forms.masterMdCmCatalogExistingAlterPop.check_status,'document.forms.masterMdCmCatalogExistingAlterPop.lnCheck');">
                     <%} %>
                     </th> 
                            <th scope="col">협력사</th>
                            <th scope="col">품목코드</th>                              
                            <th scope="col">품목명</th> 
                            <th scope="col">규격</th> 
                            <th scope="col">매출단가</th> 
                            <th scope="col">매입단가</th>
                            <th scope="col">매익율(%)</th> 
                            <th scope="col">제조사</th> 
                            <th scope="col">원산지</th> 
                        </tr>
                    </thead>
                    <tbody>
<%
if (_dataList == null || _dataList.size() == 0){
%>
               		<tr bgcolor="#FFFFFF">
                        <td colspan="10" align="center" height = "280">
                        <span class="font1"><b>조회된 내용이 없습니다 .</b></span>
                        </td> 
                    </tr>
<%}else{
for (int j=0; j<_dataList.size(); j++) {
	Map<String,String> _tmp = _dataList.get(j);
%> 
                        <tr>
                        	<td>	<input type="checkbox" name="lnCheck<%=j%>" value="<%=_tmp.get("BUYER")%>@@<%=_tmp.get("BUYER_ITEM_NO")%>@@<%=_tmp.get("AGENT")%>@@<%=_tmp.get("CONTRACT_NO")%>@@<%=_tmp.get("CONTRACT_SEQ")%>@@<%=_tmp.get("BYCA_COMORG_CODE")%>@@<%=_tmp.get("STATUS_TEXT")%>@@<%=_tmp.get("MIN_ORDER_QTY")%>@@<%=_tmp.get("PUR_UNIT_QTY")%>@@<%=_tmp.get("SELLER_AREA")%>@@<%=_tmp.get("PROCESS_TYPE")%>@@<%=_tmp.get("ORIGIN_AGENT")%>@@<%=_tmp.get("SELL_CLOSE_DATE")%>@@<%=_tmp.get("BUY_CLOSE_DATE")%>@@"/>	 </td>
							<td><%=_tmp.get("AGENT_TEXT")%></td>
							<td><%=_tmp.get("BUYER_ITEM_NO")%></td>
							<td><%=_tmp.get("DESCRIPTION")%></td>
							<td><%=_tmp.get("SPECIFICATION")%></td>
							<td><%=CommonUtil.formatNumber(_tmp.get("UNIT_PRICE"),true,0,3)%></td>
							<td><%=CommonUtil.formatNumber(_tmp.get("LIST_PRICE"),true,0,3)%></td> 
							<td><%=_tmp.get("RATE")%></td>
							<td><%=_tmp.get("MAKER_NAME")%></td>
							<td><%=_tmp.get("ORIGIN_TEXT")%></td>
                        </tr> 
<% } 
}%>                               
                    </tbody>
                </table>                  
<%	if (_dataList != null && _dataList.size() > 0){	%>
			 <input type="hidden" name="display_item_cnt" id="display_item_cnt" value="<%=_dataList.size() %>" >
<%	}	%>
        </div>
        <br>
        <!--버튼영역-->
		<div class="btnArea">
			<span class="fr">
				<span class="btn_02 mr04"><a href="javascript:addrows();">확인</a></span> 
			</span>
		</div>
    </div>        
</div> 
</form>   
</body>
</html>
