package com.koreab2b.po.dao;

import java.util.Map;

import com.ibatis.sqlmap.client.SqlMapClient;
import com.koreab2b.po.vo.EKET;
import com.koreab2b.po.vo.EKKO;
import com.koreab2b.po.vo.EKPO;

public interface GRP_MM0660_Dao {

	/**
	 * 발주 헤더 인터페이스 데이처 처리
	 * @param obj
	 * @return
	 * @throws Exception
	 */
	public int savePoHeader(EKKO obj) throws Exception;
	
	public int savePoDetail(EKPO obj) throws Exception;
	
	public int savePoDelyPlan(EKET obj) throws Exception;
	
	/**
	 * Return SqlMapClient Object
	 * @return SqlMapClient
	 */
	public SqlMapClient getSqlMapClient();
	
	public int selectEKKOSeq(Map<String,String> obj) throws Exception;
	
	public int updateEKPOHdSeq(Map<String,String> obj) throws Exception;
	
	public int updateEKETHdSeq(Map<String,String> obj) throws Exception;
}
