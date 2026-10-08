package com.koreab2b.mro.master.mdcm.dao;

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

import com.koreab2b.mro.master.mprq.dao.MasterMpRqBuyerReqDao;

@Repository("masterMdCmCatalogMappingDao")
@Transactional
public class MasterMdCmCatalogMappingDaoImpl implements MasterMdCmCatalogMappingDao {
	private static final Logger LOGGER = LoggerFactory.getLogger(MasterMdCmCatalogMappingDaoImpl.class);

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	@Autowired
	private MasterMpRqBuyerReqDao masterMpRqBuyerReqDao;
	private String _rtnMsg = "";
	// 리스트 조회
	@SuppressWarnings("unchecked")
	public List<Map<String,String>> selectList(Map<String,Object> param) {
		List<Map<String, String>> resultList = null;
		resultList =  sqlSessionTemplate.selectList("master.mdcm.selectMasterMdCmCatalogReqList", param);
		
		return resultList;
	}
	/*품목매핑*/
	@SuppressWarnings("unchecked")
	public String saveMasterMdCmCatalogMapping(Map<String,String>  formData, List<Object> gridData) {
		_rtnMsg = "승인처리가 되었습니다.";
		
		try{
			for(int i=0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));
				//승인처리
				sqlSessionTemplate.update("master.mdcm.updateMasterMdCmCatalogMapping", formData);
				
				// ICOMBYIT 표준카탈로그코드 추천구분 수정
				sqlSessionTemplate.update("master.mdcm.updateMasterMdCmCatalogMapping1", formData);
			}
		}catch(Exception e){
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("저장에 실패하였습니다.");
		}
		return _rtnMsg;
	}
	/*매핑반려*/
	@SuppressWarnings("unchecked")
	public String rejectMasterMdCmCatalogMapping(Map<String,String>  formData, List<Object> gridData) {
		_rtnMsg = "매핑반려 처리가 되었습니다.";
		
		try{
			for(int i=0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));
				//반려처리
				sqlSessionTemplate.update("master.mdcm.rejectMasterMdCmCatalogMapping", formData);
				
			}
		}catch(Exception e){
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("저장에 실패하였습니다.");
		}
		return _rtnMsg;
	}
	/*매핑완료*/
	@SuppressWarnings("unchecked")
	public String saveMasterMdCmCatalogMappingCompl(Map<String,String>  formData, List<Object> gridData) {
		_rtnMsg = "매핑완료 처리가 되었습니다.";
		
		try{
			for(int i=0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));
				//매핑완료
				sqlSessionTemplate.update("master.mdcm.saveMasterMdCmCatalogMappingCompl", formData);
				sqlSessionTemplate.update("master.mdcm.saveMasterMdCmCatalogMappingByit", formData);					
			}
		}catch(Exception e){
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("저장에 실패하였습니다.");
		}
		return _rtnMsg;
	}
	/*매핑삭제*/
	@SuppressWarnings("unchecked")
	public String saveMasterMdCmCatalogMappingDel(Map<String,String>  formData, List<Object> gridData) {
		_rtnMsg = "삭제 처리가 되었습니다.";
		
		try{
			for(int i=0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));
				//매핑완료
				sqlSessionTemplate.update("master.mdcm.saveMasterMdCmCatalogMappingDel", formData);
			}
		}catch(Exception e){
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("저장에 실패하였습니다.");
		}
		return _rtnMsg;
	}
	/*매핑요청*/
	@SuppressWarnings("unchecked")
	public String saveMasterMdcmReqMapping(Map<String,String>  formData, List<Object> gridData) {
		_rtnMsg = "매핑요청 처리가 되었습니다.";
		
		try{
			for(int i=0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));
				String st_buyer = formData.get("BUYER");
				String st_req_no = masterMpRqBuyerReqDao.nextVal(st_buyer, "RQ");
				formData.put("REQ_NO", st_req_no);
				sqlSessionTemplate.update("master.mdcm.insertMasterMdcmReqMapping", formData);
				
			}
		}catch(Exception e){
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("저장에 실패하였습니다.");
		}
		return _rtnMsg;
	}
	/*품목보완요청*/
	@SuppressWarnings("unchecked")
	public String saveMasterMdCmReqAgentCatalog(Map<String,String>  formData, Map<String,String>  formData2,List<Object> gridData) {
		_rtnMsg = "품목보완 요청 처리가 되었습니다.";
		
		try{
			for(int i=0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));
				//비고정보 저장.
				sqlSessionTemplate.update("master.mdcm.updateMasterMdcmKEPCMSHDRemark", formData);
				//전차수 종료처리.
				sqlSessionTemplate.update("master.mdcm.updateMasterMdcmKEPCMSDTRevision", formData);
				//품목보완 요청
				sqlSessionTemplate.update("master.mdcm.insertMasterMdcmKEPCMSDTRevision", formData);
				//이메일 전송.
				List<Map<String,String>> list1 = null;
				List<Map<String,String>> list2 = null;
				list2 = sqlSessionTemplate.selectList("master.mdcm.selectMasterMdCmAgentUserInfo", formData);
				if(list2.size()>0){
					Map<String,String> mp = (Map<String,String>)list2.get(0);
					if(mp.get("MAIL_RECV_FLAG").equals("Y")){
						formData.put("SUBJECT", "[KoreaB2B.com] 품목보완 요청 메일이 도착하였습니다."); //제목입력
						formData.put("CONTENTS", "카탈로그관리 > 카탈로그정비관리 > 카탈로그정비 화면에서 해당 카탈로그 품목보완 제출 바랍니다."); //내용입력.
						formData.put("RECEIVE_EMAIL", mp.get("EMAIL")); //받는메일
						formData.put("RECEIVE_NAME", mp.get("USER_NAME_LOC")); //받는사람.
						list1 = sqlSessionTemplate.selectList("master.mdcm.selectMasterMdCmItemKepMailInfo", formData);
						if(list1.size() == 0){
							LOGGER.debug("E-MAIL전송==============="+ mp.get("EMAIL"));
							sqlSessionTemplate.update("master.mdcm.insertMasterMdCmItemKepMail", formData);
						}
					}
				}
				
			}
		}catch(Exception e){
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("저장에 실패하였습니다.");
		}
		return _rtnMsg;
	}
	// 저장
	@SuppressWarnings("unchecked")
	public String saveMasterMdcmReqRemarkAtos(Map<String,String>  formData) {
		_rtnMsg = "OK";
		try {
			sqlSessionTemplate.insert("master.mdcm.updateMasterMdcmReqRemarkAtos", formData);
		} catch (Exception e) {
			_rtnMsg = "Err";
			throw new RuntimeException("에러가 발생하였습니다.");
		}
		return _rtnMsg;
	}
	// 카테고리속성조회
	public List<Map<String,String>> getMasterMdCmCategoriAttb(Map<String,String> formData) {
		return sqlSessionTemplate.selectList("master.mdcm.selectMasterMdCmCategoriAttbList", formData);
	}
	// 품목정비 요청 이력 팝업.
	public List<Map<String,String>> getCmsComplementHistoryPop(Map<String,Object> formData) {
		List<Map<String, String>> resultList = null;
		resultList =  sqlSessionTemplate.selectList("master.mdcm.selectMasterMdCmCmsComplementHistoryPop", formData);
		return resultList;
	}
}
