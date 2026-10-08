<%--
**********************************************
* 메뉴 : 구매대행>카탈로그>판촉물 전용 카탈로그 > 인기검색어
* 화면 : 인기검색어
* 기능 : 
* 프로그램 ID : PG_03_M_009_00
* 담당자 : 카탈개 ( 설계 : 권우재 )
* 착수일 : 2014-
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8"	pageEncoding="utf-8" isELIgnored="false"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/include/head.jspf"  %>

<script src="/resources/js/common.js"></script>
<script>
	
	// 시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
	function kep_onload_view() {
		
		doAction("search");
		
	}	
		
	// 기능함수
	function doAction(str) {
		
		switch (str) {
		case "search":	 // 조회
			kepAjaxFormCall("/mdcm/getMasterMdCmPopularKeywordList.do","searchCondition","btnSearch");
			break;
		
		case "save": // 저장

			if (confirm("인기검색어를 등록/수정 하시겠습니까?")){

				var key_word1 = $("#st_key_word1").val();
				var key_word2 = $("#st_key_word1").val();
				var key_word3 = $("#st_key_word1").val();
				var key_word4 = $("#st_key_word1").val();
				var key_word5 = $("#st_key_word1").val();
				var key_word6 = $("#st_key_word1").val();
				var key_word7 = $("#st_key_word1").val();
				var key_word8 = $("#st_key_word1").val();
				var key_word9 = $("#st_key_word1").val();
				var key_word10 = $("#st_key_word1").val();
				var key_word11 = $("#st_key_word1").val();
				var key_word12 = $("#st_key_word1").val();
				var key_word13 = $("#st_key_word1").val();
				var key_word14 = $("#st_key_word1").val();
				var key_word15 = $("#st_key_word1").val();

				if(!(key_word1 == "" && key_word2 == "" && key_word3 == "" && key_word4 == "" && key_word5 == "" && key_word6 == "" && key_word7 == "" && key_word8 == "" && key_word9 == "" && key_word10 == "" && key_word11 == "" && key_word12 == "" && key_word13 == "" && key_word14 == "" && key_word15 == ""))
				{
					kepAjaxFormCall("/mdcm/saveMasterMdCmPopularKeywordList.do","searchCondition","btnSave");
					
				} else {
					alert(" 인기 검색어는 총 15가지를 모두 입력하셔야 합니다.");
					return;
				}
				
				
			}
			break;
		}
	}
		

	//ajax 공통 호출후 성공시 처리 함수
	function kepAjaxSuccess(pMethod , response){
		
		if(pMethod == "btnSearch"){
			var data = response.data;
			
			if(data != null){
				
				var changeDate = data.CHANGE_DATE;
				var changeTime = data.CHANGE_TIME;
				
				var date = changeDate.substring(0,4) + "년 " + changeDate.substring(4,6) + "월 " + changeDate.substring(6,8)+"일";
				var time = changeTime.substring(0,2) + "시 " + changeTime.substring(2,4) + "분 " + changeTime.substring(4,6)+"초";
				
				
				$("#st_change_date").text(date);
				$("#st_change_time").text(time);
				$("#st_change_user_id").text(data.CHANGE_USER_ID);
				
				$("#st_key_word1").val(data.KEY_WORD1);
				$("#st_key_word2").val(data.KEY_WORD2);
				$("#st_key_word3").val(data.KEY_WORD3);
				$("#st_key_word4").val(data.KEY_WORD4);
				$("#st_key_word5").val(data.KEY_WORD5);
				$("#st_key_word6").val(data.KEY_WORD6);
				$("#st_key_word7").val(data.KEY_WORD7);
				$("#st_key_word8").val(data.KEY_WORD8);
				$("#st_key_word9").val(data.KEY_WORD9);
				$("#st_key_word10").val(data.KEY_WORD10);
				$("#st_key_word11").val(data.KEY_WORD11);
				$("#st_key_word12").val(data.KEY_WORD12);
				$("#st_key_word13").val(data.KEY_WORD13);
				$("#st_key_word14").val(data.KEY_WORD14);
				$("#st_key_word15").val(data.KEY_WORD15);
				
				$("#st_gbn_ins_up").val("update");
				
			} else {
				var date = new Date();
				
				var curDate = date.getFullYear() + "년 " + (date.getMonth()+1) + "월 " + date.getDate() + "일";
				var curTime = date.getHours() + "시 " + date.getMinutes() + "분 " + date.getSeconds() + "초";
				
				$("#st_change_date").text(curDate);
				$("#st_change_time").text(curTime);
				$("#st_change_user_id").text($("#st_user_id").val());
				
				$("#st_gbn_ins_up").val("insert");
			}
			

		} else if(pMethod == "btnSave"){
			alert("정상 등록 되었습니다.");
			doAction("search");
			
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
<body onload="kep_onload_view()">
	<!--내용 시작-->
<div id="ContArea">
	<form id = "searchCondition" name = "searchCondition" method = "post">
		<div id="searchBtnA">
			<!--HIDDEN-->
			<!-- 공통 -->
			<input type="hidden" name="s_SAVENAME">
			<input type="hidden" id="pageflag" name="pageflag" value="1">
			<!-- 화면 내 정의 -->
			<input type="hidden" id="st_gbn_ins_up" name="st_gbn_ins_up" value="" />
			<input type="hidden" id="st_user_id" name="st_user_id"  value="${sessionInfo.userId}" />
			
			<table  class="cont_t_list06" >
				<caption>인기검색어</caption>
				<colgroup>
					<col width="8%" />
					<col width="25%" />
					<col width="8%" />
					<col width="25%" />
					<col width="8%" />
					<col width="25%" />
				</colgroup>
				<tbody>
					<tr height="30">
						<th>최종수정일</th>
						<td>
							<span id="st_change_date"></span>
						</td>
						<th>최종수정시간</th>
						<td>
							<span id="st_change_time"></span>
						</td>
						<th>최종수정자</th>
						<td>
							${sessionInfo.userNameLoc}(ID: <span id="st_change_user_id"></span>)
						</td>
					</tr>
					<tr>
						<th>검색어1</th>
						<td>
							<input type="text" id="st_key_word1" name="st_key_word1" class="input_type_text" style="width:80%;" value="" />
						</td>
						<th>검색어2</th>
						<td>
							<input type="text" id="st_key_word2" name="st_key_word2" class="input_type_text" style="width:80%;" value="" />
						</td>
						<th>검색어3</th>
						<td>
							<input type="text" id="st_key_word3" name="st_key_word3" class="input_type_text" style="width:80%;" value="" />
						</td>
					</tr>
					<tr>
						<th>검색어4</th>
						<td>
							<input type="text" id="st_key_word4" name="st_key_word4" class="input_type_text" style="width:80%;" value="" />
						</td>
						<th>검색어5</th>
						<td>
							<input type="text" id="st_key_word5" name="st_key_word5" class="input_type_text" style="width:80%;" value="" />
						</td>
						<th>검색어6</th>
						<td>
							<input type="text" id="st_key_word6" name="st_key_word6" class="input_type_text" style="width:80%;" value="" />
						</td>
					</tr>
					<tr>
						<th>검색어7</th>
						<td>
							<input type="text" id="st_key_word7" name="st_key_word7" class="input_type_text" style="width:80%;" value="" />
						</td>
						<th>검색어8</th>
						<td>
							<input type="text" id="st_key_word8" name="st_key_word8" class="input_type_text" style="width:80%;" value="" />
						</td>
						<th>검색어9</th>
						<td>
							<input type="text" id="st_key_word9" name="st_key_word9" class="input_type_text" style="width:80%;" value="" />
						</td>
					</tr>
					<tr>
						<th>검색어10</th>
						<td>
							<input type="text" id="st_key_word10" name="st_key_word10" class="input_type_text" style="width:80%;" value="" />
						</td>
						<th>검색어11</th>
						<td>
							<input type="text" id="st_key_word11" name="st_key_word11" class="input_type_text" style="width:80%;" value="" />
						</td>
						<th>검색어12</th>
						<td>
							<input type="text" id="st_key_word12" name="st_key_word12" class="input_type_text" style="width:80%;" value="" />
						</td>
					</tr>
					<tr>
						<th>검색어13</th>
						<td>
							<input type="text" id="st_key_word13" name="st_key_word13" class="input_type_text" style="width:80%;" value="" />
						</td>
						<th>검색어14</th>
						<td>
							<input type="text" id="st_key_word14" name="st_key_word14" class="input_type_text" style="width:80%;" value="" />
						</td>
						<th>검색어15</th>
						<td>
							<input type="text" id="st_key_word15" name="st_key_word15" class="input_type_text" style="width:80%;" value="" />
						</td>
					</tr>
				</tbody>
			</table>
		
			<!--버튼영역-->
			<div class="btnArea">
				<span class="fr">
					<span class="btn_02 mr04"><a href="javascript:doAction('save');">저장</a></span>
				</span>
			</div>
		</div>
	</form>
</div>
<!--내용 종료-->
</body>
</html>
