package com.koreab2b.mro.common.mdcp.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.common.mdcp.dao.MasterMdCpAgntcmpyInfoAlterPopDao;

@Service("masterMdCpAgntcmpyInfoAlterPopService")
public class MasterMdCpAgntcmpyInfoAlterPopServiceImpl implements MasterMdCpAgntcmpyInfoAlterPopService {
	
	@Autowired
	private MasterMdCpAgntcmpyInfoAlterPopDao masterMdCpAgntcmpyInfoAlterPopDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,String> formData) {
		return masterMdCpAgntcmpyInfoAlterPopDao.selectList(formData);
	}	

	// 납품가능지역
	public List<Map<String,String>> getDelyAreaList(Map<String,String> formData) {
		return masterMdCpAgntcmpyInfoAlterPopDao.selectDelyAreaList(formData);
	}	
	
	// 저장
	public String updateSelectedData(Map<String,String> formData) {
		return masterMdCpAgntcmpyInfoAlterPopDao.updateSelectedData(formData);
	}
	
	// 저장
	public String updateSelectedDataAvl(Map<String,String> formData) {
		return masterMdCpAgntcmpyInfoAlterPopDao.updateSelectedDataAvl(formData);
	}
	
	// 저장
	public String deleteSelectedData(Map<String,String> formData) {
		return masterMdCpAgntcmpyInfoAlterPopDao.deleteSelectedData(formData);
	}
	
	//cck_temp에서 협력사ID로 암호화된 데이터 가져오기
	public String getEncryptText(Map<String,String> formData) {
		return masterMdCpAgntcmpyInfoAlterPopDao.getEncryptText(formData);
	}
}
