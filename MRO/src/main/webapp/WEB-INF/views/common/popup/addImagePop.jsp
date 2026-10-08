<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%> 
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<!doctype html>
<html>
<head>
<%@ include file="../../common/include/head_pop.jspf"  %>
</head>
<%
	String st_buyer			= request.getParameter("st_buyer");
	String st_quotation_no		= request.getParameter("st_quotation_no");
	String st_quotation_seq	= request.getParameter("st_quotation_seq");
	String st_revision			= request.getParameter("st_revision");
	String st_agent_revision			= request.getParameter("st_agent_revision");
	String st_agent			= request.getParameter("st_agent");
	String mod_yn			= request.getParameter("mod_yn");
	String st_type			= request.getParameter("st_type");
	String st_imgfile_dir		= request.getParameter("st_imgfile_dir");
	String st_imgfile_name	= request.getParameter("st_imgfile_name");
	String st_buyer_item_no= request.getParameter("st_buyer_item_no");


%>
<script type="text/javascript">
//이미지 미리보기
function preview_new(img,the_img,img_no) {
	$("#image1").attr("src","");
	var dest    = document.getElementById("image1");
     dest.src = img;
}
function setImageView(img_dr,img_name){
	if(img_name == "icon_emptyimg.gif"){
		alert("등록된 이미지가 없습니다.");
		return;		
	}else{
		window.open('<%= CommonUtil.getURL(request) %>'+img_dr+ img_name,'catalogImage','status=no,resizable=yes,menubar=no,scrollbars=no,"","",width=550,height=550');	
	}
	
}
//이미지등록
function kepAddImage(){
	var fileName = $("#files").val();
	if (fileName == ""){
		alert("이미지를 선택하세요.");
		return;
	} 	
	
	var dot = fileName.lastIndexOf(".");
	var ext = fileName.substring(dot).toLowerCase();
	if (ext != ".jpg" && ext != ".jpeg" && ext != ".gif" && ext != ".png"){
		alert("이미지 업로드 할 수 없는 확장자 입니다.");
		return;
	}
	document.forms.searchCondition.target = "account_work";
	document.forms.searchCondition.method = "post";
	document.forms.searchCondition.action ="/mprq/addImgRegPop.do";
	document.forms.searchCondition.submit();
 	
}
function upSet(docNo){
	var mg_arr = docNo.split("^");
	alert("이미지가 등록/ 수정되었습니다.");
  	opener.setPopupReturn(mg_arr[0],mg_arr[1]);
	this.close();
	return;
}
</script>  
<body >
	<iframe name="account_work" id="account_work" style="display:none;" scrolling="no" frameborder="0" width="100%" height="100%"></iframe>
	<form name = "searchCondition" id="searchCondition" method = "post" modelAttribute="uploadForm" enctype="multipart/form-data">
	<input type="hidden" id="st_buyer"  name="st_buyer" value="<%=st_buyer%>">
	<input type="hidden" id="st_quotation_no"  name="st_quotation_no" value="<%=st_quotation_no%>">
	<input type="hidden" id="st_quotation_seq"  name="st_quotation_seq" value="<%=st_quotation_seq%>">
	<input type="hidden" id="st_revision"  name="st_revision" value="<%=st_revision%>">
	<input type="hidden" id="st_agent_revision"  name="st_agent_revision" value="<%=st_agent_revision%>">
	<input type="hidden" id="st_agent"  name="st_agent" value="<%=st_agent%>">
	<input type="hidden" id="mod_yn"  name="mod_yn" value="<%=mod_yn%>">
	<input type="hidden" id="st_type"  name="st_type" value="<%=st_type%>">
	<input type="hidden" id="st_imgfile_dir"  name="st_imgfile_dir" value="<%=st_imgfile_dir%>">
	<input type="hidden" id="st_imgfile_name"  name="st_imgfile_name" value="<%=st_imgfile_name%>">
	<input type="hidden" id="st_buyer_item_no"  name="st_buyer_item_no" value="<%=st_buyer_item_no%>">

	<!--최소 가로길이 400px, 최소 세로길이 400px입니다-->
	<div id="popWrapper" style="height:312px; min-height: 100px;">
    	<div id="popHeader">
        	<h1 class="title">이미지 확인/등록</h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/<%=_closeImgSrc %>" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer">
			<table class="cont_t_list05">
				<tr> 
					<td colspan="2">
							<%
                                 if (st_imgfile_name == null || st_imgfile_name.equals("null") || st_imgfile_name.equals("") || st_imgfile_name.equals(" ")){
							%>
		                		<img src = "/resources/images/icon_emptyimg.gif"  id="image1" name="image1" width="400" height="400">
							<%
                                 }else{
							%>
									<a href="javascript:setImageView('<%=CommonUtil.realImgS3UploadPath+"/"+st_imgfile_dir+"/"%>','<%=st_imgfile_name%>')" >
                                    	<img src = "<%=CommonUtil.realImgS3UploadPath+"/"+st_imgfile_dir+"/"+st_imgfile_name%>"   id="image1" name = "image1" width="400" height="400" border="0">
                                    </a>
							<%
                                 }
							%>	
		                	<br>
		                	<%if(mod_yn.equals("Y")){ %>
								<input name="files" id="files" type="file" size="25" style="height:25px" onChange="preview_new(this.value,'up_img1');" value="<%=st_imgfile_name %>;">
								<span class="btn_search"><a href="javascript:kepAddImage();">등록/수정</a></span>
							<%} %>
					</td>
				</tr>
			</table>        
             <table class="cont_t_list05">
                <tr> 
             		<th width="21%">※ 주의사항</th>
						<td align="center" height="90">
					         ① 품목이미지 첨부 시 500*500 사이즈의 이미지 등록 바랍니다.<br>
					         ② 하얀 바탕의 사진 첨부 등록 바랍니다.<br>
					         ③ 사진 내 품목 이외의 워터마크, 출처, 기타품목을 혼용하지 마시기 바랍니다.<br>
					         <b><font color="blue">④ 제품의 도면, MSDS 및 기타 자료는 파일로 첨부 바랍니다.</font></b><br>
					         <b><font color="red">⑤ 제품의 상세 도면은 이미지로 등록이 불가합니다.</font></b><br>
					         ⑥ 해상도가 낮거나 흐릿한 이미지는 등록이 불가합니다.<br>
					         ⑦ 제품 이미지가 가운데 위치하도록 편집하여 등록 바랍니다.<br>
						</td>
                </tr>
            </table>
        </div>
    </div>    
    </form>
</body>
</html>
