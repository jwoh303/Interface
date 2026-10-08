package com.koreab2b.mro.common.wmco.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.util.CommonUtil;

@Repository("masterWmCoWmsNoticePopDao")
@Transactional
public class MasterWmCoWmsNoticePopDaoImpl implements MasterWmCoWmsNoticePopDao {

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	// 조회
	public List<Map<String,String>> selectList(Map<String,Object> formData) {
		return sqlSessionTemplate.selectList("common.wmco.selectMasterWmCoWmsNoticePopList", formData);
	}
	
}
