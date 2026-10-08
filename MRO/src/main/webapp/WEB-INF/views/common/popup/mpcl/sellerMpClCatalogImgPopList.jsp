<%--
**********************************************
* 메뉴 : 
* 화면 : 이미지등록요청 리스트
* 기능 : 이미지등록요청 리스트
* 프로그램 ID : 
* 담당자 : 현
* 착수일 : 
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../../common/include/head.jspf"  %>

<%
	@SuppressWarnings (value="unchecked")

	String user_id      = _sessionInfo.getUserId();
	String com_code =  CommonUtil.nvl((String) request.getParameter("com_code"), _sessionInfo.getComCode());
	String p_buyer = CommonUtil.nvl((String) request.getParameter("st_buyer"),"");  //  (조회조건)
	String p_po_no = CommonUtil.nvl((String) request.getParameter("st_po_no"),"");  //  (조회조건)
	
	
	List<Map<String, String>> detailList = (List<Map<String, String>>) request.getAttribute("detailList"); // 조회결과 - 상세 리스트
	
	
	int page_display_cnt = 0;
	
	// 발주서인쇄, 납부지시서 이벤트 시 사용
	String buyer_tr = "";
	String seller = "";
	String ref_if_no = "";
	String add_user_id = "";
	String agent_code = "";

%>
<script type="text/javascript"> 
 

//ajax 공통 호출후 성공시 처리 함수
function kepAjaxSuccess(pMethod , response){
	var msg = response.msg;
	
	if (isEmpty(msg)){
		alert("수주 접수가 정상적으로 이루어 졌습니다.\n\n입력하신 날짜에 납품이 가능도록 하여 주시기 바랍니다.");
		opener.kepSearch(1);
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
function setImageView(img_dr,img_name,gbn){

	window.open('<%= CommonUtil.getURL(request) %>'+img_dr+ img_name,'catalogImage','status=no,resizable=yes,menubar=no,scrollbars=no,"","",width=550,height=550');
	
}
</script> 
</head>

<body>
<form name = "contentForm" id="contentForm" method = "post">
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다 / 500*500-->
	<div id="popWrapper" style="height:600px;">
    	<div id="popHeader">
        	<h1 class="title">이미지 등록 요청 리스트</h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/s_btn_popclose.gif" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer">
           	<!--grid-->
            <div class="scrollArea" style="height:500px">
                <table  class="cont_t_list04"  style="width:100%">
                    <caption>상품이미지 등록 요청 리스트</caption>
                    <colgroup>
                        <col width="10%" />
                        <col width="5%" /> 
                        <col width="10%" />
                        <col width="10%" />                        
                        <col width="12%" />
                        <col width="10%" />
                        <col width="12%" />
                        <col width="10%" /> 
                        <col width="*" /> 
                    </colgroup>
                    <thead>
                        <tr>
                            <th scope="col">요청번호</th> 
                            <th scope="col">상태</th>
                            <th scope="col">상품이미지</th>
                            <th scope="col">상세이미지</th>                            
 							<th scope="col">요청일</th>
 							<th scope="col">요청자</th>
 							<th scope="col">처리일</th>
 							<th scope="col">처리자</th>
 							<th scope="col">비고</th>
                        </tr>
                    </thead>
                    <tbody>
					<%
					if (detailList == null || detailList.size() == 0){
					%>
	               		<tr bgcolor="#FFFFFF">
	                        <td colspan="8" align="center" height = "280">
	                        <span class="font1">조회된 데이타가 없습니다.</span>
	                        </td> 
	                    </tr>
					<%
					}else{
						for (int j=0; j<detailList.size(); j++) {
							page_display_cnt++;
							
							Map<String,String> rowData = detailList.get(j);
							String  tclass = (j % 2 != 0)? "#FFFFFF" : "#FAFAFA";
					%> 
                        <tr bgcolor="<%=tclass%>">
							<td>
								<!-- 요청번호 -->
							 	<%=CommonUtil.nvl(rowData.get("IMG_REQ_NO"))%>
							</td>
							<td class="center">
								<!-- 상태 -->
							 	<%=CommonUtil.nvl(rowData.get("STATUS_NM"))%>
							</td>
							<td class="center" title="상품이미지">
								<%
									if("".equals(CommonUtil.nvl(rowData.get("IMGFILE_DIR")))){
								%>
									<img src="/resources/images/noimage.gif" width="80" height="80" border="0">
								<%
									}else{
								%>
									<a class="hyperLink"  href="javascript:setImageView('<%=CommonUtil.realImgS3UploadPath+"/"+CommonUtil.nvl(rowData.get("IMGFILE_DIR"))+"/"%>','<%=CommonUtil.nvl(rowData.get("IMGFILE_NAME"))%>','A');">
										<img src="<%=CommonUtil.realImgS3UploadPath+"/"+CommonUtil.nvl(rowData.get("IMGFILE_DIR"))+"/"+CommonUtil.nvl(rowData.get("IMGFILE_NAME"))%>"  onerror="javasrcipt:this.src='/resources/images/noimage.gif'"  name="image1" width="80" height="80" border="0">
									</a>
								<%
									}
								%>
							</td>
							<td title="상품상세이미지">
							<%
								if("".equals(CommonUtil.nvl(rowData.get("DETAIL_IMGFILE_DIR")))){
							%>
								<img src="/resources/images/noimage.gif" width="80" height="80" border="0">
							<%
								}else{
							%>
								<a class="hyperLink"  href="javascript:setImageView('<%=CommonUtil.realImgS3UploadPath+"/"+CommonUtil.nvl(rowData.get("DETAIL_IMGFILE_DIR"))+"/"%>','<%=CommonUtil.nvl(rowData.get("DETAIL_IMGFILE_NAME"))%>','B');">
									<img src="<%=CommonUtil.realImgS3UploadPath+"/"+CommonUtil.nvl(rowData.get("DETAIL_IMGFILE_DIR"))+"/"+CommonUtil.nvl(rowData.get("DETAIL_IMGFILE_NAME"))%>"  onerror="javasrcipt:this.src='/resources/images/noimage.gif'"  name="image1" width="80" height="80" border="0">
								</a>
							<%
								}
							%>										
							</td>
							<td>
								<!-- 요청일 -->
							 	<%=CommonUtil.formatStrinigDate(rowData.get("ADD_DATE"))%>
							</td>
							<td>
								<!-- 요청자 -->
							 	<%=CommonUtil.nvl(rowData.get("ADD_USER_LOC"))%>
							</td>
							<td>
								<!-- 처리일 -->
							 	<%=CommonUtil.formatStrinigDate(rowData.get("CONFIRM_DATE"))%>
							</td>
							<td>
								<!-- 처리자 -->
							 	<%=CommonUtil.nvl(rowData.get("CONFIRM_NAME_LOC"))%>
							</td>
							<td>
								<!-- 비고 -->
							 	<%=CommonUtil.nvl(rowData.get("REMARK"))%>
							</td>
                        </tr> 
					<%
						}
					}
					%>
  
                    </tbody>
                </table>                  
                <input type="hidden" id="display_item_cnt" name="display_item_cnt"    value="<%=page_display_cnt%>">
        </div>
    </div>        
</div>
</form> 
</body>
</html>
