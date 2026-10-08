/**
 * 
 */
package com.kep.delivery.dao;

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
public class ParcelDaoImpl implements ParcelDao {
	private Logger log	= Logger.getLogger( this.getClass().getName() );
	private SqlMapClient sqlMapper;
	
	public ParcelDaoImpl() {
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
			log.error("####### ParcelDaoImpl Error : " + e.getMessage());
			throw new RuntimeException("Something bad happened while building the SqlMapClient instance." + e, e);
		}
	}

	@Override
	public List<Map<String, Object>> selectParcelTrkgList() throws Exception {
		return this.sqlMapper.queryForList("selectParcelTrkgList");
	}

	@Override
	public void updateParcelTrkg(Map<String,Object> result) throws Exception {
		this.sqlMapper.update("updateParcelTrkg", result);		
	}

	@Override
	public void updateParcelTrkgAllFail() throws Exception {
		this.sqlMapper.update("updateParcelTrkgAllFail");
	}

	@Override
	public List<Map<String, Object>> selectParcelToken() throws Exception {
		return this.sqlMapper.queryForList("selectParcelToken");
	}

	@Override
	public List<Map<String, Object>> selectParcelSrchList() throws Exception {
		return this.sqlMapper.queryForList("selectParcelSrchList");		
	}

	@Override
	public void updateParcelSrch(Map<String, Object> result) throws Exception {
		this.sqlMapper.update("updateParcelSrch", result);		
	}

	@Override
	public void updateParcelSrchAllFail(Map<String, Object> tmp) throws Exception {
		this.sqlMapper.update("updateParcelSrchAllFail", tmp);		
	}

	@Override
	public void insertParcelSrchDt(Map<String, Object> item) throws Exception {
		this.sqlMapper.insert("insertParcelSrchDt", item);		
	}

}
