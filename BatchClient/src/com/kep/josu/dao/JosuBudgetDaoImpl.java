package com.kep.josu.dao;

import java.io.Reader;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.ibatis.common.resources.Resources;
import com.ibatis.sqlmap.client.SqlMapClient;
import com.ibatis.sqlmap.client.SqlMapClientBuilder;
import com.kep.common.CommonProperty;
import com.kep.hwin.app.send.dao.AppSendDaoImpl;

@SuppressWarnings("unchecked")
public class JosuBudgetDaoImpl implements JosuBudgetDao {

	private static Logger log	= Logger.getLogger( AppSendDaoImpl.class.getName() );
	
	private SqlMapClient sqlMapper;
	
	public JosuBudgetDaoImpl() {
		try {
			String source	= "";
			if ( "2".equals(CommonProperty.getDB_CONN()) ) {
				source	= "conf/SqlMapConfig_Josu_Live.xml";
			} else {
				source	= "conf/SqlMapConfig_Josu_Dev.xml";
			}
			Reader reader = Resources.getResourceAsReader(source);
			this.sqlMapper = SqlMapClientBuilder.buildSqlMapClient(reader);
		} catch (Exception e) {
			e.printStackTrace();
			log.error("AppSendDaoImpl Error : " + e.getMessage());
			throw new RuntimeException("Something bad happened while building the SqlMapClient instance." + e, e);
		}
	}

	@Override
	public void selectBudget(Map<String, Object> paramMap) throws Exception {
		this.sqlMapper.queryForList("JOSU_BUDGET_STATUS",paramMap);
	}

	@Override
	public void updateBudget(Map<String, Object> paramMap) throws Exception {
		this.sqlMapper.queryForList("JOSU_BUDGET_UPDATE",paramMap);
	}

	@Override
	public void insertFiClose(Map<String, Object> map) throws Exception {
		this.sqlMapper.update("insertFiClose", map);	
	}

	@Override
	public int selectSeqCnt() throws Exception {
		int result = 1;
		try {
			result = (Integer)this.sqlMapper.queryForObject("selectSeqCnt");	
		} catch (Exception e) {
			log.error(this.getClass().getName() + " Error : " + e.getMessage());
		}
		return result;
	}

	

	
}
