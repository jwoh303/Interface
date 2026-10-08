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
public class GRP_MM1460_DaoImpl implements GRP_MM1460_Dao {
	
	private Logger log	= Logger.getLogger(this.getClass());
	private SqlMapClient sqlMapper;

	public GRP_MM1460_DaoImpl() {
		try {
			String source	= "";
			if ( "2".equals(CommonProperty.getDB_CONN()) ) {
				source	= "conf/SqlMapConfig_KEPCON_Live.xml";
			} else {
				source	= "conf/SqlMapConfig_KEPCON_Live.xml";
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
	public void updateKolonItems(Map<String, String> pMap) throws Exception {
		this.sqlMapper.update("updateIF_KOLON_ITEMS", pMap);
	}

	@Override
	public List<Map<String, String>> selectKolonItems() throws Exception {
		return this.sqlMapper.queryForList("selectIF_KOLON_ITEMS");
	}

}
