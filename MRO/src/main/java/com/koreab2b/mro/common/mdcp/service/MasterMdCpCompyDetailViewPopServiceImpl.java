package com.koreab2b.mro.common.mdcp.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.common.mdcp.dao.MasterMdCpCompyDetailViewPopDao;

@Service("masterMdCpCompyDetailViewPopService")
public class MasterMdCpCompyDetailViewPopServiceImpl implements MasterMdCpCompyDetailViewPopService {
	@Autowired
	private MasterMdCpCompyDetailViewPopDao masterMdCpCompyDetailViewPopDao;

	// 조회
	public List<Map<String,String>> getUserList(Map<String,String> formData) {
		return masterMdCpCompyDetailViewPopDao.selectUserList(formData);
	}	
	
	// 조회
	public List<Map<String,String>> getCompyList(Map<String,String> formData) {
		return masterMdCpCompyDetailViewPopDao.selectCompyList(formData);
	}
}
