package com.kep.common;

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

	private Logger log = Logger.getLogger(this.getClass());
	private Properties prop;
	
	public IFProperties() {
		FileInputStream f	= null;
		String filePath		= "";

    	String osName = System.getProperty("os.name");
    	if (osName.toUpperCase().indexOf("WINDOWS") > -1) {
    		filePath = "./client/file.properties";
    	} else {
//    		filePath = "/EAI/B2B/java/" +CommonProperty.getDB_TYPE().toLowerCase()+ "/file/client/file.properties";
    		filePath = "/EAI/B2B/java/kepmp/file/client/file.properties";
    		
    	}

    	log.debug("osName : " + osName);
    	log.debug("filePath : " + filePath);
		
		try {
			prop = new Properties();
			f = new FileInputStream(filePath);
			
			prop.load(new BufferedInputStream(f));
		} catch (Exception e) {
			e.printStackTrace();
			log.error(e.getMessage());
		}
	}
	
	public IFProperties(String filePath) {
		FileInputStream f	= null;
		
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