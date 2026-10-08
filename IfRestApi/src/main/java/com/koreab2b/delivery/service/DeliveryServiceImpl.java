/**
 * 
 */
package com.koreab2b.delivery.service;

import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.delivery.dao.DeliveryDao;

/**
 * @author jiwon
 *
 */
@Service("deliveryService")
public class DeliveryServiceImpl implements DeliveryService {
	
	private static final Logger LOGGER = LoggerFactory.getLogger(DeliveryServiceImpl.class);

	@Autowired
	private DeliveryDao deliveryDao;
	
	public String insertDeliveryResult(Map<String, Object> data) throws Exception {
		return deliveryDao.insertDeliveryResult(data);
	}

	public String updateParcelSign(Map<String, Object> data) throws Exception {
		return deliveryDao.updateParcelSign(data);		
	}
	
	public String updateParcelSignCp(Map<String, Object> data) throws Exception {
		return deliveryDao.updateParcelSignCp(data);		
	}

}
