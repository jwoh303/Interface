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
import com.posdata.glue.util.log.PosLog;
import com.posdata.eai.manager.vo.*;
import com.posdata.eai.manager.util.JITPage;
import com.posdata.glue.dao.vo.*;
import java.util.*;

public final class eventAudit_jsp extends org.apache.jasper.runtime.HttpJspBase
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

	PosContext ctx = (PosContext)request.getAttribute( "PosContext" );
	
	// 현재날짜
	
	 //out.println("Session :" + ctx.getAllSessionAttrs().get("ID"));
	java.text.SimpleDateFormat dateFormat = new java.text.SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
	java.text.SimpleDateFormat dateFormat1 = new java.text.SimpleDateFormat("yyyy-MM-dd");
	String currentDate = null;
	if (request.getParameter("sendDate") == null) {
		currentDate = dateFormat1.format(new java.util.Date());
	} else {
		currentDate = (String) request.getParameter("sendDate");
	}
	//PosRowSet rowSet = (PosRowSet)ctx.get("empResult");
	//while(rowSet.hasNext()){
	//    PosRow row = rowSet.next(); 
 	//}
	//List objVal = (ArrayList)request.getAttribute("staticsEventAudit");
	List objVal = new ArrayList();
	try {
		if(ctx!=null && ctx.get("staticsEventAudit")!=null) 
			objVal = (ArrayList)ctx.get("staticsEventAudit");
	}
	catch(Exception e) {
		out.println(e);
	}

	int totalCount = 0;
	String code = null;
	
	if (objVal != null)
	{
		for(int i=0; i<objVal.size(); i++) {
			ServiceEventAuditVO vo = (ServiceEventAuditVO)objVal.get(i);
			code = vo.getCode();
			if(code != null && !code.equals("합계"))
			{
				totalCount++;
			}
		}
	}


      out.write("\r\n");
      out.write("\r\n");
      out.write("<html>\r\n");
      out.write("<head>\r\n");
      out.write("\r\n");
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
      out.write("function execute() \r\n");
      out.write("{\r\n");
      out.write("\t//Retry 방지 start\r\n");
      out.write("\tif( isWaiting == 'true' )\r\n");
      out.write("\t{\r\n");
      out.write("\t\talert(\"조회 중 입니다!\");\r\n");
      out.write("\t\treturn;\r\n");
      out.write("    \t}\r\n");
      out.write("    \tisWaiting = 'true';\r\n");
      out.write("    \t//Retry 방지 end\r\n");
      out.write("\r\n");
      out.write("\tsearching();\r\n");
      out.write("    \tdocument.forms[0].submit();\r\n");
      out.write("}\r\n");
      out.write("</script>\r\n");
      out.write("</head>\r\n");
      out.write("\r\n");
      out.write("<body topmargin=0 leftmargin=0 onLoad=\"MM_preloadImages('img/ucube_img04_menu_over.gif','img/ucube_img05_menu_over.gif','img/ucube_img06_menu_over.gif','img/ucube_img07_menu_over.gif','img/ucube_img08_menu_over.gif','img/clock.gif')\">\r\n");
      out.write("<form method=\"post\" action=\"eventAudit.do\">\r\n");
      out.write("<input type=\"hidden\" name=\"ServiceName\" value=\"eventAudit-service\" />\r\n");
      out.write("<input type=\"hidden\" name=\"find.x\" value=\"1\" />\r\n");
      out.write("\r\n");
      out.write("<div style=\"display:none\"><img src='img/clock.gif'></div>\r\n");
      out.write("<!-- 풍선도움말 -->\r\n");
      out.write("<div id=\"balloonHint\" style=\"display:none\">\r\n");
      out.write("<table border=\"0\" cellspacing=\"0\" cellpadding=\"3\" bgcolor=\"#FFFFCC\" style=\"border:1px solid #CC3300\">\r\n");
      out.write("<tr><td style=\"font-size:12px\">도움말</td></tr>\r\n");
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
      out.write("\r\n");
      out.write("\t\t<table width=\"980\" border=\"0\" cellspacing=\"0\" cellpadding=\"0\">\r\n");
      out.write("\t\t\t<tr bgcolor=white> \r\n");
      out.write("\t\t\t\t<td height=25> \r\n");
      out.write("\t\t\t\t\t<table width=\"980\" height=\"25\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\">\r\n");
      out.write("\t\t\t\t\t\t<tr>\r\n");
      out.write("\t\t\t\t\t\t\t<td>\r\n");
      out.write("\t\t\t\t\t\t\t\t<img src=\"img/comm_img02_blank.gif\" width=\"5\" height=\"10\">\r\n");
      out.write("\t\t\t\t\t\t\t\t<img src=\"img/comm_img03_ic.gif\" width=\"11\" height=\"10\">\r\n");
      out.write("\t\t\t\t\t\t\t\t<span class=\"bluetit\"><img src=\"img/comm_img02_blank.gif\" width=\"5\" height=\"10\"></span>\r\n");
      out.write("\t\t\t\t\t\t\t\t<span class=\"tit01\">Hourly Statistical Data</span>\r\n");
      out.write("\t\t\t\t\t\t\t</td>\r\n");
      out.write("\t\t\t\t\t\t</tr>\r\n");
      out.write("\t\t\t\t\t</table>\r\n");
      out.write("\t\t\t\t</td>\r\n");
      out.write("\t\t\t</tr>\r\n");
      out.write("\t\t\t<tr><!--tr5 start --> \r\n");
      out.write("        \t\t<td align=center bgcolor=white>\r\n");
      out.write("        \t\t\t<!--검색조건-->\r\n");
      out.write("        \t\t\t<table width=\"980\"  border=\"1\" cellpadding=\"2\" cellspacing=\"0\" bordercolor=\"#FFFFFF\" bgcolor=\"#FFFFFF\" >\r\n");
      out.write("\t\t\t\t\t\t<tr>\r\n");
      out.write("\t\t\t\t\t    \t<td height=\"25\" bordercolor=\"999999\" bgcolor=\"F8F3E8\">            \r\n");
      out.write("\t\t\t\t\t        \t<table width=\"100%\"  border=\"0\" cellpadding=\"0\" cellspacing=\"0\" class=\"search\">\r\n");
      out.write("\t\t\t\t\t            \t<tr>\r\n");
      out.write("\t\t\t\t\t              \t\t<td width=\"150\">\r\n");
      out.write("\t\t\t\t\t              \t\t\t<img src=\"img/comm_img02_blank.gif\" width=\"10\" height=\"10\">\r\n");
      out.write("\t\t\t\t\t              \t\t\t<img src=\"img/comm_img06_ic.gif\" width=\"10\" height=\"3\"> <b>구분 : </b>\r\n");
      out.write("\t\t\t\t\t                  \t\t<select name=\"select\" Class=\"adf\">\r\n");
      out.write("\t\t\t\t\t\t\t\t\t\t\t\t<option value=\"SYSTEM\">시스템</option>\r\n");
      out.write("\t\t\t\t\t\t\t\t\t\t\t\t<option value=\"SERVICE\">서비스</option>\r\n");
      out.write("\t\t\t\t\t\t\t\t\t\t    </select>\r\n");
      out.write("\t\t\t\t\t\t\t\t\t\t\t<img src=\"img/comm_img02_blank.gif\" width=\"10\" height=\"10\"> \r\n");
      out.write("\t\t\t\t\t\t\t\t\t\t</td>\r\n");
      out.write("\t\t\t\t\t              \t\t<td width=\"150\">\r\n");
      out.write("\t\t\t\t\t              \t\t\t<img src=\"img/comm_img06_ic.gif\" width=\"10\" height=\"3\"> <b>날짜 : </b>                \r\n");
      out.write("\t\t\t\t\t              \t\t\t<input type=\"text\" name=\"sendDate\" value=\"");
      out.print(currentDate );
      out.write("\" size=\"10\" maxlength=\"15\" Class=\"adb1\" onblur=\"this.className='adb1'\" onfocus=\"this.className='adf1'\" readonly=\"true\" />                \r\n");
      out.write("\t\t\t\t\t              \t\t\t<img src=\"img/comm_img04_cal.gif\" width=\"14\" height=\"13\" onclick=\"showCalendar('sendDate','','','YYYY/MONTH/DD','',1,'','',2,true,'',true,'','false',false,false)\" style=\"cursor:hand\">              \r\n");
      out.write("\t\t\t\t\t              \t\t</td>\r\n");
      out.write("\t\t\t\t\t              \t\t<td height=\"25\" valign=\"middle\" align=\"right\">\r\n");
      out.write("\t\t\t\t\t              \t\t\t<img src=\"img/comm_img07_but.gif\" width=\"55\" height=\"21\" style=\"cursor:hand\" align=\"absmiddle\" onclick=\"execute()\">\r\n");
      out.write("\t\t\t\t\t              \t\t\t<img src=\"img/comm_img08_but.gif\" width=\"55\" height=\"21\" style=\"cursor:hand\" align=\"absmiddle\" onclick=\"openHelp()\">\r\n");
      out.write("\t\t\t\t\t              \t\t\t<img src=\"img/comm_img02_blank.gif\" width=\"5\" height=\"10\"> \r\n");
      out.write("\t\t\t\t\t              \t\t</td>\r\n");
      out.write("\t\t\t\t\t            \t</tr>\r\n");
      out.write("\t\t\t\t\t          \t</table>\t  \r\n");
      out.write("\t\t\t\t\t       \t</td>\r\n");
      out.write("\t\t\t\t\t\t</tr>\t  \r\n");
      out.write("\t\t\t\t\t</table>\r\n");
      out.write("\t        \t\t<!--검색조건 끝--> \r\n");
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
      out.write("\t\t\r\n");
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
      out.write("\t\t\t\t\t\t\t\t\t<tr> \r\n");
	if( "SERVICE".equals(request.getParameter("select")) ) {	
      out.write("\r\n");
      out.write("\t\t\t\t\t\t\t\t\t\t<td rowspan=2 width=120 style=\"padding:0 0 0 5;\">서비스명</td>\r\n");
	} 
      out.write("\r\n");
      out.write("\t\t\t\t\t\t\t\t\t\t<td rowspan=2 width=80>시스템 <br>이름</td>\r\n");
      out.write("\t\t\t\t\t\t\t\t\t\t<td rowspan=2 width=60>송수신<br>구분</td>\r\n");
      out.write("\t\t\t\t\t\t\t\t\t\t<td rowspan=2 width=40>합계</td>\r\n");
      out.write("\t\t\t\t\t\t\t\t\t\t<td colspan=24 width=624 height=\"20\">시간</td>\r\n");
      out.write("\t\t\t\t\t\t\t\t\t</tr>\r\n");
      out.write("\t\t\t\t\t\t\t\t\t<tr> \r\n");
      out.write("\t\t\t\t\t\t\t\t\t\t<td width=26 class=\"tblcb3\" height=\"20\">00</td>\r\n");
      out.write("\t\t\t\t\t\t\t\t\t\t<td width=26 class=\"tblcb3\">01</td>\r\n");
      out.write("\t\t\t\t\t\t\t\t\t\t<td width=26 class=\"tblcb3\">02</td>\r\n");
      out.write("\t\t\t\t\t\t\t\t\t\t<td width=26 class=\"tblcb3\">03</td>\r\n");
      out.write("\t\t\t\t\t\t\t\t\t\t<td width=26 class=\"tblcb3\">04</td>\r\n");
      out.write("\t\t\t\t\t\t\t\t\t\t<td width=26 class=\"tblcb3\">05</td>\r\n");
      out.write("\t\t\t\t\t\t\t\t\t\t<td width=26 class=\"tblcb3\">06</td>\r\n");
      out.write("\t\t\t\t\t\t\t\t\t\t<td width=26 class=\"tblcb3\">07</td>\r\n");
      out.write("\t\t\t\t\t\t\t\t\t\t<td width=26 class=\"tblcb3\">08</td>\r\n");
      out.write("\t\t\t\t\t\t\t\t\t\t<td width=26 class=\"tblcb3\">09</td>\r\n");
      out.write("\t\t\t\t\t\t\t\t\t\t<td width=26 class=\"tblcb3\">10</td>\r\n");
      out.write("\t\t\t\t\t\t\t\t\t\t<td width=26 class=\"tblcb3\">11</td>\r\n");
      out.write("\t\t\t\t\t\t\t\t\t\t<td width=26 class=\"tblcb3\">12</td>\r\n");
      out.write("\t\t\t\t\t\t\t\t\t\t<td width=26 class=\"tblcb3\">13</td>\r\n");
      out.write("\t\t\t\t\t\t\t\t\t\t<td width=26 class=\"tblcb3\">14</td>\r\n");
      out.write("\t\t\t\t\t\t\t\t\t\t<td width=26 class=\"tblcb3\">15</td>\r\n");
      out.write("\t\t\t\t\t\t\t\t\t\t<td width=26 class=\"tblcb3\">16</td>\r\n");
      out.write("\t\t\t\t\t\t\t\t\t\t<td width=26 class=\"tblcb3\">17</td>\r\n");
      out.write("\t\t\t\t\t\t\t\t\t\t<td width=26 class=\"tblcb3\">18</td>\r\n");
      out.write("\t\t\t\t\t\t\t\t\t\t<td width=26 class=\"tblcb3\">19</td>\r\n");
      out.write("\t\t\t\t\t\t\t\t\t\t<td width=26 class=\"tblcb3\">20</td>\r\n");
      out.write("\t\t\t\t\t\t\t\t\t\t<td width=26 class=\"tblcb3\">21</td>\r\n");
      out.write("\t\t\t\t\t\t\t\t\t\t<td width=26 class=\"tblcb3\">22</td>\r\n");
      out.write("\t\t\t\t\t\t\t\t\t\t<td width=26 class=\"tblcb3\">23</td>\r\n");
      out.write("\t\t\t\t\t\t\t\t\t</tr>\t\t\t\t\t\t\t\t\t\r\n");
      out.write("\t\t\t\t\t\t\t\t</table>\r\n");
      out.write("\t\t\t\t\t\t\t\t</div>\r\n");
      out.write("\t\t\t\t\t\t\t\t<DIV id=\"mainDisplay\" style=\"width:980px;height:340px;overflow-y:scroll;overflow-x:hidden\" onscroll=\"scrollY()\">\r\n");
      out.write("\t\t\t\t\t\t\t\t<table width=\"960\" border=\"1\" cellpadding=\"1\" cellspacing=\"0\" bordercolor=\"#FFFFFF\" bordercolorlight=\"#626262\" bordercolordark=\"White\" bgcolor=\"#FFFFFF\" class=\"tblbc\" valign=\"TOP\" style=\"table-layout:fixed\">\r\n");
	if( objVal != null ) 
	{
		String last_data = null; String curr_data = null;
		boolean sameData = false;
		String cssClass = "tblcg";
		
		for(int i=0; i<objVal.size(); i++) {
			ServiceEventAuditVO vo = (ServiceEventAuditVO)objVal.get(i);
			
			if("SERVICE".equals(request.getParameter("select"))) {
				curr_data = vo.getCode()==null?"":vo.getCode();
			} else {
				curr_data = vo.getCode()==null?"":vo.getCode();
			}
			if( i==0 ) last_data = curr_data;
			
			// 같은 IF ID를 사용할 경우 다음 라인에서 출력하지 않음
			if(i!=0 && last_data.equals(curr_data)) sameData = true;
			else {
				sameData = false;
				cssClass = "tblcg".equals(cssClass)==true?"tblcw":"tblcg";
			}

      out.write("\r\n");
      out.write("\t\t\t\t\t\t\t\t\t<tr class=");
      out.print(cssClass);
      out.write('>');
      out.write('\r');
      out.write('\n');
	if ( "SERVICE".equals(request.getParameter("select")) ) {	
      out.write("\r\n");
      out.write("\t\t\t\t\t\t\t\t\t\t<td width=\"120\" style=\"padding:0 0 0 5;\">");
      out.print(vo.getCode());
      out.write("</td>\r\n");
      out.write("\t\t\t\t\t\t\t            <td width=\"80\"  style=\"padding:0 0 0 5;\">");
      out.print((vo.getSystem()==null||vo.getSystem().equals(""))?"&nbsp;":vo.getSystem());
      out.write("</td>\t\r\n");
 	}else {	
      out.write("\t\t\t\t\t\t\t\t\t\r\n");
      out.write("\t\t\t\t\t\t\t\t\t\t<td width=\"80\">");
      out.print(vo.getCode());
      out.write("</td>\r\n");
 } 
      out.write("\r\n");
      out.write("\t\t\t\t\t\t\t\t\t\t<td width=60>");
      out.print(vo.getSrc());
      out.write("</td>\r\n");
      out.write("\t\t\t\t\t\t\t\t\t\t<td width=40 style=\"padding:0 3 0 0;text-align:right\">");
      out.print(vo.getTot());
      out.write("</td>\r\n");
      out.write("\t\t\t\t\t\t\t\t\t\t<td width=26 style=\"padding:0 3 0 0;text-align:right\">");
      out.print(vo.getT00());
      out.write("</td>\r\n");
      out.write("\t\t\t\t\t\t\t\t\t\t<td width=26 style=\"padding:0 3 0 0;text-align:right\">");
      out.print(vo.getT01());
      out.write("</td>\r\n");
      out.write("\t\t\t\t\t\t\t\t\t\t<td width=26 style=\"padding:0 3 0 0;text-align:right\">");
      out.print(vo.getT02());
      out.write("</td>\r\n");
      out.write("\t\t\t\t\t\t\t\t\t\t<td width=26 style=\"padding:0 3 0 0;text-align:right\">");
      out.print(vo.getT03());
      out.write("</td>\r\n");
      out.write("\t\t\t\t\t\t\t\t\t\t<td width=26 style=\"padding:0 3 0 0;text-align:right\">");
      out.print(vo.getT04());
      out.write("</td>\r\n");
      out.write("\t\t\t\t\t\t\t\t\t\t<td width=26 style=\"padding:0 3 0 0;text-align:right\">");
      out.print(vo.getT05());
      out.write("</td>\r\n");
      out.write("\t\t\t\t\t\t\t\t\t\t<td width=26 style=\"padding:0 3 0 0;text-align:right\">");
      out.print(vo.getT06());
      out.write("</td>\r\n");
      out.write("\t\t\t\t\t\t\t\t\t\t<td width=26 style=\"padding:0 3 0 0;text-align:right\">");
      out.print(vo.getT07());
      out.write("</td>\r\n");
      out.write("\t\t\t\t\t\t\t\t\t\t<td width=26 style=\"padding:0 3 0 0;text-align:right\">");
      out.print(vo.getT08());
      out.write("</td>\r\n");
      out.write("\t\t\t\t\t\t\t\t\t\t<td width=26 style=\"padding:0 3 0 0;text-align:right\">");
      out.print(vo.getT09());
      out.write("</td>\r\n");
      out.write("\t\t\t\t\t\t\t\t\t\t<td width=26 style=\"padding:0 3 0 0;text-align:right\">");
      out.print(vo.getT10());
      out.write("</td>\r\n");
      out.write("\t\t\t\t\t\t\t\t\t\t<td width=26 style=\"padding:0 3 0 0;text-align:right\">");
      out.print(vo.getT11());
      out.write("</td>\r\n");
      out.write("\t\t\t\t\t\t\t\t\t\t<td width=26 style=\"padding:0 3 0 0;text-align:right\">");
      out.print(vo.getT12());
      out.write("</td>\r\n");
      out.write("\t\t\t\t\t\t\t\t\t\t<td width=26 style=\"padding:0 3 0 0;text-align:right\">");
      out.print(vo.getT13());
      out.write("</td>\r\n");
      out.write("\t\t\t\t\t\t\t\t\t\t<td width=26 style=\"padding:0 3 0 0;text-align:right\">");
      out.print(vo.getT14());
      out.write("</td>\r\n");
      out.write("\t\t\t\t\t\t\t\t\t\t<td width=26 style=\"padding:0 3 0 0;text-align:right\">");
      out.print(vo.getT15());
      out.write("</td>\r\n");
      out.write("\t\t\t\t\t\t\t\t\t\t<td width=26 style=\"padding:0 3 0 0;text-align:right\">");
      out.print(vo.getT16());
      out.write("</td>\r\n");
      out.write("\t\t\t\t\t\t\t\t\t\t<td width=26 style=\"padding:0 3 0 0;text-align:right\">");
      out.print(vo.getT17());
      out.write("</td>\r\n");
      out.write("\t\t\t\t\t\t\t\t\t\t<td width=26 style=\"padding:0 3 0 0;text-align:right\">");
      out.print(vo.getT18());
      out.write("</td>\r\n");
      out.write("\t\t\t\t\t\t\t\t\t\t<td width=26 style=\"padding:0 3 0 0;text-align:right\">");
      out.print(vo.getT19());
      out.write("</td>\r\n");
      out.write("\t\t\t\t\t\t\t\t\t\t<td width=26 style=\"padding:0 3 0 0;text-align:right\">");
      out.print(vo.getT20());
      out.write("</td>\r\n");
      out.write("\t\t\t\t\t\t\t\t\t\t<td width=26 style=\"padding:0 3 0 0;text-align:right\">");
      out.print(vo.getT21());
      out.write("</td>\r\n");
      out.write("\t\t\t\t\t\t\t\t\t\t<td width=26 style=\"padding:0 3 0 0;text-align:right\">");
      out.print(vo.getT22());
      out.write("</td>\r\n");
      out.write("\t\t\t\t\t\t\t\t\t\t<td width=26 style=\"padding:0 3 0 0;text-align:right\">");
      out.print(vo.getT23());
      out.write("</td>\t\t\t\t\t\t\t\t\t\t\t\r\n");
      out.write("\t\t\t\t\t\t\t\t\t</tr>\t\t\t\r\n");
			last_data = curr_data;		
		}
		if( objVal != null && objVal.size() == 0) {	

      out.write("\t\t\t\t\t\t\t\t\t<tr height=21><td colspan=27 align=center>검색된 결과가 없습니다.</td></tr>\r\n");
		}	
	} 
      out.write("\r\n");
      out.write("\r\n");
      out.write("\t\t\t\t\t\t\t\t</table>\r\n");
      out.write("\t\t\t\t\t\t\t\t</DIV>\t\t    \t\t\t\t\t  \t\t\t\t\r\n");
      out.write("\t\t    \t\t\t\t</td>\r\n");
      out.write("\t\t\t\t\t\t</tr>\r\n");
      out.write("    \t\t\t\t</table>\r\n");
      out.write("    \t\t\t</td>\r\n");
      out.write("    \t\t</tr>\r\n");
      out.write("    \t</table>\r\n");
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
