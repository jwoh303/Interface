package com.koreab2b.mro.master.mpst.dao;

import java.util.List;
import java.util.Map;

public interface MasterMpStCmpyStatsDao {
	
	// 고객사 리스트 조회
	public List<Map<String,String>> selectList(Map<String,Object> param);
	public List<Map<String,String>> selectMasterMpStCmpyStatsListBNTBUYERGROUP(Map<String,Object> param);
	public List<Map<String,String>> selectMasterMpStCmpyStatsListICOMCOD2(Map<String,Object> param);
	public List<Map<String,String>> selectMasterMpStCmpyStatsListSumGroup(Map<String,Object> param);
	public List<Map<String,String>> selectMasterMpStCmpyStatsListSumTeam(Map<String,Object> param);
	
	
	// 협력사 리스트 조회
	public List<Map<String,String>> selectMasterMpStCmpyStatsListBiz(Map<String,Object> param);
	public List<Map<String,String>> selectMasterMpStCmpyStatsListBizTypeSum(Map<String,Object> param);
	public List<Map<String,String>> selectMasterMpStCmpyStatsListBizCreditStatusSum(Map<String,Object> param);
	public List<Map<String,String>> selectMasterMpStCmpyStatsListBizM110(Map<String,Object> param);
	public List<Map<String,String>> selectMasterMpStCmpyStatsListBizCMpy(Map<String,Object> param);
	
	
	public List<Map<String,String>> selectList2(Map<String,Object> param);

}
