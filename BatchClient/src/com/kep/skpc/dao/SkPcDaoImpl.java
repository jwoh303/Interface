/**
 * 
 */
package com.kep.skpc.dao;

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
public class SkPcDaoImpl implements SkPcDao {
	private Logger log	= Logger.getLogger( this.getClass().getName() );
	private SqlMapClient sqlMapper;
	
	public SkPcDaoImpl() {
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
			log.error("####### HkInnDaoImpl Error : " + e.getMessage());
			throw new RuntimeException("Something bad happened while building the SqlMapClient instance." + e, e);
		}
	}
	
	@Override
	public List<Map<String, Object>> selectSkPcToken() throws Exception {
		return this.sqlMapper.queryForList("selectSkPcToken");
	}

	@Override
	public List<Map<String, Object>> selectSkPcReQuoList() throws Exception {
		return this.sqlMapper.queryForList("selectSkPcReQuoList");
	}
	
	@Override
	public List<Map<String, Object>> selectSkPcReRtList(Map<String,Object> reItem) throws Exception {
		return this.sqlMapper.queryForList("selectSkPcReRtList", reItem);
	}
	
	@Override
	public void updateSkPcReRt(Map<String, Object> reItem) throws Exception {
		this.sqlMapper.update("updateSkPcReRt", reItem);
	}	

	@Override
	public List<Map<String, Object>> selectSkPcIvList() throws Exception {
		return this.sqlMapper.queryForList("selectSkPcIvList");
	}
	
	@Override
	public void updateSkPcIvTrxl(Map<String, Object> ivItem) throws Exception {
		this.sqlMapper.update("updateSkPcIvTrxl", ivItem);
	}
	
	@Override
	public List<Map<String, Object>> selectSkPcItList() throws Exception {
		return this.sqlMapper.queryForList("selectSkPcItList");
	}
	
	@Override
	public void updateSkPcItSend(Map<String, Object> itItem) throws Exception {
		this.sqlMapper.update("updateSkPcItSend", itItem);
	}

	@Override
	public void updateSkPcItErr() throws Exception {
		this.sqlMapper.update("updateSkPcItErr");
	}


	@Override
	public void updateSkPcReRtErr() throws Exception {
		this.sqlMapper.update("updateSkPcReRtErr");
		
	}
	
}
