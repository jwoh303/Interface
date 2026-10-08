package com.koreab2b.mro.master.mdct.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

@Repository("masterMdctNewReBuyerDao")
@Transactional
public class MasterMdctNewReBuyerDaoImpl implements MasterMdctNewReBuyerDao {
	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	
	// 전체 조회
	public List<Map<String,String>> selectAllList(Map<String,Object> param) {
		return sqlSessionTemplate.selectList("master.mdct.selectMasterMdctNewReBuyerAllList", param);
	}
	
	// 개인 조회
	public List<Map<String,String>> selectIndvList(Map<String,Object> param) {
		return sqlSessionTemplate.selectList("master.mdct.selectMasterMdctNewReBuyerIndvList", param);
	}
}
