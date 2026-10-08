/**
 * 
 */
package com.koreab2b.hugel.dao;

import java.io.Reader;
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

/**
 * @author jiwon
 *
 */
@Repository("hugelDao")
@Transactional
public class HugelDaoImpl implements HugelDao {
	private static final Logger LOGGER = LoggerFactory.getLogger(HugelDaoImpl.class);
	private SqlMapClient sqlMapper;	
	private String _rtnMsg = "";
	
	
	public HugelDaoImpl() {
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
			LOGGER.error("####### HugelDaoImpl Error : "+ e.getMessage());
			throw new RuntimeException("Something bad happened while building the SqlMapClient instance." + e, e);
		}
	}
	

	// 입고
	public String insertHugelGrData(Map<String, Object> grData) throws Exception{
		List<Map<String, Object>> itemLst = (List<Map<String, Object>>) grData.get("IF_GRDT"); 
				 
		String _rtnMsg = "입고 등록이 정상적으로 완료되었습니다.";
		
		try{
			for(Map<String,Object> item : itemLst) {
				if(item.get("LEGACY_PO_NO") == null || "".equals(item.get("LEGACY_PO_NO")) || item.get("LEGACY_PO_SEQ") == null || "".equals(item.get("LEGACY_PO_SEQ"))
						|| item.get("LEGACY_GR_NO") == null || "".equals(item.get("LEGACY_GR_NO")) || item.get("LEGACY_GR_SEQ") == null || "".equals(item.get("LEGACY_GR_SEQ"))) {
					_rtnMsg = "필수 값이 존재하지 않습니다.";
				}
				this.sqlMapper.insert("insertHugelGrData", item);
			}
			
			LOGGER.info("####### HugelDaoImpl 입고 데이터 저장완료 : ");
		}catch(Exception e){
			throw new Exception(e);
		}
		return _rtnMsg;
	}
		
}
