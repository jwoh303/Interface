<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>

<%@ page import="java.net.*"%>
<%@ page import="java.util.*" %>
<%@ page import="java.io.*" %>
<%@ page import="org.w3c.dom.*"%>
<%@ page import="javax.xml.parsers.*"%>
<%@ page import="org.w3c.dom.*"%>
<%@ page import="javax.xml.xpath.*"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="java.sql.Timestamp"%>

<%@ page import="java.net.HttpURLConnection"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>

<%

	String httpVersion = request.getProtocol();

	if(httpVersion.equals("HTTP/1.0")){	//HTTP 1.0
		response.setHeader("Pragma","no-cache");
		response.setDateHeader ("Expires", 0);				// proxy server에 캐쉬되는 것 막는다.
	}else{	//HTTP 1.1
		response.setHeader("Cache-Control","no-store");
	}

	SessionInfo sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
	
	String st_dept_code	= sessionInfo.getDepartment();
	String st_dept_name	= sessionInfo.getDepartmentName();
	String st_user_id	= sessionInfo.getUserId();
	String st_user_name	= sessionInfo.getUserNameLoc();
	String st_email		= sessionInfo.getEmail();
	String st_tel_no	= sessionInfo.getTel();
	String st_fax_no	= sessionInfo.getFax();

	String qt_buyer			= CommonUtil.nvl((String)request.getParameter("qt_buyer"));
	String qt_quotation_no	= CommonUtil.nvl((String)request.getParameter("qt_quotation_no"));
	String qt_quotation_seq	= CommonUtil.nvl((String)request.getParameter("qt_quotation_seq"));
	String qt_revision		= CommonUtil.nvl((String)request.getParameter("qt_revision"));
	String qt_rfq_kep_user	= CommonUtil.nvl((String)request.getParameter("qt_rfq_kep_user"));
	
	String p_flag	= CommonUtil.nvl((String)request.getParameter("p_flag"));
	String it_buyer	= CommonUtil.nvl((String)request.getParameter("it_buyer"));
	String it_doc_no	= CommonUtil.nvl((String)request.getParameter("it_doc_no"));
	String it_searchTerm	= CommonUtil.nvl((String)request.getParameter("it_searchTerm"));

	boolean bDsFlag	= CommonUtil.getSpecialCheckReturn(qt_buyer,"P04-4052-01");
	
	if(bDsFlag && "MD".equals(p_flag)) {
		p_flag = "DS";
	}
	
	String xmlStr = "";
	String loginURL = "";
	String return_code = "";
	StringBuffer strbuf     = new StringBuffer();
	
	HttpURLConnection connection = null;
	OutputStream os =null;
	String returnString = "";
	
	// 변수정의
	String Identity	 = "";
	String companyCode	= "";
	String BrowserFormPost	= "";
	String Connection_url  =  "";
	String RequestURL 	= request.getRequestURL().toString();
	
	if (RequestURL.indexOf("www.koreab2b.com") > -1) {
		// Live
		Identity	= "kep-misumi-prod";
		if ("MD".equals(p_flag)) {
			companyCode	= "PROD_KeP_MD";
			BrowserFormPost	= "https://www.koreab2b.com/mpso/setMisumiQT.do?st_buyer="+qt_buyer+"&amp;st_quotation_no="+qt_quotation_no+"&amp;st_quotation_seq="+qt_quotation_seq+"&amp;st_revision="+qt_revision+"&amp;st_kep_user="+qt_rfq_kep_user;
			Connection_url	= "https://www.cataren.misumi-ec.com/cataren/checkin/D9D8CD95B5C14E0DB48FEE7289C5689F.ctl";
		} else if ("DS".equals(p_flag)) {
			companyCode	= "PROD_KeP_MD_DS";
			BrowserFormPost	= "https://www.koreab2b.com/mpso/setMisumiQT.do?st_buyer="+qt_buyer+"&amp;st_quotation_no="+qt_quotation_no+"&amp;st_quotation_seq="+qt_quotation_seq+"&amp;st_revision="+qt_revision+"&amp;st_kep_user="+qt_rfq_kep_user;
			Connection_url	= "https://www.cataren.misumi-ec.com/cataren/checkin/D9D8CD95B5C14E0DB48FEE7289C5689F.ctl";	
		} else {
			companyCode	= "PROD_KeP_sales";
			BrowserFormPost	= "https://www.koreab2b.com/mpso/setMisumiItSave.do?st_buyer="+it_buyer+"&amp;st_user="+st_user_id;
			Connection_url	= "https://www.cataren.misumi-ec.com/cataren/checkin/06040F8E082149CDBC0609BB94D9CB6F.ctl";
		}
	} else {
		// Dev
		Identity	= "kep-misumi-stg";
		if ("MD".equals(p_flag)) {
			companyCode	= "TST_KeP_PROC";
			BrowserFormPost	= "https://kepdev.koreab2b.com/mpso/setMisumiQT.do?st_buyer="+qt_buyer+"&amp;st_quotation_no="+qt_quotation_no+"&amp;st_quotation_seq="+qt_quotation_seq+"&amp;st_revision="+qt_revision+"&amp;st_kep_user="+qt_rfq_kep_user;
			Connection_url	= "https://www.cataren.misumi-ec.com/cataren/checkin/207C932E09C04466A6CEE6AB1A5947D7.ctl";			
// 			https://www.cataren.misumi-ec.com/cataren/checkin/C0DC1FA5D82D4978971EFFAF282C9D44.ctl
		} else if ("DS".equals(p_flag)) {
			companyCode	= "TEST_KeP_MD_DS";
			BrowserFormPost	= "https://kepdev.koreab2b.com/mpso/setMisumiQT.do?st_buyer="+qt_buyer+"&amp;st_quotation_no="+qt_quotation_no+"&amp;st_quotation_seq="+qt_quotation_seq+"&amp;st_revision="+qt_revision+"&amp;st_kep_user="+qt_rfq_kep_user;
			Connection_url	= "https://www.cataren.misumi-ec.com/cataren/checkin/C0DC1FA5D82D4978971EFFAF282C9D44.ctl";
		} else {
			companyCode	= "KeP_sales_ken";
			BrowserFormPost	= "https://kepdev.koreab2b.com/mpso/setMisumiItSave.do?st_buyer="+it_buyer+"&amp;st_user="+st_user_id;
			Connection_url	= "https://stg.cataren.misumi-ec.com/cataren/checkin/9151B47D5F3D434BA53DD32C6F8230DA.ctl";
		}
	}

	try{
		Timestamp timestamp = new Timestamp(System.currentTimeMillis());
		StringBuffer xml = new StringBuffer();

		// 2017-06-22T10:11:43+08:00
		// 2017-09-04 13:36:17.481
		xml.append("<cXML payloadID='KEP212919120170622110000' timestamp='2017-09-01T10:11:43+08:00'>\n");
		xml.append(" <Header>\n");
		xml.append("  <From>\n");
		xml.append("   <Credential domain='KEP'>\n");
		xml.append("    <Identity>KEP</Identity>\n");
		xml.append("   </Credential>\n");
		xml.append("  </From>\n");
		xml.append("  <To>\n");
		xml.append("   <Credential domain='MISUMI'>\n");
		xml.append("    <Identity>MISUMI</Identity>\n");
		xml.append("   </Credential>\n");
		xml.append("  </To>\n");
		xml.append("  <Sender>\n");
		xml.append("   <Credential domain='KEP'>\n");
		xml.append("    <Identity>"+Identity+"</Identity>\n");
		xml.append("    <SharedSecret>VWbsCeMyL5X2</SharedSecret>\n");
		xml.append("   </Credential>\n");
		xml.append("   <UserAgent>cust-Procurment</UserAgent>\n");
		xml.append("  </Sender>\n");
		xml.append(" </Header>\n");
		xml.append(" <Request>\n");
		xml.append("  <PunchOutSetupRequest operation='create'>\n");
		xml.append("   <BuyerCookie>1234567890AB</BuyerCookie>\n");
		xml.append("   <Extrinsic name='systemcompanyCode'>MSMTST</Extrinsic>\n");
		xml.append("   <Extrinsic name='companyCode'>"+companyCode+"</Extrinsic>\n");
		xml.append("   <Extrinsic name='officeCode'>"+st_dept_code+"</Extrinsic>\n");
		xml.append("   <Extrinsic name='userID'>"+st_user_id+"</Extrinsic>\n");
		xml.append("   <Extrinsic name='username'>"+st_user_name+"</Extrinsic>\n");
		xml.append("   <Extrinsic name='usermailaddress'>"+st_email+"</Extrinsic>\n");
		xml.append("   <Extrinsic name='usertel'>.</Extrinsic>\n");
		xml.append("   <Extrinsic name='searchWord'>"+it_searchTerm+"</Extrinsic>\n");
		xml.append("   <BrowserFormPost>\n");
		xml.append("    <URL>"+BrowserFormPost+"</URL>\n");
		xml.append("   </BrowserFormPost>\n");
		xml.append("  </PunchOutSetupRequest>\n");
		xml.append(" </Request>\n");
		xml.append("</cXML>\n");

		xmlStr = xml.toString();
		System.out.println(xmlStr);
		System.out.println(Connection_url);
		
		URL  msm_url = new  URL(Connection_url);
        connection = (HttpURLConnection)msm_url.openConnection();
        connection.setDoOutput(true);
        connection.setRequestMethod("POST");
        connection.setRequestProperty( "Content-Type", "application/x-www-form-urlencoded" );
        connection.setRequestProperty( "Content-Length", Integer.toString(xmlStr.length()) );
        os = connection.getOutputStream();
        os.write(xmlStr.getBytes("utf-8") );
        os.flush();
        os.close();

           //결과값 수신
		int rc = connection.getResponseCode();
           
        StringBuffer str = new StringBuffer();
        BufferedReader br = new BufferedReader(new InputStreamReader(connection.getInputStream(), "UTF-8"));
        String ts = null;
		while ((ts = br.readLine()) != null) {
			str.append(ts);
		}
		
		if(rc==200){
			DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
			DocumentBuilder builder = factory.newDocumentBuilder();
			Document doc = builder.parse(new ByteArrayInputStream(str.toString().getBytes("UTF-8")));
			XPath xpath = XPathFactory.newInstance().newXPath();
	        NodeList cols = (NodeList)xpath.evaluate("//cXML/Response/PunchOutSetupResponse/StartPage/URL", doc, XPathConstants.NODESET);
	        response.sendRedirect(cols.item(0).getChildNodes().item(0).getNodeValue());	
         }else{
             System.out.println("http response code error: "+rc+"\n");
         }

	}catch(Exception ex){
		ex.printStackTrace();
	}

%>

<html>
<body>
</body>
</html>
