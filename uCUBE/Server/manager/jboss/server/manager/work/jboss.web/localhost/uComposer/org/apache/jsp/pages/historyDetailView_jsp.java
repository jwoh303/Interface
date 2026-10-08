package org.apache.jsp.pages;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.jsp.*;
import com.posdata.eai.adapter.livecheck.*;
import com.posdata.eai.manager.struts.action.*;
import com.posdata.eai.manager.struts.form.*;
import com.posdata.eai.manager.dao.*;
import com.posdata.eai.manager.vo.*;
import com.posdata.eai.manager.util.*;
import java.util.*;
import org.displaytag.tags.TableTag;
import java.util.List;
import java.lang.reflect.Method;
import com.posdata.glue.dao.vo.PosRowSet;
import com.posdata.glue.context.PosContext;
import com.posdata.glue.dao.vo.PosRow;
import com.posdata.glue.util.log.PosLog;
import com.posdata.glue.dao.vo.PosRowSet;
import com.posdata.glue.context.PosContext;
import com.posdata.glue.dao.vo.PosRow;
import com.posdata.eai.manager.vo.*;
import com.posdata.eai.manager.util.JITPage;
import java.util.*;
import com.posdata.glue.dao.vo.*;
import com.posdata.glue.util.log.PosLog;

public final class historyDetailView_jsp extends org.apache.jasper.runtime.HttpJspBase
    implements org.apache.jasper.runtime.JspSourceDependent {

  private static java.util.Vector _jspx_dependants;

  static {
    _jspx_dependants = new java.util.Vector(11);
    _jspx_dependants.add("/pages/form/jspheader.jsp");
    _jspx_dependants.add("/WEB-INF/struts-bean.tld");
    _jspx_dependants.add("/WEB-INF/struts-html.tld");
    _jspx_dependants.add("/WEB-INF/struts-logic.tld");
    _jspx_dependants.add("/WEB-INF/displaytag-11.tld");
    _jspx_dependants.add("/WEB-INF/ucube.tld");
    _jspx_dependants.add("/pages/form/loginCheck.jsp");
    _jspx_dependants.add("/WEB-INF/gluetag.tld");
    _jspx_dependants.add("/pages/form/htmlheader.jsp");
    _jspx_dependants.add("/pages/header.jsp");
    _jspx_dependants.add("/pages/footer.jsp");
  }

  public java.util.List getDependants() {
    return _jspx_dependants;
  }

  public void _jspService(HttpServletRequest request, HttpServletResponse response)
        throws java.io.IOException, ServletException {

    JspFactory _jspxFactory = null;
    PageContext pageContext = null;
    HttpSession session = null;
    ServletContext application = null;
    ServletConfig config = null;
    JspWriter out = null;
    Object page = this;
    JspWriter _jspx_out = null;
    PageContext _jspx_page_context = null;


    try {
      _jspxFactory = JspFactory.getDefaultFactory();
      response.setContentType("text/html;charset=UTF-8");
      pageContext = _jspxFactory.getPageContext(this, request, response,
      			null, true, 8192, true);
      _jspx_page_context = pageContext;
      application = pageContext.getServletContext();
      config = pageContext.getServletConfig();
      session = pageContext.getSession();
      out = pageContext.getOut();
      _jspx_out = out;

      out.write("\r\n");
      out.write("\r\n");
      out.write("\r\n");
      out.write("\r\n");
      out.write("\r\n");
      out.write("\r\n");
      out.write("\r\n");
      out.write("\r\n");
      out.write("\r\n");
      out.write("\r\n");
      out.write('\r');
      out.write('\n');
      out.write('\r');
      out.write('\n');

     PosContext ctx1 = (PosContext)request.getAttribute( "PosContext" );
     int level =0;
      //level =Integer.parseInt(ctx1.getSessionUserData("level").toString());
     if(ctx1==null) {
     //	response.sendRedirect("/uComposer");
     //	return;
     }

      out.write('\r');
      out.write('\n');
      out.write("\r\n");
      out.write("\r\n");
      out.write("\r\n");
      out.write("\r\n");
      out.write("\r\n");
      out.write("\r\n");
      out.write("\r\n");
      out.write("\r\n");
      out.write("\r\n");
      out.write("\r\n");
      out.write("\r\n");
      out.write("\r\n");
      out.write("\r\n");
      out.write("\r\n");
      out.write("\r\n");
      com.posdata.glue.ui.tags.GetInfoBean infoBean = null;
      synchronized (_jspx_page_context) {
        infoBean = (com.posdata.glue.ui.tags.GetInfoBean) _jspx_page_context.getAttribute("infoBean", PageContext.PAGE_SCOPE);
        if (infoBean == null){
          infoBean = new com.posdata.glue.ui.tags.GetInfoBean();
          _jspx_page_context.setAttribute("infoBean", infoBean, PageContext.PAGE_SCOPE);
        }
      }
      out.write("\r\n");
      out.write("\r\n");
      out.write("\r\n");

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


      out.write("\r\n");
      out.write("\r\n");
      out.write("<html>\r\n");
      out.write("<head>\r\n");
      out.write("<!-- \r\n");
      out.write("<link rel=\"stylesheet\" href='../css/display1.css' type=\"text/css\">\r\n");
      out.write("<link rel=\"stylesheet\" href='../css/display1.css' type=\"text/css\">\r\n");
      out.write("<link rel=\"stylesheet\" href=\"css/css.css\" style type=\"text/css\">\r\n");
      out.write("-->\r\n");
      out.write("\r\n");
      out.write("<meta http-equiv=\"Content-Type\" content=\"text/html; charset=UTF-8\">\r\n");
      out.write("<style type=\"text/css\">\r\n");
      out.write("<!--\r\n");
      out.write("body {\r\n");
      out.write("\tmargin-left: 10px;\r\n");
      out.write("\tmargin-top: 0px;\r\n");
      out.write("\tmargin-right: 0px;\r\n");
      out.write("\tmargin-bottom: 0px;\r\n");
      out.write("\t\r\n");
      out.write("}\r\n");
      out.write("\r\n");
      out.write("div.sample_attach, a.sample_attach, a.sample_attach_over\r\n");
      out.write("{\r\n");
      out.write("  width: 137px;\r\n");
      out.write("  border: 1px solid white;\r\n");
      out.write("  background: #3F7EBC;\r\n");
      out.write("  padding: 3px 3px 3px 7px;\r\n");
      out.write("  font-weight: normal;\r\n");
      out.write("  color:#FFFFFF;\r\n");
      out.write("}\r\n");
      out.write("\r\n");
      out.write("a.sample_attach\r\n");
      out.write("{\r\n");
      out.write("  display: block;\r\n");
      out.write("  border-bottom: none;\r\n");
      out.write("  text-decoration: none;\r\n");
      out.write("  font-size : 11px;\r\n");
      out.write("}\r\n");
      out.write("\r\n");
      out.write("\r\n");
      out.write("a.sample_attach_over\r\n");
      out.write("{\r\n");
      out.write("  display: block;\r\n");
      out.write("  border-bottom: none;\r\n");
      out.write("  text-decoration: none;\r\n");
      out.write("  background: #446893;\r\n");
      out.write("  font-weight: bold;\r\n");
      out.write("  font-size : 11px;\r\n");
      out.write("}\r\n");
      out.write("\r\n");
      out.write("\r\n");
      out.write("form.sample_attach\r\n");
      out.write("{\r\n");
      out.write("  position: absolute;\r\n");
      out.write("  visibility: hidden;\r\n");
      out.write("  border: 1px solid black;\r\n");
      out.write("  background: #FFFFEE;\r\n");
      out.write("  padding: 0px 5px 2px 5px;\r\n");
      out.write("}\r\n");
      out.write("-->\r\n");
      out.write("</style>\r\n");
      out.write("\r\n");
      out.write("<link href=\"css/dropdown.css\" rel=\"stylesheet\" type=\"text/css\">\r\n");
      out.write("<link href=\"css/pub_ucube.css\" rel=\"stylesheet\" type=\"text/css\">\r\n");
      out.write("\r\n");
      out.write("<!-- link rel=\"stylesheet\" href=\"css/pub.css\" style type=\"text/css\"  -->\r\n");
      out.write("\r\n");
      out.write("\r\n");
      out.write("\r\n");
      out.write("<script language=\"javascript\" type=\"text/javascript\" src=\"js/common.js\"></script>\r\n");
      out.write("<script language=\"javascript\" type=\"text/javascript\" src=\"js/messageTicker.js\"></script>\r\n");
      out.write("<script language=\"javascript\" type=\"text/javascript\" src=\"js/Calendar.js\"></script>\r\n");
      out.write("<script language=\"javascript\" type=\"text/javascript\" src=\"js/dropdown.js\"></script>\r\n");
      out.write("<script language=\"javascript\" type=\"text/javascript\" src=\"js/link.js\"></script>\r\n");
      out.write("<script language=\"javascript\" type=\"text/javascript\" src=\"js/searching.js\"></script>\r\n");
      out.write("<script language=\"javascript\" type=\"text/javascript\" src=\"js/balloon.js\"></script>\r\n");
      out.write("<script language=\"javascript\" type=\"text/javascript\" src=\"js/menu.js\"></script>\r\n");
      out.write("<script language=\"javascript\" type=\"text/javascript\" src=\"js/showCalendar.js\"></script>\r\n");
      out.write("\r\n");
      out.write("\r\n");
      out.write("<script type=\"text/javascript\">\r\n");
      out.write("\r\n");
      out.write("function pageChange(pageNo)\r\n");
      out.write("{\r\n");
      out.write("\t//document.forms[0].pageNo.value = pageNo;\r\n");
      out.write("\tdocument.getElementById(\"pageNo\").value = pageNo;\r\n");
      out.write("\texecute1();\r\n");
      out.write("}\r\n");
      out.write("\r\n");
      out.write("function execute1() \r\n");
      out.write("{\t\r\n");
      out.write("\t\r\n");
      out.write("\tif ( document.forms[0].ifid.value == \"\" &&  document.forms[0].tc.value == \"\" && document.forms[0].system.value == \"\" )\r\n");
      out.write("\t{\r\n");
      out.write("\t\talert('\"인터페이스 ID\" 또는  \"프로세스코드\" \\n적어도 한개의 검색 조건을 입력 하시오');\r\n");
      out.write("\t\treturn;\r\n");
      out.write("\t}\r\n");
      out.write("\t\r\n");
      out.write("\t//Retry 방지 start\r\n");
      out.write("\tif( isWaiting == 'true' ){\r\n");
      out.write("\t\talert(\"조회 중 입니다!\");\r\n");
      out.write("\t\treturn;\r\n");
      out.write("    }\r\n");
      out.write("    \tisWaiting = 'true';\r\n");
      out.write("    \t//Retry 방지 end\r\n");
      out.write("    \t\t\r\n");
      out.write("\tcheckPeriod();\r\n");
      out.write("\tdocument.forms[0].firstselect.value = \"%\";\r\n");
      out.write("\tsearching();\r\n");
      out.write("    \tdocument.forms[0].submit();\r\n");
      out.write("    \t\r\n");
      out.write("}\r\n");
      out.write("\r\n");
      out.write("function execute() \r\n");
      out.write("{\t\r\n");
      out.write("    document.forms[0].pageNo.value = 1;\r\n");
      out.write("    \r\n");
      out.write("\tif ( document.forms[0].ifid.value == \"\" &&  document.forms[0].tc.value == \"\" && document.forms[0].system.value == \"\")\r\n");
      out.write("\t{\r\n");
      out.write("\t\talert('\"인터페이스 ID\", \"프로세스코드\" 또는 \"시스템 이름\" \\n적어도 한개의 검색 조건을 입력 하시오');\r\n");
      out.write("\t\treturn;\r\n");
      out.write("\t}\r\n");
      out.write("\t\r\n");
      out.write("\t//Retry 방지 start\r\n");
      out.write("\tif( isWaiting == 'true' ){\r\n");
      out.write("\t\talert(\"조회 중 입니다!\");\r\n");
      out.write("\t\treturn;\r\n");
      out.write("\t}\r\n");
      out.write("\t\r\n");
      out.write("    isWaiting = 'true';\r\n");
      out.write("    \t//Retry 방지 end\r\n");
      out.write("    \t\t\r\n");
      out.write("\tcheckPeriod();\r\n");
      out.write("\tdocument.forms[0].firstselect.value = \"%\";\r\n");
      out.write("\tsearching();\r\n");
      out.write("    document.forms[0].submit();\r\n");
      out.write("    \t\r\n");
      out.write("}\r\n");
      out.write("\r\n");
      out.write("function copyData(obj) {\r\n");
      out.write("\tvar idxs = obj;\r\n");
      out.write("\tif(idxs.value==''){ document.body.focus(); return; }\r\n");
      out.write("\tidxs.select();\r\n");
      out.write("\tvar clip=idxs.createTextRange()\r\n");
      out.write("\tclip.execCommand('copy');\r\n");
      out.write("\talert('클립보드에 복사되었습니다');\r\n");
      out.write("}\r\n");
      out.write("\r\n");
      out.write("function checkPeriod()\r\n");
      out.write("{\r\n");
      out.write("\r\n");
      out.write("\tvar regexp = /-/g ; \r\n");
      out.write("\tnewString=new String('/'); \r\n");
      out.write("\r\n");
      out.write("\tsDataVal = document.forms[0].stime.value.replace(regexp,newString);\r\n");
      out.write("\teDataVal = document.forms[0].etime.value.replace(regexp,newString);\r\n");
      out.write("\t\r\n");
      out.write("\tsDate = new Date(sDataVal);\r\n");
      out.write("\teDate = new Date(eDataVal);\r\n");
      out.write("\t//alert(eDate.getTime() - sDate.getTime());\r\n");
      out.write("\tvar diff = eDate.getTime() - sDate.getTime();\r\n");
      out.write("\tif( diff < 0 || diff > 60 *60 * 3 * 1000 )\r\n");
      out.write("\t{\r\n");
      out.write("\t\tnewDate = new Date(sDataVal);\r\n");
      out.write("\t\tnewDate.setHours(sDate.getHours()+3);\r\n");
      out.write("\t\tmonth = formatTime(newDate.getMonth()+ 1);\r\n");
      out.write("\t\tdate = formatTime(newDate.getDate());\r\n");
      out.write("\t\thours = formatTime(newDate.getHours());\r\n");
      out.write("\t\tminutes = formatTime(newDate.getMinutes());\r\n");
      out.write("\t\tseconds = formatTime(newDate.getSeconds());\r\n");
      out.write("\t\tdocument.forms[0].etime.value = newDate.getFullYear() + \"-\" + month +\"-\"+date +\" \"+hours + \":\"+ minutes+\":\"+ seconds;\r\n");
      out.write("\t\talert(\"3시간을 초과할 수 없습니다\");\r\n");
      out.write("\t}\r\n");
      out.write("\t\r\n");
      out.write("}\r\n");
      out.write("function formatTime(time)\r\n");
      out.write("{\r\n");
      out.write("\tif(time < 10)\r\n");
      out.write("\t{\r\n");
      out.write("\t\ttime = \"0\" + time;\r\n");
      out.write("\t}\r\n");
      out.write("\treturn time;\r\n");
      out.write("}\r\n");
      out.write("\r\n");
      out.write("</script>\r\n");
      out.write("</head>\r\n");
      out.write("\r\n");
      out.write("<body topmargin=0 leftmargin=0 onLoad=\"MM_preloadImages('img/ucube_img04_menu_over.gif','img/ucube_img05_menu_over.gif','img/ucube_img06_menu_over.gif','img/ucube_img07_menu_over.gif','/img/ucube_img08_menu_over.gif','img/circle.gif');\">\r\n");
      out.write("<form method=\"post\" action=\"historyDetailView.do\">\r\n");
      out.write("<input type=\"hidden\" name=\"ServiceName\" value=\"historyDetailView-service\" />\r\n");
      out.write("<input type=\"hidden\" name=\"find.x\" value=\"1\" />\r\n");
      out.write("\r\n");
      out.write("<div style=\"display:none\"><img src='img/clock.gif'></div>\r\n");
      out.write("<!-- 풍선도움말 -->\r\n");
      out.write("<div id=\"balloonHint\" style=\"display:none\">\r\n");
      out.write("<table border=\"0\" cellspacing=\"0\" cellpadding=\"3\" bgcolor=\"#FFFFCC\" style=\"border:1px solid #CC3300\">\r\n");
      out.write("<!--  tr><td style=\"font-size:12px\">도움말</td></tr-->\r\n");
      out.write("<tr><td style=\"font-size:12px\">{{hint}}</td></tr>\r\n");
      out.write("</table>\r\n");
      out.write("</div>\r\n");
      out.write("\r\n");
      out.write("<div id=\"dhtml\" style=\"background:#FFFFFF;margin:5; margin-top:2; display:none; position:absolute; z-index:99; overflow-y: auto;\"></div>\r\n");
      out.write("<script language=\"javascript\">balloonHint(\"balloonHint\")</script>\r\n");
      out.write("<script language=\"javascript\" type=\"text/javascript\" src=\"/uComposer/js/common.js\"></script>\r\n");
      out.write("<script language=\"javascript\" type=\"text/javascript\" src=\"/uComposer/js/messageTicker.js\"></script>\r\n");
      out.write("<script language=\"javascript\" type=\"text/javascript\" src=\"/uComposer/js/Calendar.js\"></script>\r\n");
      out.write("<script language=\"javascript\" type=\"text/javascript\" src=\"/uComposer/js/dropdown.js\"></script>\r\n");
      out.write("<script language=\"javascript\" type=\"text/javascript\" src=\"/uComposer/js/link.js\"></script>\r\n");
      out.write("<script language=\"javascript\" type=\"text/javascript\" src=\"/uComposer/js/searching.js\"></script>\r\n");
      out.write("<script language=\"javascript\" type=\"text/javascript\" src=\"/uComposer/js/balloon.js\"></script>\r\n");
      out.write("<script language=\"javascript\" type=\"text/javascript\" src=\"/uComposer/js/menu.js\"></script>\r\n");
      out.write("<script language=\"javascript\" type=\"text/javascript\" src=\"/uComposer/js/showCalendar.js\"></script>\r\n");
      out.write("\r\n");
      out.write("<title>u-CUBE 2.0</title>\r\n");
      out.write("\r\n");

	// 
	java.text.SimpleDateFormat simpleAateFormat = new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	String now = simpleAateFormat.format(new java.util.Date());

      out.write("\r\n");
      out.write("\r\n");
      out.write("\t\t<!--로고 및 상단메뉴-->\r\n");
      out.write("\t\t<table width=\"30\" height=\"8\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\">\r\n");
      out.write("\t\t\t<tr>\r\n");
      out.write("\t\t\t\t<td></td>\r\n");
      out.write("\t\t\t</tr>\r\n");
      out.write("\t\t</table>\r\n");
      out.write("\r\n");
      out.write("\t\t<table width=\"980\"  border=\"0\" cellpadding=\"0\" cellspacing=\"0\">\r\n");
      out.write("\t\t\t<tr>\r\n");
      out.write("\t\t\t\t<td width=\"392\"><img src=\"/uComposer/img/ucube_img01_logo.gif\" width=\"341\" height=\"22\"></td>\r\n");
      out.write("\t\t\t\t<td>&nbsp;</td>\r\n");
      out.write("\t\t\t\t<td width=\"250\">\r\n");
      out.write("\t\t\t\t\t<table width=\"100%\"  border=\"0\" cellspacing=\"0\" cellpadding=\"0\">\r\n");
      out.write("\t\t\t\t\t\t<tr>\r\n");
      out.write("\t\t\t\t\t\t\t<td width=\"17\"><img src=\"/uComposer/img/ucube_img10_time.gif\" width=\"13\" height=\"13\"></td>\r\n");
      out.write("\t\t\t\t\t\t\t<td valign=\"bottom\" class=\"tblbl\">[최종조회시간 : ");
      out.print(now);
      out.write("] </td>\r\n");
      out.write("\t\t\t\t\t\t</tr>\r\n");
      out.write("\t\t\t\t\t</table>\r\n");
      out.write("\t\t\t\t</td>\r\n");
      out.write("\t\t\t\t<td width=\"50\" align=\"center\"><img src=\"/uComposer/img/ucube_img11_logout.gif\" width=\"50\" height=\"14\" onclick=\"ConfirmChoice('/uComposer/login.do?event=logout',' 나가시겠습니까 ?');return false; \" style=\"cursor:hand\"></td>\r\n");
      out.write("\t\t\t\t<td width=\"10\"></td>\r\n");
      out.write("\t\t\t</tr>\r\n");
      out.write("\t\t</table>\r\n");
      out.write("\t\t<!--로고 및 상단메뉴 끝-->\r\n");
      out.write("\r\n");
      out.write("\t\t<!--메인메뉴-->\r\n");
      out.write("\t\t<table width=\"980\"  border=\"0\" cellspacing=\"0\" cellpadding=\"0\">\r\n");
      out.write("\t\t\t<tr>\r\n");
      out.write("\t\t\t\t<td width=\"20\"><img src=\"/uComposer/img/ucube_img02_menu.gif\" width=\"11\" height=\"28\"></td>\r\n");
      out.write("\t\t\t\t<td width=\"20%\" background=\"/uComposer/img/ucube_img03_menu.gif\" height=\"28\"></td>\r\n");
      out.write("\t\t\t\t<td width=\"110\" onMouseOver=\"MM_swapImage('Image1','','/uComposer/img/ucube_img04_menu_over.gif',1)\" onMouseOut=\"MM_swapImgRestore()\">\r\n");
      out.write("\t\t\t\t\t<dl class=\"dropdown\">\r\n");
      out.write("\t\t\t\t\t\t<dt id=\"one-ddheader\" onmouseover=\"ddMenu('one',1)\" onmouseout=\"ddMenu('one',-1)\">\r\n");
      out.write("\t\t\t\t\t\t\t<a href=\"/uComposer/eventAudit.do?ServiceName=eventAudit-service\"><img src=\"/uComposer/img/ucube_img04_menu.gif\" name=\"Image1\" width=\"110\" height=\"28\" border=\"0\" id=\"Image1\"></a>\r\n");
      out.write("\t\t\t\t\t\t</dt>\r\n");
      out.write("\t\t\t\t\t\t<dd id=\"one-ddcontent\" onmouseover=\"cancelHide('one')\" onmouseout=\"ddMenu('one',-1)\">\r\n");
      out.write("\t\t    \t\t\t\t<ul>\r\n");
      out.write("\t\t\t\t\t      \t\t<li><a href=\"/uComposer/eventAudit.do?ServiceName=eventAudit-service\" class=\"underline\">- Hourly Statistical Data</a></li>\r\n");
      out.write("\t\t    \t\t\t\t</ul>\r\n");
      out.write("\t\t  \t\t\t\t</dd>\r\n");
      out.write("\t\t\t\t\t</dl> \r\n");
      out.write("\t\t\t\t</td>\r\n");
      out.write("\t\t\t\t<td width=\"104\" onMouseOver=\"MM_swapImage('Image2','','/uComposer/img/ucube_img05_menu_over.gif',1)\" onMouseOut=\"MM_swapImgRestore()\">\r\n");
      out.write("\t\t\t\t\t<dl class=\"dropdown\">\r\n");
      out.write("\t\t\t\t\t\t<dt id=\"two-ddheader\" onmouseover=\"ddMenu('two',1)\" onmouseout=\"ddMenu('two',-1)\">\r\n");
      out.write("\t\t\t\t\t\t\t<a href=\"/uComposer/historyEventView.do?ServiceName=historyEventView-service\"><img src=\"/uComposer/img/ucube_img05_menu.gif\" name=\"Image2\" width=\"104\" height=\"28\" border=\"0\" id=\"Image2\"></a>\r\n");
      out.write("\t\t\t\t\t\t</dt>\r\n");
      out.write("\t\t\t\t\t\t<dd id=\"two-ddcontent\" onmouseover=\"cancelHide('two')\" onmouseout=\"ddMenu('two',-1)\">\r\n");
      out.write("\t\t    \t\t\t\t<ul>\r\n");
      out.write("\t\t\t\t\t      \t\t<li><a href=\"/uComposer/historyEventView.do?ServiceName=historyEventView-service\" class=\"underline\">- History Event View</a></li>\r\n");
      out.write("\t\t\t\t\t      \t\t<li><a href=\"/uComposer/historyDetailView.do?ServiceName=historyDetailView-service\" class=\"underline\">- Detail Event View</a></li>\r\n");
      out.write("\t\t    \t\t\t\t</ul>\r\n");
      out.write("\t\t  \t\t\t\t</dd>\r\n");
      out.write("\t\t\t\t\t</dl> \r\n");
      out.write("\t\t\t\t</td>\r\n");
      out.write("\t\t\t\t<td width=\"130\" onMouseOver=\"MM_swapImage('Image3','','/uComposer/img/ucube_img06_menu_over.gif',1)\" onMouseOut=\"MM_swapImgRestore()\">\r\n");
      out.write("\t\t\t\t\t<dl class=\"dropdown\">\r\n");
      out.write("\t\t\t\t\t\t<dt id=\"three-ddheader\" onmouseover=\"ddMenu('three',1)\" onmouseout=\"ddMenu('three',-1)\">\r\n");
      out.write("\t\t\t\t\t\t\t<a href=\"/uComposer/queueMonitor.do?ServiceName=queueMonitor-service\"><img src=\"/uComposer/img/ucube_img06_menu.gif\" name=\"Image3\" width=\"130\" height=\"28\" border=\"0\" id=\"Image3\"></a>\r\n");
      out.write("\t\t\t\t\t\t</dt>\r\n");
      out.write("\t\t\t\t\t\t<dd id=\"three-ddcontent\" onmouseover=\"cancelHide('three')\" onmouseout=\"ddMenu('three',-1)\">\r\n");
      out.write("\t\t    \t\t\t\t<ul>\r\n");
      out.write("\t\t\t\t\t      \t\t<li><a href=\"/uComposer/queueMonitor.do?ServiceName=queueMonitor-service\" class=\"underline\">- Queue Monitor</a></li>\r\n");
      out.write("\t\t\t\t\t      \t\t<li><a href=\"/uComposer/serviceStatusMonitor.do\" class=\"underline\">- Service Status Monitor</a></li>\r\n");
      out.write("\t\t    \t\t\t\t</ul>\r\n");
      out.write("\t\t  \t\t\t\t</dd>\r\n");
      out.write("\t\t\t\t\t</dl> \r\n");
      out.write("\t\t\t\t</td>\r\n");
      out.write("\t\t\t\t<td width=\"137\" onMouseOver=\"MM_swapImage('Image5','','/uComposer/img/ucube_img08_menu_over.gif',1)\" onMouseOut=\"MM_swapImgRestore()\">\r\n");
      out.write("\t\t\t\t\t<dl class=\"dropdown\">\r\n");
      out.write("\t\t\t\t\t\t<dt id=\"four-ddheader\" onmouseover=\"ddMenu('four',1)\" onmouseout=\"ddMenu('four',-1)\">\r\n");
      out.write("\t\t\t\t\t\t\t<a href=\"/uComposer/interfaceList.do?ServiceName=interfaceList-serivce\"><img src=\"/uComposer/img/ucube_img08_menu.gif\" name=\"Image5\" width=\"137\" height=\"28\" border=\"0\" id=\"Image5\"></a>\r\n");
      out.write("\t\t\t\t\t\t</dt>\r\n");
      out.write("\t\t\t\t\t\t<dd id=\"four-ddcontent\" onmouseover=\"cancelHide('four')\" onmouseout=\"ddMenu('four',-1)\">\r\n");
      out.write("\t\t    \t\t\t\t<ul>\r\n");
      out.write("\t\t\t\t\t\t\t\t<li><a href=\"/uComposer/serviceConfigManagerAction.do?ServiceName=serviceConfigManager-service&find.x=1\" class=\"underline\">- Service Config</a></li>\r\n");
      out.write("\t\t\t\t\t      \t\t<!--  li><a href=\"/uComposer/interfaceList.do?ServiceName=interfaceList-serivce\" class=\"underline\">- Interface Inquiry</a></li>\r\n");
      out.write("\t\t\t\t\t      \t\t<li><a href=\"/uComposer/interfaceManager.do?ServiceName=interfaceManager-serivce\" class=\"underline\">- Interface Manager</a></li>\r\n");
      out.write("\t\t\t\t\t      \t\t<li><a href=\"/uComposer/interfaceGenerator.do?v\" class=\"underline\">- Interface Generator</a></li>\r\n");
      out.write("\t\t\t\t\t      \t\t<li><a href=\"/uComposer/userManager.do?ServiceName=userManager-serivc?find.x=1\" class=\"underline\">- User Manager</a></li>\r\n");
      out.write("\t\t\t\t\t      \t\t<li><a href=\"/uComposer/smsResultList.do\" class=\"underline\">- SMS Manager</a></li> -->\r\n");
      out.write("\t\t    \t\t\t\t</ul>\r\n");
      out.write("\t\t  \t\t\t\t</dd>\r\n");
      out.write("\t\t\t\t\t</dl> \r\n");
      out.write("\t\t\t\t</td>\r\n");
      out.write("\t\t\t\t<!-- td width=\"124\" onMouseOver=\"MM_swapImage('Image4','','/uComposer/img/ucube_img07_menu_over.gif',1)\" onMouseOut=\"MM_swapImgRestore()\">\r\n");
      out.write("\t\t\t\t\t<dl class=\"dropdown\">\r\n");
      out.write("\t\t\t\t\t\t<dt id=\"five-ddheader\" onmouseover=\"ddMenu('five',1)\" onmouseout=\"ddMenu('five',-1)\">\r\n");
      out.write("\t\t\t\t\t\t\t<a href=\"javascript:top.calluComposer()\"><img src=\"/uComposer/img/ucube_img08_menu.gif\" name=\"Image5\" width=\"124\" height=\"28\" border=\"0\" id=\"Image5\"></a>\r\n");
      out.write("\t\t\t\t\t\t\t<img src=\"/uComposer/img/ucube_img07_menu.gif\" name=\"Image4\" width=\"124\" height=\"28\" border=\"0\" id=\"Image4\">\r\n");
      out.write("\t\t\t\t\t\t</dt>\r\n");
      out.write("\t\t\t\t\t\t<dd id=\"five-ddcontent\" onmouseover=\"cancelHide('five')\" onmouseout=\"ddMenu('five',-1)\">\r\n");
      out.write("\t\t\t\t\t\t\t<ul>\r\n");
      out.write("\t\t\t\t\t\t\t\t<li><a href=\"javascript:top.calluComposer()\" class=\"underline\">- uComposer</a></li>\r\n");
      out.write("\t\t\t\t\t\t\t\t<li><a href=\"javascript:top.callDistribute()\" class=\"underline\">- Distribute</a></li>\r\n");
      out.write("\t\t\t\t\t\t\t\t<li><a href=\"javascript:callDistributeHistory()\" class=\"underline\">- Distribute History</a></li>\r\n");
      out.write("\t\t\t\t\t\t\t\t<li><a href=\"/uComposer/serviceConfigManagerAction.do?ServiceName=serviceConfigManager-service&find.x=1\" class=\"underline\">- Service Config</a></li>\r\n");
      out.write("\t\t\t\t\t\t\t</ul>\r\n");
      out.write("\t\t\t\t\t\t</dd>\r\n");
      out.write("\t\t\t\t\t</dl>\r\n");
      out.write("\t\t\t\t</td -->\r\n");
      out.write("\t\t\t\t<td width=\"30%\" background=\"/uComposer/img/ucube_img03_menu.gif\">&nbsp;</td>\r\n");
      out.write("\t\t\t\t<td width=\"27\"><img src=\"/uComposer/img/ucube_img09_menu.gif\" width=\"9\" height=\"28\"></td>\r\n");
      out.write("\t\t\t</tr>\r\n");
      out.write("\t\t</table>\r\n");
      out.write("\t\t\r\n");
      out.write("<!-- \t\t<dl class=\"dropdown\">\r\n");
      out.write("\t\t\t<dt id=\"one-ddheader\" onmouseover=\"ddMenu('one',1)\" onmouseout=\"ddMenu('one',-1)\">Dropdown One</dt>\r\n");
      out.write("\t\t\t\t<dd id=\"one-ddcontent\" onmouseover=\"cancelHide('one')\" onmouseout=\"ddMenu('one',-1)\">\r\n");
      out.write("\t\t\t    \t<ul>\r\n");
      out.write("\t\t\t      \t\t<li><a href=\"#\" class=\"underline\">Navigation Item 1</a></li>\r\n");
      out.write("\t\t\t      \t\t<li><a href=\"#\" class=\"underline\">Navigation Item 2</a></li>\r\n");
      out.write("\t\t\t      \t\t<li><a href=\"#\" class=\"underline\">Navigation Item 3</a></li>\r\n");
      out.write("\t\t\t      \t\t<li><a href=\"#\" class=\"underline\">Navigation Item 4</a></li>\r\n");
      out.write("\t\t\t      \t\t<li><a href=\"#\">Navigation Item 5</a></li>\r\n");
      out.write("\t\t\t    \t</ul>\r\n");
      out.write("\t\t\t  \t</dd>\r\n");
      out.write("\t\t</dl>\r\n");
      out.write("-->\r\n");
      out.write("\t\t\r\n");
      out.write("\t\t<!--메인메뉴 끝-->\r\n");
      out.write("\t\t\r\n");
      out.write("\r\n");
      out.write("    \r\n");
      out.write("\t\t<table width=\"980\" border=\"0\" cellspacing=\"0\" cellpadding=\"0\">\r\n");
      out.write("\t\t\t<tr bgcolor=white> \r\n");
      out.write("\t\t\t\t<td height=25> \r\n");
      out.write("\t\t\t\t\t<table width=\"980\" height=\"25\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\">\r\n");
      out.write("\t\t\t\t\t\t<tr>\r\n");
      out.write("\t\t\t\t\t\t\t<td>\r\n");
      out.write("\t\t\t\t\t\t\t\t<img src=\"img/comm_img02_blank.gif\" width=\"5\" height=\"10\"><img src=\"img/comm_img03_ic.gif\" width=\"11\" height=\"10\"><span class=\"bluetit\"><img src=\"img/comm_img02_blank.gif\" width=\"5\" height=\"10\"></span>\r\n");
      out.write("\t\t\t\t\t\t\t\t<span class=\"tit01\">Detail Event View</span>\r\n");
      out.write("\t\t\t\t\t\t\t</td>\r\n");
      out.write("\t\t\t\t\t\t</tr>\r\n");
      out.write("\t\t\t\t\t</table>\r\n");
      out.write("\t\t\t\t</td>\r\n");
      out.write("\t\t\t</tr>\t\r\n");
      out.write("\t\t\t<tr><!--tr5 start --> \r\n");
      out.write("        \t\t<td align=center bgcolor=white>\r\n");
      out.write("\t        \t\t<!--검색조건-->\r\n");
      out.write("        \t\t\t<table width=\"980\"  border=\"1\" cellpadding=\"2\" cellspacing=\"0\" bordercolor=\"#FFFFFF\" bgcolor=\"#FFFFFF\" >\r\n");
      out.write("\t        \t\t\t<tr> \r\n");
      out.write("\t\t\t\t\t\t   <td height=\"25\" bordercolor=\"999999\" bgcolor=\"F8F3E8\">\r\n");
      out.write("\t\t\t\t\t\t\t\t<input type=\"hidden\" name=\"select\" value=\"%\" /> \r\n");
      out.write("\t\t\t\t\t\t\t\t<input type=\"hidden\" name=\"firstselect\" /> \r\n");
      out.write("\t\t\t\t\t\t    \t<input type=\"hidden\" id=\"pageNo\" name=\"pageNo\" />\r\n");
      out.write("\r\n");
      out.write("\t\t\t\t\t\t    \t<table width=\"100%\"  border=\"0\" cellpadding=\"0\" cellspacing=\"0\" class=\"search\">\r\n");
      out.write("\t\t\t\t\t            \t<tr>\r\n");
      out.write("\t\t\t\t\t              \t\t<td width=\"%\">\r\n");
      out.write("\t\t\t\t\t              \t\t\t<img src=\"img/comm_img02_blank.gif\" width=\"5\" height=\"10\">\r\n");
      out.write("\t\t\t\t\t              \t\t\t<img src=\"img/comm_img06_ic.gif\" width=\"10\" height=\"3\"> <b>인터페이스 ID :</b>\r\n");
      out.write("\t\t\t\t\t                  \t\t<input type=\"text\" size=\"15\" maxlength=\"17\" name=\"ifid\" value=\"");
      out.print(ifid );
      out.write("\" class=\"adb1\" onblur=\"this.className='adb1'\" onfocus=\"this.className='adf1'\" onkeyup=\"this.value=upperCase(this.value);\" />\r\n");
      out.write("\t\t\t\t\t\t\t\t\t\t</td>\r\n");
      out.write("\t\t\t\t\t\t\t\t\t\t<td width=\"%\">\r\n");
      out.write("\t\t\t\t\t\t\t\t\t\t\t<img src=\"img/comm_img02_blank.gif\" width=\"5\" height=\"10\">\r\n");
      out.write("\t\t\t\t\t              \t\t\t<img src=\"img/comm_img06_ic.gif\" width=\"10\" height=\"3\"> <b>프로세스  코드 :</b>\r\n");
      out.write("\t\t\t\t\t                  \t\t<input type=\"text\" size=\"10\" maxlength=\"8\" name=\"tc\" value=\"");
      out.print(tc1 );
      out.write("\" class=\"adb1\" onblur=\"this.className='adb1'\" onfocus=\"this.className='adf1'\" onkeyup=\"this.value=upperCase(this.value);\" />\r\n");
      out.write("\t\t\t\t\t\t\t\t\t\t</td>\r\n");
      out.write("\t\t\t\t\t\t\t\t\t<!-- \t<td width=\"%\">\r\n");
      out.write("\t\t\t\t\t              \t\t\t<img src=\"img/comm_img06_ic.gif\" width=\"10\" height=\"3\"> <b>시스템명</b>\r\n");
      out.write("\t\t\t\tf\t                  \t\t<input type=\"text\" size=\"10\" maxlength=\"8\" name=\"system\" styleClass=\"adb1\" onblur=\"this.className='adb1'\" onfocus=\"this.className='adf1'\" onkeyup=\"this.value=upperCase(this.value);\" />\r\n");
      out.write("\t\t\t\t\t\t\t\t\t\t</td>\r\n");
      out.write("\t\t\t\t\t\t\t\t\t --><input type=\"hidden\" name=\"system\"/>\r\n");
      out.write("\t\t\t\t\t              \t\t<td width=\"%\">\r\n");
      out.write("\t\t\t\t\t              \t\t\t<img src=\"img/comm_img02_blank.gif\" width=\"5\" height=\"10\">\r\n");
      out.write("\t\t\t\t\t              \t\t\t<img src=\"img/comm_img06_ic.gif\" width=\"10\" height=\"3\"> <b>기간 :</b>         \r\n");
      out.write("\t\t\t\t\t              \t\t\t<input type=\"text\" size=\"18\" maxlength=\"18\" name=\"stime\"  value=\"");
      out.print(_stime );
      out.write("\" class=\"adb1\" onblur=\"this.className='adb1'\" onfocus=\"this.className='adf1'\"  /> ~ \r\n");
      out.write("\t\t\t\t\t\t    \t\t\t\t<input type=\"text\" size=\"18\" maxlength=\"18\" name=\"etime\"  value=\"");
      out.print(_etime );
      out.write("\" class=\"adb1\" onblur=\"this.className='adb1'\" onfocus=\"this.className='adf1'\"  />\r\n");
      out.write("\t\t\t\t\t              \t\t\t<img src=\"img/comm_img04_cal.gif\" border=\"0\" align=\"absmiddle\" onclick=\"showCalendar('stime','','','','etime',2,true,'opener.checkPeriod();',2,false)\" style=\"cursor:hand\" />              \r\n");
      out.write("\t\t\t\t\t              \t\t\t                                                              \r\n");
      out.write("\t\t\t\t\t              \t\t</td>\r\n");
      out.write("\t\t\t\t\t              \t\t<td height=\"%\" valign=\"middle\" align=\"right\">\r\n");
      out.write("\t\t\t\t\t              \t\t\t<img src=\"img/comm_img07_but.gif\" width=\"55\" height=\"21\" style=\"cursor:hand\" align=\"absmiddle\" onclick=\"execute()\">\r\n");
      out.write("\t\t\t\t\t              \t\t\t<img src=\"img/comm_img08_but.gif\" width=\"55\" height=\"21\" style=\"cursor:hand\" align=\"absmiddle\" onclick=\"openHelp()\">\r\n");
      out.write("\t\t\t\t\t              \t\t\t<img src=\"img/comm_img02_blank.gif\" width=\"5\" height=\"10\">\r\n");
      out.write("\t\t\t\t\t              \t\t</td>\r\n");
      out.write("\t\t\t\t\t            \t</tr>\r\n");
      out.write("\t\t\t\t\t          \t</table>\r\n");
      out.write("\t\t\t\t\t\t\t</td>\r\n");
      out.write("\t\t\t\t\t\t</tr>\t\r\n");
      out.write("\t        \t\t</table>  \r\n");
      out.write("        \t\t</td>\r\n");
      out.write("        \t</tr>\r\n");
      out.write("\t\t\t<tr bgcolor=white> \t\r\n");
      out.write("\t\t\t\t<td align=right height=20 valign=bottom>");
if(objVal!=null) { 
      out.write('총');
      out.write(' ');
      out.print(totalCount);
      out.write("건이 조회되었습니다.");
 } 
      out.write("&nbsp;&nbsp;</td>\r\n");
      out.write("\t\t\t</tr>\t\t\t        \t\t\r\n");
      out.write("\t\t</table>\r\n");
      out.write("\t\t<!-- data -->\r\n");
      out.write("   \t\t<table width=\"960\" height=400 border=0 cellpadding=\"0\" cellspacing=\"0\" bordercolorlight=FFFFFF  bordercolordark=FFFFFF>\r\n");
      out.write("\t\t\t<tr>\r\n");
      out.write("\t\t\t\t<td width=5></td>\r\n");
      out.write("\t\t\t\t<td align=center valign=top>\r\n");
      out.write("\t\t\t\t\t<table width=960 border=0 cellpadding=0 cellspacing=0 bordercolorlight=666666 bordercolordark=FFFFFF>\r\n");
      out.write("\t\t    \t\t\t<tr>\r\n");
      out.write("\t\t    \t\t\t\t<td height=400 width=100% valign=top>\r\n");
      out.write("\t\t    \t\t\t\t\t<DIV id=\"topLine\" style=\"width:980px;overflow:hidden;\">\r\n");
      out.write("\t\t    \t\t\t\t\t<table width=\"960\" border=\"1\" cellpadding=\"1\" cellspacing=\"0\" bordercolor=\"Black\" bordercolorlight=\"#626262\" bordercolordark=\"White\" class=\"tblcb1\" valign=\"TOP\" style=\"table-layout:fixed\">\r\n");
      out.write("\t\t\t\t\t\t\t\t\t<tr height=40>\r\n");
      out.write("\t\t\t\t\t\t\t\t\t\t<td width=100>인터페이스<br>ID</td>\r\n");
      out.write("\t\t\t\t\t\t\t\t\t\t<td width=80>프로세스<br>코드</td>\r\n");
      out.write("\t\t\t\t\t\t\t\t\t\t<td width=80>시스템명</td>\r\n");
      out.write("\t\t\t\t\t\t\t\t\t\t<td width=80>송수신<br>구분</td>\r\n");
      out.write("\t\t\t\t\t\t\t\t\t\t<td width=80>데이터<br>발생시간</td>\r\n");
      out.write("\t\t\t\t\t\t\t\t\t\t<td width=80>EAI 처리시간</td>\r\n");
      out.write("\t\t\t\t\t\t\t\t\t\t<td width=250>이벤트 메시지</td>\r\n");
      out.write("\t\t\t\t\t\t\t\t\t\t<td width=%>데이터<br>(Max 3,900byte)</td>\r\n");
      out.write("\t\t\t\t\t\t\t\t\t</tr>\r\n");
      out.write("\t\t\t\t\t\t\t\t</table>\r\n");
      out.write("\t\t\t\t\t\t\t\t</DIV>\r\n");
      out.write("\t\t\t\t\t\t\t\t<DIV id=\"mainDisplay\" style=\"width:980px;height:340px;overflow-y:scroll;overflow-x:hidden\" onscroll=\"scrollY()\">\r\n");
      out.write("\t\t\t\t\t\t\t\t<table width=\"960\" border=\"1\" cellpadding=\"1\" cellspacing=\"0\" bordercolor=\"#FFFFFF\" bordercolorlight=\"#626262\" bordercolordark=\"White\" bgcolor=\"#FFFFFF\" class=\"tblbc\" valign=\"TOP\" style=\"table-layout:fixed\">\t\t\t\t\t\t\t\t\t\t\t\r\n");
	if( objVal != null ) 
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

      out.write("\r\n");
      out.write("\t\t\t\t\t\t\t\t\t<tr class=");
      out.print(cssClass);
      out.write(">\r\n");
      out.write("\r\n");
      out.write("\t\t\t\t\t\t\t\t\t\r\n");
      out.write("\t\t\t\t\t\t\t\t\t\r\n");
      out.write("\t\t\t\t\t\t\t\t\t\t<td width=\"100\">");
      out.print(vo.getIfd());
      out.write("</td>\r\n");
      out.write("\t\t\t\t\t\t\t\t\t\t<td width=80>");
      out.print(vo.getTc());
      out.write("</td>\r\n");
      out.write("\t\t\t\t\t\t\t\t\t\t<td width=80>");
      out.print(vo.getSc());
      out.write("</td>\r\n");
      out.write("\t\t\t\t\t\t\t\t\t\t<td width=80>");
      out.print(vo.getCode());
      out.write("</td>\r\n");
      out.write("\t\t\t\t\t\t\t\t\t\t<td width=80>");
      out.print(vo.getEst());
      out.write("</td>\r\n");
      out.write("\t\t\t\t\t\t\t\t\t\t<td width=80>");
      out.print(vo.getErt());
      out.write("</td>\r\n");
      out.write("\t\t\t\t\t\t\t\t\t\t<td width=250 style=\"text-align:left;word-break:break-all\">");
      out.print(vo.getMsg());
      out.write("</td>\r\n");
      out.write("\t\t\t\t\t\t\t\t\t\t<td width=%><textarea id=\"sdata\" readonly cols=\"30\" rows=\"5\" class=\"txtarea\" style=\"width:%;height:90;border-width:1px;cursor:hand\" onClick=\"copyData(this)\" >");
      out.print(vo.getSdata()==null?"&nbsp;":vo.getSdata());
      out.write("</textarea></td>\r\n");
      out.write("\t\t\t\t\t\t\t\t\t</tr>\t\t\t\r\n");
			last_ifid = curr_ifid;		
		}
		if( objVal == null || objVal.size() == 0) {	

      out.write("\t\t\t\t\t\t\t\t\t<tr height=21><td colspan=9 align=center>검색된 결과가 없습니다.</td></tr>\r\n");
		}		
	}

      out.write("\r\n");
      out.write("\t\t\t\t\t\t\t\t</table>\r\n");
      out.write("\t\t\t\t\t\t\t\t</DIV>\t\t    \t\t\t\t\t  \t\t\t\t\r\n");
      out.write("\t\t    \t\t\t\t</td>\r\n");
      out.write("\t\t\t\t\t\t</tr>\r\n");
      out.write("    \t\t\t\t</table>\r\n");
      out.write("    \t\t\t</td>\r\n");
      out.write("    \t\t</tr>\r\n");
      out.write("    \t</table>\r\n");
      out.write("              <!-- 페이지 -->\r\n");
 if( objVal != null && objVal.size() != 0 && jpage != null) { 
      out.write(" \t\t\t\r\n");
      out.write("              ");
      out.print(jpage.getTag());
      out.write('\r');
      out.write('\n');
 } 
      out.write("    \t\r\n");
      out.write("<script>\r\n");
      out.write("function scrollX() {\r\n");
      out.write("\tdocument.all.mainDisplay.scrollLeft = document.all.bottomLine.scrollLeft;\r\n");
      out.write("\tdocument.all.topLine.scrollLeft = document.all.bottomLine.scrollLeft;\r\n");
      out.write("}\r\n");
      out.write("function scrollY() {\r\n");
      out.write("\t//document.all.leftDisplay.scrollTop = document.all.mainDisplay.scrollTop;\r\n");
      out.write("}\r\n");
      out.write("</script>\t\r\n");
      out.write("\r\n");
      out.write("<!--copyright-->\r\n");
      out.write("<table width=\"30\" height=\"10\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\">\r\n");
      out.write("\t<tr>\r\n");
      out.write("\t\t<td>&nbsp;</td>\r\n");
      out.write("\t</tr>\r\n");
      out.write("</table>\r\n");
      out.write("\r\n");
      out.write("<table width=\"980\"  border=\"0\" cellpadding=\"0\" cellspacing=\"0\">\r\n");
      out.write("\t<tr>\r\n");
      out.write("\t\t<td align=\"center\" >Copyright ⓒ <a href=\"http://www.posdata.co.kr\" target=\"_blank\">POSDATA</a>. All Rrights Reserved. </td>\r\n");
      out.write("\t</tr>\r\n");
      out.write("</table>\r\n");
      out.write("<!--copyright 끝-->\r\n");
      out.write("\r\n");
      out.write("</form>\r\n");
      out.write("</body>\r\n");
      out.write("</html>\r\n");
    } catch (Throwable t) {
      if (!(t instanceof SkipPageException)){
        out = _jspx_out;
        if (out != null && out.getBufferSize() != 0)
          out.clearBuffer();
        if (_jspx_page_context != null) _jspx_page_context.handlePageException(t);
      }
    } finally {
      if (_jspxFactory != null) _jspxFactory.releasePageContext(_jspx_page_context);
    }
  }
}
