package com.koreab2b.mro.common.mpds.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.buyer.mdam.dao.BuyerMdAmBudgetDaoImpl;

@Repository("masterMpDsPckpaprDesignCropProtectManagePopDao")
@Transactional
public class MasterMpDsPckpaprDesignCropProtectManagePopDaoImpl implements MasterMpDsPckpaprDesignCropProtectManagePopDao {
	private static final Logger logger = LoggerFactory.getLogger(BuyerMdAmBudgetDaoImpl.class);

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

    
	// 조회
	public List<Map<String,String>> selectList(Map<String,String> formData) {
		return sqlSessionTemplate.selectList("common.mpds.selectMasterMpDsPckpaprDesignCropProtectManagePopList", formData);
	}
	
	//바코드 부여
	public String selectBarCode(Map<String,String> formData) {
		String _rtnMsg = "바코드가 부여되었습니다.";
		/*프로시저 실행*/
		try{
			sqlSessionTemplate.selectOne("common.mpds.SP_BARCODE", formData);
		}catch(Exception e){
			logger.error("SQL ERROR : ", e);
			throw new RuntimeException("저장에 실패하였습니다.");
		}
		return _rtnMsg;
	}
	
	
	//저장
	public String updateReg(Map<String, String> formData) {
		
		String _rtnMsg = "저장이 성공적으로 이루어 졌습니다.";
		
	try{
			formData = setCompleteDate(formData);
			
			if("MOD".equals(formData.get("st_chRemark_flag"))){	//도안반려후 비고수정
				sqlSessionTemplate.update("common.mpds.setSysopDongBuOrderPackingRemarkUpdate_1", formData);
				sqlSessionTemplate.update("common.mpds.setSysopDongBuOrderPackingRemarkUpdate_2", formData);
			}else {
				sqlSessionTemplate.update("common.mpds.setSysopDongBuOrderPackingSaveUpdate", formData);
			}

			//첨부파일 유효성 활성화(GABAGE_FLAG 를 'Y' 로 변경)
			formData.put("DOC_NO", formData.get("st_image_key"));
			sqlSessionTemplate.update("common.fileUploadFlagUpdate", formData);
			
		}catch(Exception e){
			logger.error("SQL ERROR : ", e);
			throw new RuntimeException("저장에 실패하였습니다.");
		}
		return _rtnMsg;
	}

	//저장MM
	public String updateRegMM(Map<String, String> formData) {
		
		String _rtnMsg = "저장이 성공적으로 이루어 졌습니다.";
		
	try{
			formData = setCompleteDate(formData);
			sqlSessionTemplate.update("common.mpds.setBuyerDongBuOrderPackingSaveUpdate", formData);
			
			//첨부파일 유효성 활성화(GABAGE_FLAG 를 'Y' 로 변경) 
			formData.put("DOC_NO", formData.get("st_image_key"));
			sqlSessionTemplate.update("common.fileUploadFlagUpdate", formData);

		}catch(Exception e){
			logger.error("SQL ERROR : ", e);
			throw new RuntimeException("저장에 실패하였습니다.");
		}
		return _rtnMsg;
	}
	
	//종결
	public String updateReg01(Map<String, String> formData) {
		
		String _rtnMsg = "정상적으로 수정이 이루어 졌습니다.";
		
		try{
			formData = setCompleteDate(formData);
			sqlSessionTemplate.update("common.mpds.masterUpdateReg01", formData);
		}catch(Exception e){
			logger.error("SQL ERROR : ", e);
			throw new RuntimeException("수정이 실패하였습니다. 다시 확인하여 주십시요.");
		}
		return _rtnMsg;
	}
	
	private Map<String,String> setCompleteDate(Map<String,String> formData){
	    int mm = 0; //마케팅 완료
	    int dd = 0; //문안 완료
	    int ee = 0; //디자인 완료
	    int es = 0; //최종 확정
	    
		String gubun_flag = formData.get("st_gubun_flag");
			
       if(gubun_flag.equals("NW")) { //신규
            mm = 2;    //마케팅 완료  2일
            dd = mm+4; //문안 완료    4일
            ee = dd+5; //디자인 완료  5일
            es = ee+2; //최종 확정    2일
       }else {
            mm = 2;    //마케팅 완료  2일
            dd = mm+2; //문안 완료    2일
            ee = dd+3; //디자인 완료  3일
            es = ee+2; //최종 확정    2일
       }
       
       formData.put("st_mm_date", String.valueOf(mm));
       formData.put("st_dd_date", String.valueOf(dd));
       formData.put("st_ee_date", String.valueOf(ee));
       formData.put("st_es_date", String.valueOf(es));

		return formData;
	}
}
