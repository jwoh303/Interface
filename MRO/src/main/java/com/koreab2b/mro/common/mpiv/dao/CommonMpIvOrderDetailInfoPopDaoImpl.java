package com.koreab2b.mro.common.mpiv.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

@Repository("commonMpIvOrderDetailInfoPopDao")
@Transactional
public class CommonMpIvOrderDetailInfoPopDaoImpl implements CommonMpIvOrderDetailInfoPopDao {

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	// 조회
	public Map<String, String> selectList(Map<String,String> formData) {
		return sqlSessionTemplate.selectOne("common.mpiv.selectCommonMpIvOrderDetailInfoPopList", formData);
	}
	public Map<String, String> selectList_v2(Map<String,String> formData) {
		return sqlSessionTemplate.selectOne("common.mpiv.selectCommonMpIvOrderDetailInfoPopList_v2", formData);
	}
	
}
