<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<!doctype html>
<html>
<head>
<%@ include file="../../common/include/head_pop.jspf"  %>
</head>
<%
@SuppressWarnings (value="unchecked")
List<Map<String,String>> _dataList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된결과   
String DOC_NO = CommonUtil.nvl((String) request.getParameter("DOC_NO"),"");  //  (조회조건)
String TYPE = CommonUtil.nvl((String) request.getParameter("TYPE"),"");  //  (조회조건)
String IMG_YN = CommonUtil.nvl((String) request.getParameter("IMG_YN"),"N");  //  (조회조건) < 이미지 파일이여서 화면에서 보여줄경우 Y , 아니면 N
String DATE_DIR = CommonUtil.nvl((String) request.getParameter("DATE_DIR"),"N");  //  (조회조건) < 하위디렉토리가존재
String BUYER = CommonUtil.nvl((String) request.getParameter("BUYER"),"");  //  (조회조건)
String DOC_NO_UP = CommonUtil.nvl((String) request.getAttribute("DOC_NO_UP"),"");  //  (조회조건)
String INVOICE = CommonUtil.nvl((String) request.getParameter("INVOICE"),"");  //  (조회조건)
if ("".equals(DOC_NO)){
}else{
	DOC_NO_UP = DOC_NO; // 부모화면에서 docno를 넘겼을경우 설정
}
String viewType = CommonUtil.nvl((String) request.getParameter("viewType"),"");  //  (조회조건) R 조회 그외는 등록용
String result = CommonUtil.nvl((String) request.getAttribute("result"),"");


if (_dataList == null || _dataList.size() == 0){
}else{
	Map<String,String> rowData = _dataList.get(0);
	DOC_NO = CommonUtil.bnvl(rowData.get("DOC_NO"));
	DOC_NO_UP = CommonUtil.bnvl(rowData.get("DOC_NO"));
}

boolean cr = true;
if ("R".equals(viewType)) {
	cr = false; // 조회용
}
 
%> 
<script type="text/javascript">
 
 	var submitYn = "";
 	
 	//초기화
	function kepOnload(){
		<% if (!"S".equals(result) ){%>
				$("#DOC_NO").val('<%= DOC_NO%>');
				$("#DOC_NO_UP").val('<%=DOC_NO_UP%>');
				$("#BUYER").val('<%=BUYER%>');
				$("#INVOICE").val('<%=INVOICE%>');
				
				kepSearch();		
		<%} %>
	}
 
	function kepSearch() {
		submitYn = "Y";
		$('#search').attr("action", "/common/getImageFileUploadList.do").submit();
	}

	function kepUpload() {  		 
		submitYn = "Y";
		$('#UploadForm').attr("action", "/common/imageFileUpload.do").submit(); 
	}	

	function kepAddFile() { 
		var fileIndex = $('#fileTable tr').children().length;       
		$('#fileTable').append( '<tr><td scope="row">'+                '   <input type="file" name="files['+ fileIndex +']"  class="input_type_text"  onchange="kepFileExtCheck(this);" />'+                '</td></tr>');    
 	}
	
	function kepdownLoad(value1,value2,value3,fileYn) { 
		
		location.href="/common/download.do?DOC_NO="+value1+"&DOC_SEQ="+value2+"&TYPE="+value3;
		
	}
	
	function kepFileRemove(value1,value2,value3) {  		
		
		if (confirm("삭제하시겠습니까?")==false) return;
		
		$('#D_DOC_NO').val(value1);
		$('#D_DOC_SEQ').val(value2);		
		$('#D_TYPE').val(value3);		
		
		kepAjaxFormCall("/common/removeFileInfo.do","process","Remove"); 
	}
	
	/**
	 * ajax 공통 호출후 성공시 처리 함수
	 */
	function kepAjaxSuccess(pMethod , response){ 
		if (pMethod == "Remove"){
			alert("삭제가 성공적으로 이루어 졌습니다. ");
		} 
		// 처리후 재조회
		kepSearch();
	}

	/**
	 * ajax 공통 호출후 에러시 처리 함수
	 */
	function  kepAjaxError(pMethod , response) { 
		if (pMethod == "Remove"){
			 alert("삭제가 실패하였습니다.\n\n다시 한 번 시도해 주시기 바랍니다.  "); 
		}  
		// 처리후 재조회
		kepSearch();		
	} 

	//팝업 닫기
	function kepConfirm()
	{ 
	<%	
	 if (cr == true){
	%>
		var docNo =  "<%= DOC_NO%>";
		 var value1 = (docNo != '')? docNo : "<%= DOC_NO_UP%>";
		 var value2 =$("#count").val();
		 
		// alert("popup doc_no " +value1);
		 // 첨부파일이 모두 삭제되었으면 IMAGE_KEY = "";
		 if(value2 == 0){
			 value1 = "";
		 }
		 
		 opener.setPopupReturn(value1,(value2>=1)?'on':'off');
	<%
	 }
	%>
	  this.close();
	}
	
	function kepUnload(){
		if (submitYn != "Y"){
			kepConfirm();
		}
	}
	
	
	function kepFileExtCheck(args)
	{  
		banArray = new Array(".gif",".png", ".jpg",".jpeg");    // 걸러낼 확장자를 등록
		banFile = false;
		var file = args.value;
			while (file.indexOf("\\") != -1)
				file = file.slice(file.indexOf("\\") + 1);
				//파일명에 .이 포함되어있을 경우(fileName123.jpg.asp.dll)를 대비하여 마지막 확장자만 추출
				ban = file.substring(file.lastIndexOf('.'),file.length).toLowerCase();    
				for (var i = 0; i < banArray.length; i++) {
					if (banArray[i] == ban) {
						banFile = true;
						break;
					}
				}
		if (banFile == false) {
			alert(ban + " 파일은 첨부할 수 없는 파일입니다.\n스캔한 이미지 파일만 첨부 가능 합니다.");
			UploadForm.reset();
			return;
		}else{ 
		}

	}

</script>  
<body onload="kepOnload()" >

	<!--최소 가로길이 400px, 최소 세로길이 400px입니다-->
	<div id="popWrapper"  style="height:424px; min-height: 100px;">
    	<div id="popHeader">
        	<h1 class="title"><% if (cr==false) { %>배송완료증빙 내려받기<%}else{ %>배송완료 증빙첨부<%} %></h1>
            <p class="popClose"><a href="javascript:kepConfirm()"><img src="/resources/images/<%=_closeImgSrc %>" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer">
             <div id="searchBtnA02">
<!--             	<span class="btn_search"><a href="javascript:kepSearch();">조회</a></span>   -->
            </div>                	 
			<div class="scrollArea mb10" style="height:145px">            	
           	 <form name=search id=search method=post >
				<input id="DOC_NO" name="DOC_NO" type="hidden" value="<%=DOC_NO%>" />
				<input id="DOC_NO_UP" name="DOC_NO_UP" type="hidden" value="<%=DOC_NO_UP%>" />
				<input id="TYPE"  name="TYPE" type="hidden" value="<%=TYPE%>" />
				<input id="viewType" name="viewType" type="hidden" value="<%=viewType%>" />
				<input id="IMG_YN" name="IMG_YN" type="hidden" value="<%=IMG_YN%>" />
				<input id="DATE_DIR" name="DATE_DIR" type="hidden" value="<%=DATE_DIR%>" />
				<input id="BUYER" name="BUYER"  type="hidden" value="<%=BUYER%>" />
				<input id="INVOICE" name="INVOICE"  type="hidden" value="<%=INVOICE%>" />
				
            	<!--grid-->
            	<table   style="width:100%">
            		<tr>
            			<td><font color="red"><% if (cr==false) { %><%}else{ %>※ 반드시 인수자 사인이 들어간 거래명세서를 첨부 바랍니다.<%} %></font></td>
            		</tr>
            	</table>
                <table  class="cont_t_list02"  style="width:100%">
                    <caption>파일첨부</caption>
                    <colgroup>
                        <col width="20%" />  
                        <col width="*" />  
                        <col width="15%" />  
                        <col width="10%" />   
                    </colgroup>		   
                    <thead> 
                        <tr>
                            <th scope="col">순번</th> 
                            <th scope="col">파일명</th>   
                            <th scope="col">사이즈</th>   
                            <th scope="col">삭제</th>   
                        </tr>
                    </thead>
                    <tbody>
<%
if (_dataList == null || _dataList.size() == 0){
%>
               		<tr bgcolor="#FFFFFF">
                        <td colspan="4" align="center" height = "50">
                        <input type="hidden" name="count" id="count"  value="0"> 
                        <span class="font1">조회된 데이타가 없습니다.</span>
                        </td> 
                    </tr>
<%}else{
for (int j=0; j<_dataList.size(); j++) {
	Map<String,String> rowData = _dataList.get(j);
%> 
                        <tr>
						   <td>
						   		<%=(j+1) %>
						   		<input type="hidden" name="count" id="count"  value="<%=_dataList.size()%>"> 
 
						   </td> 
						   	<td><a href="javascript:kepdownLoad('<%=CommonUtil.bnvl(rowData.get("DOC_NO"))%>','<%=CommonUtil.bnvl(rowData.get("DOC_SEQ"))%>','<%=CommonUtil.nvl(rowData.get("TYPE"))%>','<%=CommonUtil.nvl(rowData.get("FILEYN"))%>')"><%=CommonUtil.nvl(rowData.get("SRC_FILE_NAME"))%></a></td>
							<td><%=CommonUtil.bnvl(rowData.get("FILE_SIZE"))%>MB</td>
							<td>
								<%if (cr == true){  %>							
								<a href="javascript:kepFileRemove('<%=CommonUtil.bnvl(rowData.get("DOC_NO"))%>','<%=CommonUtil.bnvl(rowData.get("DOC_SEQ"))%>','<%=CommonUtil.nvl(rowData.get("TYPE"))%>')">삭제</a>
								<%}%>
							</td>
						</tr> 
<% } %>

<%}%>                                   
                    </tbody>
                </table> 
				</form>
              </div> 	 
              
<%
if (cr == true) {
%>	
			<p>파일다중올리기</p>     
<% } %> 
			<div class="scrollArea mb15" style="height:105px">            	
				<form method="post" action="/common/fileUpload.do"  name="UploadForm" id="UploadForm" modelAttribute="uploadForm" enctype="multipart/form-data">     
					<input id="DOC_NO" name="DOC_NO" type="hidden" value="<%=DOC_NO_UP %>" />
					<input id="TYPE"  name="TYPE" type="hidden" value="<%=TYPE%>" />					
					<input id="IMG_YN" name="IMG_YN" type="hidden" value="<%=IMG_YN%>" />
					<input id="DATE_DIR" name="DATE_DIR" type="hidden" value="<%=DATE_DIR%>" />
					<input id="BUYER" name="BUYER" type="hidden" value="<%=BUYER%>" />
					<input id="INVOICE" name="INVOICE" type="hidden" value="<%=INVOICE%>" />
										 
<%
if (cr == true) {
%>
					<table  class="board_write" summary="피일업로드" id="fileTable">
					<caption>피일업로드</caption>
					<colgroup> 
						<col width="*" />
					</colgroup>
					<tbody> 
			    	  <tr> 
							<td scope="row">
							<input name="files[0]" type="file"  class="input_type_text"  onchange="kepFileExtCheck(this);" />
							</td>        
						</tr>        
						<tr>            
							<td scope="row">
							<input name="files[1]" type="file"  class="input_type_text"  onchange="kepFileExtCheck(this);" />
							</td>        
						</tr> 
						<tr>            
							<td scope="row">
							<input name="files[2]" type="file"  class="input_type_text"  onchange="kepFileExtCheck(this);"/>
							</td>        
						</tr> 
					</tbody>   
					</table>
<% } %> 
				</form> 
			</div>			    				
			 <!--버튼영역-->
            <div class="btnArea" style="margin-bottom:0px;"> 
                <!--버튼이 2글자일때 class="btn_02",버튼이 3글자일때 class="btn_03",버튼이 4글자일때 class="btn_04" 글자수와 class숫자가 동일 최대 10글자까지 가능-->
<%
if (cr == true) {
%>
                <span class="btn_04 mr04"><a href="javascript:kepUpload()">업로드</a></span>
                <span class="btn_04 mr04"><a href="javascript:kepAddFile()">행추가</a></span>
                <span class="btn_04"><a href="javascript:kepConfirm()">증빙첨부</a></span>
<% } %>  

            </div>            
			<form method="post"  name="process" id="process"  action="/common/removeFileInfo.do">     
				<input id="DOC_NO" name="DOC_NO" type="hidden" value="<%=DOC_NO %>" />    
				<input id="D_DES_FILE_NAME"  name="D_DES_FILE_NAME" type="hidden" value="" />  
				<input id="D_SRC_FILE_NAME"  name="D_SRC_FILE_NAME" type="hidden" value="" />  
				<input id="D_DOC_NO"  name="D_DOC_NO" type="hidden" value="" />  
				<input id="D_DOC_SEQ"  name="D_DOC_SEQ" type="hidden" value="" />   
				<input id="D_TYPE"  name="D_TYPE" type="hidden" value="" />   
				<input id="IMG_YN" name="IMG_YN" type="hidden" value="<%=IMG_YN%>" />
				<input id="DATE_DIR" name="DATE_DIR" type="hidden" value="<%=DATE_DIR%>" />
			</form>					
		</div>
    </div>         
</body>
</html>
