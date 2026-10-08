package common;

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

	
	private Logger log = Logger.getLogger(this.getClass());;
	private Properties prop;
	
	public IFProperties() {
		FileInputStream f	= null;
		log.debug("초기화");
		String filePath = "./bin_sftp/properties/dbcon.properties";

		String curDir = System.getProperty("user.dir");
		log.debug("Dir : " + curDir);
		
		if ( curDir.indexOf("bin_sftp") > -1) {
			filePath = "./properties/dbcon.properties";
		}
		
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
	
	/* 경로 입력받기 */
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