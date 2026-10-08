package com.koreab2b.mro.common.none.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

@Repository("commonNoNeNoticeBuyerPopDao")
@Transactional
public class CommonNoNeNoticeBuyerPopDaoImpl implements CommonNoNeNoticeBuyerPopDao {

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	// 조회
	public List<Map<String,String>> getCommonNoNeNoticeBuyerPop(Map<String,String> formData) {
		return sqlSessionTemplate.selectList("common.none.selectCommonNoNeNoticeBuyerPopList", formData);
	}
}
