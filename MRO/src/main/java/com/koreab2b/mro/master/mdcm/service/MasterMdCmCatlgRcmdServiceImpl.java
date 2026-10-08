package com.koreab2b.mro.master.mdcm.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.master.mdcm.dao.MasterMdCmCatlgRcmdDao;

@Service("masterMdCmCatlgRcmdService")
public class MasterMdCmCatlgRcmdServiceImpl implements MasterMdCmCatlgRcmdService {
	
	@Autowired
	private MasterMdCmCatlgRcmdDao masterMdCmCatlgRcmdDao;

	// 업로드 후 조회
	public List<Map<String,String>> getUploadList(Map<String,Object> param) {
		return masterMdCmCatlgRcmdDao.selectUploadList(param);
	}	

	// 리스트 조회
	public List<Map<String,String>> getList(Map<String,Object> param) {
		return masterMdCmCatlgRcmdDao.selectList(param);
	}
	
	// BNTRXL 저장
	@Transactional
	public String updateUploadData(Map<String,String>  formData, List<Object> gridData) {
		return masterMdCmCatlgRcmdDao.updateUploadData(formData, gridData);
	}
	
	// 추천
	@Transactional
	public String updateData(Map<String,String>  formData, List<Object> gridData) {
		return masterMdCmCatlgRcmdDao.updateData(formData, gridData);
	}
}
