%% otto serial send write/read test
%  Only test sending to ESP32
clear;

% Initialize UART Port
portName = "COM4";
uart = UartChannel(portName, 115200);

fprintf("Connecting to %s\n", portName);
speed = 10;
% TODO Uart receiver Only heard the first few packets after uart object
% created, causing issue
while true
    % Create packet instance
    speed = speed + 10;
    commandData = CommandPacket.fromParams(speed, speed, 0, 0, 100, 400);
    uart.write(commandData);

    fprintf("LeftV: %.4f, RightV: %.4f, LeftAngle: %.4f, RightAngle: %.4f, Time: %ld, CRC: %u\n", ...
            commandData.omega_left,commandData.omega_right,... 
            commandData.theta_left, commandData.theta_right,...
            commandData.time, commandData.crc32);
    
    dt_des = 0.01; % 100 ms
    % initialize clock
    t_st = tic;
    % looping
    while toc(t_st) < dt_des
    end
end