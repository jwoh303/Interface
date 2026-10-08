/*=========================================================================
*Copyright(c) 2005 POSDATA
*
*@File           : CallBackFile.java
*
*@FileName       : TC receive sample program
=========================================================================*/

// 1. u-CUBE package 선언
import com.posdata.eai.adapter.EAIHandler;
import com.posdata.eai.adapter.IAdapterDataListener;

public class CallBackFile 
{
    
    private int m_i = 0;

    public CallBackFile()
    {
   
    }

    public static void main(String[] args)
    {

        String configFilePath = null;
        int returnValue = 0;
        
        CallBackFile recv = new CallBackFile();
        EAIHandler eaiHandler = new EAIHandler();
        
        try
        {
        	// Set config file path
        	configFilePath = "C:\\uCUBE\\service\\file\\config\\cfg\\RECEIVE.xml";
        	
        	/* 1. Data 수신 이벤트 감지를 위한 Listener 등록 */
        	eaiHandler.registerDataListener(new UserAppProc());        
        	
        	/* 2. initialize() */
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
                        
            
        } catch (Exception ex)
        {
            ex.printStackTrace();            
        }
        
    }

}

class UserAppProc implements IAdapterDataListener
{
    public int onData(String ifid, String recvData, int result)
    {
        System.out.println("수신 FILE [" + recvData + "]");
        return 0;
    }
}