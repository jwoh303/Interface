package com.koreab2b.mro.buyer.mpso.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.buyer.mpso.dao.BuyerMpSoNewDoctorBatchRegDao;

@Service("buyerMpSoNewDoctorBatchRegService")
public class BuyerMpSoNewDoctorBatchRegServiceImpl implements BuyerMpSoNewDoctorBatchRegService {

	@Autowired
	private BuyerMpSoNewDoctorBatchRegDao buyerMpSoNewDoctorBatchRegDao;

	@Override
	public List<Map<String, Object>> getList(Map<String, String> formData) {
		return buyerMpSoNewDoctorBatchRegDao.selectList(formData);
	}

	@Override
	public Map<String, String> setNewDoctorCreatePo(List<Map<String, String>> pList) {
		return buyerMpSoNewDoctorBatchRegDao.setNewDoctorCreatePo(pList);
	}
}
