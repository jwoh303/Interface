package com.koreab2b.mro.common.coco.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.common.coco.dao.CommonCoCoApprovalAppointPopDao;

@Service("commonCoCoApprovalAppointPopService")
public class CommonCoCoApprovalAppointPopServiceImpl implements CommonCoCoApprovalAppointPopService {
	@Autowired
	private CommonCoCoApprovalAppointPopDao commonCoCoApprovalAppointPopDao; 

	public List<Map<String, String>> getApprovalMultiPathList(Map<String, String> pMap) {
		return commonCoCoApprovalAppointPopDao.getApprovalMultiPathList(pMap);
	}
	
	public String setCommonCoCoApprovalInfo(Map<String,String> pMap) {
		return commonCoCoApprovalAppointPopDao.setCommonCoCoApprovalInfo(pMap);
	}
	
	public void updateAppPathDefaultApproval(Map<String,String> pMap) {
		commonCoCoApprovalAppointPopDao.updateAppPathDefaultApproval(pMap);
	}
	
	public void insertAppPathCreate(Map<String,String> pMap) {
		commonCoCoApprovalAppointPopDao.insertAppPathCreate(pMap);
	}
	
	public void deleteAppPathRemove_appt(Map<String,String> pMap) {
		commonCoCoApprovalAppointPopDao.deleteAppPathRemove_appt(pMap);
	}
	
	public void deleteAppPathRemove_apse(Map<String,String> pMap) {
		commonCoCoApprovalAppointPopDao.deleteAppPathRemove_apse(pMap);
	}
	
	public List<Map<String,String>> getApprovalMultiPathUserList(Map<String,String> pMap) {
		return commonCoCoApprovalAppointPopDao.getApprovalMultiPathUserList(pMap);
	}
	
	public List<Map<String,String>> getApprovalMultiPathUserNm_arry(Map<String,String> pMap) {
		return commonCoCoApprovalAppointPopDao.getApprovalMultiPathUserNm_arry(pMap);
	}
	
	public void deleteAppPathDetailRemove_all(Map<String,String> pMap) {
		commonCoCoApprovalAppointPopDao.deleteAppPathDetailRemove_all(pMap);
	}
	
	public void insertAppPathDetailCreate(Map<String,String> pMap) {
		commonCoCoApprovalAppointPopDao.insertAppPathDetailCreate(pMap);
	}
	
	public String delCommonCoCoApprovalInfo(Map<String,String> pMap) {
		return commonCoCoApprovalAppointPopDao.delCommonCoCoApprovalInfo(pMap);
	}
	
	public String regApproverInfoList(Map<String,String> pMap) {
		return commonCoCoApprovalAppointPopDao.regApproverInfoList(pMap);
	}
}
