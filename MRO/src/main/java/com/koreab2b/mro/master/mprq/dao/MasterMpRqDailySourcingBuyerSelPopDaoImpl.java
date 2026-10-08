package com.koreab2b.mro.master.mprq.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

@Repository("masterMpRqDailySourcingBuyerSelPopDao")
@Transactional
public class MasterMpRqDailySourcingBuyerSelPopDaoImpl implements MasterMpRqDailySourcingBuyerSelPopDao {

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	public List<Map<String,String>> selectList(Map<String,Object> formData) {
		return sqlSessionTemplate.selectList("master.mprq.selectMasterMpRqDailySourcingBuyerSelPopList", formData);
	}

}
