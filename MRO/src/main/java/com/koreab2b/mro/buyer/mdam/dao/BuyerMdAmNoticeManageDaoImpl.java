package com.koreab2b.mro.buyer.mdam.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

@Repository("buyerMdAmNoticeManageDao")
@Transactional
public class BuyerMdAmNoticeManageDaoImpl implements BuyerMdAmNoticeManageDao {

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	// 조회
	public List<Map<String,String>> selectList(Map<String,String> formData) {
		return sqlSessionTemplate.selectList("buyer.mdam.selectBuyerMdAmNoticeManageList", formData);
		
	}
	
	public Map<String,String> getDetailList(Map<String,String> formData) {
		sqlSessionTemplate.update("buyer.mdam.updateNoticeLCount", formData);
		return sqlSessionTemplate.selectOne("buyer.mdam.selectBuyerMdAmNoticeManageDetailList", formData);
	}
	
	public void updateDetailList(Map<String,String>  formData) { 
		sqlSessionTemplate.update("buyer.mdam.updateDetailList", formData);
		//첨부파일 유효성 활성화(GABAGE_FLAG 를 'Y' 로 변경) 
		formData.put("DOC_NO", formData.get("IMAGE_KEY"));
		sqlSessionTemplate.update("common.fileUploadFlagUpdate", formData);

	}
	
	public void deleteDetailList(Map<String,String>  formData) { 
		sqlSessionTemplate.update("buyer.mdam.deleteDetailList", formData);
	}
	
	public void insertDetailList(Map<String,String>  formData) { 
		sqlSessionTemplate.update("buyer.mdam.insertDetailList", formData);
		//첨부파일 유효성 활성화(GABAGE_FLAG 를 'Y' 로 변경) 
		formData.put("DOC_NO", formData.get("IMAGE_KEY"));
		sqlSessionTemplate.update("common.fileUploadFlagUpdate", formData);
	}
	
}
