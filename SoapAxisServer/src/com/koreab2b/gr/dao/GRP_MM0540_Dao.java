package com.koreab2b.gr.dao;

import java.util.Map;

import com.ibatis.sqlmap.client.SqlMapClient;
import com.koreab2b.gr.vo.MKPF;
import com.koreab2b.gr.vo.MSEG;

public interface GRP_MM0540_Dao {

	public int saveGrHeader(MKPF obj) throws Exception;
	
	public int saveGrDetail(MSEG obj) throws Exception;
	
	public SqlMapClient getSqlMapClient();
	
	public int selectMKPFSeq(Map<String,String> obj) throws Exception;
	
	public int updateMSEGHdSeq(Map<String,String> obj) throws Exception;
}
