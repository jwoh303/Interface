<%--
**********************************************
* 메뉴 :  결재
* 화면 : 결재리스트 -반품정보수정
* 기능 : 결재리스트
* 프로그램 ID : 
**********************************************
--%> 
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.*"%> 
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


String buyer = CommonUtil.nvl((String) request.getParameter("COMPANY"),""); // 조회조건
String DOCU_NO = CommonUtil.nvl((String) request.getParameter("DOCU_NO"),""); // 조회조건
String DOC_TYPE = CommonUtil.nvl((String) request.getParameter("DOC_TYPE"),""); // 조회조건


String PO_NO = "";
String HIST_RSN_CD = "";
String HIST_RSN_CD_TEXT = "";
String HIST_RSN_CD_array_deatil[] = null;
String POP_FLAG = CommonUtil.nvl((String) request.getParameter("POP_FLAG"),""); //***상세팝업시 사이즈 세팅**/
String divHeight = "200px"; //***상세팝업시 사이즈 세팅**/
if("Y".equals(POP_FLAG))//***상세팝업시 사이즈 세팅**/
	divHeight = "600px";//***상세팝업시 사이즈 세팅**/

String com_type = "";
if (_sessionInfo != null){
	com_type =  CommonUtil.nvl((String)_sessionInfo.getComType()); 	
}
%>
<script type="text/javascript"> 
 

function  attach_popup(img_key){	
	
	var type = "<%=DOC_TYPE%>";
	var viewType = "R";
	kepFileUploadOpenPopup(img_key,type,viewType); 
}
function setQuery(){
	
}
function doAction(){
	var tot_cnt     =  $("#display_item_cnt").val();
    var query = "";
    var st_gw_no = "";
    if(eval(tot_cnt) == 0)
    {
        alert("조회한 데이타가 없습니다.");
        return;
    }
    if(eval(tot_cnt) < 2){
    	var st_status = document.forms.approvalWmReListPop.st_status.value;
    	if(st_status != "E"){
    		alert("결재상태가 에러일때 가능합니다.");
    		return;
    	}
    	query  = document.forms.approvalWmReListPop.st_gw_no.value;
    }else{
    	var st_status = "";    	
        for(var j = 0; j < tot_cnt; j++){
            st_gw_no          = document.forms.approvalWmReListPop.st_gw_no[j].value;
            if(document.forms.approvalWmReListPop.st_status[j].value == "E"){
            	st_status = document.forms.approvalWmReListPop.st_status[j].value;	
            }           
        }
    	if(st_status != "E"){
    		alert("결재상태가 에러일때 가능합니다.");
    		return;
    	}     
        query = st_gw_no;
    	
    }
    document.forms.approvalWmReListPop.DOCU_NO.value = st_gw_no;
    document.forms.approvalWmReListPop.st_update.value = query; 
    kepAjaxFormCall("/common/popup/approval/runlWmReListPop.do","approvalWmReListPop","runlWmReListPop");
}
//조회
function kepSearch(){
	var tot_cnt     =  $("#display_item_cnt").val();
    if(eval(tot_cnt) < 2){
    	gw_no = document.forms.approvalWmReListPop.st_gw_no.value;
    }else{
    	gw_no = document.forms.approvalWmReListPop.st_gw_no[0].value;
    }
	$('#approvalWmReListPop').attr("action", "/common/approval/getBuyerCommonMyPagePop.do").submit();   
}
/**
 * ajax 공통 호출후 성공시 처리 함수
 */ 
function kepAjaxSuccess(pMethod , response){
	var sMsg = response.msg.MSG;
    if(sMsg == "UPDATE_OK"){
        if(pMethod == "runlWmReListPop")  //재실행
        { 
     	   alert("재실행 처리했습니다 .");
     	  kepSearch();
        } 
    }
}

/**
 * ajax 공통 호출후 에러시 처리 함수
 */
function  kepAjaxError(pMethod , response) {
	if (pMethod == "runlWmReListPop"){ 
		 alert("재실행 처리에 실패하였습니다.\n\n다시 한 번 시도해 주시기 바랍니다.  "); 
	} 
	 
	
} 
</script> 
<body onload="setQuery()">
	<form name="processForm" id="processForm" method="post">	
		<input type="hidden" name="st_update" id="st_update" value="" /> 
	</form>
	 <form name=approvalWmReListPop id=approvalWmReListPop approvalWmReListPop=post >
	 <input type="hidden" name="VIEW" id="VIEW"  value="approvalWmReListPop">   
	 <input type="hidden" name="st_update" id="st_update"  value="">
	<input type="hidden" name="COMPANY"   id="COMPANY"     value="KRKORE0001">
	<input type="hidden" name="DOCU_NO"   id="DOCU_NO"     value="">
	<input type="hidden" name="PASS_TP"   id="PASS_TP"     value="2">								
	<input type="hidden" name="FLAG"   id="PASS_TP"     value="RECV">
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
       
      <table  class="cont_t_list02"  style="width:100%">
                    <caption>업무결재 리스트</caption>
                    <colgroup>
                        <col width="5%" />                   
                        <col width="7%" />                   
                        <col width="8%" />
                        <col width="10%" />
                        <col width="*" />                   
                        <col width="15%" />                                      
                        <col width="5%" />
                        <col width="5%" />  
                        <col width="20%" />            
                    </colgroup>
                    <thead>
                        <tr>
                            <th rowspan="2"   scope="col">구분</th>
                            <th rowspan="2" scope="col">고객사</th> 
                            <th scope="col">발주번호</th>
                            <th scope="col">품목코드</th> 
                            <th scope="col">품목명</th>
                            <th scope="col">메이커</th>
							<th scope="col">단위</th>
							<th scope="col">단가</th>							
							<th rowspan="2"  scope="col">결재상태</th> 
						</tr>
                        <tr>
                        	<th scope="col">처리결과</th>
                            <th scope="col">협력사</th>
                            <th scope="col">규격</th>
                            <th scope="col">모델번호</th>
                            <th scope="col">발주수량</th>
                            <th scope="col">금액</th>
						</tr>
					</thead>
					<tbody>
					<%
if (_dataList == null || _dataList.size() == 0){
%>
                <tr bgcolor="#FFFFFF">
		            <td colspan="11" align="center" height = "50"> 
		            <span>조회된 데이타가 없습니다.</span>
		            </td> 
           		</tr>
<%
     }else{
for (int j=0; j<_dataList.size(); j++) {
	Map<String,String> rowData = _dataList.get(j); 	
	
%>     
						<tr>
							<td>
								<input type="hidden" name="st_gw_no"  id ="st_gw_no"       value="<%=rowData.get("GW_NO")%>">
								<input type="hidden" name="st_status"   id=""     value="<%=rowData.get("STATUS")%>">
								<%=rowData.get("DOC_CD")%>
							</td>
							<td><%=rowData.get("BUYER_NAME")%></td>
							<td><%=rowData.get("PO_NO")%><br><%=rowData.get("STATUS_NM")%></td>
							<td><%=rowData.get("BUYER_ITEM_NO")%><br><%=rowData.get("AGENT_NAME")%></td>
							<td class="left"><%=rowData.get("DESCRIPTION")%><br><%=rowData.get("SPECIFICATION")%></td>
							<td class="left"><%=rowData.get("MAKER_NAME")%><br><%=rowData.get("MAKER_PART_NO")%></td>
							<td><%=rowData.get("UNIT_MEASURE")%><br><%=CommonUtil.formatNumber(rowData.get("ITEM_QTY"),true,0,3)%></td>
<%if(!com_type.equals("W")){%>							
							<td class="right"><%=CommonUtil.formatNumber(rowData.get("UNIT_PRICE"),true,0,3)%><br><%=CommonUtil.formatNumber(rowData.get("ITEM_AMT"),true,0,3)%></td>
<%}else{%>
							<td><br></td>
<%}%>							
							<td class="left"><%=rowData.get("ERR_MSG")%></td>
 						<tr>
<%} 
}%>  
					</tbody>
					</table>
<%	if (_dataList != null && _dataList.size() > 0){	%>
			 <input type="hidden" name="display_item_cnt" id="display_item_cnt" value="<%=_dataList.size() %>" >
<%	}	%>
			<div class="btnArea">
  				<span class="fr">
  					<span class="btn_02 mr04"><a href="javascript:doAction();">재실행</a></span>
  				</span>
  			 </div>
        </div>
       
    </div>        
</div>
</form> 
</body>
</html>
