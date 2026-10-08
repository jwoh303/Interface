/**
 * 
 */
package com.kep.common.dao;

import java.util.Map;

/**
 * @author jiwon
 *
 */
public interface ErrorLogMng_Dao {	
	
	public void saveErrLog(Map<String, Object> eMap) throws Exception;

}
