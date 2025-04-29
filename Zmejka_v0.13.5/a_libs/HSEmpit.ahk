CheckServices(h, s)
{
    If !ProcessExist("hydra_service.exe") || !ProcessExist("smpd.exe")
    {
        If FileExist(h) && FileExist(s)
        {
            ToolTip, Стравливаем SMPD и HYDRA_SERVICE
            sleep, 1000
            
            Run, "%install_services_run%"
            sleep, 1000
            
            ToolTip
        }
        Else
            MsgBox, 4160,, SMPDEXE и HYDRAEXE не обнаружены, Скачайте полный дистрибутив ZmejkaFDS
    }
}

ProcessExist(process_name)
{
    Process, Exist, %process_name%
    return ErrorLevel
}