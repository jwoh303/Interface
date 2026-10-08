package com.koreab2b.mro.common.mprq.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

@Repository("buyerMpRqDepartmentTotalPopDao")
@Transactional
public class BuyerMpRqDepartmentTotalPopDaoImpl implements BuyerMpRqDepartmentTotalPopDao {

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	public Map<String,String> getHdForm(Map<String,String>  formData){
		return sqlSessionTemplate.selectOne("common.mprq.selectHdForm", formData);
	}

	// 조회
	public List<Map<String,String>> selectList(Map<String,String> formData) {
		return sqlSessionTemplate.selectList("common.mprq.selectTotalPopList", formData);
	}
	
}
