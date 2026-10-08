<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/pages/form/htmlheader.jsp" %>
<%@ include file="/pages/form/loginCheck.jsp"%>

<html>
<head>
<title>UCUBE</title>

<style type="text/css">
<!--
body {
	margin-left: 10px;
	margin-top: 0px;
	margin-right: 0px;
	margin-bottom: 0px;

}

div.sample_attach, a.sample_attach, a.sample_attach_over
{
  width: 137px;
  border: 1px solid white;
  background: #3F7EBC;
  padding: 3px 3px 3px 7px;
  font-weight: normal;
  color:#FFFFFF;
}

a.sample_attach
{
  display: block;
  border-bottom: none;
  text-decoration: none;
  font-size : 11px;
}


a.sample_attach_over
{
  display: block;
  border-bottom: none;
  text-decoration: none;
  background: #446893;
  font-weight: bold;
  font-size : 11px;
}


form.sample_attach
{
  position: absolute;
  visibility: hidden;
  border: 1px solid black;
  background: #FFFFEE;
  padding: 0px 5px 2px 5px;
}
-->
</style>

<!-- link href="/uComposer/css/dropdown.css" rel="stylesheet" type="text/css">
<link href="/uComposer/css/pub_ucube.css" rel="stylesheet" type="text/css"  -->

</head>

<body>
		
		<%@ include file="/pages/header.jsp" %>

		<!--세로간격-->
		<table width="980" height="25" border="0" cellpadding="0" cellspacing="0">
			<tr>
				<td>
					<img src="/uComposer/img/comm_img02_blank.gif" width="5" height="10"><img src="/uComposer/img/comm_img03_ic.gif" width="11" height="10"><span class="bluetit"><img src="/uComposer/img/comm_img02_blank.gif" width="5" height="10"></span>
					<span class="tit01">uComposer</span>
				</td>
			</tr>
		</table>
		<!--세로간격 끝-->

<table width="980" height="600" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td>
	  <iframe src="/uComposer/draw2d/draw2d.jsp" width="100%" height="100%" frameborder="0"></iframe>
	</td>
  </tr>
</table>

<jsp:include page="/pages/common/copyright.jsp"/>
	
</body>
</html>
