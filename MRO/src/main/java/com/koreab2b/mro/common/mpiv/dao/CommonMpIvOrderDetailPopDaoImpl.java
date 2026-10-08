package com.koreab2b.mro.common.mpiv.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

@Repository("commonMpIvOrderDetailPopDao")
@Transactional
public class CommonMpIvOrderDetailPopDaoImpl implements CommonMpIvOrderDetailPopDao {

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	public Map<String,String> selectInfo(Map<String,String> formData) {
		return sqlSessionTemplate.selectOne("common.mpiv.selectCommonMpIvOrderDetailPopInfo", formData);
	}
	
	// 조회
	public List<Map<String,String>> selectList(Map<String,String> formData) {
		return sqlSessionTemplate.selectList("common.mpiv.selectCommonMpIvOrderDetailPopList", formData);
	}
	public List<Map<String,String>> getCommonMpIvBuyerOrderDetailListPop_v2(Map<String,Object> formData) {
		return sqlSessionTemplate.selectList("common.mpiv.getCommonMpIvBuyerOrderDetailListPop_v2", formData);
	}
}
