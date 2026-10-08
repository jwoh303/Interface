/**
 * 
 */
package com.koreab2b.delivery.dao;

import java.io.Reader;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.io.Resources;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.ibatis.sqlmap.client.SqlMapClient;
import com.ibatis.sqlmap.client.SqlMapClientBuilder;
import com.koreab2b.common.CommonProperty;
import com.koreab2b.common.CommonUtil;

/**
 * @author jiwon
 *
 */
@Repository("deliveryDao")
@Transactional
public class DeliveryDaoImpl implements DeliveryDao {
	private static final Logger LOGGER = LoggerFactory.getLogger(DeliveryDaoImpl.class);//	
	private SqlMapClient sqlMapper;	
	private String _rtnMsg = "";
	
	public DeliveryDaoImpl() {
		try {
			String source	= "";
			if ( "2".equals(CommonProperty.getDB_CONN()) ) {
				source	= "conf/SqlMapConfig_Live.xml";
			} else {
				source	= "conf/SqlMapConfig_Dev.xml";
			}
			Reader reader = Resources.getResourceAsReader(source);
			this.sqlMapper = SqlMapClientBuilder.buildSqlMapClient(reader);
		} catch (Exception e) {
			e.printStackTrace();
			LOGGER.error("####### DeliveryDaoImpl Error : "+ e.getMessage());
			throw new RuntimeException("Something bad happened while building the SqlMapClient instance." + e, e);
		}
	}

	public String insertDeliveryResult(Map<String, Object> data) throws Exception {		
		 
		String _rtnMsg = "";
		List<Map<String, Object>> deliTmp = new ArrayList<Map<String,Object>>();
		String olevel = (String) data.get("level");		
		try{			
			deliTmp = this.sqlMapper.queryForList("selectDeliInfo", data);
			if(deliTmp.size() < 1){
				if("6".equals(olevel)) {					
					_rtnMsg = "T";
					this.sqlMapper.update("updateDeliParamT", data);					
				}else {					
					_rtnMsg = "S";
					this.sqlMapper.update("updateDeliParamS", data);					
				}
				_rtnMsg = "Insert DT";
				this.sqlMapper.insert("insertDeliveryResult", data);
				_rtnMsg = "Success.";
			}			
			
		}catch(Exception e){
			_rtnMsg += " Fail. / "+data.toString();
			throw new Exception(e);
		}finally {			
			LOGGER.info("### KEP_PARCEL_DT 저장 :  "+ _rtnMsg);
			return _rtnMsg;
		}		
	}

	public String updateParcelSign(Map<String, Object> data) throws Exception {
		String _rtnMsg = null;		
		try {
			this.sqlMapper.update("updateParcelSign", data);	
		}catch(Exception e){
			_rtnMsg = "택배 추적 데이터 상태 변경에 실패하였습니다.";
			throw new Exception(e);
		}finally {
			return _rtnMsg;
		}		
	}
	
	public String updateParcelSignCp(Map<String, Object> data) throws Exception {
		String _rtnMsg = null;		
		try {
			this.sqlMapper.update("updateParcelSignCp", data);	
		}catch(Exception e){
			_rtnMsg = "쿠팡택배 추적 데이터 상태 변경에 실패하였습니다.";
			throw new Exception(e);
		}finally {
			return _rtnMsg;
		}		
	}
}
