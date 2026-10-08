<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%
@SuppressWarnings (value="unchecked")
List<Map<String,String>> _dataList = (List<Map<String,String>>) request.getAttribute("data");
String st_buyer = CommonUtil.nvl((String) request.getParameter("st_buyer"),"");
String st_user_name = CommonUtil.nvl((String) request.getParameter("st_user_name"),"");
String total_cnt = CommonUtil.nvlObj((List<Map<String,String>>) _dataList ,"0");
String curPage = CommonUtil.nvl((String) request.getParameter("curPage"),"1");
String onepagerow = CommonUtil.nvl((String) request.getParameter("onepagerow"), "10");
%>
<!doctype html>
<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=Edge;" />
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>KeP 담당자 찾기</title>
<link rel="stylesheet" type="text/css" href="/resources/css/base.css" />
<link rel="stylesheet" type="text/css" href="/resources/css/main_com.css" />
<script type="text/javascript" src="/resources/js/jquery-1.12.4.min.js"></script>
</head>
<body>
<div class="wrapPopup">
  <div class="PopupTit">KeP 담당자 찾기<span><a href="javascript:self.close()"><img src="/resources/imgs/Icon_close.png" /></a></span></div>
  <div class="h15"></div>
  <div class="Importance_Popup" style="width:788px"><img src="/resources/imgs/Icon_Importance01.png" /> 담당자를 검색하여 선택할 수 있습니다.</div>
  <div class="h10"></div>
  <form name="frmSearch" id="frmSearch" method="post">
    <input type="hidden" name="curPage" id="curPage" value="<%=curPage%>" />
    <input type="hidden" name="st_buyer" value="<%=st_buyer%>" />
    <input type="hidden" name="onepagerow" value="<%=onepagerow%>" />
    <div class="SearchPopupInputBox">
      <div class="SearchPopupInput" style="width:798px">
        <input type="text" placeholder="담당자명" id="st_user_name" name="st_user_name" value="<%=st_user_name%>" style="width:85%;" onkeydown="if(event.keyCode==13){doSearch();return false;}" />
        <button type="button" onclick="doSearch()">담당자검색버튼</button>
      </div>
    </div>
  </form>
  <table class="PopTableThCTdL" style="width:800px">
    <colgroup>
      <col width="150px" />
      <col width="150px" />
      <col width="150px" />
      <col width="150px" />
      <col width="200px" />
    </colgroup>
    <tr>
      <th>사용자ID</th>
      <th>사용자명</th>
      <th>부서</th>
      <th>연락처</th>
      <th>이메일</th>
    </tr>
<%
if (_dataList == null || _dataList.size() == 0) {
%>
    <tr>
      <td colspan="5" align="center" style="height:200px;">조회된 데이터가 없습니다.</td>
    </tr>
<%
} else {
  for (int j = 0; j < _dataList.size(); j++) {
    Map<String,String> row = _dataList.get(j);
%>
    <tr style="cursor:pointer" onclick="setReturn('<%=row.get("USER_ID")%>','<%=row.get("USER_NAME_LOC")%>','<%=row.get("PHONE_NUMBER")%>','<%=row.get("EMAIL")%>','<%=row.get("DEPARTMENT")%>','<%=row.get("DEPT_NAME")%>','<%=row.get("ADDRESS_LOC")%>','<%=row.get("FAX_NUMBER")%>')">
      <td align="center"><%=CommonUtil.nvl(row.get("USER_ID"))%></td>
      <td align="center"><%=CommonUtil.nvl(row.get("USER_NAME_LOC"))%></td>
      <td align="center"><%=CommonUtil.nvl(row.get("DEPT_NAME"))%></td>
      <td align="center"><%=CommonUtil.nvl(row.get("PHONE_NUMBER"))%></td>
      <td><%=CommonUtil.nvl(row.get("EMAIL"))%></td>
    </tr>
<%
  }
}
%>
  </table>
  <p class="paging">
    <%=CommonUtil.getPageView("doSearchPage", total_cnt, curPage, onepagerow)%>
  </p>
</div>

<script type="text/javascript">
function doSearch() {
  $("#curPage").val("1");
  $("#frmSearch").attr("action", "/mdcp/getMasterMdCpUserChoicePop_v2.do").submit();
}

function doSearchPage(page) {
  $("#curPage").val(page);
  $("#frmSearch").attr("action", "/mdcp/getMasterMdCpUserChoicePop_v2.do").submit();
}

function setReturn(user_id, user_name_loc, phone_number, email, department, dept_name, address_loc, fax_number) {
  opener.setPopupReturn(user_id, user_name_loc, phone_number, email, department, dept_name, address_loc, fax_number);
  self.close();
}
</script>
</body>
</html>
