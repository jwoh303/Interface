<%--
**********************************************
* 메뉴 : 협력사 > 견적관리
* 화면 : 견적의뢰 접수(예)
* 기능 : KeP에서 협력사에 요청한 견적요청내역을 조회하고 요청접수를 하거나 견적포기 처리를 한다
* 프로그램 ID : PG_04_A_001_00
* 담당자 : 김영미(설계:권우재)
* 생성일 : 2014-07-28
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ page import="java.util.*"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<!doctype html>
<html>
<head>
<%@include file="../../common/include/head.jspf" %>
</head>
<%
@SuppressWarnings (value="unchecked")
List<Map<String,String>> _gridList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된결과
String total_cnt = CommonUtil.nvlObj((List<Map<String,String>>) _gridList ,"0"); // 총 조회수 (필수)
String curPage = CommonUtil.nvl((String) request.getParameter("curPage"),"1"); // 현재페이지  (필수)
String onepagerow = (String) request.getParameter("onepagerow");  // 정렬갯수 <-- 없을경우 무조건 임의의 갯수로 고정처리한다.
String msg = CommonUtil.nvl( (String)request.getAttribute("msg"),""); // 결과
String com_code = CommonUtil.nvl((String) request.getParameter("com_code"), _sessionInfo.getComCode());
int page_display_cnt = 0;
%> 

<body onload="kep_onload_view()">
<div id="wrapper"> 
<!-----------------------------------------------------------------------------------------------header------------------------------------------------------------------------------------------------------->
<c:import charEncoding="utf-8" url="/menu/menu.do" >
<c:param name="page" value="sellerHeader"/>
<c:param name="part" value="header"/>
</c:import>
<!-----------------------------------------------------------------------------------------------header------------------------------------------------------------------------------------------------------->
<div id="container2">  
<c:import charEncoding="utf-8" url="/menu/menu.do">
<c:param name="page" value="sellerLeft"/>
<c:param name="part" value="${param.upperId}" />
</c:import>
<!--내용 시작-->		

        <div id="ContArea">
        	<h3>견적요청 접수</h3>
        	<div style="height:30px;"></div>
            <!--조회영역-->
	  	<form name = "searchForm" method = "post">
   			<input type="hidden" name="curPage" id="curPage" value="<%=curPage %>" />
   			<input type="hidden" id="upperId"  name="upperId" value="<c:out value="${param.upperId}"/>">
			<input type="hidden" name="agent" id="agent" value="${sessionInfo.comCode}">
	  		<span class="fl"><img src="/resources/images/txt_no.gif" alt="정렬개수" style="padding-top:3px;"/>
	       	<label for="b_no02" class="hidden">정렬개수선택</label>
				<select name="onepagerow" onChange="javascript:kepSearch('this')">
					<option value = "10" <%if ("10".equals(onepagerow)) {%>selected<%} %>>10건</option>
					<option value = "20" <%if ("20".equals(onepagerow)) {%>selected<%} %>>20건</option>
					<option value = "30" <%if ("30".equals(onepagerow)) {%>selected<%} %>>30건</option>
					<option value = "40" <%if ("40".equals(onepagerow)) {%>selected<%} %>>40건</option>
					<option value = "50" <%if ("50".equals(onepagerow)) {%>selected<%} %>>50건</option> 
				</select>
	       	</span>
	        <span class="fr">총건수 <%=total_cnt %></span>
		</form>
		<br>                    
                
 		 <form name = "contentForm" method = "post">
		 <input type="hidden" name="curPage" id="curPage" value="<%=curPage %>" />
		 <input type=hidden name="st_sign_source" id="st_sign_source"  value="" />
		 <input type=hidden name="st_sign_value" id="st_sign_value"  value="" />
		 <input type="hidden" name="signedDataTemp" id="signedDataTemp" value="" />
		 <input type="hidden" name="getR" id="getR" value="" />
            	<!--grid-->
                <table  class="cont_t_list02"  style="width:100%">
                    <caption>견적요청 접수</caption>
                    <colgroup>
                        <col width="4%" />
                        <col width="8%" />
                        <col width="9%" />
                        <col width="9%" />
                        <col width="15%" />
                        <col width="8%" />
                        <col width="7%" />
                        <col width="8%" />
                        <col width="8%" />
                        <col width="10%" />
                        <col width="6%" />
                        <col width="6%" />
                    </colgroup>
                    <thead>
				        <tr>
				          <th rowspan="2"><input type="checkbox" name="check_status" id="check_status" value="선택"  style="cursor:hand;" onclick="kepCheckAll(document.forms.contentForm.display_item_cnt.value,document.forms.contentForm.check_status,'document.forms.contentForm.checkbox')"> </th>
				          <th colspan="2" >진행상태</th>
				          <th >견적요청일</th>
				          <th >품목명</th>
				          <th >품목코드</th>
				          <th >제조사</th>
				          <th>조달일수</th>
				          <th >제출단가</th>
				          <th colspan="3" >KeP담당자</th>
				        </tr>
				        <tr>
				          <th >견적번호</th>
				          <th >순번</th>
				          <th >견적마감일</th>
				          <th >규격</th>
				          <th >제품코드</th>
				          <th >원산지</th>
				          <th>수량/단위</th>
				          <th >금액합계</th>
				          <th>운영사비고</th>
				          <th >파일</th>
				          <th >첨부</th>
				        </tr>
                    </thead>
                    <tbody>
				 		<%
				        if (_gridList == null || _gridList.size() == 0){
				        %>
				                            <tr bgcolor="#FFFFFF">
				                        <td colspan="12" align="center" height = "50"> 
				                        <span>조회된 데이타가 없습니다.</span>
				                        </td> 
				                    </tr>
				        <%
				        }else{
				        	
				        	String aaa=null;
				            
							for (int j=0; j<_gridList.size(); j++) {
								Map<String,String> rowData = _gridList.get(j);
								String  tclass = (j % 2 != 0)? "#FFFFFF" : "#FAFAFA";
								
								page_display_cnt++;
						%> 

							<tr align="center" bgcolor="<%=tclass%>">
					          <td  rowspan="2">
					          	<input type="checkbox" name="checkbox" id="checkbox<%=j%>">
					          	<input type="hidden" id="st_irs_no" name="st_irs_no" value="<%=CommonUtil.nvl(rowData.get("AGENT_IRS_NO"))%>" />
						        <input type="hidden" name="st_buyer"            value="<%=rowData.get("BUYER") %>">
						        <input type="hidden" name="st_user_id" id="st_user_id" value="${sessionInfo.userId}">
						        <input type="hidden" name="st_user_name" id="st_user_name" value="${sessionInfo.userNameLoc}">
						        <input type="hidden" name="st_user_tel" id="st_user_tel" value="${sessionInfo.tel}">
						        <input type="hidden" name="st_quotation_no"     value="<%=rowData.get("QUOTATION_NO") %>">
						        <input type="hidden" name="st_quotation_seq"    value="<%=rowData.get("QUOTATION_SEQ") %>">
						        <input type="hidden" name="st_revision"         value="<%=rowData.get("REVISION")%>">
						        <input type="hidden" name="st_agent"            value="<%=rowData.get("AGENT") %>">
						        <input type="hidden" name="st_agent_revision"   value="<%=rowData.get("AGENT_REVISION")%>">
						        <input type="hidden" name="st_cert_yn"          value="<%=rowData.get("CERT_CHECK") %>">
						        <input type="hidden" name="st_giveup_yn"          value="N">
<%-- 						        <input type="hidden" name="st_agent_irs_no"     value="<%=rowData.get("AGENT_IRS_NO") %>"> --%>
					          </td>
					          <td  colspan="2">
					<%
					      if(rowData.get("SOURCING_STATUS").equals("신규견적")) {
					%>
					            <%=rowData.get("SOURCING_STATUS") %>
					<%
					      }else {
					%>
					            <a class="hyperLink" href="javascript:AgentSourcingHistory('<%=rowData.get("BUYER") %>','<%=rowData.get("QUOTATION_NO") %>','<%=rowData.get("QUOTATION_SEQ") %>','<%=rowData.get("REVISION") %>','<%=rowData.get("AGENT") %>');"><%=rowData.get("SOURCING_STATUS") %></a>
					<%
					      }
					%>
					<!-- SLOGIC-BEGIN(P04-4040-02) -->
					<%
					      if(rowData.get("BUYER").equals("KRHITE0006") || rowData.get("BUYER").equals("KRFAGB0002")) {
					%>
					            (<%=rowData.get("BUYER_NAME") %>)
					<!-- SLOGIC-END -->
					<%
					      }
					
							if(rowData.get("STOA_DATE").equals("") && rowData.get("STOA_TIME").equals("")) {
					%>
					
							<b><font color="blue">(미제출)</font></b>
					<%
							}else {
					%>
							<b><font color="red">(제출)</font></b>
					<%
							}
							if(rowData.get("CERT_CHECK").equals("Y")) {
					%>
							<b><font color="red">(인증서)</font></b>
					<%
							}
					%>
					          </td>
					          <td ><%=rowData.get("ATOS_DATE") %></td>
					          <td  align="left" nowrap title="<%=rowData.get("DESCRIPTION") %>">
					            <a href="#"><div style="oerflow:hidden; text-overflow:ellipsis; width:150px"><%=rowData.get("DESCRIPTION") %></div></a>
					          </td>
					          <td align="left" >
					<%
					      // 두산인프라코어만 I/F 에서 REMARK_URL에 첨부파일이 첨부된다.
					      if("".equals(rowData.get("REMARK_URL").trim())) {
					          if(rowData.get("REF_NO").trim().equals("")){
					%>
					            <%=rowData.get("BUYER_ITEM_NO") %>
					<%
					          }else{
					%>
					            <%=rowData.get("BUYER_ITEM_NO") %><br>(<%=rowData.get("REF_NO") %>)
					<%
					          }
					      }else {
					          if("".equals(rowData.get("REF_NO").trim())){
					%>
					            <a class="hyperLink" href="javascript:getRemarkUrL('<%=rowData.get("REMARK_URL") %>');"><%=rowData.get("BUYER_ITEM_NO") %></a>
					<%
					          }else{
					%>
					            <a class="hyperLink" href="javascript:getRemarkUrL('<%=rowData.get("REMARK_URL") %>');"><%=rowData.get("BUYER_ITEM_NO") %></a><br>(<%=rowData.get("REF_NO") %>)
					<%
					          }
					      }
					%>
					          </td>
					          <td class="center" title="제조사">
					          <input type="text" class="input_type_text" name="st_maker_name" id="st_maker_name" value="<%=rowData.get("MAKER_NAME") %>" style="background-color:<%=tclass%>;width:80px;border-width:0px;" readonly>
<%-- 					            <input type="text" class="input_type_text" name="st_maker_name" id="st_maker_name" value="<%=rowData.get("MAKER_NAME") %>"  readonly> --%>
					          </td>
					          <td title="조달일수" >
					            <input type="text" class="input_type_text" name="st_lead_time"  id="st_lead_time" style="text-align:right;width:80px;"  value="<%=rowData.get("LEAD_TIME")%>" onkeypress="onlyNumber();" />
							  </td>
					          <td align="center" title="제출단가">
					            <input type="text" class="input_type_text" name="st_stoa_list_price_text" id="st_stoa_list_price_text" style="text-align:right;width:80px;" value="<%=rowData.get("STOA_LIST_PRICE")%>" onBlur="displayAgentPrice(<%=j%>);">
					            <input type="hidden" name="st_stoa_list_price" id="st_stoa_list_price" value="<%=rowData.get("STOA_LIST_PRICE") %>">
					          </td>
					          <td colspan="3" title="kep담당자">
					            <a class="hyperLink" href="javascript:KePManager('<%=rowData.get("KEP_USER_ID") %>');"><%=rowData.get("KEP_USER_NAME") %></a>
					          </td>
					        </tr>
					        
					        <tr bgcolor="<%=tclass%>">
					          <td  title="견적번호">
					            <a class="hyperLink" href="javascript:req_print('<%=rowData.get("BUYER") %>','<%=rowData.get("QUOTATION_NO") %>','<%=rowData.get("QUOTATION_SEQ") %>','<%=rowData.get("REVISION") %>','<%=rowData.get("KEP_USER_ID") %>','<%=rowData.get("REF_NO") %>');">
					              <b><%=rowData.get("QUOTATION_NO") %></b>
					            </a>
					          </td>
					          <td  title="순번"><%=rowData.get("QUOTATION_SEQ") %></td>
					          <td  title="견적마감일">
					            <b>
					              <%=CommonUtil.formatDate(rowData.get("ATOS_END_DATE"), CommonUtil.YYYYMMDD)%>
					<%
									String time1 = "";
									String time2 = "";
									if( !"".equals(rowData.get("ATOS_END_TIME"))){
						                time1 = rowData.get("ATOS_END_TIME").substring(0,2);
						                time2 = rowData.get("ATOS_END_TIME").substring(2,4);
									}
					%>
					              <%=time1%>:<%=time2%>
					            </b>
					          </td>
					          <td  align="left" nowrap title="<%=rowData.get("SPECIFICATION") %>">
					            <a href="#" ><div style="overflow:hidden; text-overflow:ellipsis; width:150px"><%=rowData.get("SPECIFICATION") %></div></a>
					          </td>
					          <td  align="left" nowrap title="제품코드">
					            <input type="text" class="input_type_text" name="st_maker_part_no" id="st_maker_part_no"   value="<%=rowData.get("MAKER_PART_NO") %>" style="background-color:<%=tclass%>;width:80px;border-width:0px;" readonly>
					          </td>
					          <td  class="center" title="원산지">
					            <input type="hidden" name="st_origin_code"  value="<%=rowData.get("ORIGIN_CODE") %>" style="width:95%">
					            <input type="text" class="input_type_text" name="st_origin_name" id="st_origin_name"   value="<%=rowData.get("ORIGIN_NAME") %>" style="background-color:<%=tclass%>;width:80px;border-width:0px;" readonly>
					          </td>
								<td  align="center" title="수량/단위">
								    <input type="hidden" name="st_item_qty" id="st_item_qty" value="<%=rowData.get("ITEM_QTY") %>">
					            <%=rowData.get("ITEM_QTY")%>&nbsp;
					            
					            / 
<!-- 								</td> -->
<!-- 					          <td  align="right"  width="30" title="단위"> -->
							  <%=rowData.get("UNIT_MEASURE") %>
					          </td>
					          <td title="견적금액합계(VAT별도)"  align="center">
					            <input type="text" class="input_type_text" name="st_stoa_list_price_amt" id="st_stoa_list_price_amt" style="text-align:right; border-width:0; width:60px; background-color:<%=tclass%>;" value="<%=rowData.get("ITEM_AMT")%>" readonly>  
					          </td>
					          <td class="center" title="운영사비고">
					          	<%=rowData.get("ATOS_REMARK_M") %>
					          	<input type="hidden" name="st_remark" id="st_remark" value="">
					            <input type="hidden" name="st_atos_remark" id="st_atos_remark" value="<%=rowData.get("ATOS_REMARK") %>">
					            <input type="hidden" name="st_stoa_remark" id="st_stoa_remark" value="<%=rowData.get("STOA_REMARK") %>">
								<%
								      if("".equals(rowData.get("ATOS_REMARK")) && "".equals(rowData.get("STOA_REMARK"))) {
								%>
								            <a href="javascript:doPop('remarkStoA','<%=rowData.get("ATOS_REMARK") %>','<%=rowData.get("STOA_REMARK") %>', <%=j%>);"><img name = "st_stoa_remark_img" id="st_stoa_remark_img" src="/resources/images/but_icon02.gif" border="0"></a>
								<%
								      }else {
								%>
								            <a href="javascript:doPop('remarkStoA','<%=rowData.get("ATOS_REMARK") %>','<%=rowData.get("STOA_REMARK") %>', <%=j%>);"><img name = "st_stoa_remark_img" id="st_stoa_remark_img" src="/resources/images/but_icon01.gif" border="0"></a>
								<%
								      }
								%>
					          </td>
					          <td >
					<%
					      if(!"".equals(rowData.get("IMAGE_KEY"))) {
					%>
					            <a href="javascript:doPop('attach','<%=rowData.get("IMAGE_KEY") %>','<%=rowData.get("BUYER") %>','<%=j%>');"><img src="/resources/images/disk_on.gif" border="0"></a>
					<%
					      }else {
					%>
					              <img src="/resources/images/disk_off.gif" border="0">
					<%
					      }
					%>
					          </td>
					          <td >
					            <input type="hidden" name="st_image_key" id="st_image_key" value="">
					            <a href="javascript:doPop('attachSet',<%=j%>);"><img src="/resources/images/disk_off.gif" name="st_image_key_img" id="st_image_key_img" border="0"></a>
					          </td>
					        </tr>
					<%
					      }
				        }
					%>
                    </tbody>
                </table>
				<input type="hidden" name="display_item_cnt" id="display_item_cnt"    value="<%=page_display_cnt%>">
            </form>
                
	            <!--페이징-->
	            <p class="paging" >
	            <%=CommonUtil.getPageView("kepSearch",total_cnt, curPage ,onepagerow) %> 
				</p>
				
                <!--버튼영역-->
                <div class="btnArea"> 
                	<span class="fl">
                		<font style="color: red; size: 12px; "><b>※입력한 단가를 한번 더 확인하시고 신중하게 견적제출 하여 주십시요.</b></font>
                	</span>
	                <span class="fr">
						<span class="btn_06 mr04"><a href="javaScript:doAction('reqSourcing');">견적요청서 목록</a></span>
						<span class="btn_04 mr04"><a href="javaScript:doAction('agentHandout');">견적제출</a></span>
						<span class="btn_04 "><a href="javaScript:doAction('cancel');">견적포기</a></span>
					</span>                	
				 </div>
				 
				<form name="processForm" id="processForm"  method="post">	
					<input type="hidden" name="s_SAVENAME" id="s_SAVENAME" value="" />
					<input type="hidden" name="total_cnt" id="total_cnt"  value="<%=total_cnt %>"/>
					<input type="hidden" name="curPage" id="curPage"  value="<%=curPage %>"/>
					<input type="hidden" name="onepagerow" id="onepagerow"  value="<%=onepagerow %>"/>
					<div id="process">
					</div>
				 
				</form>
          </div>    
    </div>
</div>
 
    <!--내용 종료-->	                  
    
<%@ include file="/WEB-INF/views/common/include/sellerFooter.jsp" %>    
</body>
<script type="text/javascript"> 
	var btnEvent = "";
	var gridIndex = 0;
	var remarkOn="/resources/images/but_icon01.gif";
	var remarkOff="/resources/images/but_icon02.gif";
	var diskOn = "/resources/images/disk_on.gif";
	var diskOff = "/resources/images/disk_off.gif";
	
/*
 *  최초 화면 함수
 */
function kep_onload_view(){
	
	<%if (!"complate".equals(msg)){%>
			kepSearch(1);
	<%}%> 
	
}	


//기능함수
function doAction(str) {
	st = new Date();
	btnEvent = str;
	
	switch (str) {
	case "search":
		kepSearch(curPage);
		break;
	case "reqSourcing"://견적요청서 목록
		ReqSourcingList(btnEvent);
		break;
	case "agentHandout"://견적제출
		$('#st_giveup_yn').val("N");
		agentHandout(btnEvent);
		break;
	case "cancel"://견적포기
		$('#st_giveup_yn').val("N");
		if(setGridData(btnEvent)){
			if(!confirm("견적을 포기하시겠습니까?")){ 
				return;
			}
			openSearchPopup("/common/mprq/estimateAbandonmentReasonPop.do", "", "410,400,no");
		}
		break;
	}

}

/*
 * FORM 을 이용한조회
 */
function kepSearch(curPage){
	document.forms.searchForm.target = "_self";
	document.forms.searchForm.method = "post";
	document.forms.searchForm.action = "/mprq/getSellerMpRqEstiReqList.do";
	document.forms.searchForm.submit(); 
	
}

/*
 * 견적요청서 목록
 */
function ReqSourcingList(btnEvent) {
    var tot_cnt = $("#display_item_cnt").val(); 
    
	var cnt = getCheckedRowCount(tot_cnt);
  	if(cnt <=0) {
  		alert("견적을 선택하여 주십시요.");
        return;
	}
  	
    var deli_query      = "";

    if(eval(tot_cnt)<=1) {

        buyer           = document.forms.contentForm.st_buyer.value;
        quotation_no    = document.forms.contentForm.st_quotation_no.value;
        quotation_seq   = document.forms.contentForm.st_quotation_seq.value;
        revision        = document.forms.contentForm.st_revision.value;

        deli_query  = buyer;
        deli_query += quotation_no;
        deli_query += quotation_seq;
        deli_query += revision;
        deli_query += "^||^";

    }else {

        for(var j=0; j<tot_cnt; j++) {

            var box = eval("document.forms.contentForm.checkbox" + j);

            if(box.checked==true) {

                buyer           = document.forms.contentForm.st_buyer[j].value;
                quotation_no    = document.forms.contentForm.st_quotation_no[j].value;
                quotation_seq   = document.forms.contentForm.st_quotation_seq[j].value;
                revision        = document.forms.contentForm.st_revision[j].value;

                deli_query += buyer;
                deli_query += quotation_no;
                deli_query += quotation_seq;
                deli_query += revision;
                deli_query += "^||^";
            }
        }
    }
  	
  	var param =  "["+deli_query+"]["+$('#agent').val()+"]";
	var fileName = "RD_04_B_008_03";
	
	reportOpen(fileName,param);
  	
}

/*
 * 협력사 견적요청
 */
 var rFlag = "N";
 function agentHandout(btnEvent){
	
	if(setGridData(btnEvent)){
		if (rFlag == "N"){
			if(!confirm("견적제출을 하시겠습니까?")){ 
				return;
			}
		}
		kepAjaxFormCall("/mprq/sellerMpRqEstiReqAgentHandout.do","processForm",btnEvent); 
	}
}



//협력사 견적포기
 function AgentGiveUp(reason) { 
 	var mode ="GIVEUP";
 	$("#st_mode").val(mode); 
 	
    var tot_cnt  = $("#display_item_cnt").val(); 
    var box = "";
    if(eval(tot_cnt) < 2){
    	box = eval("document.forms.contentForm.checkbox0");
        if(box.checked == true){
//             document.forms.contentForm.st_stoa_remark_img.src = remarkOn;
            document.forms.contentForm.st_remark.value = reason;
        }
    }else{
        for(var k = 0; k < tot_cnt; k++){
            box = eval("document.forms.contentForm.checkbox" + k);
            if(box.checked == true){
//                 document.forms.contentForm.st_stoa_remark_img[k].src = remarkOn;
                document.forms.contentForm.st_remark[k].value = reason;
            }
        }
    }
    
    var formArr = getFormToArr("document.forms.contentForm",false,"");
	if(formArr != null && formArr !=""){
		document.forms.processForm.s_SAVENAME.value =formArr[0];
		$("#process").html(formArr[1]);
	} else{
		alert("그리드 데이터 변환에 실패하였습니다.[getFormToArr]");
		return;
	}
    
	$('#st_giveup_yn').val("Y");
    kepAjaxFormCall("/mprq/sellerMpRqEstiReqGiveUp.do","processForm",btnEvent); 
  
 }
 
 /**
  * ajax 공통 호출후 에러시 처리 함수
  */
 function  kepAjaxError(pMethod , response) {
	 var msg = response.msg.MSG;   
 	
 	if (msg != ""){
 		alert(msg);
 	}
 } 
//ajax 공통 호출후 성공시 처리 함수
 function kepAjaxSuccess(pMethod , response){
 	var msg = response.msg.MSG;   
 	
 	if (msg != ""){
 		alert(msg);
 	}
 	// 처리후 재조회
 	kepSearch($("#curPage").val());
 }
 
/* 선택된 그리드 값을 셋팅 */
function setGridData(btnEvent){
	var returnValue = true;
	var chkFlag = false;
	//선택된 항목수 체크
	var tot_cnt  = $("#display_item_cnt").val(); 
  	var cnt      = getCheckedRowCount(tot_cnt);
  	if(cnt <=0) {
  		if (btnEvent == "cancel"){ // 견적포기
  			alert("견적포기할 폼목을 선택하여 주십시요.");
  		} else if (btnEvent == "agentHandout"){ // 견적제출
  			alert("견적제출할 폼목을 선택하여 주십시요.");
  		}
			return false;
	}
  	if (btnEvent == "agentHandout"){
  	    var box = "";
  	    if (tot_cnt < 2) {
  	    	box = eval("document.forms.contentForm.checkbox0");
	            if(box.checked == true){
	            	var lead_time  = document.forms.contentForm.st_lead_time.value;
	            	var stoa_list_price = document.forms.contentForm.st_stoa_list_price.value;
					if(kepIsValueNull(lead_time)) {
						 alert("조달일수(숫자형식)를 입력하여 주십시요.");
						 document.forms.contentForm.st_lead_time.focus();
	                     return false;
					}
					if(!kepIsNumChkStr(lead_time,1)) {
						 alert("조달일수(숫자형식)를 입력하여 주십시요.");
						 document.forms.contentForm.st_lead_time.focus();
	                     return false;
					}
					
					if(kepIsValueNull(stoa_list_price)) {
						 alert("제출단가(숫자형식)를 입력하여 주십시요.");
						 document.forms.contentForm.st_stoa_list_price_text.focus();
	                     return false;
					}
					if(!kepIsNumChkStr(stoa_list_price,3)) {
						 alert("제출단가(숫자형식)를 입력하여 주십시요.");
						 document.forms.contentForm.st_stoa_list_price_text.focus();
	                     return false;
					}
					
					if(stoa_list_price <= 1) {
						rFlag = "Y";
// 						alert("제출단가가 "+stoa_list_price+"원 입니다. 다시 입력하세요.");
						alert("유효하지 않는 견적단가입니다.");
						return;
					}
	            }
  	    } else {
  	        for(var k = 0; k < tot_cnt; k++){
  	            box = eval("document.forms.contentForm.checkbox" + k);
  	            if(box.checked == true){
  	            	var lead_time  = document.forms.contentForm.st_lead_time[k].value;
  	            	var stoa_list_price = document.forms.contentForm.st_stoa_list_price[k].value;
  					if(kepIsValueNull(lead_time)) {
  						 alert("조달일수(숫자형식)를 입력하여 주십시요.");
  						 document.forms.contentForm.st_lead_time[k].focus();
  	                     return false;
  					}
  					if(!kepIsNumChkStr(lead_time,1)) {
  						 alert("조달일수(숫자형식)를 입력하여 주십시요.");
  						 document.forms.contentForm.st_lead_time[k].focus();
  	                     return false;
  					}
  					
  					if(kepIsValueNull(stoa_list_price)) {
  						 alert("제출단가(숫자형식)를 입력하여 주십시요.");
  						 document.forms.contentForm.st_stoa_list_price_text[k].focus();
  	                     return false;
  					}
  					if(!kepIsNumChkStr(stoa_list_price,3)) {
  						 alert("제출단가(숫자형식)를 입력하여 주십시요.");
  						 document.forms.contentForm.st_stoa_list_price_text[k].focus();
  	                     return false;
  					}
  					
  					if(stoa_list_price <= 1) {
  						rFlag = "Y";
//   						alert("제출단가가 "+stoa_list_price+"원 입니다. 다시 입력하세요."); 
						alert("유효하지 않는 견적단가입니다.");
  						return;
  					}
  	            }
  	        }
  	    }
  	}
  	
	var chkGridValue = {};
	if(btnEvent == "agentHandout") {
		chkFlag=true;
		chkGridValue = {
				keys : ["st_cert_yn"] ,
				value0 : "Y",
				msg0 : "공동인증서 필수인 견적건이 포함되어 있습니다.\n (인증서) 표기 견적건은 공동인증서 로그인 후\n 견적제출하여 주십시요."
		}; 
	} else if(btnEvent == "cancel" ){
		if( cnt > 1) {
		alert("한번에 하나의 견적만 포기 가능 합니다.");
		return false;
		} else {
			return true;
		}
	}
	
	var formArr = getFormToArr("document.forms.contentForm",chkFlag,chkGridValue);
	if(formArr != null && formArr !=""){
		document.forms.processForm.s_SAVENAME.value =formArr[0];
		$("#process").html(formArr[1]);
	}else{
		alert("그리드 데이터 변환에 실패하였습니다.[getFormToArr]");
		returnValue = false;
	}

	return returnValue;
}
/**
 * 체크 된 수
 */
function getCheckedRowCount(tot_cnt) {
	if (tot_cnt == 0){
		return 0;
	}
	
	var chk_cnt = 0;
	if(eval(tot_cnt) < 2){
	    var box = eval("document.forms.contentForm.checkbox0");
	    if(box.checked == true) chk_cnt++;
	}else{
	    for(var j = 0; j < tot_cnt; j++){
	         var box = eval("document.forms.contentForm.checkbox" + j);
	         if(box.checked == true){
	              chk_cnt++;
	         }
	    }
	}
	return chk_cnt;
}
//팝업함수호출
function doPop(str, value1, value2,idx) {
	popupSel = str ;
	gridIndex = idx;
	
	switch (str) {
	case "remarkStoA":
		var atos_remark = value1;
		var stoa_remark = $("input[name=st_stoa_remark]").eq(gridIndex).val();
		openSearchPopup("/common/remarkStoAPop.do", '?st_atos_remark='+atos_remark+'&st_stoa_remark='+stoa_remark, "500,310,no");
		
		break;
	case "attach"://파일 첨부
		//SLOGIC-BEGIN(P04-4040-03)
		if (value2 == "KRKORE0254"){
			var image_key = value1;
			attach_popup(image_key);
		//SLOGIC-END				
		} else {
			var type="RFQ";
			var viewType="R";
			openSearchPopup('/common/fileUploadPop.do','?DOC_NO='+value1+'&TYPE='+type+'&viewType='+viewType,'500,430,no');// 파일첨부
		}
		break;
	case "attachSet"://파일 첨부(등록)
		var type="RFQ";
		var viewType="VI";
		gridIndex = value1;
		var image_key =  $("input[name=st_image_key]").eq(gridIndex).val();
		openSearchPopup('/common/fileUploadPop.do','?DOC_NO='+image_key+'&TYPE='+type+'&viewType='+viewType,'500,430,no');// 파일첨부
		break;
	}
}

function attach_popup(image_key){
    var left = 0;
    var top = 0;
    var width = 800;
    var height = 400;
    var toolbar = 'no';
    var menubar = 'no';
    var status = 'no';
    var scrollbars = 'yes';
    var resizable = 'no';
//  var loc = "http://safety.koreab2b.com/kr/common/popup/attach_view_pop_doosanmeca.jsp?st_image_key="+image_key;
    var loc = "http://safety.koreab2b.com/file/view.wu?fileUploadId=fileUploadPop&bizType=BOARD&fileUuid="+image_key+"&callback=setFileImage&callbackParam=0%2CCSTMR_ATTCH_FILE_NO_IMAGE%2CCSTMR_ATTCH_FILE_NO&removeBtnUnvisible=false";
    window.open(loc,'attach_popup', 'left='+left+', top='+top+', width='+width+', height='+height+', toolbar='+toolbar+', menubar='+menubar+', status='+status+', scrollbars='+scrollbars+', resizable='+resizable);
}

//콜백함수(파일명은 모두 동일)
function setPopupReturn(value1, value2){
	
	if (popupSel == "remarkStoA"){
		$("input[name=st_stoa_remark]").eq(gridIndex).val(value1);
	 	 if(value1 ==""){
	 		$("img[id=st_stoa_remark_img]").eq(gridIndex).attr("src",remarkOff);
	 	 }else{
	 		$("img[id=st_stoa_remark_img]").eq(gridIndex).attr("src",remarkOn);
	 	 }
	} else if(popupSel == "attachSet") {	//파일 첨부
		 $("input[name=st_image_key]").eq(gridIndex).val(value1);
	 	 if(value1 ==""){
			 $("img[id=st_image_key_img]").eq(gridIndex).attr("src",diskOff);
	 	 }else{
			 $("img[id=st_image_key_img]").eq(gridIndex).attr("src",diskOn);
	 	 }
	}
}
// 견적요청서
function req_print(buyer,quotation_no,quotation_seq,revision,kep_user_id,ref_no){
	//SLOGIC-BEGIN(P04-4040-05)
	var param = "";
	var fileName = "";
	var rfq_gubun = ref_no;
    if(rfq_gubun == "RFQ"){
    	fileName = "RD_04_M_005_02";
    	param =  "["+quotation_no+"]["+revision+"]["+buyer+"]";
    } else {
    	fileName = "RD_04_M_006_01";
    	param =  "["+buyer+"]["+quotation_no+"]["+quotation_seq+"]["+revision+"]["+kep_user_id+"]["+"${sessionInfo.comCode}"+"]";
    }
	reportOpen(fileName,param);
	//SLOGIC-END
}
function AgentSourcingHistory(buyer,quotation_no,quotation_seq,revision,agent){
	openSearchPopup("/mprq/showSellerMpRqUnitPriceHistoryPop.do", '?st_buyer='+buyer+'&st_quotation_no='+quotation_no+'&st_quotation_seq='+quotation_seq+'&st_revision='+revision+'&st_agent='+agent, "800,300,no");
}
function KePManager(kep_user_id){
	openSearchPopup("/common/kepManagerPop.do", '?st_user_id='+kep_user_id, "430,194,no");
}
function getRemarkUrL(remark_url){
	var loc = "http://ez-van.doosaninfracore.co.kr/data/APPENDIX/"+remark_url;
    window.open(loc, "doosaninfracore", "left=0,top=0");
}
function displayAgentPrice( k ) {
    var tot_cnt  = document.forms.contentForm.display_item_cnt.value;
    
	if (tot_cnt  < 2) {
        var imsi_target_qty        = kepTrimStr(kepFilterNum(document.forms.contentForm.st_item_qty.value));          // 수량 - 고정
        var imsi_list_price_text   = kepTrimStr(kepFilterNum(document.forms.contentForm.st_stoa_list_price_text.value));     // 단가 - 변화
        var imsi_list_price        = kepTrimStr(kepFilterNum(document.forms.contentForm.st_stoa_list_price.value));
	} else {
        var imsi_target_qty        = kepTrimStr(kepFilterNum(document.forms.contentForm.st_item_qty[k].value));          // 수량 - 고정
        var imsi_list_price_text   = kepTrimStr(kepFilterNum(document.forms.contentForm.st_stoa_list_price_text[k].value));     // 단가 - 변화
        var imsi_list_price        = kepTrimStr(kepFilterNum(document.forms.contentForm.st_stoa_list_price[k].value));
	}
	
    if( kepIsValueNull(imsi_list_price_text) || (imsi_list_price_text <= 1)  || !kepIsNumChkStr(imsi_list_price_text, 3)){
//         alert(" 단가를 입력해 주십시요!!   ");
        alert("유효하지 않는 견적단가입니다.");
        if (tot_cnt  < 2) {
	        document.forms.contentForm.st_stoa_list_price_text.value = imsi_list_price;
	        document.forms.contentForm.st_stoa_list_price_amt.value = kepCommaNum(imsi_target_qty * imsi_list_price);
        } else {
	        document.forms.contentForm.st_stoa_list_price_text[k].value = imsi_list_price;
	        document.forms.contentForm.st_stoa_list_price_amt[k].value = kepCommaNum(imsi_target_qty * imsi_list_price);
        }

        return;
    }

    if(imsi_list_price_text!=""){
    	if (tot_cnt  < 2) {
	        document.forms.contentForm.st_stoa_list_price.value           = eval(imsi_list_price_text);
	        document.forms.contentForm.st_stoa_list_price_text.value      = kepCommaNum(eval(imsi_list_price_text));
	        document.forms.contentForm.st_stoa_list_price_amt.value       = kepCommaNum(eval(imsi_target_qty) * eval(imsi_list_price_text));     // 금액 변경
    	} else {
	        document.forms.contentForm.st_stoa_list_price[k].value           = eval(imsi_list_price_text);
	        document.forms.contentForm.st_stoa_list_price_text[k].value      = kepCommaNum(eval(imsi_list_price_text));
	        document.forms.contentForm.st_stoa_list_price_amt[k].value       = kepCommaNum(eval(imsi_target_qty) * eval(imsi_list_price_text));     // 금액 변경
    		
    	}
    }
}
</script> 
</html>
