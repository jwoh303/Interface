package com.koreab2b.mro.buyer.mprq.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.util.MultiValueMap;

import com.koreab2b.mro.buyer.mprq.dao.BuyerMpRqQuotaProceStateDao;

@Service("buyerMpRqQuotaProceStateService")
public class BuyerMpRqQuotaProceStateServiceImpl implements BuyerMpRqQuotaProceStateService {
	
	@Autowired
	private BuyerMpRqQuotaProceStateDao buyerMpRqQuotaProceStateDao;

	public List<Map<String,String>> getList(Map<String,String> formData) {
		return buyerMpRqQuotaProceStateDao.selectList(formData);
	}	
	
	public String updateSelectedData(Map<String,String> formData, List<Object> gridData) {
		return buyerMpRqQuotaProceStateDao.updateSelectedData(formData, gridData);
	}
	
	public String deleteSelectedData(Map<String,String> formData, List<Object> gridData) {
		return buyerMpRqQuotaProceStateDao.deleteSelectedData(formData, gridData);
	}
	
	//엑셀 상세조회
	public List<Map<String,String>> getDetailList(Map<String,String> formData) {
		return buyerMpRqQuotaProceStateDao.selectDetailList(formData);
	}

	@Override
	public List<Map<String, String>> getList_v2(Map<String, Object> pMap) {
		return buyerMpRqQuotaProceStateDao.selectList_v2(pMap);
	}

	@Override
	public String updateSelectedData_v2(Map<String, String> pMap) {
		return buyerMpRqQuotaProceStateDao.updateSelectedData_v2(pMap);
	}

	@Override
	public List<Map<String, String>> getList_tab2_v2(Map<String, Object> pMap) {
		return buyerMpRqQuotaProceStateDao.selectList_tab2_v2(pMap);
	}
}
