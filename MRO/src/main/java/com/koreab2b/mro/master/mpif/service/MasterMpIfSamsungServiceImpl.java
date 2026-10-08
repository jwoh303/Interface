package com.koreab2b.mro.master.mpif.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.master.mpif.dao.MasterMpIfSamsungDao;

@Service("masterMpIfSamsungService")
public class MasterMpIfSamsungServiceImpl implements MasterMpIfSamsungService {
	
	@Autowired
	private MasterMpIfSamsungDao masterMpIfSamsungDao;

	@Override
	public List<Map<String, String>> getSamsungPoList(Map<String, Object> pMap) {
		return masterMpIfSamsungDao.getSamsungPoList(pMap);
	}

	@Override
	public String saveMasterMpifSamsungPoReturn(Map<String, String> formData, List<Object> gridData) {
		// TODO Auto-generated method stub
		return masterMpIfSamsungDao.insertMasterMpifSamsungPoReturn(formData, gridData);
	}
}