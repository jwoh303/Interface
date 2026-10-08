package com.koreab2b.mro.common.mdct.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.common.mdct.dao.MasterMdCtStndrdContractPopDao;

@Service("masterMdCtStndrdContractPopService")
public class MasterMdCtStndrdContractPopServiceImpl implements MasterMdCtStndrdContractPopService {
	
	@Autowired
	private MasterMdCtStndrdContractPopDao masterMdCtStndrdContractPopDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,Object> formData) {
		return masterMdCtStndrdContractPopDao.selectList(formData);
	}	
}
