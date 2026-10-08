package com.kep.cretec.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;
import org.w3c.dom.Document;
import org.w3c.dom.Element;

import com.kep.common.CommonUtil;

@SuppressWarnings("unchecked")
public class CretecIfSignOn extends CretecBaseImpl {
	private Logger log	= Logger.getLogger( this.getClass().getName() );
	
	private String process_id	= "SignOn";
	private String process_url	= "/ctxext/signon.do";
	private String callUrl	= "";

	public Map<String,Object> signOn() {
		Document xmlDoc	= null;
		Map<String, Object> rMap = null;
		
		try {
			xmlDoc = super.getDocument(this.process_id);
			Element root = xmlDoc.getDocumentElement();	// root element 확인.
			Element body = xmlDoc.createElement(this.process_id);
			body.setAttribute("username", this.cretec_id);
			body.setAttribute("password", this.cretec_pw);
			
			log.info("this.cretec_id" + this.cretec_id);
			log.info("this.cretec_pw" + this.cretec_pw);
			
			root.appendChild(body);
			
			callUrl = this.cretec_domain+this.cretec_path+this.process_url;
			
			log.debug("URL : " + callUrl);
			
			rMap = super.sendHttpPost(callUrl, xmlDoc);
			
		} catch (Exception e) {
			log.error("signOn Error : " + CommonUtil.printStackTraceToString(e));
		} finally {
		}
		
		return rMap;
	}
}