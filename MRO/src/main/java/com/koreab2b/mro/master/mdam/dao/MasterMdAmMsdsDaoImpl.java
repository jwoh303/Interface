package com.koreab2b.mro.master.mdam.dao;

import java.util.List;

import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;


@Repository("masterMdAmMsdsDao")
@Transactional
public class MasterMdAmMsdsDaoImpl implements MasterMdAmMsdsDao {
	
	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	
	// 리스트 조회 , 엑셀다운로드
	public List<Map<String,String>> selectList(Map<String,Object> param) {
		return sqlSessionTemplate.selectList("master.mdam.selectMasterMdAmMsdsList", param);
	}

}
