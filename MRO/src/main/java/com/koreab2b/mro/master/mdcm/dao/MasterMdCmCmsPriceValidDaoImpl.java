package com.koreab2b.mro.master.mdcm.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;


@Repository("masterMdCmCmsPriceValidDao")
@Transactional
public class MasterMdCmCmsPriceValidDaoImpl implements MasterMdCmCmsPriceValidDao {

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	// 목록 조회
	public List<Map<String,String>> selectList(Map<String,Object> param) {
		return sqlSessionTemplate.selectList("master.mdcm.selectMasterMdCmCmsPriceValidList", param);
	}

}
