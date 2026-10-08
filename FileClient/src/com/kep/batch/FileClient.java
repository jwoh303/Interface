package com.kep.batch;

import org.apache.log4j.Logger;

import com.kep.common.CommonProperty;
import com.kep.common.CommonUtil;
import com.kep.common.service.FileExecService;

public class FileClient {
	
	private static Logger log = Logger.getLogger(FileClient.class);

	public static void main(String[] args) {
		log.debug("FileClient Start!!!");
		try {
			if(args.length >= 2) {
				String DB_CONN	= args[0];
				String DB_TYPE	= args[1];
				
				CommonProperty.setDB_CONN(DB_CONN);	// 0: dev, 2:live
				CommonProperty.setDB_TYPE(DB_TYPE);	// KEPMP, KEPCON
				
				FileExecService service = new FileExecService();
				service.execute();
			}
		} catch (Exception e) {
			log.error(CommonUtil.printStackTraceToString(e));
		}
		log.debug("FileClient Finish!!!");
	}
}