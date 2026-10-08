package com.koreab2b.mro.master.mdct.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository("masterMdCtNewReBuyerDetailDao")
public class MasterMdCtNewReBuyerDetailPopDaoImpl implements MasterMdCtNewReBuyerDetailPopDao {
	@Autowired
	private SqlSessionTemplate sqlSessionTemplate; 

	// 조회
	public List<Map<String,String>> selectMasterMdCtNewReBuyerDetailPop(Map<String,Object>  pMap){
		return sqlSessionTemplate.selectList("master.mdct.selectMasterMdCtNewReBuyerDetailPop", pMap);
	}	
}