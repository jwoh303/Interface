package com.koreab2b.mro.common.mdcd.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.common.mdcd.dao.MasterMdCdAgentCardInfoPopDao;

@Service("masterMdCdAgentCardInfoPopService")
public class MasterMdCdAgentCardInfoPopServiceImpl implements MasterMdCdAgentCardInfoPopService {
	
	@Autowired
	private MasterMdCdAgentCardInfoPopDao masterMdCdAgentCardInfoPopDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,String> formData) {
		return masterMdCdAgentCardInfoPopDao.selectList(formData);
	}
	
	// 거래금액 조회
	public List<Map<String,String>> getVisitList(Map<String, Object> formData) {
		return masterMdCdAgentCardInfoPopDao.selectVisitList(formData);
	}
	
	// 삭제
	@Transactional
	public String delSelectedData(Map<String,String>  formData, List<Object> gridData) {
		return masterMdCdAgentCardInfoPopDao.deleteSelectedData(formData, gridData);
	}
}
