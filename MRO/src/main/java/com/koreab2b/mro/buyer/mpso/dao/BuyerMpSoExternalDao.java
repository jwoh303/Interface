package com.koreab2b.mro.buyer.mpso.dao;

import java.util.List;
import java.util.Map;

public interface BuyerMpSoExternalDao {


	/**
	 * 광동제약 주문데이터 조회.
	 * @param pMap
	 * @return
	 */
	public List<Map<String, String>> selectKwangdongGWList(Map<String, String> pMap) ;
		
	/**
	 * 광동제약 결재 후 처리 로직.
	 * @param pMap
	 * @return
	 */
	public String processKwangdongApproval(Map<String, String> pMap);
	
	/**
	 * 미스미 체크아웃 데이터 저장
	 * @param pMap
	 * @return
	 */
	public String saveMisumiCheckOut(Map<String, String> pMap);
	
	/**
	 * 고객사 미스미 품목검색 데이터 저장.
	 * @param pMaps
	 * @return
	 */
	public String saveMisumiBuyerCheckOut(List<Map<String, String>> pMaps);
	
	/**
	 * 견적 생성시 사용자 정보 획득.
	 * @param pMap
	 * @return
	 */
	public Map<String, String> selectUserInfo(Map<String, String> pMap);
	
	/**
	 * 영풍 마감 이벤트 저장
	 * @param pMap
	 */
	public void saveGRCompareEvent(Map<String, String> pMap);
	
	/**
	 * 영풍 장바구니 등록 이벤트 호출
	 * @param pMap
	 */
	public void saveYPZincCartEvent(Map<String, String> pMap);

	/**
	 * SGS 체크아웃 유저 조회
	 * @param pMap
	 * @return
	 */
	public Map<String, String> selectLoginInfoForSGS(Map<String, String> pMap) ;
	
	/**
	 * SGS 발주 처리
	 * @param pMaps
	 * @return
	 */
	public String saveSgsPurchaseOrder(List<Map<String, String>> pMaps);
	
	/**
	 * SGS 발주 처리
	 * @param pMaps
	 * @return
	 */
	public void saveLog(Map<String, String> pMap);
	
	/**
	 * 펀치아웃 유큐브 전송 데이터 생성.
	 * @param formData
	 * @return
	 */
	public String setPunchoutUcube(Map<String,String>  formData);
	
	/**
	 * 환인제약 pr리스트 조회
	 * @param pMap
	 * @return
	 */
	public List<Map<String, String>> selectWhaninPrList(Map<String, String> pMap) ;
	
	/**
	 * 엔씨켐 결재 정보 조회
	 * @return
	 */
	public List<Map<String, String>> selectNCCHAppReqList(Map<String, String> pMap);
	
	/**
	 * 고객스 그룹웨어 결재 후 처리 로직.
	 * @param pMap
	 * @return
	 */
	public String processNCCHExternApproval(Map<String, String> pMap);
	
	/**
	 * 큐라티스 - hiwors callback
	 * @param pMap
	 */
	public void processQuratisCallbackList(Map<String, String> pMap);
	
	/**
	 * 큐라티스 - Bizbox callback
	 * @param pMap
	 * @throws Exception 
	 */
	public void processQuratisBizboxCallbackList(Map<String, String> pMap) throws Exception;
	
	public void processHongIkCallbackList(Map<String, String> pMap);
	
	public List<Map<String, String>> processLnfAppSendList(Map<String, String> pMap);
	
	public void processLnfCallbackList(Map<String, String> pMap);
	
	/**
	 * 한화 사용자 정보 저장
	 * @param pMap
	 */
	public Map<String, String> mergetHanwhaUser(Map<String, String> pMap);

	public List<Map<String, String>> selectHanwhaAppUserList(Map<String, Object> pMap);
	
	public void processAeKyAppStatus(Map<String, Object> aMap, String type);
	
	
	/**
	 * 롯데 결재 연동  
	 * @param pMap
	 */
	public Map<String, Object> processLotteMpRqAppSend(Map<String, Object> pMap) throws Exception;
	
	/**
	 * FAGB 체크아웃 유저 조회
	 * @param pMap
	 * @return
	 */
	public Map<String, String> selectLoginInfoForFAGB(Map<String, String> pMap);
	
	/**
	 * FAGB 
	 * @param pMap
	 * @return
	 */	
	public String saveFagbPurchaseOrder(List<Map<String, String>> pMaps);

	/**
	 * 필립모리스 체크아웃 유저 조회
	 * @param pMap
	 * @return
	 */	
	public Map<String, String> selectLoginInfoForPMK(Map<String, String> pMap);
	
	/**
	 * 필립모리스 체크아웃 발주 조회
	 * @param pMap
	 * @return
	 */	
	public String savePMKPurchaseOrder(List<Map<String, String>> pMaps);
	
	/**
	 * 유한킴벌리 체크아웃 유저 조회
	 * @param pMap
	 * @return
	 */	
	public Map<String, String> selectLoginInfoForYHKB(Map<String, String> pMap);
	
	/**
	 * 유한킴벌리 체크아웃 발주 조회
	 * @param pMap
	 * @return
	 */	
	public String saveYHKBPurchaseOrder(List<Map<String, String>> pMaps);

	/**
	 * 솔브레인
	 * @param pMap
	 * @return
	 */	
	public void setSoulbrainMsdsStatus(Map<String, String> pMap);
	
	// 유한킴벌리 사용자 등록
	public String saveYhkbSignUp(Map<String, String> pMap);
}
