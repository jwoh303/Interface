package com.koreab2b.mro.master.mprq.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.master.mprq.dao.MasterMpRqQuotationBulkHistroyDao;

@Service("MasterMpRqQuotationBulkHistroyService")
public class MasterMpRqQuotationBulkHistroyServiceImpl implements MasterMpRqQuotationBulkHistroyService {
	
	@Autowired
	private MasterMpRqQuotationBulkHistroyDao MasterMpRqQuotationBulkHistroyDao;

	// 리스트 조회
	public List<Map<String,String>> getList(Map<String,Object> param) {
		return MasterMpRqQuotationBulkHistroyDao.selectList(param);
	}	
	@Transactional
	public String insertSelectedData(Map<String,String>  formData, List<Object> gridData) {
		return MasterMpRqQuotationBulkHistroyDao.insertSelectedData(formData, gridData);
	}	
}
