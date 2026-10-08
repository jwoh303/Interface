package com.koreab2b.mro.common.mdcp.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.seller.mdct.dao.SellerMdCtMbrCmpyInfoDaoImpl;

@Repository("masterMdCpRestrcCompanyPopDao")
@Transactional
public class MasterMdCpRestrcCompanyPopDaoImpl implements MasterMdCpRestrcCompanyPopDao {
	private static final Logger logger = LoggerFactory.getLogger(SellerMdCtMbrCmpyInfoDaoImpl.class);

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	// 조회
	public List<Map<String,String>> selectList(Map<String,String> formData) {
		return sqlSessionTemplate.selectList("common.mdcp.selectMasterMdCpRestrcCompanyPopList", formData);
	}
	
	// 조회
	public List<Map<String,String>> selectMdmList(Map<String,String> formData) {
		return sqlSessionTemplate.selectList("common.mdcp.selectMasterMdCpRestrcCompanyPopMdmNote", formData);
	}
	
	// 저장
	public String updateSelectedData(Map<String, String> formData) {
		String _rtnMsg = "OK";
		String _restrcCnt = "0";
	
		try {
			sqlSessionTemplate.update("common.mdcp.updateMasterMdCpRestrcCompanyPop", formData);
			String[] _buyerList = formData.get("st_buyer_code").split("\\@");

			for (int i=0; i < _buyerList.length; i++) {
				formData.put("st_buyer",  _buyerList[i]);
				_restrcCnt = sqlSessionTemplate.selectOne("common.mdcp.selectMasterMdCpRestrcCompanyPopCnt", formData);
				
				if ("0".equals(_restrcCnt)) {
					sqlSessionTemplate.insert("common.mdcp.insertMasterMdCpRestrcCompanyPop", formData);
				}
			}

		} catch(Exception e) {
			_rtnMsg = "Err";
			logger.error("SQL ERROR : ", e);
			throw new RuntimeException("협력사 수정에 실패하였습니다.");
		}
		return _rtnMsg;
	}
	
}
