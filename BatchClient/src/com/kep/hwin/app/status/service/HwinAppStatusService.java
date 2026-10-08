package com.kep.hwin.app.status.service;

import com.stw.kep.ws.service.M2KEP0002M2016.T_APPR_STATUS_IN_STEP;

public interface HwinAppStatusService {

	public void execute();

	public boolean approval(T_APPR_STATUS_IN_STEP pItem) throws Exception;
}
