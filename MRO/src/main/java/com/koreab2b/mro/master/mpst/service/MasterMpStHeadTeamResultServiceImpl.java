package com.koreab2b.mro.master.mpst.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.master.mpst.dao.MasterMpStHeadTeamResultDao;

@Service("masterMpStHeadTeamResultService")
public class MasterMpStHeadTeamResultServiceImpl implements MasterMpStHeadTeamResultService {
	
	@Autowired
	private MasterMpStHeadTeamResultDao masterMpStHeadTeamResultDao;

	// 리스트 조회
	public List<Map<String,String>> getList(Map<String,Object> param) {
		return masterMpStHeadTeamResultDao.selectList(param);
	}
	
	// 차트 조회
	public List<Map<String,String>> getList1(Map<String,Object> param) {
		return masterMpStHeadTeamResultDao.selectList1(param);
	}

	// 저장
	@Transactional
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData) {
		return masterMpStHeadTeamResultDao.updateSelectedData(formData, gridData);
	}	

	// 삭제
	@Transactional
	public String delSelectedData(Map<String,String>  formData, List<Object> gridData) {
		return masterMpStHeadTeamResultDao.deleteSelectedData(formData, gridData);
	}
}
