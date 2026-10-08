package com.koreab2b.mro.common.mdcm.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.util.CommonUtil;

@Repository("masterMdCmFinalOrderDateViewPopDao")
@Transactional
public class MasterMdCmFinalOrderDateViewPopDaoImpl implements MasterMdCmFinalOrderDateViewPopDao {

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	// 조회
	public List<Map<String,String>> selectList(Map<String,String> formData) {
		
		if(formData.get("st_site").equals("KM")){
			return sqlSessionTemplate.selectList("common.mdcm.selectMasterMdCmFinalOrderDateViewPopKMList", formData);
		}else{
			return sqlSessionTemplate.selectList("common.mdcm.selectMasterMdCmFinalOrderDateViewPopList", formData);
		}
		
	}
	
}
