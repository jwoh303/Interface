package com.koreab2b.mro.master.mprq.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.master.mprq.dao.MasterMpRqBulkQuotationProceListDao;

@Service("MasterMpRqBulkQuotationProceListService")
public class MasterMpRqBulkQuotationProceListServiceImpl implements MasterMpRqBulkQuotationProceListService {
	
	@Autowired
	private MasterMpRqBulkQuotationProceListDao MasterMpRqBulkQuotationDao;

	// 리스트 조회
	public List<Map<String,String>> getList(Map<String,Object> param) {
		return MasterMpRqBulkQuotationDao.selectList(param);
	}	
		
	// 동일 단가 적용
	@Override
	public String setSamePrice(Map<String, Object> param) {
		return MasterMpRqBulkQuotationDao.updatePrice(param);
	}
	
	// DM 팝업 조회
	@Override
	public List<Map<String, String>> getDmPop(Map<String, String> param) {
		return MasterMpRqBulkQuotationDao.selectDmList(param);
	}

	// 엑셀 다운로드
	@Override
	public List<Map<String, String>> getExcelList(Map<String, Object> param) {
		return MasterMpRqBulkQuotationDao.selectExcelList(param);
	}
	
	// 협력사 목록
	@Override
	public List<Map<String, String>> getAgentList(Map<String, Object> param) {
		return MasterMpRqBulkQuotationDao.selectAgentList(param);
	}	
}
