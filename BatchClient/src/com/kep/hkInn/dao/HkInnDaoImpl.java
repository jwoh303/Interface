/**
 * 
 */
package com.kep.hkInn.dao;

import java.io.Reader;
import java.util.ArrayList;
import java.util.HashMap;
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
public class HkInnDaoImpl implements HkInnDao {
	
	private Logger log	= Logger.getLogger( this.getClass().getName() );
	private SqlMapClient sqlMapper;
	
	public HkInnDaoImpl() {
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
	public List<Map<String, Object>> checkTokenVal() throws Exception {
		return this.sqlMapper.queryForList("checkTokenVal");
	}	
	
	@Override
	public List<Map<String, Object>> selectHkInnBrandList(Map<String,Object> cntMap) throws Exception {
		return this.sqlMapper.queryForList("selectHkInnBrandList");
	}


	@Override
	public List<Map<String, Object>> selectHkInnItemList() throws Exception {
		return this.sqlMapper.queryForList("selectHkInnItemList");
	}
	
	
	@Override
	public List<Map<String, Object>> selectHkInnPoCancelIdx() throws Exception {
		return this.sqlMapper.queryForList("selectHkInnPoCancelIdx");
	}

	@Override
	public List<Map<String, Object>> selectHkInnPoCancelList(Map<String,Object> idx) throws Exception {
		return this.sqlMapper.queryForList("selectHkInnPoCancelList", idx);
	}


	@Override
	public void mergeHkInnToken(Map<String, Object> newToken) throws Exception {
		sqlMapper.update("mergeHkInnToken", newToken);
	}

	@Override
	public void updateHkInnPoStatus(Map<String, Object> poStatusRsltData) throws Exception {
		sqlMapper.update("updateHkInnPoStatus", poStatusRsltData);
	}
	
	@Override
	public void updateHkInnPoCancel(Map<String, Object> poCancelRsltData) throws Exception {
		sqlMapper.update("updateHkInnPoCancel", poCancelRsltData);
	}
	
	@Override
	public void updateHkInnPoCancelFail(Map<String, Object> poCancelRsltData) throws Exception {
		sqlMapper.update("updateHkInnPoCancelFail", poCancelRsltData);
	}
	
	@Override
	public void updateHkInnDelNotInterPo() throws Exception {
		sqlMapper.update("updateHkInnDelNotInterPo");
	}	
	
	@Override
	public List<Map<String, Object>> selectHkInnPoStatusIdx() throws Exception {
		return this.sqlMapper.queryForList("selectHkInnPoStatusIdx");
	}
	
	@Override
	public List<Map<String, Object>> selectHkInnPoStatusItem(Map<String,Object> idx) throws Exception {
		return this.sqlMapper.queryForList("selectHkInnPoStatusItem",idx);
	}

	@Override
	public void updateItemFlag() throws Exception {
		sqlMapper.update("updateItemFlag");		
	}

	@Override
	public void updateItemRslt(Map<String,Object> resultMap) throws Exception {
		sqlMapper.update("updateItemRslt",resultMap);
	}

	@Override
	public void updateHkInnBrandData(Map<String,Object> isSuccess) throws Exception {
		sqlMapper.update("updateHkInnBrandData",isSuccess);		
	}

	@Override
	public List<Map<String, Object>> selectHkInnIvList() throws Exception {
		return this.sqlMapper.queryForList("selectHkInnIvList");
	}

	@Override
	public void updateHkInnIvData(Map<String, Object> ivData) throws Exception {
		sqlMapper.update("updateHkInnIvData",ivData);		
	}

}
