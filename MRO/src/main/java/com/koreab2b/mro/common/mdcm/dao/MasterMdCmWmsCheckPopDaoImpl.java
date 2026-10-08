package com.koreab2b.mro.common.mdcm.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

@Repository("masterMdCmWmsCheckPopDao")
@Transactional
public class MasterMdCmWmsCheckPopDaoImpl implements MasterMdCmWmsCheckPopDao {

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	// 조회
	public List<Map<String,String>> selectList(Map<String,String> formData) {
		
		if("KA".equals(formData.get("st_site")) ){
			return sqlSessionTemplate.selectList("common.mdcm.selectMasterMdCmWmsCheckPopListKA", formData);
		}else{
			return sqlSessionTemplate.selectList("common.mdcm.selectMasterMdCmWmsCheckPopList", formData);
		}
	}
	
}
