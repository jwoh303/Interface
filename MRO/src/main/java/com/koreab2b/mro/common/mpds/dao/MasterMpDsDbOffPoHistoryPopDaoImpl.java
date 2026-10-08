package com.koreab2b.mro.common.mpds.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository("masterMpDsDbOffPoHistoryPopDao")
public class MasterMpDsDbOffPoHistoryPopDaoImpl implements MasterMpDsDbOffPoHistoryPopDao {

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate; 

	public List<Map<String,String>> selectList(Map<String,Object>  pMap){
		return sqlSessionTemplate.selectList("master.mpds.selectMpDsDbOffPoHistoryList", pMap);
	}
	
}
