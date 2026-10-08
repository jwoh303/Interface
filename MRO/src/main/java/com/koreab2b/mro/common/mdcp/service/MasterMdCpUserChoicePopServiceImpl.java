package com.koreab2b.mro.common.mdcp.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.common.mdcp.dao.MasterMdCpUserChoicePopDao;

@Service("masterMdCpUserChoicePopService")
public class MasterMdCpUserChoicePopServiceImpl implements MasterMdCpUserChoicePopService {
	
	@Autowired
	private MasterMdCpUserChoicePopDao masterMdCpUserChoicePopDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,String> formData) {
		return masterMdCpUserChoicePopDao.selectList(formData);
	}	

}
