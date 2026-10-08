<%--
**********************************************
* 메뉴 : 
* 화면 : 계정선택
* 기능 : 예산을 사용하는 고객사 중 "예산계정별 관리항목 관리 고객사"가 장바구니에 입력될 계정코드를 선택하기 위한 팝업 CS10139
* 프로그램 ID :  PG_06_B_006_41
* 담당자 : CEJ ( 설계 : 김지현 )
* 착수일 : 2014-05-26
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.*"%> 
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
<link rel="stylesheet" href="/resources/styles/buyer_layout.css" type="text/css" />
<script src="/resources/libs/jquery/js/jquery.min.js" type="text/javascript"></script>
<script src="/resources/libs/jquery/js/jquery-ui.min.js" type="text/javascript"></script>
<script src="/resources/js/kep_common.js"></script> 
</head>
<%
@SuppressWarnings (value="unchecked")
List<Map<String,String>> _dataList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된 결과  
@SuppressWarnings (value="unchecked")
List<Map<String,String>> _dataList1 = (List<Map<String,String>>) request.getAttribute("data1"); // 조회된 결과  

SessionInfo _sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
String com_code=  CommonUtil.nvl((String) request.getParameter("com_code"),CommonUtil.nvl((String) request.getParameter("st_com_code")));
 
String dept_code = CommonUtil.nvl((String) request.getParameter("dept_code"),"");  //  (조회조건)
String cart_sum_price = CommonUtil.nvl((String) request.getParameter("st_cart_sum_price"),"0");  //  (조회조건)
String order_qty = CommonUtil.nvl((String) request.getParameter("st_order_qty"),"");  //  (조회조건)
String order_price = CommonUtil.nvl((String) request.getParameter("st_order_price"),"");  //  (조회조건)
String description = CommonUtil.nvl((String) request.getParameter("st_description"),"");  //  (조회조건)
String open = CommonUtil.nvl((String) request.getParameter("open"),"");  //  (조회조건)


String st_pa_row = CommonUtil.nvl((String) request.getParameter("st_pa_row"),"");  //  (조회조건)
String st_pa_dept_code = CommonUtil.nvl((String) request.getParameter("st_pa_dept_code"),"");  //  (조회조건)
String st_pa_dept_name = CommonUtil.nvl((String) request.getParameter("st_pa_dept_name"),"");  //  (조회조건)
String st_pa_account_type = CommonUtil.nvl((String) request.getParameter("st_pa_account_type"),"");  //  (조회조건)
String st_pa_account_name = CommonUtil.nvl((String) request.getParameter("st_pa_account_name"),"");  //  (조회조건)
 

String SessionUserDept      = _sessionInfo.getDepartment();
String SessionUserDeptName  = _sessionInfo.getDepartmentName();
String SessionUserId  = _sessionInfo.getUserId();

int rec_cnt = 0;
Map<String, String> _map = new HashMap<String, String>();
%>

<script type="text/javascript">
<!--

function kep_onload(){
	
	<% if ("Y".equals(open)){%>
	kepSearch();
	<%}%>
}
function kepSearch()
{  
	
	document.forms.buyerMpSoAccountSel1Pop.st_pa_row.value = "";
	document.forms.buyerMpSoAccountSel1Pop.st_pa_dept_code.value = "";
	document.forms.buyerMpSoAccountSel1Pop.st_pa_dept_name.value = "";
	document.forms.buyerMpSoAccountSel1Pop.st_pa_account_type.value = "";
	document.forms.buyerMpSoAccountSel1Pop.st_pa_account_name.value = "";
		
  $('#buyerMpSoAccountSel1Pop').attr("action", "/mpso/getDeptSelect.do").submit();    
  

}

function kepEnter() {	
	if (event.keyCode == 13) { 
		kepSearch();
	}
}



function getAccountDivide(row,dept_code,dept_name,account_type,account_name){
	//선택한 계정의 row를 체
	document.forms.buyerMpSoAccountSel1Pop.st_pa_row.value = row;
	document.forms.buyerMpSoAccountSel1Pop.st_pa_dept_code.value = dept_code;
	document.forms.buyerMpSoAccountSel1Pop.st_pa_dept_name.value = dept_name;
	document.forms.buyerMpSoAccountSel1Pop.st_pa_account_type.value = account_type;
	document.forms.buyerMpSoAccountSel1Pop.st_pa_account_name.value = account_name;
 
	$('#buyerMpSoAccountSel1Pop').attr("action", "/mpso/getDeptSelect.do").submit();    
}



function getAccountMgCodeNote(){
	var account_cnt =   $("#st_accountCnt").val();  
	var mg_code_arr = "";
	var mg_name = "";
	var mg_note_arr = "";
	var st_essential = "";
	var st_readonlyflag = "";

	for(var i=0; i<account_cnt; i++){
		mg_code = document.forms.buyerMpSoAccountSel1Pop.st_mg_code[i].value;
		mg_name = document.forms.buyerMpSoAccountSel1Pop.st_mg_name[i].value;
		mg_note = document.forms.buyerMpSoAccountSel1Pop.st_mg_note[i].value;
		st_essential = document.forms.buyerMpSoAccountSel1Pop.st_essential[i].value;
		st_readonlyflag = document.forms.buyerMpSoAccountSel1Pop.st_readonlyflag[i].value;
		if(mg_note == "" && st_essential == "Y")
		{
			if(st_readonlyflag != "readOnly"){
				alert(mg_name + " 의 내용을 입력/선택 하십시오.");
				document.forms.buyerMpSoAccountSel1Pop.st_mg_note[i].focus();
				return false;
			}
		}
		mg_code_arr += mg_code + "&";
		mg_note_arr += mg_note + "&";
	}
	
	return mg_code_arr+"$$"+mg_note_arr;
}


function seveAccountDivide(){
	var mg_code_note = getAccountMgCodeNote();
	if(mg_code_note == ""){
		return;
	}
	var mg_array = mg_code_note.split("$$");

	var pa_row = document.forms.buyerMpSoAccountSel1Pop.st_pa_row.value;
	var account_type = document.forms.buyerMpSoAccountSel1Pop.st_account_type[pa_row].value;
	var account_name = document.forms.buyerMpSoAccountSel1Pop.st_account_name[pa_row].value;
	var dept_code = document.forms.buyerMpSoAccountSel1Pop.st_dept_code[pa_row].value;
	var dept_name = document.forms.buyerMpSoAccountSel1Pop.st_dept_name[pa_row].value;
	var bdgt_bal = document.forms.buyerMpSoAccountSel1Pop.st_bdgt_bal[pa_row].value;
	//특수로직 예산선택 팝업이며 관리부서 통제 해당사항 업어 부서정보 공란 처리.
	var st_mng_dept_cd = "";
	var st_mng_dept_nm = "";
	
	opener.setBdgtAccount(account_type, account_name, dept_code, dept_name, mg_array[0], mg_array[1], bdgt_bal,st_mng_dept_cd,st_mng_dept_nm);
	window.close();
}
 
 //-->
</script> 
<body onload="kep_onload()">
<form name="buyerMpSoAccountSel1Pop" id="buyerMpSoAccountSel1Pop" method=post >
	<input type="hidden" name="st_pa_row"			value="<%=st_pa_row%>">
	<input type="hidden" name="st_pa_dept_code"		value="">
	<input type="hidden" name="st_pa_dept_name"		value="">
	<input type="hidden" name="st_pa_account_type"	value="">
	<input type="hidden" name="st_pa_account_name"	value="">
	<input type="hidden" name="st_order_qty"		value="<%=order_qty%>">
	<input type="hidden" name="st_order_price"		value="<%=order_price%>">
	<input type="hidden" name="st_description"		value="<%=description%>">
	<input type="hidden" name="st_com_code"		value="<%=com_code%>">
	<input type="hidden" name="st_dept_code"		value="<%=SessionUserDept%>">
	<input type="hidden" name="st_cart_sum_price"		value="<%=cart_sum_price%>">
	
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다 / 500*500-->
	<div id="popWrapper" style="height:700px;">
    	<div id="popHeader">
        	<h1 class="title">계정선택</h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/b_btn_popclose.gif" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer">          
            <!--조회영역-->
            <div id="cont_searchA">
            	<table class="cont_t_list01" style="width:100%">
						<caption>계정선택 리스트</caption>
						<colgroup>
							<col width="10%" />
							<col width="*" /> 
							<col width="10%" />
							<col width="10%" />  
						</colgroup>						
						<tbody>
						<tr>
							<td>부서명:</td>
							<td> 
								<%=SessionUserDeptName%>
                            </td>
						    <td></td>						 
							<td  class="right"> 
							</td>
						</tr>					 
					</tbody>
				</table>
            </div>            
           	<!--grid-->
            <div class="scrollArea" style="height:300px">
                <table  class="cont_t_list02"  style="width:100%">
                    <caption>계정선택 리스트</caption>
                    <colgroup>
                        <col width="15%" /> 
                        <col width="*" /> 
						<col width="20%" />
						<col width="20%" />  
                       
                    </colgroup>
                    <thead>
                        <tr>
                            <th scope="col">계정코드</th> 
                            <th scope="col">계정 명</th> 
                            <th scope="col">사용가능금액</th>
                            <th scope="col">장바구니금액</th>  
                        </tr>
                    </thead>
                    <tbody>
<%
if (_dataList == null || _dataList.size() == 0){
%>
               		<tr bgcolor="#FFFFFF">
                        <td colspan="4" align="center" height = "80">
                        <span class="font1">조회된 데이타가 없습니다.</span>
                        </td> 
                    </tr>
<%}else{
for (int j=0; j<_dataList.size(); j++) {
	Map<String,String> rowData = _dataList.get(j);
%> 
                        <tr>
						<td>
						
											<input type="hidden" name="st_row"				value="<%=j%>">
					<input type="hidden" name="st_dept_code"		value="<%=rowData.get("DEPT_CODE")%>">
					<input type="hidden" name="st_dept_name"		value="<%=rowData.get("DEPT_NAME")%>">
					<input type="hidden" name="st_account_type"		value="<%=rowData.get("ACCOUNT_TYPE")%>">
					<input type="hidden" name="st_account_name"		value="<%=rowData.get("ACCOUNT_NAME")%>">
					<input type="hidden" name="st_plan_amt_flag"	value="<%=rowData.get("PLAN_AMT_FLAG")%>">
					<input type="hidden" name="st_bdgt_bal"	value="<%=CommonUtil.formatNumber(rowData.get("AVAIL_AMT"),true,0,3)%>">  
					
						 	&nbsp;&nbsp;<%=rowData.get("ACCOUNT_TYPE")%>
						</td>
						<td class="left">
						  	<%
									// 사용가능한 예산이 있거나 , 예산미적용 계정일 경우 선택 가능하도록 설정
								if( rowData.get("BDGT_FLAG2").equals("N") ||  (rowData.get("BDGT_FLAG2").equals("Y") && Double.parseDouble(rowData.get("AVAIL_AMT")) >= Double.parseDouble((cart_sum_price)))  ){
							%>
								<a href="javascript:getAccountDivide('<%=j%>','<%=rowData.get("DEPT_CODE")%>','<%=rowData.get("DEPT_NAME")%>','<%=rowData.get("ACCOUNT_TYPE")%>','<%=rowData.get("ACCOUNT_NAME")%>','<%=CommonUtil.formatNumber(rowData.get("AVAIL_AMT"),false,0,3)%>');"><%=rowData.get("DEPT_NAME")%>-<%=rowData.get("ACCOUNT_NAME")%></a>	
							<%
								}else{	// 예산적용 계정인데 0일 경우는 선택을 하지 못하도록 설정	
							%>
								<%=rowData.get("DEPT_NAME")%>-<%=rowData.get("ACCOUNT_NAME")%>
							<%
								}
							%>
					   </td>
						<td class="right">
								<%=(rowData.get("BDGT_FLAG2").equals("N"))?"<font color=red>*</font>":""%>
							<%=CommonUtil.formatNumber(rowData.get("AVAIL_AMT"),true,0,3)%>
						</td>
						<td class="right"><%=CommonUtil.formatNumber(cart_sum_price,true,0,3)%></td>
                        </tr> 
<% } 
}%>                               
                    </tbody>
                </table> 
                
                </div>
                
                
                
                
                
                
                <b>※ 사용가능금액이 <font color="red">*</font>0 인 계정은 선택시 예산 미적용 계정으로 처리됩니다.</b>
                
                
                
                           	<!--grid-->
            <div class="scrollArea" style="height:150px">
                <table  class="cont_t_list02"  style="width:100%">
                    <caption>계정선택 리스트</caption>
                    <colgroup>
                        <col width="20%" /> 
                        <col width="*" /> 
                    </colgroup>
                    <thead>
                        <tr>
                            <th scope="col"><%=st_pa_dept_name%></th> 
                            <th scope="col" colspan='2"'><%=st_pa_account_name%></th>  
                        </tr>
                    </thead>	
                    <tbody>
<%
if (_dataList1 == null || _dataList1.size() == 0){
%>
               		<tr bgcolor="#FFFFFF">
                        <td colspan="3" align="center" height = "80">
                        <span class="font1">조회된 데이타가 없습니다.</span>
                        </td> 
                    </tr>
<%}else{
	
	rec_cnt = _dataList1.size() != 0 ? _dataList1.size() : 0; 
	
for (int j=0; j<_dataList1.size(); j++) {
	Map<String,String> rowData = _dataList1.get(j);
%> 
                        <tr>
						<td>
						
						<input type="hidden" name="st_accountCnt" id="st_accountCnt" value="<%=rec_cnt%>">
							<input type="hidden" name="st_readonlyflag" value="<%=rowData.get("TEXT3")%>">
							<input type="hidden" name="st_mg_code" value="<%=rowData.get("CODE2")%>">
							<input type="hidden" name="st_essential" value="<%=rowData.get("TEXT4")%>">
					
						<input type="text" name="st_mg_name" class="input_type_text"  style="border:0" value="<%=rowData.get("TEXT1")%>" readOnly>
						</td>
						<td class="left"> 
	 			<%
							//부서(ICOMCOD2, C001)
							if("A03".equals(rowData.get("CODE2"))){
				%>
									<select name="st_mg_note" style="width:90%">
										<option value="">-- 선택 --</option> 
											<%
											
											_map.put("com_code",com_code);
											_map.put("dept_code",dept_code);
											%>
											<%= CommonUtil.getCodeComboQueryIdList("common.mpso.getCod2C001DDLB","SEL",_map,st_pa_dept_code) %>
									</select>
				<%
							}
							//사원(ICOMLUSR, LEGACY_USER_ID)
							else if("A04".equals(rowData.get("CODE2"))){
				%>
									<select name="st_mg_note" style="width:90%">
											
											<%
											_map.put("com_code",com_code);
											_map.put("SessionUserId",SessionUserId);
											%>
											<%= CommonUtil.getCodeComboQueryIdList("common.mpso.getLusrDDLB","SEL",_map,com_code) %>
									</select>
				<%
							}
							//타계정대체(ICOMCOD2, M014)
							else if("B27".equals(rowData.get("CODE2"))){
				%>
									<select name="st_mg_note" style="width:90%">
																						
											<%
											_map.put("com_code",com_code);
											_map.put("st_pa_account_type",st_pa_account_type);
											%>
											<%= CommonUtil.getCodeComboQueryIdList("common.mpso.getCod2Z014DDLB","SEL",_map,st_pa_account_type) %>
											
									</select>
				<%
							}
							//ListBox
							else if("ListBox".equals(rowData.get("TEXT44"))){
				%>
									<select name="st_mg_note" style="width:90%">
											<%
											_map.put("com_code",com_code);
											_map.put("code2",rowData.get("CODE2"));
											%>
											<%= CommonUtil.getCodeComboQueryIdIndexSelList("common.mpso.getCod3DDLB","SEL",_map, -1) %>											
									</select>
				<%
							}else{
								//수량(DB에 빈값 들어가야함)
								if("D68".equals(rowData.get("CODE2"))){
				%>
									<%=order_qty%>
									<input type="hidden" name="st_mg_note" <%=rowData.get("TEXT3")%>>
				<%
								}
								//단가(DB에 빈값 들어가야함)
								else if("D03".equals(rowData.get("CODE2"))){
				%>
									<%=order_price%>
									<input type="hidden" name="st_mg_note" <%=rowData.get("TEXT3")%>>
				<%
								}
								//품목(DB에 빈값 들어가야함)
								else if("A10".equals(rowData.get("CODE2"))){
				%>
									<%=description%>
									<input type="hidden" name="st_mg_note" <%=rowData.get("TEXT3")%>>
				<%
								}
								else{
				%> 
									<input type="text" name="st_mg_note" value="<%=rowData.get("TEXT3")%>" class="input_type_text">
				<%
								}
							}
				%>
					   </td> 
					   <td>
					   <%=rowData.get("TEXT2")%>
					   </td>
                        </tr> 
<% } 
}%>                               
                    </tbody>
                </table> 
                
                
                
                
                                     
        </div>    
                <% if (rec_cnt>0) {  %>
                		<!-- 버튼영역 -->
		<div class="btnArea">
        	<div class="fr">
                	<span class="btn_03 mr04"><a href="javascript:seveAccountDivide();">확인</a>
                 </span>
                </div>
               </div>
                
                <%} %>
        
    </div>        
</div>
</form> 
</body>
</html>
