package com.koreab2b.mro.buyer.mprq.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.buyer.mprq.dao.BuyerMpRqUnitpriceAgrmntNegoReqDao;

@Service("buyerMpRqUnitpriceAgrmntNegoReqService")
public class BuyerMpRqUnitpriceAgrmntNegoReqServiceImpl implements BuyerMpRqUnitpriceAgrmntNegoReqService {
	
	@Autowired
	private BuyerMpRqUnitpriceAgrmntNegoReqDao buyerMpRqUnitpriceAgrmntNegoReqDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,String> formData) {
		return buyerMpRqUnitpriceAgrmntNegoReqDao.selectList(formData);
	}	
	
	// 저장
	public String updateSelectedData(Map<String,String> formData, List<Object> gridData) {
		return buyerMpRqUnitpriceAgrmntNegoReqDao.updateSelectedData(formData, gridData);
	}
	// 취소
	public String updateSelectedCancleData(Map<String,String> formData, List<Object> gridData) {
		return buyerMpRqUnitpriceAgrmntNegoReqDao.updateSelectedCancleData(formData, gridData);
	}
	// 취소_v2
	public String updateSelectedCancleData_v2(Map<String,String> formData, List<Object> gridData) {
		return buyerMpRqUnitpriceAgrmntNegoReqDao.updateSelectedCancleData_v2(formData, gridData);
	}
	// 저장
	public Map<String,String> saveBuyerMpRqUnitpriceAgrmnt(Map<String,String> formData, List<Object> gridData) {
		return buyerMpRqUnitpriceAgrmntNegoReqDao.saveBuyerMpRqUnitpriceAgrmnt(formData, gridData);
	}	
	// 견적종료
	public Map<String,String> saveBuyerMpRqCloseRemark(Map<String,String> formData, List<Object> gridData) {
		return buyerMpRqUnitpriceAgrmntNegoReqDao.saveBuyerMpRqCloseRemark(formData, gridData);
	}	
	// 저장
	public Map<String,String> saveBuyerMpRqUnitpriceAgrmntNonPass(Map<String,String> formData, List<Object> gridData) {
		return buyerMpRqUnitpriceAgrmntNegoReqDao.saveBuyerMpRqUnitpriceAgrmntNonPass(formData, gridData);
	}
	// 결재상신
	public Map<String,String> getAppSendList(Map<String,String> formData, List<Object> gridData) {
		return buyerMpRqUnitpriceAgrmntNegoReqDao.getAppSendList(formData, gridData);
	}
	// 단가합의 비고	
	public Map<String, String> saveBuyerMpRqUnitpriceAgrmntNegoReqPop(Map<String, String> formData) {
		return buyerMpRqUnitpriceAgrmntNegoReqDao.saveBuyerMpRqUnitpriceAgrmntNegoReqPop(formData);
	}

	// 견적합의대상 _v2
	public List<Map<String, String>> getList_v2(Map<String, Object> formData) {
		return buyerMpRqUnitpriceAgrmntNegoReqDao.selectList_v2(formData);
	}

	// 저장(네고요청)_v2
	public String updateSelectedData_v2(Map<String, String> _pMap, List<Object> _list) {
		return buyerMpRqUnitpriceAgrmntNegoReqDao.updateSelectedData_v2(_pMap, _list);
	}

}
