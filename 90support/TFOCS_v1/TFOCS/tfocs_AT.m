function [ x, out, opts ] = tfocs_AT( smoothF, affineF, projectorF, x0, opts )

% [ x, out, opts ] = tfocs_AT( smoothF, affineF, nonsmoothF, x0, opts )
%   Implements Auslender & Teboulle's method.
%   A variety of calling sequences are supported; type 
%      help tfocs_help
%   for a full explanation.

% Initialization
alg = 'AT';
algorithm = 'Auslender & Teboulle''s single-projection method';
alpha = 0; beta = 0; mu = 0; % Do not remove: necessary because of a MATLAB quirk
tfocs_initialize
if nargin == 0,	return; end

% SRB experimenting, Jan 10 2011
cntr_Ay     = 0;
cntr_Ax     = 0;
global cntr_reset
if isempty(cntr_reset) % for now, a hack
    cntr_reset  = Inf;
end
  % how often to explicitly recompute A*x and A*y (set to Inf if you want )

while true,
    
      x_old =   x;
    A_x_old = A_x;
      z_old =   z;
    A_z_old = A_z;
    
    % The backtracking loop
    L_old      = L;
   	L          = L * alpha;
    theta_old  = theta;
    while true,
        
        % Acceleration
        theta = advance_theta( theta_old, L, L_old );

		% Next iterate
        if theta < 1,
            y   = ( 1 - theta ) *   x_old + theta *   z_old;
            % SRB experimenting, Jan 10 2011
            if cntr_Ay > cntr_reset
                A_y = apply_linear( y, 1 );
                cntr_Ay = 0;
            else
                % the efficient way
                cntr_Ay = cntr_Ay + 1;
                A_y = ( 1 - theta ) * A_x_old + theta * A_z_old;
            end
            f_y = Inf; g_Ay = []; g_y = [];
        end
        
        % Compute the function value if it is not already
        if isempty( g_y ),
            if isempty( g_Ay ), [ f_y, g_Ay ] = apply_smooth( A_y ); end
            g_y = apply_linear( g_Ay, 2 );
        end
        
        % Scaled gradient
        step = 1 / ( theta * L );
        [ C_z, z ] = apply_projector( z_old - step * g_y, step );
        A_z = apply_linear( z, 1 );
        
        % New iterate
        if theta == 1,
            x   = z; 
            A_x = A_z;
            C_x = C_z;
        else
            x   = ( 1 - theta ) *   x_old + theta *   z;
            % SRB experimenting, Jan 10 2011
            if cntr_Ax > cntr_reset
                cntr_Ax = 0;
                A_x = apply_linear( x, 1 );
            else
                cntr_Ax = cntr_Ax + 1;
                A_x = ( 1 - theta ) * A_x_old + theta * A_z;
            end
            C_x = Inf;
        end
        f_x = Inf; g_Ax = []; g_x = [];
        
        % Perform backtracking tests
        tfocs_backtrack
        
    end
    
    % Collect data, evaluate stopping criteria, and print status
    tfocs_iterate
    
end

% Final processing
tfocs_cleanup

% TFOCS v1.0c by Stephen Becker, Emmanuel Candes, and Michael Grant.
% Copyright 2011 California Institute of Technology and CVX Research.
% See the file TFOCS/license.{txt,pdf} for full license information.

