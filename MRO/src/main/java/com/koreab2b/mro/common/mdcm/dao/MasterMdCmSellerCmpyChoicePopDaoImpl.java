package com.koreab2b.mro.common.mdcm.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.util.CommonUtil;

@Repository("masterMdCmSellerCmpyChoicePopDao")
@Transactional
public class MasterMdCmSellerCmpyChoicePopDaoImpl implements MasterMdCmSellerCmpyChoicePopDao {

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	// 조회
	public List<Map<String,String>> selectList(Map<String,String> formData) {
		String temp_flag = CommonUtil.nvl((String) formData.get("temp_flag"));
		
		if(temp_flag.equals("OLD")) {
			return sqlSessionTemplate.selectList("common.mdcm.selectMasterMdCmSellerCmpyChoicePopOldList", formData);
		}else if(temp_flag.equals("NEW")) {
			return sqlSessionTemplate.selectList("common.mdcm.selectMasterMdCmSellerCmpyChoicePopNewList", formData);
		}else{
			return sqlSessionTemplate.selectList("common.mdcm.selectMasterMdCmSellerCmpyChoicePopList", formData);
		}
	}
	
}
