package com.koreab2b.mro.common.mprq.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.common.mprq.dao.MasterMpRqBulkQuotationAddAgentExcelPopDao;


@Service("MasterMpRqBulkQuotationAddAgentExcelPopService")
public class MasterMpRqBulkQuotationAddAgentExcelPopServiceImpl implements MasterMpRqBulkQuotationAddAgentExcelPopService {
	
	@Autowired
	private MasterMpRqBulkQuotationAddAgentExcelPopDao MasterMpRqBulkQuotationAddAgentExcelDao;

	// 엑셀 업로드(고객사용)
	public String batchMasterMpRqBulkQuotationAddAgentExcel(Map<String, String> param,List<Object> gridData){
		return MasterMpRqBulkQuotationAddAgentExcelDao.batchdata(param , gridData);
	}
	// 업로드 결과 확인
	@Override
	public List<Map<String, String>> checkMasterMpRqBulkQuotationAddAgentExcel(Map<String, String> param) {
		return  MasterMpRqBulkQuotationAddAgentExcelDao.selectdata(param);
	}
	@Override
	public String saveMasterMpRqBulkQuotationAddAgentExcel(Map<String, String> param) {
		return  MasterMpRqBulkQuotationAddAgentExcelDao.savedata(param);
	}

}
