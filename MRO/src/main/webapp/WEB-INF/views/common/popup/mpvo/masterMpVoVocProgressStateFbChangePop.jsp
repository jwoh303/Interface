<%--
**********************************************
* 메뉴 : 
* 화면 : VOC 진행현황(FB Change) 상세정보 팝업
* 기능 : 
* 프로그램 ID : PG_90_C_800_16
* 담당자 : 고영일 ( 설계 : 공통 )
* 착수일 : 2014-07-18
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="com.koreab2b.mro.util.DateTimeUtil"%>
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
Map<String,String> rowData = _dataList != null && _dataList.size() > 0 ? _dataList.get(0) : null;

String st_buyer = CommonUtil.nvl((String) request.getParameter("st_buyer"), "");
String st_vc_no = CommonUtil.nvl((String) request.getParameter("st_vc_no"), "");

String curDate   = DateTimeUtil.getFormatString("yyyyMMdd");

%>

<script type="text/javascript">
<!--

//기능함수
function doAction(str) {

	switch (str) {
		case "saveVocProgressStatePop":	// 저장 
			var claim_master	= $("#st_claim_master").val();
			var claim_type		= $("#st_claim_type").val();
		    var claim_grade	= $("#st_claim_grade").val();
		    var claim_kind		= $("#st_claim_kind").val();

		    if(claim_master == ""){
		        alert("VOC Type의 상위분류를 선택해 주십시오.");
		        return;
		    }

		    if(claim_type == ""){
		        alert("VOC Type의 하위분류를 선택해 주십시오.");
		        return;
		    }

		    if(claim_kind == "C" && claim_grade == ""){
		         alert("클레임 등급을 선택해 주시기 바랍니다.");
		         document.forms[0].st_claim_grade.focus();
		         return;
		    }

			if(confirm("기재하신 사항으로 저장하시겠습니까?")){
				kepAjaxPopFormCall("/mpvo/saveMasterMpVoVocProgressStateFbChangePop.do","masterMpVoVocProgressStateFbChangePop","saveVocProgressStatePop");
			}
		
			break;

	}
}

/**
* ajax 공통 호출후 성공시 처리 함수
*/ 
function kepAjaxPopSuccess(pMethod , response) {
	var sMsg = response.msg;
	
	if (pMethod == "saveVocProgressStatePop") {
		if (sMsg == "OK") {
			alert("정상적으로 저장 완료되었습니다.");
			document.location.href = "/mpvo/getMasterMpVoVocProgressStateFbChangePop.do?st_buyer=<%=st_buyer%>&st_vc_no=<%=st_vc_no%>";
			return;
		} else {
			alert("Feedback 처리하던중 오류가 발생하였습니다.");
			parent.opener.doAction("search");
			parent.close();
			return;
		}
	}
}

/**
* ajax 공통 호출후 에러시 처리 함수
*/
function  kepAjaxPopError(pMethod , response) {
	alert("처리하던중 오류가 발생하였습니다.");
	parent.opener.doAction("search");
	parent.close();
}

/**
* ajax 공통 호출후 에러시 처리 함수
*/
function  kepAjaxError(pMethod , response) {
	alert("처리하던중 오류가 발생하였습니다.");
	parent.opener.doAction("search");
	parent.close();
}

//인쇄
function setReportPrint(){
     window.focus();
     window.print();
}

//클레임 구분값 변경
function changeClaimKindVal(){
	var st_claim_type_info = $("st_claim_type_info").val();
	var st_claim_type_info2 = st_claim_type_info.split("@@", -1);
     
    var claim_type = st_claim_type_info2[0];
    var claim_kind = st_claim_type_info2[1];

    $("#st_claim_type").val(claim_type);
    $("#st_claim_kind").val(claim_kind);

	initClaimGrade(claim_kind);
}

// 클레임 등급 disabled 세팅
function initClaimGrade(claim_kind){
	if(claim_kind == "S"){
		$("#st_claim_grade").attr("disabled",true);
	}else{
		$("#st_claim_grade").attr("disabled",false);
	}
}

// 초기화 및 상태 확인
function checkRecvFlag(){

	// 콤보 생성 ( VOC Master )
	kepAjaxCommonComboDataValue("st_claim_master","VC03","SEL","<%=CommonUtil.nvl(rowData.get("CLAIM_MASTER"))%>");
	kepAjaxCommonQueryIdSearchTwoCombo("st_claim_type_info","commonTwoSearchList", "VC01", "<%=CommonUtil.nvl(rowData.get("CLAIM_MASTER"))%>", "SEL", "<%=CommonUtil.nvl(rowData.get("CLAIM_TYPE"))%>");
	
	// VOC Type 선택 시 이벤트 발생
	$("#st_claim_master").change(function(){
		// 콤보 생성 ( VOC Type )
		kepAjaxCommonQueryIdSearchTwoCombo("st_claim_type_info","commonTwoSearchList", "VC01", $(this).val(), "SEL", "");
	});
	
	initClaimGrade("<%=CommonUtil.nvl(rowData.get("CLAIM_KIND"))%>");
}
 //-->
</script> 
<body onload="checkRecvFlag();">
	 <form name="masterMpVoVocProgressStateFbChangePop" id="masterMpVoVocProgressStateFbChangePop" method="post" >
		<input type="hidden" id="st_req_user_id" name="st_req_user_id"	value="<%=rowData.get("REQ_USER_ID")%>">
		<input type="hidden" id="st_buyer" name="st_buyer"		value="<%=st_buyer%>">
		<input type="hidden" id="st_vc_no" name="st_vc_no"		value="<%=st_vc_no%>">
	 
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다-->
	<div id="popWrapper" style="height:704px;">
    	<div id="popHeader">
        	<h1 class="title">VOC 진행현황</h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/<%=_closeImgSrc %>" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer">
<%
if(_dataList == null || _dataList.size() <= 0){
%>
			<table  class="cont_t_list06 mb15" summary="VOC 진행현황" style="width:100%;">
				<caption>VOC 진행현황</caption>
				<colgroup>
					<col width="20%" />
					<col width="30%" />
					<col width="20%" />
					<col width="*" />
				</colgroup>
				<tbody>
		    	<tr>
					<td colspan="4" class="center"><font color="blue"><b>조회 된 데이터가 없습니다.</b></font></td>
				</tr>
		        </tbody>
		   </table>
<%	
}else{
%>
			<table  class="cont_t_list06 mb15" summary="VOC 진행현황" style="width:100%;">
				<caption>VOC 진행현황</caption>
				<colgroup>
					<col width="20%" />
					<col width="30%" />
					<col width="20%" />
					<col width="*" />
				</colgroup>
				<tbody>
		    	<tr>
		    		<th scope="row">접수번호</th>
					<td colspan="3"><font color="blue"><b><%=CommonUtil.nvl(rowData.get("VC_NO"))%></b></font></td>
				</tr>
		    	<tr> 
		    		<th scope="row">고객사</th>
					<td><%=CommonUtil.nvl(rowData.get("BUYER_NAME"))%>&nbsp;<%=CommonUtil.nvl(rowData.get("MRO_AREA_TEXT"))%></td>
		    		<th scope="row">요청자</th>
					<td><%=CommonUtil.nvl(rowData.get("REQ_USER_NAME"))%>&nbsp;(<%=CommonUtil.nvl(rowData.get("REQ_USER_TEL"))%>)</td>
				</tr>
				<tr>
					<th scope="row">접수자</th>
					<td><%=CommonUtil.nvl(rowData.get("CD_USER_NAME"))%></td>
					<th scope="row">처리자</th>
					<td><%=CommonUtil.nvl(rowData.get("DS_USER_NAME"))%></td>
				  </tr>
				  <tr>
					<th scope="row">발주번호</th>
					<td><%=CommonUtil.nvl(rowData.get("PO_NO"))%></td>
					<th scope="row">접수일자</th>
					<td><%=CommonUtil.nvl(rowData.get("CD_DATE"))%> <%=CommonUtil.nvl(rowData.get("CD_TIME"))%></td>
				  </tr>
				  <tr>
					<th scope="row">품목코드</th>
					<td><%=CommonUtil.nvl(rowData.get("BUYER_ITEM_NO"))%></td>
					<th scope="row">요청일자</th>
					<td><%=CommonUtil.nvl(rowData.get("REQ_DATE"))%> <%=CommonUtil.nvl(rowData.get("REQ_TIME"))%></td>
				  </tr>
				  <tr>
					<th scope="row">처리완료일</th>
					<td><%=CommonUtil.nvl(rowData.get("DF_DATE"))%></td>
					<th scope="row">상태</th>
					<td><%=CommonUtil.nvl(rowData.get("RECV_FLAG_TEXT"))%></td>
				  </tr>
				  <tr>
					<th scope="row">VOC Type</th>
					<td scope="row" colspan="3">
								<select id="st_claim_master" name="st_claim_master" onChange="redirect(this.options.selectedIndex)"></select>&nbsp;>&nbsp;
								<select id="st_claim_type_info" name="st_claim_type_info" onchange="changeClaimKindVal();">
									<option value="" >선택</option>
								</select>
								<input type="hidden" name="st_claim_type"  value="<%=rowData.get("CLAIM_TYPE")%>">   
								<input type="hidden" name="st_claim_kind"  value="<%=rowData.get("CLAIM_KIND")%>">
					</td>
				  </tr>
		        </tbody>
		   </table>
		   <div class="btnArea" style="margin-top: 10px;">
				<span class="fr">
					<span class="btn_02"><a href="javascript:;setReportPrint()" >인쇄</a></span>
				</span>                	
			</div>
			<table  class="cont_t_list06 mb15" style="width:100%;">
				<colgroup>
					<col width="20%" />
					<col width="30%" />
					<col width="20%" />
					<col width="*" />
				</colgroup>
				<tbody>
		    	<tr> 
		    		<th scope="row">SRM연계 협력사귀책</th>
					<td colspan="3"><%=CommonUtil.nvl(rowData.get("IMPUTE_TEXT"))%></td>
				</tr>
		    	<tr> 
		    		<th scope="row">업체지정</th>
					<td><%=CommonUtil.nvl(rowData.get("AGENT_NAME"))%></td>
		    		<th scope="row">클레임등급</th>
					<td>
						<select id="st_claim_grade" name="st_claim_grade">
							<option value="" > --- </option>
							<option <%=("상".equals(rowData.get("CLAIM_GRADE")) ? "selected" : "")%> value="상">상</option>
							<option <%=("중".equals(rowData.get("CLAIM_GRADE")) ? "selected" : "")%> value="중">중</option>
							<option <%=("하".equals(rowData.get("CLAIM_GRADE")) ? "selected" : "")%> value="하">하</option>
						</select>
					</td>
				</tr>
				<tr>
					<th scope="row">요청사항</th>
					<td colspan="3">
						<textarea rows="6" cols="70" id="st_req_remark" name="st_req_remark" style="text-align:left;width:100%;" readonly ><%=CommonUtil.nvl(rowData.get("REQ_REMARK"))%></textarea>
					</td>
				  </tr>
				  <tr>
					<th scope="row">처리(답변)내용</th>
					<td colspan="3">
						<textarea rows="6" cols="70" id="st_df_remark" name="st_df_remark" style="text-align:left;width:100%;" readonly ><%=CommonUtil.nvl(rowData.get("DF_REMARK"))%></textarea>
					</td>
				  </tr>
				  <tr>
					<th scope="row">진행내역</th>
					<td id="td_df_remark" colspan="3" style="height:88px; vertical-align: top;">
						<textarea rows="2" cols="70" id="st_ds_remark_1" name="st_ds_remark_1" style="text-align:left;width:100%;" readonly ><%=CommonUtil.nvl(rowData.get("DS_REMARK_A"))%></textarea>
						<textarea rows="2" cols="70" id="st_ds_remark_2" name="st_ds_remark_2" style="text-align:left;width:100%;" readonly ><%=CommonUtil.nvl(rowData.get("DS_REMARK_B"))%></textarea>
						<textarea rows="2" cols="70" id="st_ds_remark_3" name="st_ds_remark_3" style="text-align:left;width:100%;" readonly ><%=CommonUtil.nvl(rowData.get("DS_REMARK_C"))%></textarea>
					</td>
				  </tr>
		        </tbody>
		   </table>
		   <div class="btnArea" style="margin-top: 10px;">
				<span class="fr">
					<span class="btn_02"><a href="javascript:doAction('saveVocProgressStatePop');" >저장</a></span>
				</span>                	
			</div>
<% } %>
        </div>
    </div>         
</form> 
</body>
</html>
