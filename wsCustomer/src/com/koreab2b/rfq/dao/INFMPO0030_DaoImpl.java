package com.koreab2b.rfq.dao;

import java.io.Reader;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.ibatis.common.resources.Resources;
import com.ibatis.sqlmap.client.SqlMapClient;
import com.ibatis.sqlmap.client.SqlMapClientBuilder;
import com.koreab2b.common.CommonProperty;

@SuppressWarnings("unchecked")
public class INFMPO0030_DaoImpl implements INFMPO0030_Dao {
	
	private Logger log	= Logger.getLogger(this.getClass());
	private SqlMapClient sqlMapper;

	public INFMPO0030_DaoImpl() {
		try {
			String source	= "";
			if ( "2".equals(CommonProperty.getDB_CONN()) ) {
				source	= "conf/SqlMapConfig.xml";
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
	public SqlMapClient getSqlMapClient() {
		return this.sqlMapper;
	}

	@Override
	public List<Map<String,String>> getRfqHeader(Map<String, String> pMap) throws Exception {
		return this.sqlMapper.queryForList("selectRfqHeader", pMap);
	}

	@Override
	public List<Map<String,String>> getRfqItem(Map<String, String> pMap) throws Exception {
		return this.sqlMapper.queryForList("selectListRfqItem", pMap);
	}

	@Override
	public List<Map<String,String>> getRfqVendor(Map<String, String> pMap)
			throws Exception {
		return this.sqlMapper.queryForList("selectListRfqVendor", pMap);
	}

	@Override
	public List<Map<String,String>> getQtaHeader(Map<String, String> pMap)
			throws Exception {
		return this.sqlMapper.queryForList("selectListQtaHeader", pMap);
	}

	@Override
	public List<Map<String,String>> getQtaItem(Map<String, String> pMap) throws Exception {
		return this.sqlMapper.queryForList("selectListQtaItem", pMap);
	}

	@Override
	public List<Map<String,String>> getRfqAttach(Map<String, String> pMap)
			throws Exception {
		return this.sqlMapper.queryForList("selectListRfqAttach", pMap);
	}

	@Override
	public int updateKEPRQDT(Map<String, String> pMap) throws Exception {
		return this.sqlMapper.update("updateKEPRQDT", pMap);
	}

	@Override
	public List<Map<String, String>> getQtaRefVendors(Map<String, String> pMap)
			throws Exception {
		return this.sqlMapper.queryForList("selectListQtaRefVendor", pMap);
	}

	@Override
	public List<Map<String, String>> getRfqTargets()
			throws Exception {
		return this.sqlMapper.queryForList("selectListRfqTarget");
	}

	@Override
	public int updateRefNo(Map<String, String> pMap) throws Exception {
		return this.sqlMapper.update("updateRefNo", pMap);
	}
	
	
	/******************** 추가 작업 지점. *********************/

	@Override
	public int updateIF_KOLON_RFQ_HEADER(Map<String, String> pMap)
			throws Exception {
		return this.sqlMapper.update("updateIF_KOLON_RFQ_HEADER", pMap);
	}

	@Override
	public List<Map<String, String>> selectSendList() throws Exception {
		return this.sqlMapper.queryForList("selectRFQSendList");
	}

	@Override
	public List<Map<String, String>> selectRfqHeaderList(Map<String, String> pMap) throws Exception {
		return this.sqlMapper.queryForList("selectRfqHeaderList", pMap);
	}

	@Override
	public List<Map<String, String>> selectRfqItemList(Map<String, String> pMap)
			throws Exception {
		return this.sqlMapper.queryForList("selectRfqItemList", pMap);
	}

	@Override
	public List<Map<String, String>> selectRfqVendorList(
			Map<String, String> pMap) throws Exception {
		return this.sqlMapper.queryForList("selectRfqVendorList", pMap);
	}

	@Override
	public List<Map<String, String>> selectQtaHeaderList(
			Map<String, String> pMap) throws Exception {
		return this.sqlMapper.queryForList("selectQtaHeaderList", pMap);
	}

	@Override
	public List<Map<String, String>> selectQtaItemList(Map<String, String> pMap)
			throws Exception {
		return this.sqlMapper.queryForList("selectQtaItemList", pMap);
	}

	@Override
	public List<Map<String, String>> selectQtaRefVendorList(
			Map<String, String> pMap) throws Exception {
		return this.sqlMapper.queryForList("selectQtaRefVendorList", pMap);
	}

	@Override
	public int updateResultIF_KOLON_RFQ_HEADER(Map<String, String> pMap)
			throws Exception {
		return this.sqlMapper.update("updateResultIF_KOLON_RFQ_HEADER", pMap);
	}
}
