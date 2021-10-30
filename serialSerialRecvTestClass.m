%% otto serial receive write/read test
%  Only test receiving from ESP32
clear;

% Initialize UART Port
portName = "COM4";
uart = UartChannel(portName, 115200);

fprintf("Connecting to %s\n", portName);

while true
    % Create packet instance
    receiveData = SensorPacket();
    receiveData = uart.read(receiveData);

    fprintf("LeftV: %.4f, RightV: %.4f, LeftAngle: %.4f, RightAngle: %.4f, YAW/PITCH/ROLL: %.4f/%.4f/%.4f Time: %ld, CRC: %u\n", ...
            receiveData.omega_left,receiveData.omega_right,... 
            receiveData.theta_left, receiveData.theta_right,...
            receiveData.yaw, receiveData.pitch, receiveData.roll,... 
            receiveData.time, receiveData.crc32);
end