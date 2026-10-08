package com.koreab2b.mro.master.mprq.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.master.mprq.dao.MasterMpRqBulkQuotationItemListDao;

@Service("MasterMpRqBulkQuotationItemListService")
public class MasterMpRqBulkQuotationItemListServiceImpl implements MasterMpRqBulkQuotationItemListService {
	
	@Autowired
	private MasterMpRqBulkQuotationItemListDao MasterMpRqBulkQuotationDao;

	// 프로젝트 선택 팝업
	@Override
	public List<Map<String,String>> getProject(Map<String, Object> param) {
		return MasterMpRqBulkQuotationDao.selectProject(param);
	}
	
	// 리스트 조회
	public List<Map<String,String>> getList(Map<String,Object> param) {
		return MasterMpRqBulkQuotationDao.selectList(param);
	}	
	
	//선택삭제
	@Transactional
	public String deleteData(Map<String,Object>  param) {
		return MasterMpRqBulkQuotationDao.deleteData(param);
	}
}
