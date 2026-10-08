/**
 * 
 */
package com.kep.hoban.dao;

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
public class HobanRqDaoImpl implements HobanRqDao {
	private Logger log	= Logger.getLogger( this.getClass().getName() );
	private SqlMapClient sqlMapper;
	
	public HobanRqDaoImpl() {
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
			log.error("####### HobanRqDaoImpl Error : " + e.getMessage());
			throw new RuntimeException("Something bad happened while building the SqlMapClient instance." + e, e);
		}
	}

	
	@Override
	public List<Map<String,Object>> selectHobanRqData() throws Exception {		
		return this.sqlMapper.queryForList("selectHobanRqData");
	}
	
	@Override
	public void insertRqResultData(Map<String, Object> result) throws Exception {
		this.sqlMapper.insert("insertRqResultData", result);	
	}

//	@Override
//	public void callProcHobanErr(Map<String, Object> resultMap) throws Exception {
//		this.sqlMapper.update("callProcHobanErr", resultMap);	
//	}

}
