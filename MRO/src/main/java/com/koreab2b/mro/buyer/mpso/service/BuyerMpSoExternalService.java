package com.koreab2b.mro.buyer.mpso.service;

import java.util.List;
import java.util.Map;

/**
 * 외부 인터페이스용 서비스
 * @author Jinsoo
 *
 */
public interface BuyerMpSoExternalService {

	/**
	 * 광동제약 그룹웨어 요청시 주문 내역을 조회한다.
	 * @param pMap
	 * @return
	 */
	public List<Map<String, String>> getKwangdongGWList(Map<String, String> pMap);
	
	/**
	 * 광동제약 그룹웨어 결재 후처리.
	 * @param pMap
	 * @return
	 */
	public String setKwangdongApproval(Map<String, String> pMap);
	
	/**
	 * 미스미 체크아웃 저장.
	 * @param pMap
	 * @return
	 */
	public String setMisumiCheckOut(Map<String, String> pMap);
	
	/**
	 * 고객사 미스미 품목 검색 결과 저장.
	 * @param pMaps
	 * @return
	 */
	public String setMisumiBuyerCheckOut(List<Map<String, String>> pMaps);
	
	/**
	 * 견적 요청시 필요한 사용자 정보 획득..
	 * @param pMap
	 * @return
	 */
	public Map<String,String> getUserInfo(Map<String,String> pMap);
	
	/**
	 * 영풍 마감 이벤트 저장 
	 * @param pMap
	 */
	public void saveGRCompareEvent(Map<String,String> pMap);
	
	/**
	 * 영풍 장바구니 이벤트 
	 * @param pMap
	 */
	public void saveYPZincCartEvent(Map<String,String> pMap);
	
	/**
	 * sgs 로그인
	 * @param pMap
	 * @return
	 */
	public Map<String, String> getLoginXmlForSGS(Map<String, String> pMap);
	
	/**
	 * sgs 발주저장
	 * @param pMaps
	 * @return
	 */
	public String saveSgsPurchaseOrder(List<Map<String, String>> pMaps);
	
	/**
	 * log 
	 * @param pMap
	 * @return
	 */
	public void saveLog(Map<String, String> pMap);
	
	/**
	 * 환인제약 pr 조회
	 * @param pMap
	 * @return
	 */
	public List<Map<String, String>> getWhaninPrList(Map<String, String> pMap);
	
	/**
	 * 엔씨켐 결재상신 정보
	 * @param pMap
	 * @return
	 */
	public List<Map<String, String>> getNCCHAppReqList(Map<String, String> pMap);

	/**
	 * 고객사 그룹웨어 결재 후처리.
	 * @param pMap
	 * @return
	 */
	public String setExternNCCHApproval(Map<String, String> pMap);
	
	
	public void setQuratisCallbackList(Map<String, String> pMap);
	
	/**
	 * 큐라티스-bizbox callback service
	 * @param pMap
	 * @throws Exception 
	 */
	public void setQuratisBizboxCallbackList(Map<String, String> pMap) throws Exception;
	
	public void setHongIkCallbackList(Map<String, String> pMap);
	
	public List<Map<String, String>> setLnfAppSendList (Map<String, String> pMap);
	
	public void setLnfCallbackList(Map<String, String> pMap);
	
	/**
	 * 한화 사용자 정보 조회 결과를 저장
	 * @param pMap
	 */
	public Map<String, String> setHanwhaUser(Map<String, String> pMap);

	public List<Map<String, String>> getHanwhaAppUserList(Map<String, Object> pMap);
	
	public void setAeKyAppStatus(Map<String, Object> pMap, String type);

	/**
	 * 롯데 결재 연동  
	 * @param pMap
	 */
	public Map<String, Object> getLotteMpRqAppSend(Map<String, Object> pMap) throws Exception;

	
	/**
	 * 셰플러 로그인
	 * @param pMap
	 * @return
	 */
	public Map<String, String> getLoginXmlForFAGB(Map<String, String> pMap);

	/**
	 * 셰플러 발주정보
	 * @param pMap
	 * @return
	 */
	public String saveFagbPurchaseOrder(List<Map<String, String>> pMaps);

	/**
	 * 필립모리스 로그인
	 * @param pMap
	 * @return
	 */
	public Map<String, String> getLoginXmlForPMK(Map<String, String> pMap);

	/**
	 * 필립모리스 발주정보
	 * @param pMap
	 * @return
	 */
	public String savePMKPurchaseOrder(List<Map<String, String>> pMaps);
	
	/**
	 * 유한킴벌리 로그인
	 * @param pMap
	 * @return
	 */
	public Map<String, String> getLoginXmlForYHKB(Map<String, String> pMap);

	/**
	 * 유한킴벌리 발주정보
	 * @param pMap
	 * @return
	 */
	public String saveYHKBPurchaseOrder(List<Map<String, String>> pMaps);

	/**
	 * 솔브레인
	 * @param pMap
	 * @param req
	 * @return
	 * @throws IOException 
	 */
	public void setSoulbrainMsdsStatus(Map<String, String> pMap);
	
	// 유한킴벌리 사용자 등록
	public String saveYhkbSignUp(Map<String, String> pMap);
}
