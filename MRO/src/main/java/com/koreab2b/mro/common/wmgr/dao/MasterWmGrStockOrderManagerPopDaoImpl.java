package com.koreab2b.mro.common.wmgr.dao;

import java.math.BigDecimal;
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

import com.koreab2b.mro.master.wmgr.dao.MasterWmGrStockGrCreDaoImpl;
import com.koreab2b.mro.util.CommonUtil;

@Repository("masterWmGrStockOrderManagerPopDao")
@Transactional
public class MasterWmGrStockOrderManagerPopDaoImpl implements MasterWmGrStockOrderManagerPopDao {
	private static final Logger logger = LoggerFactory.getLogger(MasterWmGrStockGrCreDaoImpl.class);
	private String _rtnMsg = "";
	
	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	// 조회
	public List<Map<String,String>> selectList(Map<String,Object> formData) {
		return sqlSessionTemplate.selectList("common.wmgr.selectMasterWmGrStockOrderManagerPopList", formData);
	}
	
	// 팝업조회
	public List<Map<String,String>> selectPop(Map<String,String> formData) {
		return sqlSessionTemplate.selectList("common.wmgr.selectMasterWmGrStockOrderManagerPop", formData);
	}
	
	//단가변경
	// 저장
	@SuppressWarnings("unchecked")
	@Transactional
	public String deleteMasterWmGrStockOrderManagerPopPriceChange(Map<String,String>  formData, List<Object> gridData) {
		_rtnMsg = "저장완료.";
		String strPrNo = "";
		for(int j= 0 ; j<gridData.size() ; j++)
		{
			formData.putAll((Map<String,String>)gridData.get(j));
			sqlSessionTemplate.update("common.wmgr.deleteMasterWmGrStockOrderManagerPopPriceChange", formData);
			sqlSessionTemplate.update("common.wmgr.deleteMasterWmGrStockOrderManagerPopPriceChange2", formData);
			sqlSessionTemplate.update("common.wmgr.deleteMasterWmGrStockOrderManagerPopPriceChange4", formData);
			sqlSessionTemplate.update("common.wmgr.deleteMasterWmGrStockOrderManagerPopPriceChange4", formData);
			sqlSessionTemplate.update("common.wmgr.deleteMasterWmGrStockOrderManagerPopPriceChange5", formData);
			strPrNo = formData.get("PR_NO");
		}
		formData.put("st_pr_no", strPrNo );
		sqlSessionTemplate.update("common.wmgr.deleteMasterWmGrStockOrderManagerPopPriceChange6", formData);
		
		sqlSessionTemplate.update("common.wmgr.deleteMasterWmGrStockOrderManagerPopPriceChange7", formData);
		return _rtnMsg;
	}
	
	
	//공급사변경
	// 저장
	@SuppressWarnings("unchecked")
	@Transactional
	public String deleteMasterWmGrStockOrderManagerPopAgentChange(Map<String,String>  formData, List<Object> gridData) {
		_rtnMsg = "저장완료.";
		
		for(int j= 0 ; j<gridData.size() ; j++)
		{
			formData.putAll((Map<String,String>)gridData.get(j));
			
			sqlSessionTemplate.update("common.wmgr.deleteMasterWmGrStockOrderManagerPopAgentChange", formData);
			sqlSessionTemplate.update("common.wmgr.deleteMasterWmGrStockOrderManagerPopAgentChange2", formData);
			sqlSessionTemplate.update("common.wmgr.deleteMasterWmGrStockOrderManagerPopAgentChange3", formData);
			sqlSessionTemplate.update("common.wmgr.deleteMasterWmGrStockOrderManagerPopAgentChange4", formData);
			sqlSessionTemplate.update("common.wmgr.deleteMasterWmGrStockOrderManagerPopAgentChange5", formData);
			sqlSessionTemplate.update("common.wmgr.deleteMasterWmGrStockOrderManagerPopAgentChange6", formData);
		}
		
		return _rtnMsg;
	}
	
	@SuppressWarnings("unchecked")
	private void delPr(Map<String,String>  formData, List<Object> gridData)
	{
		
		for(int j= 0 ; j<gridData.size() ; j++)
		{	
			formData.putAll((Map<String,String>)gridData.get(j) );
			sqlSessionTemplate.update("common.wmgr.deletetMasterWmGrStockOrderManagerPopPoICOMPRDT", formData);
			
		}
		for(int j= 0 ; j<gridData.size() ; j++)
		{
			formData.putAll((Map<String,String>)gridData.get(j) );
			List<Map<String,Object>> iCOMPRDTCountList = sqlSessionTemplate.selectList("common.wmgr.selectMasterWmGrStockOrderManagerPopICOMPRDTCount",formData);
			
			BigDecimal bigdeci = new BigDecimal(iCOMPRDTCountList.get(0).get("COUNTICOMPRDT").toString());
			BigDecimal zeroBig = new BigDecimal(0);
			if(bigdeci.equals(zeroBig))
			{
				sqlSessionTemplate.update("common.wmgr.deletetMasterWmGrStockOrderManagerPopDelPrHd", formData);
			}
		}
		
	}
	
	@SuppressWarnings("unchecked")
	private void delPoRs(Map<String,String>  formData, List<Object> gridData)
	{
		for(int j= 0 ; j<gridData.size() ; j++)
		{
			formData.putAll((Map<String,String>)gridData.get(j) );
			sqlSessionTemplate.update("common.wmgr.deletetMasterWmGrStockOrderManagerPopDelPoRs", formData);
		}
		
	}
	
	@SuppressWarnings("unchecked")
	private void delPoDt(Map<String,String>  formData, List<Object> gridData){
	
		for(int j= 0 ; j<gridData.size() ; j++)
		{
			formData.putAll((Map<String,String>)gridData.get(j) );
			sqlSessionTemplate.update("common.wmgr.deletetMasterWmGrStockOrderManagerPopDelPoDt", formData);
		}
		
		List<Map<String,String>> delPoDtCountList = sqlSessionTemplate.selectList("common.wmgr.deletetMasterWmGrStockOrderManagerPopDelPoDtCount",formData);
		formData.put("delPoDtCount",delPoDtCountList.get(0).get("countICOMPRDT"));
		sqlSessionTemplate.update("common.wmgr.deletetMasterWmGrStockOrderManagerPopDelPoHd", formData);
		
		
	}
	
	@SuppressWarnings("unchecked")
	private void delIvDtHd(Map<String,String>  formData, List<Object> gridData){
		List<Map<String,Object>> delIvDtHdList;
		Map<String,Object> _selectParam0 = new HashMap<String,Object>();
		 _selectParam0.putAll(formData);
		for(int j= 0 ; j<gridData.size() ; j++)
		{
			formData.putAll((Map<String,String>)gridData.get(j) );
			sqlSessionTemplate.update("common.wmgr.deletetMasterWmGrStockOrderManagerPopDelIvDtHd", formData);
		}
		for(int j= 0 ; j<gridData.size() ; j++)
		{
			formData.putAll((Map<String,String>)gridData.get(j) );
			delIvDtHdList = sqlSessionTemplate.selectList("common.wmgr.selecttMasterWmGrStockOrderManagerPopDelIvDtHd",formData);
			for(int i =0 ; i<delIvDtHdList.size(); i++)
			{
				_selectParam0.putAll((Map<String,Object>)delIvDtHdList.get(i));
				List<Map<String,Object>> delIvDtHdListCount = sqlSessionTemplate.selectList("common.wmgr.selecttMasterWmGrStockOrderManagerPopDelIvDtHdCount",_selectParam0);
				BigDecimal countNum = new BigDecimal(delIvDtHdListCount.get(0).get("CTN").toString());
				BigDecimal zeroTemp = new BigDecimal(0);
				if(countNum.equals(zeroTemp))
				{
					sqlSessionTemplate.update("common.wmgr.updateMasterWmGrStockOrderManagerPopICOMIVHD", _selectParam0);
				}
			}

		}

	}
	@SuppressWarnings("unchecked")
		private void delWmsIvdt(Map<String,String>  formData, List<Object> gridData)
		{
			for(int j= 0 ; j<gridData.size() ; j++)
			{
				formData.putAll((Map<String,String>)gridData.get(j) );
				sqlSessionTemplate.update("common.wmgr.updateMasterWmGrStockOrderManagerPoDelWmsIvdt", formData);
			}
			
		}
	
		@SuppressWarnings("unchecked")
		private void delGrDt(Map<String,String>  formData, List<Object> gridData)
		{
			for(int j= 0 ; j<gridData.size() ; j++)
			{
				formData.putAll((Map<String,String>)gridData.get(j) );
				sqlSessionTemplate.update("common.wmgr.updateMasterWmGrStockOrderManagerPoDelGrDt", formData);
			}
		}
		
		
		@SuppressWarnings("unchecked")
		private void delKwayOrder(Map<String,String>  formData, List<Object> gridData)
		{
			for(int j= 0 ; j<gridData.size() ; j++)
			{
				formData.putAll((Map<String,String>)gridData.get(j) );
				//delKwayOrder
				sqlSessionTemplate.update("common.wmgr.updateMasterWmGrStockOrderManagerPoKwayOrderDetail", formData);
				
				sqlSessionTemplate.update("common.wmgr.updateMasterWmGrStockOrderManagerPoKwayOrder", formData);
			}
		}
		
		
		@SuppressWarnings("unchecked")
		private String updateWmsStckForSTCK(Map<String,String>  formData, List<Map<String,String>> gridData) 
		{
			String msg = "";
			for(int j= 0 ; j<gridData.size() ; j++)
			{
				formData.putAll((Map<String,String>)gridData.get(j) );
				if("입고완료".equals(formData.get("STATUS_TEXT")))
				{
					sqlSessionTemplate.update("common.wmgr.updateMasterWmGrStockOrderManagerPoWmsStckForSTCK", formData);
					
					List<Map<String,Object>> wmsStckForSTCKCount = sqlSessionTemplate.selectList("common.wmgr.selecttMasterWmGrStockOrderManagerPoWmsStckForSTCK",formData);
					BigDecimal zeroBig = new BigDecimal(0);
					BigDecimal tempCount = new BigDecimal(wmsStckForSTCKCount.get(0).get("AVAIL_QTY").toString());
					if(tempCount.compareTo(zeroBig) ==-1)
					{
						_rtnMsg = "재고 수량부족으로 삭제 할 수 없습니다";

					}
				}
				else if("입고예정".equals(formData.get("STATUS_TEXT")))
				{
					sqlSessionTemplate.update("common.wmgr.updateMasterWmGrStockOrderManagerPoWmsStckForSTCK2", formData);
				}
				else if("발주".equals(formData.get("STATUS_TEXT")))
				{
					sqlSessionTemplate.update("common.wmgr.updateMasterWmGrStockOrderManagerPoWmsStckForSTCK3", formData);
				}
			}
			return msg;
		}
	
	//발주삭제
	// 저장
	@SuppressWarnings("unchecked")
	@Transactional
	public String deleteMasterWmGrStockOrderManagerPopPoDel(Map<String,String>  formData, List<Object> gridData) {
		
		_rtnMsg = "";
		
		String wmsStckMsg = "";
		
		try{
			

			//재고인 경우
			if("STCK".equals(formData.get("GUBUN")) )
			{
				Map<String,Object> _selectParam = new HashMap<String,Object>();
				 List<String> listParam = new ArrayList<String>();
				_selectParam.putAll(formData);
				
				 for(int i=0; i<gridData.size() ; i++)
				 {
					 listParam.add(((Map<String, String>)gridData.get(i)).get("PO_SEQ"));
				 }
				_selectParam.put("listForUpdate",listParam);
				//1.발주삭제 대상정보 select 		
				List<Map<String,String>> poSeqListList  = sqlSessionTemplate.selectList("common.wmgr.selectMasterWmGrStockOrderManagerPopPoSeqList",_selectParam);
				
				//구매요청테이블(ICOMPRDT, ICOMPRHD)의 삭제처리(STATUS = 'D' 업데이트) (delPr() 호출)
				delPr( formData, gridData);
				
				//발주수주접수테이블(ICOMPORS)의 해당 발주정보 삭제(STATUS = 'D' 업데이트) 및 변경일자 업데이트 delPoRs
				delPoRs( formData, gridData);
				
				
				//발주테이블(ICOMPODT, ICOMPOHD)의 삭제처리(STATUS = 'D' 업데이트) delPoDt
				delPoDt( formData, gridData);
				
				//협력사납품테이블(ICOMIVDT, ICOMIVHD)의 해당 발주정보 삭제(STATUS = 'D' 업데이트) 및 	변경일자 갱신 
				delIvDtHd( formData, gridData);
				
				//물류납품테이블(WMSIVDT)의 해당 발주정보 삭제(STATUS = 'D' 업데이트) 및 변경일자 갱신	
				delWmsIvdt( formData, gridData);
					
				//고객사입고테이블(ICOMGRDT)의 해당 발주정보 삭제(STATUS = 'D' 업데이트) 및 변경일자 갱신					
				delGrDt( formData, gridData);
					
				if("주문".equals(formData.get("STATUS")))
				{
					delKwayOrder( formData, gridData);
				}	
					
				if(!"".equals(updateWmsStckForSTCK(formData,poSeqListList)))
				{
					throw new RuntimeException(updateWmsStckForSTCK(formData,poSeqListList));
				}
				
						
			}//재고 끝 
			else  if("VMI".equals(formData.get("GUBUN")) )
			{
				//vmi인경우 발주테이블(EDIVPODT)의 삭제처리(STATUS = 'D' 업데이트)  (delEdiPo() 호출)
				for(int i= 0 ; i<gridData.size() ; i++)
				{
					formData.putAll((Map<String,String>)gridData.get(i));
					sqlSessionTemplate.update("common.wmgr.updateMasterWmGrStockOrderManagerPoDelEdiPo", formData);
					
					
					//물류재고테이블(WMSSTCK)의 해당 발주건 입고예정재고(PRE_GR_QTY), 가용재고(AVAIL_QTY), 매출원가(STC_SELLER_PRICE) 등 차감  (updateWmsStckForVMI() 호출) 
					sqlSessionTemplate.update("common.wmgr.updateMasterWmGrStockOrderManagerPoWmsStckForVMI", formData);
					
					if("입고완료".equals(formData.get("st_STATUS")))
					{
						
						List<Map<String,Object>> wmsStckForSTCKCount  = sqlSessionTemplate.selectList("common.wmgr.selectMasterWmGrStockOrderManagerPoWmsStckForVMI", formData);
						if(wmsStckForSTCKCount.size() >0 )
						{
							BigDecimal bigDeciZero = new BigDecimal(0);
							BigDecimal bigDeciStck = new BigDecimal(wmsStckForSTCKCount.get(0).get("AVAIL_QTY").toString());
							if(bigDeciZero.compareTo(bigDeciStck) == 1)
							{
								//alert('재고 수량부족으로 삭제 할 수 없습니다')
								_rtnMsg = "재고 수량부족으로 삭제 할 수 없습니다";
								throw new RuntimeException("재고 수량부족으로 삭제 할 수 없습니다");
							}
							
						}
					}

				}
				
				// -1이면 exception 
				List<Map<String,Object>> delEdiPoCount = sqlSessionTemplate.selectList("common.wmgr.selectMasterWmGrStockOrderManagerPoDelEdiPoCount",formData);
				BigDecimal deciCount = new  BigDecimal(delEdiPoCount.get(0).get("COUNTEDIVPODT").toString());
				BigDecimal minorOne = new BigDecimal(-1);
				//비교 후 
                //-1이면 execption과  	alert('발주삭제 도중 문제가 발생했습니다.\n운영자에게 문의 하세요');
				//-1 보다 크면  발주삭제가 정상적으로 이루어 졌습니다
				//쿼리 에러면 alert('재고 수량부족으로 삭제 할 수 없습니다');
				if(deciCount.compareTo(minorOne) == 0)
				{
					_rtnMsg = "발주삭제 도중 문제가 발생했습니다. 운영자에게 문의 하세요";
					throw new RuntimeException("발주삭제 도중 문제가 발생했습니다. 운영자에게 문의 하세요");

				}else if(deciCount.compareTo(minorOne) == 1)
				{
					_rtnMsg = "발주삭제가 정상적으로 이루어 졌습니다";
					logger.debug("발주삭제 메세지:"+_rtnMsg);
				}
				
			}


		} catch (Exception e){
			logger.error("SQL ERROR : ", e);
			    _rtnMsg = "발주삭제 도중 문제가 발생했습니다. 운영자에게 문의 하세요";
				throw new RuntimeException("발주삭제 도중 문제가 발생했습니다. 운영자에게 문의 하세요");
		}
		return _rtnMsg;
	}
}
