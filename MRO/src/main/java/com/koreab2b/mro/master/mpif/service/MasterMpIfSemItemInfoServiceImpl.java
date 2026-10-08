package com.koreab2b.mro.master.mpif.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.master.mpif.dao.MasterMpIfSecItemInfoDao;
import com.koreab2b.mro.master.mpif.dao.MasterMpIfSemItemInfoDao;

@Service("masterMpIfSemItemInfoService")
public class MasterMpIfSemItemInfoServiceImpl implements MasterMpIfSemItemInfoService {
	
	@Autowired
	private MasterMpIfSemItemInfoDao masterMpIfSemItemInfoDao;

	// 리스트 조회
	public List<Map<String,String>> getList(Map<String,Object> param) {
		return masterMpIfSemItemInfoDao.selectList(param);
	}

	// 견적 저장
	@Override
	public String updateSemItemInfo(Map<String, String> pFormData, List<Object> pGridData) {
		return masterMpIfSemItemInfoDao.updateItemInfo(pFormData, pGridData);
	}

	// 재견적
	@Override
	public String requotSemItemInfo(Map<String, String> pFormData, List<Object> pGridData) {
		return masterMpIfSemItemInfoDao.requotItemInfo(pFormData, pGridData);
	}
	
	// 견적취소
	@Override
	public String cancelQutSemItemInfo(Map<String, String> pFormData, List<Object> pGridData) {
		return masterMpIfSemItemInfoDao.cancelItemInfo(pFormData, pGridData);
	}
}
