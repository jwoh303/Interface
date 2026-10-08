<%--
**********************************************
* 메뉴 : 
* 화면 : 거래명세서작성
* 기능 : 거래명세서를 작성하기위한 팝업
* 프로그램 ID : PG_07_A_002_01
* 담당자 : 개발3 ( 설계 : 김지현 )
* 착수일 : 2014-
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../../common/include/head.jspf"  %>
 
<%
	@SuppressWarnings (value="unchecked")

	String p_buyer		= CommonUtil.nvl((String)request.getAttribute("st_buyer"));
	String p_gr_flag	= CommonUtil.nvl((String)request.getAttribute("st_gr_flag"));
	String p_buyer_name	= CommonUtil.nvl((String)request.getAttribute("st_buyer_name"));
	String p_com_code	= CommonUtil.nvl((String)request.getAttribute("st_com_code"));
	
	// 운영사 업무대행에서 호출시 사용. (p_proxy_yn == Y)
	String p_proxy_yn	= CommonUtil.nvl((String)request.getAttribute("st_proxy_yn"));
	String p_agent	= CommonUtil.nvl((String)request.getAttribute("st_agent"));
	String p_agent_name	= CommonUtil.nvl((String)request.getAttribute("st_agent_name"));
	
	if(p_gr_flag.equals("")){
		p_gr_flag = "GR";
	}
	
	if(!p_proxy_yn.equals("Y")){
		p_agent = p_com_code;
	}
	
	//조회결과 - 상세 리스트
	List<Map<String, String>> list = (List<Map<String, String>>) request.getAttribute("data"); 
	
	int rec_cnt = 0;
	int page_display_cnt = 0;
	
%>
<script type="text/javascript">

// 납품서 생성
function setDHIMCreate(){

	var tot_cnt  = $("#display_item_cnt").val();
	var po_no = "";
	var query = "";
	var buyer = $("#st_buyer").val();
	var agent = $("#st_agent").val();
	var gr_flag = $("#st_gr_flag").val();
	
	if(eval(tot_cnt) < 2){
		var box = eval("document.forms[0].checkbox"+0);
		po_no	= document.forms[0].st_po_no.value;	//PO번호
		
		if(box.checked == true){
			query = "'"+po_no+"',";
		}
	} else {
		for(var k = 0; k<tot_cnt ; k++){
			var box = eval("document.forms[0].checkbox" + k);          
			
			if(box.checked == true){ 
				var po_no  = document.forms[0].st_po_no[k].value;
				
				query += "'"+po_no+"',";
				
			}
		}
	}
	
	query = query.substring(0,query.length-1);
	
	$("#st_query").val(query);
	
	kepAjaxFormCall("/mpiv/getSellerMpIvTranStatementWriteDiPoList.do","contentForm","btnPoSearch");
		
	return;

}


function setPoResult(res){

	//console.log(res);
	
	var proxy_yn = "<%=p_proxy_yn%>";
	
	var agent_name 	= "<%=p_agent_name%>";
	var agent 		= "<%=p_agent%>";
		
	if(proxy_yn != "Y"){
		agent_name 	= $("#st_com_name").val();
		agent 		= $("#st_com_code").val();	
	}
	
	var po_no 		= res.results;
	var portal_user_id	= "20493";
	var portal_password = "20493";
	
//	var loc  = 'http://doowin.doosaninfracore.com/keplogin.do?';
//			loc +=  'agent='+agent+'&agent_name='+agent_name+'&po_no='+po_no+'&portal_user_id='+portal_user_id+'&portal_password='+portal_password;


	//document.agent_invoice_di_pop_c.action = "http://doowin.doosaninfracore.com/keplogin.do";
	//document.agent_invoice_di_pop_c.target = "_blank";
	/*document.agent_invoice_di_pop_c.agent.value = agent;
	document.agent_invoice_di_pop_c.agent_name.value = agent_name;
	document.agent_invoice_di_pop_c.po_no.value = po_no;
	document.agent_invoice_di_pop_c.portal_user_id.value = portal_user_id;
	document.agent_invoice_di_pop_c.portal_password.value = portal_password;
*/
	
	//console.log("agnet ==> " + agent);
	//console.log("agent_name ==> " + agent_name);
	//console.log("po_no ==> " + po_no);
	//console.log("portal_user_id ==> " + portal_user_id);
	//console.log("portal_password ==> " + portal_password);
	
	
	$("#agent").val(agent);
	$("#agent_name").val(agent_name);
	$("#po_no").val(po_no);
	$("#portal_user_id").val(portal_user_id);
	$("#portal_password").val(portal_password);
	
	//document.agent_invoice_di_pop_c.submit();

	//document.contentForm.action = "http://doowin.doosanmachinetools.com/keplogin.do";
	document.contentForm.action = "https://partner.dn-solutions.com/keplogin.do";
	document.contentForm.target = "_blank";
	document.contentForm.submit();
	
	//	window.open(loc,"newW","left=0,top=0,width=1024,height=760,resizable=yes,scrollbars=no");
//		top.window.close();
		
// message ==> 510080786500020@@510080786500020@@510081537900020@@510081880900010@@510082106900040@@510082628200020@@510082981700010@@510083017700110@@510083037900010@@510083037900020@@510083421400070@@510083421400080@@
		
}	


//ajax 공통 호출후 성공시 처리 함수
function kepAjaxSuccess(pMethod , response){
	
	//var msg = response.Message;
	
	if(pMethod == "btnPoSearch"){
		
		setPoResult(response);
		
	}
	
	// 특수로직 추가 후 주석 풀기!!! 
	//opener.setQuery();
	//window.close();
	
	return;
}

//ajax 공통 호출후 실패시 처리 함수
function kepAjaxError(pMethod , response){
	var msg = response.Message;
	
	if (!isEmpty(msg)){
		alert(msg);
	}
	return;
}

//전체선택/해제
function checkAll(){
	var tot_cnt      = document.forms[0].display_item_cnt.value;
	//var check_status = document.forms[0].check_status.value;
	var check_status = $("#check_status").html();
	
	if(check_status == "전체"){
		for(var j = 0; j < tot_cnt; j++){
			var box = eval("document.forms[0].checkbox" + j);
			var check_status = "해제";
			
			if(box.checked == false) box.checked = true;
			
			//document.forms[0].check_status.value = check_status;
			$("#check_status").html(check_status);
		}
	} else {
		for(var j = 0; j < tot_cnt; j++){
			var box = eval("document.forms[0].checkbox" + j);
			var check_status = "전체";
			
			if(box.checked == true) box.checked = false;
			
			//document.forms[0].check_status.value = check_status;
			$("#check_status").html(check_status);
		}
	}
}
</script> 
</head>

<body>
<form name="contentForm" id="contentForm" method = "post">

<!-- HIDDEN -->
<input type="hidden" id="st_query" name="st_query" value="">
<input type="hidden" id="st_buyer" name="st_buyer" value ="<%=p_buyer%>">
<input type="hidden" id="st_agent" name="st_agent"  value ="<%=p_agent%>">
<input type="hidden" id="st_gr_flag" name="st_gr_flag"  value ="<%=p_gr_flag%>">

<!-- 두산인프라 인터페이스시 사용 -->
<input type="hidden" id="agent" name="agent" value =""/>
<input type="hidden" id="agent_name" name="agent_name" value =""/>
<input type="hidden" id="po_no" name="po_no" value =""/>
<input type="hidden" id="portal_user_id" name="portal_user_id" value =""/>
<input type="hidden" id="portal_password" name="portal_password" value =""/>

<input type="hidden" name="st_user_id" id="st_user_id" value="${sessionInfo.userId}">
<input type="hidden" name="st_com_code" id="st_com_code" value="${sessionInfo.comCode}">
<input type="hidden" name="st_com_name" id="st_com_name" value="${sessionInfo.comNameLoc}">

<input type="hidden" name="st_proxy_yn" id="st_proxy_yn" value="<%=p_proxy_yn%>">


	<!--최소 가로길이 400px, 최소 세로길이 400px입니다 / 500*500-->
	<div id="popWrapper" style="height:594px;">
    	<div id="popHeader">
        	<h1 class="title">거래명세서 작성 - 두산인프라코어 전용</h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/s_btn_popclose.gif" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer">
        	<!-- 거래명세서 작성 상세내용 -->  
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
			        <td bgcolor="#898989" height="1"></td>
			    </tr>
			    <tr>
			        <td height="5"></td>
			    </tr>
				<tr valign="top">
			        <td height="23">
			        	<b>구매회원사 : <%=p_buyer_name%></b>
			        </td>
				</tr>
			    <tr>
			        <td height="5"></td>
			    </tr>
			</table>
			
           	<!--grid-->
            <div class="scrollArea" style="height:420px">
                <table  class="cont_t_list04"  style="width:100%">
                    <caption>거래명세서 작성 두산인프라전용 팝업 리스트</caption>
                    <colgroup>
                        <col width="4%" /> 
                        <col width="12%" />
                        <col width="12%" />
                        <col width="12%" />
                        <col width="12%" />
                        <col width="12%" /> 
                        <col width="12%" />
                        <col width="12%" />
                        <col width="12%" /> 
                    </colgroup>
                    <thead>
                        <tr>
                        	<th scope="col">
	                        	<a href="javascript:checkAll();" id="check_status">전체</a>
	                        	<!-- input type="text" name="check_status" size="3px" value="전체" READONLY style="background-color:#fffaec;height=20;font-weight:normal;border:#EDE1B0;color:#1F1F1F; 1px solid;" class="ac"-->
                        	</th>
                            <th scope="col">발주번호</th> 
                            <th scope="col">납품품목수</th> 
                            <th scope="col">발주일</th>
                            <th scope="col">PO번호</th>
                            <th scope="col">납품예정일</th>
                            <th scope="col">납품총금액</th>
                            <th scope="col">납기요청일</th>
                            <th scope="col">PLANT</th> 
                        </tr>
                    </thead>
                    <tbody>
					<%
					
					int seq_count_tot = 0;
					int seq_count_a = 0;

					rec_cnt = list.size();
					
					String chk_box = "";
					String tclass = "";
					
					if (rec_cnt <= 0){
					%>
	               		<tr bgcolor="#FFFFFF">
	                        <td colspan="9" align="center" height = "50">
	                        <span class="font1">조회된 데이타가 없습니다.</span>
	                        </td> 
	                    </tr>
					<%
					} else {
						
						for (int j=0; j<rec_cnt; j++){
							page_display_cnt++;
							
							Map<String,String> rowData = list.get(j);
							
							seq_count_a 	= Integer.parseInt(CommonUtil.nvl(rowData.get("CNT_SEQ")));
							seq_count_tot = seq_count_tot + seq_count_a;
							
							if(seq_count_tot < 100){  
								chk_box = "checked";
							}else{
								chk_box = "";
							}

							tclass = (j % 2 != 0)? "#FFFFFF" : "#FAFAFA";
					%>
					
				
                        <tr bgcolor="<%=tclass%>">
							<td>
								<!-- CHECKBOX -->
								<input type="checkbox" name="checkbox<%=j%>" value="" id="check" <%=chk_box%> />
								</a>
							</td>
							<td>
								<!-- 발주번호 -->
							 	<%=CommonUtil.nvl(rowData.get("LEGACY_PO_NO"))%>
							</td>
							<td class="right" style="padding:3px;">
								<!-- 납품품목수 -->
							 	<%=CommonUtil.formatNumber(CommonUtil.nvl(rowData.get("CD_ITEM_QTY")),true,0,3)%>
							</td>
							<td>
								<!-- 발주일 -->
							 	<%=CommonUtil.formatStrinigDate(CommonUtil.nvl(rowData.get("PO_CREATE_DATE")))%>
							</td>
							<td>
								<!-- PO번호 -->
							 	<%=CommonUtil.nvl(rowData.get("PO_NO"))%>
					 			<input type="hidden" name="st_po_no" value="<%=CommonUtil.nvl(rowData.get("PO_NO"))%>">
							</td>
							<td>
								<!-- 납품예정일 -->
							 	<%=CommonUtil.formatStrinigDate(CommonUtil.nvl(rowData.get("DS_DATE")))%>
							</td>
							
							<td class="right" style="padding:3px;">
								<!-- 납품총금액 -->
							 	<%=CommonUtil.formatNumber(CommonUtil.nvl(rowData.get("CD_TTL_AMT")),true,0,3)%>
							</td>
							<td>
								<!-- 납기요청일 -->
								<%=CommonUtil.formatStrinigDate(CommonUtil.nvl(rowData.get("RD_DATE")))%>							 	
							</td>
							<td>
								<!-- PLANT -->
							 	<%=CommonUtil.nvl(rowData.get("PLANT"))%>
							</td>
                        </tr> 
					<%
						}
					}
					%>
  
                    </tbody>
                </table>                  
                <input type="hidden" id="display_item_cnt" 	name="display_item_cnt"    value="<%=page_display_cnt%>">
        </div>
        
        <table width="100%" border="0" cellspacing="0" cellpadding="0" style="margin-top:8px;">
			<tr>
				<td height="25" align="left">
	                ※ 납품서생성 전송 대상은 <font color="red">발주항번 수의 합계</font>가 <font color="red">99개</font> 까지만 가능합니다.
				</td>
	        </tr>
			<tr>
				<td align="right">
					<div class="btnArea">
						<div class="fr">
							<span class="btn_04">
								<a href="javascript:setDHIMCreate();">납품서생성</a> &nbsp;
							</span>
			            </div>
			        </div>
				</td>
			</tr>
		</table>
    </div>        
</div>
</form> 

</body>
</html>
