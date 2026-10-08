package com.koreab2b.mro.common.mprq.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.common.mprq.dao.MasterMpRqBulkQuotationItemInfoRegPopDao;


@Service("MasterMpRqBulkQuotationItemInfoRegPopService")
public class MasterMpRqBulkQuotationItemInfoRegPopServiceImpl implements MasterMpRqBulkQuotationItemInfoRegPopService {
	
	@Autowired
	private MasterMpRqBulkQuotationItemInfoRegPopDao MasterMpRqBulkQuotationItemInfoRegDao;

	// 엑셀 업로드(고객사용)
	public String batchMasterMpRqBulkQuotationItemInfoReg(Map<String, String> param,List<Object> gridData){
		return MasterMpRqBulkQuotationItemInfoRegDao.batchdata(param , gridData);
	}
	// 업로드 결과 확인
	@Override
	public List<Map<String, String>> checkMasterMpRqBulkQuotationItemInfoReg(Map<String, String> param) {
		return  MasterMpRqBulkQuotationItemInfoRegDao.selectdata(param);
	}
	@Override
	public String saveMasterMpRqBulkQuotationItemInfoReg(Map<String, String> param) {
		return  MasterMpRqBulkQuotationItemInfoRegDao.savedata(param);
	}

}
