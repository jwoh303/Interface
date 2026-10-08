/**
 * 
 */
package com.kep.common.dao;

import java.io.Reader;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.ibatis.common.resources.Resources;
import com.ibatis.sqlmap.client.SqlMapClient;
import com.ibatis.sqlmap.client.SqlMapClientBuilder;
import com.kep.common.CommonProperty;
import com.kep.common.CommonUtil;

/**
 * @author jiwon
 *
 */
@SuppressWarnings("unchecked")
public class ErrorLogMng_DaoImpl implements ErrorLogMng_Dao {
	private static 	Logger		log		= Logger.getLogger(UpdateIfStatus_DaoImpl.class);
	private SqlMapClient sqlMapper;
	
	//BatchClient
	public ErrorLogMng_DaoImpl() {
		try {
			String source	= "";
			if ( "2".equals(CommonProperty.getDB_CONN()) ) {
				source	= "conf/SqlMapConfig_Live.xml";
			} else {
				source	= "conf/SqlMapConfig_Dev.xml";
			}
			Reader reader = Resources.getResourceAsReader(source);
			this.sqlMapper = SqlMapClientBuilder.buildSqlMapClient(reader);
		} catch (Exception e) {
		    log.error(e.getMessage());
		    throw new RuntimeException("Something bad happened while building the SqlMapClient instance." + e, e);
		}
	}	
	
	
	@Override
	public void saveErrLog(Map<String, Object> eMap) {
		try {
			List<Map<String, Object>> errTmp = new ArrayList<Map<String, Object>>();
			Integer errCnt = 0;
			errTmp = this.sqlMapper.queryForList("selectErrLog",eMap);
			
			if(errTmp != null && errTmp.size() > 0) {
				errCnt = Integer.parseInt((String) errTmp.get(0).get("ERR_CNT"));
			}
			
			eMap.put("ERR_CNT", errCnt +1);
			this.sqlMapper.update("mergeErrLogHd", eMap);
			this.sqlMapper.update("mergeErrLogDt", eMap);	
		} catch (Exception e) {
			log.error(CommonUtil.printStackTraceToString(e));
		}
	}
	

}
