package com.koreab2b.mro.common.home.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

@Repository("buyerHomeDeptBudgetPopDao")
@Transactional
public class BuyerHomeDeptBudgetPopDaoImpl implements BuyerHomeDeptBudgetPopDao {
	private static final Logger LOGGER = LoggerFactory.getLogger(BuyerHomeDeptBudgetPopDaoImpl.class);
	
	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	// 조회
	public List<Map<String,String>> selectList(Map<String,Object> formData) {
		int multi_dept_user_cnt = (Integer)sqlSessionTemplate.selectOne("common.home.selectBuyerHomeDeptBudgetPopChk", formData);

		if(multi_dept_user_cnt > 0){
			formData.put("multi_dept_user_yn", "Y");
		}else{
			formData.put("multi_dept_user_yn", "N");
		}
		return sqlSessionTemplate.selectList("common.home.selectBuyerHomeDeptBudgetPopList", formData);
	}
	public List<Map<String,String>> selectList_v2(Map<String,Object> formData) {
		int multi_dept_user_cnt = (Integer)sqlSessionTemplate.selectOne("common.home.selectBuyerHomeDeptBudgetPopChk", formData);
		
		if(multi_dept_user_cnt > 0){
			formData.put("multi_dept_user_yn", "Y");
		}else{
			formData.put("multi_dept_user_yn", "N");
		}
		
		return sqlSessionTemplate.selectList("common.home.selectBuyerHomeDeptBudgetPopList_v2", formData);
	}
}
