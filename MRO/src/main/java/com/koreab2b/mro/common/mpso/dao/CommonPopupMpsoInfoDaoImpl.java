package com.koreab2b.mro.common.mpso.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository("commonPopupMpsoDao")
public class CommonPopupMpsoInfoDaoImpl implements CommonPopupMpsoInfoDao {

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate; 

	public Map<String,String> poDetailPopHd(Map<String,String>  pMap){
		return sqlSessionTemplate.selectOne("commonPopupMpso.poDetailPopHd", pMap);
	}
	public List<Map<String,String>> poDetailPopDt(Map<String,String>  pMap){
		return sqlSessionTemplate.selectList("commonPopupMpso.poDetailPopDt", pMap);
	}

	// 특수로직 (발주서인쇄) 조회
	public List<Map<String, String>> getSpecialLogicInfo(Map<String,String> formData) {
		return sqlSessionTemplate.selectList("commonPopupMpso.selectSpecialLogicInfo", formData);
	}
	
	public Map<String,String> poDetailHistPopHd(Map<String,String>  pMap){
		return sqlSessionTemplate.selectOne("commonPopupMpso.poDetailHistPopHd", pMap);
	}
	public List<Map<String,String>> poDetailHistPopDt(Map<String,String>  pMap){
		return sqlSessionTemplate.selectList("commonPopupMpso.poDetailHistPopDt", pMap);
	}

}
