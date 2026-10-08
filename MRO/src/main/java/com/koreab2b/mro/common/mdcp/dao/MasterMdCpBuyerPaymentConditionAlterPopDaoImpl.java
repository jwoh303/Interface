package com.koreab2b.mro.common.mdcp.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.util.CommonUtil;

@Repository("masterMdCpBuyerPaymentConditionAlterPopDao")
@Transactional
public class MasterMdCpBuyerPaymentConditionAlterPopDaoImpl implements MasterMdCpBuyerPaymentConditionAlterPopDao {

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	// 조회
	public List<Map<String,String>> selectList(Map<String,String> formData) {
		return sqlSessionTemplate.selectList("common.mdcp.selectMasterMdCpBuyerPaymentConditionAlterPopList", formData);
	}
	
}
