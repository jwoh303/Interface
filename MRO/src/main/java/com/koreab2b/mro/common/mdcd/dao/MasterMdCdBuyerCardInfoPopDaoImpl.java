package com.koreab2b.mro.common.mdcd.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

@Repository("masterMdCdBuyerCardInfoPopDao")
@Transactional
public class MasterMdCdBuyerCardInfoPopDaoImpl implements MasterMdCdBuyerCardInfoPopDao {
	private static final Logger logger = LoggerFactory.getLogger(MasterMdCdBuyerCardInfoPopDaoImpl.class);
	
	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	private String _rtnMsg = "";
	
	// 조회
	public List<Map<String,String>> selectList(Map<String,String> formData) {
		return sqlSessionTemplate.selectList("common.mdcd.selectMasterMdCdBuyerCardInfoPopList", formData);
	}
	
	//거래금액 조회
	public List<Map<String,String>> selectAcountList(Map<String,String> formData) {
		return sqlSessionTemplate.selectList("common.mdcd.selectMasterMdCdBuyerCardInfoPopAcount", formData);
	}
	
	//주요활동내용 조회
	public List<Map<String,String>> selectVisitList(Map<String, Object> formData) {
		return sqlSessionTemplate.selectList("common.mdcd.selectMasterMdCdBuyerCardInfoPopVisit", formData);
	}
	
	// 고객특이사항 저장
	public String updateSelectedData(Map<String,String>  formData) {
		 _rtnMsg = "OK";

		try {
				// STEP1
				sqlSessionTemplate.update("common.mdcd.updateMasterMdCdBuyerCardInfoPop", formData);

		} catch (Exception e) {
			_rtnMsg = "Err";
			logger.error("SQL ERROR : ", e);
			throw new RuntimeException("고객관리(INSERT KEP_VISITHD) UPDATE 에러가 발생하였습니다.");
		}
		return _rtnMsg;
	}
	
	// 삭제
	@SuppressWarnings("unchecked")
	@Transactional(rollbackFor=Exception.class, propagation=Propagation.REQUIRED)
	public String deleteSelectedData(Map<String,String>  formData, List<Object> gridData) {
		
		_rtnMsg = "삭제가 완료 되었습니다.";
		
		try {
			for (int i=0; i < gridData.size(); i++) {
				formData.putAll((Map<String, String>)gridData.get(i));		

				sqlSessionTemplate.update("common.mdcd.deleteMasterMdCdBuyerCardInfoPop", formData);
			}
		} catch(Exception e) {
			logger.error("SQL ERROR : ", e);
			throw new RuntimeException("고객관리(INSERT KEP_VISITHD) UPDATE 에러가 발생하였습니다.");
		}

		return _rtnMsg;
		
	}	
	
}
