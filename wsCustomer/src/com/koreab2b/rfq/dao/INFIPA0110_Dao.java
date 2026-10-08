/**
 * 
 */
package com.koreab2b.rfq.dao;

import java.util.List;
import java.util.Map;

import com.ibatis.sqlmap.client.SqlMapClient;

/**
 * @author jiwon
 *
 */
public interface INFIPA0110_Dao {
	public SqlMapClient getSqlMapClient();
	
	
	/**
	 * RFQ_HEADER 상태 변경
	 * @param pMap
	 * @return
	 * @throws Exception
	 */
	public int updateIpaIF_KOLON_RFQ_HEADER(Map<String,String> pMap) throws Exception;
	
	/**
	 * INFIPA0110 전송대상 조회
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, String>> selectIpaRFQSendList() throws Exception;
	
	/**
	 * INFMPO0030 인더스트리,이앤피,바스프이노폼 회사코드 조회 
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, String>> selectIpaList() throws Exception;
	
	/**
	 * RFQ_HEADER 조회
	 * @param pMap
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, String>> selectIpaRfqHeaderList(Map<String,String> pMap) throws Exception;
	
	/**
	 * RFQ_ITEM 조회
	 * @param pMap
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, String>> selectIpaRfqItemList(Map<String,String> pMap) throws Exception;
	
	/**
	 * RFQ_VENDOR 조회
	 * @param pMap
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, String>> selectIpaRfqVendorList(Map<String,String> pMap) throws Exception;
	
	/**
	 * QTA_HEADER 조회
	 * @param pMap
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, String>> selectIpaQtaHeaderList(Map<String,String> pMap) throws Exception;
	
	/**
	 * QTA_ITEM 조회
	 * @param pMap
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, String>> selectIpaQtaItemList(Map<String,String> pMap) throws Exception;
	
	/**
	 * QTA_REF_VENDOR 조회
	 * @param pMap
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, String>> selectIpaQtaRefVendorList(Map<String,String> pMap) throws Exception;
	
	/**
	 * IF_KOLON_RFQ_HEADER 결과 처리
	 * @param pMap
	 * @return
	 * @throws Exception
	 */
	public int updateResultIpaIF_KOLON_RFQ_HEADER(Map<String,String> pMap) throws Exception;
	
}
