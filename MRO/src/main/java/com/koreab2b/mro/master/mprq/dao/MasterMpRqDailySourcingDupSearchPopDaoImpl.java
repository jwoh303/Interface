package com.koreab2b.mro.master.mprq.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

@Repository("masterMpRqDailySourcingDupSearchPopDao")
@Transactional
public class MasterMpRqDailySourcingDupSearchPopDaoImpl implements MasterMpRqDailySourcingDupSearchPopDao {

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	public List<Map<String,String>> selectCatList(Map<String,Object> formData) {
		return sqlSessionTemplate.selectList("master.mprq.selectMasterMpRqDailySourcingDupCatList", formData);
	}

	public List<Map<String,String>> selectStdList(Map<String,Object> formData) {
		return sqlSessionTemplate.selectList("master.mprq.selectMasterMpRqDailySourcingDupStdList", formData);
	}

}
