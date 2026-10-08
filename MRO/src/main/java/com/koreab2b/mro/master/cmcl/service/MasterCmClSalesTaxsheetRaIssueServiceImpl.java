package com.koreab2b.mro.master.cmcl.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.master.cmcl.dao.MasterCmClSalesTaxsheetRaIssueDao;

@Service("masterCmClSalesTaxRaReqSumService")
public class MasterCmClSalesTaxsheetRaIssueServiceImpl implements MasterCmClSalesTaxsheetRaIssueService {

	@Autowired
	private MasterCmClSalesTaxsheetRaIssueDao dao;
	
	@Override
	public List<Map<String, String>> getList(Map<String, Object> pParam) {
		return dao.selectList(pParam);
	}

	@Override
	public List<Map<String, String>> SendARMasterCmClSalesTaxsheetRaIssueFormat(Map<String, Object> pMap) {
		return dao.getRaIssueFormat(pMap);
	}

	@Override
	public String delSelectedData(Map<String, String> pFormData, List<Object> pGridData) {
		return dao.delSelectedData(pFormData, pGridData);
	}
}
