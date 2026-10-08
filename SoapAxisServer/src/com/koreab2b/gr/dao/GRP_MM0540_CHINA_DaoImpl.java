package com.koreab2b.gr.dao;

import java.io.Reader;
import java.util.Map;

import org.apache.log4j.Logger;

import com.ibatis.common.resources.Resources;
import com.ibatis.sqlmap.client.SqlMapClient;
import com.ibatis.sqlmap.client.SqlMapClientBuilder;
import com.koreab2b.gr.vo.MKPF;
import com.koreab2b.gr.vo.MSEG;

public class GRP_MM0540_CHINA_DaoImpl implements GRP_MM0540_CHINA_Dao {

	private Logger log	= Logger.getLogger(this.getClass());
	private SqlMapClient sqlMapper;

	public GRP_MM0540_CHINA_DaoImpl() {
		try {
		      Reader reader = Resources.getResourceAsReader("conf/SqlMapConfig_KEPCON.xml");
		      this.sqlMapper = SqlMapClientBuilder.buildSqlMapClient(reader);
		} catch (Exception e) {
		      log.error(e.getMessage());
		      throw new RuntimeException("Something bad happened while building the SqlMapClient instance." + e, e);
		}
	}

	@Override
	public int saveGrHeader(MKPF obj) throws Exception {
		return this.sqlMapper.update("insertMKPF", obj);
	}

	@Override
	public int saveGrDetail(MSEG obj) throws Exception {
		return this.sqlMapper.update("insertMSEG", obj);
	}

	@Override
	public SqlMapClient getSqlMapClient() {
		return this.sqlMapper;
	}

	@Override
	public int selectMKPFSeq(Map<String,String> obj) throws Exception {
		return (Integer)this.sqlMapper.queryForObject("selectMKPFSeq", obj);
	}

	@Override
	public int updateMSEGHdSeq(Map<String, String> obj) throws Exception {
		return this.sqlMapper.update("updateMSEGHdSeq", obj);
	}
}
