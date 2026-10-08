package com.koreab2b.mro.common.mpds.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

@Repository("buyerMpDsPckpaprDesignManagePopDao")
@Transactional
public class BuyerMpDsPckpaprDesignManagePopDaoImpl implements BuyerMpDsPckpaprDesignManagePopDao {

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	// 조회
	public List<Map<String,String>> selectList(Map<String,String> formData) {
		return sqlSessionTemplate.selectList("common.mpds.selectBuyerMpDsPckpaprDesignManagePopList", formData);
	}

	//저장(KEP)
	public String updateMMReg(Map<String, String> formData) {
		
		String _rtnMsg = "저장이 성공적으로 이루어 졌습니다.";
		
		try{
				sqlSessionTemplate.update("common.mpds.buyerUpdateMMReg", formData);

				//첨부파일 유효성 활성화(GABAGE_FLAG 를 'Y' 로 변경) 
				formData.put("DOC_NO", formData.get("st_image_key"));
				sqlSessionTemplate.update("common.fileUploadFlagUpdate", formData);

		}catch(Exception e){
				throw new RuntimeException("저장에 실패하였습니다.");
		}
		return _rtnMsg;
	}
	
	//저장(문안)
	public String updateDDReg(Map<String, String> formData) {
		
		String _rtnMsg = "저장이 성공적으로 이루어 졌습니다.";
		
		try{
				sqlSessionTemplate.update("common.mpds.buyerUpdateDDReg", formData);

				//첨부파일 유효성 활성화(GABAGE_FLAG 를 'Y' 로 변경) 
				formData.put("DOC_NO", formData.get("st_image_key"));
				sqlSessionTemplate.update("common.fileUploadFlagUpdate", formData);

		}catch(Exception e){
				throw new RuntimeException("저장에 실패하였습니다.");
		}
		return _rtnMsg;
	}
	
	//저장(디자인)
	public String updateEEReg(Map<String, String> formData) {
		
		String _rtnMsg = "저장이 성공적으로 이루어 졌습니다.";
		
		try{
				sqlSessionTemplate.update("common.mpds.buyerUpdateEEReg", formData);

				//첨부파일 유효성 활성화(GABAGE_FLAG 를 'Y' 로 변경)
				formData.put("DOC_NO", formData.get("st_image_key"));
				sqlSessionTemplate.update("common.fileUploadFlagUpdate", formData);

		}catch(Exception e){
				throw new RuntimeException("저장에 실패하였습니다.");
		}
		return _rtnMsg;
	}
	
	//저장(마케팅)
	public String updateEsMkReg(Map<String, String> formData) {
		
		String _rtnMsg = "저장이 성공적으로 이루어 졌습니다.";
		
		try{
				sqlSessionTemplate.update("common.mpds.buyerUpdateEsMkReg", formData);
				
				if( "GB".equals(formData.get("db_recv_flag"))){	//반려의 경우 반려이력을 남김
					formData.put("st_user_dept", "MK");
					formData.put("st_remark", formData.get("st_es_mk1_remark"));
					sqlSessionTemplate.update("common.mpds.buyerUpdateGbHistory", formData);
				}

				//첨부파일 유효성 활성화(GABAGE_FLAG 를 'Y' 로 변경)
				formData.put("DOC_NO", formData.get("st_image_key"));
				sqlSessionTemplate.update("common.fileUploadFlagUpdate", formData);

		}catch(Exception e){
				throw new RuntimeException("저장에 실패하였습니다.");
		}
		return _rtnMsg;
	}
	
	//저장(PM)
	public String updateEsPdReg(Map<String, String> formData) {
		
		String _rtnMsg = "저장이 성공적으로 이루어 졌습니다.";
		
		try{
				sqlSessionTemplate.update("common.mpds.buyerUpdateEsPdReg", formData);
				
				if( "GB".equals(formData.get("db_recv_flag"))){	//반려의 경우 반려이력을 남김
					formData.put("st_user_dept", "PD");
					formData.put("st_remark", formData.get("st_es_pd1_remark"));
					sqlSessionTemplate.update("common.mpds.buyerUpdateGbHistory", formData);
				}

				//첨부파일 유효성 활성화(GABAGE_FLAG 를 'Y' 로 변경) 
				formData.put("DOC_NO", formData.get("st_image_key"));
				sqlSessionTemplate.update("common.fileUploadFlagUpdate", formData);

		}catch(Exception e){
				throw new RuntimeException("저장에 실패하였습니다.");
		}
		return _rtnMsg;
	}
	
	//저장(품질)
	public String updateEsQaReg(Map<String, String> formData) {
		
		String _rtnMsg = "저장이 성공적으로 이루어 졌습니다.";
		
		try{
				sqlSessionTemplate.update("common.mpds.buyerUpdateEsQaReg", formData);
				
				if( "GB".equals(formData.get("db_recv_flag"))){	//반려의 경우 반려이력을 남김
					formData.put("st_user_dept", "QA");
					formData.put("st_remark", formData.get("st_es_qa1_remark"));
					sqlSessionTemplate.update("common.mpds.buyerUpdateGbHistory", formData);
				}

				//첨부파일 유효성 활성화(GABAGE_FLAG 를 'Y' 로 변경) 
				formData.put("DOC_NO", formData.get("st_image_key"));
				sqlSessionTemplate.update("common.fileUploadFlagUpdate", formData);

		}catch(Exception e){
				throw new RuntimeException("저장에 실패하였습니다.");
		}
		return _rtnMsg;
	}
	

	/*저장*/
	public String updateEsFiReg(Map<String, String> formData) {
		
		String _rtnMsg = "저장이 성공적으로 이루어 졌습니다.";
		
		try{
				sqlSessionTemplate.update("common.mpds.buyerUpdateEsFiReg", formData);
				
				if( "GB".equals(formData.get("db_recv_flag"))){	//반려의 경우 반려이력을 남김
					formData.put("st_user_dept", "FI");
					formData.put("st_remark", formData.get("st_es_fi_remark"));
					sqlSessionTemplate.update("common.mpds.buyerUpdateGbHistory", formData);
				}
				
				//첨부파일 유효성 활성화(GABAGE_FLAG 를 'Y' 로 변경)
				formData.put("DOC_NO", formData.get("st_image_key"));
				sqlSessionTemplate.update("common.fileUploadFlagUpdate", formData);

		}catch(Exception e){
				throw new RuntimeException("저장에 실패하였습니다.");
		}
		return _rtnMsg;
	}

}
