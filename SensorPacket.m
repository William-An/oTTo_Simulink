%% Sensor packet class
classdef SensorPacket
    properties (Constant)
        % Header bytes
        headerBytes = [0x33, 0x42, 0x38, 0x92];
    end
    
    properties
        omega_left  {mustBeNumeric}
        omega_right {mustBeNumeric}
        theta_left  {mustBeNumeric}
        theta_right {mustBeNumeric}
        time        {mustBeNumeric}
        crc32
        struct_map  = [ "uint32",	% Header
                        "single",   % LeftAngularVelo
                        "single",	% RightAngularVelo
                        "single",   % angleRotatedLeftMotor
                        "single",   % angleRotatedRightMotor
                        "single",   % yaw
                        "single",   % pitch
                        "single",   % roll
                        "uint64",   % timestamp
                        "uint32"];  % CRC
    end
    methods
        function obj = SensorPacket()
            % TODO Calculate CRC32?
            obj.omega_left  = 0;
            obj.omega_right = 0;
            obj.theta_left  = 0;
            obj.theta_right = 0;
            obj.time        = 0;
            obj.crc32       = 0;
        end
        
        function obj = SensorPacketFromParams(obj, omega_left, omega_right, theta_left, theta_right, time, crc32)
            % TODO Calculate CRC32?
            obj.omega_left  = omega_left;
            obj.omega_right = omega_right;
            obj.theta_left  = theta_left;
            obj.theta_right = theta_right;
            obj.time        = time;
            obj.crc32       = crc32;
        end

        function obj = SensorPacketFromArray(obj, array)
            % TODO Calculate CRC32?
            obj.omega_left  = array(1);
            obj.omega_right = array(2);
            obj.theta_left  = array(3);
            obj.theta_right = array(4);
            obj.time        = array(5);
            obj.crc32       = array(6);
        end

        function calculateCRC(obj)
            % TODO add CRC algo here and check for match?
        end
    end
end