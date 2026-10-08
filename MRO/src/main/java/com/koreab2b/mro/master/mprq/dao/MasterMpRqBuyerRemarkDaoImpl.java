package com.koreab2b.mro.master.mprq.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.master.mprq.controller.MasterMpRqBuyerRemarkController;

@Repository("masterMpRqBuyerRemarkDao")
@Transactional
public class MasterMpRqBuyerRemarkDaoImpl implements MasterMpRqBuyerRemarkDao {

	private static final Logger LOGGER = LoggerFactory.getLogger(MasterMpRqBuyerRemarkController.class);
	
	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	
	public List<Map<String,String>> getList(Map<String,String>  pMap) {
		return sqlSessionTemplate.selectList("master.mprq.getMasterMpRqBuyerRemarkList", pMap);
	}
	
	// 저장
	public String updateSelectedData(Map<String,String> formData) {
		String _rtnMsg = "";
		String _result = "";
		try {
			// 고객사견적특이사항
			sqlSessionTemplate.update("master.mprq.updateMasterMpRqBuyerReNote", formData);
			
			// DB클렌징비고
			formData.put("TYPE", "CLRM");
			formData.put("REMARK", formData.get("st_remark2_1"));
			_result = sqlSessionTemplate.selectOne("master.mprq.getMasterMpRqBuyerRemarkOne", formData);
			
			if (Integer.parseInt(_result) > 0) {
				sqlSessionTemplate.update("master.mprq.updateMasterMpRqBuyerRemarkOne", formData);
				
			} else {
				sqlSessionTemplate.insert("master.mprq.insertMasterMpRqBuyerRemarkOne", formData);
			}
			
			// MOQ설정비고
			formData.put("TYPE", "MOQT");
			formData.put("REMARK", formData.get("st_remark2_2"));
			_result = sqlSessionTemplate.selectOne("master.mprq.getMasterMpRqBuyerRemarkOne", formData);
			
			if (Integer.parseInt(_result) > 0) {
				sqlSessionTemplate.update("master.mprq.updateMasterMpRqBuyerRemarkOne", formData);
				
			} else {
				sqlSessionTemplate.insert("master.mprq.insertMasterMpRqBuyerRemarkOne", formData);
			}

			// 지정_선호협력사비고
			formData.put("TYPE", "DSRM");
			formData.put("REMARK", formData.get("st_remark3"));
			_result = sqlSessionTemplate.selectOne("master.mprq.getMasterMpRqBuyerRemarkOne", formData);
			
			if (Integer.parseInt(_result) > 0) {
				sqlSessionTemplate.update("master.mprq.updateMasterMpRqBuyerRemarkOne", formData);
				
			} else {
				sqlSessionTemplate.insert("master.mprq.insertMasterMpRqBuyerRemarkOne", formData);
			}
			
			// 업체선정
			formData.put("TYPE", "ASRM");
			formData.put("REMARK", formData.get("st_remark4_1"));
			_result = sqlSessionTemplate.selectOne("master.mprq.getMasterMpRqBuyerRemarkOne", formData);
			
			if (Integer.parseInt(_result) > 0) {
				sqlSessionTemplate.update("master.mprq.updateMasterMpRqBuyerRemarkOne", formData);
				
			} else {
				sqlSessionTemplate.insert("master.mprq.insertMasterMpRqBuyerRemarkOne", formData);
			}
			
			// 고객사제출비고내용
			formData.put("TYPE", "ASRMGD");
			formData.put("REMARK", formData.get("st_remark4_2"));
			_result = sqlSessionTemplate.selectOne("master.mprq.getMasterMpRqBuyerRemarkOne", formData);
			
			if (Integer.parseInt(_result) > 0) {
				sqlSessionTemplate.update("master.mprq.updateMasterMpRqBuyerRemarkOne", formData);
				
			} else {
				sqlSessionTemplate.insert("master.mprq.insertMasterMpRqBuyerRemarkOne", formData);
			}
			
			// 제출전비고
			formData.put("TYPE", "QSRM");
			formData.put("REMARK", formData.get("st_remark5"));
			_result = sqlSessionTemplate.selectOne("master.mprq.getMasterMpRqBuyerRemarkOne", formData);
			
			if (Integer.parseInt(_result) > 0) {
				sqlSessionTemplate.update("master.mprq.updateMasterMpRqBuyerRemarkOne", formData);
				
			} else {
				sqlSessionTemplate.insert("master.mprq.insertMasterMpRqBuyerRemarkOne", formData);
			}
			_rtnMsg = "OK";
			
		} catch (Exception e) {
			LOGGER.error("SQL ERROR : ", e);
			_rtnMsg = "ERR";
			throw new RuntimeException("저장에 실패 했습니다.");
		}
		
		return _rtnMsg; 
	}
}
