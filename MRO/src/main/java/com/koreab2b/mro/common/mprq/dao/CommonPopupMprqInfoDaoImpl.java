package com.koreab2b.mro.common.mprq.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository("commonPopupMprqDao")
public class CommonPopupMprqInfoDaoImpl implements CommonPopupMprqInfoDao {
	private String _rtnMsg = "";
	
	@Autowired
	private SqlSessionTemplate sqlSessionTemplate; 

	public Map<String,String> quotationReDetailPopHd(Map<String,String>  pMap){
		return sqlSessionTemplate.selectOne("commonPopupMprq.quotationReDetailPopHd", pMap);
	}
	public List<Map<String,String>> quotationReDetailPopDt(Map<String,String>  pMap){
		return sqlSessionTemplate.selectList("commonPopupMprq.quotationReDetailPopDt", pMap);
	}
	
	/*신규견적고객사*/
	public List<Map<String,String>> selectNewSourcingBuyerList(Map<String,Object>  pMap){
		return sqlSessionTemplate.selectList("commonPopupMprq.newSourcingBuyerList", pMap);
	}	

	/*신규Nego 의뢰 고객사*/
	public List<Map<String,String>> selectNewSourcingNegoBuyerList(Map<String,Object>  pMap){
		return sqlSessionTemplate.selectList("commonPopupMprq.newSourcingNegoBuyerList", pMap);
	}		
	public List<Map<String,String>> getBidSucessCodePop(Map<String,Object>  pMap){
		return sqlSessionTemplate.selectList("commonPopupMprq.selectBidSucessCodePop", pMap);
	}		
	public List<Map<String,String>> getMarginReSelectPop(Map<String,Object>  pMap){
		return sqlSessionTemplate.selectList("commonPopupMprq.selectMarginReSelectPop", pMap);
	}		
	public List<Map<String,String>> getSellerChoice4Pop(Map<String,Object>  pMap){
		return sqlSessionTemplate.selectList("commonPopupMprq.selectSellerChoice4Pop", pMap);
	}		
	public List<Map<String,String>> getSellerChoice4CntPop(Map<String,Object>  pMap){
		return sqlSessionTemplate.selectList("commonPopupMprq.selectSellerChoice4CntPop", pMap);
	}		
	public List<Map<String,String>> getPumPrintPop(Map<String,Object>  pMap){
		return sqlSessionTemplate.selectList("commonPopupMprq.selectPumPrintPop", pMap);
	}		
	public List<Map<String,String>> getQuotationInitList(Map<String,Object>  pMap){
		return sqlSessionTemplate.selectList("commonPopupMprq.selectQuotationInitListPop", pMap);
	}		
	public List<Map<String,String>> getSellerUnitPriceHistoryPop(Map<String,String>  pMap){
		return sqlSessionTemplate.selectList("commonPopupMprq.selectSellerUnitPriceHistoryPop", pMap);
	}
	public List<Map<String,String>> getNegoview(Map<String,String>  pMap){
		return sqlSessionTemplate.selectList("commonPopupMprq.selectNegoviewPop", pMap);
	}
	public String saveScmRemark(Map<String,String>  pMap){
		_rtnMsg = "정상적으로 저장되었습니다.";
		try{
			sqlSessionTemplate.update("commonPopupMprq.saveScmRemark", pMap);
		}catch(Exception e){
			throw new RuntimeException("처리를 하던중 오류가 발생하였습니다.\n\n관리자에게 문의 바랍니다.");
		}
		return _rtnMsg;	
		
	}
	// 조회
	public List<Map<String,String>> selectMasterMpRqSgChoicePop(Map<String,String> formData) {
		return sqlSessionTemplate.selectList("commonPopupMprq.selectMasterMpRqSgChoicePop", formData);
	}
	
	// 삼양사 네고이력 팝업
	public List<Map<String, String>> getSamyangNegoview(Map<String, String> pMap) {
		return sqlSessionTemplate.selectList("commonPopupMprq.selectSamyangNegoviewPop", pMap);
	}
	// 고객사제출비고 팝업(ICOMCOD2.TYPE=ASRMGD 포함)
	public Map<String,String> getRemarkAtoB2PopHd(Map<String,String>  pMap){
		return sqlSessionTemplate.selectOne("commonPopupMprq.selectRemarkAtoB2PopHd", pMap);
	}
	
	//단가이력-리뉴얼 조회
	public List<Map<String,String>> getSellerMpRqUnitPriceHistoryPop_v2(Map<String,Object>  pMap){
		return sqlSessionTemplate.selectList("commonPopupMprq.selectSellerMpRqUnitPriceHistoryPop_v2", pMap);
	}
	//견적상세팝업-리뉴얼 조회
	public List<Map<String,String>> getSellerMpRqQuotaDetailPop_v2(Map<String,String>  pMap){
		return sqlSessionTemplate.selectList("commonPopupMprq.selectSellerMpRqQuotaDetailPop_v2", pMap);
	}
	//견적상세팝업-리뉴얼-첨부파일 조회
	public List<Map<String,String>> getSellerMpRqFile_v2(Map<String,String>  pMap){
		return sqlSessionTemplate.selectList("commonPopupMprq.getSellerMpRqFile_v2", pMap);
	}
}
