package com.koreab2b.mro.common.mpds.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.util.CommonUtil;

@Repository("masterMpDsInspDetailItemPopDao")
@Transactional
public class MasterMpDsInspDetailItemPopDaoImpl implements MasterMpDsInspDetailItemPopDao {

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	// 조회
	public List<Map<String,String>> selectList(Map<String,String> formData) {
		return sqlSessionTemplate.selectList("common.mpds.selectMasterMpDsInspDetailItemPopList", formData);
	}
	
}
