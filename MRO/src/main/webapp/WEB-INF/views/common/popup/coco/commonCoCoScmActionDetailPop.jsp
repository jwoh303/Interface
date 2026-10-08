<%--
**********************************************
* 메뉴 : 
* 화면 : SCM조치내역
* 기능 : 발주데이터별 SCM조치내역을 조회하고 관리한다.
* 프로그램 ID : PG_90_C_900_02
* 담당자 :  ( 설계 : 공통 )
* 착수일 : 2014-
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../../common/include/head.jspf"  %>


<%
	@SuppressWarnings (value="unchecked")
	Map<String,String> _data = (Map<String,String>) request.getAttribute("data"); // 조회된 결과 
	//SessionInfo _sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
	//String com_code=  CommonUtil.nvl((String) request.getParameter("com_code"), _sessionInfo.getComCode());
	
	String buyer = CommonUtil.nvl((String) request.getParameter("st_buyer"),"");  //  (조회조건)
	String po_no = CommonUtil.nvl((String) request.getParameter("st_po_no"),"");  //  (조회조건)
	String po_seq = CommonUtil.nvl((String) request.getParameter("st_po_seq"),"");  //  (조회조건)
	String st_WMS_YN = CommonUtil.nvl((String) request.getParameter("st_WMS_YN"),"");  //  (조회조건)
	List<Map<String, String>> _dataList = null;
	
	String dept_cd	 = _sessionInfo.getDepartment();	// 부서코드
	String user_name = _sessionInfo.getUserNameLoc();
	
	String scm_remark = CommonUtil.nvl(_data.get("SCM_REMARK"));
	String[] remark_arr = null;
	
	if(!scm_remark.equals("")){
		remark_arr = scm_remark.split("\\^\\^");
	}
%>

<script type="text/javascript">

function setDeRemark(){
	
	if($("#st_scm_remark").val().trim()== ""){
		alert("처리내역을 입력 하셔야 합니다.");
		return;
	}

	if(!confirm("처리내역을 입력 하시겠습니까?")){
		return;
	}
	
	<%if(dept_cd.equals("015")){%>
		if(document.forms[0].st_is_all[0].checked){
			if(!confirm("해당발주번호 전체에 입력내역이 반영됩니다\n\n입력하시겠습니까?")){
				return;
			}
		}
	<%}%>
	
	kepAjaxFormCall("/coco/saveCommonCoCoScmActionDetailPop.do","commonCoCoScmActionDetailPop","btnSave");
	
	/*
	document.forms[0].methdo = "post";
	document.forms[0].target = "iframe_work";
	document.forms[0].action = "/kr/sysop/proxbuy/scm/sysop_proxbuy_scm_scmremark_req.jsp";
	document.forms[0].submit();
	*/
}

//ajax 공통 호출후 성공시 처리 함수
function kepAjaxSuccess(pMethod , response){
	var msg = response.msg;
	
	if (isEmpty(msg)){
		alert("처리내역이 입력되었습니다.");
		opener.doAction("search");
		window.close();
	}
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

</script> 
</head>
<body onload="">
<form name="commonCoCoScmActionDetailPop" id="commonCoCoScmActionDetailPop" method=post >
	<input type="hidden" id="st_buyer" name="st_buyer" value="<%=buyer%>" />
	<input type="hidden" id="st_po_no" name="st_po_no" value="<%=po_no%>" />
	<input type="hidden" id="st_po_seq" name="st_po_seq" value="<%=po_seq%>" />
	<input type="hidden" id="st_user_name" name="st_user_name" value="<%=user_name%>" />
	
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다 / 500*500-->
	<div id="popWrapper" style="height:494px;">
		<div id="popHeader">
			<h1 class="title">운영자 메모</h1>
			<p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/b_btn_popclose.gif" alt="닫기버튼" /></a></p>
		</div>
		<!--팝업내용입니다-->
		<div id="popContainer">

			<div id="ContArea" style="height:30px;margin-left:10px;">
   				<h3 style="width:100%;font-size:15px;">운영자 메모 내역</h1>
			</div>

			<!--grid-->
			<div class="scrollArea" style="height:380px">
				<table  class="cont_t_list02"  style="width:100%">
					<caption>운영자 메모 내역</caption>
					<colgroup>
						<col width="20%" /> 
						<col width="30%" /> 
						<col width="*" /> 
					</colgroup>
					<thead>
						<tr>
							<th scope="col">날짜</th> 
							<th scope="col">작성자</th> 
							<th scope="col">내용</th> 
						</tr>
					</thead>
					<tbody>
				<%
					if (remark_arr == null || remark_arr.length == 0){
				%>
						<tr bgcolor="#FFFFFF">
							<td colspan="3" align="center" height = "50">
								<span class="font1">조회된 데이타가 없습니다.</span>
							</td> 
						</tr>
				<%	} else {
						for(int i=1; i < remark_arr.length; i++){
							String[] data = remark_arr[i].split("@@");
				%>
						<tr>
							<td><%=CommonUtil.formatStrinigDate(data[0])%></td>
							<td><%=CommonUtil.nvl(data[1])%></td>
							<td class="left"><%=CommonUtil.nvl(data[2])%></td>
						</tr> 
				<%		} 
					}
				%>
					</tbody>
				</table>
			</div>
		</div>
	</div>
</form> 
</body>
</html>
