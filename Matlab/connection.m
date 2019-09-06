function [ obj1 , obj2 ] = connection(id1, id2)

% Find a VISA-USB object.
obj1 = instrfind('Type', 'visa-usb', 'RsrcName', id1, 'Tag', '');

% Create the VISA-USB object if it does not exist
% otherwise use the object that was found.
if isempty(obj1)
    obj1 = visa('AGILENT', id1);
else
    fclose(obj1);
    obj1 = obj1(1);
end

% Disconnect from instrument object, obj1.
fclose(obj1);

% Connect to instrument object, obj1.
fopen(obj1);

    
% Find a VISA-USB object.
obj2 = instrfind('Type', 'visa-usb', 'RsrcName', id2, 'Tag', '');

% Create the VISA-USB object if it does not exist
% otherwise use the object that was found.
if isempty(obj2)
    obj2 = visa('AGILENT', id2);
else
    fclose(obj2);
    obj1 = obj2(1);
end

% Disconnect from instrument object, obj1.
fclose(obj2);

% Connect to instrument object, obj1.
fopen(obj2);



    
end

