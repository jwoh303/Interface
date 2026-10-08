<%@ include file="/pages/form/jspheader.jsp"%>
<%@ include file="/pages/form/loginCheck.jsp"%>
<%@ page contentType="text/html;charset=UTF-8"%>

<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html"%>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean"%>
<%@ taglib uri="/WEB-INF/gluetag.tld" prefix="posui" %>

<%@ page import="com.posdata.glue.dao.vo.PosRowSet,
				 com.posdata.glue.context.PosContext,
				 com.posdata.glue.dao.vo.PosRow" %>

<%@ page import = "com.posdata.eai.manager.vo.*, 
                   com.posdata.eai.manager.util.JITPage" %>

<%@ page import = "java.util.*" %>
<%@ page import = "com.posdata.glue.dao.vo.*" %>
<%@ page import = "com.posdata.glue.util.log.PosLog" %>

<jsp:useBean id="infoBean" class="com.posdata.glue.ui.tags.GetInfoBean"/>


<%
	PosContext ctx = (PosContext)request.getAttribute( "PosContext" );

	// 현재날짜
	java.text.SimpleDateFormat dateFormat = new java.text.SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
	java.text.SimpleDateFormat dateFormat1 = new java.text.SimpleDateFormat("yyyy-MM-dd");
	String priviousDate = null;
	String currentDate = null;
	if (request.getParameter("date") == null) {
		long time  = System.currentTimeMillis();
		long pTime = time - 1*60*60*1000;
		priviousDate = dateFormat.format(new java.util.Date(pTime));
		currentDate = dateFormat.format(new java.util.Date(time));
	} else {
		currentDate = (String) request.getParameter("date");
	}
	
	String ifid = "";
//	String _stime = "";
//	String _etime = "";
	String tc1 = "";
	
		String _stime=request.getParameter("stime");
        String _etime=request.getParameter("etime");
	    _stime = _stime==null?priviousDate:_stime;
	    _etime = _etime==null?currentDate:_etime;
	
	if(request.getParameter("ifid")!=null || request.getParameter("tc")!=null) {
		ifid = request.getParameter("ifid").toString();
		tc1 = request.getParameter("tc").toString();
 	
	}
	
	
	//String getSelect = (String) request.getParameter("select");
	//List objVal = (ArrayList)request.getAttribute("historyDetail");
	String[] select = null;
	String getSelect = null;
	List objVal = new ArrayList();
	try {
		if(ctx!=null && ctx.get("historyDetail")!=null && ctx.get("select")!=null){
			objVal = (ArrayList)ctx.get("historyDetail");
			select = (String[])ctx.get("select");
			getSelect = select[0];
		}
	}
	catch(Exception e) {
		out.println(e);
	}
	
	int totalCount = 0;

	JITPage jpage = null;
	if( objVal != null && objVal.size() !=0 && !getSelect.equals("noReceivedMsg") ){
		HistoryDetailViewVO vo = (HistoryDetailViewVO)objVal.get(0);
		totalCount = vo.getRowCount();
		jpage = new JITPage(totalCount,vo.getPageNo());
	} else 
	{
		totalCount = objVal==null?0:objVal.size();
	}

%>

<html>
<head>
<%@ include file="/pages/form/htmlheader.jsp"%>

<script type="text/javascript">

function pageChange(pageNo)
{
	//document.forms[0].pageNo.value = pageNo;
	document.getElementById("pageNo").value = pageNo;
	execute1();
}

function execute1() 
{	
	
	if ( document.forms[0].ifid.value == "" &&  document.forms[0].tc.value == "" && document.forms[0].system.value == "" )
	{
		alert('"인터페이스 ID" 또는  "프로세스코드" \n적어도 한개의 검색 조건을 입력 하시오');
		return;
	}
	
	//Retry 방지 start
	if( isWaiting == 'true' ){
		alert("조회 중 입니다!");
		return;
    }
    	isWaiting = 'true';
    	//Retry 방지 end
    		
	checkPeriod();
	document.forms[0].firstselect.value = "%";
	searching();
    	document.forms[0].submit();
    	
}

function execute() 
{	
    document.forms[0].pageNo.value = 1;
    
	if ( document.forms[0].ifid.value == "" &&  document.forms[0].tc.value == "" && document.forms[0].system.value == "")
	{
		alert('"인터페이스 ID", "프로세스코드" 또는 "시스템 이름" \n적어도 한개의 검색 조건을 입력 하시오');
		return;
	}
	
	//Retry 방지 start
	if( isWaiting == 'true' ){
		alert("조회 중 입니다!");
		return;
	}
	
    isWaiting = 'true';
    	//Retry 방지 end
    		
	checkPeriod();
	document.forms[0].firstselect.value = "%";
	searching();
    document.forms[0].submit();
    	
}

function copyData(obj) {
	var idxs = obj;
	if(idxs.value==''){ document.body.focus(); return; }
	idxs.select();
	var clip=idxs.createTextRange()
	clip.execCommand('copy');
	alert('클립보드에 복사되었습니다');
}

function checkPeriod()
{

	var regexp = /-/g ; 
	newString=new String('/'); 

	sDataVal = document.forms[0].stime.value.replace(regexp,newString);
	eDataVal = document.forms[0].etime.value.replace(regexp,newString);
	
	sDate = new Date(sDataVal);
	eDate = new Date(eDataVal);
	//alert(eDate.getTime() - sDate.getTime());
	var diff = eDate.getTime() - sDate.getTime();
	if( diff < 0 || diff > 60 *60 * 3 * 1000 )
	{
		newDate = new Date(sDataVal);
		newDate.setHours(sDate.getHours()+3);
		month = formatTime(newDate.getMonth()+ 1);
		date = formatTime(newDate.getDate());
		hours = formatTime(newDate.getHours());
		minutes = formatTime(newDate.getMinutes());
		seconds = formatTime(newDate.getSeconds());
		document.forms[0].etime.value = newDate.getFullYear() + "-" + month +"-"+date +" "+hours + ":"+ minutes+":"+ seconds;
		alert("3시간을 초과할 수 없습니다");
	}
	
}
function formatTime(time)
{
	if(time < 10)
	{
		time = "0" + time;
	}
	return time;
}

</script>
</head>

<body topmargin=0 leftmargin=0 onLoad="MM_preloadImages('img/ucube_img04_menu_over.gif','img/ucube_img05_menu_over.gif','img/ucube_img06_menu_over.gif','img/ucube_img07_menu_over.gif','/img/ucube_img08_menu_over.gif','img/circle.gif');">
<form method="post" action="historyDetailView.do">
<input type="hidden" name="ServiceName" value="historyDetailView-service" />
<input type="hidden" name="find.x" value="1" />

<div style="display:none"><img src='img/clock.gif'></div>
<!-- 풍선도움말 -->
<div id="balloonHint" style="display:none">
<table border="0" cellspacing="0" cellpadding="3" bgcolor="#FFFFCC" style="border:1px solid #CC3300">
<!--  tr><td style="font-size:12px">도움말</td></tr-->
<tr><td style="font-size:12px">{{hint}}</td></tr>
</table>
</div>

<div id="dhtml" style="background:#FFFFFF;margin:5; margin-top:2; display:none; position:absolute; z-index:99; overflow-y: auto;"></div>
<script language="javascript">balloonHint("balloonHint")</script>
<%@ include file="/pages/header.jsp"%>
    
		<table width="980" border="0" cellspacing="0" cellpadding="0">
			<tr bgcolor=white> 
				<td height=25> 
					<table width="980" height="25" border="0" cellpadding="0" cellspacing="0">
						<tr>
							<td>
								<img src="img/comm_img02_blank.gif" width="5" height="10"><img src="img/comm_img03_ic.gif" width="11" height="10"><span class="bluetit"><img src="img/comm_img02_blank.gif" width="5" height="10"></span>
								<span class="tit01">Detail Event View</span>
							</td>
						</tr>
					</table>
				</td>
			</tr>	
			<tr><!--tr5 start --> 
        		<td align=center bgcolor=white>
	        		<!--검색조건-->
        			<table width="980"  border="1" cellpadding="2" cellspacing="0" bordercolor="#FFFFFF" bgcolor="#FFFFFF" >
	        			<tr> 
						   <td height="25" bordercolor="999999" bgcolor="F8F3E8">
								<input type="hidden" name="select" value="%" /> 
								<input type="hidden" name="firstselect" /> 
						    	<input type="hidden" id="pageNo" name="pageNo" />

						    	<table width="100%"  border="0" cellpadding="0" cellspacing="0" class="search">
					            	<tr>
					              		<td width="%">
					              			<img src="img/comm_img02_blank.gif" width="5" height="10">
					              			<img src="img/comm_img06_ic.gif" width="10" height="3"> <b>인터페이스 ID :</b>
					                  		<input type="text" size="15" maxlength="17" name="ifid" value="<%=ifid %>" class="adb1" onblur="this.className='adb1'" onfocus="this.className='adf1'" onkeyup="this.value=upperCase(this.value);" />
										</td>
										<td width="%">
											<img src="img/comm_img02_blank.gif" width="5" height="10">
					              			<img src="img/comm_img06_ic.gif" width="10" height="3"> <b>프로세스  코드 :</b>
					                  		<input type="text" size="10" maxlength="8" name="tc" value="<%=tc1 %>" class="adb1" onblur="this.className='adb1'" onfocus="this.className='adf1'" onkeyup="this.value=upperCase(this.value);" />
										</td>
									<!-- 	<td width="%">
					              			<img src="img/comm_img06_ic.gif" width="10" height="3"> <b>시스템명</b>
				f	                  		<input type="text" size="10" maxlength="8" name="system" styleClass="adb1" onblur="this.className='adb1'" onfocus="this.className='adf1'" onkeyup="this.value=upperCase(this.value);" />
										</td>
									 --><input type="hidden" name="system"/>
					              		<td width="%">
					              			<img src="img/comm_img02_blank.gif" width="5" height="10">
					              			<img src="img/comm_img06_ic.gif" width="10" height="3"> <b>기간 :</b>         
					              			<input type="text" size="18" maxlength="18" name="stime"  value="<%=_stime %>" class="adb1" onblur="this.className='adb1'" onfocus="this.className='adf1'"  /> ~ 
						    				<input type="text" size="18" maxlength="18" name="etime"  value="<%=_etime %>" class="adb1" onblur="this.className='adb1'" onfocus="this.className='adf1'"  />
					              			<img src="img/comm_img04_cal.gif" border="0" align="absmiddle" onclick="showCalendar('stime','','','','etime',2,true,'opener.checkPeriod();',2,false)" style="cursor:hand" />              
					              			                                                              
					              		</td>
					              		<td height="%" valign="middle" align="right">
					              			<img src="img/comm_img07_but.gif" width="55" height="21" style="cursor:hand" align="absmiddle" onclick="execute()">
					              			<img src="img/comm_img08_but.gif" width="55" height="21" style="cursor:hand" align="absmiddle" onclick="openHelp()">
					              			<img src="img/comm_img02_blank.gif" width="5" height="10">
					              		</td>
					            	</tr>
					          	</table>
							</td>
						</tr>	
	        		</table>  
        		</td>
        	</tr>
			<tr bgcolor=white> 	
				<td align=right height=20 valign=bottom><%if(objVal!=null) { %>총 <%=totalCount%>건이 조회되었습니다.<% } %>&nbsp;&nbsp;</td>
			</tr>			        		
		</table>
		<!-- data -->
   		<table width="960" height=400 border=0 cellpadding="0" cellspacing="0" bordercolorlight=FFFFFF  bordercolordark=FFFFFF>
			<tr>
				<td width=5></td>
				<td align=center valign=top>
					<table width=960 border=0 cellpadding=0 cellspacing=0 bordercolorlight=666666 bordercolordark=FFFFFF>
		    			<tr>
		    				<td height=400 width=100% valign=top>
		    					<DIV id="topLine" style="width:980px;overflow:hidden;">
		    					<table width="960" border="1" cellpadding="1" cellspacing="0" bordercolor="Black" bordercolorlight="#626262" bordercolordark="White" class="tblcb1" valign="TOP" style="table-layout:fixed">
									<tr height=40>
										<td width=100>인터페이스<br>ID</td>
										<td width=80>프로세스<br>코드</td>
										<td width=80>시스템명</td>
										<td width=80>송수신<br>구분</td>
										<td width=80>데이터<br>발생시간</td>
										<td width=80>EAI 처리시간</td>
										<td width=250>이벤트 메시지</td>
										<td width=%>데이터<br>(Max 3,900byte)</td>
									</tr>
								</table>
								</DIV>
								<DIV id="mainDisplay" style="width:980px;height:340px;overflow-y:scroll;overflow-x:hidden" onscroll="scrollY()">
								<table width="960" border="1" cellpadding="1" cellspacing="0" bordercolor="#FFFFFF" bordercolorlight="#626262" bordercolordark="White" bgcolor="#FFFFFF" class="tblbc" valign="TOP" style="table-layout:fixed">											
<%	if( objVal != null ) 
	{
		

		String last_ifid = null; String curr_ifid = null;
		boolean sameifid = false;
		String cssClass = "tblcg";
		/**		
		Hashtable hashtable = new Hashtable();		
		for(int i=0; i<objVal.size(); i++)
		{
			HistoryDetailViewVO vo = (HistoryDetailViewVO)objVal.get(i);
			Object key = vo.getIfd();
			Integer count = (Integer)hashtable.get(key);
			if ( count == null)
			{
				hashtable.put(key, new Integer(1));
			}else
			{
				hashtable.remove(key);
				hashtable.put(key,new Integer(count.intValue() + 1));
			}
			key = null;
			count = null;
			
			key = vo.getIfd() + vo.getTc();
			count = (Integer)hashtable.get(key);
			if ( count == null)
			{
				hashtable.put(key, new Integer(1));
			}else
			{
				hashtable.remove(key);
				hashtable.put(key,new Integer(count.intValue() + 1));
			}
			
		}*/
		for(int i=0; i<objVal.size(); i++) {
			HistoryDetailViewVO vo = (HistoryDetailViewVO)objVal.get(i);
			curr_ifid = vo.getIfd();
			if( i==0 ) last_ifid = curr_ifid;
			
			// 같은 IF ID를 사용할 경우 다음 라인에서 출력하지 않음
			if(i!=0 && last_ifid.equals(curr_ifid)) sameifid = true;
			else {
				sameifid = false;
				cssClass = "tblcg".equals(cssClass)==true?"tblcw":"tblcg";
			}
%>
									<tr class=<%=cssClass%>>

									
									
										<td width="100"><%=vo.getIfd()%></td>
										<td width=80><%=vo.getTc()%></td>
										<td width=80><%=vo.getSc()%></td>
										<td width=80><%=vo.getCode()%></td>
										<td width=80><%=vo.getEst()%></td>
										<td width=80><%=vo.getErt()%></td>
										<td width=250 style="text-align:left;word-break:break-all"><%=vo.getMsg()%></td>
										<td width=%><textarea id="sdata" readonly cols="30" rows="5" class="txtarea" style="width:%;height:90;border-width:1px;cursor:hand" onClick="copyData(this)" ><%=vo.getSdata()==null?"&nbsp;":vo.getSdata()%></textarea></td>
									</tr>			
<%			last_ifid = curr_ifid;		
		}
		if( objVal == null || objVal.size() == 0) {	
%>									<tr height=21><td colspan=9 align=center>검색된 결과가 없습니다.</td></tr>
<%		}		
	}
%>
								</table>
								</DIV>		    					  				
		    				</td>
						</tr>
    				</table>
    			</td>
    		</tr>
    	</table>
              <!-- 페이지 -->
<% if( objVal != null && objVal.size() != 0 && jpage != null) { %> 			
              <%=jpage.getTag()%>
<% } %>    	
<script>
function scrollX() {
	document.all.mainDisplay.scrollLeft = document.all.bottomLine.scrollLeft;
	document.all.topLine.scrollLeft = document.all.bottomLine.scrollLeft;
}
function scrollY() {
	//document.all.leftDisplay.scrollTop = document.all.mainDisplay.scrollTop;
}
</script>	
<%@ include file="/pages/footer.jsp"%>
</form>
</body>
</html>
