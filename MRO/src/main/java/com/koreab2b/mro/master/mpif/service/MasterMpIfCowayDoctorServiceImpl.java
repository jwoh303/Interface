/**
 * 
 */
package com.koreab2b.mro.master.mpif.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.master.mpif.dao.MasterMpIfCowayDoctorDao;

/**
 * @author jinsoo97
 *
 */
@Service("masterMpIfCowayDoctorService")
public class MasterMpIfCowayDoctorServiceImpl implements MasterMpIfCowayDoctorService {

	@Autowired
	private MasterMpIfCowayDoctorDao masterMpIfCowayDoctorDao;

	@Override
	public List<Map<String, String>> getDoctorAsList(Map<String, Object> pMap) {
		return masterMpIfCowayDoctorDao.selectCowayDoctorAsList(pMap);
	}

	@Override
	public String delMasterMpIfCowayDoctorAsList(List<Object> pGridData) {
		return masterMpIfCowayDoctorDao.deleteMasterMpIfCowayDoctorAsList(pGridData);
	}

	@Override
	public String batchMasterMpIfCowayDoctorAsList(List<Object> pGridData) {
		return masterMpIfCowayDoctorDao.insertMasterMpIfCowayDoctorAsList(pGridData);
	}

	@Override
	public String sendMasterMpIfCowayDoctorAsList(List<Object> pGridData) {
		return masterMpIfCowayDoctorDao.sendMasterMpIfCowayDoctorAsList(pGridData);
	}

	@Override
	public String saveMasterMpIfCowayDoctorAsList(List<Object> pGridData) {
		return masterMpIfCowayDoctorDao.saveMasterMpIfCowayDoctorAsList(pGridData);
	}

}
