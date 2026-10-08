package com.koreab2b.mro.common.mdcm.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

@Repository("masterMdCmUnitpriceAlterHistoryPopDao")
@Transactional
public class MasterMdCmUnitpriceAlterHistoryPopDaoImpl implements MasterMdCmUnitpriceAlterHistoryPopDao {

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	// 조회
	public List<Map<String,String>> selectList(Map<String,String> formData) {
		
		String strSite =  formData.get("site");
		if("KM".equals(strSite)){
			return sqlSessionTemplate.selectList("common.mdcm.selectMasterMdCmUnitpriceAlterHistoryKMPopList", formData);
		}else{
			return sqlSessionTemplate.selectList("common.mdcm.selectMasterMdCmUnitpriceAlterHistoryPopList", formData);
		}
		
	}
	
}
