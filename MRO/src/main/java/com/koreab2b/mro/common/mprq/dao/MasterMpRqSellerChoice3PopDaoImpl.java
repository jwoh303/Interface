package com.koreab2b.mro.common.mprq.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.master.mprq.dao.MasterMpRqCmpySelQuotationSendDaoImpl;


@Repository("masterMpRqSellerChoice3PopDao")
@Transactional
public class MasterMpRqSellerChoice3PopDaoImpl implements MasterMpRqSellerChoice3PopDao {
	private static final Logger LOGGER = LoggerFactory.getLogger(MasterMpRqCmpySelQuotationSendDaoImpl.class);
	
	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	private String _rtnMsg = "";

	public List<Map<String,String>> selectList(Map<String,Object> formData) {
		return sqlSessionTemplate.selectList("common.mprq.selectMasterMpRqSellerChoice3PopList", formData);
	}
	
	public List<Map<String,String>> selectListHd(Map<String,Object> formData) {
		return sqlSessionTemplate.selectList("common.mprq.selectMasterMpRqSellerChoice3PopHdList", formData);
	}
	
	public List<Map<String,String>> selectListCode(Map<String,Object> formData) {
		return sqlSessionTemplate.selectList("common.mprq.selectMasterMpRqSellerChoice3PopCodeList", formData);
	}
	
	public List<Map<String,String>> selectListReNote(Map<String,Object> formData) {
		return sqlSessionTemplate.selectList("common.mprq.selectMasterMpRqSellerChoice3PopReNoteList", formData);
	}
	
	public String updateFileUpload(Map<String,String> formData) {
		_rtnMsg = "정상적으로 파일 첨부 처리되었습니다.";
		try{
				sqlSessionTemplate.update("common.mprq.updateFileUpload", formData);
				
				//첨부파일 유효성 활성화(GABAGE_FLAG 를 'Y' 로 변경) 
				formData.put("DOC_NO", formData.get("st_image_key"));
				sqlSessionTemplate.update("common.fileUploadFlagUpdate", formData);
		}catch(Exception e){
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("처리를 하던중 오류가 발생하였습니다.\n\n관리자에게 문의 바랍니다.");
		}
		return _rtnMsg;	
	}
	
	public String saveMasterMpRqClose(Map<String,String> formData) {
		_rtnMsg = "정상적으로 견적 마감 처리되었습니다.";
		try{
			sqlSessionTemplate.update("common.mprq.saveMasterMpRqClose", formData);
		}catch(Exception e){
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("처리를 하던중 오류가 발생하였습니다.\n\n관리자에게 문의 바랍니다.");
		}
		return _rtnMsg;	
	}
	
	public List<Map<String,String>> getBuyerRate(Map<String,Object> formData) {
		return sqlSessionTemplate.selectList("common.mprq.selectBuyerRate", formData);
	}
	public List<Map<String,String>> getBuyerSum(Map<String,Object> formData) {
		return sqlSessionTemplate.selectList("common.mprq.selectBuyerSum", formData);
	}
	public List<Map<String,String>> getBuyerSumB(Map<String,Object> formData) {
		return sqlSessionTemplate.selectList("common.mprq.selectBuyerSumB", formData);
	}
	public List<Map<String,String>> getProcessImportRate(Map<String,Object> formData) {
		return sqlSessionTemplate.selectList("common.mprq.selectProcessImportRate", formData);
	}
	
	// 협력사선정
	@SuppressWarnings("unchecked")
	@Transactional(rollbackFor=Exception.class, propagation=Propagation.REQUIRED)
	public String saveMasterMpRqAgentSel(Map<String,String>  formData, List<Object> gridData) {
		
		_rtnMsg = "정상적으로 처리되었습니다.";
		
		try{
			
			for(int i=0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));
				//전략소싱팀 진행건.
				if(formData.get("SG_GBN").equals("SO")){
					if(formData.get("SG_KEP_YN").equals("Y")){
						if(i ==0){
							sqlSessionTemplate.update("common.mprq.saveRQDT", formData);
						}
						// 각 협력사 낙찰 및 판매단가 지정
						sqlSessionTemplate.update("common.mprq.saveSgQTDT", formData);
					}else{
						if(i ==0){
							sqlSessionTemplate.update("common.mprq.saveRQDT", formData);
						}
						// 각 협력사 낙찰 및 판매단가 지정
						sqlSessionTemplate.update("common.mprq.savePmQTDT", formData);
					}
				}else{
					if(formData.get("AGENT_CHECK").equals("1")){
						sqlSessionTemplate.update("common.mprq.saveRQDT", formData);
					}
					// 각 협력사 낙찰 및 판매단가 지정
					sqlSessionTemplate.update("common.mprq.saveQTDT", formData);
				}
			}
			
		} catch (Exception e){
			LOGGER.error("SQL ERROR : ", e);
				throw new RuntimeException("저장에 실패하였습니다.");
		}
		return _rtnMsg;
	}
	
	//시장가 확인 업데이트
	public void saveMasterMpRqMarketUnitPriceYn(Map<String,String>  formData) {
		sqlSessionTemplate.update("common.mprq.saveMasterMpRqMarketUnitPriceYn", formData);
	}
}

