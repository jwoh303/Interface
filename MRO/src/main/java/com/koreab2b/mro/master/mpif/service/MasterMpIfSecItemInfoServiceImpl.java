package com.koreab2b.mro.master.mpif.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.master.mpif.dao.MasterMpIfSecItemInfoDao;

@Service("masterMpIfSecItemInfoService")
public class MasterMpIfSecItemInfoServiceImpl implements MasterMpIfSecItemInfoService {
	
	@Autowired
	private MasterMpIfSecItemInfoDao masterMpIfSecItemInfoDao;

	// 리스트 조회
	public List<Map<String,String>> getList(Map<String,Object> param) {
		return masterMpIfSecItemInfoDao.selectList(param);
	}

	@Override
	public String deleteSecItemInfo(Map<String, String> pFormData, List<Object> pGridData) {
		return masterMpIfSecItemInfoDao.deleteItemInfo(pFormData, pGridData);
	}

	@Override
	public String updateSecItemInfo(Map<String, String> pFormData, List<Object> pGridData) {
		return masterMpIfSecItemInfoDao.updateItemInfo(pFormData, pGridData);
	}

	@Override
	public String requotSecItemInfo(Map<String, String> pFormData, List<Object> pGridData) {
		return masterMpIfSecItemInfoDao.requotItemInfo(pFormData, pGridData);
	}

	@Override
	public String registSecItemInfo(Map<String, String> pFormData, List<Object> pGridData) {
		return masterMpIfSecItemInfoDao.registItemInfo(pFormData, pGridData);
	}

	@Override
	public String cancelQutSecItemInfo(Map<String, String> pFormData, List<Object> pGridData) {
		return masterMpIfSecItemInfoDao.cancelItemInfo(pFormData, pGridData);
	}

	@Override
	public String resendPriceSecItemInfo(Map<String, String> formData, List<Object> gridData) {
		return masterMpIfSecItemInfoDao.resendPrice(formData, gridData);
	}
}
