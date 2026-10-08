/**
 * 
 */
package com.kep.hugel.dao;

import java.io.Reader;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.ibatis.common.resources.Resources;
import com.ibatis.sqlmap.client.SqlMapClient;
import com.ibatis.sqlmap.client.SqlMapClientBuilder;
import com.kep.common.CommonProperty;

/**
 * @author jiwon
 *
 */
@SuppressWarnings("unchecked")
public class HugelDaoImpl implements HugelDao {
	private Logger log	= Logger.getLogger( this.getClass().getName() );
	private SqlMapClient sqlMapper;
	
	public HugelDaoImpl() {
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
			e.printStackTrace();
			log.error("####### HugelDaoImpl Error : " + e.getMessage());
			throw new RuntimeException("Something bad happened while building the SqlMapClient instance." + e, e);
		}
	}

	
	@Override
	public List<Map<String,String>> selectHugelPrList() throws Exception {		
		return this.sqlMapper.queryForList("selectHugelPrList");
	}
	
	@Override
	public Map<String, Object> selectHugelPrHeader(Map<String,String> obj) throws Exception {		
		return (Map<String, Object>) this.sqlMapper.queryForObject("selectHugelPrHeader", obj);
	}
	
	@Override
	public List<Map<String,Object>> selectHugelPrItemList(Map<String,String> obj) throws Exception {		
		return this.sqlMapper.queryForList("selectHugelPrItemList", obj);
	}

	@Override
	public int updatePrData(Map<String, Object> prRsltData) throws Exception {
		log.info("################# ZSTATUS :  "+prRsltData.get("ZSTATUS"));
		int num = 0;
		if(prRsltData.get("ZSTATUS").equals("S")) {			
			List<Map<String,Object>> poItem = (List<Map<String, Object>>) prRsltData.get("IT_POITEM");
			try {
				for(Map<String,Object> item : poItem) {					
					prRsltData.put("IT_POITEM", item);
					log.info("################# after prRsltData  : "+prRsltData.toString());
					num += sqlMapper.update("updatePrData", prRsltData);
				}
			} catch(Exception e) {
				e.printStackTrace();
				log.error("####### updatePrData DAO Error : " + e.getMessage());
			}
			return num;
		}else {
			log.info("################# ZSTATUS : E  : "+prRsltData.get("ZSTATUS"));
			sqlMapper.update("updatePrErrorData", prRsltData);
			return sqlMapper.update("callProcSendPr", prRsltData);
		}		
	}

	@Override
	public boolean updateProgress(Map<String, String> pMap) throws Exception {
		log.info("################# HUGEL DAO PROGRESS pMap  : "+pMap.toString());
		int isSuccess = sqlMapper.update("updateProgress", pMap);
		if(isSuccess == 1) {
			return true;
		}else {
			return false;
		}		
	}


	@Override
	public List<Map<String, Object>> selectHugelChgDelList() throws Exception {
		return this.sqlMapper.queryForList("selectHugelChgDelList");
	}


	@Override
	public void callProcHuglErr(Map<String, Object> resultMap) throws Exception {
		this.sqlMapper.update("callProcHuglErr", resultMap);	
	}


	@Override
	public void updateResultData(Map<String, Object> obj) throws Exception {
		this.sqlMapper.update("updateResultData", obj);
	}
	
}
