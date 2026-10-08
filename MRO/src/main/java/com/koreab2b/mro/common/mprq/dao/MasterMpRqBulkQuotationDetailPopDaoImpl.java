package com.koreab2b.mro.common.mprq.dao;

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

@Repository("MasterMpRqBulkQuotationDetailPopDao")
@Transactional
public class MasterMpRqBulkQuotationDetailPopDaoImpl implements MasterMpRqBulkQuotationDetailPopDao {
	private static final Logger LOGGER = LoggerFactory.getLogger(MasterMpRqBulkQuotationDetailPopDaoImpl.class);

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	private String _rtnMsg = "";
	
	//프로젝트 조회
	@Override
	public Map<String, String> getProject(Map<String, Object> formData) {
		return sqlSessionTemplate.selectOne("master.mprq.selectMasterMpRqBulkQuotationProject", formData);
	}

	// 유의사항 조회
	@Override
	public List<Map<String, String>> getSheet(Map<String, Object> formData) {
		String _sheetNum = (String) formData.get("st_sheet"); 
		return sqlSessionTemplate.selectList("master.mprq.selectMasterMpRqBulkQuotationDetailSheetPop"+_sheetNum, formData);
	}
	
	// 프로젝트 저장
	@SuppressWarnings("unchecked")
	public String updateData(Map<String, String> formData) {
		
		try{
			sqlSessionTemplate.update("master.mprq.updateBulkQuotationProject", formData);
			
		} catch (Exception e){
			LOGGER.error("SQL ERROR : ", e.getMessage());
			throw new RuntimeException("프로젝트 등록 시 오류가 발생하였습니다. 담당자에게 문의 바랍니다.");
		}
		
		return _rtnMsg;
	}

	// 유의사항 저장
	@Override
	public String updateNoticeData(List<Object> gridData, Map<String, String> formData) {
		try{
		
			for(int i=0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));

				LOGGER.debug("updateNoticeData  formData {} " , formData);
				
				// 신규등록
				if(formData.get("NOTICE_STATUS").equals("N")){
					String SEQ = sqlSessionTemplate.selectOne("master.mprq.selectBurqMaxSeq", formData);
					
					formData.put("st_seq",SEQ);
					
					sqlSessionTemplate.update("master.mprq.updateBulkQuotationtNotice_1", formData);
					
				}else if(!formData.get("NOTICE_STATUS").equals("C")){ // 수정되거나 삭제된 경우 R , D / C는 수정없음(등록상태)
					sqlSessionTemplate.update("master.mprq.updateBulkQuotationtNotice_2", formData);
				}
			}
			
		} catch (Exception e){
			LOGGER.error("SQL ERROR : ", e);
				throw new RuntimeException("유의사항 저장에 실패하였습니다.");
		}
		return _rtnMsg;
	}
	
	// 고객사코드 저장
	@Override
	public String updateBuyerData(List<Object> gridData, Map<String, String> formData) {
		
		try{

			for(int i=0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));
				LOGGER.debug("updateBuyerData formData {} " , formData);
				if(formData.get("STATUS").equals("R")){
 					// 기존 고객사 코드 저장 정보 UPDATe
					sqlSessionTemplate.update("master.mprq.updateBulkQuotationtBuyer_1", formData);
					
					// KEP_BURQ_RFQ에 반영 되어 있는 부분 업데이트
					sqlSessionTemplate.update("master.mprq.updateBulkQuotationtBuyer_2", formData);
				}
				if(formData.get("STATUS").equals("N")){ // 신규추가
					sqlSessionTemplate.update("master.mprq.insertBulkQuotationtBuyer", formData);
				}
				if(formData.get("STATUS").equals("D")){ // 삭제
					sqlSessionTemplate.update("master.mprq.deleteBulkQuotationtBuyer", formData);
				}
			}
			
		} catch (Exception e){
			LOGGER.error("SQL ERROR : ", e);
				throw new RuntimeException("유의사항 저장에 실패하였습니다.");
		}
		return _rtnMsg;

	}

}
