package com.koreab2b.mro.master.cmcl.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.master.cmcl.dao.MasterCmClTeamBuyerSalesStatementDao;

@Service("masterCmClTeamBuyerSalesStatementService")
public class MasterCmClTeamBuyerSalesStatementServiceImpl implements MasterCmClTeamBuyerSalesStatementService {
	
	@Autowired
	private MasterCmClTeamBuyerSalesStatementDao masterCmClTeamBuyerSalesStatementDao;

	// 리스트 조회
	public List<Map<String,String>> getList(Map<String,Object> param) {
		return masterCmClTeamBuyerSalesStatementDao.selectList(param);
	}	

	// 저장
//	@Transactional
//	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData) {
//		return masterCmClTeamBuyerSalesStatementDao.updateSelectedData(formData, gridData);
//	}	

	// 삭제
//	@Transactional
//	public String delSelectedData(Map<String,String>  formData, List<Object> gridData) {
//		return masterCmClTeamBuyerSalesStatementDao.deleteSelectedData(formData, gridData);
//	}
}
