package com.koreab2b.mro.common.mprq.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.common.mprq.dao.MasterMpRqBulkQuotationItemRegPopDao;


@Service("MasterMpRqBulkQuotationItemRegPopService")
public class MasterMpRqBulkQuotationItemRegPopServiceImpl implements MasterMpRqBulkQuotationItemRegPopService {
	
	@Autowired
	private MasterMpRqBulkQuotationItemRegPopDao MasterMpRqBulkQuotationItemRegDao;

	// 엑셀 업로드
	public String batchMasterMpRqBulkQuotationItemReg(Map<String, String> param,List<Object> gridData){
		return MasterMpRqBulkQuotationItemRegDao.batchdata(param , gridData);
	}
	// 업로드 결과 확인
	@Override
	public List<Map<String, String>> checkMasterMpRqBulkQuotationItemReg(Map<String, String> param) {
		return  MasterMpRqBulkQuotationItemRegDao.selectdata(param);
	}
	@Override
	public String saveMasterMpRqBulkQuotationItemReg(Map<String, String> param) {
		return  MasterMpRqBulkQuotationItemRegDao.savedata(param);
	}

}
