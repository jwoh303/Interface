package com.koreab2b.mro.common.mpiv.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.common.mpiv.dao.SellerMpIvExcelUploadPopDao;

@Service("sellerMpIvExcelUploadPopService")
public class SellerMpIvExcelUploadPopServiceImpl implements SellerMpIvExcelUploadPopService {
	
	@Autowired
	private SellerMpIvExcelUploadPopDao sellerMpIvExcelUploadPopDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,String> formData) {
		return sellerMpIvExcelUploadPopDao.selectList(formData);
	}
	public List<Map<String,String>> getSellerMpIvExcelUploadPop_v2(Map<String,Object> formData) {
		return sellerMpIvExcelUploadPopDao.getSellerMpIvExcelUploadPop_v2(formData);
	}
	
	// 엑셀 업로드
	public String setExcelUp(Map<String,String>  formData) {
		return sellerMpIvExcelUploadPopDao.saveExcelUp(formData);
	}
	@Transactional
	public String setMpIvExcelUp_v2(Map<String,String>  formData, List<Object> gridData) {
		return sellerMpIvExcelUploadPopDao.setMpIvExcelUp_v2(formData, gridData);
	}
	
	// 엑셀 TMP 테이블 삭제
	public String delExcelUp(Map<String,String>  formData) {
		return sellerMpIvExcelUploadPopDao.delExcelUp(formData);
	}
}
