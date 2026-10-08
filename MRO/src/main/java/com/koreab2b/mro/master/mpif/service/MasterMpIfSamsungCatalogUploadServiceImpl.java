package com.koreab2b.mro.master.mpif.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.koreab2b.mro.master.mpif.dao.MasterMpIfSamsungCatalogUploadDao;

@Service("masterMpIfSamsungCatalogUploadService")
public class MasterMpIfSamsungCatalogUploadServiceImpl implements MasterMpIfSamsungCatalogUploadService {
	
	@Autowired
	private MasterMpIfSamsungCatalogUploadDao masterMpIfSamsungCatalogUploadDao;

	@Override
	public List<Map<String, String>> getList(Map<String, Object> param) {
		return masterMpIfSamsungCatalogUploadDao.getList(param);
	}

	@Override
	public String batchUploadList(Map<String, String> formData, List<Object> gridData) {
		return masterMpIfSamsungCatalogUploadDao.batchUploadList(formData, gridData);
	}

	@Override
	public String requestMasterMpIfSamsungCatalogUploadList(Map<String, String> formData, List<Object> gridData) {
		return masterMpIfSamsungCatalogUploadDao.requestMasterMpIfSamsungCatalogUploadList(formData, gridData);
	}

	@Override
	public String saveList(Map<String, String> formData, List<Object> gridData) {
		return masterMpIfSamsungCatalogUploadDao.saveList(formData, gridData);
	}

	@Override
	public String delList(Map<String, String> formData, List<Object> gridData) {
		return masterMpIfSamsungCatalogUploadDao.delList(formData, gridData);
	}

	
}
	
