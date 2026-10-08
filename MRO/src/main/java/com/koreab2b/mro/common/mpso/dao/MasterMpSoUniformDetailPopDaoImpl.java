package com.koreab2b.mro.common.mpso.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

@Repository("masterMpSoUniformDetailPopDao")
@Transactional
public class MasterMpSoUniformDetailPopDaoImpl implements MasterMpSoUniformDetailPopDao {
	private static final Logger LOGGER = LoggerFactory.getLogger(MasterMpSoUniformDetailPopDaoImpl.class);

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	
	// 조회
	public List<Map<String,String>> selectHdList(Map<String,String> formData) {
		return sqlSessionTemplate.selectList("common.mpso.selectMasterMpSoUniformDetailPopHdList", formData);
	}
	
	// 조회
	public List<Map<String,String>> selectList(Map<String,Object> param) {
		List<Map<String, String>> resultList = null;
		
		resultList = sqlSessionTemplate.selectList("common.mpso.selectMasterMpSoUniformDetailPopList", param);
		
		return resultList;
	}
	
	// 저장
	public String updateSelectedData(Map<String,String>  formData){
		try{
			String business_cond = "";
			String aprv_flag = "";
			
			business_cond = formData.get("st_business_cond");
			aprv_flag = formData.get("st_aprv_flag");
			
			// 결재, 반려 처리
			sqlSessionTemplate.update("common.mpso.updateMasterMpSoUniformDetailPop", formData);
			
			/*
			결재요청(고객사 신청자 => 고객사 결재자) : 1
			결재반려(고객사 결재자 => 고객사 신청자) : 2
			확인요청(고객사 신청자 => 운영사 담당자) : 3
			확인반려(운영사 결재자 => 고객사 신청자) : 4
			접수요청(운영사 결재자 => 협력사 결재자) : 5
			접수반려(협력사 결재자 => 운영사 담당자) : 6
			계약완료(운영사 => 고객사 신청자/운영사 담당자/협력사 결재자) : 7
			*/
			
			if("B".equals(business_cond)){
				if("R".equals(aprv_flag)){
					formData.put("MAIL_TYPE", "2");
				}
				if("Y".equals(aprv_flag)){
					formData.put("MAIL_TYPE", "3");
				}
			}else if("M".equals(business_cond)){
				if("R".equals(aprv_flag)){
					formData.put("MAIL_TYPE", "4");
				}
				if("Y".equals(aprv_flag)){
					formData.put("MAIL_TYPE", "5");
				}
			}else if("S".equals(business_cond)){
				if("R".equals(aprv_flag)){
					formData.put("MAIL_TYPE", "6");
				}
				if("Y".equals(aprv_flag)){
					formData.put("MAIL_TYPE", "7");
				}
			}
			
			formData.put("MAIL_BUYER", formData.get("buyer"));
			formData.put("MAIL_ST_NO", formData.get("st_no"));
			
			sqlSessionTemplate.update("buyer.mpso.call_PKG_MAIL_REQ_PROC_INSERT_MAILSEND", formData);
			
		}catch(Exception e){
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("저장 실패하였습니다.");
		}
		return null;
	}
}
