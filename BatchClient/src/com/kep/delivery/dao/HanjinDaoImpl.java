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
public class HanjinDaoImpl implements HanjinDao {

	private Logger log	= Logger.getLogger( this.getClass().getName() );
	private SqlMapClient sqlMapper;
	
	public HanjinDaoImpl() {
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
			log.error("####### DeliveryDaoImpl Error : " + e.getMessage());
			throw new RuntimeException("Something bad happened while building the SqlMapClient instance." + e, e);
		}
	}

	@Override
	public List<Map<String, Object>> selectHanjinItemList() throws Exception {
		return this.sqlMapper.queryForList("selectHanjinItemList");
	}

	@Override
	public void updateHanjinOrder(Map<String,Object> item) throws Exception {
		this.sqlMapper.update("updateHanjinOrder", item);
	}

	
	@Override
	public void updateHanjinOrderAllFail() throws Exception {
		this.sqlMapper.update("updateHanjinOrderAllFail");
	}

	@Override
	public List<Map<String, Object>> selectHanjinCancelList() throws Exception {
		return this.sqlMapper.queryForList("selectHanjinCancelList");
	}

	@Override
	public void updateHanjinCancel(Map<String, Object> item) throws Exception {
		this.sqlMapper.update("updateHanjinCancel", item);
	}
	
	@Override
	public void updateHanjinCancelAllFail() throws Exception {
		this.sqlMapper.update("updateHanjinCancelAllFail");
	}

	@Override
	public List<Map<String, Object>> selectHanjinPrintList() throws Exception {
		return this.sqlMapper.queryForList("selectHanjinPrintList");
	}

}
