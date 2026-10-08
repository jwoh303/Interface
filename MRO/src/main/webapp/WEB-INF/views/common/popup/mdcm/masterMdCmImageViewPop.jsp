<%--
**********************************************
* 메뉴 : 
* 화면 : 이미지 보기 
* 기능 : 
* 프로그램 ID : PG_03_M_003_04
* 담당자 : 홍석규 ( 설계 : 권우재 )
* 착수일 : 2014-07-03
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.*"%> 
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<!doctype html>
<html>
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>코리아 e 플랫폼</title>
<head>
<link rel="stylesheet" href="/resources/styles/base.css" type="text/css" />
<link rel="stylesheet" href="/resources/styles/master_layout.css" type="text/css" />
<script src="/resources/libs/jquery/js/jquery.min.js" type="text/javascript"></script>
<script src="/resources/libs/jquery/js/jquery-ui.min.js" type="text/javascript"></script>
<script src="/resources/js/kep_common.js"></script>
</head>
<%
@SuppressWarnings (value="unchecked")
List<Map<String,String>> _dataList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된 결과
String st_cms_catlg_id = CommonUtil.nvl((String) request.getParameter("st_cms_catlg_id"),"");

Map<String,String> _rowData = null;
if (_dataList != null && _dataList.size() != 0) { 
	_rowData = _dataList.get(0);
}

%>

<script type="text/javascript">
<!--
function MM_reloadPage(init) {  //reloads the window if Nav4 resized
  if (init==true) with (navigator) {if ((appName=="Netscape")&&(parseInt(appVersion)==4)) {
    document.MM_pgW=innerWidth; document.MM_pgH=innerHeight; onresize=MM_reloadPage; }}
  else if (innerWidth!=document.MM_pgW || innerHeight!=document.MM_pgH) location.reload();
}
MM_reloadPage(true);

function MM_findObj(n, d) { //v4.0
  var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {
    d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
  if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
  for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document);
  if(!x && document.getElementById) x=document.getElementById(n); return x;
}

function MM_showHideLayers() { //v3.0
  var i,p,v,obj,args=MM_showHideLayers.arguments;
  for (i=0; i<(args.length-2); i+=3) if ((obj=MM_findObj(args[i]))!=null) { v=args[i+2];
    if (obj.style) { obj=obj.style; v=(v=='show')?'visible':(v='hide')?'hidden':v; }
    obj.visibility=v; }
}

function kep_onload_view() {
	<% if (_dataList.size() == 0) { %>
		alert("이미지가 없습니다.\n\n관리자에게 문의 하십시요.");
		self.close();
	<% }%>
}

 //-->
</script> 
<body onload="kep_onload_view();">
	<div id="popWrapper" style="height:570px;">
    	<div id="popHeader">
        	<h1 class="title">이미지 보기 </h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/m_btn_popclose.gif" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer">
			<div id="ContArea" style="width:720px;margin-left:0;" >
           	<!--grid-->
            <div style="height:480px">
            <% if (_rowData != null) {  %>
				<table   style="width:100%">
					<caption>이미지 상세보기</caption>
                    <colgroup>
                    	<col width="500px" />
	                    <col width="10px" />
	                    <col width="270px" />
					</colgroup>
					<tbody>
						<tr>
							<td valign="top" width="500">
								<div style="z-index: 1; position: absolute; width: 460px; height: 500px; visibility: visible" id=first><img src="<%=_rowData.get("IMG01_NM")%>" width=460 height=500></div>
								<div style="z-index: 1; position: absolute; width: 460px; height: 500px; visibility: hidden" id=second><img src="<%=_rowData.get("IMG02_NM")%>" width=460 height=500></div>
								<div style="z-index: 1; position: absolute; width: 460px; height: 500px; visibility: hidden" id=third><img src="<%=_rowData.get("IMG03_NM")%>" width=460 height=500></div>
								<div style="z-index: 1; position: absolute; width: 460px; height: 500px; visibility: hidden" id=fourth><img src="<%=_rowData.get("IMG04_NM")%>" width=460 height=500></div>
							</td>
						<td valign="middle" width="10" align="right">
							<table border="0" cellspacing="0" cellpadding="0" width="1" bgcolor="#d3d3d3" height="500">
							<tr>
							<td></td>
							</tr>
							</table>
						</td>
						<td valign="top" width="270" align="center">
							<table border="0" cellspacing="0" cellpadding="0" width="100%" height="490">
							<tr>
								<td height="60" align="center"><img src="/resources/images/b_h1_logo.gif" width="166" height="37"></td>
							</tr>
							<tr>
								<td>
									<table border="0" cellspacing="0" cellpadding="0" width="100%" bgcolor="#d3d3d3" height="1">
									<tbody>
									<tr>
									<td></td>
									</tr>
									</tbody>
									</table>
								</td>
							</tr>
							<tr>
								<td valign="top">
								<table border="0" cellspacing="0" cellpadding="0" width="100%">
									<tr>
										<td>&nbsp;</td>
									</tr>
									<tr>
										<td align="center" style="height:30px; color:#003694; padding-top:3px; font-size:18px; font-weight:bold;"><%=st_cms_catlg_id%></td>
									</tr>
									<tr>
										<td>&nbsp;</td>
									</tr>
									<tr>
										<td>&nbsp;</td>
									</tr>
									<tr>
										<td align="center">
											<table border="0" cellspacing="0" cellpadding="0" width="72%">
												<tr align=center>
													<td>
														<table border="0" cellspacing="1" cellpadding="0" bgcolor="#cccccc">
															<tr>
																<td bgcolor="#ffffff"><img onMouseOver="MM_showHideLayers('first','','show','second','','hide','third','','hide','fourth','','hide')" onMouseOut="MM_showHideLayers('first','','show','second','','hide','third','','hide','fourth','','hide')" border=0 src="<%=_rowData.get("IMG01_NM")%>" width=65 height=65></td>
																<td bgcolor="#ffffff"><img onMouseOver="MM_showHideLayers('first','','hide','second','','show','third','','hide','fourth','','hide')" onMouseOut="MM_showHideLayers('first','','show','second','','hide','third','','hide','fourth','','hide')" border=0 src="<%=_rowData.get("IMG02_NM")%>" width=65 height=65></td>
															</tr>
															<tr>
																<td bgcolor="#ffffff"><img onMouseOver="MM_showHideLayers('first','','hide','second','','hide','third','','show','fourth','','hide')" onMouseOut="MM_showHideLayers('first','','show','second','','hide','third','','hide','fourth','','hide')" border=0 src="<%=_rowData.get("IMG03_NM")%>" width=65 height=65></td>
																<td bgcolor="#ffffff"><img onMouseOver="MM_showHideLayers('first','','hide','second','','hide','third','','hide','fourth','','show')" onMouseOut="MM_showHideLayers('first','','show','second','','hide','third','','hide','fourth','','hide')" border=0 src="<%=_rowData.get("IMG04_NM")%>" width=65 height=65></td>
															</tr>
														</table>
													</td>
												</tr>
											</table>
										</td>
									</tr>
									<tr>
										<td>&nbsp;</td>
									</tr>
								</table>
								</td>
							</tr>
							<tr>
								<td align="center"><a href="http://www.koreab2b.com/" target="_blank"><span style="cursor: hand" ><b><u>www.koreab2b.com</u></b></span></a> </td>
							</tr>
							<tr>
								<td align="right">
									<table border="0" cellspacing="0" cellpadding="0" width="100%" bgcolor="#d3d3d3" height="1">
										<tr>
										<td></td>
										</tr>
									</table>
								</td>
							</tr>
							<tr>
								<td height="30" align="center">
									<table border="0" cellspacing="0" cellpadding="0" width="100%" height="10">
									<tr>
									<td></td>
									</tr>
									</table>
								</td>
							</tr>
							</table>
						</td>
						</tr>
					</tbody>
				</table>
				<% }  %>
        	</div>
        	<!--버튼영역-->
            <div class="btnArea">
            	<span class="fr">
            		<span class="btn_02"><a href="javascript:window.print();">인쇄하기</a></span>
            	</span>
            </div>
    		</div>    
    	</div>    
	</div>
</body>
</html>
