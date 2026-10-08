package com.koreab2b.mro.common.mpso.dao;

import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

@Repository("masterMpSoPrewarhsngRequestDetailInfoPopDao")
@Transactional
public class MasterMpSoPrewarhsngRequestDetailInfoPopDaoImpl implements MasterMpSoPrewarhsngRequestDetailInfoPopDao {

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	// 조회
	public Map<String,String> getDetail(Map<String,Object> formData) {
		return sqlSessionTemplate.selectOne("common.mpso.selectMasterMpSoPrewarhsngRequestDetailInfoPopList", formData);
	}
	
}
