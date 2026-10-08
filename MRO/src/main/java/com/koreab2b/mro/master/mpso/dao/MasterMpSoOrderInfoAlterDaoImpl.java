package com.koreab2b.mro.master.mpso.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.util.CommonUtil;

@Repository("masterMpSoOrderInfoAlterDao")
@Transactional
public class MasterMpSoOrderInfoAlterDaoImpl implements MasterMpSoOrderInfoAlterDao {
	private static final Logger LOGGER = LoggerFactory.getLogger(MasterMpSoOrderInfoAlterDaoImpl.class);

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	private String _rtnMsg = "";
	
	// 리스트 조회
	public List<Map<String,String>> selectList(Map<String,Object> param) {
		return sqlSessionTemplate.selectList("master.mpso.selectMasterMpSoOrderInfoAlterList", param);
	}

	// 저장
	@SuppressWarnings("unchecked")
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData) {
		
		_rtnMsg = "저장완료.";
		
		try{
			for(int i=0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));
				
				// STEP1
				sqlSessionTemplate.update("master.mpso.insertMasterMpSoOrderInfoAlter", formData);
			}
			
		} catch (Exception e){
			LOGGER.error("SQL ERROR : ", e);
				throw new RuntimeException("저장에 실패하였습니다.");
		}
		return _rtnMsg;
	}
	
	
	// 삭제
	@SuppressWarnings("unchecked")
	@Transactional(rollbackFor=Exception.class, propagation=Propagation.REQUIRED)
	public String deleteSelectedData(Map<String,String>  formData, List<Object> gridData) {
		
		_rtnMsg = "삭제완료";
		
		try{
			for(int i=0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));		
				
				sqlSessionTemplate.update("master.mpso.deleteMasterMpSoOrderInfoAlter", formData);
				LOGGER.error("deleteSelectedData 실행 완료");

			}
		}catch(Exception e){
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("견적 요청에 실패하였습니다.");
		}

		return _rtnMsg;		
		
	}	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	// 리스트조회 ( 일괄)
	public List<Map<String,String>> getMasterMpSoOrderInfoAlterMultiList(Map<String,Object>  param) {
		return sqlSessionTemplate.selectList("master.mpso.getKEP_PO_BULK_TMP", param);
	}
	public List<Map<String,String>> getMasterMpSoOrderInfoAlterMultiList_v2(Map<String,Object>  param) {
		return sqlSessionTemplate.selectList("master.mpso.getKEP_PO_BULK_TMP_v2", param);
	}

	// 저장  ( 일괄)
	public String saveMasterMpSoOrderInfoAlterMultiList(Map<String,String>  formData, List<Object> gridData) {
		
		_rtnMsg = "저장완료.";
		
		String USER_ID = CommonUtil.nvl(formData.get("USER_ID"),"");
		String PO_NO = "";
		String PO_SEQ = "";
		String BUYER_ITEM_NO = "";
		String UNIT_PRICE = "";
		String AGENT_PRICE = "";
		int userEquals = 0;

		try{
			for(int i=0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));
				
				// STEP1
				formData.put("USER_ID", USER_ID); 			
				PO_NO = CommonUtil.nvl(formData.get("PO_NO"),"");
				PO_SEQ = CommonUtil.nvl(formData.get("PO_SEQ"),"");
				BUYER_ITEM_NO = CommonUtil.nvl(formData.get("BUYER_ITEM_NO"),"");
				UNIT_PRICE = CommonUtil.nvl(formData.get("UNIT_PRICE"),"");
				AGENT_PRICE = CommonUtil.nvl(formData.get("AGENT_PRICE"),"");
				if ("".equals(PO_NO)
						|| "".equals(PO_SEQ)
						|| "".equals(BUYER_ITEM_NO)
						|| "".equals(UNIT_PRICE)
						|| "".equals(AGENT_PRICE) 
						|| "".equals(USER_ID) 
					){
					userEquals = 1;
					throw new RuntimeException();
				} 
				
				
				sqlSessionTemplate.update("master.mpso.removeKEP_PO_BULK_TMP2", formData);				
				sqlSessionTemplate.update("master.mpso.createKEP_PO_BULK_TMP", formData);
			}
			
		} catch (Exception e){
			LOGGER.error("SQL ERROR : ", e);
			if (userEquals == 1){
				throw new RuntimeException("정확한 정보를 엑셀 업로드하세요.");
			} else{
				throw new RuntimeException("엑셀 저장에 실패하였습니다.");
			}
		}
		return _rtnMsg;
	}
	
	// 삭제 ( 일괄)
	public String delMasterMpSoOrderInfoAlterMultList(Map<String,String>  formData, List<Object> gridData) {
		
		_rtnMsg = "삭제완료.";
		
		try{
			for(int i=0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));
				
				// STEP1
				sqlSessionTemplate.update("master.mpso.removeKEP_PO_BULK_TMP2", formData);
			}
			
		} catch (Exception e){
			LOGGER.error("SQL ERROR : ", e);
				throw new RuntimeException("삭제에 실패하였습니다.");
		}
		return _rtnMsg;
	}
	// 삭제 ( 주문정보수정 일괄) -- 상신전 삭제하는거 추가 2014.12.3
	public String delMasterMpSoOrderInfoAlterMultList2(Map<String,String>  formData) {
		
		_rtnMsg = "삭제완료."; 
		try{
				// STEP1
				sqlSessionTemplate.update("master.mpso.removeKEP_PO_BULK_TMP3", formData);
		 
			
		} catch (Exception e){
			LOGGER.error("SQL ERROR : ", e);
				throw new RuntimeException("삭제에 실패하였습니다.");
		}
		return _rtnMsg;
	}
	
}
