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
import com.posdata.eai.manager.util.*;
import java.util.*;

public final class serviceStatusMonitor_jsp extends org.apache.jasper.runtime.HttpJspBase
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
      out.write("\t\t\t\t\t\r\n");
      out.write("\r\n");
      out.write("\r\n");
      out.write("\r\n");

	PosContext ctx = (PosContext)request.getAttribute( "PosContext" );

	// 현재날짜
	java.text.SimpleDateFormat dateFormat = new java.text.SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
	java.text.SimpleDateFormat dateFormat1 = new java.text.SimpleDateFormat("yyyy-MM-dd");
	String currentDate = null;
	if (request.getParameter("date") == null) {
		currentDate = dateFormat1.format(new java.util.Date());
	} else {
		currentDate = (String) request.getParameter("date");
	}
    
	List objVal = new ArrayList();
	List sectionList = new ArrayList();

	try {
		if(ctx!=null && ctx.get("serviceStatusMonitor")!=null) {
			objVal = (ArrayList)ctx.get("serviceStatusMonitor");
		}
	}
	catch(Exception e) {
		out.println(e);
	}
				
	try {
		if(ctx!=null && ctx.get("sectionList")!=null) {
			sectionList = (ArrayList)ctx.get("sectionList");
		}
	}
	catch(Exception e) {
		out.println(e);
	}
	
	int totalCount = objVal==null?0:objVal.size();

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
      out.write("<script language=\"javascript\" src=\"js/selectAll.js\"></script>\r\n");
      out.write("<script type=\"text/javascript\">\r\n");
      out.write("\r\n");
      out.write("function execute() \r\n");
      out.write("{\r\n");
      out.write("\t//alert(\"execute() \" + isWaiting);\r\n");
      out.write("\t//Retry 방지 start\r\n");
      out.write("\tif( isWaiting == 'true' )\r\n");
      out.write("\t{\r\n");
      out.write("\t\talert(\"조회 중 입니다!\");\r\n");
      out.write("\t\treturn;\r\n");
      out.write("    }\r\n");
      out.write("    isWaiting = 'true';\r\n");
      out.write("    \r\n");
      out.write("    //Retry 방지 end\r\n");
      out.write("\t\r\n");
      out.write("\t//업무 구분이 ALL 일경우에는 서비스 이름 혹은 링크이름에 값이 있어야한다 없을 경우 ALERT\r\n");
      out.write("//\tif(document.forms[0].section.value == \"ALL\" && document.forms[0].serviceName.value == \"\" && document.forms[0].linkName.value == \"\" && document.forms[0].hostName.value == \"\")\r\n");
      out.write("//\t{\r\n");
      out.write("//\t\talert(\"업무 구분에 ALL을 선택하였을 경우 서비스 이름 또는 링크이름은 필수 입력값입니다.\");\r\n");
      out.write("//\t\tisWaiting = 'false';\r\n");
      out.write("//\t\treturn;\r\n");
      out.write("//\t}\r\n");
      out.write("    \t\r\n");
      out.write("\tcheckPeriod(document.forms[0].refreshTime.value);\r\n");
      out.write("\t//일반 조회\r\n");
      out.write("\t//searching();\r\n");
      out.write("    //document.forms[0].submit();\r\n");
      out.write("    //Ajax\r\n");
      out.write("    getServerData();\r\n");
      out.write("}\r\n");
      out.write("function checkPeriod(num)\r\n");
      out.write("{\r\n");
      out.write("\t\r\n");
      out.write("\tif (checkDigit(num) == false || num < 10)\r\n");
      out.write("\t{\r\n");
      out.write("\t\tdocument.forms[0].refreshTime.value = 10;\r\n");
      out.write("\t\talert(\"최소 값은 10 입니다\");\r\n");
      out.write("\t\treturn 10;\r\n");
      out.write("\t}else\t{\r\n");
      out.write("\t\treturn num;\r\n");
      out.write("\t}\r\n");
      out.write("}\r\n");
      out.write("function saveClick(event)\r\n");
      out.write("{\r\n");
      out.write("\tvar objCheck = document.all.sequence;\r\n");
      out.write("\tif(objCheck==null) return;\r\n");
      out.write("\t\r\n");
      out.write("\tvar message = \"\";\r\n");
      out.write("\tif(event==\"edit\") message = \"정말로 수정하시겠습니까?\";\r\n");
      out.write("\telse if (event==\"delete\") message = \"정말로 삭제하시겠습니까?\";\r\n");
      out.write("\telse {\r\n");
      out.write("\t\talert(\"잘못된 요청정보입니다.\"); return;\r\n");
      out.write("\t}\r\n");
      out.write("\t\r\n");
      out.write("\tvar selectcount = 0;\r\n");
      out.write("\tif( objCheck.length == null) {\r\n");
      out.write("\t\tif(objCheck.checked) selectcount++;\r\n");
      out.write("\t} else {\r\n");
      out.write("\t\tfor(idx=0;idx<objCheck.length;idx++) {\r\n");
      out.write("\t\t\tif( objCheck[idx].checked ) { selectcount++; break; }\r\n");
      out.write("\t\t}\r\n");
      out.write("\t}\r\n");
      out.write("\tif( selectcount == 0 ) {\r\n");
      out.write("\t\tif (event==\"edit\") alert(\"수정할 항목을 선택하세요\"); \r\n");
      out.write("\t\telse alert(\"삭제할 항목을 선택하세요\"); \r\n");
      out.write("\t}\r\n");
      out.write("\telse {\r\n");
      out.write("\t\tif(confirm(message)) {\r\n");
      out.write("\t\t\tdocument.forms[0].actionFlag.value = event;\r\n");
      out.write("\t\t\tdocument.forms[0].submit();\r\n");
      out.write("\t\t}\r\n");
      out.write("\t}\r\n");
      out.write("}\r\n");
      out.write("</script>\r\n");
      out.write("</head>\r\n");
      out.write("\r\n");
      out.write("<body topmargin=0 leftmargin=0 onLoad=\"MM_preloadImages('img/ucube_img04_menu_over.gif','img/ucube_img05_menu_over.gif','img/ucube_img06_menu_over.gif','img/ucube_img07_menu_over.gif','img/ucube_img08_menu_over.gif','img/clock.gif')\">\r\n");
      out.write("<form method=\"post\" action=\"serviceStatusMonitor.do\">\r\n");
      out.write("<input type=\"hidden\" name=\"ServiceName\" value=\"serviceStatusMonitor-service\" />\r\n");
      out.write("<input type=\"hidden\" name=\"find.x\" value=\"1\" />\r\n");
      out.write("\r\n");
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
      out.write("<input type=\"hidden\" name=\"actionFlag\" value=\"\">\r\n");
      out.write("<input type=\"hidden\" name=\"asyncRefresh\" value=\"\">\r\n");
      out.write("\r\n");
      out.write("\t\t<table width=\"980\" border=\"0\" cellspacing=\"0\" cellpadding=\"0\">\r\n");
      out.write("\t\t\t<tr bgcolor=white> \r\n");
      out.write("\t\t\t\t<td height=25> \r\n");
      out.write("\t\t\t\t\t<table width=\"980\" height=\"25\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\">\r\n");
      out.write("\t\t\t\t\t\t<tr>\r\n");
      out.write("\t\t\t\t\t\t\t<td>\r\n");
      out.write("\t\t\t\t\t\t\t\t<img src=\"img/comm_img02_blank.gif\" width=\"5\" height=\"10\"><img src=\"img/comm_img03_ic.gif\" width=\"11\" height=\"10\"><span class=\"bluetit\"><img src=\"img/comm_img02_blank.gif\" width=\"5\" height=\"10\"></span>\r\n");
      out.write("\t\t\t\t\t\t\t\t<span class=\"tit01\">Service Status Monitor</span>\r\n");
      out.write("\t\t\t\t\t\t\t</td>\r\n");
      out.write("\t\t\t\t\t\t</tr>\r\n");
      out.write("\t\t\t\t\t</table>\r\n");
      out.write("\t\t\t\t</td>\r\n");
      out.write("\t\t\t</tr>\t\t\r\n");
      out.write("\t\t\t<tr><!--tr5 start --> \r\n");
      out.write("        \t\t<td align=center bgcolor=white>\r\n");
      out.write("        \t\t\t<!--검색조건-->\r\n");
      out.write("        \t\t\t<table width=\"980\"  border=\"1\" cellpadding=\"2\" cellspacing=\"0\" bordercolor=\"#FFFFFF\" bgcolor=\"#FFFFFF\" >\r\n");
      out.write("\t        \t\t\t<tr> \r\n");
      out.write("\t        \t\t\t\t<td height=\"25\" bordercolor=\"999999\" bgcolor=\"F8F3E8\">            \r\n");
      out.write("\t\t\t\t\t        \t<table width=\"100%\"  border=\"0\" cellpadding=\"0\" cellspacing=\"0\" class=\"search\">\r\n");
      out.write("\t\t\t\t\t            \t<tr>\r\n");
      out.write("\t\t\t\t\t              \t\t<td width=\"%\">\r\n");
      out.write("\t\t\t\t\t              \t\t\t<img src=\"img/comm_img02_blank.gif\" width=\"%\"  height=\"10\">\r\n");
      out.write("\t\t\t\t\t              \t\t\t<img src=\"img/comm_img06_ic.gif\" width=\"10\" height=\"3\"> <b>업부구분 : </b>\r\n");
      out.write("\t\t\t\t\t                  \t\t<select name=\"section\" Class=\"adf\">\r\n");
      out.write("\t\t\t\t\t\t\t\t\t\t\t\t<option value=\"STOP\">STOP</option>\r\n");
      out.write("\t\t\t\t\t\t\t\t\t\t\t\t<option value=\"ALL\">ALL</option>\r\n");
      out.write("\t\t\t\t\t\t\t\t\t\t    </select>\r\n");
      out.write("\t\t\t\t\t\t\t\t\t\t\t<img src=\"img/comm_img02_blank.gif\" width=\"%\" height=\"10\"> \r\n");
      out.write("\t\t\t\t\t\t\t\t\t\t</td>\r\n");
      out.write("\t\t\t\t\t\t\t\t\t\t<td width=\"%\">\r\n");
      out.write("\t\t\t\t\t              \t\t\t<img src=\"img/comm_img02_blank.gif\" width=\"%\"  height=\"10\">\r\n");
      out.write("\t\t\t\t\t              \t\t\t<img src=\"img/comm_img06_ic.gif\" width=\"10\" height=\"3\"> <b>시스템 이름 : </b>\r\n");
      out.write("\t\t\t\t\t                  \t\t<input type=\"text\" size=\"10\" maxlength=\"8\" name=\"hostName\" Class=\"adb1\" onblur=\"this.className='adb1'\" onfocus=\"this.className='adf1'\" />\r\n");
      out.write("\t\t\t\t\t\t\t\t\t\t\t<img src=\"img/comm_img02_blank.gif\" width=\"%\"  height=\"10\"> \r\n");
      out.write("\t\t\t\t\t\t\t\t\t\t</td>\r\n");
      out.write("\t\t\t\t\t\t\t\t\t\t<td width=\"%\">\r\n");
      out.write("\t\t\t\t\t              \t\t\t<img src=\"img/comm_img02_blank.gif\" width=\"%\"  height=\"10\">\r\n");
      out.write("\t\t\t\t\t              \t\t\t<img src=\"img/comm_img06_ic.gif\" width=\"10\" height=\"3\"> <b>서비스 이름 : </b>\r\n");
      out.write("\t\t\t\t\t                  \t\t<input type=\"text\" size=\"15\" maxlength=\"12\" name=\"serviceName\" Class=\"adb1\" onblur=\"this.className='adb1'\" onfocus=\"this.className='adf1'\" />\r\n");
      out.write("\t\t\t\t\t\t\t\t\t\t\t<img src=\"img/comm_img02_blank.gif\" width=\"%\" height=\"10\"> \r\n");
      out.write("\t\t\t\t\t\t\t\t\t\t</td>\r\n");
      out.write("\t\t\t\t\t\t\t\t\t\t<td width=\"%\">\r\n");
      out.write("\t\t\t\t\t              \t\t    <img src=\"img/comm_img02_blank.gif\" width=\"%\" height=\"10\">\r\n");
      out.write("\t\t\t\t\t\t\t\t\t\t    <img src=\"img/comm_img06_ic.gif\" width=\"10\" height=\"3\"> <b>링크 이름 : </b>\r\n");
      out.write("\t\t\t\t\t\t    \t            <input type=\"text\" size=\"10\" maxlength=\"8\" name=\"linkName\" Class=\"adb1\" onblur=\"this.className='adb1'\" onfocus=\"this.className='adf1'\" />\r\n");
      out.write("\t\t\t\t\t\t    \t            <img src=\"img/comm_img02_blank.gif\" width=\"%\" height=\"10\"> \r\n");
      out.write("\t\t\t\t\t\t    \t        </td>\r\n");
      out.write("\t\t\t\t\t\t\t\t\t\t<td width=\"%\">\r\n");
      out.write("\t\t\t\t\t              \t\t\t<img src=\"img/comm_img02_blank.gif\" width=\"%\"  height=\"10\">\r\n");
      out.write("\t\t\t\t\t              \t\t\t<img src=\"img/comm_img06_ic.gif\" width=\"10\" height=\"3\"> <b>갱신 주기 : </b>\r\n");
      out.write("\t\t\t\t\t                  \t\t<input type=\"text\" size=\"5\" maxlength=\"5\" name=\"refreshTime\" value=\"60\" Class=\"adb1\" />\r\n");
      out.write("\t\t\t\t\t\t\t\t\t\t\t<img src=\"img/comm_img02_blank.gif\" width=\"%\"  height=\"10\"> \r\n");
      out.write("\t\t\t\t\t\t\t\t\t\t\t<input type=\"hidden\" name=\"formName\" value=\"");
      out.print(request.getParameter("refreshTime"));
      out.write("\" />\r\n");
      out.write("\t\t\t\t\t\t\t\t\t\t</td>\r\n");
      out.write("\t\t\t\t\t              \t\t<td height=\"25\" valign=\"middle\" align=\"right\">\r\n");
      out.write("\t\t\t\t\t              \t\t\t<img src=\"img/comm_img07_but.gif\" width=\"55\" height=\"21\" style=\"cursor:hand\" align=\"absmiddle\" onclick=\"execute()\">\r\n");
      out.write("\t\t\t\t\t              \t\t\t<img src=\"img/comm_img08_but.gif\" width=\"55\" height=\"21\" style=\"cursor:hand\" align=\"absmiddle\" onclick=\"openHelp()\">\r\n");
      out.write("\t\t\t\t\t              \t\t\t<img src=\"img/comm_img02_blank.gif\" width=\"5\" height=\"10\"> \r\n");
      out.write("\t\t\t\t\t              \t\t</td>\r\n");
      out.write("\t\t\t\t\t            \t</tr>\r\n");
      out.write("\t\t\t\t\t          \t</table>\t  \r\n");
      out.write("\t\t\t\t\t       \t</td>\r\n");
      out.write("\t        \t\t\t</tr>\r\n");
      out.write("\t        \t\t</table>\r\n");
      out.write("\t        \t</td>\r\n");
      out.write("\t        </tr>  \r\n");
      out.write("\t\t\t<tr bgcolor=white>\r\n");
      out.write("\t\t\t\t<td height=25>\r\n");
      out.write("\t\t\t\t\t<table border=0 width=100%>\r\n");
      out.write("\t\t\t\t\t\t<tr>\r\n");
      out.write("\t\t\t\t\t\t\t<td width=5> </td>\r\n");
      out.write("\t\t\t\t\t\t\t<td width=% valign=bottom> \r\n");
      out.write("\t\t\t\t\t\t\t\t<img src=\"img/icon_critical.gif\"> Down\r\n");
      out.write("\t\t\t\t\t\t\t\t<img src=\"img/icon_error.gif\"> Error\r\n");
      out.write("\t\t\t\t\t\t\t\t<img src=\"img/icon_normal.gif\"> Normality\r\n");
      out.write("\t\t\t\t\t\t\t</td>\r\n");
      out.write("\t\t\t\t\t\t\t<td align=right width=300 valign=bottom><div id=\"totalCount\"></div></td>\r\n");
      out.write("\t\t\t\t\t\t\t\r\n");
      out.write("\t\t\t\t\t\t</tr>\r\n");
      out.write("\t\t\t\t\t</table>\r\n");
      out.write("\t\t\t\t</td> \t\r\n");
      out.write("\t\t\t</tr>\t\t\t        \t\t\r\n");
      out.write("\t\t</table>\r\n");
      out.write("\t\t<!-- data -->\r\n");
      out.write("   \t\t<table width=\"960\" height=400 border=0 cellpadding=\"0\" cellspacing=\"0\" bordercolorlight=FFFFFF  bordercolordark=FFFFFF>\r\n");
      out.write("\t\t\t<tr>\r\n");
      out.write("\t\t\t\t<td width=5> </td>\r\n");
      out.write("\t\t\t\t<td align=center valign=top>\r\n");
      out.write("\t\t\t\t\t<table width=960 border=0 cellpadding=0 cellspacing=0 bordercolorlight=666666 bordercolordark=FFFFFF>\r\n");
      out.write("\t\t    \t\t\t<tr>\r\n");
      out.write("\t\t    \t\t\t\t<td height=400 width=100% valign=top>\r\n");
      out.write("\t\t    \t\t\t\t\t<DIV id=\"topLine\" style=\"width:980px;overflow:hidden;\">\r\n");
      out.write("\t\t\t\t\t\t\t\t<table width=\"960\" border=\"1\" cellpadding=\"1\" cellspacing=\"0\" bordercolor=\"Black\" bordercolorlight=\"#626262\" bordercolordark=\"White\" class=\"tblcb1\" valign=\"TOP\" style=\"table-layout:fixed\">\r\n");
      out.write("\t\t\t\t\t\t\t\t\t<TR HEIGHT=40 CLASS=tbldb> \r\n");
      out.write("\t\t\t\t\t\t\t\t\t\t\r\n");
      out.write("\t\t\t\t\t\t\t\t\t\t<td width=100>시스템 이름</td>\r\n");
      out.write("\t\t\t\t\t\t\t\t\t\t<td width=200>서비스 이름</td>\r\n");
      out.write("\t\t\t\t\t\t\t\t\t\t<td width=160>링크 이름</td>\r\n");
      out.write("\t\t\t\t\t\t\t\t\t\t<td width=%>설 명</td>\r\n");
      out.write("\t\t\t\t\t\t\t\t\t\t<td width=100>상 태</td>\r\n");
      out.write("\t\t\t\t\t\t\t\t\t\t<td width=150>마지막 접속시간</td>\r\n");
      out.write("\t\t\t\t\t\t\t\t\t</tr>\r\n");
      out.write("\t\t\t\t\t\t\t\t</table>\r\n");
      out.write("\t\t\t\t\t\t\t\t</div>\r\n");
      out.write("\t\t\t\t\t\t\t\t<!--nom-->\r\n");
      out.write("\t\t\t\t\t\t\t\t<div id=\"dataTable\" style=\"width:998px;height:340px;overflow-y:scroll;overflow-x:hidden;visibility:hidden;filter:revealTrans(duration=1);\" onscroll=\"scrollY()\"></div>\r\n");
      out.write("\t\t\t\t\t\t\t\t<div id=\"mainDisplay\" style=\"width:998px;height:340px;overflow-y:scroll;overflow-x:hidden;display:none;\" onscroll=\"scrollY()\">\r\n");
      out.write("\t\t\t\t\t\t\t\t<table width=980 border=1 cellpadding=0 cellspacing=0 bordercolorlight=666666 bordercolordark=FFFFFF style=\"table-layout:fixed\">\t\t\t\t\t\t\t\t\t\t\t\r\n");
	if( objVal != null  && objVal.size() > 0) 
	{
		String last_data = null; String curr_data = null;
		boolean samedata = false;
		String cssClass = "tblcg";
		
		Object preValue = null;					
		Hashtable hashtable = new Hashtable();		
		int currIndex = 0;
		int count = 0;
		int[] objVaArray = new int[objVal.size()];
		
		for(int i=0; i<objVal.size(); i++)
		{
			ServiceStatusMonitorVO vo = (ServiceStatusMonitorVO)objVal.get(i);
			Object key = vo.getServiceName();
			if(!key.equals(preValue))
			{
				
				objVaArray[currIndex] = count;
				currIndex = i;
				count = 1;
			}else
			{
				count++;
			}
			preValue = key;
		}
		objVaArray[currIndex] = count;
		
		for(int i=0; i<objVal.size(); i++) {
			ServiceStatusMonitorVO vo = (ServiceStatusMonitorVO)objVal.get(i);
			//curr_data = vo.getServiceName() + ":" + vo.getHostName();
			curr_data = vo.getHostName();
			if( i==0 ) last_data = curr_data;
			
			// 같은 IF ID를 사용할 경우 다음 라인에서 출력하지 않음
			if(i!=0 && last_data.equals(curr_data)) samedata = true;
			else {
				samedata = false;
				cssClass = "tblcg".equals(cssClass)==true?"tblcw":"tblcg";
			}
			
			// 이미지
			String status = vo.getStatus();
			String targetImg = "";
			long currentTime = System.currentTimeMillis();
			String timestamp = vo.getLtime();
			
			Date myDate = null;
			try {
				if (timestamp != null) {
					myDate = dateFormat.parse(timestamp);
				}
			} catch (java.text.ParseException e) {}
	
			long diff = currentTime - myDate.getTime();
			// Normal
			if ("NORMAL".equals(status))
			{
				targetImg = "<img src=\"img/icon_normal.gif\" />";
			}
			// ERROR
			else if ("ERROR".equals(status))
			{
				targetImg = "<img src=\"img/icon_error.gif\" />";
			}
			else
			{
				targetImg = "<img src=\"img/icon_critical.gif\" />";
			}
			// 이미지 끝

      out.write("\r\n");
      out.write("\r\n");
      out.write("\t\t\t\t\t\t\t\t\t<tr class=");
      out.print(cssClass);
      out.write(">\r\n");
      out.write("\t\t\t\t\t\t\t\t\t\t<!--<td width=\"70\"><input type='checkbox' name='sequence' id='");
      out.print("l"+i);
      out.write("' value='");
      out.print(vo.getSeq());
      out.write("'/></td>-->\r\n");
      out.write("\t\t\t\t\t\t\t\t\t\t\r\n");

			if(objVaArray[i] != 0)
			{

      out.write("\t\t\t\t\t\t\t\t\t\t<td width=100 ROWSPAN=");
      out.print(objVaArray[i]);
      out.write(' ');
      out.write('>');
      out.print(samedata==true?"&nbsp;":vo.getHostName());
      out.write("</td>\r\n");
      out.write("\t\t\t\t\t\t\t\t\t\t\r\n");
      out.write("\t\t\t\t\t\t\t\t\t\t\r\n");

			}

      out.write("\r\n");
      out.write("\t\t\t\t\t\t\t\t\t\t<td width=200>");
      out.print(vo.getServiceName());
      out.write(" </td>\r\n");
      out.write("\t\t\t\t\t\t\t\t\t\t<td width=160>");
      out.print(vo.getLinkName());
      out.write("</td>\r\n");
      out.write("\t\t\t\t\t\t\t\t\t\t<td width=\"%\" align=\"left\">");
      out.print(vo.getQDescription()==null?"&nbsp":vo.getQDescription());
      out.write("</td>\r\n");
      out.write("\t\t\t\t\t\t\t\t\t\t<td width=100>");
      out.print(targetImg);
      out.write("</td>\r\n");
      out.write("\t\t\t\t\t\t\t\t\t\t<td width=150>");
      out.print(vo.getLtime());
      out.write("</td>\r\n");
      out.write("\t\t\t\t\t\t\t\t\t</tr>\t\t\t\r\n");
			last_data = curr_data;		
		}				
	}else
	{

      out.write("\t\r\n");
      out.write("\t\t\t\t\t\t\t\t\t<tr height=21><td colspan=7 align=center>검색된 결과가 없습니다.</td></tr>\r\n");
									
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
      out.write("\r\n");
      out.write("<script type=\"text/javascript\">\r\n");
      out.write("\r\n");
      out.write("function getServerData() \r\n");
      out.write("{\r\n");
      out.write("\r\n");
      out.write("  // Obtain an XMLHttpRequest instance\r\n");
      out.write("  var req = newXMLHttpRequest();\r\n");
      out.write("  \r\n");
      out.write("\r\n");
      out.write("  // Set the handler function to receive callback notifications\r\n");
      out.write("  // from the request object\r\n");
      out.write("  var handlerFunction = getReadyStateHandler(req, displayDataTable);\r\n");
      out.write("  req.onreadystatechange = handlerFunction;\r\n");
      out.write("  \r\n");
      out.write("  // Open an HTTP POST connection to the shopping cart servlet.\r\n");
      out.write("  // Third parameter specifies request is asynchronous.\r\n");
      out.write("  req.open(\"POST\", \"/uComposer/PosAjaxAction.do?ServiceName=serviceStatusMonitor-service&find.x=1\", true);\r\n");
      out.write("\r\n");
      out.write("  // Specify that the body of the request contains form data\r\n");
      out.write("  req.setRequestHeader(\"Content-Type\", \"application/x-www-form-urlencoded\");\r\n");
      out.write("  //req.send(\"section=M10\");\r\n");
      out.write("  req.send(\"asyncRefresh=YES&section=\" + document.forms[0].section.value + \"&serviceName=\" + document.forms[0].serviceName.value+ \"&hostName=\" + document.forms[0].hostName.value+\"&linkName=\"+document.forms[0].linkName.value);\r\n");
      out.write("}\r\n");
      out.write("\r\n");
      out.write("/*\r\n");
      out.write(" * Returns a new XMLHttpRequest object, or false if this browser\r\n");
      out.write(" * doesn't support it\r\n");
      out.write(" */\r\n");
      out.write("function newXMLHttpRequest() {\r\n");
      out.write("\r\n");
      out.write("  var xmlreq = false;\r\n");
      out.write("\r\n");
      out.write("  if (window.XMLHttpRequest) {\r\n");
      out.write("\r\n");
      out.write("    // Create XMLHttpRequest object in non-Microsoft browsers\r\n");
      out.write("    xmlreq = new XMLHttpRequest();\r\n");
      out.write("\r\n");
      out.write("  } else if (window.ActiveXObject) {\r\n");
      out.write("\r\n");
      out.write("    // Create XMLHttpRequest via MS ActiveX\r\n");
      out.write("    try {\r\n");
      out.write("      // Try to create XMLHttpRequest in later versions\r\n");
      out.write("      // of Internet Explorer\r\n");
      out.write("\r\n");
      out.write("      xmlreq = new ActiveXObject(\"Msxml2.XMLHTTP\");\r\n");
      out.write("\r\n");
      out.write("    } catch (e1) {\r\n");
      out.write("\r\n");
      out.write("      // Failed to create required ActiveXObject\r\n");
      out.write("\r\n");
      out.write("      try {\r\n");
      out.write("        // Try version supported by older versions\r\n");
      out.write("        // of Internet Explorer\r\n");
      out.write("\r\n");
      out.write("        xmlreq = new ActiveXObject(\"Microsoft.XMLHTTP\");\r\n");
      out.write("\r\n");
      out.write("      } catch (e2) {\r\n");
      out.write("\r\n");
      out.write("        // Unable to create an XMLHttpRequest with ActiveX\r\n");
      out.write("      }\r\n");
      out.write("    }\r\n");
      out.write("  }\r\n");
      out.write("\r\n");
      out.write("  return xmlreq;\r\n");
      out.write("}\r\n");
      out.write("\r\n");
      out.write("\r\n");
      out.write("/*\r\n");
      out.write(" * Returns a function that waits for the specified XMLHttpRequest\r\n");
      out.write(" * to complete, then passes its XML response\r\n");
      out.write(" * to the given handler function.\r\n");
      out.write(" * req - The XMLHttpRequest whose state is changing\r\n");
      out.write(" * responseXmlHandler - Function to pass the XML response to\r\n");
      out.write(" */\r\n");
      out.write("function getReadyStateHandler(req, displayDataTable) {\r\n");
      out.write("\r\n");
      out.write("  // Return an anonymous function that listens to the \r\n");
      out.write("  // XMLHttpRequest instance\r\n");
      out.write("  return function () {\r\n");
      out.write("    //alert(req.readyState);\r\n");
      out.write("    // If the request's status is \"complete\"\r\n");
      out.write("    if (req.readyState == 4) {\r\n");
      out.write("      \r\n");
      out.write("      // Check that a successful server response was received\r\n");
      out.write("      if (req.status == 200) {\r\n");
      out.write("\r\n");
      out.write("        // Pass the XML payload of the response to the \r\n");
      out.write("        // handler function\r\n");
      out.write("       // alert(req.status);\r\n");
      out.write("        displayDataTable(req.responseXML);\r\n");
      out.write("        \r\n");
      out.write("      } else {\r\n");
      out.write("\r\n");
      out.write("        // An HTTP problem has occurred\r\n");
      out.write("        alert(\"HTTP error: \"+req.status);\r\n");
      out.write("      }\r\n");
      out.write("    }\r\n");
      out.write("  }\r\n");
      out.write("}\r\n");
      out.write("\r\n");
      out.write("\r\n");
      out.write("function displayDataTable(serviceStatus)\r\n");
      out.write("{\r\n");
      out.write("\t//alert(serviceStatus);\r\n");
      out.write("\t//serviceStatus = getElement();\r\n");
      out.write("\t\r\n");
      out.write("\tadapterArray = serviceStatus.getElementsByTagName('ADAPTER');\r\n");
      out.write("\t            \t\r\n");
      out.write("\t//totalCount.style.visibility = \"hidden\";\r\n");
      out.write("\t//if( adapterArray != null  && adapterArray.length > 0) \r\n");
      out.write("\t//{\t\r\n");
      out.write("\t//\ttotalCount.innerHTML =  \"<table><tr><td align=right width=300 valign=bottom>총\" + adapterArray.length +  \"건이 조회되었습니다</td></tr></table>\";\r\n");
      out.write("\t//}else\r\n");
      out.write("\t//{\r\n");
      out.write("\t//\ttotalCount.innerHTML =  \"<table><tr><td align=right width=300 valign=bottom>&nbsp;&nbsp;</td></tr></table>\";\r\n");
      out.write("\t//}\r\n");
      out.write("\t//totalCount.style.visibility = \"visible\";\r\n");
      out.write("\t\r\n");
      out.write("\t\r\n");
      out.write("\tvar totalCoount = document.getElementById(\"totalCount\");\r\n");
      out.write("\tif (adapterArray.length > 0)\r\n");
      out.write("\t{\r\n");
      out.write("\t\ttotalCount.innerHTML = \"총 \" + adapterArray.length+ \"건이 조회되었습니다\";\r\n");
      out.write("\t}else\r\n");
      out.write("\t{\r\n");
      out.write("\t\ttotalCount.innerHTML = \"&nbsp;&nbsp;\";\r\n");
      out.write("\t}\r\n");
      out.write("\t\r\n");
      out.write("\tvar mainTable\t= '<table width=960 border=1 cellpadding=1 cellspacing=0 bordercolorlight=666666 bordercolordark=FFFFFF style=\"table-layout:fixed\">';\t\r\n");
      out.write("\tif( adapterArray != null  && adapterArray.length > 0) \r\n");
      out.write("\t{\r\n");
      out.write("\t\r\n");
      out.write("\t\t\t\r\n");
      out.write("\t\tvar cssClass = \"tblcg\";\r\n");
      out.write("\t\tvar samedata;\r\n");
      out.write("\t\tvar targetImg;\r\n");
      out.write("\t\t\r\n");
      out.write("\t\tvar objVaArray = new Array(adapterArray.length);\r\n");
      out.write("\t\t\r\n");
      out.write("\t\tvar preValue;\t\t\t\t\t\r\n");
      out.write("\t\t//Hashtable hashtable = new Hashtable();\t\t\r\n");
      out.write("\t\tvar currIndex = 0;\r\n");
      out.write("\t\tvar count = 1;\r\n");
      out.write("\t\t\r\n");
      out.write("\t\t\r\n");
      out.write("\t\tfor (var i = 0 ; i < adapterArray.length ; i++) \r\n");
      out.write("\t\t{\r\n");
      out.write("\t\t\tvar adapter = adapterArray[i];\r\n");
      out.write("\t\t\tvar key = adapter.getAttribute('SYSTEM_NAME');\r\n");
      out.write("\t\t\tif( preValue != key)\r\n");
      out.write("\t\t\t{\r\n");
      out.write("\t\t\t\t\r\n");
      out.write("\t\t\t\tobjVaArray[currIndex] = count;\r\n");
      out.write("\t\t\t\tcurrIndex = i;\r\n");
      out.write("\t\t\t\tcount = 1;\r\n");
      out.write("\t\t\t}else\r\n");
      out.write("\t\t\t{\r\n");
      out.write("\t\t\t\tcount++;\r\n");
      out.write("\t\t\t}\r\n");
      out.write("\t\t\tpreValue = key;\r\n");
      out.write("\t\t}\r\n");
      out.write("\t\tobjVaArray[currIndex] = count;\r\n");
      out.write("\t\t\r\n");
      out.write("\t\tfor (var i = 0 ; i < adapterArray.length ; i++) \r\n");
      out.write("\t\t{\r\n");
      out.write("\t\t\tvar adapter = adapterArray[i];\r\n");
      out.write("\t\t\t//var curr_data = adapter.getAttribute('ADAPTER_NAME') + \":\" + adapter.getAttribute('SYSTEM_NAME');\t\t\t\r\n");
      out.write("\t\t\tvar curr_data = adapter.getAttribute('SYSTEM_NAME');\r\n");
      out.write("\t\t\tif( i==0 ) last_data = curr_data;\r\n");
      out.write("\t\t\t// 같은 IF ID를 사용할 경우 다음 라인에서 출력하지 않음\r\n");
      out.write("\t\t\tif( i != 0 && last_data == curr_data) \r\n");
      out.write("\t\t\t{\r\n");
      out.write("\t\t\t\tsamedata = true;\r\n");
      out.write("\t\t\t}else {\r\n");
      out.write("\t\t\t\tsamedata = false;\r\n");
      out.write("\t\t\t\tcssClass = (\"tblcg\" == cssClass?\"tblcw\":\"tblcg\");\r\n");
      out.write("\t\t\t}\r\n");
      out.write("\t\t\tlast_data = curr_data;\t\r\n");
      out.write("\t\t\t// 이미지\r\n");
      out.write("\t\t\tvar status = adapter.getAttribute('STATUS');\t\t\t\r\n");
      out.write("\t\r\n");
      out.write("\t\t\t// Normal\r\n");
      out.write("\t\t\tif (\"NORMAL\" == status)\r\n");
      out.write("\t\t\t{\r\n");
      out.write("\t\t\t\ttargetImg = \"<img src=\\\"img/icon_normal.gif\\\" />\";\r\n");
      out.write("\t\t\t}\r\n");
      out.write("\t\t\t// ERROR\r\n");
      out.write("\t\t\telse if (\"ERROR\" == status)\r\n");
      out.write("\t\t\t{\r\n");
      out.write("\t\t\t\ttargetImg = \"<img src=\\\"img/icon_error.gif\\\" />\";\r\n");
      out.write("\t\t\t}\r\n");
      out.write("\t\t\telse\r\n");
      out.write("\t\t\t{\r\n");
      out.write("\t\t\t\ttargetImg = \"<img src=\\\"img/icon_critical.gif\\\" />\";\r\n");
      out.write("\t\t\t}\t\t\r\n");
      out.write("\t\t\t\r\n");
      out.write("\t\t\tmainTable \t= mainTable + '<tr class=' + cssClass + '>';\t\r\n");
      out.write("\t\t\t\r\n");
      out.write("\t\t\tif(objVaArray[i] != null)\r\n");
      out.write("\t\t\t{\r\n");
      out.write("\t\t\t\t//alert(\"\\\"\" + objVaArray[i]+ \"\\\"\");\t\r\n");
      out.write("\t\t\t\tmainTable\t= mainTable + '<td width=100 ROWSPAN='+ objVaArray[i] + ' >'+ adapter.getAttribute('SYSTEM_NAME')+'</td>';\r\n");
      out.write("\t\t\t\t\r\n");
      out.write("\t\t\t\t\r\n");
      out.write("\t\t\t}\t\t\t\r\n");
      out.write("\t\t\t//alert(adapter.getAttribute('DESC'));\r\n");
      out.write("\t\t\t//mainTable\t= mainTable + '<td width=200 >'+ adapter.getAttribute('ADAPTER_NAME')+'</td>';\r\n");
      out.write("\t\t\t//mainTable\t= mainTable + '<td width=100 >'+ adapter.getAttribute('SYSTEM_NAME')+'</td>';\r\n");
      out.write("\t\t\t//mainTable\t= mainTable + '<td width=200 ROWSPAN='+ objVaArray[i] + ' >'+ adapter.getAttribute('ADAPTER_NAME')+'</td>';\r\n");
      out.write("\t\t\tmainTable\t= mainTable + '<td width=200>'+ adapter.getAttribute('ADAPTER_NAME')+'</td>';\r\n");
      out.write("\t\t\tmainTable\t= mainTable + '<td width=160>'+ adapter.getAttribute('LINK_NAME')+'</td>';\r\n");
      out.write("\t\t\tmainTable\t= mainTable + '<td width=%>'+ (adapter.getAttribute('DESC')==\"\"?\"&nbsp;\":adapter.getAttribute('DESC')) +'</td>';\r\n");
      out.write("\t\t\tmainTable\t= mainTable + '<td width=100>'+ targetImg + '</td>';\r\n");
      out.write("\t\t\tmainTable\t= mainTable + '<td width=150>'+ adapter.getAttribute('LAST_ACCESS_TIME')+'</td>';\r\n");
      out.write("\t\t\tmainTable\t= mainTable + '</tr>';\r\n");
      out.write("\t\t\t\t\t\t\t\t\t\t\t\r\n");
      out.write("\t\t}\r\n");
      out.write("\t\t\r\n");
      out.write("\t\t//mainDisplay.style.visibility = \"hidden\";\r\n");
      out.write("\r\n");
      out.write("\t}else\r\n");
      out.write("\t{\r\n");
      out.write("\t\tmainTable = mainTable + \"<tr height=21><td colspan=7 align=center>검색된 결과가 없습니다.</td></tr>\" ;\r\n");
      out.write("\t}\r\n");
      out.write("\t\r\n");
      out.write("\tmainTable = mainTable + '</table>';\r\n");
      out.write("\t\r\n");
      out.write("\t\r\n");
      out.write("\t//dataTable.filters.item(0).transition =(new Date().getSeconds() %15);\r\n");
      out.write("\tdataTable.filters.item(0).transition = 44;\r\n");
      out.write("\tdataTable.filters.item(0).apply();\r\n");
      out.write("\tdataTable.style.visibility = \"hidden\";\r\n");
      out.write("\tdataTable.filters.item(0).play();\r\n");
      out.write("\t//dataTable.style.visibility = \"hidden\";\t\r\n");
      out.write("\tdataTable.innerHTML = \"\" + mainTable;             \t\r\n");
      out.write("\tdataTable.style.visibility = \"visible\";\r\n");
      out.write("\t\r\n");
      out.write("\tif(clock != 0)\r\n");
      out.write("\t{\r\n");
      out.write("\t\t//alert(\" clock \" + clock);\r\n");
      out.write("\t\twindow.clearTimeout(clock);\r\n");
      out.write("\t\tclock = 0;\r\n");
      out.write("\t}\r\n");
      out.write("\tclock = window.setTimeout('execute()',1000*eval(checkPeriod(document.forms[0].refreshTime.value)));\r\n");
      out.write("\t\r\n");
      out.write("\t//Prevent Retry\r\n");
      out.write("\tisWaiting = 'false';\r\n");
      out.write("\t\r\n");
      out.write("\t\r\n");
      out.write("}\r\n");
      out.write("function getElement()\r\n");
      out.write("{\r\n");
      out.write("\t//TEST용\r\n");
      out.write("\tvar serviceStatus = document.createElement('SERVICE_STATUS');\r\n");
      out.write("\t\r\n");
      out.write("\tvar adapter = document.createElement('ADAPTER');\r\n");
      out.write("\tserviceStatus.appendChild(adapter);\r\n");
      out.write("\t\r\n");
      out.write("\tadapter.setAttribute('ADAPTER_NAME','aaaaaa');\r\n");
      out.write("\tadapter.setAttribute('SYSTEM_NAME','bbbbb');\r\n");
      out.write("\tadapter.setAttribute('LINK_NAME','ccccc');\r\n");
      out.write("\tadapter.setAttribute('DESC','ddddd');\r\n");
      out.write("\tadapter.setAttribute('STATUS','NORMAL');\r\n");
      out.write("\tadapter.setAttribute('LAST_ACCESS_TIME','fffff');\r\n");
      out.write("\t\r\n");
      out.write("\tadapter = document.createElement('ADAPTER');\r\n");
      out.write("\tserviceStatus.appendChild(adapter);\r\n");
      out.write("\t\r\n");
      out.write("\tadapter.setAttribute('ADAPTER_NAME','aaaaaa');\r\n");
      out.write("\tadapter.setAttribute('SYSTEM_NAME','bbbbb');\r\n");
      out.write("\tadapter.setAttribute('LINK_NAME','ccccc');\r\n");
      out.write("\tadapter.setAttribute('DESC','ddddd');\r\n");
      out.write("\tadapter.setAttribute('STATUS','NORMAL');\r\n");
      out.write("\tadapter.setAttribute('LAST_ACCESS_TIME','fffff');\r\n");
      out.write("\t\r\n");
      out.write("\tadapter = document.createElement('ADAPTER');\r\n");
      out.write("\tserviceStatus.appendChild(adapter);\r\n");
      out.write("\t\r\n");
      out.write("\tadapter.setAttribute('ADAPTER_NAME','fffff');\r\n");
      out.write("\tadapter.setAttribute('SYSTEM_NAME','bbbbb');\r\n");
      out.write("\tadapter.setAttribute('LINK_NAME','ccccc');\r\n");
      out.write("\tadapter.setAttribute('DESC','ddddd');\r\n");
      out.write("\tadapter.setAttribute('STATUS','NORMAL');\r\n");
      out.write("\tadapter.setAttribute('LAST_ACCESS_TIME','fffff');\r\n");
      out.write("\t\r\n");
      out.write("\t\r\n");
      out.write("\tadapter = document.createElement('ADAPTER');\r\n");
      out.write("\tserviceStatus.appendChild(adapter);\r\n");
      out.write("\t\r\n");
      out.write("\tadapter.setAttribute('ADAPTER_NAME','fffff');\r\n");
      out.write("\tadapter.setAttribute('SYSTEM_NAME','bbbbb');\r\n");
      out.write("\tadapter.setAttribute('LINK_NAME','ccccc');\r\n");
      out.write("\tadapter.setAttribute('DESC','ddddd');\r\n");
      out.write("\tadapter.setAttribute('STATUS','NORMAL');\r\n");
      out.write("\tadapter.setAttribute('LAST_ACCESS_TIME','fffff');\r\n");
      out.write("\t\r\n");
      out.write("\t\r\n");
      out.write("\tadapter = document.createElement('ADAPTER');\r\n");
      out.write("\tserviceStatus.appendChild(adapter);\r\n");
      out.write("\t\r\n");
      out.write("\tadapter.setAttribute('ADAPTER_NAME','fffff');\r\n");
      out.write("\tadapter.setAttribute('SYSTEM_NAME','bbbbb');\r\n");
      out.write("\tadapter.setAttribute('LINK_NAME','ccccc');\r\n");
      out.write("\tadapter.setAttribute('DESC','ddddd');\r\n");
      out.write("\tadapter.setAttribute('STATUS','NORMAL');\r\n");
      out.write("\tadapter.setAttribute('LAST_ACCESS_TIME','fffff');\r\n");
      out.write("\t//TEST용\r\n");
      out.write("\treturn serviceStatus;\r\n");
      out.write("}\r\n");
      out.write("\r\n");
      out.write("</script>\r\n");
      out.write("<script>\r\n");
      out.write("<!--\r\n");
      out.write("function scrollX() {\r\n");
      out.write("\tdocument.all.mainDisplay.scrollLeft = document.all.bottomLine.scrollLeft;\r\n");
      out.write("\tdocument.all.topLine.scrollLeft = document.all.bottomLine.scrollLeft;\r\n");
      out.write("}\r\n");
      out.write("function scrollY() {\r\n");
      out.write("\t//document.all.leftDisplay.scrollTop = document.all.mainDisplay.scrollTop;\r\n");
      out.write("}\r\n");
      out.write("clock = window.setTimeout('execute()',1000*eval(checkPeriod(document.forms[0].refreshTime.value)));\r\n");
      out.write("//-->\r\n");
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
