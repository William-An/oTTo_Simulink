%% otto serial write/read test

command_packet_struct = ["uint32",  % Header
                         "single",  % LeftAngularVelo
                         "single",	% RightAngularVelo
                         "single",  % angleRotatedLeftMotor
                         "single",  % angleRotatedRightMotor
                         "uint64",  % timestamp
                         "uint32"]; % CRC
                    
sensor_packet_struct = ["uint32",	% Header
                        "single",   % LeftAngularVelo
                        "single",	% RightAngularVelo
                        "single",   % angleRotatedLeftMotor
                        "single",   % angleRotatedRightMotor
                        "single",   % yaw
                        "single",   % pitch
                        "single",   % roll
                        "uint64",   % timestamp
                        "uint32"];  % CRC

portName = "COM4";

% Poll the serial port until a header is reached
magicHeader = 0x92384233;

% Create serial port object
% TODO Define callback function for the serial port, data reading?
try
    port = serialport(portName, 115200);
catch err
    fprintf("%s: %s\n", err.identifier, err.message);
end
% Self loop send/receive test
%dummyData = [magicHeader, 2.0, 4.0, 6.0, 8.0, 11.0, 12.0, 13.14, 12134, 12312313];
%sensor_packet_size = length(dummyData);

% Send
%for i = 1:sensor_packet_size
%    write(port, dummyData(i), sensor_packet_struct(i));
%end


% Receive
while true
    % Scan for header, assume little-endian
    % breakdown header
    magicHeaderParts = [0x33, 0x42, 0x38, 0x92];
    index = 1;
    while index <= 4
        tmp = read(port, 1, "uint8");
        if tmp == magicHeaderParts(index)
            % Match current, check next
            index = index + 1;
        elseif tmp == magicHeaderParts(1)
            % Potential restart
            index = 2;
        else
            % Reset
            index = 1;
            fprintf("[!] Reset header counter\n");
        end
    end
    
    command_packet_size = length(command_packet_struct);
    buffer = zeros(1, command_packet_size);
    buffer(1) = magicHeader;
    for i = 2:command_packet_size
        buffer(i) = read(port, 1, command_packet_struct(i));
    end

    fprintf("LeftV: %.4f, RightV: %.4f, LeftAngle: %.4f, RightAngle: %.4f, Time: %ld, CRC: %u\n", ...
            buffer(2), buffer(3), buffer(4), buffer(5), buffer(6), buffer(7));
end