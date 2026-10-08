package com.koreab2b.mro.seller.mprq.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.transaction.interceptor.TransactionAspectSupport;

import com.koreab2b.mro.master.mprq.dao.MasterMpRqCmpySelQuotationSendDaoImpl;

@Repository("sellerMpRqQuotManageDao")
@Transactional
public class SellerMpRqQuotManageDaoImpl implements SellerMpRqQuotManageDao {
	private static final Logger LOGGER = LoggerFactory.getLogger(MasterMpRqCmpySelQuotationSendDaoImpl.class);
	
	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	private String _rtnMsg = "";
	
	//리뉴얼 > 전체탭 > 조회
	public List<Map<String,String>> getSellerMpRqQuotaList_v2(Map<String,Object>  param) {
		return sqlSessionTemplate.selectList("seller.mprq.getSellerMpRqQuotaList_v2", param);
		
	}
	
	//리뉴얼 > 견적상세팝업 > 견적제출,포기
	public Map<String, Object> saveSellerMpRqQuotaDetailReqList_v2(Map<String,String>  param){
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		_rtnMsg = "견적을 제출하였습니다.";
		int chk = 0;
		try {
			String msds_flag = param.get("MSDS_YN");
			String giveup_flag = param.get("st_giveup_yn");

			if("Y".equals(msds_flag)){
				sqlSessionTemplate.update("seller.mprq.saveSellerMpRqQuotReqMsds_v2", param);	
			}
			
			chk = sqlSessionTemplate.update("seller.mprq.saveSellerMpRqQuotaReqList_v2", param);
			if(chk == 0){
				throw new Exception("작업에 실패하였습니다.\n관리자에게 문의하여 주시기 바랍니다.");
			}
			else{
				if("Y".equals(giveup_flag)){
					_rtnMsg = "정상적으로 견적포기 되었습니다.";
				}
				
				//첨부파일 유효성 활성화(GABAGE_FLAG 를 'Y' 로 변경) 
				param.put("DOC_NO", param.get("SELLER_IMAGE_KEY"));
				sqlSessionTemplate.update("common.fileUploadFlagUpdate", param);
			}
		} catch (Exception e) {
			TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
			rtnMap.put("msg", e.getMessage());
			return rtnMap;
		}
		rtnMap.put("msg", _rtnMsg);
		return rtnMap;
	}
	
	//리뉴얼 > 견적상세팝업 > 저장
	public Map<String, Object> saveSellerMpRqQuotaDetailProceList_v2(Map<String,String>  param){
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		_rtnMsg = "수정제출 하였습니다.";
		int chk = 0;
		try {

			chk = sqlSessionTemplate.update("seller.mprq.saveSellerMpRqQuotaList_v2", param);
			if(chk == 0){
				throw new Exception("저장에 실패하였습니다.\n관리자에게 문의하여 주시기 바랍니다.");
			}
		} catch (Exception e) {
			TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
			rtnMap.put("msg", e.getMessage());
			return rtnMap;
		}
		rtnMap.put("msg", _rtnMsg);
		return rtnMap;
	}
	
	//리뉴얼 > 견적요청탭 > 조회
	public List<Map<String,String>> getSellerMpRqQuotaReqList_v2(Map<String,Object>  param) {
		return sqlSessionTemplate.selectList("seller.mprq.getSellerMpRqQuotaReqList_v2", param);
	}
	
	//리뉴얼 > 견적요청탭 > 견적제출,포기
	@SuppressWarnings("unchecked")
	@Transactional(rollbackFor=Exception.class, propagation=Propagation.REQUIRED)
	public String saveSellerMpRqQuotaReqList_v2(Map<String,String>  formData, List<Object> gridData) {
		
		_rtnMsg = "견적을 제출하였습니다.";
		
		try{
			for(int i=0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));		
				
				String msds_flag = formData.get("MSDS_YN");
				String giveup_flag = formData.get("st_giveup_yn");
				
				if("Y".equals(msds_flag)){
					sqlSessionTemplate.update("seller.mprq.saveSellerMpRqQuotReqMsds_v2", formData);	
				}
				
				if("Y".equals(giveup_flag)){
					_rtnMsg = "정상적으로 견적포기 되었습니다.";
				}
				if("S".equals(giveup_flag)){
					_rtnMsg = "임시 저장 되었습니다.";
				}
				
				sqlSessionTemplate.update("seller.mprq.saveSellerMpRqQuotaReqList_v2", formData);
				
				//첨부파일 유효성 활성화(GABAGE_FLAG 를 'Y' 로 변경) 
				formData.put("DOC_NO", formData.get("SELLER_IMAGE_KEY"));
				sqlSessionTemplate.update("common.fileUploadFlagUpdate", formData);
			}
		}catch(Exception e){
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("견적 저장에 실패하였습니다.");
		}
		
		return _rtnMsg;		
	}
	
	//리뉴얼 > 견적제출탭 > 저장
	@SuppressWarnings("unchecked")
	@Transactional(rollbackFor=Exception.class, propagation=Propagation.REQUIRED)
	public String saveSellerMpRqQuotaList_v2(Map<String,String>  formData, List<Object> gridData) {
		
		_rtnMsg = "저장하였습니다.";
		
		try{
			for(int i=0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));		
				
				
				int chk = sqlSessionTemplate.update("seller.mprq.saveSellerMpRqQuotaList_v2", formData);
				if(chk == 0){
					throw new Exception("저장에 실패하였습니다.\n관리자에게 문의하여 주시기 바랍니다.");
				}
			}
		}catch(Exception e){
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("견적 저장에 실패하였습니다.");
		}
		
		return _rtnMsg;		
	}
	
}
