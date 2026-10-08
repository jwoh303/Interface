package com.koreab2b.mro.master.mdpp.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.master.mdpp.dao.MasterMdPpPropListDao;

@Service("masterMdPpPropListService")
public class MasterMdPpPropListServiceImpl implements MasterMdPpPropListService {
	
	@Autowired
	private MasterMdPpPropListDao masterMdPpPropListDao;

	// 리스트 조회
	public List<Map<String,String>> getList(Map<String,Object> param) {
		return masterMdPpPropListDao.selectList(param);
	}
	
	// 상세 팝업 조회
	public List<Map<String,String>> getMasterMdPpPropDetailPop(Map<String,Object> formData) {
		return masterMdPpPropListDao.getMasterMdPpPropDetailPop(formData);
	}

	// 제안평가 팝업 조회
	public List<Map<String,String>> getMasterMdPpPropArpsPop(Map<String,Object> formData) {
		return masterMdPpPropListDao.getMasterMdPpPropArpsPop(formData);
	}
	
	// 평가
	public String saveMasterMdPpPropArps(Map<String,String> pMap) {
		return masterMdPpPropListDao.saveMasterMdPpPropArps(pMap);
	}
	
	// 불채택
	public String rejectMasterMdPpPropArps(Map<String,String> pMap) {
		return masterMdPpPropListDao.rejectMasterMdPpPropArps(pMap);
	}
	
	// 불채택 사유 팝업 조회
	public List<Map<String,String>> getMasterMdPpPropRejectPop(Map<String,Object> formData) {
		return masterMdPpPropListDao.getMasterMdPpPropRejectPop(formData);
	}
}
