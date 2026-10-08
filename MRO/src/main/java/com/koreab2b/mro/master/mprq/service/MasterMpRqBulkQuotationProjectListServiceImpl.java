package com.koreab2b.mro.master.mprq.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.master.mprq.dao.MasterMpRqBulkQuotationProjectListDao;

@Service("MasterMpRqBulkQuotationProjectListService")
public class MasterMpRqBulkQuotationProjectListServiceImpl implements MasterMpRqBulkQuotationProjectListService {
	
	@Autowired
	private MasterMpRqBulkQuotationProjectListDao MasterMpRqBulkQuotationDao;

	// 리스트 조회
	public List<Map<String,String>> getList(Map<String,Object> param) {
		return MasterMpRqBulkQuotationDao.selectList(param);
	}	
	@Transactional
	public String updateData(Map<String,Object>  param) {
		return MasterMpRqBulkQuotationDao.updateData(param);
	}	
}
