package com.koreab2b.mro.common.mdsr.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

@Repository("masterMdSrSrCmsDetailPopDaoImpl")
@Transactional
public class MasterMdSrSrCmsDetailPopDaoImpl implements MasterMdSrSrCmsDetailPopDao {
	
	private static final Logger logger = LoggerFactory.getLogger(MasterMdSrSrCmsDetailPopDaoImpl.class);
	
	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	
	// 조회
	public List<Map<String,String>> getMasterMdSrSrCmsDetailPop(Map<String,Object> formData) {
		return sqlSessionTemplate.selectList("common.mdsr.selectMasterMdSrSrCmsDetailPop", formData);
	}

	// 저장
	public String saveMasterMdSrSrCmsDetailPop(Map<String,String>  formData) {
		String _rtnMsg = "OK";
		String recvFlag = "";
		try {
			recvFlag = formData.get("st_recv_flag");
			
			if("PS".equals(recvFlag)){
				sqlSessionTemplate.update("common.mdsr.updateMasterMdSrSrCmsDetailPopPS", formData);
			}else if("PA".equals(recvFlag) || "PB".equals(recvFlag)){
				sqlSessionTemplate.update("common.mdsr.updateMasterMdSrSrCmsDetailPop", formData);
				
				//첨부파일 유효성 활성화(GABAGE_FLAG 를 'Y' 로 변경) 
				formData.put("DOC_NO", formData.get("st_ff_image_key"));
				sqlSessionTemplate.update("common.fileUploadFlagUpdate", formData);
				
				if("PA".equals(recvFlag) || "PB".equals(recvFlag)){
					sqlSessionTemplate.update("common.mdsr.mailMasterMdSrSrCmsDetailPop", formData);
				}
			}
			
		} catch (Exception e) {
			_rtnMsg = "Err";
			logger.error("SQL ERROR : ", e);
			throw new RuntimeException("처리 하던중 오류가 발생하였습니다.");
		}
		return _rtnMsg;
	}
	
	// 형상관리
	public String historyMasterMdSrSrCmsDetailPop(Map<String,String>  formData) {
		String _rtnMsg = "OK";
		try {
			//STEP1
			sqlSessionTemplate.update("common.mdsr.historyInsertSWMGBUGTD", formData);
			//STEP2
			sqlSessionTemplate.update("common.mdsr.historyUpdateKEPASRDT", formData);
			
		} catch (Exception e) {
			_rtnMsg = "Err";
			logger.error("SQL ERROR : ", e);
			throw new RuntimeException("형상관리 요청 에러 발생하였습니다.");
		}
		return _rtnMsg;
	}


}
