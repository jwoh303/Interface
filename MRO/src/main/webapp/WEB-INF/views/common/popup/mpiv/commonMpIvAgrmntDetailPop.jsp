<%--
**********************************************
* 메뉴 : 
* 화면 : 합의내역
* 기능 : 
* 프로그램 ID : PG_07_M_900_28
* 담당자 :  ( 설계 : 김지현 )
* 착수일 : 2014-
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
<%@ include file="../../../common/include/head.jspf"  %>

<%
	@SuppressWarnings (value="unchecked")
	List<Map<String,String>> _dataList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된 결과 
	String _mailYn = (String) request.getAttribute("mailYn"); // 조회된 결과
	
	
	String buyer = CommonUtil.nvl((String) request.getParameter("st_buyer"),"");  //  (조회조건)
	String po_no = CommonUtil.nvl((String) request.getParameter("st_po_no"),"");  //  (조회조건)
	String po_seq = CommonUtil.nvl((String) request.getParameter("st_po_seq"),"");  //  (조회조건)
	String buyer_name = CommonUtil.nvl((String) request.getParameter("st_buyer_name"),"");  //  (조회조건)
	String rd_date = CommonUtil.nvl((String) request.getParameter("st_rd_date"),"");  //  (조회조건)
	
	if(_mailYn.equals("N")){
	
	}
%>

<script type="text/javascript">
//최초 화면 함수 
function kep_onload_view(){
	kepSetCalender('st_approval_rd_date_cal');
	
	kepAjaxCommonComboDataValue('st_reason_code', 'M065', 'SEL', '');
}

function setAgrmntDetail(){
	
	// validation check
	// 협력사담당자
	if(isEmpty($("#st_supplier_user_name").val())){
		alert("협력사담당자를 입력해 주십시요.");
		return;
	}
	
	// 납품합의일
	if(isEmpty($("#st_approval_rd_date_cal").val())){
		alert("납품합의일을 입력해 주십시요.");
		return;
	}
	
	// 사유코드
	if(isEmpty($("#st_reason_code").val())){
		alert("사유코드를 선택해 주십시요.");
		return;
	}
	
	var reason_code = $("#st_reason_code").val();
	
	if(reason_code == "R6"){
		// 납품합의일
		if(isEmpty($("#st_reason_remark").val())){
			alert("기타사유를 입력해 주십시요.");
			return;
		}	
	}
	
	if(!confirm("합의내용을 입력 하시겠습니까?")){
		return;
	}
	
	var approval_rd_date = $.datepicker.formatDate('yymmdd', $("#st_approval_rd_date_cal").datepicker("getDate"));
	$("#st_approval_rd_date").val(approval_rd_date);
	
	kepAjaxFormCall("/mpiv/saveCommonMpIvAgrmntDetailPop.do","commonMpIvAgrmntDetailPop","btnSave");
}


//ajax 공통 호출후 성공시 처리 함수
function kepAjaxSuccess(pMethod , response){
	var msg = response.msg;
	
	if (isEmpty(msg)){
		alert("합의내용이 정상적으로 저장 되었습니다.");
		$('#commonMpIvAgrmntDetailPop').attr("action", "/mpiv/getCommonMpIvAgrmntDetailPop.do").submit();
		// /mpiv/getCommonMpIvAgrmntDetailPop.do
	//	opener.doAction("search");
	//	window.close();
	}
	return;
}

//ajax 공통 호출후 실패시 처리 함수
function kepAjaxError(pMethod , response){
	var msg = response.Message;
	
	if (!isEmpty(msg)){
		alert(msg);
		//opener.doAction("search");
		//window.close();
	}
	return;
}

function setReasonRemark(){
	var reason_code = $("#st_reason_code").val();
	
//	console.log("reason_code ==>> " + reason_code);
	if(reason_code == "R6"){
		$("#st_reason_remark").removeAttr("disabled");
	} else {
		$("#st_reason_remark").val("");
		$("#st_reason_remark").attr("disabled","disabled");
	}
	return;
}

</script>
</head>
<body onload="kep_onload_view();">
<form name="commonMpIvAgrmntDetailPop" id="commonMpIvAgrmntDetailPop" method=post >
	<input type="hidden" id="st_buyer" name="st_buyer"  value="<%=buyer%>">
	<input type="hidden" id="st_po_no" name="st_po_no"  value="<%=po_no%>">
	<input type="hidden" id="st_po_seq" name="st_po_seq"  value="<%=po_seq%>">
	<input type="hidden" id="st_buyer_name" name="st_buyer_name"  value="<%=buyer_name%>">
	<input type="hidden" id="st_rd_date" name="st_rd_date"  value="<%=rd_date%>">
	
	<input type="hidden" id="st_user_id" name="st_user_id"  value="${sessionInfo.userId}">
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다 / 500*500-->
	<div id="popWrapper" style="height:494px;">
    	<div id="popHeader">
        	<h1 class="title">합의이력 관리</h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/b_btn_popclose.gif" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer">
			<!--조회영역-->
			<table class="cont_t_list02"  style="width:100%">
				<caption>합의이력관리</caption>
				<colgroup>
					<col width="20%" />
					<col width="30%" /> 
					<col width="20%" /> 
					<col width="*" /> 
				</colgroup>
				<tbody>
					<tr>
						<th style="text-align:left;">&nbsp;&nbsp;고객사명</th>
						<td class="left">&nbsp;<%=buyer_name%></td>
						<th style="text-align:left;">&nbsp;&nbsp;발주번호</th>
						<td class="left">&nbsp;<%=po_no%></td>
					</tr>
				</tbody>
			</table>
			
			<!--저장영역-->
			<table class="cont_t_list06" style="width:100%">
				<tr>
					<th>협력사담당자</th>
					<td> 
						<input type="text" name="st_supplier_user_name" id="st_supplier_user_name" style="width:93%;" value="" class="input_type_text"> 
					</td>
					<th>납품합의일</th>
					<td>
						<input type="text" name="st_approval_rd_date_cal" id="st_approval_rd_date_cal" size="10" value="" class="input_type_text"  readonly>
						<input type="hidden" name="st_approval_rd_date" id="st_approval_rd_date" value="">
					</td>
					<th>납기요청일</th>
					<td>
						<%=CommonUtil.formatStrinigDate(rd_date)%>
					</td>
				</tr>
				<tr>
					<th>사유코드</th>
					<td width="105px" style="text-align:left;"  class="am mt02">
						<select id="st_reason_code" name="st_reason_code" style="width:100px;" onChange="javascript:setReasonRemark();">
							<!-- <option value=""></option>
							<option value="재고부족">재고부족</option>
							<option value="생산지연">생산지연</option>
							<option value="수입지연">수입지연</option>
							<option value="단가부적합">단가부적합</option>
							<option value="단순수주접수지연">단순수주접수지연</option>
							<option value="기타">기타</option>
							 -->
						</select>
					</td>
					<th>기타사유</th>
					<td>
						<input type="text" id="st_reason_remark" name="st_reason_remark"  class="input_type_text" style="width:93%;" disabled="disabled">
					</td>
					<td colspan="2">
						<div class="fl">
						<!-- _mailYn Y: 체크버튼 visible true, N: visible false -->
					<% 
						if(!_mailYn.equals("N")){
					%>
							<input type="checkbox" id="st_mail_chk" name="st_mail_chk" value="Y" visible="false" checked="checked"> 메일전송</checkbox>
					<% 
						}
					%>
						</div>
						<div class="fr">
							<span class="btn_02"><a href="javascript:setAgrmntDetail();">저장</a></span>
						</div>
					</td>
				</tr>
			</table>
			
			<h3>납품합의 이력</h3>
			
           	<!--grid-->
            <div class="scrollArea" style="height:338px">
                <table  class="cont_t_list02"  style="width:100%">
                    <caption>납품합의 이력 리스트</caption>
                    <colgroup>
                    	<col width="6%" />
                        <col width="10%" />
                        <col width="10%" />
                        <col width="12%" />
                        <col width="12%" />
                        <col width="*" />
                        <col width="12%" />
                        <col width="12%" /> 
                    </colgroup>
                    <thead>
                        <tr>
                            <th scope="col">순번</th> 
                            <th scope="col">KeP담당자</th> 
                            <th scope="col">협력사담당자</th>
                            <th scope="col">납품합의일</th>
                            <th scope="col">사유코드</th>
                            <th scope="col">기타사유</th>
                            <th scope="col">처리일시</th>
                            <th scope="col">처리자</th> 
                        </tr>
                    </thead>
                    <tbody>
				<%
					if (_dataList == null || _dataList.size() == 0){
				%>
               		<tr bgcolor="#FFFFFF">
                        <td colspan="8" align="center" height = "50">
                        <span class="font1">조회된 데이타가 없습니다.</span>
                        </td> 
                    </tr>
				<%	} else {
						for (int j=0; j<_dataList.size(); j++) {
							Map<String,String> _tmp = _dataList.get(j);
				%>
							<tr>
								<td><%=j+1%></td>
								<td><%=_tmp.get("KEP_USER_NAME")%></td>
								<td><%=_tmp.get("SUPPLIER_USER_NAME")%></td>
								<td><%=CommonUtil.formatStrinigDate(_tmp.get("APPROVAL_RD_DATE"))%></td>
								<td class="left"><%=_tmp.get("REASON_CODE")%></td>
								<td class="left"><%=_tmp.get("REASON_REMARK")%></td>
								<td><%=CommonUtil.formatStrinigDate(_tmp.get("CREATE_DATE"))%></td>
								<td><%=_tmp.get("KEP_USER_ID")%></td>
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
