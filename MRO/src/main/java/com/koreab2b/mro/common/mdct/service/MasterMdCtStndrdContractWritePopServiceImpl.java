package com.koreab2b.mro.common.mdct.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.common.mdct.dao.MasterMdCtStndrdContractWritePopDao;

@Service("masterMdCtStndrdContractWritePopService")
public class MasterMdCtStndrdContractWritePopServiceImpl implements MasterMdCtStndrdContractWritePopService {
	
	@Autowired
	private MasterMdCtStndrdContractWritePopDao masterMdCtStndrdContractWritePopDao;

	// 조회
	public Map<String,String> getList(Map<String,String> formData) {
		return masterMdCtStndrdContractWritePopDao.selectList(formData);
	}	
	
	// 저장
	public String updateSelectedData(Map<String,String> formData) {
		return masterMdCtStndrdContractWritePopDao.updateSelectedData(formData);
	}
		
}
