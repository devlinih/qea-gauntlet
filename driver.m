pub = rospublisher('/raw_vel');

% Stop the robot if it's going right now
msg = rosmessage(pub);
msg.Data = [0, 0];
send(pub, msg);
pause(2);

% Set initial position and direction
position = [0; -2];
heading = [1; 0];

% Move neato to inital point pointed in positive i-hat direction
placeNeato(position(1), position(2), heading(1), heading(2));
pause(2);

% Constants:
wheelBase = 0.235;
lambda = 0.01;
angularSpeed = 0.2;  % radians / second (set higher than real to help with testing)
linearSpeed = 0.25;  % meters / second

% set a flag to control when we are sufficiently close to the minimum of f
shouldStop = false;

while ~shouldStop
    % get the gradient
    gradValue = approx_grad(position(1), position(2));
    % calculate the angle to turn to align the robot to the direction of
    % gradValue.
    crossProd = cross([heading; 0], [gradValue; 0]);

    % if the z-component of the crossProd vector is negative that means we
    % should be turning clockwise and if it is positive we should turn
    % counterclockwise
    turnDirection = sign(crossProd(3));

    % turn angle from the magnitude of the cross product and the angle
    % between the vectors
    turnAngle = asin(norm(crossProd)/(norm(heading)*norm(gradValue)));

    % this is how long in seconds to turn for
    turnTime = double(turnAngle) / angularSpeed;
   
    % note that we use the turnDirection here to negate the wheel speeds
    % when we should be turning clockwise instead of counterclockwise
    msg.Data = [-turnDirection*angularSpeed*wheelBase/2,
                turnDirection*angularSpeed*wheelBase/2];
    send(pub, msg);
    
    % record the start time and wait until the desired time has elapsed
    startTurn = rostic;
    while rostoc(startTurn) < turnTime
        pause(0.01);
    end
    heading = gradValue;

    % this is how far we are going to move
    forwardDistance = norm(gradValue*lambda);

    % this is how long to take to move there based on desired linear speed
    forwardTime = forwardDistance / linearSpeed;
    
    % start the robot moving
    msg.Data = [linearSpeed, linearSpeed];
    send(pub, msg);
    
    % record the start time and wait until the desired time has elapsed
    startForward = rostic;
    while rostoc(startForward) < forwardTime
        pause(0.01)
    end
    
    % update the position for the next iteration
    position = position + (gradValue*lambda);
    
    % if our step is too short, flag it so we break out of our loop
    shouldStop = forwardDistance < .01;
end

% stop the robot before exiting
msg.Data = [0, 0];
send(pub, msg);




