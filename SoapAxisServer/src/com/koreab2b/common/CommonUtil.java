package com.koreab2b.common;

import java.io.StringWriter;
import java.io.Writer;
import java.lang.reflect.Field;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.transform.OutputKeys;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;

import org.w3c.dom.Document;
import org.w3c.dom.Element;

public class CommonUtil {
	
    public static String printStackTraceToString(Throwable e) {
        StringBuffer sb = new StringBuffer();
        try {
            sb.append(e.toString());
            sb.append("\n");
            StackTraceElement element[] = e.getStackTrace();
            for (int idx = 0; idx < element.length; idx++) {
                sb.append("\tat ");
                sb.append(element[idx].toString());
                sb.append("\n");
            }
        } catch (Exception ex) {
            return e.toString();
        }
        return sb.toString();
    }
    
    public static HashMap<String, Object> convertVoToMap(Object obj) {
    	HashMap<String, Object> rtnMap	= new HashMap<String, Object>();
    	
    	Field[] fList = obj.getClass().getDeclaredFields(); 
    	
    	for(Field fItem : fList) {
    		String fId	= fItem.getName();
    		Object fData	=	null;
    		try {
        		fData	= obj.getClass().getDeclaredMethod("get"+fId).invoke(obj);	
			} catch (Exception e) {
			}
    		rtnMap.put(fId, fData);
    	}
    	
    	return rtnMap;
    }

	public static String null2sp(String str) {
		
		String rtn = "";
		
		try {
			if( !"".equals(str) && str != null) {
				rtn = str;
			}
		} catch (Exception e) {
		}
		
		return rtn;
	}
	
	public static String makeElement(String name, String value) {
		String rtn = "";
		
		if ( value == null || "".equals(value) ) {
			rtn = "	<"+name+"/>\n";
		} else {
			rtn = "	<"+name+">"+value+"</"+name+">\n";
		}
		
		return rtn;
	}

	public static Document getDocument(String xmlId) throws Exception {
		DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
		DocumentBuilder builder = dbf.newDocumentBuilder();
		Document xmlDoc	= builder.newDocument();
		
		Element root	= xmlDoc.createElement(xmlId);
		
		xmlDoc.appendChild(root);
		
		return xmlDoc;
	}
	
	public static Element makeXmlElementForMap(Document xmlDoc, String tagName, Map<String, String> iMap) {
		
		Element rtnObj	=  xmlDoc.createElement(tagName);
		
		Iterator<String> keySet = iMap.keySet().iterator();
		
		while(keySet.hasNext()) {
			String key	= keySet.next();
			String value = iMap.get(key);
			Element child = makeXmlElement(xmlDoc, key, value);
			rtnObj.appendChild(child);
		}
		
		return rtnObj;
	}
	
	public static Element makeXmlElement(Document xmlDoc, String tagName, String value) {
		
		Element xmlObj	=  xmlDoc.createElement(tagName);
		xmlObj.setTextContent(value);
		
		return xmlObj;
	}
	
	public static String xmlToString(Document xmlDoc) {
		
		String xmlStr	= null;

		try {
			Transformer tf = TransformerFactory.newInstance().newTransformer();
			tf.setOutputProperty(OutputKeys.ENCODING, "UTF-8");
			tf.setOutputProperty(OutputKeys.INDENT,"yes");
			Writer out = new StringWriter();
			tf.transform(new DOMSource(xmlDoc), new StreamResult(out));	
			
			xmlStr	= out.toString();
		} catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
		}
		
		return xmlStr;
	}
}
