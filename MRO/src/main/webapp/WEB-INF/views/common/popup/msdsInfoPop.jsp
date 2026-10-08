<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%> 
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<!doctype html>
<html>
<head>
<%@ include file="../../common/include/head_pop.jspf"  %>
</head>

<script type="text/javascript">

function init(){

}

function kepConfirm()
{ 
  this.close();
}


</script>  
<body onload="init(); " >
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다-->
	<div id="popWrapper" style="height:214px; min-height: 100px;">
    	<div id="popHeader">
        	<h1 class="title">MSDS 대상품목 확인 절차</h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/<%=_closeImgSrc %>" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer">
             <table class="cont_t_list05">
                <tr> 
                	<td>1. 품목 성분 및 함유량 확인</td>
                </tr>
                <tr> 
                	<td>2. 성분이 MSDS 대상 물질 여부 아래 3번부터 확인</td>
                </tr>
                <tr> 
                	<td>3. 안전보건공단 <a href="http://msds.kosha.or.kr" target="_blank">http://msds.kosha.or.kr/ URL 접속</a></td>
                </tr>
                <tr> 
                	<td>4. 우측 중간 MSDS 검색 <img src="/resources/images/msds_search.jpg" alt="MSDS" > 클릭</td>
                </tr>
                <tr> 
                	<td>5. MSDS 검색에서 물질명(품목명) 입력 후 검색하기</td>
                </tr>
                <tr> 
                	<td>6. 검색어 대한 검색결과 물질명 클릭</td>
                </tr>
                <tr> 
                	<td>7. MSDS 상세정보 MSDS 요약정보 클릭</td>
                </tr>
                <tr> 
                	<td>8. MSDS 요약정보 팝업창 확인(물질명, 함유량 등)</td>
                </tr>
            </table>
			<table class="cont_t_list05" style="background-color: #FAF9CF;">
				<tr > 
					<td ><b style="color:#ee3212; ">위의 절차에 따라 MSDS 대상 품목이면 견적의뢰
						<br>접수 화면 □MSDS 체크박스 체크 후 협력사 견적의뢰</b>
					</td>
				</tr>

            </table>
 			<table >
                <tr>
                    <td height="4"></td>
                </tr>
            </table >
	       	<div class="btnArea ac" style="margin-bottom:0px;"> 
			     <span class="fr btn_02"><a href="javascript:kepConfirm()">확인</a></span> 
			</div> 		
        </div>
    </div>
</body>
</html>
