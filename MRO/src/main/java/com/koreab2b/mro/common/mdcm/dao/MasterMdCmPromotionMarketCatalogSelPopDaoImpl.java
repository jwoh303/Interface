package com.koreab2b.mro.common.mdcm.dao;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

@Repository("masterMdCmPromotionMarketCatalogSelPopDao")
@Transactional
public class MasterMdCmPromotionMarketCatalogSelPopDaoImpl implements MasterMdCmPromotionMarketCatalogSelPopDao {

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	// 조회
	public List<Map<String,String>> selectList(Map<String,String> formData) {
		return sqlSessionTemplate.selectList("common.mdcm.selectMasterMdCmPromotionMarketCategorySelPopList", formData);
	}
	
	// 조회
	public List<Map<String,String>> getCategorySelPop(Map<String,String> formData) {
		return sqlSessionTemplate.selectList("common.mdcm.selectCategorySelPop", formData);
	}

	// 조회
	public List<Map<String,String>> getSgInfo(Map<String,String> formData) {
		return sqlSessionTemplate.selectList("common.mdcm.selectSgInfo", formData);
	}
	// 조회
	public List<Map<String,String>> getCategInfo(Map<String,String> formData) {
		return sqlSessionTemplate.selectList("common.mdcm.selectCategInfo", formData);
	}
	// 조회
	public List<Map<String,String>> getBuyerSgInfo(Map<String,String> formData) {
		return sqlSessionTemplate.selectList("common.mdcm.selectBuyerSgInfo", formData);
	}
	// 조회
	public List<Map<String,String>> getNewUserInfo(Map<String,String> formData) {
		return sqlSessionTemplate.selectList("common.mdcm.selectNewUserInfo", formData);
	}
	// 주문불가능자리스트조회
	public List<Map<String,String>> getOrderUserInfo(Map<String,String> formData) {
		return sqlSessionTemplate.selectList("common.mdcm.selectOrderUserInfo", formData);
	}

	@Override
	public Map<String, String> getSmartSgInfo(Map<String, String> formData) {		 
		List<Map<String, String>> sgCodeList = sqlSessionTemplate.selectList("common.mdcm.selectSmartSgInfo", formData);
		Map<String, String> sgCodeMap = new HashMap<String, String>();
		for(int i = 0; i < sgCodeList.size(); i++) {
			String code = sgCodeList.get(i).get("CODE");
			String[] sgCode = code.split("=");
			sgCodeMap.put(sgCode[0], sgCode[1]);
		}
		return sgCodeMap;
	}

	@Override
	public List<String> getSmartSgIdInfo(Map<String, Object> formData) {		
		List<Map<String, String>> sgCodeIdList = sqlSessionTemplate.selectList("common.mdcm.selectSmartSgIdInfo", formData);
		List<String> IdList = new ArrayList<String>();
		for(int i = 0; i < sgCodeIdList.size(); i++) {
			String kepId = sgCodeIdList.get(i).get("CODE2");
			IdList.add(kepId);			
		}
		return IdList;
	}
}
