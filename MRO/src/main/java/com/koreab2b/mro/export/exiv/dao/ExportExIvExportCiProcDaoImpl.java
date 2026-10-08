package com.koreab2b.mro.export.exiv.dao;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.util.CommonUtil;
import com.koreab2b.mro.util.ResultRowHandler;

@Repository("exportExIvExportCiProcDao")
@Transactional
public class ExportExIvExportCiProcDaoImpl implements ExportExIvExportCiProcDao {
	private static final Logger logger = LoggerFactory.getLogger(ExportExIvExportCiProcDaoImpl.class);

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	private String _rtnMsg = "";
	
	// 리스트 조회
	@SuppressWarnings("unchecked")
	public List<Map<String,String>> selectList(Map<String,Object> param) {
		List< String > _list = new ArrayList< String >( );
		_list = CommonUtil.getStringArrary((String) param.get("st_buyer_code"),"@");
		if(_list.size() > 0){
			param.put("st_buyerArr", _list);
		}
	    List<Map<String, String>> resultList = null;
	    if("0".equals(param.get("pageflag"))){
		    ResultRowHandler _resultHander = new ResultRowHandler();
			sqlSessionTemplate.select("export.exiv.selectExportExIvExportCiProcList", param,_resultHander);
			resultList = (List<Map<String, String>>)_resultHander.getList();
	    }
	    else{
	    	resultList = sqlSessionTemplate.selectList("export.exiv.selectExportExIvExportCiProcList", param);
	    }
		return resultList;
	}
	// CI Item 추가등록 대상 조회
	public List<Map<String,String>> selectItemList(Map<String,Object> param) {
		return sqlSessionTemplate.selectList("export.exiv.selectExportExIvExportCiItemList", param);
	}
	// 입고등록
	@SuppressWarnings("unchecked")
	public String updateSelectedHdData(Map<String,String>  formData, List<Object> gridData) {
		
		_rtnMsg = "입고등록 처리가 되었습니다.";
		String _grCnt = null;
		try{
			for(int i = 0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));
				// 입고등록 전 입고가능수량 체크 후 INSERT
				_grCnt = (String)sqlSessionTemplate.selectOne("export.exiv.selectExportExivPkgGrQtyHdCheck", formData);
				logger.debug("_grCnt ==>> " + _grCnt);
				if(Integer.parseInt(_grCnt) > 0){
					_rtnMsg = (i+1)+"번째 입고 등록건 입니다.\n 재조회 후 다시 등록하시기 바랍니다.";
				} else {
					logger.debug("PROCESS_TYPE ==>> " +formData.get("PROCESS_TYPE"));	
					if(formData.get("PROCESS_TYPE").equals("0")){
						sqlSessionTemplate.insert("export.exiv.updateExportExIvExportCiProcHd", formData);
					}else{
						sqlSessionTemplate.insert("export.exiv.updateExportExIvExportCiProcTrHd", formData);						
					}
				}
			}
		} catch (Exception e){
			logger.error("SQL ERROR : ", e);
			if(_rtnMsg.equals("")){
				_rtnMsg = "입고등록에 실패하였습니다.";
			}
			throw new RuntimeException(_rtnMsg);
		}
		return _rtnMsg;
	}
	
	// 리스트 상세 조회
	public List<Map<String,String>> selectDetailList(Map<String,Object> param) {

		return sqlSessionTemplate.selectList("export.exiv.selectExportExIvExportCiProcDetail", param);
	}
	
	// icomcod2 조회팝업
	public List<Map<String,String>> selectExportExIvIcomCodPop(Map<String,Object> param) {

		return sqlSessionTemplate.selectList("export.exiv.selectExportExIvIcomCodPop", param);
	}
	
	// C/L, P/L 등록
	@SuppressWarnings("unchecked")
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData) {
		
		_rtnMsg = "OK";
		String _grCnt = null;
		double _exp_amt  = 0;
		double _exp_weight  = 0;
		double _exp_p_weight  = 0;
		try{
			String ciNo =  formData.get("st_ci_no");
			for(int i = 0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));
				// 입고등록 전 입고가능수량 체크 후 INSERT
				_grCnt = (String)sqlSessionTemplate.selectOne("export.exiv.selectExportExIvKepExpCheck", formData);
				logger.debug("_grCnt ==>> " + _grCnt);
				if(Integer.parseInt(_grCnt) > 0){
					_rtnMsg = (i+1)+"번째 C/I 수량 초과 되어 생성 불가능 합니다.\n 재조회 후 다시 등록하시기 바랍니다.";
					throw new RuntimeException(_rtnMsg);
				} else {
					logger.debug("PROCESS_TYPE ==>> " +formData.get("PROCESS_TYPE"));	
					formData.put("CI_NO", ciNo);
					formData.put("CI_SEQ", String.valueOf(i+1));
					//외화 total 금액
					logger.debug("EXP_FOR_UNIT_PRICE : {}", formData.get("EXP_FOR_UNIT_PRICE"));
					logger.debug("PKG_CI_QTY : {}", formData.get("PKG_CI_QTY"));
					_exp_amt  = (Double.parseDouble(formData.get("EXP_FOR_UNIT_PRICE")) * Double.parseDouble(formData.get("PKG_CI_QTY")))+_exp_amt;
					logger.debug("_exp_amt ==>> " +String.valueOf(_exp_amt));
					logger.debug("G_WEIGHT ==>> " +formData.get("G_WEIGHT"));
					//총무게
					_exp_weight  = Double.parseDouble(CommonUtil.nvl(formData.get("G_WEIGHT"),"0")) +_exp_weight;
					logger.debug("N_WEIGHT ==>> " +formData.get("N_WEIGHT"));
					//총무게
					_exp_p_weight  = Double.parseDouble(CommonUtil.nvl(formData.get("N_WEIGHT"),"0")) +_exp_p_weight;					
					logger.debug("_exp_weight ==>> " +String.valueOf(_exp_weight));
					//INSERT KEP_EXP_CIDT
					sqlSessionTemplate.insert("export.exiv.insertExportExIvKepExpDt", formData);
					//CI 출고 수량 업데이트
					if(formData.get("PROCESS_TYPE").equals("0")){
						//ICOMIVDT PKG_CI_QTY 수량 업데이트
						sqlSessionTemplate.insert("export.exiv.updateExportExIvExportIcomivdt", formData);
					}else{
						//WMSIVDT PKG_CI_QTY 수량 업데이트
						sqlSessionTemplate.insert("export.exiv.updateExportExIvExportWmsivdt", formData);						
					}
					//LOT 정보 입력
					String lotInfo = CommonUtil.nvl(formData.get("LOT"),"");
					String  _lotInfoFormat[] = lotInfo.split("@@");
					if(!lotInfo.equals("")){
						logger.debug("_lotInfoFormat.length : {}", _lotInfoFormat.length);
						 if (_lotInfoFormat.length >0){
							 logger.debug("lotInfo : {}", lotInfo);
							 for( int j=0 ; j< _lotInfoFormat.length; j++){ 
								 Map<String,String> _dataDetailParam = null;
								_dataDetailParam = new HashMap<String,String>() ;
								logger.debug("_lotInfoFormat[j] : {}", _lotInfoFormat[j]);
								String str[] =  _lotInfoFormat[j].split("__");
								logger.debug("str[0] : {}", str[0]);
								logger.debug("str[1] : {}", str[1]);
								logger.debug("str[2] : {}", str[2]);
								_dataDetailParam.put("PKG_COMPANY_CODE", formData.get("st_pkg_cmpy_no"));
								_dataDetailParam.put("BUYER", formData.get("BUYER"));
								_dataDetailParam.put("AGENT", formData.get("AGENT"));
								_dataDetailParam.put("CI_NO", ciNo);
								_dataDetailParam.put("CI_SEQ", String.valueOf(i+1));
								_dataDetailParam.put("LOT_NO", str[0]);
								_dataDetailParam.put("LOT_SEQ", String.valueOf(j+1));
								_dataDetailParam.put("BUYER_ITEM_NO", formData.get("BUYER_ITEM_NO"));
								_dataDetailParam.put("LOT_QTY", str[1]);
								_dataDetailParam.put("PRODUCTION_DAY", str[2]);
								_dataDetailParam.put("st_user_id", formData.get("st_user_id"));
								sqlSessionTemplate.insert("export.exiv.insertExportExIvKepExpLotInfo", _dataDetailParam);
							 }
						 }
					}
					formData.put("EXP_AMT", String.valueOf(_exp_amt));
					formData.put("EXP_WEIGHT", String.valueOf(_exp_weight));
					formData.put("EXP_N_WEIGHT", String.valueOf(_exp_p_weight));
					formData.put("st_notify_party",CommonUtil.nvl(formData.get("st_notify_party"), " ")); // 삼성전자 이외 고객사 빈값처리 -> NOT NULL컬럼으로 " " 빈문자열로 변경
					//INSERT KEP_EXP_CIHD 마지막
					logger.debug("gridData.size()-1 : {}", gridData.size()-1);
					if(i==gridData.size()-1){
						sqlSessionTemplate.insert("export.exiv.insertExportExIvKepExpHd", formData);
					}
				}
			}
		} catch (Exception e){
			logger.error("SQL ERROR : ", e);
			if(_rtnMsg.equals("")){
				_rtnMsg = "C/I 등록에 실패하였습니다.";
			}
			throw new RuntimeException(_rtnMsg);
		}
		return _rtnMsg;
	}
	//채번
	public String getOrderNo(String comCode, String docType){

		String orderNo = "";
		Map<String,String> _map = new HashMap<String,String>();
		
		try{
			
			_map.put("st_com_code", comCode);
			_map.put("st_doc_type", docType);
			
			// 기존 고객사화면에서 사용하는 쿼리 사용
			orderNo = CommonUtil.nvl((String)sqlSessionTemplate.selectOne("buyer.wmgr.selectBuyerWmGrWarehousingGrNo", _map));
			
			if(orderNo.equals("")){
				sqlSessionTemplate.insert("buyer.wmgr.insertBuyerWmGrWarehousingGrNo", _map);
				
				orderNo = "" + Calendar.getInstance().get(Calendar.YEAR);
				orderNo = _map.get("st_doc_type") + orderNo.substring(2,4) + "000001";
				
			} else {
				sqlSessionTemplate.update("buyer.wmgr.updateBuyerWmGrWarehousingGrNo", _map);
			}
			
			
		}catch(Exception e){
			logger.error("SQL ERROR : ", e);
			throw new RuntimeException("입고번호 생성 중 에러가 발생하였습니다.");
		}
		
		return orderNo;
	}
	// 입고취소
	@SuppressWarnings("unchecked")
	public String cancleExportExIvExportReceipt(Map<String,String>  formData, List<Object> gridData) {
		
		_rtnMsg = "OK";
		String _grCnt = null;
		try{
			for(int i = 0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));
				logger.debug("PROCESS_TYPE ==>> " +formData.get("PROCESS_TYPE"));	
				if(formData.get("PROCESS_TYPE").equals("0")){
					_grCnt = (String)sqlSessionTemplate.selectOne("export.exiv.selectExportExIvExpCiDtCheck", formData);
					if(Integer.parseInt(_grCnt) > 0){
						_rtnMsg = (i+1)+"번째 C/I 생성건이 존재 합니다.\n 해당건 삭제 후 취소처리 바랍니다.";
					}else{
						sqlSessionTemplate.insert("export.exiv.updateExportExIvExpCiDtCancle", formData);	
					}
				}else{
					_grCnt = (String)sqlSessionTemplate.selectOne("export.exiv.selectExportExIvExpCiDtCheck", formData);
					if(Integer.parseInt(_grCnt) > 0){
						_rtnMsg = (i+1)+"번째 C/I 생성건이 존재 합니다.\n 해당건 삭제 후 취소처리 바랍니다.";
					}else{
						sqlSessionTemplate.insert("export.exiv.updateExportExIvExpCiDtCancleTr", formData);	
					}
				}
			}
		} catch (Exception e){
			logger.error("SQL ERROR : ", e);
			if(_rtnMsg.equals("")){
				_rtnMsg = "입고취소 실패하였습니다.";
			}
			throw new RuntimeException(_rtnMsg);
		}
		return _rtnMsg;
	}
	// CI 중복 체크
	public String selectCICheck(Map<String,String> formData) {
		String _rtnMsg = "NO";
		
		try {
			String idFlag = sqlSessionTemplate.selectOne("export.exiv.selectExportExIvExportCICheck", formData);
			
			if (Integer.parseInt(idFlag) == 0) {
				_rtnMsg = "OK";
			}
			
		} catch (Exception e){
			throw new RuntimeException("CI번호 중복 입니다.");
		}
		return _rtnMsg;
	}
}
