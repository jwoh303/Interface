package com.koreab2b.rfq.dao;

import java.util.List;
import java.util.Map;

import com.ibatis.sqlmap.client.SqlMapClient;

public interface INFMPO0030_Dao {
	
	public SqlMapClient getSqlMapClient();

	public List<Map<String,String>> getRfqHeader(Map<String,String> pMap) throws Exception;
	
	public List<Map<String,String>> getRfqItem(Map<String,String> pMap) throws Exception;
	
	public List<Map<String,String>> getRfqVendor(Map<String,String> pMap) throws Exception;
	
	public List<Map<String,String>> getQtaHeader(Map<String,String> pMap) throws Exception;
	
	public List<Map<String,String>> getQtaItem(Map<String,String> pMap) throws Exception;
	
	public List<Map<String,String>> getRfqAttach(Map<String,String> pMap) throws Exception;
	
	public List<Map<String,String>> getQtaRefVendors(Map<String,String> pMap) throws Exception;
	
	public List<Map<String,String>> getRfqTargets() throws Exception;
	
	public int updateKEPRQDT(Map<String,String> pMap) throws Exception;
	
	public int updateRefNo(Map<String,String> pMap) throws Exception;
	
	/******************** 추가 작업 지점. *********************/
	
	/**
	 * RFQ_HEADER 상태 변경
	 * @param pMap
	 * @return
	 * @throws Exception
	 */
	public int updateIF_KOLON_RFQ_HEADER(Map<String,String> pMap) throws Exception;
	
	/**
	 * INFMPO0030 전송대상 조회
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, String>> selectSendList() throws Exception;
	
	/**
	 * RFQ_HEADER 조회
	 * @param pMap
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, String>> selectRfqHeaderList(Map<String,String> pMap) throws Exception;
	
	/**
	 * RFQ_ITEM 조회
	 * @param pMap
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, String>> selectRfqItemList(Map<String,String> pMap) throws Exception;
	
	/**
	 * RFQ_VENDOR 조회
	 * @param pMap
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, String>> selectRfqVendorList(Map<String,String> pMap) throws Exception;
	
	/**
	 * QTA_HEADER 조회
	 * @param pMap
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, String>> selectQtaHeaderList(Map<String,String> pMap) throws Exception;
	
	/**
	 * QTA_ITEM 조회
	 * @param pMap
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, String>> selectQtaItemList(Map<String,String> pMap) throws Exception;
	
	/**
	 * QTA_REF_VENDOR 조회
	 * @param pMap
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, String>> selectQtaRefVendorList(Map<String,String> pMap) throws Exception;
	
	/**
	 * IF_KOLON_RFQ_HEADER 결과 처리
	 * @param pMap
	 * @return
	 * @throws Exception
	 */
	public int updateResultIF_KOLON_RFQ_HEADER(Map<String,String> pMap) throws Exception;
}
