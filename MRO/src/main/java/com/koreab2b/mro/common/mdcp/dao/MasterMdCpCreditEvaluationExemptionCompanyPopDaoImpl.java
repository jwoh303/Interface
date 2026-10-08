package com.koreab2b.mro.common.mdcp.dao;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.seller.mdct.dao.SellerMdCtMbrCmpyInfoDaoImpl;
import com.koreab2b.mro.util.CommonUtil;

@Repository("masterMdCpCreditEvaluationExemptionCompanyPopDao")
@Transactional
public class MasterMdCpCreditEvaluationExemptionCompanyPopDaoImpl implements MasterMdCpCreditEvaluationExemptionCompanyPopDao {
	private static final Logger logger = LoggerFactory.getLogger(SellerMdCtMbrCmpyInfoDaoImpl.class);
	
	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	// 조회
	public List<Map<String,String>> selectList(Map<String,String> formData) {
		return sqlSessionTemplate.selectList("common.mdcp.selectMasterMdCpCreditEvaluationExemptionCompanyPopList", formData);
	}
	
	// 조회
	public List<Map<String,String>> selectMdmList(Map<String,String> formData) {
		return sqlSessionTemplate.selectList("common.mdcp.selectMasterMdCpCreditEvaluationExemptionCompanyPopMdm", formData);
	}

	// 저장
	public String updateSelectedData(Map<String, String> formData) {

		String _rtnMsg = "OK";
	
		try {
			sqlSessionTemplate.update("common.mdcp.updateMasterMdCpCreditEvaluationExemptionCompanyPop", formData);
			sqlSessionTemplate.delete("common.mdcp.deleteMasterMdCpCreditEvaluationExemptionCompanyPop", formData);
			Map<String, Object>  _data = new HashMap<String, Object>();
			_data.putAll(formData);
			List< String > _list = new ArrayList< String >( );
			
			if (!formData.get("st_buyer_code").equals("ALL")) {
				_list = CommonUtil.getStringArrary((String) formData.get("st_buyer_code"),"@");
				if (_list.size() > 0) {
					_data.put("buyer_code_array", _list);
				}
			}
			
			sqlSessionTemplate.insert("common.mdcp.insertMasterMdCpCreditEvaluationExemptionCompanyPop", _data);

		} catch(Exception e) {
			_rtnMsg = "Err";
			logger.error("SQL ERROR : ", e);
			throw new RuntimeException("협력사 저장에 실패하였습니다.");
		}
		return _rtnMsg;
	}
}
