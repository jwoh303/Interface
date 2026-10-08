package com.koreab2b.mro.common.wmgr.dao;

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

@Repository("masterWmGrStockOrderGrRegPopDao")
@Transactional
public class MasterWmGrStockOrderGrRegPopDaoImpl implements MasterWmGrStockOrderGrRegPopDao {
	private static final Logger logger = LoggerFactory.getLogger(MasterWmGrStockGrCreDaoImpl.class);
	
	
	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	private String _rtnMsg = "";
	
	// 조회
	public List<Map<String,String>> selectList(Map<String,Object> formData) {
		return sqlSessionTemplate.selectList("common.wmgr.selectMasterWmGrStockOrderGrRegPopList", formData);
	}
	
	
	// 저장
	@SuppressWarnings("unchecked")
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData) {
		
		_rtnMsg = "";
		
		try{
			
			Map<String,Object> _selectParam = new HashMap<String,Object>();
			Map<String,Object> _insertParam = new HashMap<String,Object>();
			String _wareHousesCode = formData.get("st_warehouse_code");
			
			List<Map<String,String>> _rtnSelectForUpdate = new ArrayList<Map<String,String>>();
			List<Map<String,String>> _orderNO = new ArrayList<Map<String,String>>();
			
			
			_selectParam.putAll(formData);
			 List<String> listParam = new ArrayList<String>();
			 for(int i=0; i<gridData.size() ; i++)
			 {
				 listParam.add(((Map<String, String>)gridData.get(i)).get("IV_NO"));
			 }
			_selectParam.put("listForUpdate",listParam);
			logger.debug("selectMasterWmGrStockGrCreForUpdateList:{}"+_selectParam);
			_rtnSelectForUpdate = sqlSessionTemplate.selectList("master.wmgr.selectMasterWmGrStockGrCreForUpdatePop", _selectParam);
			
			//orderNO조회 
			_orderNO = sqlSessionTemplate.selectList("master.wmgr.selectOrderNo", formData);
			String GRNO = "";
			
			//getOrderNo가 존재하면 insert 없으면 update
			if(_orderNO.size() ==0)
			{
				GRNO = _orderNO.get(0).get("GRNO");
				sqlSessionTemplate.update("master.wmgr.insertIcomsqmt", formData);
				GRNO = "" + Calendar.getInstance().get(Calendar.YEAR);
				GRNO = "GR" + GRNO.substring(2,4) +   "000001";
			}
			else
			{
				GRNO = _orderNO.get(0).get("GRNO");
				sqlSessionTemplate.update("master.wmgr.updateIcomsqmt", formData);
			}
			
			String _strOS = System.getProperty("os.name").toLowerCase();
			List<Map<String ,String>> _checkGr = new ArrayList<Map<String,String>>();
			
			for(int i=0 ; i<_rtnSelectForUpdate.size() ; i++)
			{
//				//입고가 진행되었는지 체크 
//				if(_strOS.indexOf("win") >= 0){
//					
//					_checkGr = sqlSessionTemplate.selectList("master.wmgr.selectMasterWmGrStockGrCre_GR_QTY", formData);
//					if(_checkGr.size() >0 ){
//						
//						_rtnMsg = "existStock";
//						throw new RuntimeException("입고번호 "+formData.get("INV_NO")+"는 기 입고 대상 입니다.");
//						
//					}
//				}
				
				logger.debug("selectMasterWmGrStockGrCreForUpdateList:{}"+formData);
				formData.putAll((Map<String, String>)_rtnSelectForUpdate.get(i));	
				formData.put("GRNO",GRNO);
				formData.put("GR_SEQ", String.valueOf(i+1));
				logger.debug("insertICOMGRDT formData :{}"+formData);
				sqlSessionTemplate.update("master.wmgr.insertICOMGRDT", formData);
				
				logger.debug("updataeICOMPODT formData :{}"+formData);
				sqlSessionTemplate.update("master.wmgr.updataeICOMPODT", formData);
				
				logger.debug("updataeICOMIVDT formData :{}"+formData);
				sqlSessionTemplate.update("master.wmgr.updataeICOMIVDT", formData);
				
				logger.debug("updataeICOMIVHD formData :{}"+formData);
				sqlSessionTemplate.update("master.wmgr.updataeICOMIVHD", formData);

			}
			List<Map<String,String>> _resultInv = new ArrayList<Map<String,String>>();
			_resultInv = sqlSessionTemplate.selectList("master.wmgr.selectICOMIVDT", formData);

			sqlSessionTemplate.update("master.wmgr.updataeIICOMIVDT_WMS_GR_QTY", formData);
			
			
			for(int j= 0 ; j<_resultInv.size() ; j++)
			{
				logger.debug("updataeICOMIVDTList2 formData :{}"+formData);
				formData.putAll((Map<String, String>)_resultInv.get(j));
				 sqlSessionTemplate.update("master.wmgr.updataeICOMIVDTList2Pop", formData);
			}
			
			
		} catch (Exception e){
			if(_rtnMsg.equals("existStock")){
				throw new RuntimeException("입고번호 "+formData.get("INV_NO")+"는 기 입고 대상 입니다.");
			}else{
				logger.error("SQL ERROR : ", e);
				_rtnMsg = "재고 입고 등록에 실패 하였습니다.";
					throw new RuntimeException("저장에 실패하였습니다.");
			}
		}
		return _rtnMsg;
	}
	
}
