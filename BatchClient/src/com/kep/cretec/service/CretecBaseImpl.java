package com.kep.cretec.service;

import java.io.StringWriter;
import java.io.Writer;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.xml.namespace.QName;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.transform.OutputKeys;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;
import javax.xml.xpath.XPath;
import javax.xml.xpath.XPathConstants;
import javax.xml.xpath.XPathFactory;

import org.apache.http.Header;
import org.apache.http.HttpEntity;
import org.apache.http.HttpResponse;
import org.apache.http.NameValuePair;
import org.apache.http.client.entity.UrlEncodedFormEntity;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.impl.client.BasicCookieStore;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.message.BasicNameValuePair;
import org.apache.http.util.EntityUtils;
import org.apache.log4j.Logger;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;

import com.kep.common.CommonProperty;
import com.kep.common.CommonUtil;
import com.kep.cretec.dao.CretecDao;
import com.kep.cretec.dao.CretecDaoImpl;

public class CretecBaseImpl implements CretecBase {
	private Logger log	= Logger.getLogger( this.getClass().getName() );
	private String st_ctxId	= "13893028";
	public String cretec_domain	= "";
	public String cretec_path	= "";
	public String cretec_id	= "";
	public String cretec_pw	= "";
	public CretecDao	dao;
	public XPath xpath = null;
	public String JSESSIONID = null;
	public Node	_dataNode	= null;
	
	public CretecBaseImpl () {
		
		try {
			dao = new CretecDaoImpl();
			Map<String, String> iMap = new HashMap<String, String>();
			iMap.put("server_mode", CommonProperty.getDB_CONN());
			
			Map<String, Object> prop = dao.getCretecProperty(iMap);
			
			this.cretec_domain = (String)prop.get("DOMAIN");
			this.cretec_path = (String)prop.get("PATH");
			this.cretec_id	= (String)prop.get("ID");
			this.cretec_pw	= (String)prop.get("PW");

    		this.xpath = XPathFactory.newInstance().newXPath();
			
		} catch (Exception e) {
			log.error("Cretec Constructor : " + CommonUtil.printStackTraceToString(e));
		}
	}

	@Override
	public Document getDocument(String xmlId) throws Exception {
		DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
		DocumentBuilder builder = dbf.newDocumentBuilder();
		Document xmlDoc	= builder.newDocument();
		
		// xml Root Element
		Element root	= xmlDoc.createElement("Request");
		root.setAttribute("comp", "KEP");
		root.setAttribute("ctxId", this.st_ctxId);
		root.setAttribute("id", xmlId);
		root.setAttribute("xmlns", "http://nctx.cretec.kr/nctx/schema");
		root.setAttribute("xmlns:xsi", "http://www.w3.org/2001/XMLSchema-instance");
		root.setAttribute("xsi:schemaLocation", "http://nctx.cretec.kr/nctx/schema/CTX_Request-1.1.xsd");
		
		xmlDoc.appendChild(root);
		
		return xmlDoc;
	}

	@Override
	public Map<String, Object> sendHttpPost(String url, Document xmlDoc) throws Exception {
		Map<String, Object> rMap	= new HashMap<String, Object>();
		int rc = 0;
		String xmlStr	= null;
		String sessionId	= null;
		
		Transformer tf = TransformerFactory.newInstance().newTransformer();
		tf.setOutputProperty(OutputKeys.ENCODING, "UTF-8");
		tf.setOutputProperty(OutputKeys.INDENT,"yes");
		Writer out = new StringWriter();
		tf.transform(new DOMSource(xmlDoc), new StreamResult(out));

        xmlStr	= out.toString();
        log.debug("XML Content : \n" + xmlStr);
        
        DefaultHttpClient client = new DefaultHttpClient();
        BasicCookieStore cookieStore = new BasicCookieStore();
        
        HttpPost post = new HttpPost(url);
        
        List<NameValuePair> params = new ArrayList<NameValuePair>();
        params.add(new BasicNameValuePair("ctxId", this.st_ctxId));
        params.add(new BasicNameValuePair("xmlBody", xmlStr));
        post.setEntity(new UrlEncodedFormEntity(params, "UTF-8"));

        if ( !"".equals(this.JSESSIONID) && this.JSESSIONID != null ) {
        	post.setHeader("Cookie", "JSESSIONID="+this.JSESSIONID + "; path=CtxApp");
        }
        
        HttpResponse resp = client.execute(post);
        
        rc = resp.getStatusLine().getStatusCode();
        
        if (rc == 200) {
            HttpEntity rEntity = resp.getEntity();
            Header[] headers = resp.getAllHeaders();
            
            for(Header iHeader : headers) {
            	if ("Set-Cookie".equals(iHeader.getName()) ) {
            		String[] _cookieStr = iHeader.getValue().split(";");
            		for(String iStr : _cookieStr) {
            			String[] arrStr = iStr.split("=");
            			
            			if ("JSESSIONID".equals(arrStr[0])) {
            				sessionId = arrStr[1];
            			}
            		}
            	}
            }
            
    		DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
    		DocumentBuilder builder = dbf.newDocumentBuilder();
    		Document rtnDoc	= builder.parse( rEntity.getContent() );
    		String rtnMsg = (String)this.xpath.evaluate("/Response/Result", rtnDoc, XPathConstants.STRING);
    		
    		log.debug("rtnMsg : " + rtnMsg);
    		
    		if("success".equals(rtnMsg)) {
            	rMap.put("RTN_FLAG","S");
            	rMap.put("RTN_MSG",rtnMsg);
            	rMap.put("RTN_DATA", rtnDoc);
            	rMap.put("JSESSIONID", sessionId);
    		} else {
            	rMap.put("RTN_FLAG","F");
            	rMap.put("RTN_MSG",rtnMsg);
            	rMap.put("ERROR",(String)this.xpath.evaluate("/Response/Error", rtnDoc, XPathConstants.STRING));
            	log.error("Error : " + (String)this.xpath.evaluate("/Response/Error", rtnDoc, XPathConstants.STRING));
    		}
        } else {
        	rMap.put("RTN_FLAG","F");
        	rMap.put("RTN_MSG","Failure");
        }
		
		return rMap;
	}
	
	
	@Override
	public Map<String, Object> sendHttpPost(String url, String ivDate) throws Exception {
		Map<String, Object> rMap	= new HashMap<String, Object>();
		int rc = 0;
		String xmlStr	= null;
		String sessionId	= null;
		
		Transformer tf = TransformerFactory.newInstance().newTransformer();
		tf.setOutputProperty(OutputKeys.ENCODING, "UTF-8");
		tf.setOutputProperty(OutputKeys.INDENT,"yes");
		Writer out = new StringWriter();
		tf.transform(new DOMSource(), new StreamResult(out));

        xmlStr	= out.toString();
        log.debug("XML Content : \n" + xmlStr);
        
        DefaultHttpClient client = new DefaultHttpClient();
        BasicCookieStore cookieStore = new BasicCookieStore();
        
		HttpGet get = new HttpGet(url+ "?relsDt=" + ivDate);
        
		
        List<NameValuePair> params = new ArrayList<NameValuePair>();
        params.add(new BasicNameValuePair("ctxId", this.st_ctxId));
        params.add(new BasicNameValuePair("xmlBody", xmlStr));

        if ( !"".equals(this.JSESSIONID) && this.JSESSIONID != null ) {
        	get.setHeader("Cookie", "JSESSIONID="+this.JSESSIONID + "; path=CtxApp");
        	get.addHeader("Content-Type", "application/json");
        	get.addHeader("Accept", "application/json; charset=UTF-8");
        }
        
        HttpResponse resp = client.execute(get);
        
        rc = resp.getStatusLine().getStatusCode();
		
        if (rc == 200) {
        	String response = EntityUtils.toString(resp.getEntity());
        	rMap.put("flag", "S");
        	rMap.put("response", response);
        	log.info("rMap 200 :: " + rMap );
        	log.info("rMap response :: " + response );
         }else {
        	 rMap.put("flag", "E");
        	 log.info("rMap 200 !!:: " + rMap );
         }
		return rMap;
	}
	

	@Override
	public Object getXmlValue(String id, QName type) throws Exception {
		Object rtn	= null;
		rtn	= this.xpath.evaluate("./"+id, _dataNode, type);
		return rtn;
	}

	@Override
	public String getXmlString(String id) throws Exception {
		String rtn	= null;
		rtn	=	(String)getXmlValue(id, XPathConstants.STRING);
		return rtn;
	}
}