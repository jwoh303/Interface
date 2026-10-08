package com.koreab2b.mro.common.mdct.service;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.common.mdct.dao.MasterMdCtStndrdContractDetailPopDao;

@Service("masterMdCtStndrdContractDetailPopService")
public class MasterMdCtStndrdContractDetailPopServiceImpl implements MasterMdCtStndrdContractDetailPopService {
	
	@Autowired
	private MasterMdCtStndrdContractDetailPopDao masterMdCtStndrdContractDetailPopDao;

	// 조회
	public Map<String,String> getList(Map<String,String> formData) {
		return masterMdCtStndrdContractDetailPopDao.selectList(formData);
	}	
	
	// 삭제
	public String deleteSelectedData(Map<String,String> formData) {
		return masterMdCtStndrdContractDetailPopDao.deleteSelectedData(formData);
	}

}
