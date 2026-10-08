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
import java.util.*;

public final class login_jsp extends org.apache.jasper.runtime.HttpJspBase
    implements org.apache.jasper.runtime.JspSourceDependent {

  private static java.util.Vector _jspx_dependants;

  static {
    _jspx_dependants = new java.util.Vector(8);
    _jspx_dependants.add("/pages/form/jspheader.jsp");
    _jspx_dependants.add("/WEB-INF/struts-bean.tld");
    _jspx_dependants.add("/WEB-INF/struts-html.tld");
    _jspx_dependants.add("/WEB-INF/struts-logic.tld");
    _jspx_dependants.add("/WEB-INF/displaytag-11.tld");
    _jspx_dependants.add("/WEB-INF/ucube.tld");
    _jspx_dependants.add("/WEB-INF/gluetag.tld");
    _jspx_dependants.add("/pages/form/htmlheader.jsp");
  }

  private org.apache.jasper.runtime.TagHandlerPool _jspx_tagPool_bean_message_key_nobody;

  public java.util.List getDependants() {
    return _jspx_dependants;
  }

  public void _jspInit() {
    _jspx_tagPool_bean_message_key_nobody = org.apache.jasper.runtime.TagHandlerPool.getTagHandlerPool(getServletConfig());
  }

  public void _jspDestroy() {
    _jspx_tagPool_bean_message_key_nobody.release();
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
	java.text.SimpleDateFormat dateFormat = new java.text.SimpleDateFormat("yyyy/MM/dd HH:mm:ss");



      out.write("\r\n");
      out.write("\r\n");
      out.write("<html>\r\n");

	String loginResult = (String)request.getAttribute("loginResult");
	if( loginResult != null ) out.println("<script>alert('" + loginResult +"');</script");

      out.write("\r\n");
      out.write("<head>\r\n");
      out.write("<title>");
      if (_jspx_meth_bean_message_0(_jspx_page_context))
        return;
      out.write("</title>\r\n");
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
      out.write("<script language=\"JavaScript\">\r\n");
      out.write("function login() {\r\n");
      out.write("\r\n");
      out.write("//alert(LoginForm.id.value);\r\n");
      out.write("\tif ( LoginForm.id.value == \"\" ) {\r\n");
      out.write("\t//document.forms[0].id.value;\r\n");
      out.write("\t//document.LoginForm.id.value;\r\n");
      out.write("\t//\talert(\"Username을 입력하세요\");\r\n");
      out.write("\t\tLoginForm.id.focus();\r\n");
      out.write("\t\treturn false;\r\n");
      out.write("\t} \r\n");
      out.write("\tif ( LoginForm.password.value == \"\" ) {\r\n");
      out.write("\t\talert(\"Password을 입력하세요\");\r\n");
      out.write("\t\tLoginForm.password.focus();\r\n");
      out.write("\t\treturn false;\r\n");
      out.write("\t}\r\n");
      out.write("\tLoginForm.submit();\t\r\n");
      out.write("}\r\n");
      out.write("function executeEnterKey(){\r\n");
      out.write("\tif( event.keyCode == 13 ) LoginForm.submit();\t\r\n");
      out.write("}\r\n");
      out.write("</script>\r\n");
      out.write("</head>\r\n");
      out.write("\r\n");
      out.write("<body>\r\n");
      out.write("\r\n");
      out.write("<form name=LoginForm method=\"post\" action=\"login.do\">\r\n");
      out.write("<input type=\"hidden\" name=\"ServiceName\" value=\"login-service\" />\r\n");
      out.write("<input type=\"hidden\" name=\"find.x\" value=\"1\" />\r\n");
      out.write("\t<div id=\"body\"><BR>\r\n");
      out.write("\t<BR>\r\n");
      out.write("\t<BR>\r\n");
      out.write("\t<BR>\r\n");
      out.write("\t<BR>\r\n");
      out.write("\t\r\n");
      out.write("<table width=\"697\" height=\"100\"  border=\"0\" align=\"center\" cellpadding=\"0\" cellspacing=\"0\">\r\n");
      out.write("  <tr>\r\n");
      out.write("    <td>&nbsp;</td>\r\n");
      out.write("  </tr>\r\n");
      out.write("</table>\r\n");
      out.write("<table width=\"697\" border=\"0\" align=\"center\" cellpadding=\"0\" cellspacing=\"0\">\r\n");
      out.write("  <tr>\r\n");
      out.write("    <td height=\"184\" colspan=\"3\"><img src=\"/uComposer/img/ucube_img00_login01.JPG\" width=\"697\" height=\"184\"></td>\r\n");
      out.write("  </tr>\r\n");
      out.write("  <tr>\r\n");
      out.write("    <td width=\"348\"><img src=\"/uComposer/img/ucube_img00_login02.JPG\" width=\"348\" height=\"126\"></td>\r\n");
      out.write("    <td width=\"306\" height=\"126\" align=\"center\" valign=\"top\" background=\"/uComposer/img/ucube_img00_login04.JPG\"><table width=\"50\"  border=\"0\" cellspacing=\"0\" cellpadding=\"0\">\r\n");
      out.write("      <tr>\r\n");
      out.write("        <td><img src=\"/uComposer/img/comm_img02_blank.gif\" width=\"10\" height=\"5\"></td>\r\n");
      out.write("      </tr>\r\n");
      out.write("    </table>      \r\n");
      out.write("    <table width=\"260\"  border=\"0\" cellpadding=\"0\" cellspacing=\"0\">\r\n");
      out.write("      <tr>\r\n");
      out.write("        <td width=\"85\"><img src=\"/uComposer/img/comm_img00_login_username.gif\" width=\"78\" height=\"12\"></td>\r\n");
      out.write("        <td> <input type=\"text\" name=\"id\"  style=\"solid\" value=\"\" size=\"12\" titleKey=\"login.title.username\" tabindex=\"1\"></td>\r\n");
      out.write("        <td width=\"65\" rowspan=\"3\" valign=\"bottom\">\r\n");
      out.write("        <img src=\"/uComposer/img/comm_img00_login_btn.gif\" width=\"52\" height=\"22\" style=\"cursor:hand\" onclick=\"return login();\" /></td>\r\n");
      out.write("      </tr>\r\n");
      out.write("      <tr>\r\n");
      out.write("        <td colspan=\"2\"><img src=\"/uComposer/img/comm_img02_blank.gif\" width=\"10\" height=\"5\"></td>\r\n");
      out.write("        </tr>\r\n");
      out.write("      <tr>\r\n");
      out.write("        <td><img src=\"/uComposer/img/comm_img00_login_password.gif\" width=\"71\" height=\"13\"></td>\r\n");
      out.write("        <td><input type=\"password\"  name=\"password\" value=\"\" tabindex=\"2\" titleKey=\"login.title.password\" size=\"12\" maxlength=\"8\" onkeypress=\"javascript:return executeEnterKey();\" /></td>\r\n");
      out.write("     </tr>\r\n");
      out.write("    </table></td>\r\n");
      out.write("    <td width=\"43\"><img src=\"/uComposer/img/ucube_img00_login03.JPG\" width=\"43\" height=\"126\"></td>\r\n");
      out.write("  </tr>\r\n");
      out.write("</table>\r\n");
      out.write("<table width=\"50\"  border=\"0\" align=\"center\" cellpadding=\"0\" cellspacing=\"0\">\r\n");
      out.write("  <tr>\r\n");
      out.write("    <td><img src=\"/uComposer/img/comm_img02_blank.gif\" width=\"10\" height=\"10\"></td>\r\n");
      out.write("  </tr>\r\n");
      out.write("</table>\r\n");
      out.write("<table width=\"697\"  border=\"0\" align=\"center\" cellpadding=\"0\" cellspacing=\"0\">\r\n");
      out.write("  <tr>\r\n");
      out.write("    <td align=\"right\" valign=\"top\"><img src=\"/uComposer/img/comm_img00_login_copyright.gif\" width=\"697\" height=\"44\"></td>\r\n");
      out.write("  </tr>\r\n");
      out.write("</table>\r\n");
      out.write("</div>\r\n");
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

  private boolean _jspx_meth_bean_message_0(PageContext _jspx_page_context)
          throws Throwable {
    PageContext pageContext = _jspx_page_context;
    JspWriter out = _jspx_page_context.getOut();
    //  bean:message
    org.apache.struts.taglib.bean.MessageTag _jspx_th_bean_message_0 = (org.apache.struts.taglib.bean.MessageTag) _jspx_tagPool_bean_message_key_nobody.get(org.apache.struts.taglib.bean.MessageTag.class);
    _jspx_th_bean_message_0.setPageContext(_jspx_page_context);
    _jspx_th_bean_message_0.setParent(null);
    _jspx_th_bean_message_0.setKey("login.title");
    int _jspx_eval_bean_message_0 = _jspx_th_bean_message_0.doStartTag();
    if (_jspx_th_bean_message_0.doEndTag() == javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
      return true;
    _jspx_tagPool_bean_message_key_nobody.reuse(_jspx_th_bean_message_0);
    return false;
  }
}
