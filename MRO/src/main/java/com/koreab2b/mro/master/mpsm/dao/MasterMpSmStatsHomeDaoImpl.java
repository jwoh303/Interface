package com.koreab2b.mro.master.mpsm.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

@Repository("masterMpSmStatsHomeDao")
@Transactional
public class MasterMpSmStatsHomeDaoImpl implements MasterMpSmStatsHomeDao {
	
	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	
	// 리스트 조회
	public List<Map<String,String>> selectWarhsngResultList(Map<String,Object> param) {
		return sqlSessionTemplate.selectList("master.mpsm.selectWarhsngResultList", param);
	}
}
