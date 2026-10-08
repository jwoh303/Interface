package com.koreab2b.mro.common.mdcm.dao;

import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

@Repository("masterMdCmStndrdCatalogDetailViewPopDao")
@Transactional
public class MasterMdCmStndrdCatalogDetailViewPopDaoImpl implements MasterMdCmStndrdCatalogDetailViewPopDao {
	
	private static final Logger logger = LoggerFactory.getLogger(MasterMdCmStndrdCatalogDetailViewPopDaoImpl.class);

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	// 조회
	public List<Map<String,String>> selectList(Map<String,String> formData) {
		return sqlSessionTemplate.selectList("common.mdcm.selectMasterMdCmStndrdCatalogDetailViewPopList", formData);
	}
	
	// 상품상세속성
	public List<Map<String,String>> getCmsCatalogDispPopAttr(Map<String,String> formData){
		return sqlSessionTemplate.selectList("common.mdcm.selectMasterMdCmCmsCatalogDispPopAttrList", formData);
	}
	
	// 이미지
	public List<Map<String,String>> getCmsCatalogDispPopImg(Map<String,String> formData){
		return sqlSessionTemplate.selectList("common.mdcm.selectMasterMdCmCmsCatalogDispPopImgList", formData);
	}
	
	//저장
	public String updateSelectedData(Map<String,String> formData) {
		String _rtnMsg = "정상적으로 처리 수정 완료 되었습니다.";
		try {
			
			sqlSessionTemplate.update("common.mdcm.updateMasterMdCmStndrdCatalogDetailViewPop", formData);
			
			// 표준카테고리 변경시 구매사카탈로그의 표준카테고리 변경
			if(formData.get("st_cms_categ_change_yn").equals("Y") ){
				sqlSessionTemplate.update("common.mdcm.updateMasterMdCmBuyerCatalogChange1", formData);
				sqlSessionTemplate.update("common.mdcm.updateMasterMdCmBuyerCatalogChange2", formData);
				sqlSessionTemplate.update("common.mdcm.updateMasterMdCmBuyerCatalogChange3", formData);
				sqlSessionTemplate.update("common.mdcm.updateMasterMdCmBuyerCatalogChange4", formData);
				sqlSessionTemplate.update("common.mdcm.updateMasterMdCmBuyerCatalogChange5", formData);
			}
			
			//첨부파일 유효성 활성화(GABAGE_FLAG 를 'Y' 로 변경) 
			formData.put("DOC_NO", formData.get("st_image_key"));
			sqlSessionTemplate.update("common.fileUploadFlagUpdate", formData);
			
		} catch (Exception e) {
			logger.error("SQL ERROR : ", e);
			_rtnMsg = "처리하던중 오류가 발생하였습니다.\n\n담당자에게 문의 바랍니다.";
			throw new RuntimeException("처리하던중 오류가 발생하였습니다.\n\n관리자에게 문의 하세요");
		}
		
		return _rtnMsg; 
	}


}
