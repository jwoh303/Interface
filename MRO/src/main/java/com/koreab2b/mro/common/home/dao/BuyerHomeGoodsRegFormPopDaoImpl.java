package com.koreab2b.mro.common.home.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

@Repository("buyerHomeGoodsRegFormPopDao")
@Transactional
public class BuyerHomeGoodsRegFormPopDaoImpl implements BuyerHomeGoodsRegFormPopDao {
	private static final Logger LOGGER = LoggerFactory.getLogger(BuyerHomeGoodsRegFormPopDaoImpl.class);
	
	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	// 조회
	public List<Map<String,String>> selectList(Map<String,Object> formData) {
		return sqlSessionTemplate.selectList("common.home.selectBuyerHomeGoodsRegFormPopList", formData);
	}
	
	// 저장
	@SuppressWarnings("unchecked")
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData) {
		String _rtnMsg = "정상적으로 처리되었습니다.";
		
		try {
			for ( int i=0; i < gridData.size(); i++ ) {
				formData.putAll((Map<String, String>)gridData.get(i));
				
				LOGGER.debug("insertBuyerHomeGoodsRegFormPopList 요청 파라미터 : formData {}", formData.get("sStatus"));
				
				if ( "I".equals(formData.get("sStatus")) ) {
					sqlSessionTemplate.insert("common.home.insertBuyerHomeGoodsRegFormPopList", formData);
					
					formData.put("DOC_NO", formData.get("IMAGE_KEY"));
					sqlSessionTemplate.update("common.fileUploadFlagUpdate", formData);
				}
			}
		} catch (Exception e) {
			_rtnMsg = "등록에 실패하였습니다.\n\n다시 확인하여 주십시요.";
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("등록에 실패하였습니다.\n\n다시 확인하여 주십시요.");
		}
		
		return _rtnMsg;
	}
	
	// 삭제
	@SuppressWarnings("unchecked")
	public String deleteSelectedData(Map<String,String>  formData, List<Object> gridData) {
		String _rtnMsg = "정상적으로 처리되었습니다.";
		
		try {
			for ( int i=0; i < gridData.size(); i++ ) {
				formData.putAll((Map<String, String>)gridData.get(i));
	
				LOGGER.debug("deletetBuyerHomeGoodsRegFormPop 요청 파라미터 : formData {}", formData);
				sqlSessionTemplate.delete("common.home.deletetBuyerHomeGoodsRegFormPopList", formData);
			}
		} catch (Exception e) {
			_rtnMsg = "삭제에 실패하였습니다.\n\n다시 확인하여 주십시요.";
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("삭제에 실패하였습니다.\n\n다시 확인하여 주십시요.");
		}
		
		return _rtnMsg;
	}
	
}
