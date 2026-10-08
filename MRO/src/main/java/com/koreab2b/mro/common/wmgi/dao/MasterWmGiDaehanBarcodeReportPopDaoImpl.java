package com.koreab2b.mro.common.wmgi.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.util.CommonUtil;

@Repository("masterWmGiDaehanBarcodeReportPopDao")
@Transactional
public class MasterWmGiDaehanBarcodeReportPopDaoImpl implements MasterWmGiDaehanBarcodeReportPopDao {

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	// 조회
	public List<Map<String,String>> selectList(Map<String,Object> formData) {
		return sqlSessionTemplate.selectList("common.wmgi.selectMasterWmGiDaehanBarcodeReportPopList", formData);
	}
	
}
