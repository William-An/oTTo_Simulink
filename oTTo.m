function pitch = oTTo(uart, omega_left, omega_right)
    %OTTO Function for oTTo simulink interface, naive version
    %     uart: created object to uart, class of uartChannel
    %     omega_left: left motor angular velocity
    %     omega_right: right motor angular velocity
    arguments
        uart         UartChannel
        omega_left   {mustBeNumeric}
        omega_right  {mustBeNumeric}
    end
    
    % Read packet first
    % then issue command
    % TODO Might need threading
    sensorData = SensorPacket();
    sensorData = uart.read(sensorData);
    pitch = sensorData.pitch;
    
    commanData = CommandPacket.fromParams(omega_left, omega_right, 0, 0, 100, 400);
    uart.write(commanData);
end

