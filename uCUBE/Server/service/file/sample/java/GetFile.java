/*=========================================================================
*Copyright(c) 2005 POSDATA
*
*@File           : GetFile.java
*
*@FileName       : TC receive sample program
=========================================================================*/

// 1. u-CUBE package 선언
import com.posdata.eai.adapter.EAIHandler;

public class GetFile 
{
    
    private int m_i = 0;

    public GetFile()
    {
   
    }

    public static void main(String[] args)
    {
        String recvData = null;
        String ifid = null;
        String configFilePath = null;
        int recvWaitTime = 60000;     // mili-Seconds.
        boolean flag = true;
        int returnValue = 0;
        
        GetFile recv = new GetFile();
        EAIHandler eaiHandler = new EAIHandler();
        
        try
        {
        	// Set config file path
        	configFilePath = "C:\\uCUBE\\service\\file\\config\\cfg\\RECEIVE_GET.xml";
        	
        	//initialize UCUBE
            returnValue = eaiHandler.initialize(configFilePath);
            if (returnValue == 0)
            {
                System.out.println("u-CUBE Engine과의 연결이 성공했습니다.");
            }
            else
            {
                System.out.println("u-CUBE Engine과의 연결을 실패했습니다. 결과=" + returnValue);
                System.exit(returnValue);
            }
            
            while(flag)
            {
            	/* Try receive Data from Server. */
                returnValue = eaiHandler.receiveData(recvWaitTime);   
                recvData = eaiHandler.getReceiveData();
                ifid = eaiHandler.getReceiveIFD();

                switch(returnValue) 
                {
                    case 0 :
                            System.out.println("수신 DATA=" + recvData);
                            
                            //commit tc from Queue
                            eaiHandler.HandleReturnValue(0);
                            
                            break;         
                    case -5 :
                            System.out.println("수신호출 Timeout 발생. 재호출이 필요합니다.");
                            break;
                    case -12 :
                            System.out.println("연결 재시도 중입니다.");
                            Thread.sleep(10000);
                            break;
                    default :
                            System.out.println("CFG, IFD 설정 이상이 있습니다. 확인이 필요합니다. 결과=" + returnValue);
                            flag = false;
                            break;
                }
            } // end of while
            
        } catch (Exception ex)
        {
            ex.printStackTrace();            
        }
        
        System.exit(returnValue);
    }

}
