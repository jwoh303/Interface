package com.koreab2b.mro.seller.mpcl.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.master.mprq.dao.MasterMpRqCmpySelQuotationSendDaoImpl;

@Repository("sellerMpClCatalogRecharterDao")
@Transactional
public class SellerMpClCatalogRecharterDaoImpl implements SellerMpClCatalogRecharterDao {
	private static final Logger LOGGER = LoggerFactory.getLogger(MasterMpRqCmpySelQuotationSendDaoImpl.class);
	
	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	private String _rtnMsg = "";
	
	// 리스트 조회
	public List<Map<String,String>> selectList(Map<String,Object> param) {
		return sqlSessionTemplate.selectList("seller.mpcl.selectSellerMpClCatalogRecharterList", param);
	}
	
	// 재계약 제출
	@SuppressWarnings("unchecked")
	@Transactional(rollbackFor=Exception.class, propagation=Propagation.REQUIRED)
	public String saveSelectedData(Map<String,String>  formData, List<Object> gridData) {
		
		_rtnMsg = "재계약을 제출하였습니다.";
		try{
			for(int i=0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));		
				sqlSessionTemplate.update("seller.mpcl.saveSellerMpClCatalogRecharterList", formData);
			}
		}catch(Exception e){
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("재견적 저장에 실패하였습니다.");
		}
		return _rtnMsg;		
	}
	
	// 재계약 이력팝업
	public List<Map<String,String>> getSellerMpClCatalogRecharterHistoryPop(Map<String,Object> param) {
		return sqlSessionTemplate.selectList("seller.mpcl.selectSellerMpCatalogRecharterHistoryPop", param);
	}
	
	// 재계약 포기
	@SuppressWarnings("unchecked")
	public String rejectSellerMpClCatalogRecharter(Map<String,String>  formData, List<Object> gridData) {
		
		_rtnMsg = "재계약 포기 하였습니다.";
		try{
			for(int i=0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));
				//재계약 테이블 재계약 포기 처리
				sqlSessionTemplate.update("seller.mpcl.rejectSellerMpClCatalogRecharter", formData);
				//재계약 포기건 카탈로그 단종 처리
				sqlSessionTemplate.update("seller.mpcl.updateSellerMpClCatalogCloseFlag", formData);
			}
		}catch(Exception e){
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("재계약 포기에 실패하였습니다.");
		}
		return _rtnMsg;		
	}
}
