package com.koreab2b.mro.master.mpif.dao;

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
import com.koreab2b.mro.util.ResultRowHandler;

@Repository("masterMpIfOrderCreateDao")
@Transactional
public class MasterMpIfOrderCreateDaoImpl implements MasterMpIfOrderCreateDao {
	private static final Logger LOGGER = LoggerFactory.getLogger(MasterMpIfOrderCreateDaoImpl.class);

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	private String _rtnMsg = "";
	
	// 리스트 조회
	@SuppressWarnings("unchecked")
	public List<Map<String,String>> selectList(Map<String,Object> param) {
	    ResultRowHandler _resultHander = new ResultRowHandler();
	    List<Map<String, String>> resultList = null;

		sqlSessionTemplate.select("master.mpif.selectMasterMpIfOrderCreateList", param, _resultHander);
		resultList = (List<Map<String, String>>)_resultHander.getList();

		return resultList;
	}

	// 실행
	@SuppressWarnings("unchecked")
	@Transactional(rollbackFor=Exception.class, propagation=Propagation.REQUIRED)
	public String executeDataList(Map<String,String>  formData, List<Object> gridData) {
	
		_rtnMsg = "정상적으로 실행되었습니다.";
		Map<String, Object> resultMap = null;
		int errCode = 0;
		
		try{
			
//			resultMap = sqlSessionTemplate.selectOne("master.mpif.getMasterMpIfOrderCreateErrorCount", formData);
//			if(!(resultMap.get("CNT").toString()).equals("0")){
//				System.out.println(resultMap.get("CNT").toString());
//				System.out.println(resultMap.get("CNT").toString().equals("0"));
//				System.out.println((resultMap.get("CNT").toString()).equals("0"));
//				errCode = 1;
//				throw new RuntimeException();
//			}
			
			sqlSessionTemplate.insert("master.mpif.executeMasterMpIfOrderCreate", formData);
			sqlSessionTemplate.update("master.mpif.updateMasterMpIfOrderFlag", formData);
			
		}catch(Exception e) {
			LOGGER.error("SQL ERROR : ", e);
			
			if(errCode == 1){
				_rtnMsg = "실행 대상건 중 오류 건이 있습니다. 확인후 재실행 하시기바립니다.";
			}else{
				_rtnMsg = "실행 중 오류가 발생하였습니다.";
			}
			
			throw new RuntimeException(_rtnMsg);
		}
		return _rtnMsg;
	}
	
	
	// 저장
	@SuppressWarnings("unchecked")
	@Transactional(rollbackFor=Exception.class, propagation=Propagation.REQUIRED)
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData) {
		
		String _jobKind = formData.get("job_kind");
		String _checkResult = "";
		try {
			
			if ( "save".equals(_jobKind) ) {
				_rtnMsg = "정상적으로 저장되었습니다.";
				
				for ( int i=0; i < gridData.size(); i++ ) {
					formData.putAll((Map<String, String>)gridData.get(i));
					
					if(formData.get("STATUS").equals("1")){
						throw new RuntimeException("발주생성 중인 경우 저장 불가능 합니다.");
					}

					sqlSessionTemplate.update("master.mpif.updateMasterMpIfOrderCreate", formData);
					
					_checkResult = checkErrSelectedData(formData);
					
					if(_checkResult.equals("Error")){
						throw new RuntimeException("검증 중 에러 발생");
					}else if(!_checkResult.equals("")){
						formData.put("ERROR_MSG", _checkResult);
						formData.put("IF_FLAG", "E");
					}else{
						formData.put("ERROR_MSG", "");
						formData.put("IF_FLAG", "N");
					}
					
					sqlSessionTemplate.update("master.mpif.updateMasterMpIfOrderFlagNErrormsg", formData);
				}
			}
			
		} catch (Exception e) {
			LOGGER.error("SQL ERROR : ", e);
			
			if ( e instanceof RuntimeException ) {
				throw new RuntimeException(e.getMessage());
			}
			
			if ( "save".equals(_jobKind) ) {
				throw new RuntimeException("\n\n- 저장 실패 -\n\n담당자에게 연락 바랍니다.");
			}
		}
		
		return _rtnMsg;
	}
	
	
	// 삭제
	@SuppressWarnings("unchecked")
	@Transactional(rollbackFor=Exception.class, propagation=Propagation.REQUIRED)
	public String deleteSelectedData(Map<String,String>  formData, List<Object> gridData) {
		
		_rtnMsg = "정상적으로 삭제 되었습니다";
		
		try {
			for ( int i=0; i < gridData.size(); i++ ) {
				formData.putAll((Map<String, String>)gridData.get(i));		
				
				// 오류 현황 메인 update
				sqlSessionTemplate.update("master.mpif.deleteMasterMpIfOrderCreate", formData);
			}
		} catch(Exception e) {
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("\n\n- 삭제 실패 -\n\n담당자에게 연락 바랍니다.");
		}

		return _rtnMsg;		
	}	
	
	@SuppressWarnings("unchecked")
	@Transactional(rollbackFor=Exception.class, propagation=Propagation.REQUIRED)
	public String updateSelectedDataExcelCheck(Map<String, String> formData, List<Object> gridData) {
		
		_rtnMsg = "업로드가 완료되었습니다.";
		String _checkResult = "";
		String st_com_code = "";
		String BUYER = "";
		String LEGACY_PO_NO = "";
		String LEGACY_PO_SEQ = "";
		String BUYER_ITEM_NO = "";
		String ITEM_QTY = "";
		String PURCHASER_USER_ID = "";
		String PO_DATE = "";
		String RD_DATE = "";
		String CURRENCY_CODE = "";
		String UNIT_PRICE_IF = "";
		int errCode = 0;
		List<Map<String,Object>> itemInfo = null;
		List<Map<String,Integer>> unitPrice = null;
		try{
			for(int i=0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));
			
				formData.put("CONTRACT_NO", "");
				formData.put("CONTRACT_SEQ", "");
				formData.put("COMORG_CODE", "");
				formData.put("PROCESS_TYPE", "");
				formData.put("UNIT_PRICE", "");
				formData.put("UNIT_MEASURE", "");
				formData.put("AGENT", "");
				if(!("").equals(formData.get("REMARK"))) {
					if(isDouble(formData.get("REMARK"))) {
						formData.put("REMARK", Double.toString(Math.round(Double.parseDouble(formData.get("REMARK"))*100)/100.0));
					}
				}
				
				LOGGER.debug("updateSelectedDataExcelCheck  formData {} " , formData);
				
				st_com_code = CommonUtil.nvl(formData.get("st_com_code"),"");
				BUYER = CommonUtil.nvl(formData.get("st_com_code"),"");
				LEGACY_PO_NO = CommonUtil.nvl(formData.get("LEGACY_PO_NO"),"");
				LEGACY_PO_SEQ = CommonUtil.nvl(formData.get("LEGACY_PO_SEQ"),"");
				BUYER_ITEM_NO = CommonUtil.nvl(formData.get("BUYER_ITEM_NO"),"");
				ITEM_QTY = CommonUtil.nvl(formData.get("ITEM_QTY"),"");
				PURCHASER_USER_ID = CommonUtil.nvl(formData.get("PURCHASER_USER_ID"),"");
				PO_DATE = CommonUtil.nvl(formData.get("PO_DATE"),"");
				RD_DATE = CommonUtil.nvl(formData.get("RD_DATE"),"");
				CURRENCY_CODE = CommonUtil.nvl(formData.get("CURRENCY_CODE"),"");
				UNIT_PRICE_IF = CommonUtil.nvl(formData.get("UNIT_PRICE_IF"),"");
				
				// 필수값 체크
				System.out.println(BUYER+"/"+LEGACY_PO_NO+"/"+LEGACY_PO_SEQ+"/"+BUYER_ITEM_NO+"/"+ITEM_QTY+"/"+PURCHASER_USER_ID+"/"+PO_DATE+"/"+RD_DATE+"/"+UNIT_PRICE_IF+"/"+CURRENCY_CODE);
				if("".equals(BUYER)
						|| "".equals(LEGACY_PO_NO)
						|| "".equals(LEGACY_PO_SEQ)
						|| "".equals(BUYER_ITEM_NO)
						|| "".equals(CURRENCY_CODE)
						|| "".equals(UNIT_PRICE_IF)
						|| "".equals(ITEM_QTY)
						|| "".equals(PURCHASER_USER_ID)
						|| "".equals(PO_DATE)
						|| "".equals(RD_DATE)){
					errCode = 1;
					throw new RuntimeException();
				}
					
				// 고객사코드 체크. 선택 고객사와 업로드 데이터의 고객사가 다른경우.
				if(!st_com_code.equals(BUYER)){
					errCode = 2;
					throw new RuntimeException();
				}
				
				// 허용 고객사 체크
				List<Map<String,Object>> chkCompany = null;
				chkCompany = sqlSessionTemplate.selectList("master.mpif.getMasterMpIfOrderCreateComcodeCheck",formData);
				if(chkCompany.size()>0){
					if( "0".equals(chkCompany.get(0).get("CNT").toString()) ){
						errCode = 4;
						throw new RuntimeException();
					}
				}
				
				itemInfo = sqlSessionTemplate.selectList("master.mpif.getMasterMpIfOrderCreateItemInfo",formData);
				
				if(itemInfo.size()>0){
					formData.put("CONTRACT_NO", itemInfo.get(0).get("CONTRACT_NO").toString());
					formData.put("CONTRACT_SEQ", itemInfo.get(0).get("CONTRACT_SEQ").toString());
					formData.put("COMORG_CODE", itemInfo.get(0).get("COMORG_CODE").toString());
					formData.put("PROCESS_TYPE", itemInfo.get(0).get("PROCESS_TYPE").toString());
					//formData.put("UNIT_PRICE", itemInfo.get(0).get("UNIT_PRICE").toString());
					formData.put("UNIT_MEASURE", itemInfo.get(0).get("UNIT_MEASURE").toString());
					formData.put("AGENT", itemInfo.get(0).get("AGENT").toString());
				}
				
				if("KRSAMS0168".equals(formData.get("BUYER")) && "0".equals(formData.get("UNIT_PRICE_IF"))) {					
					unitPrice = sqlSessionTemplate.selectList("master.mpif.getCqdtUnitPrice",formData);
					if(unitPrice.size() == 1) {
						formData.put("UNIT_PRICE_IF", String.valueOf(unitPrice.get(0).get("UNIT_PRICE")));
					}else {
						formData.put("UNIT_PRICE_IF", "0");						
					}
				}
				// 테스트를 위한 조건 추가
				if("KRKEPB0004".equals(formData.get("BUYER")) && "0".equals(formData.get("UNIT_PRICE_IF"))) {					
					unitPrice = sqlSessionTemplate.selectList("master.mpif.getCqdtUnitPrice",formData);
					if(unitPrice.size() == 1) {
						formData.put("UNIT_PRICE_IF", String.valueOf(unitPrice.get(0).get("UNIT_PRICE")));
					}else {
						formData.put("UNIT_PRICE_IF", "0");						
					}
				}
				
				// 도착지 특수로직(자동 채번)
				List<Map<String,Object>> chkLocation = null;
				String chkLocationFlag = "N";
				
				chkLocation = sqlSessionTemplate.selectList("master.mpif.getDelyToLocationSlg",formData);
				if(chkLocation.size()>0){
					if(Integer.parseInt(chkLocation.get(0).get("CNT").toString()) > 0){
						chkLocationFlag = "Y";
					}
				}
				
				formData.put("D_CHK", chkLocationFlag);
												
//				if(chkLocationFlag.equals("Y")){
//					
//					formData.put("DELY_TO_LOCATION_TEXT", itemInfo.get(0).get("DELY_TO_LOCATION").toString());
//					
//					formData.put("DELY_TO_LOCATION", "ZZZ");
//					
//				}
				
				/*삭제 중복제거*/
				sqlSessionTemplate.update("master.mpif.deleteMasterMpIfOrderCreate", formData);
				
				/*인서트*/
				sqlSessionTemplate.update("master.mpif.saveMasterMpIfOrderCreate",formData);
				
				_checkResult = checkErrSelectedData(formData);
				
				if(_checkResult.equals("Error")){
					errCode = 3;
					throw new RuntimeException();
				}else if(!_checkResult.equals("")){
					formData.put("ERROR_MSG", _checkResult);
					formData.put("IF_FLAG", "E");
				}else{
					formData.put("ERROR_MSG", "");
					formData.put("IF_FLAG", "N");
				}
				System.out.println("ERROR MSG : "+_checkResult);
				sqlSessionTemplate.update("master.mpif.updateMasterMpIfOrderFlagNErrormsg", formData);

			}
			
		} catch (Exception e){
			LOGGER.error("SQL ERROR : ", e);
			
			if(errCode == 1){
				throw new RuntimeException("필수값이 누락되었습니다.");
			}else if(errCode == 2){
				throw new RuntimeException("선택된 고객사와 업로드데이터의 고객사가 다릅니다.");
			}else if(errCode == 3){
				throw new RuntimeException("데이터 검증에 실패하였습니다.");
			}else if(errCode == 4){
				throw new RuntimeException("I/F발주 생성 허용된 고객사가 아닙니다.");
			}else{
				throw new RuntimeException("엑셀 검증에 실패하였습니다.");
			}
			
		}
		
		return _rtnMsg;
	}
		
	/*검증*/
	@SuppressWarnings("unchecked")
	public String checkErrSelectedData(Map<String, String> formData) {

		String _errMsg = "";
		
		List<Map<String, String>> resultList = null;
		try {
			// 오류 현황 메인 update
			resultList = sqlSessionTemplate.selectList("master.mpif.getMasterMpIfOrderCreateErrCount", formData);
			if(resultList.size()>0){
				System.out.println(resultList.get(0).get("BUYER_ITEM_ERR_FLAG")
						+"/"+resultList.get(0).get("PURCHASER_USER_ID_ERR_FLAG")
						+"/"+resultList.get(0).get("UNIT_PRICE_ERR_FLAG"));
				if((resultList.get(0).get("BUYER_ITEM_ERR_FLAG")).equals("Y")){
					_errMsg += "품목코드 미등록. ";
				}
				if((resultList.get(0).get("PURCHASER_USER_ID_ERR_FLAG")).equals("Y")){
					_errMsg += "발주자 미등록. ";
				}
				if((resultList.get(0).get("UNIT_PRICE_ERR_FLAG")).equals("Y")){
					_errMsg += "단가 불일치. ";
				}
			}
			
		} catch(Exception e) {
			LOGGER.error("SQL ERROR : ", e);
			_errMsg = "Error";
		}

		return _errMsg;		
	}
	
	/*Double 타입 체크*/
	public static boolean isDouble(String strVal) {
		try {
			Double.parseDouble(strVal);
			return true;
		}catch (NumberFormatException ex) {
			return false;
		}
	}

}
