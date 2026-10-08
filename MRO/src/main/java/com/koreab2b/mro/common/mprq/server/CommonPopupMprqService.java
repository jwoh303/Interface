package com.koreab2b.mro.common.mprq.server;

import java.util.List;
import java.util.Map;


public interface CommonPopupMprqService {	 
	public Map<String,String> quotationReDetailPopHd(Map<String,String>  pMap);
	public List<Map<String,String>> quotationReDetailPopDt(Map<String,String>  pMap);
	
	/*신규견적 고객사*/
	public List<Map<String,String>> getNewSourcingBuyerList(Map<String,Object>  pMap);

	/*신규Nego 의뢰 고객사*/
	public List<Map<String,String>> getNewSourcingNegoBuyerList(Map<String,Object>  pMap);
	public List<Map<String,String>> getBidSucessCodePop(Map<String,Object>  pMap);
	public List<Map<String,String>> getMarginReSelectPop(Map<String,Object>  pMap);
	public List<Map<String,String>> getSellerChoice4Pop(Map<String,Object>  pMap);
	public List<Map<String,String>> getSellerChoice4CntPop(Map<String,Object>  pMap);
	public List<Map<String,String>> getPumPrintPop(Map<String,Object>  pMap);
	public List<Map<String,String>> getQuotationInitList(Map<String,Object>  pMap);
	public List<Map<String,String>> getSellerUnitPriceHistoryPop(Map<String,String>  pMap);
	public List<Map<String,String>> getNegoview(Map<String,String>  pMap);
	public String saveScmRemark(Map<String,String>  pMap);
	//SG리스트조회.
	public List<Map<String,String>> getMasterMpRqSgChoicePop(Map<String,String>  formData);
	// 삼양사 네고이력 팝업
	public List<Map<String, String>> getSamyangNegoview(Map<String, String> pMap);
	// 고객사제출비고 팝업(ICOMCOD2.TYPE=ASRMGD)
	public Map<String,String> getRemarkAtoB2PopHd(Map<String,String>  pMap);
	
	//단가이력-리뉴얼 조회
	public List<Map<String,String>> getSellerMpRqUnitPriceHistoryPop_v2(Map<String,Object>  pMap);
	//견적상세팝업-리뉴얼 조회
	public List<Map<String,String>> getSellerMpRqQuotaDetailPop_v2(Map<String,String>  pMap);
	//견적상세팝업-첨부파일 조회
	public List<Map<String,String>> getSellerMpRqFile_v2(Map<String,String>  pMap);
	
}
