package com.koreab2b.mro.common.mdcp.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.common.mdcp.dao.MasterMdCpUserDetailViewPopDao;

@Service("masterMdCpUserDetailViewPopService")
public class MasterMdCpUserDetailViewPopServiceImpl implements MasterMdCpUserDetailViewPopService {
	
	@Autowired
	private MasterMdCpUserDetailViewPopDao masterMdCpUserDetailViewPopDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,String> formData) {
		return masterMdCpUserDetailViewPopDao.selectList(formData);
	}	
	
	// 조회
		public List<Map<String,String>> getApprovedList(Map<String,String> formData) {
			return masterMdCpUserDetailViewPopDao.selectApprovedList(formData);
		}
			
		// 조회
		public List<Map<String,String>> getReferList(Map<String,String> formData) {
			return masterMdCpUserDetailViewPopDao.selectReferList(formData);
		}
		
		// 저장
		public String updateSelectedData(Map<String,String> formData) {
			return masterMdCpUserDetailViewPopDao.updateSelectedData(formData);
		}

}
