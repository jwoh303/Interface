package com.kep.duzon.dao;

import java.io.Reader;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.ibatis.common.resources.Resources;
import com.ibatis.sqlmap.client.SqlMapClient;
import com.ibatis.sqlmap.client.SqlMapClientBuilder;
import com.kep.common.CommonProperty;

@SuppressWarnings("unchecked")
public class ErpDuzonDao {

	private Logger log	= Logger.getLogger( this.getClass().getName() );
	private SqlMapClient sqlMapper;
	private String _CD_COMPANY = "TEST";

	public ErpDuzonDao() {
		try {
			String source	= "";
			if ( "2".equals(CommonProperty.getDB_CONN()) ) {
				source	= "conf/SqlMapConfig_Duzon_Live.xml";
				this._CD_COMPANY = "1000";
			} else {
				source	= "conf/SqlMapConfig_Duzon_Dev.xml";
				this._CD_COMPANY = "TEST";
			}
			Reader reader = Resources.getResourceAsReader(source);
			this.sqlMapper = SqlMapClientBuilder.buildSqlMapClient(reader);
		} catch (Exception e) {
			e.printStackTrace();
			log.error(this.getClass().getName() + " Error : " + e.getMessage());
			throw new RuntimeException("Something bad happened while building the SqlMapClient instance." + e, e);
		}
	}
	
	public List<Map<String, String>> selectCredit() throws Exception {
		Map<String, String> pMap = new HashMap<String, String>();
		pMap.put("CD_COMPANY", this._CD_COMPANY);	// 개발:TEST, 운영:1000
		return this.sqlMapper.queryForList("selectCredit", pMap);
	}
	
	public void insertFiDocu(Map<String, String> pMap) throws Exception {
		this.sqlMapper.insert("insertFiDocu", pMap);
	}
	
	public List<Map<String, String>> selectFiDocuR() throws Exception {
		Map<String, String> pMap = new HashMap<String, String>();
		pMap.put("CD_COMPANY", this._CD_COMPANY);	// 개발:TEST, 운영:1000
		return this.sqlMapper.queryForList("selectFiDocuR", pMap);
	}
	
	public int updateFiDocuR(Map<String, String> pMap) throws Exception {
		log.debug("RESULT : " + pMap.get("IF_ID")  + " : " + pMap.get("IF_SEQ") + " : " + pMap.get("TR_FLAG"));
		return this.sqlMapper.update("updateFiDocuR", pMap);
	}

	public void insertPartnerTemp(Map<String, String> pMap) throws Exception {
		this.sqlMapper.insert("insertPartnerTemp", pMap);
	}
	
	public void insertPartnerDeposit(Map<String, String> pMap) throws Exception {
		this.sqlMapper.insert("insertPartnerDeposit", pMap);
	}
	
	public List<Map<String, String>> selectPartnerDepositR() throws Exception {
		Map<String, String> pMap = new HashMap<String, String>();
		pMap.put("CD_COMPANY", this._CD_COMPANY);	// 개발:TEST, 운영:1000
		return this.sqlMapper.queryForList("selectPartnerDepositR", pMap);
	}
	
	public int updatePartnerDepositR(Map<String, String> pMap) throws Exception {
		return this.sqlMapper.update("updatePartnerDepositR", pMap);
	}
	
	public List<Map<String, String>> selectNoDocu(Map<String, String> pMap) throws Exception {
		pMap.put("CD_COMPANY", this._CD_COMPANY);	// 개발:TEST, 운영:1000
		return this.sqlMapper.queryForList("selectNoDocu",pMap);
	}
	
	public int udpateNoDocuRtnFlag(Map<String, String> pMap) throws Exception {
		return this.sqlMapper.update("udpateNoDocuRtnFlag", pMap);
	}
	
	public List<Map<String, String>> selectCreditAging(Map<String, String> pMap) throws Exception {
		pMap.put("CD_COMPANY", this._CD_COMPANY);	// 개발:TEST, 운영:1000
		return this.sqlMapper.queryForList("selectCreditAging",pMap);
	}
}