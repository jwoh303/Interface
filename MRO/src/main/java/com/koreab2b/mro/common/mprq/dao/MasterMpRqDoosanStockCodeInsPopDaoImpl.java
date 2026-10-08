package com.koreab2b.mro.common.mprq.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.common.mprq.controller.MasterMpRqDoosanStockCodeInsPopController;


@Repository("masterMpRqDoosanStockCodeInsPopDao")
@Transactional
public class MasterMpRqDoosanStockCodeInsPopDaoImpl implements MasterMpRqDoosanStockCodeInsPopDao {

	private static final Logger LOGGER = LoggerFactory.getLogger(MasterMpRqDoosanStockCodeInsPopController.class);
	
	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	private String _rtnMsg = "";
	
	// 조회
	public List<Map<String,String>> selectList(Map<String,Object> formData) {
		return sqlSessionTemplate.selectList("common.mprq.selectMasterMpRqDoosanStockCodeInsPopList", formData);
	}
	
	// 저장
	@SuppressWarnings("unchecked")
	public String saveDoosanStockCode(Map<String,String>  formData, List<Object> gridData) {
		
		_rtnMsg = "재고 자재코드 등록이 완료 되었습니다.";
		
		try{
			formData.putAll((Map<String, String>)gridData.get(0));	
			// STEP1
			sqlSessionTemplate.update("common.mprq.updateDoosanStockCode", formData);
		} catch (Exception e){
			LOGGER.error("SQL ERROR : ", e);
				throw new RuntimeException("재고 자재코드 등록 하던중 오류가 발생하였습니다. 담당자에게 문의 바랍니다.");
		}
		return _rtnMsg;
	}
}
