classdef (Abstract) Packet
    % Abstract class for UART Packet
    properties (Abstract)
        struct_map;
    end
    
    methods (Static)
        % Construct class from param fields
        obj = fromParams();
        
        % Deserialized array and put in class fields
        obj = fromArray(array);
    end
    
    methods
        % TODO Move this up to this class?
        calculateCRC(obj);
        
        % Return serialized packet fields
        serialized = toArray(obj);
    end
end

