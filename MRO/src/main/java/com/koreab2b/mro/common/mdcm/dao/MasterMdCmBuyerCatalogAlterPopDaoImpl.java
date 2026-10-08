package com.koreab2b.mro.common.mdcm.dao;

import java.io.File;
import java.io.IOException;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.io.FileUtils;
import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import com.koreab2b.mro.common.coco.controller.FileUploadForm;
import com.koreab2b.mro.master.mprq.dao.MasterMpRqBuyerReqDao;
import com.koreab2b.mro.util.CommonAwsS3;
import com.koreab2b.mro.util.CommonUtil;
import com.koreab2b.mro.util.ResultRowHandler;

@Repository("masterMdCmBuyerCatalogAlterPopDao")
@Transactional
public class MasterMdCmBuyerCatalogAlterPopDaoImpl implements MasterMdCmBuyerCatalogAlterPopDao {
	private static final Logger LOGGER = LoggerFactory.getLogger(MasterMdCmBuyerCatalogAlterPopDaoImpl.class);

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	@Autowired
	private MasterMpRqBuyerReqDao masterMpRqBuyerReqDao;
	private String _rtnMsg = "";

	// 조회
	public List<Map<String,String>> selectList(Map<String,Object> formData) {
		return sqlSessionTemplate.selectList("common.mdcm.selectMasterMdCmBuyerCatalogAlterPopList", formData);
	};
	
	// 상세조회
	public List<Map<String,String>> selectDetailList(Map<String,String> formData) {
		return sqlSessionTemplate.selectList("common.mdcm.selectMasterMdCmBuyerCatalogAlterPopDetailList", formData);
	};
	
	// CMS 담당자 여부 확인
	public String getCheckedCmsRoleUser(Map<String,String> formData){
		return sqlSessionTemplate.selectOne("common.mdcm.selectMasterMdCmCheckedCmsRoleUser", formData);
	};
	
	// 담당자 조회
	public List<Map<String,String>> selectUserSelectkorea(Map<String,String> formData){
		return sqlSessionTemplate.selectList("common.mdcm.selectMasterMdCmUserSelectkoreaList", formData);
	};
	
	// 상세조회
	public List<Map<String,String>> selectMsDsDetailList(Map<String,String> formData) {
		return sqlSessionTemplate.selectList("common.mdcm.selectMasterMdCmBuyerMsDsPopDetailList", formData);
	};
	
	// 납품가능조회
	public List<Map<String,String>> selectBtoaDetailList(Map<String,String> formData) {
		return sqlSessionTemplate.selectList("common.mdcm.selectMasterMdCmBuyerBtoaPopDetailList", formData);
	};	
	//저장
	@SuppressWarnings("unchecked")
	@Transactional(rollbackFor=Exception.class, propagation=Propagation.REQUIRED)
	public Map<String,String> saveSelectedData(Map<String,String>  formData, List<Object> gridData) {
		_rtnMsg = "정상적으로 저장 되었습니다.";
		/*
		String isFlag = "";
		String masterflag_check = ""
		String epCheck = "";
		*/
		String strStatus = "";
		String _restrcCnt = "0";
		String strApprovalYn = "";
		int index = 0;
		String _pm_no = null;
		int _pm_seq = 1;
		String dssChk = "Y";
		Map<String, String> pMap = new HashMap<String, String>();
		
		try{
			/*isFlag = formData.get("FLAG");
			masterflag_check = formData.get("st_masterflag_check");
			if(isFlag.equals("true")){
				_rtnMsg = "표준화 된 카탈로그 입니다.\n\n품명/규격/제조사/원산지/단위 수정은 CMS팀 요청 바랍니다.";
			}*/
			//품의여부.
			strApprovalYn = formData.get("st_approval_yn");
			if("Y".equals(strApprovalYn)){
				_rtnMsg = "계약추가 및 품목명/원산지/협력사/매출단가/매입단가/품목구분/표준납기일/단가유효일 변경 시에는 품의상신 하여야 합니다.\n (규격, 제조사, 단위 등 이외 정보들은 즉시 반영됩니다.)";
			}
			
			for(int i=0; i < gridData.size(); i++){
				Map<String, String> gridMap= (Map<String, String>) gridData.get(i);
				formData.putAll(gridMap);
				
				//epCheck = gridMap.get("EP_CHECK").toString();
				strStatus = gridMap.get("NEW_YN").toString();
				
				String[] _belowList = gridMap.get("BELOW_ARRAY").split("\\@");
				String belowChangeYn = gridMap.get("BELOW_CHANGE_YN").toString();
				
				
				//행추가로 저장 logic 실행
				//if(strStatus.equals("Y")){
					//sqlSessionTemplate.insert("common.mdcm.insertMasterMdCmBuyerCatalogAlterPop1", formData);
					//sqlSessionTemplate.update("common.mdcm.insertMasterMdCmBuyerCatalogAlterPop2", formData);
					//sqlSessionTemplate.update("common.mdcm.insertMasterMdCmBuyerCatalogAlterPop3", formData);
				
				//}else{ 
					//품의상신건은 저장을 하지 않음. 
					if(!"Y".equals(strApprovalYn)){
						//저장 process 실행.
						sqlSessionTemplate.update("common.mdcm.saveMasterMdCmBuyerCatalogAlterPop1", formData);
						/* 이력TABLE은 품의상신된 후에 처리되도록 변경. 
						if(epCheck.equals("Y")){
							sqlSessionTemplate.update("common.mdcm.saveMasterMdCmBuyerCatalogAlterPop2", formData);
							sqlSessionTemplate.update("common.mdcm.saveMasterMdCmBuyerCatalogAlterPop3", formData);
						}
						*/
						/* 제조사변경은 품의를 태우도록 변경.
						if(masterflag_check.equals("Y")) {	// 제조사 변경시 ICOMCQDT.ORIGIN_CODE, MAKER_CODE, MAKER_NAME 모두 수정
							sqlSessionTemplate.update("common.mdcm.saveMasterMdCmBuyerCatalogAlterPop4", formData);
						}
						*/
						sqlSessionTemplate.update("common.mdcm.saveMasterMdCmBuyerCatalogAlterPop5", formData);
						
						// 규격은 CQDT 일괄 변경 적용
						sqlSessionTemplate.update("common.mdcm.saveMasterMdCmBuyerCatalogAlterPop6", formData);
						//적용구분 수정했을때만 적용구분 process START
						if("Y".equals(belowChangeYn)){
							//본인data수정후 적용구분 적용 START
							for (int j=0; j < _belowList.length; j++) {
								formData.put("st_below_comorg_code",  _belowList[j]);
								
								//적용구분이 고객사와 동일하면 skip 
								if(!_belowList[j].equals(formData.get("st_buyer_code"))){
								
									_restrcCnt = sqlSessionTemplate.selectOne("common.mdcm.selectMasterMdCmICOMCQDTCntSave", formData);
									
									//건수가 없으면 ICOMCQDT insert, 있으면 update									
									
									if (Integer.parseInt(_restrcCnt)  > 0 ) { 
										sqlSessionTemplate.update("common.mdcm.updateMasterMdCmICOMCQDT", formData);
									}else{
										sqlSessionTemplate.insert("common.mdcm.insertMasterMdCmICOMCQDT1", formData);
										//이력 저장.
										formData.put("KEPMGPHD_REG_ID", formData.get("st_user_id"));
										sqlSessionTemplate.update("common.mdcm.insertMasterMdCmICOMCQDT2", formData);
									}
								}
							}
							//적용구분 END
						}
						
					}else{
						
						//제제업체 발생 시 오류 발생
						formData.put("AGENT", CommonUtil.nvl(formData.get("AGENT"), ""));
						formData.put("BUYER", CommonUtil.nvl(formData.get("BELOW_COMORG_CODE"), ""));
						dssChk = (String) sqlSessionTemplate.selectOne("master.mdcm.selectMasterMdCmCatalogRegBNot", formData);
						
						if(dssChk.equals("Y")) { // 제제대상 없으면
						
							++index;
		
							if (index == 1){
								pMap.put("COM_CODE", "KRKORE0001");
								pMap.put("DOC_TYPE", "PM");
								
								//sqlSessionTemplate.update("common.updateDocuNo", pMap);
								//sqlSessionTemplate.selectOne("common.getDocuNo", pMap);
								_pm_no =  masterMpRqBuyerReqDao.nextVal("KRKORE0001", "PM"); 
								formData.put("PM_NO", _pm_no);
								formData.put("NEW_YN", strStatus);
								
								sqlSessionTemplate.update("common.mdcm.insertCaKEPMGPHD", formData);
							}
							
							formData.put("PM_NO", _pm_no);
							formData.put("PM_SEQ", String.valueOf(_pm_seq));
							sqlSessionTemplate.update("common.mdcm.insertCaKEPMGPDT", formData);
							
							// 2025.11.04 카탈로그 조회 및 수정 화면에서 품의 상신 시 변경 안되는 정보 반영 -- GPDT로 변경 전 이력 확인을 위하여 GPDT insert이후 update
							sqlSessionTemplate.update("common.mdcm.saveMasterMdCmBuyerCatalogAlterPop1", formData);
							
							sqlSessionTemplate.update("common.mdcm.saveMasterMdCmBuyerCatalogAlterPop5", formData);
							
							// 규격은 CQDT 일괄 변경 적용
							sqlSessionTemplate.update("common.mdcm.saveMasterMdCmBuyerCatalogAlterPop6", formData);
							
							_pm_seq++;
						} else {
							throw new RuntimeException("제제업체(협력사) 입니다.\n"+formData.get("BUYER") +"<->" +formData.get("AGENT"));
						}						
				//}
					}
				LOGGER.error("saveMasterMdCmBuyerCatalogAlterPop 실행 완료");

			}
		}catch(Exception e){
			LOGGER.error("SQL ERROR : ", e);
			if(dssChk.equals("Y")) {
				throw new RuntimeException("저장이 실패하였습니다. 다시 확인하여 주십시요. ");
			} else {
				throw new RuntimeException(e.getMessage());
			}
		}
		
		pMap.put("MSG", _rtnMsg);
		pMap.put("PM_NO", _pm_no);
		return pMap;	
	};
	

	// 삭제
	@SuppressWarnings("unchecked")
	@Transactional(rollbackFor=Exception.class, propagation=Propagation.REQUIRED)
	public String deleteSelectedData(Map<String,String>  formData, List<Object> gridData) {
		
		_rtnMsg = "삭제가 정상적으로 이루어 졌습니다. ";
		
		try{
			for(int i=0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));		
				
				sqlSessionTemplate.update("common.mdcm.deleteMasterMdCmBuyerCatalogAlterPop1", formData);
				sqlSessionTemplate.update("common.mdcm.deleteMasterMdCmBuyerCatalogAlterPop2", formData);
				LOGGER.error("deleteMasterMdCmBuyerCatalogAlterPop 실행 완료");

			}
		}catch(Exception e){
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("삭제 실패하였습니다. 다시 확인하여 주십시요. ");
		}

		return _rtnMsg;		
		
	};
	
	// 삭제취소
	@SuppressWarnings("unchecked")
	@Transactional(rollbackFor=Exception.class, propagation=Propagation.REQUIRED)
	public String deleteCancelSelectedData(Map<String,String>  formData, List<Object> gridData) {
		
		_rtnMsg = "사용처리가 정상적으로 이루어 졌습니다. ";
		
		try{
			for(int i=0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));		
				
				sqlSessionTemplate.update("common.mdcm.deleteCancelMasterMdCmBuyerCatalogAlterPop1", formData);
				sqlSessionTemplate.update("common.mdcm.deleteCancelMasterMdCmBuyerCatalogAlterPop2", formData);
				LOGGER.error("deleteCancelMasterMdCmBuyerCatalogAlterPop 실행 완료");

			}
		}catch(Exception e){
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("사용처리가 실패하였습니다. 다시 확인하여 주십시요. ");
		}

		return _rtnMsg;		
		
	};
	
	// 승인/승인취소
	@SuppressWarnings("unchecked")
	@Transactional(rollbackFor=Exception.class, propagation=Propagation.REQUIRED)
	public String confirmSelectedData(Map<String,String>  formData, List<Object> gridData) {
		
		String strProductFlag = "";
		String strText = "";
		
		try{
			strProductFlag = formData.get("st_product_flag").toString();
			if(strProductFlag.equals("N")){
				strText = "승인";
			}else {
				strText = "미승인 또는 단종";
			}
			_rtnMsg = strText+"처리가 정상적으로 이루어 졌습니다. ";
			
			for(int i=0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));		
				if("N".equals(strProductFlag)){
					sqlSessionTemplate.update("common.mdcm.confirmMasterMdCmBuyerCatalogAlterPop1", formData);
				}
				sqlSessionTemplate.update("common.mdcm.confirmMasterMdCmBuyerCatalogAlterPop2", formData);
				LOGGER.error("confirmMasterMdCmBuyerCatalogAlterPop 실행 완료");

			}
		}catch(Exception e){
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException( strText+"처리가 실패하였습니다. 다시 확인하여 주십시요. ");
		}

		return _rtnMsg;		
		
	};
	
	// 이미지등록
	public String addCatalogImagePop(FileUploadForm uploadForm, Map<String,String> pMap) {
		
		List<MultipartFile> _files = uploadForm.getFiles();
		
		String osName = System.getProperty("os.name");
		String _newDir = CommonUtil.formatDate(new Date(),0,"");
		String _path = CommonUtil.realImgUploadRegisterPath+"/" +_newDir;
		 //DB에 저장할 상대경로
		 String _relativePath = "ITEM_IMAGE/"+_newDir;
		
		 String docNo = pMap.get("st_catalog_com_code")+"_"+pMap.get("st_buyer_item_no");

		 File f = new File(_path); 
			if(!f.isDirectory()) {
	            f.mkdirs();
	            LOGGER.debug("폴더생성 {} " ,f);
	        }else{
	        	 LOGGER.debug("폴더이미존재 {} " ,f);
	        }
		 
		if (null != _files && _files.size() > 0) {
			LOGGER.debug("_files.size()  {} " ,_files.size()); 
			for (MultipartFile _multipartFile : _files) {

				String _fileName = _multipartFile.getOriginalFilename();
				String _exc = "." + _fileName.substring(_fileName.lastIndexOf(".")+1, _fileName.length());
				if(_fileName.isEmpty()) continue;
				
				String UniqFileName = docNo;
				
				File _destFile = new File(_path + "/" + UniqFileName+ "r"+_exc);		
				LOGGER.debug("_path : "+_path);
				if ("".equals(_fileName)) {
					LOGGER.debug("_fileName null ");
				} else {
					try {
						//파일이 존재하면 삭제함.
						if (_destFile.exists()){
							_destFile.delete();
						}
						//MultipartFile multi = CommonUtil.makeThumbnail(_multipartFile, 500, 500); //이미지 리사이징 2023.01.27 현명환
						CommonAwsS3.upload(_multipartFile, _path+ "/" , UniqFileName+_exc); //multi -> _multipartFile  2023.01.27 현명환
					} catch (IOException e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					}
				}
				
				/*
				 * 기존 이미지를 가로,세로길이에 맞게 변경한다.
				 * 예제임니다...추후 사용하세요.
				 * CommonUtil.makeThumbnail
				 */
				
				pMap.put("st_imgfile_dir", _relativePath);
				pMap.put("st_imgfile_name", UniqFileName+_exc);
				sqlSessionTemplate.update("common.mdcm.updateIcombyitImage",pMap);
			}//end of for
		}
		
		return docNo;
	};
	
	// 이미지 삭제
	public String delCatalogImagePop(Map<String,String>  formData) {
		
		try{

			formData.put("st_imgfile_dir", "");
			formData.put("st_imgfile_name", "");
			sqlSessionTemplate.update("common.mdcm.updateIcombyitImage",formData);

		} catch (Exception e){
			LOGGER.error("SQL ERROR : ", e);
				throw new RuntimeException("이미지 삭제 중 오류가 발생하였습니다.");
		}
		return _rtnMsg;
	}
	
	// 표준화 여부 확인
	public String getIsModifyCatalogCheckedByBusinessTeam(Map<String,String> formData){
		return sqlSessionTemplate.selectOne("common.mdcm.selectIsModifyCatalogCheckedByBusinessTeam", formData);
	};
	
	// 카탈로그변경 요청 후 처리(CA)
	public String caRequest(Map<String,String> formData){
		
		return "OK";
	}
	
	// 카탈로그변경 결재 상신취소 후 처리(CA)
	public String caCancel(Map<String,String> formData){
		
		formData.put("DOC_NAME", formData.get("DOC_TYPE").toString());
        Map<String, String> _pMap = sqlSessionTemplate.selectOne("commonApproval.getPassWisehubNo",formData);        
		
		_pMap.put("STATUS", "D");
		
		// STEP1
		sqlSessionTemplate.update("master.mprq.updateCancelKEPMGPHD", _pMap);
		// STEP2
		sqlSessionTemplate.update("master.mprq.updateCancelKEPMGPDT", _pMap);
        
		return "OK";
	}
	
	// 카탈로그변경 결재 승인 후 처리(CA)
	public String caApproval(Map<String,String> formData){
		
		formData.put("DOC_NAME", formData.get("DOC_TYPE").toString());
        Map<String, String> _pMap = sqlSessionTemplate.selectOne("commonApproval.getPassWisehubNo",formData);
		
        // 결재 요청자 정보 불러오기
     	String KEPMGPHD_REG_ID = _pMap.get("REG_USER_ID");
     	// 결재 요청자 정보 세팅
     	_pMap.put("KEPMGPHD_REG_ID", KEPMGPHD_REG_ID);
        
        _pMap.put("STATUS", "A");
        _pMap.put("USER_ID", formData.get("USER_ID"));
        _pMap.put("USER_DEPT", formData.get("USER_DEPT"));
        _pMap.put("USER_NAME", formData.get("USER_NAME"));
        _pMap.put("USER_TEL", formData.get("USER_TEL"));
		String st_buyer = formData.get("KEY_2");
		//해당 고객사 매출단가 변경이 안됨. 삼성전자,삼성전기 로직
		if(st_buyer.equals("KRSAMS0123")||st_buyer.equals("KRSAMS0192")){
			// STEP1
			sqlSessionTemplate.update("common.mdcm.updateCaApprovalICOMCQDT2", _pMap);//KEPMGPDT.BUYER
		}else{
			// STEP1
			sqlSessionTemplate.update("common.mdcm.updateCaApprovalICOMCQDT", _pMap);			
		}
		//CQDT 품목정보 추가 업데이트
		sqlSessionTemplate.update("common.mdcm.updateCaApprovalItemCQDT", _pMap);
		// STEP2
		sqlSessionTemplate.update("common.mdcm.updateCaApprovalICOMBYIT", _pMap);
		// STEP3
		sqlSessionTemplate.update("master.mprq.updateApprovalKEPMGPHD", _pMap);
		// STEP4
		sqlSessionTemplate.update("master.mprq.updateApprovalKEPMGPDT", _pMap);
		
		//HISTORY 기록
		sqlSessionTemplate.update("common.mdcm.updateCaApprovalICOMCQEP", _pMap);
		//해당 고객사 매출단가 변경이 안됨. 삼성전자 로직
		if(st_buyer.equals("KRSAMS0123")||st_buyer.equals("KRSAMS0192")){
			sqlSessionTemplate.update("common.mdcm.insertCaApprovalICOMCQEP2", _pMap);//KEPMGPDT.BUYER
			//I/F전송 로직
			sqlSessionTemplate.update("common.mdcm.insertCaApprovalEaiItemInfo", _pMap);
		}else{//삼성전자(KRSAMS0123)는 판매단가는 고객사 confirm 이후 변경 되기 때문에 외화단가 변경 필요 없음.
			sqlSessionTemplate.update("common.mdcm.insertCaApprovalICOMCQEP", _pMap);
			//외화단가 정보 업데이트
			sqlSessionTemplate.update("common.mdcm.updateCaApprovalKEPCURRENCYDT", _pMap);
			//외화단가 이력 insert
			sqlSessionTemplate.update("common.mdcm.insertCaApprovalKEPCURRENCYDT_HIST", _pMap);
		}		
		//적용구분이 존재하는 dataList를 SELECT
		List<Map<String,String>> dtList = sqlSessionTemplate.selectList("common.mdcm.selectCaApprovalDtList", _pMap);
		int dtCnt = dtList.size();
		String _restrcCnt = "0";
		//해당 고객사 매출단가 변경이 안됨. 삼성전자 로직
		if(st_buyer.equals("KRSAMS0123")||st_buyer.equals("KRSAMS0192")){
			dtCnt = 0;
		}
		for(int i = 0; i < dtCnt; i++){
			Map<String, String> dtMap = dtList.get(i);
			dtMap.put("st_catalog_com_code", dtMap.get("BUYER"));
			dtMap.put("st_buyer_item_no", dtMap.get("BUYER_ITEM_NO"));
			dtMap.put("st_re_agent", dtMap.get("RE_AGENT"));
			dtMap.put("UNIT_PRICE_CHANGE_REASON", CommonUtil.nvl(dtMap.get("UNIT_PRICE_CHANGE_REASON")));
			dtMap.put("LIST_PRICE_CHANGE_REASON", CommonUtil.nvl(dtMap.get("LIST_PRICE_CHANGE_REASON")));
			
			String[] _belowList = dtMap.get("BELOW_LIST").split("\\@");
			
			//본인data수정후 적용구분 적용 START
			for (int j=0; j < _belowList.length; j++) {
				dtMap.put("st_below_comorg_code",  _belowList[j]);
				dtMap.put("st_user_id", formData.get("USER_ID"));
				dtMap.put("KEPMGPHD_REG_ID", KEPMGPHD_REG_ID);
				
				//이미 적용된 DATA는 skip 
				if(!_belowList[j].equals(dtMap.get("BELOW_COMORG_CODE")) ){
				
					_restrcCnt = sqlSessionTemplate.selectOne("common.mdcm.selectMasterMdCmICOMCQDTCnt", dtMap);
					
					//건수가 없으면 ICOMCQDT insert, 있으면 update
					if (Integer.parseInt(_restrcCnt)  > 0 ) { 
						//ICOMCQDT 테이블 UPDATE
						sqlSessionTemplate.update("common.mdcm.updateCaApprovalIBelowCOMCQDT", dtMap);
						
						//HISTORY 기록
						sqlSessionTemplate.update("common.mdcm.updateCaApprovalIBelowCOMCQEP", dtMap);
						sqlSessionTemplate.update("common.mdcm.insertCaApprovalIBelowCOMCQEP", dtMap);
					}else{
						//ICOMCQDT 테이블 신규INSERT
						sqlSessionTemplate.insert("common.mdcm.insertMasterMdCmICOMCQDT1", dtMap);
						
						dtMap.put("BEF_UNIT_PRICE", String.valueOf(dtMap.get("CH_UNIT_PRICE")));
						dtMap.put("BEF_LIST_PRICE", String.valueOf(dtMap.get("CH_LIST_PRICE")));
						dtMap.put("BEF_AGENT", dtMap.get("AGENT"));
						dtMap.put("st_description", dtMap.get("CH_DESCRIPTION"));
						dtMap.put("st_specification", dtMap.get("CH_SPECIFICATION"));
						dtMap.put("st_unit_measure", dtMap.get("CH_UNIT_MEASURE"));
						dtMap.put("BEF_ORIGIN_CODE", dtMap.get("CH_ORIGIN_CODE"));
						dtMap.put("BEF_MAKER_NAME", dtMap.get("CH_MAKER_NAME"));
						dtMap.put("CH_SELL_CLOSE_DATE", dtMap.get("CH_SELL_CLOSE_DATE"));
						dtMap.put("CH_BUY_CLOSE_DATE", dtMap.get("CH_BUY_CLOSE_DATE"));
						
						//HISTORY 기록
						sqlSessionTemplate.update("common.mdcm.insertMasterMdCmICOMCQDT2", dtMap);
					}
				}
			}
			//적용구분 END
		}
		
		return "OK";
	}
	
	// 카탈로그계약추가 결재 승인 후 처리(CCA)
	public String approvalAppendCqdt(Map<String,String> formData){
		
		formData.put("DOC_NAME", formData.get("DOC_TYPE").toString());
        Map<String, String> _pMap = sqlSessionTemplate.selectOne("commonApproval.getPassWisehubNo",formData);
		
        _pMap.put("STATUS", "A");
        _pMap.put("USER_ID", formData.get("USER_ID"));
        _pMap.put("USER_DEPT", formData.get("USER_DEPT"));
        _pMap.put("USER_NAME", formData.get("USER_NAME"));
        _pMap.put("USER_TEL", formData.get("USER_TEL"));
        // STEP1
		sqlSessionTemplate.insert("common.mdcm.insertMasterMdCmBuyerCatalogAlterAprroval1", _pMap);
		// STEP2		
		sqlSessionTemplate.insert("common.mdcm.insertMasterMdCmBuyerCatalogAlterAprroval2", _pMap);
		// STEP3
		sqlSessionTemplate.update("master.mprq.updateApprovalKEPMGPHD", _pMap);
		// STEP4
		sqlSessionTemplate.update("master.mprq.updateApprovalKEPMGPDT", _pMap);
		
		return "OK";
	}
	
	// IF발주댄기 단가 UPDATE(IF)
	public String approvalIfPrice(Map<String,String> formData){
		
		formData.put("DOC_NAME", formData.get("DOC_TYPE").toString());
        Map<String, String> _pMap = sqlSessionTemplate.selectOne("commonApproval.getPassWisehubNo",formData);
		
        _pMap.put("STATUS", "A");
        _pMap.put("USER_ID", formData.get("USER_ID"));
        _pMap.put("USER_DEPT", formData.get("USER_DEPT"));
        _pMap.put("USER_NAME", formData.get("USER_NAME"));
        _pMap.put("USER_TEL", formData.get("USER_TEL"));
        // STEP1
		sqlSessionTemplate.insert("common.mdcm.updateApprovalICOMPRDT", _pMap);
		// STEP2
		sqlSessionTemplate.update("master.mprq.updateApprovalKEPMGPHD", _pMap);
		// STEP3
		sqlSessionTemplate.update("master.mprq.updateApprovalKEPMGPDT", _pMap);
		
		return "OK";
	}
	// 카탈로그변경 결재 반려 후 처리(CA) , (CAM)
	public String caReject(Map<String,String> formData){
		
		formData.put("DOC_NAME", formData.get("DOC_TYPE").toString());
        Map<String, String> _pMap = sqlSessionTemplate.selectOne("commonApproval.getPassWisehubNo",formData);
		
        _pMap.put("STATUS", "B");
        _pMap.put("USER_ID", formData.get("USER_ID"));
        
		// STEP1
        sqlSessionTemplate.update("master.mprq.updateRejectKEPMGPHD", _pMap);
		// STEP2
        sqlSessionTemplate.update("master.mprq.updateRejectKEPMGPDT", _pMap);
		
		return "OK";
	}
	public List<Map<String,String>> caResultList(Map<String,String> param) {
		return sqlSessionTemplate.selectList("common.mdcm.selectCaResultList", param);
	}
	//카탈로그 상태변경 리스트
	public List<Map<String,String>> caStResultList(Map<String,String> param) {
		return sqlSessionTemplate.selectList("common.mdcm.selectCaStResultList", param);
	}
	// 이미지 상세등록
	public String addCatalogImageDetailPop(FileUploadForm uploadForm, Map<String,String> pMap) {
		
		List<MultipartFile> _files = uploadForm.getFiles2();
		
		String osName = System.getProperty("os.name");
		String _newDir = CommonUtil.formatDate(new Date(),0,"");
		String _path = CommonUtil.realImgUploadRegisterPath+"/" +_newDir;
		 //DB에 저장할 상대경로
		 String _relativePath = "ITEM_IMAGE/"+_newDir;
		
		 String docNo = pMap.get("st_buyer_item_no")+"_DESC";

		 File f = new File(_path); 
			if(!f.isDirectory()) {
	            f.mkdirs();
	            LOGGER.debug("폴더생성 {} " ,f);
	        }else{
	        	 LOGGER.debug("폴더이미존재 {} " ,f);
	        }
		 
		if (null != _files && _files.size() > 0) {
			LOGGER.debug("_files.size()  {} " ,_files.size()); 
			for (MultipartFile _multipartFile : _files) {

				String _fileName = _multipartFile.getOriginalFilename();
				String _exc = "." + _fileName.substring(_fileName.lastIndexOf(".")+1, _fileName.length());
				if(_fileName.isEmpty()) continue;
				
				String UniqFileName = docNo;
				
				File _destFile = new File(_path + "/" + UniqFileName+_exc);		
				LOGGER.debug("_path : "+_path);
				if ("".equals(_fileName)) {
					LOGGER.debug("_fileName null ");
				} else {
					try {
						//파일이 존재하면 삭제함.
						if (_destFile.exists()){
							_destFile.delete();
						}
						CommonAwsS3.upload(_multipartFile, _path+ "/" , UniqFileName+_exc);
					} catch (IOException e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					}
				}
				
				/*
				 * 기존 이미지를 가로,세로길이에 맞게 변경한다.
				 * 예제임니다...추후 사용하세요.
				 * CommonUtil.makeThumbnail
				 */
				//CommonUtil.makeThumbnail(_path + "/" + UniqFileName+ "r"+_exc, _path + "/" + UniqFileName+_exc, 500, 500);
				
				pMap.put("st_imgfile_dir", _relativePath);
				pMap.put("st_imgfile_name", UniqFileName+_exc);
				sqlSessionTemplate.update("common.mdcm.updateIcombyitDetailImage",pMap);
			}//end of for
		}
		
		return docNo;
	};
	// 물질정보요청
	@SuppressWarnings("unchecked")
	@Transactional(rollbackFor=Exception.class, propagation=Propagation.REQUIRED)
	public String reqMasterMdCmSellerChemicalMat(Map<String,String>  formData, List<Object> gridData) {
		_rtnMsg = "물질정보 요청 처리 완료했습니다.";
		try{
			for(int i=0; i < gridData.size(); i++){
				String reqNo =  getReqNo("KRKORE0001","CM");
				formData.put("reqNo",  reqNo);
				formData.putAll((Map<String, String>)gridData.get(i));
				sqlSessionTemplate.update("common.mdcm.reqMasterMdCmSellerChemicalMat", formData);
				LOGGER.error("reqMasterMdCmSellerChemicalMat 실행 완료");
			}
		}catch(Exception e){
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("물질정보 요청 실패하였습니다. 다시 확인하여 주십시요. ");
		}
		return _rtnMsg;		
	};
	//채번
	public String getReqNo(String comCode, String docType){
		String orderNo = "";
		Map<String,String> _map = new HashMap<String,String>();
		try{
			_map.put("st_com_code", comCode);
			_map.put("st_doc_type", docType);
			orderNo = CommonUtil.nvl((String)sqlSessionTemplate.selectOne("buyer.wmgr.selectBuyerWmGrWarehousingGrNo", _map));
			if(orderNo.equals("")){
				sqlSessionTemplate.insert("buyer.wmgr.insertBuyerWmGrWarehousingGrNo", _map);
				orderNo = "" + Calendar.getInstance().get(Calendar.YEAR);
				orderNo = _map.get("st_doc_type") + orderNo.substring(2,4) + "000001";
			} else {
				sqlSessionTemplate.update("buyer.wmgr.updateBuyerWmGrWarehousingGrNo", _map);
			}
		}catch(Exception e){
			throw new RuntimeException("잠재고객사 코드 생성 중 에러가 발생하였습니다.");
		}
		return orderNo;
	}
	// 재계약 관리 품의상신
	public String rctRequest(Map<String,String> formData){
		try{
			sqlSessionTemplate.update("common.mdcm.updateMdCmrctRequest",formData);
		} catch (Exception e){
			LOGGER.error("SQL ERROR : ", e);
				throw new RuntimeException("재계약 품의상신 중 오류가 발생하였습니다.");
		}
		return "OK";
	}
	// 재계약 결재화면 조회
	@SuppressWarnings("unchecked")
	public List<Map<String,String>> approvalRctListPop(Map<String,String> formData) {
		String pageflag = (String) formData.get("pageflag");
		ResultRowHandler _resultHander = new ResultRowHandler();
		List<Map<String, String>> resultList = null;
		if("0".equals(pageflag)){
			sqlSessionTemplate.select("common.mdcm.selectApprovalRctListPop", formData, _resultHander);
			resultList = (List<Map<String, String>>)_resultHander.getList();
		}else{
			resultList =  sqlSessionTemplate.selectList("common.mdcm.selectApprovalRctListPop", formData);
		}
		return resultList;
	}
	//재계약 단가 유효기간 변경 결재처리. (RCT)
	public String  rctApproval(Map<String, String> param) {
		String _rtnMsg = "결재완료 되었습니다.";
		param.put("DOC_NAME", param.get("DOC_TYPE").toString());
        Map<String, String> _pMap = sqlSessionTemplate.selectOne("commonApproval.getPassWisehubNo",param);
		_pMap.put("STATUS", "A");
		// STEP1
		sqlSessionTemplate.update("master.mdcm.call_PROC_KEPRCDT_UPDATE", _pMap);
		// STEP2
		sqlSessionTemplate.update("master.mprq.updateApprovalKEPMGPHD", _pMap);
		// STEP3
		sqlSessionTemplate.update("master.mprq.updateApprovalKEPMGPDT", _pMap);
		return _rtnMsg; 
	}
	// 재계약 단가 유효기간 변경 반려처리. (RCT)
	public String rctReject(Map<String,String> formData){
		
		formData.put("DOC_NAME", formData.get("DOC_TYPE").toString());
        Map<String, String> _pMap = sqlSessionTemplate.selectOne("commonApproval.getPassWisehubNo",formData);
		
        _pMap.put("STATUS", "B");
        _pMap.put("USER_ID", formData.get("USER_ID"));
		// STEP1
		sqlSessionTemplate.update("master.mdcm.call_PROC_KEPRCDT_RETURN", _pMap);
		// STEP2
        sqlSessionTemplate.update("master.mprq.updateRejectKEPMGPHD", _pMap);
		// STEP3
        sqlSessionTemplate.update("master.mprq.updateRejectKEPMGPDT", _pMap);
		
		return "OK";
	}
	// 카탈로그 상태 변경
	public String caStApproval(Map<String,String> formData){
		
		formData.put("DOC_NAME", formData.get("DOC_TYPE").toString());
        Map<String, String> _pMap = sqlSessionTemplate.selectOne("commonApproval.getPassWisehubNo",formData);
        _pMap.put("STATUS", "A");
        _pMap.put("USER_ID", formData.get("USER_ID"));
        _pMap.put("USER_DEPT", formData.get("USER_DEPT"));
        _pMap.put("USER_NAME", formData.get("USER_NAME"));
        _pMap.put("USER_TEL", formData.get("USER_TEL"));
		// STEP1
		sqlSessionTemplate.update("master.mdcm.call_PROC_CATALOG_STATUS_UPDATE", _pMap);
		// STEP2
		sqlSessionTemplate.update("master.mprq.updateApprovalKEPMGPHD", _pMap);
		// STEP3
		sqlSessionTemplate.update("master.mprq.updateApprovalKEPMGPDT", _pMap);
		return "OK";
	}
	
	// 보관조건 저장
	public String saveCatalogTempCond(Map<String,String>  formData) {
		try{
			sqlSessionTemplate.update("common.mdcm.updateIcombyitTempCond",formData);

		} catch (Exception e){
			LOGGER.error("SQL ERROR : ", e);
				throw new RuntimeException("보관조건 저장 중 오류가 발생하였습니다.");
		}
		return _rtnMsg;
	}
}
