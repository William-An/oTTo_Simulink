%% otto serial send write/read test
%  Only test sending to ESP32
clear;

% Initialize UART Port
portName = "COM4";
uart = UartChannel(portName, 115200);

fprintf("Connecting to %s\n", portName);
speed = 360;
while true
    % Create packet instance
    speed = mod(speed + 10, 720);
    commanData = CommandPacket.fromParams(speed, speed, 0, 0, 100, 400);
    uart.write(commanData);

    fprintf("LeftV: %.4f, RightV: %.4f, LeftAngle: %.4f, RightAngle: %.4f, Time: %ld, CRC: %u\n", ...
            commanData.omega_left,commanData.omega_right,... 
            commanData.theta_left, commanData.theta_right,...
            commanData.time, commanData.crc32);
    
    dt_des = 0.1; % 100 ms
    % initialize clock
    t_st = tic;
    % looping
    while toc(t_st) < dt_des
    end
end