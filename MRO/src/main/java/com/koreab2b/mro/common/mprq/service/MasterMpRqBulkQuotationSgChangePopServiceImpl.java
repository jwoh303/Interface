package com.koreab2b.mro.common.mprq.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.common.mprq.dao.MasterMpRqBulkQuotationSgChangePopDao;


@Service("MasterMpRqBulkQuotationSgChangePopService")
public class MasterMpRqBulkQuotationSgChangePopServiceImpl implements MasterMpRqBulkQuotationSgChangePopService {
	
	@Autowired
	private MasterMpRqBulkQuotationSgChangePopDao MasterMpRqBulkQuotationSgChangeDao;

	// 엑셀 업로드(고객사용)
	public String batchMasterMpRqBulkQuotationSgChange(Map<String, String> param,List<Object> gridData){
		return MasterMpRqBulkQuotationSgChangeDao.batchdata(param , gridData);
	}
	// 업로드 결과 확인
	@Override
	public List<Map<String, String>> checkMasterMpRqBulkQuotationSgChange(Map<String, String> param) {
		return  MasterMpRqBulkQuotationSgChangeDao.selectdata(param);
	}
	@Override
	public String saveMasterMpRqBulkQuotationSgChange(Map<String, String> param) {
		return  MasterMpRqBulkQuotationSgChangeDao.savedata(param);
	}

}
