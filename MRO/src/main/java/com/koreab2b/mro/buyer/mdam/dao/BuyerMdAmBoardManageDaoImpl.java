package com.koreab2b.mro.buyer.mdam.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

@Repository("buyerMdAmBoardManageDao")
@Transactional
public class BuyerMdAmBoardManageDaoImpl implements BuyerMdAmBoardManageDao {

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	// 조회
	public List<Map<String,String>> selectList(Map<String,String> formData) {
		return sqlSessionTemplate.selectList("buyer.mdam.selectBuyerMdAmBoardManageList", formData);
		
	}
	
	public Map<String,String> getDetailList(Map<String,String> formData) {
		sqlSessionTemplate.update("buyer.mdam.updateBoardLCount", formData);
		return sqlSessionTemplate.selectOne("buyer.mdam.selectBuyerMdAmBoardManageDetailList", formData);
	}
	
	public void updateDetailList(Map<String,String>  formData) { 
		sqlSessionTemplate.update("buyer.mdam.updateBoardDetailList", formData);
		//첨부파일 유효성 활성화(GABAGE_FLAG 를 'Y' 로 변경) 
		formData.put("DOC_NO", formData.get("IMAGE_KEY"));
		sqlSessionTemplate.update("common.fileUploadFlagUpdate", formData);
	}
	
	public void deleteDetailList(Map<String,String>  formData) { 
		sqlSessionTemplate.update("buyer.mdam.deleteBoardDetailList", formData);
	}
	
	public void insertDetailList(Map<String,String>  formData) { 
		if("QA_RE".equals(formData.get("st_re_flag"))){
			int lev = Integer.parseInt(formData.get("st_parent_blevel")) + 1; // 현재 Parent에 사용되는 BLEVEL+1을 한다.
			formData.put("lev", String.valueOf(lev));
			
			String pvid = sqlSessionTemplate.selectOne("buyer.mdam.getKePPrevMaxVid", formData);
			formData.put("pvid", pvid);
			
			String vid1 = sqlSessionTemplate.selectOne("buyer.mdam.getKePPrevVid", formData);
			if(vid1 == null || "".equals(vid1)){
				vid1 = formData.get("st_parent_vid");
			}
			formData.put("vid1", vid1);
			
			String vid2 = sqlSessionTemplate.selectOne("buyer.mdam.getKePNextVid", formData);
			
            float vid3 = (float)((Integer.parseInt(vid1) + Integer.parseInt(vid2)) / 2.0);
			formData.put("vid3", String.valueOf(vid3));
		}
		
		sqlSessionTemplate.update("buyer.mdam.insertBoardDetailList", formData);
		//첨부파일 유효성 활성화(GABAGE_FLAG 를 'Y' 로 변경) 
		formData.put("DOC_NO", formData.get("IMAGE_KEY"));
		sqlSessionTemplate.update("common.fileUploadFlagUpdate", formData);
	}
	
}
