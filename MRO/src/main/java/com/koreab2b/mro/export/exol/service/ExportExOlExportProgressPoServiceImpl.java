package com.koreab2b.mro.export.exol.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.export.exol.dao.ExportExOlExportProgressPoDao;

@Service("exportExOlExportProgressPoService")
public class ExportExOlExportProgressPoServiceImpl implements ExportExOlExportProgressPoService {
	@Autowired
	private ExportExOlExportProgressPoDao exportExOlExportProgressPoDao;

	// 리스트 조회
	public List<Map<String,String>> getList(Map<String,Object> param) {
		return exportExOlExportProgressPoDao.selectList(param);
	}	

	// HS CODE 등록
	@Transactional
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData) {
		return exportExOlExportProgressPoDao.updateSelectedData(formData, gridData);
	}
}
