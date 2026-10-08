package com.aeky.budget.send.service;

import java.io.BufferedInputStream;
import java.io.FileInputStream;
import java.util.Properties;

import org.apache.log4j.Logger;

/**
 * cowayInterface.Properties
 * @author jinsoo97
 * @remark 속성치 값을 읽어서 사용한다.
 */
public class IFProperties {

	
	private Logger log = null;
	private Properties prop;
	
	public IFProperties() {
		FileInputStream f	= null;
		String filePath		= "../properties/aekyIF.properties";
		
		try {
			log	= Logger.getLogger(this.getClass());
			prop = new Properties();
			f = new FileInputStream(filePath);
			
			prop.load(new BufferedInputStream(f));
		} catch (Exception e) {
			e.printStackTrace();
			log.error(e.getMessage());
		}
	}
	
	public String getProperty(String name) {
		String rtn	= "";
		
		try {
			rtn	= prop.getProperty(name);
		} catch (Exception e) {
			e.printStackTrace();
			log.error(e.getMessage());
		}
		return rtn;
	}
}