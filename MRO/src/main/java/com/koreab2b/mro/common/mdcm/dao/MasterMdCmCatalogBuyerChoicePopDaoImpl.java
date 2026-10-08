package com.koreab2b.mro.common.mdcm.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

@Repository("masterMdCmCatalogBuyerChoicePopDao")
@Transactional
public class MasterMdCmCatalogBuyerChoicePopDaoImpl implements MasterMdCmCatalogBuyerChoicePopDao {

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	// 조회
	public List<Map<String,String>> selectList(Map<String,String> formData) {
		
		if(formData.get("temp_flag").equals("QUERY") ){
			return sqlSessionTemplate.selectList("common.mdcm.selectMasterMdCmCatalogBuyerChoicePopList", formData);
		}else{
			return sqlSessionTemplate.selectList("common.mdcm.selectDefMasterMdCmCatalogBuyerChoicePopList", formData);
		}
	}
	
}
