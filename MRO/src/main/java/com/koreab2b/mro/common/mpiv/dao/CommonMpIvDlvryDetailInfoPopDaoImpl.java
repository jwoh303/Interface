package com.koreab2b.mro.common.mpiv.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

@Repository("commonMpIvDlvryDetailInfoPopDao")
@Transactional
public class CommonMpIvDlvryDetailInfoPopDaoImpl implements CommonMpIvDlvryDetailInfoPopDao {

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	// 조회
	public Map<String, String> selectInfo(Map<String,String> formData) {
		return sqlSessionTemplate.selectOne("common.mpiv.selectCommonMpIvDlvryDetailPopInfo", formData);
	}
	
	// 조회
		public List<Map<String,String>> selectList(Map<String,String> formData) {
			return sqlSessionTemplate.selectList("common.mpiv.selectCommonMpIvDlvryDetailPopList", formData);
	}
	
}
