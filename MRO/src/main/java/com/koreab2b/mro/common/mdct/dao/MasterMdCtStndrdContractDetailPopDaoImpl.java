package com.koreab2b.mro.common.mdct.dao;

import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.seller.mdct.dao.SellerMdCtMbrCmpyInfoDaoImpl;

@Repository("masterMdCtStndrdContractDetailPopDao")
@Transactional
public class MasterMdCtStndrdContractDetailPopDaoImpl implements MasterMdCtStndrdContractDetailPopDao {
	private static final Logger LOGGER = LoggerFactory.getLogger(SellerMdCtMbrCmpyInfoDaoImpl.class);
	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	// 조회
	public Map<String,String> selectList(Map<String,String> formData) {
		return sqlSessionTemplate.selectOne("common.mdct.selectMasterMdCtStndrdContractDetailPopList", formData);
	}
	
	
	
	// 삭제
	public String deleteSelectedData(Map<String,String> formData) {

		String _rtnMsg = "OK";
	
		try {
			sqlSessionTemplate.update("common.mdct.deleteMasterMdCtStndrdContractDetailPop", formData);

		} catch(Exception e) {
			_rtnMsg = "Err";
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("표준계약서 삭제 실패하였습니다.");
		}
		return _rtnMsg;
	}
	
}
