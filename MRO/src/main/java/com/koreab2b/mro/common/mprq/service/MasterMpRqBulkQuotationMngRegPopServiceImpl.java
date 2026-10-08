package com.koreab2b.mro.common.mprq.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.common.mprq.dao.MasterMpRqBulkQuotationMngRegPopDao;


@Service("MasterMpRqBulkQuotationMngRegPopService")
public class MasterMpRqBulkQuotationMngRegPopServiceImpl implements MasterMpRqBulkQuotationMngRegPopService {
	
	@Autowired
	private MasterMpRqBulkQuotationMngRegPopDao MasterMpRqBulkQuotationMngRegDao;

	// 엑셀 업로드(고객사용)
	public String batchMasterMpRqBulkQuotationMngReg(Map<String, String> param,List<Object> gridData){
		return MasterMpRqBulkQuotationMngRegDao.batchdata(param , gridData);
	}
	// 업로드 결과 확인
	@Override
	public List<Map<String, String>> checkMasterMpRqBulkQuotationMngReg(Map<String, String> param) {
		return  MasterMpRqBulkQuotationMngRegDao.selectdata(param);
	}
	@Override
	public String saveMasterMpRqBulkQuotationMngReg(Map<String, String> param) {
		return  MasterMpRqBulkQuotationMngRegDao.savedata(param);
	}

}
