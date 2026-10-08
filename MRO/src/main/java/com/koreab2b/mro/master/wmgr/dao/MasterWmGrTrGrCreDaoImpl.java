package com.koreab2b.mro.master.wmgr.dao;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Calendar;
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

import com.koreab2b.mro.common.mpiv.service.SellerMpIvTranStatementWritePopService;
import com.koreab2b.mro.util.CommonUtil;
import com.koreab2b.mro.util.ResultRowHandler;

import doosan.bean.DetailBean;
import doosan.bean.HeaderBean;
import doosan.bean.InterfaceBean;
import doosan.info.Constant;
import doosan.svc.DoosanInterfaceService;



@Repository("masterWmGrTrGrCreDao")
@Transactional
public class MasterWmGrTrGrCreDaoImpl implements MasterWmGrTrGrCreDao {
	private static final Logger LOGGER = LoggerFactory.getLogger(MasterWmGrTrGrCreDaoImpl.class);

	@Autowired
	private SellerMpIvTranStatementWritePopService sellerMpIvTranStatementWritePopService;
	
	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	private String _rtnMsg = "";
	
	// 리스트 조회
	@SuppressWarnings("unchecked")
	public List<Map<String,String>> selectList(Map<String,Object> param) {
		List<String> buyerParam;
		List<String> agnetrParam;
		List<String> invoParam;
		buyerParam = Arrays.asList( ((String)param.get("st_buyer_code")).split("@"));
		agnetrParam = Arrays.asList( ((String)param.get("st_agent_code")).split("@"));
		invoParam = Arrays.asList( ((String)param.get("st_iv_no_barcode")).split(","));
		
		// 품목코드
		if(!param.get("st_po_no_multi").equals("")){
			List<String> item_list = CommonUtil.getStringArrary((String) param.get("st_po_no_multi"), "@");
			param.put("st_po_no_multi", item_list);	
		}
		
	    if(invoParam.size() >0 )
	    {
	    	param.put("invoParam",invoParam);
	    	param.put("invoCnt","1");
	    }
	    if(buyerParam.size() >1 || !"".equals((String)param.get("st_buyer_code")) )
	    {
	    	param.put("buyerParam",buyerParam);
	    	param.put("buyerCnt","1");
	    }
	    if(agnetrParam.size() >1 || !"".equals((String)param.get("st_agent_code")) )
	    {
	    	param.put("agnetrParam",agnetrParam );
	    	param.put("agentCnt","1");
	    }
	    List<Map<String, String>> resultList = null;
	    if("0".equals(param.get("pageflag"))){
		    ResultRowHandler _resultHander = new ResultRowHandler();
			sqlSessionTemplate.select("master.wmgr.selectMasterWmGrTrGrCreList", param,_resultHander);
			resultList = (List<Map<String, String>>)_resultHander.getList();
	    }
	    else{
	    	resultList = sqlSessionTemplate.selectList("master.wmgr.selectMasterWmGrTrGrCreList", param);
	    }

		return resultList;
	}

	
	// 리스트 조회
	public List<Map<String,String>> selectPop(Map<String,String> param) {


		return sqlSessionTemplate.selectList("master.wmgr.selectMasterWmGrTrGrCreDelayList", param);
	}
	
	
	// 출고지시
	@SuppressWarnings("unchecked")
	public String updateSelectedDataIvt(Map<String,String>  formData, List<Object> gridData) {
		
		_rtnMsg = "GR_IK_OK";
		try{
			String di_ivk_list = "";
			List<Map<String,String>>_list2 = null;
			for(int i=0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));
				
				//PO_SEQ, INV_SEQ, INV_QTY 조회sqlSessionTemplate
				//처리대상 조회 
				List<Map<String,Object>>  _rtnList = sqlSessionTemplate.selectList("master.wmgr.selectMasterWmGrTrGrCreICOMIVDT", formData);
				
				//여신한도 초과시 수주접수 불가능.
				_list2 = sqlSessionTemplate.selectList("master.wmgr.selectMasterWmGrCreditLimitOrderCheck",formData);
				String credit_limit_flag = CommonUtil.getListKeyValue(_list2,"CREDIT_LIMIT_FLAG","");
				if(credit_limit_flag.equals("Y")){
					_rtnMsg = "입고처리만 되었으며, 출고지시가 불가능한 상태입니다. \n"+CommonUtil.getListKeyValue(_list2,"USER_NAME_LOC","")+" ("
							+CommonUtil.getListKeyValue(_list2,"PHONE_NUMBER","")+")"+ "담당자에게 문의바랍니다.";
					throw new RuntimeException(_rtnMsg);
				}
				
				String orderno ="";
				//송장번호 생성을 위한 조회 
				List<Map<String,Object>>  _rtnListorderno= sqlSessionTemplate.selectList("master.wmgr.selectMasterWmGrTrGrCreORDERNO", formData);
				//현재 Company 코드에 해당하는 type의 코드가 존재하지 않는 경우 새로 번호를 생성한다.
				if(_rtnListorderno.size() !=1)
				{
					sqlSessionTemplate.update("master.wmgr.insertMasterWmGrTrGrCreIcomsqmt", formData);
	                int year_num = Calendar.getInstance().get(Calendar.YEAR);
	                String year_str = String.valueOf(year_num);
	                orderno = "IK"+year_str.substring(2,4) + "000001";
				}
				else
				{
					sqlSessionTemplate.update("master.wmgr.updateMasterWmGrTrGrCreIcomsqmt", formData);
					orderno = _rtnListorderno.get(0).get("ORDERNO").toString();
				}
				
				
				
				//처리대상 건수만큼 
				for(int j= 0 ; j<_rtnList.size() ; j++)
				{
					formData.put("PO_NO", _rtnList.get(j).get("PO_NO").toString());
					formData.put("BUYER", _rtnList.get(j).get("BUYER").toString());
					formData.put("PO_SEQ", _rtnList.get(j).get("PO_SEQ").toString());
					formData.put("INV_SEQ", _rtnList.get(j).get("INV_SEQ").toString());
					formData.put("INV_QTY", _rtnList.get(j).get("INV_QTY").toString());
					formData.put("INV_NO", _rtnList.get(j).get("INV_NO").toString());
					if(j==0)
					{
						//효성SAP
						//if("KRHYOS0033".equals(formData.get("BUYER")) || "KRHYOS0034".equals(formData.get("BUYER")) || "KRHYOS0036".equals(formData.get("BUYER")) ||"KRHYOS0037".equals(formData.get("BUYER")) )
						//SLOGIC-BEGIN(P08-0000003-02)
						if(CommonUtil.getSpecialCheckReturn(formData.get("BUYER"),"P08-0000003-02"))
						{
							try{
								List<Map<String,Object>>  _rtnListLegacyIvSerial = sqlSessionTemplate.selectList("master.wmgr.selectMasterWmGrTrGrCreILegacyIvSerialHyosungSAP", formData);
								formData.put("LEGACY_IV_SERIAL",_rtnListLegacyIvSerial.get(0).get("LEGACY_IV_SERIAL").toString());
								
							}catch(Exception e){
								_rtnMsg = "효성 송장 차수(LEGACY_IV_SERIAL) 생성시  에러가 발생 하였습니다";
								throw new RuntimeException("효성 송장 차수(LEGACY_IV_SERIAL) 생성시  에러가 발생 하였습니다.");
							}
						
						}//SLOGIC-END 
						//else if("KRSSAN0025".equals(formData.get("BUYER")))
						//SLOGIC-BEGIN(P08-0000003-04)
						else if(CommonUtil.getSpecialCheckReturn(formData.get("BUYER"),"P08-0000003-04"))
						{
							try{
								List<Map<String,Object>>  _rtnListLegacyIvSerial = sqlSessionTemplate.selectList("master.wmgr.selectMasterWmGrTrGrCreILegacyIvSerialSsangyong", formData);
								formData.put("LEGACY_IV_SERIAL",_rtnListLegacyIvSerial.get(0).get("LEGACY_IV_SERIAL").toString());
								
							}catch(Exception e){
								_rtnMsg = "쌍용자동차 송장 차수(LEGACY_IV_SERIAL) 생성시 에러가 발생 하였습니다.";
								throw new RuntimeException("쌍용자동차 송장 차수(LEGACY_IV_SERIAL) 생성시 에러가 발생 하였습니다.");
							}

						}//SLOGIC-END 
						//SLOGIC-BEGIN(P08-0000003-05)
						else if(CommonUtil.getSpecialCheckReturn(formData.get("BUYER"),"P08-0000003-05"))
						{
							try{
								List<Map<String,Object>>  _rtnListLegacyIvSerial = sqlSessionTemplate.selectList("master.wmgr.selectMasterWmGrTrGrCreILegacyIvSerialLTAL", formData);
								formData.put("LEGACY_IV_SERIAL",_rtnListLegacyIvSerial.get(0).get("LEGACY_IV_SERIAL").toString());
								
							}catch(Exception e){
								_rtnMsg = "롯데알미늄 송장번호(LEGACY_IV_SERIAL) 생성시 에러가 발생 하였습니다.";
								throw new RuntimeException("롯데알미늄 송장번호(LEGACY_IV_SERIAL) 생성시 에러가 발생 하였습니다.");
							}

						}//SLOGIC-END 
						else
						{
							formData.put("LEGACY_IV_SERIAL","");
						}
					}
					
					
					//WMSIVDT INSERT					
					//물류센터 송장 INSERT
					try{
						formData.put("INV_SEQ_I", String.valueOf(j+1));
						formData.put("orderno", orderno);
						sqlSessionTemplate.update("master.wmgr.insertMasterWmGrTrGrCreWMSIVDT", formData);
						
						// 출고예정일 변경 ICOMPORS BUYER_DS_DATE UPDATE
						sqlSessionTemplate.update("common.wmgi.updateMasterWmGiDstbtrICOMPORS", formData);
						
					}catch(Exception se)	{
						
						_rtnMsg = "송장생성중(WMS INSERT INTO WMSIVDT) 에러가 발생하였습니다.";
						throw new RuntimeException("송장생성중(WMS INSERT INTO WMSIVDT) 에러가 발생하였습니다.");
					}
					
					
					try{
						   //update ICOMPODT 발주 DETAIL
						   sqlSessionTemplate.update("master.wmgr.insertMasterWmGrTrGrCreICOMPODT", formData);
						   
					}catch(Exception se)	{
						
						_rtnMsg = "송장생성중(WMS UPDATE ICOMPODT) 에러가 발생하였습니다.";
						throw new RuntimeException("송장생성중(WMS UPDATE ICOMPODT) 에러가 발생하였습니다.");
					}

					
					try{
						
						//update ICOMIVDT 협력사 송장 
						sqlSessionTemplate.update("master.wmgr.insertMasterWmGrTrGrCreICOMIVDT", formData);
						
					}catch(Exception se)	{
						
						_rtnMsg = "송장생성중(WMS UPDATE ICOMIVDT) 에러가 발생하였습니다..";
						throw new RuntimeException("송장생성중(WMS UPDATE ICOMIVDT) 에러가 발생하였습니다.");
						
					}
					

			
				}//처리대상 건수만큼 의 for 끝
				
				_rtnMsg  += "@@" + orderno;
				//두산인프라코어 반입시스템관련 I/F전송 대상 추출
				if("KRDHIM0002".equals(formData.get("BUYER")) || "KRDHIM0003".equals(formData.get("BUYER")) || "KRDHIM0006".equals(formData.get("BUYER" )) || "KRDHIM0005".equals(formData.get("BUYER" )) || "KRDIGU0001".equals(formData.get("BUYER" ))||
						 "KRDAEW0043".equals(formData.get("BUYER" )) ||  "KRDAEW0045".equals(formData.get("BUYER" ))|| "KRDOOS0020".equals(formData.get("BUYER" ))|| "KRDIVC0001".equals(formData.get("BUYER" ))|| "KRDIVC0002".equals(formData.get("BUYER" )) ){
					
					di_ivk_list +=formData.get("BUYER")+ "@@" + orderno + ":";
				
				}
				
				
	
			}//for 종료
			
			
			_rtnMsg += "$$"+di_ivk_list;
			
		} catch (Exception e){
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException(_rtnMsg);
		}
		
		return _rtnMsg;
		
	}

	
	// DOOSAN 저장 
	public String saveMasterWmGrTrGrCreDoosanIF(Map<String,String>  formData) {
		_rtnMsg = "";
		//String str[] = formData.get("st_ivk_list").split("^||^");

		Map<String ,String> _mp = new HashMap<String,String>();
		List<Map<String ,String>> _pWMSInvHdList = null;
		List<Map<String ,Object>> _pWMSInvDtList = null;
		Map<String ,String> _hdMap = new HashMap<String,String>();
		Map<String ,Object> _dtMap = new HashMap<String,Object>();
		Map<String ,String> _updateMap = new HashMap<String,String>();
		
		if("WMS_GR_IK".equals(formData.get("st_sys_type"))){
			
			List<String> st_ivk_list = Arrays.asList( (formData.get("st_ivk_list")).split(":"));
			LOGGER.debug( "form Data  saveMasterWmGrTrGrCreDoosanIF: "+formData);
			LOGGER.debug( "form Data  saveMasterWmGrTrGrCreDoosanIF  st_ivk_list: "+formData.get("st_ivk_list"));
			LOGGER.debug( "form Data  saveMasterWmGrTrGrCreDoosanIF  st_ivk_list.size(): "+st_ivk_list.size());
			
			
			for(int i=0 ; i<st_ivk_list.size();i++){
				
				LOGGER.debug(  "=====================================================" );
				LOGGER.debug(  st_ivk_list.get(i) );
				LOGGER.debug(  new StringBuilder("length").append(st_ivk_list.get(i).split("@@")[0]).toString()  );
				LOGGER.debug(  new StringBuilder("str").append(st_ivk_list.get(i).split("@@")[1]).toString()  );
				
				_mp.put("buyer", st_ivk_list.get(i).split("@@")[0]);
				_mp.put("inv_no", st_ivk_list.get(i).split("@@")[1]);
				_mp.put("st_warehouse_code", formData.get("st_warehouse_code"));
				_pWMSInvHdList = sqlSessionTemplate.selectList("master.wmgr.getWMSInvHdList", _mp);
				
				_pWMSInvDtList= sqlSessionTemplate.selectList("master.wmgr.getWMSInvDtList", _mp);
				
				String rValue = "";
				
				HeaderBean hdBean	=	new HeaderBean();
				List<DetailBean> dtList	=	new ArrayList<DetailBean>();
				InterfaceBean	ifBean	=	new InterfaceBean();	 
				
				_hdMap = _pWMSInvHdList.get(0);
				
				hdBean.setSYS_GUBN(_hdMap.get("SYS_GUBUN")); 
				hdBean.setBARCD_NO(_hdMap.get("BARCD_NO")); 
				hdBean.setMAN_EMPNO(_hdMap.get("MAN_EMPNO"));
				hdBean.setMAN_EMPNM(_hdMap.get("MAN_EMPNM"));
				hdBean.setREQ_DPTCD(_hdMap.get("REQ_DPTCD"));
				hdBean.setREQ_DPTNM(_hdMap.get("REQ_DPTNM"));
				hdBean.setREQ_DATE(_hdMap.get("REQ_DATE")); 
				hdBean.setINCOMP_NM(_hdMap.get("INCOMP_NM"));
				hdBean.setINCOMP_NO(_hdMap.get("INCOMP_NO"));
				hdBean.setSTATUS(_hdMap.get("STATUS"));
				hdBean.setCARRYIN_NO(_hdMap.get("CARRYIN_NO"));
				hdBean.setCHECK_GB(_hdMap.get("CHECK_GB"));

				ifBean.setHeaderBean( hdBean ); 
				
				for(int j= 0 ; j<_pWMSInvDtList.size() ;j++){
					
					DetailBean		dtBean	=	new DetailBean();
					
					_dtMap = _pWMSInvDtList.get(j);
					
					dtBean.setBARCD_NO(_dtMap.get("BARCD_NO_D").toString()); 	
					dtBean.setITEM(_dtMap.get("ITEM").toString());	 	
					dtBean.setITEM_NM(_dtMap.get("ITEM_NM").toString()); 	
					dtBean.setQTY(  ((BigDecimal)_dtMap.get("QTY")).toString()); 		
					dtBean.setUNIT(_dtMap.get("UNIT").toString());
					dtBean.setBIGO(_dtMap.get("BIGO").toString());
					dtBean.setPERIOD_DATE(_dtMap.get("PERIOD_DATE").toString()); 
					dtBean.setINAREA(_dtMap.get("INAREA").toString()); 		
					
					
					dtList.add( dtBean );
					
				}

				// TODO : Dooan If Check
				String opType = formData.get("OP_TYPE"); //1 : DEVELOP / 2 : QUALITY / 3 : REAL
				Constant.setActionType(opType);
				
				LOGGER.info("Doosan Server Info");
				LOGGER.info("IP : " + Constant.getServerInfo());
				LOGGER.info("OP_TYPE : " + Constant.getActionType());
				
				DoosanInterfaceService sample = new DoosanInterfaceService();
				rValue = sample.doService( ifBean );	// TODO : 테스트 후 주석 제거
				
				
				if( rValue != null && rValue.equals("S")){
					if(formData.get("st_sys_type").equals("WMS")||formData.get("st_sys_type").equals("WMS_GR_IK")){
						
						_updateMap.put("st_warehouse_code", formData.get("st_warehouse_code"));
						_updateMap.put("buyer", st_ivk_list.get(i).split("@@")[0]);
						_updateMap.put("ik_no", st_ivk_list.get(i).split("@@")[1]);
						updateIvhd2(_updateMap);
					}else{
						//result = updateIvdt( buyer, ik_no);    //wms는 해당 없으니 다른 곳에서 구현
					}
				}else{
					//오류처리.
				}
				
				
			}
			
		}//end if WMS_GR_IK
		else if("WMS".equals(formData.get("st_sys_type"))){
			
			_pWMSInvHdList = sqlSessionTemplate.selectList("master.wmgr.getWMSInvHdList", formData);
			_pWMSInvDtList= sqlSessionTemplate.selectList("master.wmgr.getWMSInvDtList", formData);
			
			String rValue = "";
			HeaderBean hdBean = new HeaderBean();
			List<DetailBean> dtList = new ArrayList<DetailBean>();
			InterfaceBean ifBean = new InterfaceBean();	 
			
			_hdMap = _pWMSInvHdList.get(0);
			
			hdBean.setSYS_GUBN(_hdMap.get("SYS_GUBUN")); 
			hdBean.setBARCD_NO(_hdMap.get("BARCD_NO")); 
			hdBean.setMAN_EMPNO(_hdMap.get("MAN_EMPNO"));
			hdBean.setMAN_EMPNM(_hdMap.get("MAN_EMPNM"));
			hdBean.setREQ_DPTCD(_hdMap.get("REQ_DPTCD"));
			hdBean.setREQ_DPTNM(_hdMap.get("REQ_DPTNM"));
			hdBean.setREQ_DATE(_hdMap.get("REQ_DATE")); 
			hdBean.setINCOMP_NM(_hdMap.get("INCOMP_NM"));
			hdBean.setINCOMP_NO(_hdMap.get("INCOMP_NO"));
			hdBean.setSTATUS(_hdMap.get("STATUS"));
			hdBean.setCARRYIN_NO(_hdMap.get("CARRYIN_NO"));
			hdBean.setCHECK_GB(_hdMap.get("CHECK_GB"));

			ifBean.setHeaderBean( hdBean ); 
			
			for(int j= 0 ; j<_pWMSInvDtList.size() ;j++){
				
				DetailBean		dtBean	=	new DetailBean();
				
				_dtMap = _pWMSInvDtList.get(j);
				
				dtBean.setBARCD_NO(_dtMap.get("BARCD_NO_D").toString()); 	
				dtBean.setITEM(_dtMap.get("ITEM").toString());	 	
				dtBean.setITEM_NM(_dtMap.get("ITEM_NM").toString()); 	
				dtBean.setQTY(  ((BigDecimal)_dtMap.get("QTY")).toString()); 		
				dtBean.setUNIT(_dtMap.get("UNIT").toString());
				dtBean.setBIGO(_dtMap.get("BIGO").toString());
				dtBean.setPERIOD_DATE(_dtMap.get("PERIOD_DATE").toString()); 
				dtBean.setINAREA(_dtMap.get("INAREA").toString()); 		
				
				
				dtList.add( dtBean );
				
			}

			// TODO : Dooan If Check
			String opType	= formData.get("OP_TYPE");	//1 : DEVELOP / 2 : QUALITY / 3 : REAL
			Constant.setActionType(opType);
			
			LOGGER.info("Doosan Server Info");
			LOGGER.info("IP : " + Constant.getServerInfo());
			LOGGER.info("OP_TYPE : " + Constant.getActionType());
			
			ifBean.setDetailBeanList( dtList ); 
			DoosanInterfaceService sample = new DoosanInterfaceService();
     		rValue = sample.doService( ifBean );
			
			
			if( rValue != null && rValue.equals("S")){
				if(formData.get("st_sys_type").equals("WMS")||formData.get("st_sys_type").equals("WMS_GR_IK")){
					
					_updateMap.put("st_warehouse_code", formData.get("st_warehouse_code"));
					_updateMap.put("buyer", formData.get("buyer"));
					_updateMap.put("ik_no", formData.get("inv_no"));
					updateIvhd2(_updateMap);
				}else{
					//result = updateIvdt( buyer, ik_no);    //wms는 해당 없으니 다른 곳에서 구현
				}
			}else{
				//오류처리.
			}
		
		}
		
		return _rtnMsg;
	}
	
	
    public String updateIvhd2(Map<String,String> formData)  {
    	
    	int res_cnt = 0;
    	String result = ""; 
    	try{
        	res_cnt = sqlSessionTemplate.update("master.wmgr.insertMasterWmGrTrGrCreDoosanWMSIVDT", formData);
        	
    		if(res_cnt < 1){
    			throw new RuntimeException("WMSIVDT.SEND_DATE, TIME 업데이트 도중 오류 발생. warehouse_code : " + formData.get("st_warehouse_code") + ", ik_no : " + formData.get("ik_no")  + ", buyer " + formData.get("buyer"));
    		} 
        	 
    		res_cnt = sqlSessionTemplate.update("master.wmgr.insertMasterWmGrTrGrCreDoosanICOMIVHD", formData);
        	 
    		
    		if( res_cnt < 1){
    			throw new RuntimeException("ICOMIVHD.SEND_DATE, TIME 업데이트 도중 오류 발생. warehouse_code : " + formData.get("st_warehouse_code") + ", ik_no : " + formData.get("ik_no") + ", buyer " +  formData.get("buyer"));
    		}
    		
    		result = "OK";   
    		
    	}catch(Exception e){
    		
    		throw new RuntimeException();
    	}
    	
    	return result;
		
    }
	
	// 입고확정
	@SuppressWarnings("unchecked")
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData) {
		
		_rtnMsg = "";
		String _osCheck = System.getProperty("os.name").toLowerCase();
		String hub_orderno = "";
		String hub_yn = "N";
		
		List<Map<String ,String>> _checkGr = new ArrayList<Map<String,String>>();
		
		try{
			for(int i=0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));
				
				if(formData.get("HUB_YN").equals("Y")){
					if(hub_yn.equals("N")) {
						//송장번호 생성을 위한 조회 
						List<Map<String,Object>> _rtnListorderno = sqlSessionTemplate.selectList("master.wmgr.selectMasterWmGrTrGrCreHubORDERNO", formData);
						
						//현재 Company 코드에 해당하는 type의 코드가 존재하지 않는 경우 새로 번호를 생성한다.
						if(_rtnListorderno.size() != 1){
							sqlSessionTemplate.update("master.wmgr.insertMasterWmGrTrGrCreHubIcomsqmt", formData);
			                int year_num = Calendar.getInstance().get(Calendar.YEAR);
			                String year_str = String.valueOf(year_num);
			                hub_orderno = "IH" + year_str.substring(2,4) + "000001";
						}else{
							sqlSessionTemplate.update("master.wmgr.updateMasterWmGrTrGrCreHubIcomsqmt", formData);
							hub_orderno = _rtnListorderno.get(0).get("ORDERNO").toString();
						}
					}
					
					hub_yn = "Y";
					
					formData.put("hub_orderno", hub_orderno);
					
					// ICOMIVDT.HUB_FLAG 변경
					formData.put("HUB_FLAG", "G");
					sqlSessionTemplate.update("master.wmgr.updateMasterWmGrTrGrCreHubIcomivdt", formData);
					// HUBIVDT 생성
					sqlSessionTemplate.update("master.wmgr.insertMasterWmGrTrGrCreHub", formData);
				}else{
					//입고수량을 체크하여 있을경우 불가 처리 
					if(_osCheck.indexOf("win") >= 0){
						_checkGr = sqlSessionTemplate.selectList("master.wmgr.insertMasterWmGrTrGrCreWMS_GR_QTY", formData);
						
						if(_checkGr.size() >0 ){
							_rtnMsg = "existStock@@"+formData.get("INV_NO");
							return _rtnMsg;
						}
					}
					
					sqlSessionTemplate.update("master.wmgr.insertMasterWmGrTrGrCre", formData);
				}
			}
		} catch (Exception e){
			LOGGER.error("SQL ERROR : ", e);
			_rtnMsg = "저장에 실패하였습니다.";
			throw new RuntimeException("저장에 실패하였습니다.");
		}
		return _rtnMsg;
	}
	@SuppressWarnings("unchecked")
	public String updateSelectedData_v2(Map<String,String>  formData, List<Object> gridData) {
		
		_rtnMsg = "";
		String _osCheck = System.getProperty("os.name").toLowerCase();
		String hub_orderno = "";
		String hub_yn = "N";
		
		List<Map<String ,String>> _checkGr = new ArrayList<Map<String,String>>();
		
		try{
			for(int i=0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));
				
				if(formData.get("HUB_YN").equals("Y")){
					if(hub_yn.equals("N")) {
						//송장번호 생성을 위한 조회 
						List<Map<String,Object>> _rtnListorderno = sqlSessionTemplate.selectList("master.wmgr.selectMasterWmGrTrGrCreHubORDERNO", formData);
						
						//현재 Company 코드에 해당하는 type의 코드가 존재하지 않는 경우 새로 번호를 생성한다.
						if(_rtnListorderno.size() != 1){
							sqlSessionTemplate.update("master.wmgr.insertMasterWmGrTrGrCreHubIcomsqmt", formData);
			                int year_num = Calendar.getInstance().get(Calendar.YEAR);
			                String year_str = String.valueOf(year_num);
			                hub_orderno = "IH" + year_str.substring(2,4) + "000001";
						}else{
							sqlSessionTemplate.update("master.wmgr.updateMasterWmGrTrGrCreHubIcomsqmt", formData);
							hub_orderno = _rtnListorderno.get(0).get("ORDERNO").toString();
						}
					}
					
					hub_yn = "Y";
					
					formData.put("hub_orderno", hub_orderno);
					
					// ICOMIVDT.HUB_FLAG 변경 / DELIVERY_DATE 도 업데이트
					formData.put("HUB_FLAG", "G");
					sqlSessionTemplate.update("master.wmgr.updateMasterWmGrTrGrCreHubIcomivdt_v2", formData);
					// HUBIVDT 생성
					sqlSessionTemplate.update("master.wmgr.insertMasterWmGrTrGrCreHub", formData);
				}else{
					//입고수량을 체크하여 있을경우 불가 처리 
					if(_osCheck.indexOf("win") >= 0){
						_checkGr = sqlSessionTemplate.selectList("master.wmgr.insertMasterWmGrTrGrCreWMS_GR_QTY", formData);
						
						if(_checkGr.size() >0 ){
							_rtnMsg = "existStock@@"+formData.get("INV_NO");
							return _rtnMsg;
						}
					}
					
					int hubIvdtCheck = sqlSessionTemplate.selectOne("master.wmgr.getMasterWmGrTrCreHubIvdtCount_v2", formData);
					if(hubIvdtCheck == 0) { //순수입고센터
						sqlSessionTemplate.update("master.wmgr.insertMasterWmGrTrGrCre_v2", formData);
					}else {//간선 도착센터
						sqlSessionTemplate.update("master.wmgr.insertMasterWmGrTrGrCre", formData);
					}
				}
			}
		} catch (Exception e){
			LOGGER.error("SQL ERROR : ", e);
			_rtnMsg = "저장에 실패하였습니다.";
			throw new RuntimeException("저장에 실패하였습니다.");
		}
		return _rtnMsg;
	}
	
	// 삭제
	@Transactional(rollbackFor=Exception.class, propagation=Propagation.REQUIRED)
	public void saveMasterWmCoDelayPop(Map<String, String> pMap) {
		
		
		try{
				
				sqlSessionTemplate.update("master.wmgr.saveMasterWmCoDelayPop", pMap);
				LOGGER.error("deleteMasterWmGrTrGrCre 실행 완료");

		
		}catch(Exception e){
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("견적 요청에 실패하였습니다.");
		}

		
	}	

}
