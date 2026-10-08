package com.kep.cretec.service;

import java.util.Map;

import javax.xml.namespace.QName;

import org.w3c.dom.Document;
import org.w3c.dom.Node;

public interface CretecBase {
	
	public Document getDocument(String xmlId) throws Exception;
	
	public Map<String, Object> sendHttpPost(String url, Document xmlDoc ) throws Exception;
	
	public Object getXmlValue(String id, QName type) throws Exception;
	
	public String getXmlString(String id) throws Exception;

	public Map<String, Object> sendHttpPost(String url, String date) throws Exception;
}