package com.kep.hwDefense.gr.submit.dao;

import java.io.Reader;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.ibatis.common.resources.Resources;
import com.ibatis.sqlmap.client.SqlMapClient;
import com.ibatis.sqlmap.client.SqlMapClientBuilder;
import com.kep.common.CommonProperty;
import com.kep.common.CommonUtil;
import com.kep.hwin.app.status.service.HwinAppStatusServiceImpl;

@SuppressWarnings("unchecked")
public class GrSubmitDaoImpl implements GrSubmitDao {
	
	private SqlMapClient sqlMapper;
	private Logger log	= Logger.getLogger( this.getClass().getName() );

	public GrSubmitDaoImpl() {
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
			throw new RuntimeException("Something bad happened while building the SqlMapClient instance." + e, e);
		}
	}

	@Override
	public List<Map<String, String>> selectHwDefenseGrList() throws Exception {
		return sqlMapper.queryForList("selectHwDefenseGrList");
	}

	@Override
	public void updateResultGrSubmit(List<Map<String, Object>> grResultList) throws Exception {
		for(Map<String, Object> iMap : grResultList) {
			sqlMapper.update("updateHwDefenseResultGrSubmit", iMap);	
		}
	}

}
