package com.koreab2b.mro.master.mpst.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.master.mpst.dao.MasterMpStCmpyStatsDao;

@Service("masterMpStCmpyStatsService")
public class MasterMpStCmpyStatsServiceImpl implements MasterMpStCmpyStatsService {
	
	@Autowired
	private MasterMpStCmpyStatsDao masterMpStCmpyStatsDao;

	// 고객사 리스트 조회
	public List<Map<String,String>> selectList(Map<String,Object> param) {
		return masterMpStCmpyStatsDao.selectList(param);
	}	
	public List<Map<String,String>> selectMasterMpStCmpyStatsListBNTBUYERGROUP(Map<String,Object> param) {
		return masterMpStCmpyStatsDao.selectMasterMpStCmpyStatsListBNTBUYERGROUP(param);
	}	
	public List<Map<String,String>> selectMasterMpStCmpyStatsListICOMCOD2(Map<String,Object> param) {
		return masterMpStCmpyStatsDao.selectMasterMpStCmpyStatsListICOMCOD2(param);
	}	
	public List<Map<String,String>> selectMasterMpStCmpyStatsListSumGroup(Map<String,Object> param) {
		return masterMpStCmpyStatsDao.selectMasterMpStCmpyStatsListSumGroup(param);
	}	
	public List<Map<String,String>> selectMasterMpStCmpyStatsListSumTeam(Map<String,Object> param) {
		return masterMpStCmpyStatsDao.selectMasterMpStCmpyStatsListSumTeam(param);
	}	
	
	
	// 협력사 리스트 조회
	public List<Map<String,String>> selectMasterMpStCmpyStatsListBiz(Map<String,Object> param){
		return masterMpStCmpyStatsDao.selectMasterMpStCmpyStatsListBiz(param);
	}	
	public List<Map<String,String>> selectMasterMpStCmpyStatsListBizTypeSum(Map<String,Object> param){
		return masterMpStCmpyStatsDao.selectMasterMpStCmpyStatsListBizTypeSum(param);
	}	
	public List<Map<String,String>> selectMasterMpStCmpyStatsListBizCreditStatusSum(Map<String,Object> param){
		return masterMpStCmpyStatsDao.selectMasterMpStCmpyStatsListBizCreditStatusSum(param);
	}	
	public List<Map<String,String>> selectMasterMpStCmpyStatsListBizM110(Map<String,Object> param){
		return masterMpStCmpyStatsDao.selectMasterMpStCmpyStatsListBizM110(param);
	}	
	public List<Map<String,String>> selectMasterMpStCmpyStatsListBizCMpy(Map<String,Object> param){
		return masterMpStCmpyStatsDao.selectMasterMpStCmpyStatsListBizCMpy(param);
	}	
	
	
	
	
	
	
	
	
	
	
	public List<Map<String,String>> getList2(Map<String,Object> param) {
		return masterMpStCmpyStatsDao.selectList2(param);
	}	
}
