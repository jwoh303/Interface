package com.koreab2b.ltal.dao;

import java.io.Reader;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.ibatis.common.resources.Resources;
import com.ibatis.sqlmap.client.SqlMapClient;
import com.ibatis.sqlmap.client.SqlMapClientBuilder;
import com.koreab2b.common.CommonUtil;
import com.koreab2b.ltal.vo.ItemVO;
import com.koreab2b.ltal.vo.RequestVO;

@SuppressWarnings("unchecked")
public class WsLtalGetItemInfo_DaoImpl implements WsLtalGetItemInfo_Dao {

	private Logger log	= Logger.getLogger(this.getClass().getName());
	private SqlMapClient sqlMapper;
	
	public WsLtalGetItemInfo_DaoImpl() {
		try {
			Reader reader = Resources.getResourceAsReader("conf/SqlMapConfig.xml");
			this.sqlMapper = SqlMapClientBuilder.buildSqlMapClient(reader);
		} catch (Exception e) {
		    log.error(e.getMessage());
		    throw new RuntimeException("Something bad happened while building the SqlMapClient instance." + e, e);
		}
	}
	
	@Override
	public List<ItemVO> getItemInfo(RequestVO requestVO) throws Exception{
		List<ItemVO> retList = new ArrayList<ItemVO>();
		
		List<Map<String,String>> sendList = new ArrayList<Map<String,String>>();
		
		try {
			this.sqlMapper.startTransaction();
			
			/*전송 대상건 select max 30*/
			sendList = this.sqlMapper.queryForList("getItemMasterList");
			log.debug("sendListSize : "+sendList.size());
			for (int i = 0; i < sendList.size(); i++) {
				Map<String,String> iMap = sendList.get(i);
				try {
					ItemVO vo = new ItemVO(); 
					
					vo = (ItemVO)this.sqlMapper.queryForObject("getItemMasterDetail",iMap);
					
					retList.add(vo);
					
					iMap.put("IF_FLAG", "T");
					iMap.put("IF_MSG", "Success.");
					this.sqlMapper.update("updateItemMasterResult",iMap);
				} catch (Exception e) {
					log.error("getItemInfo : "+ CommonUtil.printStackTraceToString(e));
					iMap.put("IF_FLAG", "E");
					iMap.put("IF_MSG", e.getMessage());
					this.sqlMapper.update("updateItemMasterResult",iMap);
				}
			}
			
			this.sqlMapper.commitTransaction();
			
		} catch (Exception e) {
			log.error(e.getMessage());
			e.printStackTrace();
		} finally {
			this.sqlMapper.endTransaction();
		}
		
		return retList;
	}
}
