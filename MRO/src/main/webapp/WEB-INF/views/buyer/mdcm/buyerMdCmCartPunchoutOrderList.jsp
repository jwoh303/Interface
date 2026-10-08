<%--
**********************************************
* 메뉴 : 장바구니 PUNCHOUT 주문전송
* 화면 : 장바구니 PUNCHOUT 주문전송
* 기능 : 장바구니 PUNCHOUT 주문전송
* 프로그램 ID : PG_02_B_000834_005
* 담당자 : 현명환
* 착수일 : 2014-03-03
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page language="java" import="java.sql.*,java.io.*,java.util.*,java.net.*,javax.*" %>
<%@ page import="javax.naming.*" %>
<%@ page import="javax.naming.directory.*" %>
<%@ page import="javax.sql.DataSource" %>
<%@ page import="javax.sql.*" %>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<!DOCTYPE html>
<%

	// 장바구니 상품 삭제
	String com_code     = null2sp(request.getParameter("st_com_code"));
	String user_id         = null2sp(request.getParameter("st_user_id"));
    String query           = null2sp(request.getParameter("st_query"));
    String ReturnURL     = null2sp(request.getParameter("st_return_url"));

	// 장바구니 목록을 XML 문서로 작성
	StringBuffer cart_buf = new StringBuffer();

	cart_buf.append("<?xml version = \"1.0\" encoding=\"utf-8\"?>										\n");
	cart_buf.append("<response>																								\n");
	cart_buf.append("	<header version=\"1.0\">																		\n");
	cart_buf.append("		<return returnCode=\"S\"/>																\n");
	cart_buf.append("	</header>																								\n");
	cart_buf.append("	<body>																									\n");
	cart_buf.append("		<OrderLinesDataElements>																	\n");


	String cart_srt   = null2sp(request.getParameter("st_query_cart"));
	String cart_arr[] = StrToArray(cart_srt , "^||^");
	
	for(int i=0 ; i < cart_arr.length; i++){
		String str[] = StrToArray(cart_arr[i] , "@@");

		for( int k=0; k < str.length; k++){
		}


		cart_buf.append("			<orderLine>																\n");
		cart_buf.append("				<item lineType=\"GOODS\" quantity=\"").append(str[1]).append("\">	\n");
		cart_buf.append("					<itemNumber>													\n");

		// 재고로 구입시만
		if(!null2sp(str[6].trim()).equals("") || !null2sp(str[6].trim()).equals(" ")){

			cart_buf.append("						<buyerItemNumber>											\n");
			cart_buf.append("							<itemID>												\n");
			cart_buf.append(								str[6]												   );
			cart_buf.append("							</itemID>												\n");
			cart_buf.append("						</buyerItemNumber>											\n");
		}

		cart_buf.append("						<supplierItemNumber>										\n");
		cart_buf.append("							<itemID>												\n");
		cart_buf.append(								str[0]												   );
		cart_buf.append("							</itemID>												\n");
		cart_buf.append("						</supplierItemNumber>										\n");
		cart_buf.append("					</itemNumber>													\n");
	if(!null2sp(str[9].trim()).equals("") || !null2sp(str[9].trim()).equals(" ")){
	  if(null2sp(str[6].trim()).equals("") || null2sp(str[6].trim()).equals(" ")){
		cart_buf.append("					<itemDescription> <![CDATA[").append(str[4]).append(" ").append(str[5]).append("(EXPENSE)").append("]]></itemDescription>	\n");
	  }else{
		cart_buf.append("					<itemDescription> <![CDATA[").append(str[4]).append(" ").append(str[5]).append("]]></itemDescription>	\n");
	  }	
	}else{
		cart_buf.append("					<itemDescription> <![CDATA[").append(str[4]).append(" ").append(str[5]).append("]]></itemDescription>	\n");
	}	
		cart_buf.append("					<manufacturerName></manufacturerName>                           \n");

		cart_buf.append("					<unitOfMeasure>													\n");
		cart_buf.append("						<supplierUnitOfMeasure>										\n");
		cart_buf.append("							<supplierUOMType>										\n");
		cart_buf.append("								<![CDATA[").append(str[2]).append("]]>				\n");
		cart_buf.append("							</supplierUOMType>										\n");
		cart_buf.append("						</supplierUnitOfMeasure>									\n");
		cart_buf.append("					</unitOfMeasure>												\n");
		cart_buf.append("				</item>																\n");
		cart_buf.append("				<category>															\n");
		cart_buf.append("					<categoryCode categoryCodeIdentifier=\"SUPPLIER\">				\n");
		cart_buf.append("						").append(str[8]).append("									\n");
		cart_buf.append("					</categoryCode>													\n");
		cart_buf.append("				</category>															\n");
		cart_buf.append("				<price>																\n");
		cart_buf.append("					<currency>														\n");
		cart_buf.append("						").append(str[7]).append("									\n");
		cart_buf.append("					</currency>														\n");
		cart_buf.append("					<unitPrice>														\n");
		cart_buf.append("						").append(str[3]).append("									\n");
		cart_buf.append("					</unitPrice>													\n");
		cart_buf.append("				</price>															\n");
		cart_buf.append("				<supplier>															\n");
		cart_buf.append("					<supplierTradingPartnerCode>34240</supplierTradingPartnerCode>	\n");
		cart_buf.append("					<supplierName>													\n");
		cart_buf.append("						KEP															\n");
		cart_buf.append("					</supplierName>													\n");
		cart_buf.append("				</supplier>															\n");
		cart_buf.append("				<additionalAttributes>												\n");
		cart_buf.append("					<attribute1></attribute1>	          \n");
		cart_buf.append("					<attribute2></attribute2>	          \n");
		cart_buf.append("					<attribute3></attribute3>	          \n");
		cart_buf.append("					<attribute4></attribute4>	          \n");
		cart_buf.append("					<attribute5></attribute5>	          \n");
		cart_buf.append("					<attribute6></attribute6>	          \n");
		cart_buf.append("					<attribute7></attribute7>	          \n");
	if(null2sp(str[10].trim()).equals("Y")){	
		cart_buf.append("					<attribute8>YES</attribute8>        \n");
	}else{
		cart_buf.append("					<attribute8>NO</attribute8>        \n");
	}		
		cart_buf.append("					<attribute9></attribute9>	          \n");
		cart_buf.append("					<attribute10></attribute10>	          \n");
		cart_buf.append("					<attribute11></attribute11>	          \n");
		cart_buf.append("					<attribute12></attribute12>	          \n");
		cart_buf.append("					<attribute13></attribute13>	          \n");
		cart_buf.append("					<attribute14></attribute14>	          \n");
		cart_buf.append("					<attribute15></attribute15>	          \n");
		cart_buf.append("				</additionalAttributes>												\n");
		cart_buf.append("			</orderLine>															\n");
	}

	cart_buf.append("		</OrderLinesDataElements>													\n");
	cart_buf.append("	</body>																			\n");
	cart_buf.append("</response>																		\n");


	String cart_list = cart_buf.toString();

	cart_list = URLUTF8Encoder_encode(cart_list);

%>

<html>
<head>
<script language="javascript">

	function send_cart(){

		document.forms[0].method = "post";
		document.forms[0].action = "<%=ReturnURL%>";
		document.forms[0].submit();
	}

</script>
</head>

<body onLoad="javascript:send_cart();" >
<center>
	<form >
		<input type="hidden" name="oracleCart" value="<%=cart_list%>"  >
	</form>
</center>
</body>
</html>
<%!
public static String URLUTF8Encoder_encode(String s){
	   String[] hex = {
			"%00", "%01", "%02", "%03", "%04", "%05", "%06", "%07",
			"%08", "%09", "%0a", "%0b", "%0c", "%0d", "%0e", "%0f",
			"%10", "%11", "%12", "%13", "%14", "%15", "%16", "%17",
			"%18", "%19", "%1a", "%1b", "%1c", "%1d", "%1e", "%1f",
			"%20", "%21", "%22", "%23", "%24", "%25", "%26", "%27",
			"%28", "%29", "%2a", "%2b", "%2c", "%2d", "%2e", "%2f",
			"%30", "%31", "%32", "%33", "%34", "%35", "%36", "%37",
			"%38", "%39", "%3a", "%3b", "%3c", "%3d", "%3e", "%3f",
			"%40", "%41", "%42", "%43", "%44", "%45", "%46", "%47",
			"%48", "%49", "%4a", "%4b", "%4c", "%4d", "%4e", "%4f",
			"%50", "%51", "%52", "%53", "%54", "%55", "%56", "%57",
			"%58", "%59", "%5a", "%5b", "%5c", "%5d", "%5e", "%5f",
			"%60", "%61", "%62", "%63", "%64", "%65", "%66", "%67",
			"%68", "%69", "%6a", "%6b", "%6c", "%6d", "%6e", "%6f",
			"%70", "%71", "%72", "%73", "%74", "%75", "%76", "%77",
			"%78", "%79", "%7a", "%7b", "%7c", "%7d", "%7e", "%7f",
			"%80", "%81", "%82", "%83", "%84", "%85", "%86", "%87",
			"%88", "%89", "%8a", "%8b", "%8c", "%8d", "%8e", "%8f",
			"%90", "%91", "%92", "%93", "%94", "%95", "%96", "%97",
			"%98", "%99", "%9a", "%9b", "%9c", "%9d", "%9e", "%9f",
			"%a0", "%a1", "%a2", "%a3", "%a4", "%a5", "%a6", "%a7",
			"%a8", "%a9", "%aa", "%ab", "%ac", "%ad", "%ae", "%af",
			"%b0", "%b1", "%b2", "%b3", "%b4", "%b5", "%b6", "%b7",
			"%b8", "%b9", "%ba", "%bb", "%bc", "%bd", "%be", "%bf",
			"%c0", "%c1", "%c2", "%c3", "%c4", "%c5", "%c6", "%c7",
			"%c8", "%c9", "%ca", "%cb", "%cc", "%cd", "%ce", "%cf",
			"%d0", "%d1", "%d2", "%d3", "%d4", "%d5", "%d6", "%d7",
			"%d8", "%d9", "%da", "%db", "%dc", "%dd", "%de", "%df",
			"%e0", "%e1", "%e2", "%e3", "%e4", "%e5", "%e6", "%e7",
			"%e8", "%e9", "%ea", "%eb", "%ec", "%ed", "%ee", "%ef",
			"%f0", "%f1", "%f2", "%f3", "%f4", "%f5", "%f6", "%f7",
			"%f8", "%f9", "%fa", "%fb", "%fc", "%fd", "%fe", "%ff"
		};

		StringBuffer sbuf = new StringBuffer();
		int len = s.length();

		for (int i = 0; i < len; i++) {
			int ch = s.charAt(i);

			if ('A' <= ch && ch <= 'Z') {		// 'A'..'Z'
				sbuf.append((char)ch);
			}else if ('a' <= ch && ch <= 'z') {	// 'a'..'z'
				sbuf.append((char)ch);
			}else if ('0' <= ch && ch <= '9') {	// '0'..'9'
				sbuf.append((char)ch);
			}else if (ch == ' ') {			// space
				sbuf.append('+');
			}else if (ch == '-' || ch == '_'		// unreserved
				  || ch == '.' || ch == '!'
				  || ch == '~' || ch == '*'
				  || ch == '\'' || ch == '('
				  || ch == ')') {
				sbuf.append((char)ch);
			}else if (ch <= 0x007f){		// other ASCII
				sbuf.append(hex[ch]);
			}else if (ch <= 0x07FF){		// non-ASCII <= 0x7FF
				sbuf.append(hex[0xc0 | (ch >> 6)]);
				sbuf.append(hex[0x80 | (ch & 0x3F)]);
			}else{					// 0x7FF < ch <= 0xFFFF
				sbuf.append(hex[0xe0 | (ch >> 12)]);
				sbuf.append(hex[0x80 | ((ch >> 6) & 0x3F)]);
				sbuf.append(hex[0x80 | (ch & 0x3F)]);
			}
		}
		return sbuf.toString();
	}

public String null2sp(String str) {
	if ( str == null || str == "" || str == "null" || str.equals("") || str.equals("null") || str.equals(null)) return "";
	else return str;
}

public static String[] StrToArray(String str, String str2)
{
    StringTokenizer st = new StringTokenizer(str, str2, false);
    int cnt = st.countTokens();
    String value[] = new String[cnt];
    for(int count = 0; count < cnt; count++)
    {
        value[count] = st.nextToken().trim();
        if(value[count].length() == 0)
            value[count] = " ";
    }

    return value;
}
%>
