/**
 * 
 */
package com.koreab2b.rfq.dao;

import java.io.Reader;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.ibatis.common.resources.Resources;
import com.ibatis.sqlmap.client.SqlMapClient;
import com.ibatis.sqlmap.client.SqlMapClientBuilder;
import com.koreab2b.common.CommonProperty;

/**
 * @author jiwon
 *
 */
@SuppressWarnings("unchecked")
public class INFIPA0110_DaoImpl implements INFIPA0110_Dao {

	private Logger log	= Logger.getLogger(this.getClass());
	private SqlMapClient sqlMapper;

	public INFIPA0110_DaoImpl() {
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
	public int updateIpaIF_KOLON_RFQ_HEADER(Map<String, String> pMap) throws Exception {
		return this.sqlMapper.update("updateIpaIF_KOLON_RFQ_HEADER", pMap);
	}

	@Override
	public List<Map<String, String>> selectIpaRFQSendList() throws Exception {
		return this.sqlMapper.queryForList("selectIpaRFQSendList");
	}

	@Override
	public List<Map<String, String>> selectIpaRfqHeaderList(Map<String, String> pMap) throws Exception {
		return this.sqlMapper.queryForList("selectIpaRfqHeaderList", pMap);
	}

	@Override
	public List<Map<String, String>> selectIpaRfqItemList(Map<String, String> pMap)	throws Exception {
		return this.sqlMapper.queryForList("selectIpaRfqItemList", pMap);
	}

	@Override
	public List<Map<String, String>> selectIpaRfqVendorList(Map<String, String> pMap) throws Exception {
		return this.sqlMapper.queryForList("selectIpaRfqVendorList", pMap);
	}

	@Override
	public List<Map<String, String>> selectIpaQtaHeaderList(Map<String, String> pMap) throws Exception {
		return this.sqlMapper.queryForList("selectIpaQtaHeaderList", pMap);
	}

	@Override
	public List<Map<String, String>> selectIpaQtaItemList(Map<String, String> pMap)	throws Exception {
		return this.sqlMapper.queryForList("selectIpaQtaItemList", pMap);
	}

	@Override
	public List<Map<String, String>> selectIpaQtaRefVendorList(Map<String, String> pMap) throws Exception {
		return this.sqlMapper.queryForList("selectIpaQtaRefVendorList", pMap);
	}

	@Override
	public int updateResultIpaIF_KOLON_RFQ_HEADER(Map<String, String> pMap)	throws Exception {
		return this.sqlMapper.update("updateResultIpaIF_KOLON_RFQ_HEADER", pMap);
	}
	
	@Override
	public List<Map<String, String>> selectIpaList() throws Exception {
		return this.sqlMapper.queryForList("selectIpaList");
	}

}
