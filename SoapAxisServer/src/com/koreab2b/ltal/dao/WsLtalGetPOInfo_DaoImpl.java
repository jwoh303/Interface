package com.koreab2b.ltal.dao;

import java.io.Reader;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.ibatis.common.resources.Resources;
import com.ibatis.sqlmap.client.SqlMapClient;
import com.ibatis.sqlmap.client.SqlMapClientBuilder;
import com.koreab2b.ltal.vo.PurchaseOrderHeaderVO;
import com.koreab2b.ltal.vo.PurchaseOrderVO;
import com.koreab2b.ltal.vo.RequestVO;

@SuppressWarnings("unchecked")
public class WsLtalGetPOInfo_DaoImpl implements WsLtalGetPOInfo_Dao {

	private Logger log	= Logger.getLogger(this.getClass().getName());
	private SqlMapClient sqlMapper;
	
	public WsLtalGetPOInfo_DaoImpl() {
		try {
			Reader reader = Resources.getResourceAsReader("conf/SqlMapConfig.xml");
			this.sqlMapper = SqlMapClientBuilder.buildSqlMapClient(reader);
		} catch (Exception e) {
		    log.error(e.getMessage());
		    throw new RuntimeException("Something bad happened while building the SqlMapClient instance." + e, e);
		}
	}
	
	@Override
	public List<PurchaseOrderVO> getPoInfo(RequestVO requestVO) throws Exception{
		List<PurchaseOrderVO> retList = new ArrayList<PurchaseOrderVO>();
		
		List<Map<String,String>> sendList = new ArrayList<Map<String,String>>();
		
		try {
			this.sqlMapper.startTransaction();
			
			/*전송 대상건 select max 30*/
			sendList = this.sqlMapper.queryForList("getPurchaseOrderList");
			log.debug("sendListSize : "+sendList.size());
			for (int i = 0; i < sendList.size(); i++) {
				PurchaseOrderVO vo = new PurchaseOrderVO();
				vo.setPoHeader((PurchaseOrderHeaderVO) this.sqlMapper.queryForObject("getPurchaseOrderHeader",sendList.get(i)));
				vo.setPoItemList(this.sqlMapper.queryForList("getPurchaseOrderDataList",sendList.get(i)));
				retList.add(vo);
				this.sqlMapper.update("updatePurchaseOrderList",sendList.get(i));
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
