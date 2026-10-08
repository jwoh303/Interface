package com.koreab2b.po.dao;

import java.io.Reader;
import java.util.Map;

import org.apache.log4j.Logger;

import com.ibatis.common.resources.Resources;
import com.ibatis.sqlmap.client.SqlMapClient;
import com.ibatis.sqlmap.client.SqlMapClientBuilder;
import com.koreab2b.po.vo.EKET;
import com.koreab2b.po.vo.EKKO;
import com.koreab2b.po.vo.EKPO;

public class GRP_MM0660_CHINA_DaoImpl implements GRP_MM0660_CHINA_Dao {

	
	private Logger log	= Logger.getLogger(this.getClass());
	private SqlMapClient sqlMapper;
	
	public GRP_MM0660_CHINA_DaoImpl() {
		try {
		      Reader reader = Resources.getResourceAsReader("conf/SqlMapConfig_KEPCON.xml");
		      this.sqlMapper = SqlMapClientBuilder.buildSqlMapClient(reader);
		} catch (Exception e) {
		      log.error(e.getMessage());
		      throw new RuntimeException("Something bad happened while building the SqlMapClient instance." + e, e);
		}
	}

	@Override
	public int savePoHeader(EKKO obj) throws Exception {
		return this.sqlMapper.update("updateEKKO", obj);
	}

	@Override
	public int savePoDetail(EKPO obj) throws Exception {
		return this.sqlMapper.update("updateEKPO", obj);
	}

	@Override
	public int savePoDelyPlan(EKET obj) throws Exception {
		return this.sqlMapper.update("updateEKET", obj);
	}

	@Override
	public SqlMapClient getSqlMapClient() {
		return this.sqlMapper;
	}

	@Override
	public int selectEKKOSeq(Map<String,String> obj) throws Exception {
		return (Integer)this.sqlMapper.queryForObject("selectEKKOSeq", obj);
	}

	@Override
	public int updateEKPOHdSeq(Map<String, String> obj) throws Exception {
		return this.sqlMapper.update("updateEKPOHdSeq", obj);
	}

	@Override
	public int updateEKETHdSeq(Map<String, String> obj) throws Exception {
		return this.sqlMapper.update("updateEKETHdSeq", obj);
	}
}
