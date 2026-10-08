package com.kep.cretec.dao;

import java.io.Reader;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.ibatis.common.resources.Resources;
import com.ibatis.sqlmap.client.SqlMapClient;
import com.ibatis.sqlmap.client.SqlMapClientBuilder;
import com.kep.common.CommonProperty;

@SuppressWarnings("unchecked")
public class CretecDaoImpl implements CretecDao {

	private Logger log	= Logger.getLogger( this.getClass().getName() );

	private SqlMapClient sqlMapper;

	public CretecDaoImpl() {
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
			log.error(this.getClass().getName() + " Error : " + e.getMessage());
			throw new RuntimeException("Something bad happened while building the SqlMapClient instance." + e, e);
		}
	}

	@Override
	public Map<String, Object> getCretecProperty(Map<String, String> pMap) throws Exception {
		return (Map<String, Object>)this.sqlMapper.queryForObject("selectCretecProperty",pMap);
	}
	
	@Override
	public List<Map<String, String>> getPOList() throws Exception  {
		return this.sqlMapper.queryForList("selectCretecPoList");
	}

	@Override
	public void updatePOResult(Map<String, String> pMap) throws Exception {
		this.sqlMapper.update("updateCretecIfResult", pMap);
	}

	@Override
	public List<Map<String, Object>> getPODTList(Map<String, String> pMap) throws Exception {
		return this.sqlMapper.queryForList("selectCretecPodtList", pMap);
	}

	@Override
	public List<Map<String, String>> getDeliveryList(Map<String, String> pMap) throws Exception {
		return this.sqlMapper.queryForList("selectCretecDlvList", pMap);
	}

	@Override
	public Integer checkPORSEvent(Map<String, String> pMap) throws Exception {
		return (Integer)this.sqlMapper.queryForObject("checkPORS_ADDEvent", pMap);
	}

	@Override
	public void insertPORSEvent(Map<String, String> pMap) throws Exception {
		this.sqlMapper.insert("insertPORS_ADDEvent", pMap);
	}

	@Override
	public List<Map<String, String>> getItemCheckList() throws Exception {
		return this.sqlMapper.queryForList("selectCretecItemCheckList");
	}

	@Override
	public void deleteCretecItemInfo() throws Exception {
		this.sqlMapper.delete("deleteCretecItems");
	}

	@Override
	public void insertCretecItemInfo(Map<String, String> pMap) throws Exception {
		this.sqlMapper.insert("insertCretecItem", pMap);
	}

	@Override
	public List<Map<String, String>> getCretecItemDetailInfo(Map<String, String> pMap) throws Exception {
		return this.sqlMapper.queryForList("selectCretecItemDetailInfo", pMap);
	}

	@Override
	public List<Map<String, String>> getCretecTargetCatalogList()
			throws Exception {
		return this.sqlMapper.queryForList("selectTargetCatalogList");
	}

	@Override
	public void updateCretecItemClose(Map<String, String> pMap)
			throws Exception {
		this.sqlMapper.update("updateCretecItemClose", pMap);
	}

	@Override
	public void updateCretecItemRecover(Map<String, String> pMap)
			throws Exception {
		this.sqlMapper.update("updateCretecItemRecover", pMap);
	}

	@Override
	public void deleteAlertList() throws Exception {
		this.sqlMapper.delete("deleteAlertList");
	}

	@Override
	public void insertCretecItemCloseAlertList(Map<String, String> pMap) throws Exception {
		this.sqlMapper.update("insertCretecItemCloseAlertList", pMap);
	}

	@Override
	public void insertCretecItemRecoverAlertList(Map<String, String> pMap) throws Exception {
		this.sqlMapper.update("insertCretecItemRecoverAlertList", pMap);
	}
	
	@Override
	public void updateCretecItemStatus() throws Exception {
		this.sqlMapper.update("updateCretecItemStatus");
	}

	@Override
	public void insertCretecIv(Map<String, String> resultMap) throws Exception {
		this.sqlMapper.insert("insertCretecIvdtUc", resultMap);
	}

	@Override
	public void insertCretecIvMail() throws Exception {
		this.sqlMapper.insert("insertCretecIvMail");
	}
}