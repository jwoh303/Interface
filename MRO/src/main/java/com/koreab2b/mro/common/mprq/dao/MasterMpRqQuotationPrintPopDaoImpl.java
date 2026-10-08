package com.koreab2b.mro.common.mprq.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;


@Repository("masterMpRqQuotationPrintPopDao")
@Transactional
public class MasterMpRqQuotationPrintPopDaoImpl implements MasterMpRqQuotationPrintPopDao {

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	// 조회
	public List<Map<String,String>> selectList(Map<String,Object> formData) {
		return sqlSessionTemplate.selectList("common.mprq.selectMasterMpRqQuotationPrintPopList", formData);
	}
	
}
