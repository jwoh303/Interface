/**
 * 
 */
package com.kep.hoban.dao;

import java.io.Reader;
import java.util.ArrayList;
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
public class HobanPoDaoImpl implements HobanPoDao {
	private Logger log	= Logger.getLogger( this.getClass().getName() );
	private SqlMapClient sqlMapper;
	
	public HobanPoDaoImpl() {
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
			log.error("####### HobanPoDaoImpl Error : " + e.getMessage());
			throw new RuntimeException("Something bad happened while building the SqlMapClient instance." + e, e);
		}
	}

	
	@Override
	public void mergeHobanPoData(Map<String,Object> obj) throws Exception {		
		List<Map<String,Object>> poItem = (List<Map<String, Object>>) obj.get("result");
		try {
			for(Map<String,Object> item : poItem) {
				this.sqlMapper.update("mergeHobanPoData", item);
			}
		} catch(Exception e) {
			e.printStackTrace();
			log.error("####### mergeHobanPoData DAO Error : " + e.getMessage());
		}		
	}

//	@Override
//	public void callProcHobanErr(Map<String, Object> resultMap) throws Exception {
//		this.sqlMapper.update("callProcHobanErr", resultMap);	
//	}
}
