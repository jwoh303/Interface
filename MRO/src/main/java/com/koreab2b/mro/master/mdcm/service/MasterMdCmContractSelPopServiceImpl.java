package com.koreab2b.mro.master.mdcm.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.master.mdcm.dao.MasterMdCmContractSelPopDao;

@Service("masterMdCmContractSelPopService")
public class MasterMdCmContractSelPopServiceImpl implements MasterMdCmContractSelPopService {
	@Autowired
	private MasterMdCmContractSelPopDao masterMdCmContractSelPopDao;

	// 조회
	public List<Map<String,String>> getMasterMdCmContractSelPop(Map<String,String> formData) {
		return masterMdCmContractSelPopDao.getMasterMdCmContractSelPop(formData);
	}
}
