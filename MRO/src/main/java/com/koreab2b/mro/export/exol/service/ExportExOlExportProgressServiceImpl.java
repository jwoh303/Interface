package com.koreab2b.mro.export.exol.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.export.exol.dao.ExportExOlExportProgressDao;

@Service("exportExOlExportProgressService")
public class ExportExOlExportProgressServiceImpl implements ExportExOlExportProgressService {
	@Autowired
	private ExportExOlExportProgressDao exportExOlExportProgressDao;

	// 리스트 조회
	public List<Map<String,String>> getList(Map<String,Object> param) {
		return exportExOlExportProgressDao.selectList(param);
	}	

	// 저장, 납품완료
	@Transactional
	public String updateSelectedHdData(Map<String,String>  formData, List<Object> gridData) {
		return exportExOlExportProgressDao.updateSelectedHdData(formData, gridData);
	}
	
	// CI 삭제
	@Transactional
	public String updateSelectedCiData(Map<String,String>  formData, List<Object> gridData) {
		return exportExOlExportProgressDao.updateSelectedCiData(formData, gridData);
	}

	// BL 삭제
	@Transactional
	public String updateSelectedBlData(Map<String,String>  formData, List<Object> gridData) {
		return exportExOlExportProgressDao.updateSelectedBlData(formData, gridData);
	}
}
