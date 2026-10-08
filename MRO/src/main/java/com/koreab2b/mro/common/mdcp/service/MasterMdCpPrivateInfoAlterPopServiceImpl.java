package com.koreab2b.mro.common.mdcp.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.common.mdcp.dao.MasterMdCpPrivateInfoAlterPopDao;

@Service("masterMdCpPrivateInfoAlterPopService")
public class MasterMdCpPrivateInfoAlterPopServiceImpl implements MasterMdCpPrivateInfoAlterPopService {
	
	@Autowired
	private MasterMdCpPrivateInfoAlterPopDao masterMdCpPrivateInfoAlterPopDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,String> formData) {
		return masterMdCpPrivateInfoAlterPopDao.selectList(formData);
	}	
	

}
