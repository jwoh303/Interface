package com.koreab2b.mro.common.mprq.server;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.common.mprq.dao.CommonPopupMprqInfoDao;

@Service("commonPopupMprqService")
public class CommonPopupMprqServiceImpl implements CommonPopupMprqService {

	@Autowired
	private CommonPopupMprqInfoDao commonPopupMprqInfoDao; 
	
	public Map<String,String> quotationReDetailPopHd(Map<String,String>  pMap){
		return commonPopupMprqInfoDao.quotationReDetailPopHd(pMap);
	}
	public List<Map<String,String>> quotationReDetailPopDt(Map<String,String>  pMap){
		return commonPopupMprqInfoDao.quotationReDetailPopDt(pMap);
	}
	
	/*신규견적 고객사*/
	public List<Map<String,String>> getNewSourcingBuyerList(Map<String,Object>  pMap){
		return commonPopupMprqInfoDao.selectNewSourcingBuyerList(pMap);
	}
	
	/*신규Nego 의뢰 고객사*/
	public List<Map<String,String>> getNewSourcingNegoBuyerList(Map<String,Object>  pMap){
		return commonPopupMprqInfoDao.selectNewSourcingNegoBuyerList(pMap);
	}	
	public List<Map<String,String>> getBidSucessCodePop(Map<String,Object>  pMap){
		return commonPopupMprqInfoDao.getBidSucessCodePop(pMap);
	}	
	public List<Map<String,String>> getMarginReSelectPop(Map<String,Object>  pMap){
		return commonPopupMprqInfoDao.getMarginReSelectPop(pMap);
	}	
	public List<Map<String,String>> getSellerChoice4Pop(Map<String,Object>  pMap){
		return commonPopupMprqInfoDao.getSellerChoice4Pop(pMap);
	}
	public List<Map<String,String>> getSellerChoice4CntPop(Map<String,Object> pMap) {
		return commonPopupMprqInfoDao.getSellerChoice4CntPop(pMap);
	}
	public List<Map<String,String>> getPumPrintPop(Map<String,Object>  pMap){
		return commonPopupMprqInfoDao.getPumPrintPop(pMap);
	}	
	public List<Map<String,String>> getQuotationInitList(Map<String,Object>  pMap){
		return commonPopupMprqInfoDao.getQuotationInitList(pMap);
	}	
	public List<Map<String,String>> getSellerUnitPriceHistoryPop(Map<String,String>  pMap){
		return commonPopupMprqInfoDao.getSellerUnitPriceHistoryPop(pMap);
	}	
	public List<Map<String,String>> getNegoview(Map<String,String>  pMap){
		return commonPopupMprqInfoDao.getNegoview(pMap);
	}	
	public String saveScmRemark(Map<String,String>  pMap){
		return commonPopupMprqInfoDao.saveScmRemark(pMap);
	}	
	public List<Map<String,String>> getMasterMpRqSgChoicePop(Map<String,String> formData) {
		return commonPopupMprqInfoDao.selectMasterMpRqSgChoicePop(formData);
	}
	
	// 삼양사 네고이력 팝업
	public List<Map<String,String>> getSamyangNegoview(Map<String,String>  pMap){
		return commonPopupMprqInfoDao.getSamyangNegoview(pMap);
	}
	// 고객사제출비고 팝업(ICOMCOD2.TYPE=ASRMGD)
	public Map<String,String> getRemarkAtoB2PopHd(Map<String,String>  pMap){
		return commonPopupMprqInfoDao.getRemarkAtoB2PopHd(pMap);
	}
	
	//단가이력 -리뉴얼 조회
	public List<Map<String,String>> getSellerMpRqUnitPriceHistoryPop_v2(Map<String,Object>  pMap){
		return commonPopupMprqInfoDao.getSellerMpRqUnitPriceHistoryPop_v2(pMap);
	}
	//견적상세팝업 조회
	public List<Map<String,String>> getSellerMpRqQuotaDetailPop_v2(Map<String,String>  pMap){
		return commonPopupMprqInfoDao.getSellerMpRqQuotaDetailPop_v2(pMap);
	}
	//견적상세팝업 - 첨부파일 조회
	public List<Map<String,String>> getSellerMpRqFile_v2(Map<String,String>  pMap){
		return commonPopupMprqInfoDao.getSellerMpRqFile_v2(pMap);
	}
}
