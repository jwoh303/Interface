package com.koreab2b.mro.master.cmcl.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.util.CommonUtil;

@Repository("masterCmClSalesTaxsheetRemarkUploadDao")
@Transactional
public class MasterCmClSalesTaxsheetRemarkUploadDaoImpl implements MasterCmClSalesTaxsheetRemarkUploadDao {
	private static final Logger LOGGER = LoggerFactory.getLogger(MasterCmClSalesTaxsheetRemarkUploadDaoImpl.class);

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	
	// 리스트 조회
	@SuppressWarnings("unchecked")
	public List<Map<String,String>> selectList(Map<String,Object> param) {
		return sqlSessionTemplate.selectList("master.cmcl.selectMasterCmClSalesTaxsheetRemarkUploadList", param);
	}
	
	@SuppressWarnings("unchecked")
	public String batchMasterCmClSalesTaxsheetRemarkUpload(Map<String, String> param,List<Object> gridData) {
		
		String _rtnMsg = "저장완료 되었습니다.";
		int checkFlag = 0;
		String TAX_BILL_NO = "";
		String AMT = "";
		String TAX = "";
		
		try{
			param.put("DOC_NAME","AR_REMARK");
			param.put("ST_USER_ID", param.get("st_user_id"));
			
			// 기존 업로드건 삭제
			sqlSessionTemplate.update("master.cmcl.setBnttrxlUploadDel", param);
			
			for(int i=0; i < gridData.size(); i++){
				param.putAll((Map<String, String>)gridData.get(i));
				
				LOGGER.debug("batchMasterCmClSalesTaxsheetRemarkUpload param : {} ", param);
				
				// 빈값 체크
				TAX_BILL_NO = CommonUtil.nvl(param.get("TARGET"),"");
				AMT = CommonUtil.nvl(param.get("KEY_6"),""); 
				TAX = CommonUtil.nvl(param.get("KEY_7"),"");  
				
				if ("".equals(TAX_BILL_NO) || "".equals(AMT) || "".equals(TAX)){	
					checkFlag = 1;
					throw new RuntimeException();
				}
				
				LOGGER.debug("batchMasterCmClSalesTaxsheetRemarkUpload checkFlag : {} ", checkFlag);
				
				// 업로드
				sqlSessionTemplate.update("master.cmcl.setBnttrxlUploadReg", param);
			}
			
		} catch (Exception e){
			LOGGER.error("SQL ERROR : ", e);
			String msg = "저장에 실패하였습니다.";
			if (checkFlag==1){
				msg = "빈 값 없이 정확한 정보로 엑셀 업로드하세요.";
			}
				throw new RuntimeException(msg);
		}
		return _rtnMsg; 
	}
	
	@SuppressWarnings("unchecked")
	public String saveMasterCmClSalesTaxsheetRemarkUpload(Map<String, String> param,List<Object> gridData) {
		
		String _rtnMsg = "수정완료 되었습니다.";
		String bf_tax_bill_no = "";
		
		try{
			param.put("DOC_NAME", "AR_REMARK");
			param.put("ST_USER_ID", param.get("st_user_id"));
			
			
			for(int i=0; i < gridData.size(); i++){
				param.putAll((Map<String, String>)gridData.get(i));
				
				LOGGER.debug("saveMasterCmClSalesTaxsheetRemarkUpload1 param : {} ", param);

				// 리스트 중 새로운 세금계산서 번호 확인 시 기존 KEPTITEM 삭제 (KEPTARDT ADD_USER_ID 와 세션ID 일치건만 삭제)
				if(!bf_tax_bill_no.equals(param.get("TARGET"))){
					sqlSessionTemplate.update("master.cmcl.setKeptitemUploadDel", param);
				}

				// KEPTITEM 일괄 수정
				sqlSessionTemplate.update("master.cmcl.setKeptitemUploadReg", param);
				
				// 다음 비교할 세금계산서번호 저장
				bf_tax_bill_no = param.get("TARGET");
			}
			
			// 사용한 BNTTRXL 삭제
			LOGGER.debug("saveMasterCmClSalesTaxsheetRemarkUpload2 param : {} ", param);

			sqlSessionTemplate.update("master.cmcl.setBnttrxlUploadDel", param);
		} catch (Exception e){
			LOGGER.error("SQL ERROR : ", e);
			String msg = "수정에 실패하였습니다.";
			throw new RuntimeException(msg);
		}
		return _rtnMsg; 
	}
}
