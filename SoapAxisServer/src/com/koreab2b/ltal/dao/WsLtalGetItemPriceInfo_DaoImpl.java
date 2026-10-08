package com.koreab2b.ltal.dao;

import java.io.Reader;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.ibatis.common.resources.Resources;
import com.ibatis.sqlmap.client.SqlMapClient;
import com.ibatis.sqlmap.client.SqlMapClientBuilder;
import com.koreab2b.ltal.vo.ItemPriceVO;
import com.koreab2b.ltal.vo.RequestVO;

@SuppressWarnings("unchecked")
public class WsLtalGetItemPriceInfo_DaoImpl implements WsLtalGetItemPriceInfo_Dao {

	private Logger log	= Logger.getLogger(this.getClass().getName());
	private SqlMapClient sqlMapper;
	
	public WsLtalGetItemPriceInfo_DaoImpl() {
		try {
			Reader reader = Resources.getResourceAsReader("conf/SqlMapConfig.xml");
			this.sqlMapper = SqlMapClientBuilder.buildSqlMapClient(reader);
		} catch (Exception e) {
		    log.error(e.getMessage());
		    throw new RuntimeException("Something bad happened while building the SqlMapClient instance." + e, e);
		}
	}
	
	@Override
	public List<ItemPriceVO> getItemPriceInfo(RequestVO requestVO) throws Exception{
		List<ItemPriceVO> retList = new ArrayList<ItemPriceVO>();
		
		List<Map<String,String>> sendList = new ArrayList<Map<String,String>>();
		
		try {
			this.sqlMapper.startTransaction();
			
			/*전송 대상건 select max 30*/
			sendList = this.sqlMapper.queryForList("getItemPriceList");
			for (int i = 0; i < sendList.size(); i++) {
				Map<String,String> iMap = sendList.get(i);
				
				try {
					ItemPriceVO vo = new ItemPriceVO(); 
					
					vo = (ItemPriceVO)this.sqlMapper.queryForObject("getItemPriceDetail",iMap);
					
					retList.add(vo);
					
					iMap.put("IF_FLAG", "Y");
					iMap.put("IF_MSG", "Success.");
					this.sqlMapper.update("updateItemPriceResult",iMap);
				} catch (Exception e) {
					iMap.put("IF_FLAG", "E");
					iMap.put("IF_MSG", e.getMessage());
					this.sqlMapper.update("updateItemPriceResult",iMap);
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
