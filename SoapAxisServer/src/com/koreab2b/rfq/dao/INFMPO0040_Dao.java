package com.koreab2b.rfq.dao;

import java.util.List;
import java.util.Map;

import com.ibatis.sqlmap.client.SqlMapClient;
import com.koreab2b.rfq.vo.RFQ_HEADER;

public interface INFMPO0040_Dao {

	/**
	 * Return SqlMapClient Object
	 * @return SqlMapClient
	 */
	public SqlMapClient getSqlMapClient();
	
	/**
	 * 견적취소
	 * @param pMap
	 * @return
	 * @throws Exception
	 */
	public int updateRfqCancel(Map<String,String> obj) throws Exception;
	
	/**
	 * 재견적 rqdt 생성
	 * @param pMap
	 * @return
	 * @throws Exception
	 */
	public int insertRfqNegoRQDT(Map<String,String> obj) throws Exception;
	
	/**
	 * 재견적 qtdt 생성
	 * @param pMap
	 * @return
	 * @throws Exception
	 */
	public int insertRfqNegoQTDT(Map<String,String> obj) throws Exception;
	
	/**
	 * 고객사코드 확인
	 * @param obj
	 * @return
	 * @throws Exception
	 */
	public List<Map<String,String>> selectBuyer(Map<String,String> obj) throws Exception;
	
	/**
	 * KEPQTDT 종료
	 * @param obj
	 * @return
	 * @throws Exception
	 */
	public int updateQTDTClose(Map<String,String> obj) throws Exception;
}
