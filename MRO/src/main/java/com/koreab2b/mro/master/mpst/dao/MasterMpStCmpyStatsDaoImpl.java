package com.koreab2b.mro.master.mpst.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

@Repository("masterMpStCmpyStatsDao")
@Transactional
public class MasterMpStCmpyStatsDaoImpl implements MasterMpStCmpyStatsDao {
	private static final Logger logger = LoggerFactory.getLogger(MasterMpStCmpyStatsDaoImpl.class);

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	
	// 고객사 리스트 조회
	public List<Map<String,String>> selectList(Map<String,Object> param) {
		return sqlSessionTemplate.selectList("master.mpst.selectMasterMpStCmpyStatsList", param);
	}
	
	public List<Map<String,String>> selectMasterMpStCmpyStatsListBNTBUYERGROUP(Map<String,Object> param) {
		return sqlSessionTemplate.selectList("master.mpst.selectMasterMpStCmpyStatsListBNTBUYERGROUP", param);
	}
	
	public List<Map<String,String>> selectMasterMpStCmpyStatsListICOMCOD2(Map<String,Object> param) {
		return sqlSessionTemplate.selectList("master.mpst.selectMasterMpStCmpyStatsListICOMCOD2", param);
	}
	
	public List<Map<String,String>> selectMasterMpStCmpyStatsListSumTeam(Map<String,Object> param) {
		return sqlSessionTemplate.selectList("master.mpst.selectMasterMpStCmpyStatsListSumTeam", param);
	}
	public List<Map<String,String>> selectMasterMpStCmpyStatsListSumGroup(Map<String,Object> param) {
		return sqlSessionTemplate.selectList("master.mpst.selectMasterMpStCmpyStatsListSumGroup", param);
	}
	
	// 협력사 리스트 조회 
	public List<Map<String,String>> selectMasterMpStCmpyStatsListBiz(Map<String,Object> param) {
		return sqlSessionTemplate.selectList("master.mpst.selectMasterMpStCmpyStatsListBiz", param);
	}
	
	public List<Map<String,String>> selectMasterMpStCmpyStatsListBizTypeSum(Map<String,Object> param) {
		return sqlSessionTemplate.selectList("master.mpst.selectMasterMpStCmpyStatsListBizTypeSum", param);
	}
	
	public List<Map<String,String>> selectMasterMpStCmpyStatsListBizCreditStatusSum(Map<String,Object> param) {
		return sqlSessionTemplate.selectList("master.mpst.selectMasterMpStCmpyStatsListBizCreditStatusSum", param);
	}
	
	public List<Map<String,String>> selectMasterMpStCmpyStatsListBizM110(Map<String,Object> param) {
		return sqlSessionTemplate.selectList("master.mpst.selectMasterMpStCmpyStatsListBizM110", param);
	}
	public List<Map<String,String>> selectMasterMpStCmpyStatsListBizCMpy(Map<String,Object> param) {
		return sqlSessionTemplate.selectList("master.mpst.selectMasterMpStCmpyStatsListBizCMpy", param);
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	public List<Map<String,String>> selectList2(Map<String,Object> param) {
		return sqlSessionTemplate.selectList("master.mpst.selectMasterMpStSupplierStatsList", param);
	}

}
