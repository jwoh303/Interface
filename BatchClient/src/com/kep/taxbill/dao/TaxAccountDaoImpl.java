package com.kep.taxbill.dao;

import java.io.Reader;
import java.util.Map;

import org.apache.log4j.Logger;

import com.ibatis.common.resources.Resources;
import com.ibatis.sqlmap.client.SqlMapClient;
import com.ibatis.sqlmap.client.SqlMapClientBuilder;
import com.kep.common.CommonProperty;

public class TaxAccountDaoImpl implements TaxAccountDao {
	
	private Logger log	= Logger.getLogger( this.getClass().getName() );

	private SqlMapClient sqlMapper;

	public TaxAccountDaoImpl() {
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
	public void mergeTaccountData(Map<String, Object> pMap) throws Exception {
		
		log.debug(pMap.get("APPROVE_DATE"));
		
		this.sqlMapper.insert("mergeTaccountData",pMap);
	}

	@Override
	public void deleteMappingDataForTaccountCancel() throws Exception {
		this.sqlMapper.delete("deleteMappingDataForTaccountCancel");
	}
	
}
