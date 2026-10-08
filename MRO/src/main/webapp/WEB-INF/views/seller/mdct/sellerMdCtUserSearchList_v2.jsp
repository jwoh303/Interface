<%--
**********************************************
* 메뉴 : 마스터관리>사용자조회
* 화면 : 사용자조회(판매사)
* 기능 : 협력사의 등록된 사용자 목록 조회하고 삭제한다
* 프로그램 ID : SM0204001
* 담당자 :
* 착수일 : 2025-01-24
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/include/head_v2.jspf" %>
<!-- IBSheet 래퍼 (IBSheet 로드 후에 와야 함) -->
<script src="/resources/js/common/IBSheetWrapper.js" type="text/javascript"></script>

<!-- HttpUtil (리뉴얼 - AJAX 통신) -->
<script src="/resources/js/common/HttpUtil.js" type="text/javascript"></script>

<!-- PopupUtil (리뉴얼 - 범용 팝업 유틸리티) -->
<script src="/resources/js/common/PopupUtil.js" type="text/javascript"></script>
</head>
<%
	String com_code = _sessionInfo.getComCode();
	String menuId = (String) request.getParameter("menuId");
	String currentUserId = _sessionInfo.getUserId(); // 현재 로그인한 사용자 ID

	if(myMenuListHeader != null){ //null이 아닌 경우에만 체크
		for(int i = 0; i<myMenuListHeader.size(); i++){
			if(myMenuListHeader.get(i).get("MENU_ID").equals(menuId)){
				myMenuFlag = true;
				break;
			}
		}
	}
%>
<body>
<div id="wrapper">
<!-- 메뉴 S -->
<c:import charEncoding="utf-8" url="/menu/menu.do" >
<c:param name="page" value="sellerHeader_sub_v2"/>
<c:param name="part" value="header_v2"/>
</c:import>
<c:import charEncoding="utf-8" url="/main/leftMenuData.do">
<c:param name="page" value="sellerLeft_v2"/>
</c:import>

<!-- 컨텐츠 -->
	<div class="containerBoxSub">
      <div class="PDleft50"><!--padding-left:50px; 시작 -->
		<div class="SubTit">
          <%if(myMenuFlag) {%>
          <button class="But_Star_on"></button>
     	<%}else{ %>
     	  <button class="But_Star"></button>
     	<%} %> 사용자 관리
          <div class="SummaryGuide">
      	    <ul>
        	  <li><img src="/resources/imgs/Icon_Home.png" /></li>
              <li>회원사관리</li>
              <li>사용자관리</li>
            </ul>
          </div>
        </div>

        <div class="containerSub"><!--margin-right:50px; 설정 -->
          <table class="SearchTable03">
            <colgroup>
              <col width="100px" />
              <col width="300px" />
              <col width="100px" />
              <col width="300px" />
              <col width="*" />
            </colgroup>
			<tr>
			  <th>이름</th>
              <td>
                <input class="input30" style="width:200px" name="st_search_user_name" id="st_search_user_name" type="text" />
			  </td>
              <th>부서명</th>
              <td>
                <!-- 부서 팝업 제거 - 직접 입력으로 변경 -->
                <input class="input30" style="width:200px" name="st_btoa_user_dept_name" id="st_btoa_user_dept_name" type="text" placeholder="부서명 입력" />
                <!-- 부서 팝업 기능 (주석 처리)
                <input type="hidden" id="st_btoa_user_dept_code" name="st_btoa_user_dept_code" value="">
                <form class="SearchBuyer" onSubmit="return false;" style="width:220px">
                  <input type="text" placeholder="부서 선택" id="st_btoa_user_dept_name" name="st_btoa_user_dept_name" style="width:85%;" readonly>
                  <button type="button" class="buyer-search-btn" onclick="doPop('dept', '<%=com_code%>')">부서검색버튼</button>
                </form>
                -->
			  </td>
              <td></td>
            </tr>
          </table>
          <div class="SearchBtnBoxNoTab">
         	<button class="ButSmall_Outline" onclick="resetSearch()">초기화</button>
        	<button class="ButMSmallDarkGray" onclick="searchData()">조회</button>
          </div>
          <div class="ListBtnBox">
            <div class="left"></div>
            <div class="right"><button class="ButOutline_Medium" onclick="deleteUser()">삭제</button></div>
          </div>

          <!--grid-->
          <div class="ib-container">
            <script type="text/javascript">
              createIBSheet("mySheet", "100%", "600px");
            </script>
          </div><!--IBSheet 끝 -->
          <div class="h5"></div>

          <div class="h30"></div>
        </div><!-- containerSub 끝 -->

      </div> <!--padding-left:50px; 끝 -->
    </div><!--containerBoxSub-->

<%@ include file="/WEB-INF/views/common/include/sellerFooter_sub_v2.jsp" %>

<script type="text/javascript">

// ========================================
// 현재 로그인한 사용자 ID (본인 삭제 방지용)
// ========================================
var currentUserId = "<%=currentUserId%>";

// ========================================
// IBSheet 컬럼 정의
// ========================================
var userColumns = [
    {Align:"Center", SaveName:"sStatus", Header:"상태", Type:"Status", Width:0, Edit:false, EditLen:0, Sort:0, Hidden:true},
    {Align:"Center", SaveName:"CHK", Header:"", Type:"CheckBox", Width:100, Edit:true, EditLen:0, Sort:0, Hidden:false},
    {Align:"Center", SaveName:"USER_ID",Cursor:'Pointer',FontColor:'#3a72c7', Header:"ID", Type:"Text", Width:300, Edit:false, EditLen:50, Sort:1, Hidden:false},
    {Align:"Left", SaveName:"USER_NAME_LOC", Header:"성명", Type:"Text", Width:200, Edit:false, EditLen:100, Sort:1, Hidden:false},
    {Align:"Left", SaveName:"DEPT_NAME", Header:"부서", Type:"Text", Width:400, Edit:false, EditLen:100, Sort:1, Hidden:false},
    {Align:"Center", SaveName:"PHONE_NUMBER", Header:"전화번호", Type:"Text", Width:300, Edit:false, EditLen:50, Sort:1, Hidden:false},
    {Align:"Left", SaveName:"EMAIL", Header:"이메일", Type:"Text", Width:300, Edit:false, EditLen:200, Sort:1, Hidden:false},
    {Align:"Center", SaveName:"DEPARTMENT", Header:"부서코드", Type:"Text", Width:0, Edit:false, EditLen:50, Sort:0, Hidden:true}
];

// ========================================
// IBSheetWrapper 초기화 (리뉴얼)
// ========================================
var userSheet = new IBSheetWrapper("mySheet", "사용자조회");
userSheet.initialize(userColumns);

// USER_ID 컬럼 클릭 이벤트 등록 (IBSheetWrapper 방식)
userSheet.setOnClick('USER_ID', function(row, col, value) {
    showUserDetail(row, col);
});

// ========================================
// 체크박스 동기화 이벤트 (헤더 ↔ 개별)
// ========================================
// 개별 체크박스 클릭 시 헤더 체크박스 동기화
userSheet.setOnChange(function(row, col, value) {
    var sheet = this.getSheet();
    var colName = sheet.ColSaveName(col);

    // CHK 컬럼 변경 시에만 동작
    if (colName === 'CHK') {
        syncHeaderCheckbox();
    }
});

// 헤더 체크박스와 개별 체크박스 동기화 함수
function syncHeaderCheckbox() {
    var sheet = userSheet.getSheet();
    var totalRows = sheet.RowCount();

    if (totalRows === 0) return;

    // 모든 행의 체크 상태 확인
    var allChecked = true;
    for (var i = 1; i <= totalRows; i++) {
        if (sheet.GetCellValue(i, "CHK") !== "1") {
            allChecked = false;
            break;
        }
    }

    // 헤더 체크박스 상태 업데이트
    // IBSheet에서는 헤더 체크박스가 자동으로 동기화되지 않으므로
    // 하나라도 해제되면 전체 해제로 간주
    if (!allChecked) {
        // 모든 체크가 안된 경우 헤더도 해제 (시각적 효과)
        sheet.SetHeaderCheck(0, "CHK", 0);
    }
}

// ========================================
// 행 조회 완료 이벤트 등록 (IBSheetWrapper 방식)
// ========================================
// 각 행이 로드될 때마다 호출되어 개인정보 마스킹 적용
userSheet.setOnRowSearchEnd(function(row) {
    // 이메일과 전화번호 가져오기
    var EMAIL = this.getCellValue(row, "EMAIL");
    var PHONE_NUMBER = this.getCellValue(row, "PHONE_NUMBER");

    // 마스킹 처리 후 다시 설정 (이벤트 발생 방지)
    if (EMAIL) {
        var maskedEmail = kepMaskingEmail(EMAIL);
        if (maskedEmail) {
            this.SetCellValue(row, "EMAIL", maskedEmail, {event: 0});
        }
    }

    if (PHONE_NUMBER) {
        var maskedPhone = kepMaskingPhone(PHONE_NUMBER);
        if (maskedPhone) {
            this.SetCellValue(row, "PHONE_NUMBER", maskedPhone, {event: 0});
        }
    }
});

// ========================================
// 화면 진입 시 자동 조회
// ========================================
$(document).ready(function() {
    // 화면 진입 시 자동 조회
    searchData();

    // ========================================
    // 엔터 키로 조회 실행
    // ========================================
    // 이름 입력 필드에서 엔터 키 이벤트
    $("#st_search_user_name").on("keypress", function(e) {
        if (e.which === 13 || e.keyCode === 13) {
            e.preventDefault();
            searchData();
        }
    });

    // 부서명 입력 필드에서 엔터 키 이벤트
    $("#st_btoa_user_dept_name").on("keypress", function(e) {
        if (e.which === 13 || e.keyCode === 13) {
            e.preventDefault();
            searchData();
        }
    });
});

// ========================================
// 데이터 조회 (리뉴얼)
// ========================================
function searchData() {
    var userName = document.getElementById("st_search_user_name") ? document.getElementById("st_search_user_name").value : "";
    var deptName = document.getElementById("st_btoa_user_dept_name") ? document.getElementById("st_btoa_user_dept_name").value : "";

    // 검색 파라미터 구성 (부서명으로 직접 검색)
    var searchParams = "st_search_user_name=" + encodeURIComponent(userName) +
                      "&st_btoa_user_dept_name=" + encodeURIComponent(deptName);

    console.log("[사용자조회] 검색 파라미터:", searchParams);

    // userSheet.DoSearch 호출 (리뉴얼 - v2 엔드포인트 사용, 페이징 없음)
    userSheet.DoSearch("/mdct/getSellerMdCtUserSearchList_v2.do", searchParams);
}

// ========================================
// 초기화 (리뉴얼)
// ========================================
function resetSearch() {
    // 입력 필드 초기화
    if (document.getElementById("st_search_user_name")) document.getElementById("st_search_user_name").value = "";
    if (document.getElementById("st_btoa_user_dept_name")) document.getElementById("st_btoa_user_dept_name").value = "";

    // 시트 데이터 초기화
    if (userSheet) {
        userSheet.removeAll();
    }

    console.log("[사용자조회] 검색 조건 초기화 완료");
}

// ========================================
// 사용자 상세정보 팝업 (리뉴얼)
// ========================================
function showUserDetail(row, col) {
    var sheet = userSheet.getSheet();
    var userId = sheet.GetCellValue(row, "USER_ID");

    console.log("[사용자조회] 상세정보 팝업 열기 - Row:", row, "USER_ID:", userId);

    if (!userId) {
        console.error("[사용자조회] USER_ID가 없습니다");
        return;
    }

    // AJAX로 사용자 상세정보 조회
    console.log("[사용자 상세] 요청 시작 - userId:", userId);

    HttpUtil.get('/mdct/getUserDetailJson.do', { st_user_id: userId }, { showDefaultAlert: false })
    .then(function(response) {
        console.log("[사용자 상세] 서버 응답 전체:", response);
        console.log("[사용자 상세] response.data:", response.data);
        console.log("[사용자 상세] response.data.success:", response.data.success);
        console.log("[사용자 상세] response.data.data:", response.data.data);

        // HttpUtil은 응답을 { data: {...} } 형태로 감싸므로 response.data.success 확인
        var isSuccess = (response.data.success === true || response.data.success === "true");

        console.log("[사용자 상세] isSuccess:", isSuccess);

        if (isSuccess && response.data.data) {
            // PopupUtil을 사용한 팝업 열기 + 데이터 바인딩
            PopupUtil.open({
                url: '/resources/html/common/popup/user_detail.html',
                onInit: function(api) {
                    console.log("[사용자 상세] 팝업 로드 완료, 데이터 바인딩 시작");

                    // 팝업 API의 setUserData 호출 (실제 사용자 데이터는 response.data.data)
                    api.setUserData(response.data.data);
                }
            });
        } else {
            console.error("[사용자 상세] 데이터 조회 실패:", response.data.message);

            PopupUtil.callback(function(api) {
                api.setMessage(response.data.message || '사용자 정보를 가져올 수 없습니다.');
            }).show(PopupUtil.POPUP_URLS.CONFIRM);
        }
    })
    .catch(function(error) {
        console.error("[사용자 상세] 조회 오류:", error);

        PopupUtil.callback(function(api) {
            api.setMessage('사용자 정보 조회 중 오류가 발생했습니다.');
        }).show(PopupUtil.POPUP_URLS.CONFIRM);
    });
}

// ========================================
// 삭제 기능 (리뉴얼)
// ========================================
function deleteUser() {
    var sheet = userSheet.getSheet();

    // 체크된 행 가져오기
    var checkedRows = sheet.FindCheckedRow("CHK");

    if (!checkedRows || checkedRows === "" || checkedRows.split("|").length === 0) {
        PopupUtil.callback(function(api) {
            api.setMessage('삭제할 사용자를 선택하여 주십시요');
        }).show(PopupUtil.POPUP_URLS.CONFIRM);
        return;
    }

    // 체크된 행의 USER_ID 수집
    var userIds = "";
    var rowArray = checkedRows.split("|");
    var containsCurrentUser = false; // 본인 ID 포함 여부

    for (var i = 0; i < rowArray.length; i++) {
        if (rowArray[i] !== "") {
            var rowIdx = parseInt(rowArray[i]);
            var userId = sheet.GetCellValue(rowIdx, "USER_ID");
            if (userId) {
                // 본인 ID가 포함되어 있는지 확인
                if (userId === currentUserId) {
                    containsCurrentUser = true;
                }
                userIds += userId + "|";
            }
        }
    }

    console.log("[사용자조회] 삭제 대상 USER_ID:", userIds);
    console.log("[사용자조회] 본인 ID 포함 여부:", containsCurrentUser);

    // 본인 ID가 포함되어 있으면 삭제 차단
    if (containsCurrentUser) {
        PopupUtil.callback(function(api) {
            api.setMessage('현재 사용 중인 계정은 삭제할 수 없습니다.\n변경이 필요하면 KEP 운영 담당자에게 문의해 주세요.');
        }).show(PopupUtil.POPUP_URLS.CONFIRM);
        return;
    }

    // 삭제 확인 팝업
    PopupUtil.callback(function(api) {
        api.setMessage('한번 삭제된 사용자 정보는 복구할 수 없습니다. 계속하시겠습니까?');
        api.onConfirm(function() {
            // 확인 버튼 클릭 시 삭제 실행
            executeDelete(userIds);
        });
    }).show(PopupUtil.POPUP_URLS.CONFIRM);
}

// ========================================
// 삭제 실행 함수
// ========================================
function executeDelete(userIds) {
    var params = {
        st_checked_id: userIds
    };

    console.log("[사용자조회] 삭제 요청 파라미터:", params);

    HttpUtil.post('/mdct/deleteSellerMdCtUserSearchList.do', params, {
        showDefaultAlert: false
    })
    .then(function(response) {
        console.log("[사용자조회] 삭제 성공:", response);

        // 삭제 후 즉시 데이터 재조회
        searchData();

        PopupUtil.callback(function(api) {
            api.setMessage('선택한 사용자가 삭제되었습니다.');
        }).show(PopupUtil.POPUP_URLS.CONFIRM);
    })
    .catch(function(error) {
        console.error("[사용자조회] 삭제 실패:", error);

        PopupUtil.callback(function(api) {
            api.setMessage('사용자 삭제 중 오류가 발생했습니다.');
        }).show(PopupUtil.POPUP_URLS.CONFIRM);
    });
}

/* ========================================
 * 부서 검색 팝업 기능 (주석 처리 - 직접 입력으로 변경)
 * ========================================
var popupSel = "";

function doPop(str, val) {
    popupSel = str;
    switch (str) {
        case "dept": // 요청부서
            openSearchPopup("/common/deptCodeAdminPop.do", "?com_code=" + val + "&open=Y", "500,500,no");
            break;
    }
}

function setPopupReturn(code, text) {
    console.log("[부서 선택 완료] code:", code, "text:", text);

    if (popupSel == "dept") {
        // 부서 코드와 이름 설정
        if (document.getElementById("st_btoa_user_dept_code")) {
            document.getElementById("st_btoa_user_dept_code").value = code;
        }
        if (document.getElementById("st_btoa_user_dept_name")) {
            document.getElementById("st_btoa_user_dept_name").value = text;
        }
    }
}
*/

</script>

</body>
</html>
