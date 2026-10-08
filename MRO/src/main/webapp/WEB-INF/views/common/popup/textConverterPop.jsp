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

<script type="text/javascript">
function kep_onload_view(){
}

function converter(flag){
	var text = $("#st_text").val();
	if(flag == "C"){ //대문자
		$("#st_text").val(text.toUpperCase());
	}else{ //소문자
		$("#st_text").val(text.toLowerCase());
	}
}
function getByte(text){
	var total = 0;
	for(var i = 0; i<text.length; i++){
		var curr = text.charCodeAt(i);
		if(curr > 128){
			total += 2;
		}else{
			total += 1;
		}
	}
	return total;
}
function checkLengthByte(){
	var textLength = $("#st_text").val().length;
	var textByte = getByte($("#st_text").val());
	$("#st_byte").html(textLength+" 자 / "+textByte+" byte");
}
</script> 
<body onload="">
	 <form name=logis_fee_reason_pop id=logis_fee_reason_pop method=post >
	<div id="popWrapper" >
    	<div id="popHeader">
        	<h1 class="title">텍스트 변환기</h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/<%=_closeImgSrc %>" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
		<div id="popContainer">
<!-- 			<h2>텍스트 변환기</h2> -->
			<span id="st_byte" style="float: right; font-size: 15px;" >0 자 / 0 byte</span>
			<!--grid-->
                <table class="cont_t_list02" style="width:100%">
					<caption>텍스트 변환기</caption>
                    
                    <textarea rows="10" id="st_text" placeholder="내용을 입력해주세요" style="width:100%; font-size: 18px;" onkeyup="checkLengthByte();"></textarea>
                    <div class="btnArea mt05">
					<span class="fr">
						<span class="btn_02 mr04"><a href="javascript:converter('C');">대문자</a></span>
						<span class="btn_02 mr04"><a href="javascript:converter('S');">소문자</a></span>
					</span> 
				</div>
				</table>
		</div>
	</div>
</form> 
</body>
</html>
