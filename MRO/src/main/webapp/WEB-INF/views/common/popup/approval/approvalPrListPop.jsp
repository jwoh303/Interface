<%--
**********************************************
* 메뉴 :  결재
* 화면 : 결재리스트
* 기능 : 결재리스트
* 프로그램 ID : 
* 담당자 : CEJ  
* 착수일 : 2014-XX-XX
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
List<Map<String,String>> _dataList =  (List<Map<String,String>>) request.getAttribute("data"); // 조회된결과   

SessionInfo sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
String buyer = CommonUtil.nvl((String) request.getParameter("COMPANY"),""); // 조회조건
String DOCU_NO = CommonUtil.nvl((String) request.getParameter("DOCU_NO"),""); // 조회조건
String DOC_TYPE = CommonUtil.nvl((String) request.getParameter("DOC_TYPE"),""); // 조회조건
String REJECT_YN =CommonUtil.nvl((String) request.getParameter("REJECT_YN"),"");  //  (조회조건)
String approval_user_id =CommonUtil.nvl((String) request.getParameter("approval_user_id"),"");  //  (조회조건)
String FLAG =CommonUtil.nvl((String) request.getParameter("FLAG"),"");  //  (조회조건)
String pass_status = CommonUtil.nvl((String) request.getParameter("pass_status"),"");  //  (조회조건)
double PO_AMT_SUM = 0;
String RECV_FLAG = "";

boolean cowayFlag = false;
//SLOGIC-BEGIN(P06-0000036) 
//코웨이일경우
String p060000036_COWAY = CommonUtil.getSpecialCheckReturn(buyer,"P06-0000036","COL03_DATA"); // 권한특수로직
if ("COWAY".equals(p060000036_COWAY)){
	cowayFlag = true; 
} 
//SLOGIC-END 

String SessionComCode = "";
String byca_comorg_code = ""; 
String user_dept              = ""; 
String userId = "";
String byca_comorg_level = "";
String dept_name = "";
String budget_flag = "";
String person_author = "";
if (sessionInfo != null){ 
	SessionComCode =  CommonUtil.nvl((String)sessionInfo.getComCode()); 
	byca_comorg_code =  CommonUtil.nvl((String)sessionInfo.getBycaComorgCode());  
	buyer  = SessionComCode;
	user_dept =  CommonUtil.nvl((String)sessionInfo.getDepartment());  
	dept_name =  CommonUtil.nvl((String)sessionInfo.getDepartmentName());  
	userId = CommonUtil.nvl((String)sessionInfo.getUserId()); 
	byca_comorg_level = CommonUtil.nvl((String)sessionInfo.getBycaComorgLevel()); 
    budget_flag           = CommonUtil.nvl((String)sessionInfo.getBudgetFlag());  // 구매사 예산 사용여부 
    
    person_author =  CommonUtil.nvl((String)sessionInfo.getPersonAuthor());  
}   

//SLOGIC-BEGIN(P06-0000016)
String reportText= "품의서출력"; // default 버튼명
String reportid = "RD_06_B_002_12";  // default report id /kr/customer/sheet/pr_print_kep.jsp
Map<String, String> p060000016 = CommonUtil.getSpecialCheckReturnMap(buyer,"P06-0000016");   // com_code , 특수로직아이디
if (p060000016 != null){
	reportText= CommonUtil.nvl(p060000016.get("COL01_DATA"),reportText); // 레포트 버튼명
	reportid = CommonUtil.nvl(p060000016.get("COL02_DATA"),reportid); // 레포트아이디
} 
//SLOGIC-END

String POP_FLAG = CommonUtil.nvl((String) request.getParameter("POP_FLAG"),""); //***상세팝업시 사이즈 세팅**/
String divHeight = "200px"; //***상세팝업시 사이즈 세팅**/
if("Y".equals(POP_FLAG))//***상세팝업시 사이즈 세팅**/
	divHeight = "600px";//***상세팝업시 사이즈 세팅**/

boolean bag00001 = CommonUtil.getSpecialCheckReturn(buyer,"BAG00001"); // 비고란 노출(금호석유화학 그룹)	
boolean bag00003 = CommonUtil.getSpecialCheckReturn(buyer,"BAG00003"); // 품목별 구매사유 노출(깨끗한나라)
boolean bag00005 = CommonUtil.getSpecialCheckReturn(buyer,"BAG00005"); // 예산계정 변경 가능
%>
<script type="text/javascript"> 
 

function  attach_popup(img_key){	
	
	var type = "<%=DOC_TYPE%>";
	var viewType = "R";
	kepFileUploadOpenPopup(img_key,type,viewType); 
}

function setQuery(){
	
}
function prnSheet() {	  
	var buyer         = "<%=SessionComCode%>"; //필수항목
	var chgUserDept   = "<%=user_dept%>"; //필수항목
	var addUserID     = "<%=userId%>"; //필수항목
	var prNo          = "<%=DOCU_NO %>";
	var ref_no        = "";
	var add_date      = kepGetNowTimeStr('YYYYMMDD', '');
	var dept_name     = "<%=dept_name%>";
	var dept_code     = "<%=user_dept%>";
	var byca_comorg_level  = "<%=byca_comorg_level%>";
	var recv_flag     = $('#st_recv_flag').val(); 

	var fileName = "<%=reportid%>";
	//var param =  "["+prNo+"]["+buyer+"]["+byca_comorg_level+"]["+recv_flag+"]["+chgUserDept+"]["+add_date+"]["+dept_code+"]["+dept_name+"]["+ref_no+"]";  // 통합된 파라미터
	var param =  "["+prNo+"]["+buyer+"]["+byca_comorg_level+"]["+recv_flag+"]["+add_date+"]["+dept_code+"]["+dept_name+"]["+ref_no+"][]";  // 통합된 파라미터
  	reportOpen(fileName,param);
} 
var popupSel = "";
var g_buyer = "";
var g_pr_no = "";
var g_pr_seq = "";
//부분반려
function saveReject(buyer,pr_no,pr_seq){
	var viewType="rejectPr";
	var cancel_remark = "";
	popupSel = "saveReject";
	g_buyer = buyer;
	g_pr_no = pr_no;
	g_pr_seq = pr_seq;
	openSearchPopup("/common/remarkCancelPop.do",'?cancel_remark='+cancel_remark+'&viewType='+viewType,"500,230,no");
}
//콜백함수(파일명은 모두 동일)
function setPopupReturn(code, text){
		 if (popupSel == "saveReject") {
			 document.forms.buyerCommonMyPagePop.st_buyer.value = g_buyer;
			 document.forms.buyerCommonMyPagePop.st_pr_no.value = g_pr_no;
			 document.forms.buyerCommonMyPagePop.st_pr_seq.value = g_pr_seq;
			 document.forms.buyerCommonMyPagePop.st_prrecv_flag.value = "GR";
			 document.forms.buyerCommonMyPagePop.st_return_reason.value = code;
			 kepAjaxFormCall("/common/popup/approval/rejectPrListPop.do","buyerCommonMyPagePop","SAVE"); 
		}
}

//비고 팝업
function PrRemark(remark) {
	openSearchPopup('/common/showPrRemarkPop.do','?remark='+remark , "500,200,no");
}

//구매사유 팝업
function PrReason(reason) {
	openSearchPopup('/common/showPrRemarkPop.do','?reason='+reason , "500,200,no");
}

//예산계정 변경 팝업
function getChangeAccountPop(buyer, pr_no, pr_seq, req_dept, req_dept_name){
	//post 팝업 파라미터 설정
	var st_form_name = "changeAccountForm";
	var st_popup_url = "/mpso/showBuyerMpSoChangeAccountPop.do";
	var st_popup_param = "open@@N^||^com_code@@"+buyer+"^||^"+"pr_no@@"+pr_no+"^||^"+"pr_seq@@"+pr_seq+"^||^"+"dept_code@@"+req_dept+"^||^"+"dept_name@@"+req_dept_name;
	var st_popup_option = "750,500,no";
	//post 팝업 호출
	openSearchPopupAppendPost(st_form_name,st_popup_url,st_popup_param,st_popup_option);
}
</script> 
<body onload="setQuery()">
	 <form name=approvalSamplePop id=approvalSamplePop method=post >
	 <input type="hidden" name="VIEW" id="VIEW"  value="approvalSamplePop">  
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다-->
	<div id="popWrapper">
	   	<%
    		if("Y".equals(POP_FLAG)){//***상세팝업시 사이즈 세팅**/ %>
        	<div id="popHeader" >
	    	<h1 class="title">결재문서 상세</h1>
	        <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/<%=_closeImgSrc %>" alt="닫기버튼" /></a></p>
	  	</div>
    	<%}%>
        <!--팝업내용입니다-->
        <div id="popContainer">  
         
            <div class="scrollArea" style="height:<%=divHeight %>">
            	<!--grid-->
            	 <h3>발주번호 : <%=DOCU_NO %></h3>
                <table  class="cont_t_list02"  style="width:100%">
                    <caption>업무결재 리스트</caption>
                    <colgroup>
                    	<col width="4%" />
                        <col width="10%" />                   
                        <col width="*" />                   
                        <col width="5%" />                   
                        <col width="7%" /> 
                        <col width="7%" /> 
                        <col width="12%" />    
            <% if (cowayFlag == true){ %>
                        <col width="7%" />
                        <col width="7%" />
                        <col width="7%" />
 			<%}else{%>
 				<%if(budget_flag.equals("Y")){%>
                        <col width="15%" />
				<%}%>
 			<%}%>
                        <col width="4%" />
			<%if(bag00001 || bag00003){%>
                        <col width="5%" />
			<%}%>
			<%if(!REJECT_YN.equals("N")){ %>
                        <col width="5%" />
			<%} %>
                    </colgroup>
                    <thead>
                        <tr>
                        	<th scope="col">순번</th>
                            <th scope="col">품목코드</th>
                            <th scope="col">품목명<br>규격</th>
							<th scope="col">수량<br>단위</th>
							<th scope="col">단가<br>금액</th>
							<th scope="col">납기요청일</th>
			<%
				String title1 ="관리번호";
				if(buyer.equals("KRHYOS0026")){
					title1 ="요청부서";
				}
			%>
        				<th scope="col" >협력사<br><%=title1%></th>	
 		<%if(buyer.equals("KRCOWA0002")||buyer.equals("KRCOWA0003")||buyer.equals("KRCOWA0007")||buyer.equals("KRCOWA0008")){ %>
        				<th scope="col" >대상자</th>										
        				<th scope="col" >수수료구분</th>										
        				<th scope="col" >결제금액</th> 		       				
     	<%}else if (cowayFlag == true){  	%>
        				<th scope="col" >예산부서</th>										
        				<th scope="col" >계정</th>										
        				<th scope="col" >예산잔액</th>			
         <%}else{%>
         	<%if(budget_flag.equals("Y")){%>
         				<th scope="col" >예산부서<br>계정정보</th>
         	<%}%>										
         <%}%>											
        				<th scope="col" >첨부</th>
		<%if(bag00001){%>
        	<%if(bag00003){%>
        				<th scope="col" >비고<br>구매사유</th>
			<%}else{%>
						<th scope="col" >비고</th>
			<%}%>
		<%}else{%>
			<%if(bag00003){%>
						<th scope="col" >구매사유</th>
			<%}%>
		<%}%>
        <%if(!REJECT_YN.equals("N")){ %>
        				<th scope="col" >부분<br>반려</th>
         <%} %>										
                        </tr>              
                    </thead>
                    <tbody> 
<%
if (_dataList == null || _dataList.size() == 0){
%>
                <tr bgcolor="#FFFFFF">
		            <td colspan="16" align="center" height = "50"> 
		            <span>조회된 데이타가 없습니다.</span>
		            </td> 
           		</tr>
<%
     }else{
for (int j=0; j<_dataList.size(); j++) {
	Map<String,String> rowData = _dataList.get(j);
	
	PO_AMT_SUM = PO_AMT_SUM + Double.parseDouble( CommonUtil.bnvl(rowData.get("PO_AMT")));
	RECV_FLAG = rowData.get("RECV_FLAG");
	
%>     
<tr>
		<td height="25" align="center" title="순번"><%=j+1%></td>
		<td align="center" title="품목코드"><a class="hyperLink" href="javascript:getBuyerCatalogDisplayPop('<%=rowData.get("BYIT_COMORG_CODE")%>','<%=rowData.get("BUYER_ITEM_NO")%>','<%=rowData.get("CONTRACT_NO")%>','<%=rowData.get("CONTRACT_SEQ")%>');"><%=rowData.get("BUYER_ITEM_NO")%></a></td>

          <td title="품목명/규격" class="left"><%=rowData.get("DESCRIPTION")%><br><%=rowData.get("SPECIFICATION")%></td>

          <td class="right" title="수량/단위"><%=CommonUtil.formatNumber(rowData.get("TARGET_QTY"),true,0,3)%><br><%=rowData.get("UNIT_MEASURE")%></td>

          <td class="right" title="단가/금액"><%=CommonUtil.formatNumber(rowData.get("TARGET_PRICE"),true,0,3)%><br><%=CommonUtil.formatNumber(rowData.get("PO_AMT"),true,0,3)%></td>

          <td class="center" title="납기요청일"><%=CommonUtil.formatStrinigDate(rowData.get("RD_DATE"))%></td>
         <%

				String title1_val =rowData.get("REF_PR_NO");

			if(buyer.equals("KRHYOS0026")){

					title1_val = rowData.get("REQ_DEPT_NAME")+"/"+rowData.get("REQ_USER_NAME");

			%>

          <td class="center" title = "협력사/관리번호&nbsp;:&nbsp;<%=rowData.get("REF_PR_NO")%>"><%=rowData.get("AGENT_NAME")%><br><%=title1_val%></td>

          <%

				}else{

			%>

	          <td class="center"><%=rowData.get("AGENT_NAME")%><br><%=title1_val%></td>

          <%

				}

			%>
 			<%if(buyer.equals("KRCOWA0002")||buyer.equals("KRCOWA0003")||buyer.equals("KRCOWA0007")||buyer.equals("KRCOWA0008")){ %>
				<td  title="대상자"><%=CommonUtil.nvl(rowData.get("DAESNG_USER_NAME"))%></td>
				<td  title="수수료"><%=CommonUtil.nvl(rowData.get("GONGJE"))%></td>
				<td  title="결제금액"><%=CommonUtil.formatNumber(rowData.get("BUDAM_AMT"),true,0,3)%></td>
			 <%}else  if (cowayFlag == true){  	%>
				<td  title="예산부서"><%=CommonUtil.nvl(rowData.get("BUDGET_DEPT_NAME"))%><br><%=CommonUtil.nvl(rowData.get("BUDGET_DEPT"))%></td>
				<td  title="계정"><%=CommonUtil.nvl(rowData.get("ACCOUNT_NAME"))%><br><%=CommonUtil.nvl(rowData.get("ACCOUNT_TYPE"))%></td>
				<td  title="예산잔액"><%=CommonUtil.formatNumber(rowData.get("REST_AMT"),true,0,3)%></td>
			<%}else{%>
				<%if(budget_flag.equals("Y")){%>
					<td title="예산부서/계정정보">
						<%=CommonUtil.nvl(rowData.get("PR_BUDGET_DEPT"))%>
						<br>
					<%if(bag00005 && "RECV".equals(FLAG) && userId.equals(approval_user_id) ){%>
						<a class="hyperLink" href="javascript:getChangeAccountPop('<%=rowData.get("BUYER")%>','<%=rowData.get("PR_NO")%>','<%=rowData.get("PR_SEQ")%>','<%=rowData.get("REQ_DEPT")%>','<%=rowData.get("REQ_DEPT_NAME")%>');"><%=rowData.get("PR_ACCOUNT_TYPE")%></a>
					<%}else{%>
						<%=CommonUtil.nvl(rowData.get("PR_ACCOUNT_TYPE"))%>
					<%}%>
					</td>
				<%}%>
			<%}%>
			<%
				String IMAGE_KEY = CommonUtil.nvl(rowData.get("IMAGE_KEY"));
			%>
                	<td title="파일">
                					<input type="hidden" name="st_image_key"            value="<%=IMAGE_KEY%>">
			<%
					 if(!"".equals(IMAGE_KEY)) {
			%>
				
						<a href="javascript:attach_popup('<%=IMAGE_KEY%>');"> <img src="/resources/images/disk_on.gif" name="MasterImage" width="14" height="14" border="0"> </a>
			<%
								}else {
			%>
					 <img src="/resources/images/ico_file.gif" name="MasterImage" width="14" height="14" border="0"> 
			<%
								}
			%>
                	
                	
                	</td>
			<%if(bag00001){%>
				<%if(bag00003){%>
                	<td title="비고/구매사유">
            	   	<% if(rowData.get("REMARK") != null) { %>
                		<span id="remark" class="btn_quickbuy mb02"><a href="javascript:PrRemark('<%=rowData.get("REMARK")%>');">비고</a></span>
                	<% } %>
                		<br>
                	<% if(rowData.get("PR_REASON") != null) { %>
                		<span id="pr_reason" class="btn_quickbuy mb02"><a href="javascript:PrReason('<%=rowData.get("PR_REASON")%>');">구매사유</a></span>
                	<% } %>                	        	
                	</td>
               	<%}else{%>
               		<td title="비고">
                	<% if(rowData.get("REMARK") != null) { %>
                		<span id="remark" class="btn_quickbuy mb02"><a href="javascript:PrRemark('<%=rowData.get("REMARK")%>');">비고</a></span>
                	<% } %>
                	</td>
               	<%}%>
			<%}else{%>
				<%if(bag00003){%>
					<td title="구매사유">
                	<% if(rowData.get("PR_REASON") != null) { %>
                		<span id="pr_reason" class="btn_quickbuy mb02"><a href="javascript:PrReason('<%=rowData.get("PR_REASON")%>');">구매사유</a></span>
                	<% } %>
                	</td>
				<%}%>
			<%}%>
                	<%if(!REJECT_YN.equals("N")){ %>
                	<td class="center" title="부분반려">
                	<%
                	if(_dataList.size() > 1){
                		if ("RECV".equals(FLAG)&& "0".equals(pass_status)  &&userId.equals(approval_user_id)){ 
                	%><span class="btn_quickbuy mb02"  title="반려">
                			<a href="javascript:saveReject('<%=rowData.get("BUYER")%>','<%=rowData.get("PR_NO")%>','<%=rowData.get("PR_SEQ")%>');">반려</a>
                		</span>
                	<%
                		}else if(!"RECV".equals(FLAG)){
    						%>	                			
    	                			<%=CommonUtil.nvl(rowData.get("RECV_FLAG_TEXT"))%>
    	                			<br>
    	                			<%=CommonUtil.nvl(rowData.get("RETURN_REASON"))%>
    	                	<%
                		}
                	}else{
                		if(!"RECV".equals(FLAG)){
                	%>
                			<%=CommonUtil.nvl(rowData.get("RECV_FLAG_TEXT"))%>
                			<br>
                			<%=CommonUtil.nvl(rowData.get("RETURN_REASON"))%>
                	<%
                		}
                	}
                	%>
                	</td>
                	<%
                	}
                	%>


<%}

%>
<tr>
<%

}%>                      
                    </tbody>
                </table>     
                <span class="fr"><b>금액합계 :  <%=CommonUtil.formatNumber(PO_AMT_SUM,true,0,3)%> / 총건수:  <%=CommonUtil.formatNumber(_dataList.size(),true,0,3)%></b> 
                <input type="hidden" id="st_recv_flag" name="st_recv_flag" value="<%=RECV_FLAG%>" >
                </span> 
        </div>
       <!--버튼영역--> 
       <%if ("Y".equals(POP_FLAG)) { %>  
		 <div class="btnArea" >  
		 	<span class="fl">
	  		<% if (!"NONE".equals(reportText)) { %>
	  			<span class="btn_04 mr04"  title="<%=reportText%>"><a href="javascript:prnSheet();"><%=reportText%></a></span>  
	  		<%} %>
	  		</span>
		</div>
		<%} %> 
    </div>        
</div>
</form> 
</body>
</html>
