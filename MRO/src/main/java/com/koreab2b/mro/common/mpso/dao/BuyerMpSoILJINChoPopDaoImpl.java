package com.koreab2b.mro.common.mpso.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

@Repository("buyerMpSoILJINChoPopDao")
@Transactional
public class BuyerMpSoILJINChoPopDaoImpl implements BuyerMpSoILJINChoPopDao {

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
 
	
	public List<Map<String,String>> selectLegacyUserIdList(Map<String,String> formData){
		return sqlSessionTemplate.selectList("common.mpso.selectLegacyUserIdList", formData);
	}

	public List<Map<String,String>> selectIljinProject(Map<String,String>  pMap){
		return sqlSessionTemplate.selectList("common.mpso.iljin_project_list", pMap);
	}
	
	@Override
	public Map<String, String> selectItemItemInfo(Map<String, String> pMap) {
		return sqlSessionTemplate.selectOne("common.mpso.iljin_item_info", pMap);
	}
}
