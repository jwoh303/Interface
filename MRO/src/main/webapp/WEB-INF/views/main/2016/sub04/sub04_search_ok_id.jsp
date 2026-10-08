<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!doctype html>
<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=Edge;" />
<%
	@SuppressWarnings (value="unchecked")
List<Map<String,String>> _dataList = (List<Map<String,String>>) request.getAttribute("idData"); // 조회된 결과
%>
</head>
<body>
	<div class="wrap">
		<!-----------------------------------------------------------------------------------------------header------------------------------------------------------------------------------------------------------->
		<%@ include file="/WEB-INF/views/common/include/2016/mainHeader.jsp"%>
		<!-----------------------------------------------------------------------------------------------header------------------------------------------------------------------------------------------------------->
		<!--컨텐츠-->
		<form id="id_some_find" name="id_some_find" method="post">
			<div class="subcontentsArea">
				<div class="subbanner">
					<div class="subbannerimg">
						<img src="img_2016/SB22.jpg" />
					</div>
					<div class="subbannertxt">
						<p class="sbtit">아이디 찾기</p>
						<p>KeP서비스 이용을 통해 경쟁력을 높여 보세요</p>
					</div>
					<div class="subbannerbg"></div>
				</div>
				<div class="subcontent">
					<div class="sub04_join">
						<p class="subcontentTit">아이디 확인</p>
						<div class="idpwSearch" style="height: 360px">
							<br />
							<br /> 입력하신 정보에 따른 일부 아이디정보입니다. <br /> <br />
							<br />
							<%
								Map<String,String> _rowData = null;
							if (_dataList != null && _dataList.size() != 0) {
								for(int i=0; i<_dataList.size(); i++){
									_rowData = _dataList.get(i);
									String id = _rowData.get("USER_ID");
									
									int f_len = id.length();
									int h_len = Math.round(f_len/2);  

									String h_id = id.substring(0,(f_len-h_len));
									for(int j=0; j<h_len; j++){
								h_id+="*";
									}
							%>
							<p style="line-height: 10px; color: #ee3212; font-weight: bold">
								<%=h_id%></p>
							<br /> 
							<%
								}
							}
							%>
							<%
								if (_dataList != null && _dataList.size() > 0){
							%>
							<input type="hidden" name="display_item_cnt" id="display_item_cnt" value="<%=_dataList.size()%>">
							<%
								}
							%>
							※ 개인정보 보호를 위해 끝가지는 *로 표시됩니다.<br /> <br />
							<div class="joinBtn">
								 <a href="javascript:MovePage_2016('<%=httpurl%>','04', '04');">비밀번호 확인</a>
							</div>
						</div>
					</div>
				</div>
			</div>
			<!--컨텐츠 끝-->
			<!------------------------------------------------------------------------------------------------footer-------------------------------------------------------------------------------------------------------------->
			<%@ include file="/WEB-INF/views/common/include/2016/mainFooter.jsp"%>
			<!------------------------------------------------------------------------------------------------footer-------------------------------------------------------------------------------------------------------------->
	</div>
	</form>
</body>
<script type="text/javascript">
var chkIdx;
function radioCheck() {
	var val = 0;
	var frm = document.id_some_find; 
	chkIdx = 0;
	var tot_cnt         = $("#display_item_cnt").val();
	if(tot_cnt < 2){
		if(frm.ch_id.checked == true) {
			val = frm.ch_id.value;
			$("#p_num").val(frm.ch_phone.value);
			$("#st_user_id").val(frm.ch_user_id.value);
			chkIdx++;
		}
	}else{
		for(var i = 0; i < frm.ch_id.length; i++) {
			if(frm.ch_id[i].checked == true) {
				val = frm.ch_id[i].value;
				$("#p_num").val(frm.ch_phone[i].value);
				$("#st_user_id").val(frm.ch_user_id[i].value);
				chkIdx++;
			}
		}		
	}

	return val;
}  

function findIdAll(){
	var  c_valer = radioCheck();
	var p_num = $("#p_num").val();
	
	//라디오버튼 선택했는지 확인.
	if(chkIdx == 0){
		alert("확인하려는 아이디를 선택하세요.");
		return;
	}

	if(p_num != "" && p_num.split("-").length ==3 ){
		$("#st_id_no").val(c_valer);
		$('#id_some_find').attr("method", "post");
		$('#id_some_find').attr("action", "<%=sslurl%>/main/sub04/sub04_search_find_end_2016.do");
			$('#id_some_find').submit();

		} else {
			alert("해당 아이디에 등록된 휴대전화번호가 유효하지 않습니다.\n새로 가입하시거나, 고객센타로 문의 바랍니다.");
			return;
		}
	}
</script>
</html>

