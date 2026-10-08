package com.koreab2b.mro.common.wmre.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.common.mpif.dao.MasterMpIfOrderNoSearchPopDaoImpl;

@Repository("masterWmReReturnEntryPopDao")
@Transactional
public class MasterWmReReturnEntryPopDaoImpl implements MasterWmReReturnEntryPopDao {
	
	private static final Logger LOGGER = LoggerFactory.getLogger(MasterMpIfOrderNoSearchPopDaoImpl.class);
	
	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	// 조회
	public List<Map<String,String>> selectList(Map<String,Object> formData) {
		return sqlSessionTemplate.selectList("common.wmre.selectMasterWmReReturnEntryPopList", formData);
	}
	
	//고객사 조회
	public List<Map<String,String>> selectPopList(Map<String,String> formData) {
		return sqlSessionTemplate.selectList("commonPopup.masterWmDeptPop", formData);
	}	
	// 조회 _for upadate
	public List<Map<String,String>> selectUpdateList(Map<String,Object> formData) {
		return sqlSessionTemplate.selectList("common.wmre.getMasterWmReReturnWmPopForUpdate", formData);
	}
	public List<Map<String,String>> getMasterWmReReturnEntryPopForUpdateSeller_v2(Map<String,Object> formData) {
		return sqlSessionTemplate.selectList("common.wmre.getMasterWmReReturnEntryPopForUpdateSeller_v2", formData);
	}
	
	
	//반품고객사 입력 조회 
	public List<Map<String,String>> selectPopBuyerList(Map<String,String> formData) {
		return sqlSessionTemplate.selectList("common.wmre.selectMasterWmReReturnEntryPopForBuyer", formData);
	}	
	public List<Map<String,String>> getPopBuyer_v2(Map<String,String> formData) {
		return sqlSessionTemplate.selectList("common.wmre.getPopBuyer_v2", formData);
	}	
	
	
	public String saveMasterWmReReturnEntryPop(Map<String,String> formData) {
		String rtnMsg = "Ok";
		
		try{

	
			if("Y".equals(formData.get("st_insert_yn"))){
				
				//기등록된 반품인지 검색
				// 발주번호체크.
				//int rtnCount = (Integer)sqlSessionTemplate.selectOne("common.wmre.existMasterWmReReturnEntry", formData);
			
				/*if(rtnCount>0){
					rtnMsg = "이미 반품정보가 등록되어 있습니다.";
					return rtnMsg;
				}*/
				if("Y".equals(formData.get("st_seller_flag"))){
					
					sqlSessionTemplate.update("common.wmre.saveMasterWmReReturnEntrySellerPop", formData);
					
				}else{
					
					sqlSessionTemplate.update("common.wmre.saveMasterWmReReturnEntryPop", formData);
					
				}

			}
			else{
				
				if("Y".equals(formData.get("st_seller_flag"))){
					
					sqlSessionTemplate.update("common.wmre.updateMasterWmReReturnEntrySellerPop", formData);
					
				}else{
					
					sqlSessionTemplate.update("common.wmre.updateMasterWmReReturnEntryPop", formData);
					
				}
				
			}

		
		}catch(Exception e){
			rtnMsg = "반품정보 등록 중 오류가 발생 하였습니다.";
			throw new RuntimeException();
		}
		
		return rtnMsg;
	}
	
	//반품등록 고객사 요청 취소  / 교환 등록 
	public String saveMasterWmReReturnEntryCancelPop(Map<String,String> formData) {
		String rtnMsg = "Ok";
		String wmre_no = "";
		try{
			
			//기등록된 반품인지 검색
			int rtnCount = (Integer)sqlSessionTemplate.selectOne("common.wmre.existMasterWmReReturnEntry", formData);
		
			if(rtnCount>0){
				rtnMsg = "이미 반품정보가 등록되어 있습니다.";
				return rtnMsg;
			}
			
			if("Y".equals(formData.get("st_cancel_flag"))){
				
				sqlSessionTemplate.update("common.wmre.saveMasterWmReReturnEntryCancelPop", formData);
				
			}else if("N".equals(formData.get("st_cancel_flag"))){
				
				sqlSessionTemplate.update("common.wmre.saveMasterWmReReturnEntryForBuyerPop", formData);
				
			}
			
			// insert 시 채번 될 wmre_no 확인(메일 전송 파라미터 이용 위하여)
			wmre_no = sqlSessionTemplate.selectOne("common.wmre.getMasterWmReReturnWmreNo", formData);
						
			formData.put("wmre_no", wmre_no);
			sqlSessionTemplate.update("common.wmre.insertMasterWmReBuyerReturnNoticeMail", formData);
		
		}catch(Exception e){
			
			LOGGER.error("SQL ERROR : ", e);
			
			if ( e instanceof RuntimeException ) {
				throw new RuntimeException(e.getMessage());
			}
			rtnMsg = "반품정보 등록 중 오류가 발생 하였습니다.";
			throw new RuntimeException(rtnMsg);
		}
		
		return rtnMsg;
	}
	
	
	//반품등록(상태)조회
	public List<Map<String,String>> selectRegPopList(Map<String,String> formData) {
		return sqlSessionTemplate.selectList("common.wmre.getMasterWmReReturnWmNoPop", formData);
	}	
	
	//반품등록(상태)
	public String saveMasterWmReReturnWmNoPop(Map<String,String> formData) {
		String rtnMsg = "Ok";
		
		try{
			sqlSessionTemplate.update("common.wmre.saveMasterWmReReturnWmNoPop", formData);
		
		}catch(Exception e){
			rtnMsg = "반품정보 등록 중 오류가 발생 하였습니다.";
			throw new RuntimeException(e.getMessage());
		}
		
		return rtnMsg;
	}
	
	//협력사 접수 , 입고 처리
	public String saveMasterWmReReturnWmNoPop_v2(Map<String,String> formData) {
		String rtnMsg = "Ok";
		
		try{
			int chk = sqlSessionTemplate.update("common.wmre.saveMasterWmReReturnWmNoPop_v2", formData);
			if(chk == 0){
				rtnMsg = "반품정보 처리 중 오류가 발생 하였습니다.";
				throw new RuntimeException();
			}
		}catch(Exception e){
			rtnMsg = "반품정보 처리 중 오류가 발생 하였습니다.";
			throw new RuntimeException(e.getMessage());
		}
		
		return rtnMsg;
	}
	
	//반품등록(취소)
	public String cancelMasterWmReReturnWmNoPop(Map<String,String> formData) {
		String rtnMsg = "Ok";
		
		try{
			sqlSessionTemplate.update("common.wmre.cancelMasterWmReReturnWmNoPop", formData);
		
		}catch(Exception e){
			rtnMsg = "반품정보 취소 중 오류가 발생 하였습니다.";
			throw new RuntimeException(e.getMessage());
		}
		
		return rtnMsg;
	}
	// 조회 발주기준 반품정보
	public List<Map<String,String>> selectReturnPoInfo(Map<String,Object> formData) {
		return sqlSessionTemplate.selectList("common.wmre.getMasterWmReReturnPoInfo", formData);
	}	
}
