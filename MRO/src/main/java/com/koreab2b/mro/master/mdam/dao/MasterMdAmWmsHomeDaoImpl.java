package com.koreab2b.mro.master.mdam.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

@Repository("masterMdAmWmsHomeDao")
@Transactional
public class MasterMdAmWmsHomeDaoImpl implements MasterMdAmWmsHomeDao {
	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	
	// 물류센터 공지사항 리스트조회
	public List<Map<String,String>> selectList(Map<String,Object> param) {
		return sqlSessionTemplate.selectList("master.mdam.selectMasterMdAmWmsHomeList", param);
	}
}
