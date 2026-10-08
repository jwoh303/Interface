package com.koreab2b.mro.master.mpso.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

@Repository("masterMpSoMonthClosingInfoDao")
@Transactional
public class MasterMpSoMonthClosingInfoDaoImpl implements MasterMpSoMonthClosingInfoDao {

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	
	// 리스트 조회
	public List<Map<String,String>> selectList(Map<String,Object> param) {
		return sqlSessionTemplate.selectList("master.mpso.selectMasterMpSoMonthClosingInfoList", param);
	}

}
