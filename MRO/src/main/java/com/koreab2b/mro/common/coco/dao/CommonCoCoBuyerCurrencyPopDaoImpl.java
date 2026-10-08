package com.koreab2b.mro.common.coco.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

@Repository("commonCoCoBuyerCurrencyPopDao")
public class CommonCoCoBuyerCurrencyPopDaoImpl implements CommonCoCoBuyerCurrencyPopDao {
	private static final Logger logger = LoggerFactory.getLogger(CommonCoCoBuyerCurrencyPopDaoImpl.class);
	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	private String _rtnMsg = "";
	
	public List<Map<String,String>> getCommonCoCoBuyerCurrencyPop(Map<String,Object> pMap) {
		
		List<Map<String,String>> resultList = sqlSessionTemplate.selectList("common.coco.selectCommonCoCoBuyerCurrencyPop", pMap);
		
		return resultList;
	}
	// 생성
	@SuppressWarnings("unchecked")
	public String saveCommonCoCoBuyerCurrencyPop(Map<String,String>  formData, List<Object> gridData) {
		
		_rtnMsg = "환율매핑 처리 완료되었습니다.";
		
		try{
			
			for(int i=0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));
				//외화단가 정보 입력
				sqlSessionTemplate.update("common.coco.insertCommonCoCoBuyerCurrency", formData);
				//외화단가 이력 입력
				sqlSessionTemplate.update("common.coco.insertCommonCoCoBuyerCurrencyHist", formData);
			}
			
		} catch (Exception e){
			logger.error("SQL ERROR : ", e);
			_rtnMsg = "환율매핑 처리 실패하였습니다.";
			throw new RuntimeException("환율매핑 처리 실패하였습니다.");
		}
		return _rtnMsg;
	}
	// 삭제
	@SuppressWarnings("unchecked")
	public String deleteCommonCoCoBuyerCurrencyPop(Map<String,String>  formData, List<Object> gridData) {
		
		_rtnMsg = "환율매핑 삭제완료 되었습니다.";
		
		try{
			for(int i=0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));
				//외화단가 매핑 삭제
				sqlSessionTemplate.update("common.coco.deleteCommonCoCoBuyerCurrency", formData);

			}
		}catch(Exception e){
			_rtnMsg = "환율매핑 삭제 실패하였습니다.";
			logger.error("SQL ERROR : ", e);
			throw new RuntimeException("환율매핑 삭제 실패하였습니다.");
		}

		return _rtnMsg;		
		
	}	
}
