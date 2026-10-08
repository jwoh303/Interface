package com.koreab2b.mro.master.wmgr.dao;

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
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.util.ResultRowHandler;

@Repository("masterWmGrStockGrCreDao")
@Transactional
public class MasterWmGrStockGrCreDaoImpl implements MasterWmGrStockGrCreDao {
	private static final Logger logger = LoggerFactory.getLogger(MasterWmGrStockGrCreDaoImpl.class);

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	private String _rtnMsg = "";
	
	// 리스트 조회
	@SuppressWarnings("unchecked")
	public List<Map<String,String>> selectList(Map<String,Object> param) {
		String pageflag = (String) param.get("pageflag");
		if("0".equals(pageflag)){
			ResultRowHandler _resultHander = new ResultRowHandler();
			List<Map<String, String>> resultList = null;
			sqlSessionTemplate.select("master.wmgr.selectMasterWmGrStockGrCreList", param, _resultHander);
			resultList = (List<Map<String, String>>)_resultHander.getList();
			return resultList;
		}else{
			
			return sqlSessionTemplate.selectList("master.wmgr.selectMasterWmGrStockGrCreList", param);
		}
		
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
			 if("Y".equals(formData.get("IV_NO_pop")))
			 {
				 listParam.add(formData.get("IV_NO"));
			 }
			 else
			 {
				 for(int i=0; i<gridData.size() ; i++)
				 {
					 listParam.add(((Map<String, String>)gridData.get(i)).get("IV_NO"));
				 }
			 }
			 	

			_selectParam.put("listForUpdate",listParam);
			logger.debug("selectMasterWmGrStockGrCreForUpdateList:{}"+_selectParam);
			_rtnSelectForUpdate = sqlSessionTemplate.selectList("master.wmgr.selectMasterWmGrStockGrCreForUpdateList", _selectParam);
			
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

				
				formData.putAll((Map<String, String>)_rtnSelectForUpdate.get(i));	
				formData.put("GRNO",GRNO);
				formData.put("GR_SEQ", String.valueOf(i+1));
				
				//입고가 진행되었는지 체크 
				if(_strOS.indexOf("win") >= 0){
					
					_checkGr = sqlSessionTemplate.selectList("master.wmgr.selectMasterWmGrStockGrCre_GR_QTY", formData);
					if(_checkGr.size() >0 ){
						
						_rtnMsg = "existStock";
						throw new RuntimeException("입고번호 "+formData.get("INV_NO")+"는 기 입고 대상 입니다.");
						
					}
				}	
				
				sqlSessionTemplate.update("master.wmgr.insertICOMGRDT", formData);
				
				sqlSessionTemplate.update("master.wmgr.updataeICOMPODT", formData);
				
				sqlSessionTemplate.update("master.wmgr.updataeICOMIVDT", formData);
				
				sqlSessionTemplate.update("master.wmgr.updataeICOMIVHD", formData);

			}
			List<Map<String,String>> _resultInv = new ArrayList<Map<String,String>>();
			
			for(int k=0; k<gridData.size(); k++){
				logger.debug("gridData.size() :{}"+gridData.size());
				formData.putAll((Map<String, String>)gridData.get(k));
				sqlSessionTemplate.update("master.wmgr.updataeICOMIVDTList", formData);
				
				logger.debug("selectICOMIVDT formData :{}"+formData);
				_resultInv = sqlSessionTemplate.selectList("master.wmgr.selectICOMIVDT", formData);
				
				logger.debug("_resultInv.size() :{}"+_resultInv.size());
				
				//updateWmsStck  updataeICOMIVDTList2
				for(int j= 0 ; j<_resultInv.size() ; j++)
				{
					logger.debug("updataeICOMIVDTList2 formData :{}"+formData);
					formData.putAll((Map<String, String>)_resultInv.get(j));
					 sqlSessionTemplate.update("master.wmgr.updataeICOMIVDTList2", formData);
				}
				
			}
		

			
			
		} catch (Exception e){
			if(_rtnMsg.equals("existStock")){
				throw new RuntimeException("입고번호 "+formData.get("INV_NO")+"는 기 입고 대상 입니다.");
			}else{
				logger.error("SQL ERROR : ", e);
				_rtnMsg = "재고 입고 등록에 실패 하였습니다.";
					throw new RuntimeException("재고 입고 등록에 실패 하였습니다.");
			}

		}
		return _rtnMsg;
	}
	
	
	// 삭제
	@SuppressWarnings("unchecked")
	@Transactional(rollbackFor=Exception.class, propagation=Propagation.REQUIRED)
	public String deleteSelectedData(Map<String,String>  formData, List<Object> gridData) {
		
		_rtnMsg = "";
		
		try{
			for(int i=0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));		
				
				sqlSessionTemplate.update("master.wmgr.deleteMasterWmGrStockGrCre", formData);
				logger.error("deleteMasterWmGrStockGrCre 실행 완료");

			}
		}catch(Exception e){
			logger.error("SQL ERROR : ", e);
			throw new RuntimeException("견적 요청에 실패하였습니다.");
		}

		return _rtnMsg;		
		
	}	
	
	

}
