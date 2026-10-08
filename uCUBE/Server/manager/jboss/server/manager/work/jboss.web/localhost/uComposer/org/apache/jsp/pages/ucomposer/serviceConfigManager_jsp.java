package org.apache.jsp.pages.ucomposer;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.jsp.*;
import com.posdata.glue.context.PosContext;
import java.util.ArrayList;

public final class serviceConfigManager_jsp extends org.apache.jasper.runtime.HttpJspBase
    implements org.apache.jasper.runtime.JspSourceDependent {

  private static java.util.Vector _jspx_dependants;

  static {
    _jspx_dependants = new java.util.Vector(3);
    _jspx_dependants.add("/WEB-INF/gluetag.tld");
    _jspx_dependants.add("/pages/form/htmlheader.jsp");
    _jspx_dependants.add("/pages/header.jsp");
  }

  private org.apache.jasper.runtime.TagHandlerPool _jspx_tagPool_posui_showUtilityButtons_onClick_names_imgs_nobody;

  public java.util.List getDependants() {
    return _jspx_dependants;
  }

  public void _jspInit() {
    _jspx_tagPool_posui_showUtilityButtons_onClick_names_imgs_nobody = org.apache.jasper.runtime.TagHandlerPool.getTagHandlerPool(getServletConfig());
  }

  public void _jspDestroy() {
    _jspx_tagPool_posui_showUtilityButtons_onClick_names_imgs_nobody.release();
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
      com.posdata.glue.ui.tags.GetInfoBean infoBean = null;
      synchronized (_jspx_page_context) {
        infoBean = (com.posdata.glue.ui.tags.GetInfoBean) _jspx_page_context.getAttribute("infoBean", PageContext.PAGE_SCOPE);
        if (infoBean == null){
          infoBean = new com.posdata.glue.ui.tags.GetInfoBean();
          _jspx_page_context.setAttribute("infoBean", infoBean, PageContext.PAGE_SCOPE);
        }
      }
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
      out.write("<title>uComposer Service Config</title>");


    PosContext ctx = (PosContext)request.getAttribute( "PosContext" );
    int linenum = 0;
    String alertMessage = null;
    String currentTime = "";
    if( ctx != null ) {
        alertMessage = (String)ctx.get( "alertMessage" );
        currentTime = (String)ctx.get( "currentTime" );
    }

      out.write("\r\n");
      out.write("<script language=\"javascript\" type=\"text/javascript\">\r\n");
      out.write("<!--\r\n");
 if( alertMessage != null ) { 
      out.write("\r\n");
      out.write("    alert(\"");
      out.print(alertMessage );
      out.write("\");\r\n");
 } 
      out.write("\r\n");
      out.write("var chk_flg;\r\n");
      out.write("function uCUBE_setEvent( btn )\r\n");
      out.write("{\r\n");
      out.write("    if( btn==\"find\" )\r\n");
      out.write("    {\r\n");
      out.write("        document.forms[0].hidden_event.value = btn;\r\n");
      out.write("        return true;\r\n");
      out.write("    } else if( btn==\"delete\" )\r\n");
      out.write("    {\r\n");
      out.write("        if(confirm(\"삭제하시겠습니까?\"))\r\n");
      out.write("        {\r\n");
      out.write("            document.forms[0].hidden_event.value = btn;\r\n");
      out.write("            return true;\r\n");
      out.write("        }\r\n");
      out.write("    } else\r\n");
      out.write("    {\r\n");
      out.write("        if(document.forms[0].hidden_event.value==\"create\"){\r\n");
      out.write("            var target_url = \"/uComposer/serviceConfigManagerPopupAction.do?ServiceName=serviceConfigManager-service&find.x=1&hidden_event=create\";\r\n");
      out.write("            returnValue = window.showModalDialog(target_url,\"\",\"dialogWidth:900px;dialogHeight:620px;status:yes;\");\r\n");
      out.write("            if(returnValue==\"create\"){\r\n");
      out.write("                document.forms[0].hidden_event.value = \"find\";\r\n");
      out.write("                document.forms[0].action = document.forms[0].action+\"?find.x=1\";\r\n");
      out.write("                document.forms[0].submit();\r\n");
      out.write("            }\r\n");
      out.write("        } else {\r\n");
      out.write("            var target_url = \"/uComposer/serviceConfigManagerPopupAction.do?ServiceName=serviceConfigManager-service&find.x=1&hidden_event=modify\";\r\n");
      out.write("            if(document.forms[0].chk.length>1){\r\n");
      out.write("                for(i=0; i<document.forms[0].chk.length; i++){\r\n");
      out.write("                    if(document.forms[0].chk[i].checked){\r\n");
      out.write("                        target_url = target_url+\"&hidden_service=\"+document.forms[0].directory[i].value+\"&hidden_filename=\"+document.forms[0].file_info[i].value ;\r\n");
      out.write("                        window.showModalDialog(target_url,\"\",\"dialogWidth:900px;dialogHeight:620px;stauts:yes;\");\r\n");
      out.write("                    }\r\n");
      out.write("                }\r\n");
      out.write("            }else{\r\n");
      out.write("                    if(document.forms[0].chk.checked){\r\n");
      out.write("                        target_url = target_url+\"&hidden_service=\"+document.forms[0].directory.value+\"&hidden_filename=\"+document.forms[0].file_info.value ;\r\n");
      out.write("                        window.showModalDialog(target_url,\"\",\"dialogWidth:900px;dialogHeight:620px;stauts:yes;\");\r\n");
      out.write("                    }\r\n");
      out.write("            }\r\n");
      out.write("        }\r\n");
      out.write("    }\r\n");
      out.write("    return false;\r\n");
      out.write("}\r\n");
      out.write("function uCUBE_toggleButton(checkbox_obj,imgsrc1,imgsrc2)\r\n");
      out.write("{\r\n");
      out.write("    var _form = eval(\"document.forms[0].\" + checkbox_obj.name);\r\n");
      out.write("    var cnt = _form.length\r\n");
      out.write("    chk_flg = 0;\r\n");
      out.write("    if( cnt > 1)\r\n");
      out.write("    {\r\n");
      out.write("        for( i=0; i<cnt ; i++)\r\n");
      out.write("        {\r\n");
      out.write("            if(_form[i].checked == true ) chk_flg = chk_flg+1;\r\n");
      out.write("        }\r\n");
      out.write("    } else\r\n");
      out.write("    {\r\n");
      out.write("        if( _form.checked == true) chk_flg = 1;\r\n");
      out.write("    }\r\n");
      out.write("    var imgname = document.getElementById('insert');\r\n");
      out.write("    if(chk_flg==1){\r\n");
      out.write("        document.forms[0].hidden_event.value=\"modify\";\r\n");
      out.write("        imgname.src = imgsrc2;\r\n");
      out.write("    } else {\r\n");
      out.write("        document.forms[0].hidden_event.value=\"create\";\r\n");
      out.write("        imgname.src = imgsrc1;\r\n");
      out.write("    }\r\n");
      out.write("    return;\r\n");
      out.write("}\r\n");
      out.write("function goClose() {\r\n");
      out.write("    self.close();\r\n");
      out.write("}\r\n");
      out.write("-->\r\n");
      out.write("</script>\r\n");
      out.write("</head>\r\n");
      out.write("<div id=\"overDiv\" style=\"position:absolute; visibility:hidden; z-index:1000;\"></div><!-- 풍선도움말을 위한 Div Layer -->\r\n");
      out.write("<body bgcolor=\"#FFFFFF\" text=\"#000000\" topmargin=0 leftmargin=0>\r\n");
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
      out.write("<form name=\"serviceConfigManager\" method=\"post\" action=\"serviceConfigManagerAction.do\">\r\n");
      out.write("<input type=\"hidden\" name=\"ServiceName\" value=\"serviceConfigManager-service\">\r\n");
      out.write("<input type=\"hidden\" name=\"hidden_event\" value=\"create\"><!-- checkbox 클릭시 변경, 조회|삭제 버튼클릭시 변경 -->\r\n");
      out.write("<!--세로간격-->\r\n");
      out.write("<table width=\"980\" height=\"25\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\">\r\n");
      out.write("    <tr>\r\n");
      out.write("        <td>\r\n");
      out.write("            <img src=\"/uComposer/img/comm_img02_blank.gif\" width=\"5\" height=\"10\"><img src=\"/uComposer/img/comm_img03_ic.gif\" width=\"11\" height=\"10\"><span class=\"bluetit\"><img src=\"/uComposer/img/comm_img02_blank.gif\" width=\"5\" height=\"10\"></span>\r\n");
      out.write("            <span class=\"tit01\">Service Config</span>\r\n");
      out.write("        </td>\r\n");
      out.write("    </tr>\r\n");
      out.write("</table>\r\n");
      out.write("<!--세로간격 끝-->\r\n");
      out.write("<!--검색조건-->\r\n");
      out.write("<table width=\"980\" border=\"1\" cellpadding=\"2\" cellspacing=\"0\" bordercolor=\"#FFFFFF\" bgcolor=\"#FFFFFF\">\r\n");
      out.write("    <tr>\r\n");
      out.write("        <td height=\"25\" bordercolor=\"999999\" bgcolor=\"F8F3E8\">\r\n");
      out.write("            <table width=\"100%\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\" class=\"search\">\r\n");
      out.write("                <tr>\r\n");
      out.write("                  <td height=25>\r\n");
      out.write("                      <img src=\"/uComposer/img/comm_img02_blank.gif\" width=\"10\" height=\"10\">\r\n");
      out.write("                      <img src=\"/uComposer/img/comm_img06_ic.gif\" width=\"10\" height=\"3\">\r\n");
      out.write("                      <b>Service:</b>\r\n");
      out.write("                      <select name=service_config_type>\r\n");
      out.write("                        <option value=all>----------all----------</option>");

              ArrayList service = (ArrayList)ctx.get("service_config_types");
              if(service!=null)
              {
                  String prev = request.getParameter("service_config_type")==null?"all":request.getParameter("service_config_type");
                  for(int i=0, iz=service.size(); i<iz; i++)
                  {
                      String selected = prev.equals(service.get(i))?" selected":""; 

      out.write("\r\n");
      out.write("                        <option value='");
      out.print(service.get(i));
      out.write('\'');
      out.print(selected);
      out.write('>');
      out.print(((String)service.get(i)));
      out.write("</option>");

                  }
              }
                        
      out.write("\r\n");
      out.write("                      </select>\r\n");
      out.write("                      <img src=\"/uComposer/img/comm_img02_blank.gif\" width=\"10\" height=\"10\">\r\n");
      out.write("                      <img src=\"/uComposer/img/comm_img06_ic.gif\" width=\"10\" height=\"3\">\r\n");
      out.write("                      <b>File Name:</b>\r\n");
      out.write("                      <input type=\"text\" name=\"file_name\" style=\"width:100\" Class=\"adb1\" onblur=\"this.className='adb1'\" onfocus=\"this.className='adf1'\" onkeyup=\"this.value=upperCase(this.value);\" value=\"");
      out.print( request.getParameter("file_name")==null?"":request.getParameter("file_name") );
      out.write("\">\r\n");
      out.write("                  </td>\r\n");
      out.write("                  <td height=25 valign=\"middle\" align=right>\r\n");
      out.write("                      <input type=image name=find src=\"img/m000001ico.gif\" border=0 onclick=\"return uCUBE_setEvent('find');\"\">\r\n");
      out.write("                      <img id=\"insert\" src=\"img/m000007ico.gif\" border=0 onclick=\"uCUBE_setEvent('insert');\" style=\"cursor:pointer\">\r\n");
      out.write("                      <input type=image name=delete  src=\"img/m000009ico.gif\"border=0 onclick=\"return uCUBE_setEvent('delete');\">\r\n");
      out.write("                      <img name=close src=\"img/m000005ico.gif\" border=0 onclick=\"goClose();\" style=\"cursor:pointer\">\r\n");
      out.write("                      <!--\r\n");
      out.write("                      ");
      if (_jspx_meth_posui_showUtilityButtons_0(_jspx_page_context))
        return;
      out.write("\r\n");
      out.write("                      -->\r\n");
      out.write("                  </td>\r\n");
      out.write("                </tr>\r\n");
      out.write("            </table>\r\n");
      out.write("        </td>\r\n");
      out.write("    </tr>\r\n");
      out.write("</table>\r\n");
      out.write("<!--검색조건 끝-->\r\n");
      out.write("<!--세로간격-->\r\n");
      out.write("<table width=\"980\" height=\"8\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\">\r\n");
      out.write("    <tr>\r\n");
      out.write("        <td>\r\n");
      out.write("        </td>\r\n");
      out.write("    </tr>\r\n");
      out.write("</table>\r\n");
      out.write("<!--세로간격 끝-->\r\n");
      out.write("<table width=\"980\" border=\"1\" cellspacing=\"0\" cellpadding=\"0\" bordercolorlight=\"#666666\" bordercolordark=\"#FFFFFF\">\r\n");
      out.write("    <tr height=25 class=\"tblcb1\">\r\n");
      out.write("        <td><img src=\"img/m000009img.gif\" border=0 onClick=\"selectAll(chk);\" style='cursor:hand'></td>\r\n");
      out.write("        <td width=45%>Service</td>\r\n");
      out.write("        <td width=50%>FileName</td>\r\n");
      out.write("    </tr>");

              ArrayList fileinfo = (ArrayList)ctx.get("service_config_files");
              if(fileinfo!=null){
                  for(int i=0, iz=fileinfo.size(); i<iz; i++){
                      Object[] obj = (Object[])fileinfo.get(i);

      out.write("\r\n");
      out.write("    <tr height=25>\r\n");
      out.write("        <td align=center><input type=checkbox name=chk value=");
      out.print(i);
      out.write(" onClick=\"uCUBE_toggleButton(this, 'img/m000007ico.gif', 'img/m000028ico.gif')\"></td>\r\n");
      out.write("        <td>&nbsp;");
      out.print(obj[0]);
      out.write("<input type=hidden name=directory value=\"");
      out.print(obj[0]);
      out.write("\"></td>\r\n");
      out.write("        <td>&nbsp;");
      out.print(obj[1]);
      out.write("<input type=hidden name=file_info value=\"");
      out.print(obj[1]);
      out.write("\"></td>\r\n");
      out.write("    </tr>");

                  }
              }

      out.write("\r\n");
      out.write("</table>\r\n");
      out.write("<input type=hidden name=chk_cnt value=0>\r\n");
      out.write("</form>\r\n");
      out.write("<div style=\"display:none\">\r\n");
      out.write("<form name=\"popup\" method=\"post\" action=\"serviceConfigManagerAction.do\">\r\n");
      out.write("<input type=text name=directory value=\"\">\r\n");
      out.write("<input type=text name=filename value=\"\">\r\n");
      out.write("<textarea name=filecontent></textarea>\r\n");
      out.write("</form>\r\n");
      out.write("</div>\r\n");
      org.apache.jasper.runtime.JspRuntimeLibrary.include(request, response, "/pages/common/copyright.jsp", out, false);
      out.write("\r\n");
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

  private boolean _jspx_meth_posui_showUtilityButtons_0(PageContext _jspx_page_context)
          throws Throwable {
    PageContext pageContext = _jspx_page_context;
    JspWriter out = _jspx_page_context.getOut();
    //  posui:showUtilityButtons
    com.posdata.glue.ui.tags.ShowUtilityButtonsTag _jspx_th_posui_showUtilityButtons_0 = (com.posdata.glue.ui.tags.ShowUtilityButtonsTag) _jspx_tagPool_posui_showUtilityButtons_onClick_names_imgs_nobody.get(com.posdata.glue.ui.tags.ShowUtilityButtonsTag.class);
    _jspx_th_posui_showUtilityButtons_0.setPageContext(_jspx_page_context);
    _jspx_th_posui_showUtilityButtons_0.setParent(null);
    _jspx_th_posui_showUtilityButtons_0.setNames("find|insert|delete|close");
    _jspx_th_posui_showUtilityButtons_0.setOnClick("uCUBE_setEvent('find')|javascript:return uCUBE_setEvent('insert')|uCUBE_setEvent('delete')|javascript: return goClose()");
    _jspx_th_posui_showUtilityButtons_0.setImgs("/uComposer/img/m000001ico.gif|img/m000007ico.gif|img/m000009ico.gif|img/m000005ico.gif");
    int _jspx_eval_posui_showUtilityButtons_0 = _jspx_th_posui_showUtilityButtons_0.doStartTag();
    if (_jspx_th_posui_showUtilityButtons_0.doEndTag() == javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
      return true;
    _jspx_tagPool_posui_showUtilityButtons_onClick_names_imgs_nobody.reuse(_jspx_th_posui_showUtilityButtons_0);
    return false;
  }
}
