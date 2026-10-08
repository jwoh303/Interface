package com.koreab2b.mro.common.mdcd.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.util.CommonUtil;

@Repository("masterMdCdPrimaryActivityDetailRegPopDao")
@Transactional
public class MasterMdCdPrimaryActivityDetailRegPopDaoImpl implements MasterMdCdPrimaryActivityDetailRegPopDao {
	private static final Logger logger = LoggerFactory.getLogger(MasterMdCdBuyerCardInfoPopDaoImpl.class);
	
	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	// 조회
	public List<Map<String,String>> selectList(Map<String,String> formData) {
		return sqlSessionTemplate.selectList("common.mdcd.selectMasterMdCdPrimaryActivityDetailRegPopList", formData);
	}
	
	// 저장
	public String updateSelectedData(Map<String,String>  formData) {
		String _rtnMsg = "OK";

		try {
			formData.putAll(CommonUtil.getMapNvl(formData));
			formData.put("st_visit_date",   formData.get("st_visit_date").replaceAll("/", ""));
			if (formData.get("flag").equals("insert")) {
				sqlSessionTemplate.insert("common.mdcd.insertMasterMdCdPrimaryActivityDetailRegPop", formData);
			} else {
				sqlSessionTemplate.update("common.mdcd.updateMasterMdCdPrimaryActivityDetailRegPop", formData);
			}
		} catch (Exception e) {
			_rtnMsg = "Err";
			logger.error("SQL ERROR : ", e);
			throw new RuntimeException("고객관리(INSERT KEP_VISITHD) UPDATE 에러가 발생하였습니다.");
		}
		return _rtnMsg;
	}
	
}
