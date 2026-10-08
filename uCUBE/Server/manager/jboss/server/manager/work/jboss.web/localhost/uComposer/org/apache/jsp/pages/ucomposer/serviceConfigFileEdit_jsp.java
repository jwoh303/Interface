package org.apache.jsp.pages.ucomposer;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.jsp.*;
import com.posdata.glue.context.PosContext;
import java.util.ArrayList;

public final class serviceConfigFileEdit_jsp extends org.apache.jasper.runtime.HttpJspBase
    implements org.apache.jasper.runtime.JspSourceDependent {

  private static java.util.Vector _jspx_dependants;

  static {
    _jspx_dependants = new java.util.Vector(1);
    _jspx_dependants.add("/pages/form/htmlheader.jsp");
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
      out.write("<html>\r\n");
      out.write("<head>\r\n");
      out.write("<title>uComposer Service Config - File Edit</title>\r\n");
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
      out.write("<script language=\"JavaScript\">\r\n");
      out.write("function setEvent(value)\r\n");
      out.write("{\r\n");
      out.write("    if(value=='create' && confirm(\"등록 하시겠습니까?\")){\r\n");
      out.write("        document.forms[0].hidden_event.value=value;\r\n");
      out.write("        return true;\r\n");
      out.write("    }else if(value=='modify' && confirm(\"수정 하시겠습니까?\")){\r\n");
      out.write("        document.forms[0].hidden_event.value=value;\r\n");
      out.write("        return true;\r\n");
      out.write("    }\r\n");
      out.write("    return false;\r\n");
      out.write("}\r\n");
      out.write("</script>\r\n");
      out.write("<base target=\"_self\"/>\r\n");
      out.write("</head>");

    PosContext ctx = (PosContext)request.getAttribute( "PosContext" );
    String hidden_event = request.getParameter("hidden_event");
    String hidden_service = request.getParameter("hidden_service");
    String hidden_filename = request.getParameter("hidden_filename");
    String close = (String)ctx.get("closeModalDailog");

      out.write("\r\n");
      out.write("<body bgcolor=\"#FFFFFF\" text=\"#000000\" topmargin=0 leftmargin=0 ");
      out.print(close!=null?"onLoad=self.close();window.returnValue=\""+hidden_event+"\";":"");
      out.write(">\r\n");
      out.write("<form name=\"serviceConfigManager_popup\" method=\"post\" action=\"serviceConfigManagerPopupAction.do\">\r\n");
      out.write("<input type=\"hidden\" name=\"ServiceName\" value=\"serviceConfigManager-service\">\r\n");
      out.write("<input type=\"hidden\" name=\"hidden_event\" value=\"");
      out.print(hidden_event);
      out.write("\">\r\n");
      out.write("<!--세로간격-->\r\n");
      out.write("<table width=\"860\" height=\"25\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\">\r\n");
      out.write("    <tr>\r\n");
      out.write("        <td>\r\n");
      out.write("            <img src=\"/uComposer/img/comm_img02_blank.gif\" width=\"5\" height=\"10\"><img src=\"/uComposer/img/comm_img03_ic.gif\" width=\"11\" height=\"10\"><span class=\"bluetit\"><img src=\"/uComposer/img/comm_img02_blank.gif\" width=\"5\" height=\"10\"></span>\r\n");
      out.write("            <span class=\"tit01\">Service Config File : ");
      out.print(hidden_event);
      out.write(" </span>\r\n");
      out.write("        </td>\r\n");
      out.write("    </tr>\r\n");
      out.write("</table>\r\n");
      out.write("<!--세로간격 끝-->\r\n");
      out.write("<!--검색조건-->\r\n");
      out.write("<table width=\"860\" border=\"1\" cellpadding=\"2\" cellspacing=\"0\" bordercolor=\"#FFFFFF\" bgcolor=\"#FFFFFF\">\r\n");
      out.write("    <tr>\r\n");
      out.write("        <td height=\"25\" bordercolor=\"999999\" bgcolor=\"F8F3E8\">\r\n");
      out.write("            <table width=\"100%\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\" class=\"search\">\r\n");
      out.write("                <tr height=25>\r\n");
      out.write("                  <td>\r\n");
      out.write("                      <img src=\"/uComposer/img/comm_img02_blank.gif\" width=\"10\" height=\"10\"><img src=\"/uComposer/img/comm_img06_ic.gif\" width=\"10\" height=\"3\">\r\n");
      out.write("                      <b>Service:</b>");

          if(hidden_service==null){

      out.write("\r\n");
      out.write("                      <select name=\"service_config_type\" class=adf>");

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
      out.write("                      <img src=\"/uComposer/img/comm_img02_blank.gif\" width=\"10\" height=\"10\"><img src=\"/uComposer/img/comm_img06_ic.gif\" width=\"10\" height=\"3\">\r\n");
      out.write("                      <b>File Name:</b>\r\n");
      out.write("                      <input type=\"text\" name=\"file_name\" style=\"width:200\" class=adf value=\"\">");

          }else{

      out.write("\r\n");
      out.write("                      <input type=\"hidden\" name=\"service_config_type\" value=\"");
      out.print(hidden_service);
      out.write("\" readonly>");
      out.print(hidden_service);
      out.write("\r\n");
      out.write("                      <img src=\"/uComposer/img/comm_img02_blank.gif\" width=\"10\" height=\"10\"><img src=\"/uComposer/img/comm_img06_ic.gif\" width=\"10\" height=\"3\">\r\n");
      out.write("                      <b>File Name:</b>\r\n");
      out.write("                      <input type=\"hidden\" name=\"file_name\" value=\"");
      out.print(hidden_filename);
      out.write("\" readonly>");
      out.print(hidden_filename);

          }

      out.write("\r\n");
      out.write("                  </td>\r\n");
      out.write("                  <td valign=bottom align=right>");
 if("modify".equals(hidden_event)){
      out.write("\r\n");
      out.write("                      <input type=image name=\"update\" src=\"img/m000028ico.gif\" onClick=\"javascript:return setEvent('modify')\">");
}else{
      out.write("\r\n");
      out.write("                      <input type=image name=\"insert\" src=\"img/m000007ico.gif\" onClick=\"javascript:return setEvent('create')\">");
}
      out.write("\r\n");
      out.write("                      <input type=image name=\"close\" src=\"img/m000005ico.gif\" onClick=\"javascript:window.close();return false;\">&nbsp;\r\n");
      out.write("                  </td>\r\n");
      out.write("                </tr>\r\n");
      out.write("            </table>\r\n");
      out.write("        </td>\r\n");
      out.write("    </tr>\r\n");
      out.write("</table>\r\n");
      out.write("<table width=\"860\" height=\"8\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\">\r\n");
      out.write("    <tr>\r\n");
      out.write("        <td>\r\n");
      out.write("        </td>\r\n");
      out.write("    </tr>\r\n");
      out.write("</table>\r\n");
      out.write("<table width=\"860\" height=\"8\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\">\r\n");
      out.write("    <tr>\r\n");
      out.write("        <td align=center>\r\n");
      out.write("          <textarea name=\"content\" class=adb style=\"height:500px;width:858px;\">");
      out.print(ctx.get("file_contents")==null?"":ctx.get("file_contents"));
      out.write("</textarea>\r\n");
      out.write("        </td>\r\n");
      out.write("    </tr>\r\n");
      out.write("</table>\r\n");
      out.write("<!--검색조건 끝-->");
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
